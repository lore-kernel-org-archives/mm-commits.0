From: akpm@osdl.org
Subject: + qconf-relocate-search-command.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:20:34 -0800
Message-ID: <200701112120.l0BLKYCL003390@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35807 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbXAKVVf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:21:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shlomif@iglu.org.il, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     qconf: relocate Search Command
has been added to the -mm tree.  Its filename is
     qconf-relocate-search-command.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: qconf: relocate Search Command
From: Shlomi Fish <shlomif@iglu.org.il>

Relocate the qconf search command to the "Edit"->"Find" menu option.

This is per the discussion on my qconf search dialog patch.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kconfig/qconf.cc |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

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

qconf-relocate-search-command.patch
