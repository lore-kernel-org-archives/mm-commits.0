From: akpm@linux-foundation.org
Subject: [merged] printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:46 -0700
Message-ID: <20120731184947.1550D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57007 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab2GaStt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:49 -0400
Received: by eekd4 with SMTP id d4so295430eek.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: remove the now unnecessary "C" annotation for KERN_CONT
has been removed from the -mm tree.  Its filename was
     printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: remove the now unnecessary "C" annotation for KERN_CONT

Now that all KERN_<LEVEL> uses are prefixed with ASCII SOH, there is no
need for a KERN_CONT.  Keep it backward compatible by adding #define
KERN_CONT ""

Reduces kernel image size a thousand bytes.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kern_levels.h |    2 +-
 include/linux/printk.h      |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/kern_levels.h~printk-remove-the-now-unnecessary-c-annotation-for-kern_cont include/linux/kern_levels.h
--- a/include/linux/kern_levels.h~printk-remove-the-now-unnecessary-c-annotation-for-kern_cont
+++ a/include/linux/kern_levels.h
@@ -20,6 +20,6 @@
  * line that had no enclosing \n). Only to be used by core/arch code
  * during early bootup (a continued line is not SMP-safe otherwise).
  */
-#define KERN_CONT	KERN_SOH "c"
+#define KERN_CONT	""
 
 #endif
diff -puN include/linux/printk.h~printk-remove-the-now-unnecessary-c-annotation-for-kern_cont include/linux/printk.h
--- a/include/linux/printk.h~printk-remove-the-now-unnecessary-c-annotation-for-kern_cont
+++ a/include/linux/printk.h
@@ -13,7 +13,6 @@ static inline int printk_get_level(const
 		switch (buffer[1]) {
 		case '0' ... '7':
 		case 'd':	/* KERN_DEFAULT */
-		case 'c':	/* KERN_CONT */
 			return buffer[1];
 		}
 	}
@@ -26,7 +25,6 @@ static inline const char *printk_skip_le
 		switch (buffer[1]) {
 		case '0' ... '7':
 		case 'd':	/* KERN_DEFAULT */
-		case 'c':	/* KERN_CONT */
 			return buffer + 2;
 		}
 	}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch

