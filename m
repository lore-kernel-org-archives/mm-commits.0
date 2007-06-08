From: akpm@linux-foundation.org
Subject: - dm-add-missing-braces-in-driver-debug-code.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:26 -0700
Message-ID: <200706081735.l58HZQ75006364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55627 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967010AbXFHRgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm: add missing braces in driver debug code
has been removed from the -mm tree.  Its filename was
     dm-add-missing-braces-in-driver-debug-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: add missing braces in driver debug code
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Add missing braces in dm debug macros.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/md/dm.h~dm-add-missing-braces-in-driver-debug-code drivers/md/dm.h
--- a/drivers/md/dm.h~dm-add-missing-braces-in-driver-debug-code
+++ a/drivers/md/dm.h
@@ -25,7 +25,7 @@
 		if (printk_ratelimit())	\
 			printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " \
 			       f "\n", ## arg); \
-	while (0)
+	} while (0)
 
 #define DMWARN(f, arg...) \
 	printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
@@ -34,7 +34,7 @@
 		if (printk_ratelimit())	\
 			printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " \
 			       f "\n", ## arg); \
-	while (0)
+	} while (0)
 
 #define DMINFO(f, arg...) \
 	printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
@@ -43,7 +43,7 @@
 		if (printk_ratelimit())	\
 			printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f \
 			       "\n", ## arg); \
-	while (0)
+	} while (0)
 
 #ifdef CONFIG_DM_DEBUG
 #  define DMDEBUG(f, arg...) \
@@ -53,7 +53,7 @@
 		if (printk_ratelimit())	\
 			printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX ": " f \
 			       "\n", ## arg); \
-	while (0)
+	} while (0)
 #else
 #  define DMDEBUG(f, arg...) do {} while (0)
 #  define DMDEBUG_LIMIT(f, arg...) do {} while (0)
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

arm26-remove-broken-and-unused-macro.patch
drivers-edac-new-intel-5000-mc-driver-fix.patch
