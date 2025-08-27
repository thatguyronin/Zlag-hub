-- Create the main screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

-- Save the default walk speed
local defaultWalkSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
print("Default walk speed saved: " .. defaultWalkSpeed)

-- Create the black background at the bottom
local blackBackground = Instance.new("Frame")
blackBackground.Size = UDim2.new(1, 0, 0, 50) -- Full width, 50 pixels height
blackBackground.Position = UDim2.new(0, 0, 1, -50) -- Bottom of the screen
blackBackground.BackgroundColor3 = Color3.new(0, 0, 0) -- Black color
blackBackground.Parent = screenGui
print("Black background created")

-- Create the player's profile picture
local player = game.Players.LocalPlayer
local profilePicture = Instance.new("ImageLabel")
profilePicture.Size = UDim2.new(0, 30, 0, 30) -- 30x30 pixels
profilePicture.Position = UDim2.new(0, 10, 0, 10) -- Bottom left corner with some padding
profilePicture.BackgroundTransparency = 1 -- Make the background transparent
profilePicture.Parent = blackBackground

-- Function to set the player's thumbnail
local function setPlayerThumbnail()
    local success, thumbnail = pcall(function()
        return player:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    if success then
        profilePicture.Image = thumbnail
        print("Profile picture set")
    else
        print("Failed to set profile picture")
    end
end

setPlayerThumbnail()

-- Create the speed button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 100, 0, 30) -- 100 pixels width, 30 pixels height
speedButton.Position = UDim2.new(0, 10, 0, 10) -- Beside the profile picture with some padding
speedButton.Text = "Speed"
speedButton.TextColor3 = Color3.new(1, 0, 0) -- Red color
speedButton.TextSize = 18
speedButton.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
speedButton.BackgroundTransparency = 0.5 -- 50% transparent
speedButton.Parent = blackBackground

local isSpeedActivated = false

speedButton.MouseButton1Click:Connect(function()
    if isSpeedActivated then
        -- Deactivate speed
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = defaultWalkSpeed
        speedButton.TextColor3 = Color3.new(1, 0, 0) -- Red color
    else
        -- Activate speed
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
        speedButton.TextColor3 = Color3.new(0, 1, 0) -- Green color
    end
    isSpeedActivated = not isSpeedActivated
end)

-- Create the ESP button
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 100, 0, 30) -- 100 pixels width, 30 pixels height
espButton.Position = UDim2.new(0, 120, 0, 10) -- Beside the speed button with some padding
espButton.Text = "ESP"
espButton.TextColor3 = Color3.new(1, 0, 0) -- Red color
espButton.TextSize = 18
espButton.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
espButton.BackgroundTransparency = 0.5 -- 50% transparent
espButton.Parent = blackBackground

local isEspActivated = false
local espDrawings = {}

espButton.MouseButton1Click:Connect(function()
    isEspActivated = not isEspActivated

    if isEspActivated then
        -- Activate ESP
        espButton.TextColor3 = Color3.new(0, 1, 0) -- Green color

        -- Function to find player data dynamically
        local function findPlayerData()
            local playerData = {}
            for _, player in pairs(game.Players:GetPlayers()) do
                local character = player.Character
                if character then
                    table.insert(playerData, {
                        name = player.Name,
                        position = character.PrimaryPart.Position
                    })
                end
            end
            return playerData
        end

        -- Function to draw ESP
        local function drawESP(playerData)
            for _, drawing in pairs(espDrawings) do
                drawing.Visible = false
                drawing:Remove()
            end
            table.clear(espDrawings)

            for _, data in pairs(playerData) do
                local position = data.position
                local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(position)
                if onScreen then
                    local textObject = Drawing.new("Text")
                    textObject.Text = data.name
                    textObject.Size = 18
                    textObject.Color = Color3.new(1, 0, 0)
                    textObject.Position = Vector2.new(screenPos.X, screenPos.Y)
                    textObject.Visible = true

                    -- Store the drawing objects
                    table.insert(espDrawings, textObject)
                end
            end
        end

        -- Main loop to update ESP
        while isEspActivated do
            local playerData = findPlayerData()
            drawESP(playerData)
            wait(0.05) -- Update every 0.05 seconds (faster update interval)
        end
    else
        -- Deactivate ESP
        espButton.TextColor3 = Color3.new(1, 0, 0) -- Red color

        -- Clear all drawing objects
        for _, drawing in pairs(espDrawings) do
            drawing.Visible = false
            drawing:Remove()
        end
        table.clear(espDrawings)
    end
end)

-- Create the Fullbright button
local fullbrightButton = Instance.new("TextButton")
fullbrightButton.Size = UDim2.new(0, 100, 0, 30) -- 100 pixels width, 30 pixels height
fullbrightButton.Position = UDim2.new(0, 230, 0, 10) -- Beside the ESP button with some padding
fullbrightButton.Text = "Fullbright"
fullbrightButton.TextColor3 = Color3.new(1, 0, 0) -- Red color
fullbrightButton.TextSize = 18
fullbrightButton.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
fullbrightButton.BackgroundTransparency = 0.5 -- 50% transparent
fullbrightButton.Parent = blackBackground

local isFullbrightActivated = false

