{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    commands = {
      'atom-vim-colon-command-on-command-pallete:w':      => @write(),
      'atom-vim-colon-command-on-command-pallete:write':  => @write(),
      'atom-vim-colon-command-on-command-pallete:q':      => @quit(),
      'atom-vim-colon-command-on-command-pallete:quit':   => @quit(),
      'atom-vim-colon-command-on-command-pallete:wq':     => @writeAndQuit(),
      'atom-vim-colon-command-on-command-pallete:x':      => @writeAndQuit(),
      'atom-vim-colon-command-on-command-pallete:tabnew': => @openNewTab(),
      'w':                                                => @write(),
      'write':                                            => @write(),
      'q':                                                => @quit(),
      'quit':                                             => @quit(),
      'qa':                                               => @quitAll(),
      'wq':                                               => @writeAndQuit()
      'x':                                                => @writeAndQuit()
      'wqa':                                              => @writeAndQuitAll()
      'xa':                                               => @writeAndQuitAll()
      'tabnew':                                           => @openNewTab()
      'e': (event)                                        => @edit(event)
      'edit': (event)                                     => @edit(event)
    }
    @subscriptions.add atom.commands.add 'atom-text-editor', commands

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  write: ->
    atom.workspace.getActiveTextEditor().save()

  quit: ->
    atom.workspace.destroyActivePane()

  quitAll: ->
    panes = atom.workspace.getPanes()
    pane.destroy() for pane in panes

  writeAndQuit: ->
    atom.workspace.getActiveTextEditor().save()
    atom.workspace.getActivePane().destroy()

  writeAndQuitAll: ->
    editors = atom.workspace.getTextEditors()
    editor.save() for editor in editors
    panes = atom.workspace.getPanes()
    pane.destroy() for pane in panes

  openNewTab: ->
    atom.workspace.open()

  edit: (event) ->
    editorElement = atom.views.getView(atom.workspace.getActiveTextEditor())
    atom.commands.dispatch(editorElement, 'advanced-open-file:toggle')
