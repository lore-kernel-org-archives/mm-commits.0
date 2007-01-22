From: akpm@osdl.org
Subject: + qconf-back-button-behaviour-normalization.patch added to -mm tree
Date: Mon, 22 Jan 2007 14:21:35 -0800
Message-ID: <200701222221.l0MMLZq1003851@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57805 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497AbXAVWWT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 17:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     qconf: Back button behaviour normalization
has been added to the -mm tree.  Its filename is
     qconf-back-button-behaviour-normalization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: qconf: Back button behaviour normalization
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>

Do "Back" button behaviour normalization so it is enabled starting from
second-level menu only.

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kconfig/qconf.cc |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

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

qconf-fix-showing-help-info-on-failed-search.patch
qconf-back-button-behaviour-normalization.patch
