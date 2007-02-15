From: akpm@linux-foundation.org
Subject: - qconf-back-button-behaviour-normalization.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:12 -0800
Message-ID: <200702150847.l1F8lCSs024965@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39881 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965341AbXBOIrS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     qconf: Back button behaviour normalization
has been removed from the -mm tree.  Its filename was
     qconf-back-button-behaviour-normalization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: qconf: Back button behaviour normalization
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>

Do "Back" button behaviour normalization so it is enabled starting from
second-level menu only.

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/qconf.cc |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/kconfig/qconf.cc~qconf-back-button-behaviour-normalization scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~qconf-back-button-behaviour-normalization
+++ a/scripts/kconfig/qconf.cc
@@ -1472,7 +1472,10 @@ void ConfigMainWindow::searchConfig(void
 void ConfigMainWindow::changeMenu(struct menu *menu)
 {
 	configList->setRootMenu(menu);
-	backAction->setEnabled(TRUE);
+	if (configList->rootEntry->parent == &rootmenu)
+		backAction->setEnabled(FALSE);
+	else
+		backAction->setEnabled(TRUE);
 }
 
 void ConfigMainWindow::setMenuLink(struct menu *menu)
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
