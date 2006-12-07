From: akpm@osdl.org
Subject: - qconf-support-old-qt.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:57 -0800
Message-ID: <200612072304.kB7N4vxn030099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52334 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163885AbWLGXFJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:05:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xtp@google.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     qconf: support old QT
has been removed from the -mm tree.  Its filename was
     qconf-support-old-qt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: qconf: support old QT


Might make qconf compilable with qt-3.1 as well as qt-3.3

Cc: greg chesson <xtp@google.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kconfig/qconf.cc |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN scripts/kconfig/qconf.cc~qconf-support-old-qt scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~qconf-support-old-qt
+++ a/scripts/kconfig/qconf.cc
@@ -798,7 +798,7 @@ void ConfigList::contextMenuEvent(QConte
 			QAction *action;
 
 			headerPopup = new QPopupMenu(this);
-			action = new QAction("Show Name", 0, this);
+			action = new QAction(NULL, "Show Name", 0, this);
 			  action->setToggleAction(TRUE);
 			  connect(action, SIGNAL(toggled(bool)),
 				  parent(), SLOT(setShowName(bool)));
@@ -806,7 +806,7 @@ void ConfigList::contextMenuEvent(QConte
 				  action, SLOT(setOn(bool)));
 			  action->setOn(showName);
 			  action->addTo(headerPopup);
-			action = new QAction("Show Range", 0, this);
+			action = new QAction(NULL, "Show Range", 0, this);
 			  action->setToggleAction(TRUE);
 			  connect(action, SIGNAL(toggled(bool)),
 				  parent(), SLOT(setShowRange(bool)));
@@ -814,7 +814,7 @@ void ConfigList::contextMenuEvent(QConte
 				  action, SLOT(setOn(bool)));
 			  action->setOn(showRange);
 			  action->addTo(headerPopup);
-			action = new QAction("Show Data", 0, this);
+			action = new QAction(NULL, "Show Data", 0, this);
 			  action->setToggleAction(TRUE);
 			  connect(action, SIGNAL(toggled(bool)),
 				  parent(), SLOT(setShowData(bool)));
@@ -1161,7 +1161,7 @@ void ConfigInfoView::expr_print_help(voi
 QPopupMenu* ConfigInfoView::createPopupMenu(const QPoint& pos)
 {
 	QPopupMenu* popup = Parent::createPopupMenu(pos);
-	QAction* action = new QAction("Show Debug Info", 0, popup);
+	QAction* action = new QAction(NULL,"Show Debug Info", 0, popup);
 	  action->setToggleAction(TRUE);
 	  connect(action, SIGNAL(toggled(bool)), SLOT(setShowDebug(bool)));
 	  connect(this, SIGNAL(showDebugChanged(bool)), action, SLOT(setOn(bool)));
_

Patches currently in -mm which might be from xtp@google.com are

origin.patch

