# # eval "$(starship init zsh)"
# export EDITOR="nvim"
# export SUDO_EDITOR="$EDITOR"
# export PGHOST="/var/run/postgresql"
#
#
#
# HISTFILE=~/.history
# HISTSIZE=10000
# SAVEHIST=50000
#
# alias v=nvim
# # alias swappy="grim -g "$(slurp)" - | swappy -f -"
# #
# setopt inc_append_history
#
# plugins=(
# 	zsh-autosuggestions
# )
#
# source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#
# # append completions to fpath
# fpath=(${ASDF_DIR}/completions $fpath)
# # initialise completions with ZSH's compinit
# autoload -Uz compinit && compinit
#
#
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#
# fastfetch

# Zinit Setup (for plugin management)
if [[ ! -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
    print -P "%F{33} Installing Zinit... %f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34} Installation successful. %f%b" || \
        print -P "%F{160} The clone has failed. %f%b"
fi
 
# Source Zinit for plugin management
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
 
# Simple plugins for autosuggestions and syntax highlighting
zinit light zsh-users/zsh-autosuggestions    # Command autosuggestions
zinit light zsh-users/zsh-syntax-highlighting # Syntax highlighting
 
 
# For command execution time with millisecond precision
function preexec() {
    timer=$(($(date +%s%0N)/1000000))
}
 
function precmd() {
    if [ $timer ]; then
        now=$(($(date +%s%0N)/1000000))
        elapsed=$(($now-$timer))
 
        if [[ $elapsed -eq 0 ]]; then
            # Show just "0" when no time has elapsed
            timer_show="0s"
        elif [[ $elapsed -ge 1000 ]]; then
            # For times >= 1 second, show as X.XXs
            timer_show="$(printf "%.2fs" $((elapsed/1000.0)))"
        elif [[ $elapsed -ge 100 ]]; then
            # For times >= 100ms, show as 0.XXXs
            timer_show="$(printf "0.%03ds" $elapsed)"
        else
            # For times < 100ms, ensure leading zeros
            timer_show="$(printf "0.%03ds" $elapsed)"
        fi
        unset timer
    else
        timer_show="0s"
    fi
}
 
# Function to calculate spaces for right alignment
function align_right() {
    local left_content="╭────  // %m // %~"
    local left_content_length=${#${(%)left_content}}
    local terminal_width=$(tput cols)
    local timer_length=${#timer_show}
    local spaces=$((terminal_width - left_content_length - timer_length))
 
    if [[ $spaces -gt 0 ]]; then
        printf "%${spaces}s" " "
    else
        printf " "
    fi
}
 
setopt PROMPT_SUBST
# Main prompt (left side + aligned timer on the first line)
PS1='%F{blue}╭──── %f // %F{blue}%m%f // %~$(align_right)%F{blue}${timer_show}%f
%F{blue}╰─󰁔%f '
 
autoload -Uz compinit && compinit
 
# Enable History Options
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt append_history
setopt hist_ignore_dups
 
# Custom Aliases for common commands
alias ll='ls -lah'
alias gs='git status'
alias gco='git checkout'
alias gp='git pull'
 
# Make tab completion work better
setopt auto_cd            # Switch to a directory just by typing its name
fastfetch --kitty-icat Downloads/shogun.jpeg --logo-width 23 --logo-height 10 && printf "\n"

fastfetch
