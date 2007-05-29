From: akpm@linux-foundation.org
Subject: + dm-add-missing-braces-in-driver-debug-code.patch added to -mm tree
Date: Tue, 29 May 2007 12:50:31 -0700
Message-ID: <200705291950.l4TJoV4q010009@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbXE2Tus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 15:50:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, agk@redhat.com


The patch titled
     dm: add missing braces in driver debug code
has been added to the -mm tree.  Its filename is
     dm-add-missing-braces-in-driver-debug-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

dm-add-missing-braces-in-driver-debug-code.patch
m68k-parenthesis-balance.patch
arm26-remove-broken-and-unused-macro.patch
