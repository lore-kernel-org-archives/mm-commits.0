From: akpm@osdl.org
Subject: - kconfig-new-function-bool-conf_get_changedvoid.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:03:13 -0800
Message-ID: <200612140603.kBE63DFb001769@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51856 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbWLNGGM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:06:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: annabellesgarden@yahoo.de, fzu@wemgehoertderstaat.de, randy.dunlap@oracle.com, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kconfig: new function "bool conf_get_changed(void)"
has been removed from the -mm tree.  Its filename was
     kconfig-new-function-bool-conf_get_changedvoid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kconfig: new function "bool conf_get_changed(void)"
From: Karsten Wiese <annabellesgarden@yahoo.de>

Run "make xconfig" on a freshly untarred kernel-tree.  Look at the floppy disk
icon of the qt application, that has just started: Its in a normal, active
state.

Mouse click on it: .config is being saved.

This patch series changes things so taht 
after the mouse click on the floppy disk icon, the icon is greyed out.
If you mouse click on it now, nothing happens.

If you change some CONFIG_*, the floppy disk icon returns to "active state",
that is, if you mouse click it now, .config is written.


This patch:

Returns sym_change_count to reflect the .config's change state.
All read only accesses of
	sym_change_count
are replaced by calls to
	conf_get_changed()
.
mconfig.c is manipulated to ask for saving only when
conf_get_changed() returned true.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kconfig/conf.c      |    2 +-
 scripts/kconfig/confdata.c  |    7 ++++++-
 scripts/kconfig/lkc_proto.h |    1 +
 scripts/kconfig/mconf.c     |   21 ++++++++++++++-------
 scripts/kconfig/qconf.cc    |    2 +-
 5 files changed, 23 insertions(+), 10 deletions(-)

diff -puN scripts/kconfig/conf.c~kconfig-new-function-bool-conf_get_changedvoid scripts/kconfig/conf.c
--- a/scripts/kconfig/conf.c~kconfig-new-function-bool-conf_get_changedvoid
+++ a/scripts/kconfig/conf.c
@@ -600,7 +600,7 @@ int main(int ac, char **av)
 			input_mode = ask_silent;
 			valid_stdin = 1;
 		}
-	} else if (sym_change_count) {
+	} else if (conf_get_changed()) {
 		name = getenv("KCONFIG_NOSILENTUPDATE");
 		if (name && *name) {
 			fprintf(stderr, _("\n*** Kernel configuration requires explicit update.\n\n"));
diff -puN scripts/kconfig/confdata.c~kconfig-new-function-bool-conf_get_changedvoid scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c~kconfig-new-function-bool-conf_get_changedvoid
+++ a/scripts/kconfig/confdata.c
@@ -432,7 +432,7 @@ int conf_write(const char *name)
 		     use_timestamp ? "# " : "",
 		     use_timestamp ? ctime(&now) : "");
 
-	if (!sym_change_count)
+	if (!conf_get_changed())
 		sym_clear_all_valid();
 
 	menu = rootmenu.list;
@@ -765,3 +765,8 @@ int conf_write_autoconf(void)
 
 	return 0;
 }
+
+bool conf_get_changed(void)
+{
+	return sym_change_count;
+}
diff -puN scripts/kconfig/lkc_proto.h~kconfig-new-function-bool-conf_get_changedvoid scripts/kconfig/lkc_proto.h
--- a/scripts/kconfig/lkc_proto.h~kconfig-new-function-bool-conf_get_changedvoid
+++ a/scripts/kconfig/lkc_proto.h
@@ -5,6 +5,7 @@ P(conf_read,int,(const char *name));
 P(conf_read_simple,int,(const char *name, int));
 P(conf_write,int,(const char *name));
 P(conf_write_autoconf,int,(void));
+P(conf_get_changed,bool,(void));
 
 /* menu.c */
 P(rootmenu,struct menu,);
diff -puN scripts/kconfig/mconf.c~kconfig-new-function-bool-conf_get_changedvoid scripts/kconfig/mconf.c
--- a/scripts/kconfig/mconf.c~kconfig-new-function-bool-conf_get_changedvoid
+++ a/scripts/kconfig/mconf.c
@@ -890,14 +890,19 @@ int main(int ac, char **av)
 	do {
 		conf(&rootmenu);
 		dialog_clear();
-		res = dialog_yesno(NULL,
-				   _("Do you wish to save your "
-				     "new kernel configuration?\n"
-				     "<ESC><ESC> to continue."),
-				   6, 60);
+		if (conf_get_changed())
+			res = dialog_yesno(NULL,
+					   _("Do you wish to save your "
+					     "new kernel configuration?\n"
+					     "<ESC><ESC> to continue."),
+					   6, 60);
+		else
+			res = -1;
 	} while (res == KEY_ESC);
 	end_dialog();
-	if (res == 0) {
+
+	switch (res) {
+	case 0:
 		if (conf_write(NULL)) {
 			fprintf(stderr, _("\n\n"
 				"Error during writing of the kernel configuration.\n"
@@ -905,11 +910,13 @@ int main(int ac, char **av)
 				"\n\n"));
 			return 1;
 		}
+	case -1:
 		printf(_("\n\n"
 			"*** End of Linux kernel configuration.\n"
 			"*** Execute 'make' to build the kernel or try 'make help'."
 			"\n\n"));
-	} else {
+		break;
+	default:
 		fprintf(stderr, _("\n\n"
 			"Your kernel configuration changes were NOT saved."
 			"\n\n"));
diff -puN scripts/kconfig/qconf.cc~kconfig-new-function-bool-conf_get_changedvoid scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~kconfig-new-function-bool-conf_get_changedvoid
+++ a/scripts/kconfig/qconf.cc
@@ -1585,7 +1585,7 @@ void ConfigMainWindow::showFullView(void
  */
 void ConfigMainWindow::closeEvent(QCloseEvent* e)
 {
-	if (!sym_change_count) {
+	if (!conf_get_changed()) {
 		e->accept();
 		return;
 	}
_

Patches currently in -mm which might be from annabellesgarden@yahoo.de are


