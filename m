From: akpm@linux-foundation.org
Subject: + kconfig-qconf-fix-wall-compiler-warnings.patch added to -mm tree
Date: Wed, 27 May 2009 23:43:53 -0700
Message-ID: <200905280643.n4S6hrms015092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755305AbZE1GoL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:44:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markus.heidelberg@web.de, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     kconfig qconf: fix -Wall compiler warnings
has been added to the -mm tree.  Its filename is
     kconfig-qconf-fix-wall-compiler-warnings.patch

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

