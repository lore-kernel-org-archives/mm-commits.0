From: akpm@linux-foundation.org
Subject: [merged] kconfig-qconf-fix-wall-compiler-warnings.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:48:59 -0700
Message-ID: <200906101748.n5AHmxvb002391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696AbZFJRv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:51:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: markus.heidelberg@web.de, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kconfig qconf: fix -Wall compiler warnings
has been removed from the -mm tree.  Its filename was
     kconfig-qconf-fix-wall-compiler-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kconfig qconf: fix -Wall compiler warnings
From: Markus Heidelberg <markus.heidelberg@web.de>

These compiler warnings occure when adding -Wall to HOSTCXXFLAGS in
/Makefile

scripts/kconfig/qconf.h: In constructor `ConfigInfoView::ConfigInfoView(QWidget*, const char*)':
scripts/kconfig/qconf.h:274: warning: `ConfigInfoView::menu' will be initialized after
scripts/kconfig/qconf.h:273: warning:   `symbol* ConfigInfoView::sym'
scripts/kconfig/qconf.cc:922: warning:   when initialized here

scripts/kconfig/qconf.cc: In member function `void ConfigMainWindow::setMenuLink(menu*)':
scripts/kconfig/qconf.cc:1498: warning: enumeration value `menuMode' not handled in switch
scripts/kconfig/qconf.cc:1498: warning: enumeration value `listMode' not handled in switch

scripts/kconfig/qconf.cc: In member function `void ConfigMainWindow::saveSettings()':
scripts/kconfig/qconf.cc:1664: warning: enumeration value `menuMode' not handled in switch
scripts/kconfig/qconf.cc:1664: warning: enumeration value `listMode' not handled in switch

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/qconf.cc |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN scripts/kconfig/qconf.cc~kconfig-qconf-fix-wall-compiler-warnings scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~kconfig-qconf-fix-wall-compiler-warnings
+++ a/scripts/kconfig/qconf.cc
@@ -920,7 +920,7 @@ void ConfigView::updateListAll(void)
 }
 
 ConfigInfoView::ConfigInfoView(QWidget* parent, const char *name)
-	: Parent(parent, name), menu(0), sym(0)
+	: Parent(parent, name), sym(0), menu(0)
 {
 	if (name) {
 		configSettings->beginGroup(name);
@@ -1524,6 +1524,8 @@ void ConfigMainWindow::setMenuLink(struc
 	case fullMode:
 		list = configList;
 		break;
+	default:
+		break;
 	}
 
 	if (list) {
@@ -1673,6 +1675,9 @@ void ConfigMainWindow::saveSettings(void
 	case fullMode :
 		entry = "full";
 		break;
+
+	default:
+		break;
 	}
 	configSettings->writeEntry("/listMode", entry);
 
_

Patches currently in -mm which might be from markus.heidelberg@web.de are

linux-next.patch

