From: akpm@linux-foundation.org
Subject: - qconf-relocate-search-command.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:04 -0800
Message-ID: <200702150847.l1F8l4rY024959@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39935 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965361AbXBOIrs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shlomif@iglu.org.il, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     qconf: relocate Search Command
has been removed from the -mm tree.  Its filename was
     qconf-relocate-search-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: qconf: relocate Search Command
From: Shlomi Fish <shlomif@iglu.org.il>

Relocate the qconf search command to the "Edit"->"Find" menu option.

This is per the discussion on my qconf search dialog patch.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/qconf.cc |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN scripts/kconfig/qconf.cc~qconf-relocate-search-command scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~qconf-relocate-search-command
+++ a/scripts/kconfig/qconf.cc
@@ -1317,7 +1317,7 @@ ConfigMainWindow::ConfigMainWindow(void)
 	conf_changed();
 	QAction *saveAsAction = new QAction("Save As...", "Save &As...", 0, this);
 	  connect(saveAsAction, SIGNAL(activated()), SLOT(saveConfigAs()));
-	QAction *searchAction = new QAction("Search", "&Search", CTRL+Key_F, this);
+	QAction *searchAction = new QAction("Find", "&Find", CTRL+Key_F, this);
 	  connect(searchAction, SIGNAL(activated()), SLOT(searchConfig()));
 	QAction *singleViewAction = new QAction("Single View", QPixmap(xpm_single_view), "Split View", 0, this);
 	  connect(singleViewAction, SIGNAL(activated()), SLOT(showSingleView()));
@@ -1374,10 +1374,13 @@ ConfigMainWindow::ConfigMainWindow(void)
 	saveAction->addTo(config);
 	saveAsAction->addTo(config);
 	config->insertSeparator();
-	searchAction->addTo(config);
-	config->insertSeparator();
 	quitAction->addTo(config);
 
+	// create edit menu
+	QPopupMenu* editMenu = new QPopupMenu(this);
+	menu->insertItem("&Edit", editMenu);
+	searchAction->addTo(editMenu);
+
 	// create options menu
 	QPopupMenu* optionMenu = new QPopupMenu(this);
 	menu->insertItem("&Option", optionMenu);
_

Patches currently in -mm which might be from shlomif@iglu.org.il are

origin.patch
