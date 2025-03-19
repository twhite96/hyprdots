export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
export PATH=$HOME/.config/rofi/scripts:$PATH
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export EDITOR=/bin/nvim

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light xylous/gitstatus
# zinit ice wait'0'  # Load asynchronously
# zinit light zsh-users/zsh-autosuggestions

zinit light zsh-users/zsh-history-substring-search

zinit snippet OMZP::git
zinit snippet OMZP::sudo
#zinit snippet OMZP::archLinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
#zinit snippet OMZP::go
zinit snippet OMZP::kubectx
#zinit snippet OMZP::docker
zinit snippet OMZP::command-not-found
zinit snippet OMZP::terraform

autoload -Uz compinit && compinit
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'


# # Keybindings
bindkey -e
bindkey '^[ '   autosuggest-execute
bindkey '^[Z ' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

cd_up() {
  cd ..
  zle reset-prompt
}
zle -N cd_up
bindkey '^H' cd_up

cd_menu() {
  local dir
  dir=$(eza -1 --color=always --icons --group-directories-first | fzf --ansi --preview 'eza --tree --level=1 --icons --color=always {}')
  [[ -n "$dir" ]] && cd "$dir" && zle reset-prompt
}

zle -N cd_menu
bindkey '^L' cd_menu
zle -N cd_menu
bindkey '^L' cd_menu



HISTSIZE=5001
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# # Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval $(thefuck --alias)
eval "$(atuin init zsh)"
eval "$(starship init zsh)"

alias vim='nvim'
alias jump='nvim $(fzf -m --preview="bat --color=always {}")'
alias ls='eza -l -i --header  --tree --level=1  --all --sort=Name'
alias search='eval "~/.local/bin/search.sh"'
alias cod='code .'

# Tmux
alias t='tmux new -s '
alias tt='tmux a -t'

alias seek='pacseek'
alias y='yazi'
alias ci='cdi'
alias ....='cd ../..'
alias ..='cd ..'
alias ~='cd ~'

gh_open() {
  xdg-open "https://github.com/ad1822/$1"
}

backup_dots(){
  exec syncAll.sh
}


fcd(){
  local dir
  dir=$(find ${1:-.} -type d -not -path '*/\.*' 2> /dev/null | fzf +m) && cd "$dir"
}

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.gz)  tar -xzf "$1"      ;;
      *.tar.xz)  tar -xf "$1"       ;;
      *.tar.bz2) tar -xjf "$1"      ;;
      *.gz)      gunzip "$1"        ;;
      *.bz2)     bunzip2 "$1"       ;;
      *.zip)     unzip "$1"         ;;
      *.Z)       uncompress "$1"    ;;
      *.7z)      7z x "$1"          ;;
      *)         echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

killp() {
  ps aux | fzf | awk '{print $2}' | xargs kill -9
}

j() {
  local dir
  dir=$(eza -1 --color=always --icons --group-directories-first  | fzf --ansi) && cd "$(echo "$dir" | awk '{print $NF}')"
}


take() {
    mkdir -p "$1" && cd "$1"
}

#fastfetch

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
