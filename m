From: akpm@osdl.org
Subject: - kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:03:46 -0800
Message-ID: <200612140603.kBE63kfL001790@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51977 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbWLNGHd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:07:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: annabellesgarden@yahoo.de, fzu@wemgehoertderstaat.de, randy.dunlap@oracle.com, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kconfig: add "void conf_set_changed_callback(void (*fn)(void))", use it in qconf.cc
has been removed from the -mm tree.  Its filename was
     kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kconfig: add "void conf_set_changed_callback(void (*fn)(void))", use it in qconf.cc
From: Karsten Wiese <annabellesgarden@yahoo.de>

Added function sets "void (*conf_changed_callback)(void)".  Call it, if
.config's changed state changes.  Use above in qconf.cc to set gui's
save-widget's sensitvity.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kconfig/confdata.c  |   12 +++++++++++-
 scripts/kconfig/lkc_proto.h |    1 +
 scripts/kconfig/qconf.cc    |   13 ++++++++++++-
 scripts/kconfig/qconf.h     |    3 +++
 4 files changed, 27 insertions(+), 2 deletions(-)

diff -puN scripts/kconfig/confdata.c~kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c~kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc
+++ a/scripts/kconfig/confdata.c
@@ -767,18 +767,28 @@ int conf_write_autoconf(void)
 }
 
 static int sym_change_count;
+static void (*conf_changed_callback)(void);
 
 void sym_set_change_count(int count)
 {
+	int _sym_change_count = sym_change_count;
 	sym_change_count = count;
+	if (conf_changed_callback &&
+	    (bool)_sym_change_count != (bool)count)
+		conf_changed_callback();
 }
 
 void sym_add_change_count(int count)
 {
-	sym_change_count += count;
+	sym_set_change_count(count + sym_change_count);
 }
 
 bool conf_get_changed(void)
 {
 	return sym_change_count;
 }
+
+void conf_set_changed_callback(void (*fn)(void))
+{
+	conf_changed_callback = fn;
+}
diff -puN scripts/kconfig/lkc_proto.h~kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc scripts/kconfig/lkc_proto.h
--- a/scripts/kconfig/lkc_proto.h~kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc
+++ a/scripts/kconfig/lkc_proto.h
@@ -6,6 +6,7 @@ P(conf_read_simple,int,(const char *name
 P(conf_write,int,(const char *name));
 P(conf_write_autoconf,int,(void));
 P(conf_get_changed,bool,(void));
+P(conf_set_changed_callback, void,(void (*fn)(void)));
 
 /* menu.c */
 P(rootmenu,struct menu,);
diff -puN scripts/kconfig/qconf.cc~kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc
+++ a/scripts/kconfig/qconf.cc
@@ -38,6 +38,8 @@
 static QApplication *configApp;
 static ConfigSettings *configSettings;
 
+QAction *ConfigMainWindow::saveAction;
+
 static inline QString qgettext(const char* str)
 {
 	return QString::fromLocal8Bit(gettext(str));
@@ -1306,8 +1308,11 @@ ConfigMainWindow::ConfigMainWindow(void)
 	  connect(quitAction, SIGNAL(activated()), SLOT(close()));
 	QAction *loadAction = new QAction("Load", QPixmap(xpm_load), "&Load", CTRL+Key_L, this);
 	  connect(loadAction, SIGNAL(activated()), SLOT(loadConfig()));
-	QAction *saveAction = new QAction("Save", QPixmap(xpm_save), "&Save", CTRL+Key_S, this);
+	saveAction = new QAction("Save", QPixmap(xpm_save), "&Save", CTRL+Key_S, this);
 	  connect(saveAction, SIGNAL(activated()), SLOT(saveConfig()));
+	conf_set_changed_callback(conf_changed);
+	// Set saveAction's initial state
+	conf_changed();
 	QAction *saveAsAction = new QAction("Save As...", "Save &As...", 0, this);
 	  connect(saveAsAction, SIGNAL(activated()), SLOT(saveConfigAs()));
 	QAction *searchAction = new QAction("Search", "&Search", CTRL+Key_F, this);
@@ -1658,6 +1663,12 @@ void ConfigMainWindow::saveSettings(void
 	configSettings->writeSizes("/split2", split2->sizes());
 }
 
+void ConfigMainWindow::conf_changed(void)
+{
+	if (saveAction)
+		saveAction->setEnabled(conf_get_changed());
+}
+
 void fixup_rootmenu(struct menu *menu)
 {
 	struct menu *child;
diff -puN scripts/kconfig/qconf.h~kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc scripts/kconfig/qconf.h
--- a/scripts/kconfig/qconf.h~kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc
+++ a/scripts/kconfig/qconf.h
@@ -297,6 +297,9 @@ protected:
 
 class ConfigMainWindow : public QMainWindow {
 	Q_OBJECT
+
+	static QAction *saveAction;
+	static void conf_changed(void);
 public:
 	ConfigMainWindow(void);
 public slots:
_

Patches currently in -mm which might be from annabellesgarden@yahoo.de are


