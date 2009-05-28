From: akpm@linux-foundation.org
Subject: + kconfig-qconf-add-namespace-for-use-of-key_-enum-values.patch added to -mm tree
Date: Wed, 27 May 2009 23:43:57 -0700
Message-ID: <200905280643.n4S6hvjN015098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758649AbZE1GoS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:44:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markus.heidelberg@web.de, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     kconfig qconf: add namespace for use of Key_ enum values
has been added to the -mm tree.  Its filename is
     kconfig-qconf-add-namespace-for-use-of-key_-enum-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kconfig qconf: add namespace for use of Key_ enum values
From: Markus Heidelberg <markus.heidelberg@web.de>

They are defined in the 'Qt' namespace.

Fixes the following compiler errors after a quick conversion with 'qt3to4',
which occured with g++ 3.4.6 and 4.1.2, but not anymore with 4.3.2.

scripts/kconfig/qconf.cc: In member function 'virtual void ConfigLineEdit::keyPressEvent(QKeyEvent*)':
scripts/kconfig/qconf.cc:311: error: 'Key_Escape' was not declared in this scope
scripts/kconfig/qconf.cc:313: error: 'Key_Return' was not declared in this scope
scripts/kconfig/qconf.cc:314: error: 'Key_Enter' was not declared in this scope

scripts/kconfig/qconf.cc: In member function 'virtual void ConfigList::keyPressEvent(QKeyEvent*)':
scripts/kconfig/qconf.cc:653: error: 'Key_Escape' was not declared in this scope
scripts/kconfig/qconf.cc:666: error: 'Key_Return' was not declared in this scope
scripts/kconfig/qconf.cc:667: error: 'Key_Enter' was not declared in this scope
scripts/kconfig/qconf.cc:681: error: 'Key_Space' was not declared in this scope
scripts/kconfig/qconf.cc:684: error: 'Key_N' was not declared in this scope
scripts/kconfig/qconf.cc:687: error: 'Key_M' was not declared in this scope
scripts/kconfig/qconf.cc:690: error: 'Key_Y' was not declared in this scope

