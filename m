From: akpm@osdl.org
Subject: - qconf-fix-sigsegv-on-empty-menu-items.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:37 -0800
Message-ID: <200701070800.l0780bjV013206@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41068 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932492AbXAGIAn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:00:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     qconf: fix SIGSEGV on empty menu items
has been removed from the -mm tree.  Its filename was
     qconf-fix-sigsegv-on-empty-menu-items.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: qconf: fix SIGSEGV on empty menu items
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>

qconf may cause SIGSEGV by trying to show debug information on empty menu
items

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kconfig/qconf.cc |   12 ++++++++++--
 scripts/kconfig/qconf.h  |    2 ++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff -puN scripts/kconfig/qconf.cc~qconf-fix-sigsegv-on-empty-menu-items scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~qconf-fix-sigsegv-on-empty-menu-items
+++ a/scripts/kconfig/qconf.cc
@@ -925,6 +925,8 @@ ConfigInfoView::ConfigInfoView(QWidget* 
 		configSettings->endGroup();
 		connect(configApp, SIGNAL(aboutToQuit()), SLOT(saveSettings()));
 	}
+
+	has_dbg_info = 0;
 }
 
 void ConfigInfoView::saveSettings(void)
@@ -953,10 +955,13 @@ void ConfigInfoView::setInfo(struct menu
 	if (menu == m)
 		return;
 	menu = m;
-	if (!menu)
+	if (!menu) {
+		has_dbg_info = 0;
 		clear();
-	else
+	} else {
+		has_dbg_info = 1;
 		menuInfo();
+       }
 }
 
 void ConfigInfoView::setSource(const QString& name)
@@ -991,6 +996,9 @@ void ConfigInfoView::symbolInfo(void)
 {
 	QString str;
 
+	if (!has_dbg_info)
+		return;
+
 	str += "<big>Symbol: <b>";
 	str += print_filter(sym->name);
 	str += "</b></big><br><br>value: ";
diff -puN scripts/kconfig/qconf.h~qconf-fix-sigsegv-on-empty-menu-items scripts/kconfig/qconf.h
--- a/scripts/kconfig/qconf.h~qconf-fix-sigsegv-on-empty-menu-items
+++ a/scripts/kconfig/qconf.h
@@ -273,6 +273,8 @@ protected:
 	struct symbol *sym;
 	struct menu *menu;
 	bool _showDebug;
+
+	int has_dbg_info;
 };
 
 class ConfigSearchWindow : public QDialog {
_

Patches currently in -mm which might be from gorcunov@gmail.com are
