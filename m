From: akpm@linux-foundation.org
Subject: [merged] kconfig-qconf-fix-namespace-for-horizontal-and-vertical-enum-values.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:50:11 -0700
Message-ID: <200906101750.n5AHoBKG003335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549AbZFJRxI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:53:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: markus.heidelberg@web.de, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kconfig qconf: fix namespace for Horizontal and Vertical enum values
has been removed from the -mm tree.  Its filename was
     kconfig-qconf-fix-namespace-for-horizontal-and-vertical-enum-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kconfig qconf: fix namespace for Horizontal and Vertical enum values
From: Markus Heidelberg <markus.heidelberg@web.de>

They were used as QSplitter::Horizontal resp. QSplitter::Vertical, but
are defined in the 'Qt' namespace.

Fixes the following compiler errors after a quick conversion with 'qt3to4',
which occured with g++ 3.4.6 and 4.1.2, but not anymore with 4.3.2.

scripts/kconfig/qconf.cc: In constructor 'ConfigSearchWindow::ConfigSearchWindow(ConfigMainWindow*, const char*)':
scripts/kconfig/qconf.cc:1213: error: 'Vertical' is not a member of 'QSplitter'

scripts/kconfig/qconf.cc: In constructor 'ConfigMainWindow::ConfigMainWindow()':
scripts/kconfig/qconf.cc:1304: error: 'Horizontal' is not a member of 'QSplitter'
scripts/kconfig/qconf.cc:1311: error: 'Vertical' is not a member of 'QSplitter'

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/qconf.cc |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/kconfig/qconf.cc~kconfig-qconf-fix-namespace-for-horizontal-and-vertical-enum-values scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~kconfig-qconf-fix-namespace-for-horizontal-and-vertical-enum-values
+++ a/scripts/kconfig/qconf.cc
@@ -1199,7 +1199,7 @@ ConfigSearchWindow::ConfigSearchWindow(C
 	layout1->addLayout(layout2);
 
 	split = new QSplitter(this);
-	split->setOrientation(QSplitter::Vertical);
+	split->setOrientation(Qt::Vertical);
 	list = new ConfigView(split, name);
 	list->list->mode = listMode;
 	info = new ConfigInfoView(split, name);
@@ -1290,14 +1290,14 @@ ConfigMainWindow::ConfigMainWindow(void)
 		move(x, y);
 
 	split1 = new QSplitter(this);
-	split1->setOrientation(QSplitter::Horizontal);
+	split1->setOrientation(Qt::Horizontal);
 	setCentralWidget(split1);
 
 	menuView = new ConfigView(split1, "menu");
 	menuList = menuView->list;
 
 	split2 = new QSplitter(split1);
-	split2->setOrientation(QSplitter::Vertical);
+	split2->setOrientation(Qt::Vertical);
 
 	// create config tree
 	configView = new ConfigView(split2, "config");
_

Patches currently in -mm which might be from markus.heidelberg@web.de are

linux-next.patch

