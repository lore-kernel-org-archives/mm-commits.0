From: akpm@linux-foundation.org
Subject: + kconfig-qconf-fix-the-type-of-the-desktop-widget.patch added to -mm tree
Date: Wed, 27 May 2009 23:43:59 -0700
Message-ID: <200905280643.n4S6hx3o015101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112AbZE1Gog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:44:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markus.heidelberg@web.de, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     kconfig qconf: fix the type of the desktop widget
has been added to the -mm tree.  Its filename is
     kconfig-qconf-fix-the-type-of-the-desktop-widget.patch

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
Subject: kconfig qconf: fix the type of the desktop widget
From: Markus Heidelberg <markus.heidelberg@web.de>

QApplication::desktop() returns a pointer to QDesktopWidget, not to
QWidget.

Fixes the following compiler error after a quick conversion with 'qt3to4',
which occured with g++ 3.4.6 and 4.1.2, but not anymore with 4.3.2.

scripts/kconfig/qconf.cc: In constructor 'ConfigMainWindow::ConfigMainWindow()':
scripts/kconfig/qconf.cc:1289: error: cannot convert 'QDesktopWidget*' to 'QWidget*' in initialization

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/qconf.cc |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/kconfig/qconf.cc~kconfig-qconf-fix-the-type-of-the-desktop-widget scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~kconfig-qconf-fix-the-type-of-the-desktop-widget
+++ a/scripts/kconfig/qconf.cc
@@ -5,6 +5,7 @@
 
 #include <qapplication.h>
 #include <qmainwindow.h>
+#include <qdesktopwidget.h>
 #include <qtoolbar.h>
 #include <qlayout.h>
 #include <qvbox.h>
@@ -1275,7 +1276,7 @@ ConfigMainWindow::ConfigMainWindow(void)
 	int x, y, width, height;
 	char title[256];
 
-	QWidget *d = configApp->desktop();
+	QDesktopWidget *d = configApp->desktop();
 	snprintf(title, sizeof(title), _("Linux Kernel v%s Configuration"),
 		getenv("KERNELVERSION"));
 	setCaption(title);
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