fullbrightButton.MouseButton1Click:Connect(function()
    if isFullbrightActivated then
        -- Deactivate Fullbright
        for _, light in pairs(workspace:GetChildren()) do
            if light:IsA("Light") then
                light.Brightness = 1
                light.Shadows = true
            end
        end
        game.Lighting.Ambient = Color3.new(0.2, 0.2, 0.2) -- Reset ambient light
        game.Lighting.FogEnd = 1000 -- Reset fog
        fullbrightButton.TextColor3 = Color3.new(1, 0, 0) -- Red color
    else
        -- Activate Fullbright
        for _, light in pairs(workspace:GetChildren()) do
            if light:IsA("Light") then
                light.Brightness = 10
                light.Shadows = false
            end
        end
        game.Lighting.Ambient = Color3.new(1, 1, 1) -- Set ambient light to white
        game.Lighting.FogEnd = 99999 -- Remove fog
        fullbrightButton.TextColor3 = Color3.new(0, 1, 0) -- Green color
    end
    isFullbrightActivated = not isFullbrightActivated
end)

-- Handle new players for ESP
game.Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(character)
        if isEspActivated then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.new(1, 0, 0) -- Red color
            highlight.FillTransparency = 0.5 -- 50% transparent
            highlight.Parent = character
        end
    end)
end)

-- Create the God Mode button
local godModeButton = Instance.new("TextButton")
godModeButton.Size = UDim2.new(0, 100, 0, 30) -- 100 pixels width, 30 pixels height
godModeButton.Position = UDim2.new(0, 340, 0, 10) -- Beside the Fullbright button with some padding
godModeButton.Text = "God Mode"
godModeButton.TextColor3 = Color3.new(1, 0, 0) -- Red color
godModeButton.TextSize = 18
godModeButton.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
godModeButton.BackgroundTransparency = 0.5 -- 50% transparent
godModeButton.Parent = blackBackground

local isGodModeActivated = false

godModeButton.MouseButton1Click:Connect(function()
    isGodModeActivated = not isGodModeActivated

    if isGodModeActivated then
        -- Activate God Mode
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        humanoid.Health = math.huge
        humanoid.MaxHealth = math.huge

        godModeButton.TextColor3 = Color3.new(0, 1, 0) -- Green color
    else
        -- Deactivate God Mode
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        humanoid.Health = 100
        humanoid.MaxHealth = 100

        godModeButton.TextColor3 = Color3.new(1, 0, 0) -- Red color
    end
end)

-- Create the Noclip button
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0, 100, 0, 30) -- 100 pixels width, 30 pixels height
noclipButton.Position = UDim2.new(0, 450, 0, 10) -- Beside the God Mode button with some padding
noclipButton.Text = "Noclip"
noclipButton.TextColor3 = Color3.new(1, 0, 0) -- Red color
noclipButton.TextSize = 18
noclipButton.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
noclipButton.BackgroundTransparency = 0.5 -- 50% transparent
noclipButton.Parent = blackBackground

local isNoclipActivated = false

noclipButton.MouseButton1Click:Connect(function()
    isNoclipActivated = not isNoclipActivated

    if isNoclipActivated then
        -- Activate Noclip
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        local function makePartsNoclip(part)
            part.CanCollide = false
            part.Transparency = 0.5
        end

        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                makePartsNoclip(part)
            end
        end

        character.ChildAdded:Connect(function(child)
            if child:IsA("BasePart") then
                makePartsNoclip(child)
            end
        end)

        noclipButton.TextColor3 = Color3.new(0, 1, 0) -- Green color
    else
        -- Deactivate Noclip
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        local function makePartsClip(part)
            part.CanCollide = true
            part.Transparency = 0
        end

        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                makePartsClip(part)
            end
        end

        character.ChildAdded:Connect(function(child)
            if child:IsA("BasePart") then
                makePartsClip(child)
            end
        end)

        noclipButton.TextColor3 = Color3.new(1, 0, 0) -- Red color
    end
end)

-- Toggle visibility with 'K' key
local tweenService = game:GetService("TweenService")
local isVisible = true

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        if isVisible then
            -- Tween out
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = tweenService:Create(blackBackground, tweenInfo, {Position = UDim2.new(0, 0, 1, 0)}) -- Move up
            tween:Play()
            tween.Completed:Connect(function()
                isVisible = false
            end)
        else
            -- Tween in
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local tween = tweenService:Create(blackBackground, tweenInfo, {Position = UDim2.new(0, 0, 1, -50)}) -- Move down
            tween:Play()
            tween.Completed:Connect(function()
                isVisible = true
            end)
        end
    end
end)

-- Create the unload button
local unloadButton = Instance.new("TextButton")
unloadButton.Size = UDim2.new(0, 50, 0, 30) -- 50 pixels width, 30 pixels height
unloadButton.Position = UDim2.new(1, -60, 0, 10) -- Right side with some padding
unloadButton.Text = "X"
unloadButton.TextColor3 = Color3.new(1, 0, 0) -- Red color
unloadButton.TextSize = 18
unloadButton.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
unloadButton.BackgroundTransparency = 0.5 -- 50% transparent
unloadButton.Parent = blackBackground

unloadButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
