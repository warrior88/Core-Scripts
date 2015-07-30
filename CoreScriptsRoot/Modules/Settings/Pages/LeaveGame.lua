--[[
		Filename: LeaveGame.lua
		Written by: jeditkacheff
		Version 1.0
		Description: Takes care of the leave game in Settings Menu
--]]


-------------- CONSTANTS -------------
local LEAVE_GAME_ACTION = "LeaveGameCancelAction"

-------------- SERVICES --------------
local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")

----------- UTILITIES --------------
local utility = require(RobloxGui.Modules.Settings.Utility)

------------ Variables -------------------
local PageInstance = nil
RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")
local isTenFootInterface = require(RobloxGui.Modules.TenFootInterface):IsEnabled()


----------- CLASS DECLARATION --------------

local function Initialize()
	local settingsPageFactory = require(RobloxGui.Modules.Settings.SettingsPageFactory)
	local this = settingsPageFactory:CreateNewPage()

	this.DontLeaveFunc = function(name, state, input)
		if this.HubRef and (not state or state == Enum.UserInputState.Begin) then
			this.HubRef:PopMenu()
		end
	end
	
	------ TAB CUSTOMIZATION -------
	this.TabHeader = nil -- no tab for this page

	------ PAGE CUSTOMIZATION -------
	this.Page.Name = "LeaveGamePage"

	local leaveGameText =  utility:Create'TextLabel'
	{
		Name = "LeaveGameText",
		Text = "Are you sure you want to leave the game?",
		Font = Enum.Font.SourceSansBold,
		FontSize = Enum.FontSize.Size36,
		TextColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,0,200),
		TextWrapped = true,
		ZIndex = 2,
		Parent = this.Page
	};
	if utility:IsSmallTouchScreen() then
		leaveGameText.FontSize = Enum.FontSize.Size24
		leaveGameText.Size = UDim2.new(1,0,0,100)
	elseif isTenFootInterface then
		leaveGameText.FontSize = Enum.FontSize.Size48
	end

	local buttonSpacing = 20
	local buttonSize = UDim2.new(0, 200, 0, 50)
	if isTenFootInterface then
		leaveGameText.Position = UDim2.new(0,0,0,100)
		buttonSize = UDim2.new(0, 300, 0, 80)
	end

	this.LeaveGameButton = utility:MakeStyledButton("LeaveGame", "Leave", buttonSize)
	this.LeaveGameButton.NextSelectionRight = nil
	this.LeaveGameButton:SetVerb("Exit")
	if utility:IsSmallTouchScreen() then
		this.LeaveGameButton.Position = UDim2.new(0.5, -buttonSize.X.Offset - buttonSpacing, 1, 0)
	else
		this.LeaveGameButton.Position = UDim2.new(0.5, -buttonSize.X.Offset - buttonSpacing, 1, -30)
	end
	this.LeaveGameButton.Parent = leaveGameText


	------------- Init ----------------------------------
	
	local dontleaveGameButton = utility:MakeStyledButton("DontLeaveGame", "Don't Leave", buttonSize, this.DontLeaveFunc)
	dontleaveGameButton.NextSelectionLeft = nil
	if utility:IsSmallTouchScreen() then
		dontleaveGameButton.Position = UDim2.new(0.5, buttonSpacing, 1, 0)
	else
		dontleaveGameButton.Position = UDim2.new(0.5, buttonSpacing, 1, -30)
	end
	dontleaveGameButton.Parent = leaveGameText

	this.Page.Size = UDim2.new(1,0,0,dontleaveGameButton.AbsolutePosition.Y + dontleaveGameButton.AbsoluteSize.Y)

	return this
end


----------- Public Facing API Additions --------------
PageInstance = Initialize()

PageInstance.Displayed.Event:connect(function()
	GuiService.SelectedCoreObject = PageInstance.LeaveGameButton
	ContextActionService:BindCoreAction(LEAVE_GAME_ACTION, PageInstance.DontLeaveFunc, false, Enum.KeyCode.ButtonB)
end)

PageInstance.Hidden.Event:connect(function()
	ContextActionService:UnbindCoreAction(LEAVE_GAME_ACTION)
end)


return PageInstance