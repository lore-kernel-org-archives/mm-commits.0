From: akpm@linux-foundation.org
Subject: [merged] kconfig-qconf-fix-the-type-of-the-desktop-widget.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:52:33 -0700
Message-ID: <200906101752.n5AHqXxD005358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590AbZFJRy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:54:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: markus.heidelberg@web.de, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kconfig qconf: fix the type of the desktop widget
has been removed from the -mm tree.  Its filename was
     kconfig-qconf-fix-the-type-of-the-desktop-widget.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