scripts/kconfig/qconf.cc: In constructor 'ConfigMainWindow::ConfigMainWindow()':
scripts/kconfig/qconf.cc:1329: error: 'CTRL' was not declared in this scope
scripts/kconfig/qconf.cc:1329: error: 'Key_Q' was not declared in this scope
scripts/kconfig/qconf.cc:1331: error: 'Key_L' was not declared in this scope
scripts/kconfig/qconf.cc:1333: error: 'Key_S' was not declared in this scope
scripts/kconfig/qconf.cc:1340: error: 'Key_F' was not declared in this scope

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/qconf.cc |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN scripts/kconfig/qconf.cc~kconfig-qconf-add-namespace-for-use-of-key_-enum-values scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~kconfig-qconf-add-namespace-for-use-of-key_-enum-values
+++ a/scripts/kconfig/qconf.cc
@@ -297,10 +297,10 @@ void ConfigLineEdit::show(ConfigItem* i)
 void ConfigLineEdit::keyPressEvent(QKeyEvent* e)
 {
 	switch (e->key()) {
-	case Key_Escape:
+	case Qt::Key_Escape:
 		break;
-	case Key_Return:
-	case Key_Enter:
+	case Qt::Key_Return:
+	case Qt::Key_Enter:
 		sym_set_string_value(item->menu->sym, text().latin1());
 		parent()->updateList(item);
 		break;
@@ -639,7 +639,7 @@ void ConfigList::keyPressEvent(QKeyEvent
 	struct menu *menu;
 	enum prop_type type;
 
-	if (ev->key() == Key_Escape && mode != fullMode && mode != listMode) {
+	if (ev->key() == Qt::Key_Escape && mode != fullMode && mode != listMode) {
 		emit parentSelected();
 		ev->accept();
 		return;
@@ -652,8 +652,8 @@ void ConfigList::keyPressEvent(QKeyEvent
 	item = (ConfigItem*)i;
 
 	switch (ev->key()) {
-	case Key_Return:
-	case Key_Enter:
+	case Qt::Key_Return:
+	case Qt::Key_Enter:
 		if (item->goParent) {
 			emit parentSelected();
 			break;
@@ -667,16 +667,16 @@ void ConfigList::keyPressEvent(QKeyEvent
 			emit menuSelected(menu);
 			break;
 		}
-	case Key_Space:
+	case Qt::Key_Space:
 		changeValue(item);
 		break;
-	case Key_N:
+	case Qt::Key_N:
 		setValue(item, no);
 		break;
-	case Key_M:
+	case Qt::Key_M:
 		setValue(item, mod);
 		break;
-	case Key_Y:
+	case Qt::Key_Y:
 		setValue(item, yes);
 		break;
 	default:
@@ -1315,18 +1315,18 @@ ConfigMainWindow::ConfigMainWindow(void)
 	backAction = new QAction("Back", QPixmap(xpm_back), _("Back"), 0, this);
 	  connect(backAction, SIGNAL(activated()), SLOT(goBack()));
 	  backAction->setEnabled(FALSE);
-	QAction *quitAction = new QAction("Quit", _("&Quit"), CTRL+Key_Q, this);
+	QAction *quitAction = new QAction("Quit", _("&Quit"), Qt::CTRL + Qt::Key_Q, this);
 	  connect(quitAction, SIGNAL(activated()), SLOT(close()));
-	QAction *loadAction = new QAction("Load", QPixmap(xpm_load), _("&Load"), CTRL+Key_L, this);
+	QAction *loadAction = new QAction("Load", QPixmap(xpm_load), _("&Load"), Qt::CTRL + Qt::Key_L, this);
 	  connect(loadAction, SIGNAL(activated()), SLOT(loadConfig()));
-	saveAction = new QAction("Save", QPixmap(xpm_save), _("&Save"), CTRL+Key_S, this);
+	saveAction = new QAction("Save", QPixmap(xpm_save), _("&Save"), Qt::CTRL + Qt::Key_S, this);
 	  connect(saveAction, SIGNAL(activated()), SLOT(saveConfig()));
 	conf_set_changed_callback(conf_changed);
 	// Set saveAction's initial state
 	conf_changed();
 	QAction *saveAsAction = new QAction("Save As...", _("Save &As..."), 0, this);
 	  connect(saveAsAction, SIGNAL(activated()), SLOT(saveConfigAs()));
-	QAction *searchAction = new QAction("Find", _("&Find"), CTRL+Key_F, this);
+	QAction *searchAction = new QAction("Find", _("&Find"), Qt::CTRL + Qt::Key_F, this);
 	  connect(searchAction, SIGNAL(activated()), SLOT(searchConfig()));
 	QAction *singleViewAction = new QAction("Single View", QPixmap(xpm_single_view), _("Single View"), 0, this);
 	  connect(singleViewAction, SIGNAL(activated()), SLOT(showSingleView()));
_

Patches currently in -mm which might be from markus.heidelberg@web.de are

kconfig-fix-typo-mconfig-to-menuconfig-in-a-comment.patch
kconfig-add-a-note-about-the-deps-to-the-silentoldconfig-help.patch
kconfig-resort-the-documentation-of-the-environment-variables.patch
gitignore-ignore-kconfig-i18n-files.patch
kconfig-qconf-fix-wall-compiler-warnings.patch
kconfig-qconf-fix-namespace-for-horizontal-and-vertical-enum-values.patch
kconfig-qconf-add-namespace-for-use-of-key_-enum-values.patch
kconfig-qconf-fix-the-type-of-the-desktop-widget.patch
kconfig-do-not-hardcode-config-filename.patch
kconfig-do-not-hardcode-include-config-autoconf-filename.patch

