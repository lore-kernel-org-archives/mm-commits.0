From: akpm@linux-foundation.org
Subject: + watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch added to -mm tree
Date: Thu, 01 May 2008 14:51:51 -0700
Message-ID: <200805012151.m41Lpqh1027177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760726AbYEAVw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 17:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.chen@freescale.com, wim@iguana.be


The patch titled
     watchdog: fix booke_wdt.c on MPC85xx SMP system
has been added to the -mm tree.  Its filename is
     watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: fix booke_wdt.c on MPC85xx SMP system
From: Chen Gong <g.chen@freescale.com>

On Book-E SMP systems each core has its own private watchdog.  If only one
watchdog is enabled, when the core that doesn't enable the watchdog is hung,
system can't reset because no watchdog is running on it.  That's bad.  It
means we must enable watchdogs on both cores.

We can use smp_call_function() to send appropriate messages to all the other
cores to enable and update the watchdog.

Signed-off-by: Chen Gong <g.chen@freescale.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/booke_wdt.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff -puN drivers/watchdog/booke_wdt.c~watchdog-fix-booke_wdtc-on-mpc85xx-smp-system drivers/watchdog/booke_wdt.c
--- a/drivers/watchdog/booke_wdt.c~watchdog-fix-booke_wdtc-on-mpc85xx-smp-system
+++ a/drivers/watchdog/booke_wdt.c
@@ -1,12 +1,12 @@
 /*
- * drivers/char/watchdog/booke_wdt.c
+ * drivers/watchdog/booke_wdt.c
  *
  * Watchdog timer for PowerPC Book-E systems
  *
  * Author: Matthew McClintock
  * Maintainer: Kumar Gala <galak@kernel.crashing.org>
  *
- * Copyright 2005 Freescale Semiconductor Inc.
+ * Copyright 2005, 2008 Freescale Semiconductor Inc.
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -16,6 +16,7 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/smp.h>
 #include <linux/miscdevice.h>
 #include <linux/notifier.h>
 #include <linux/watchdog.h>
@@ -47,23 +48,31 @@ u32 booke_wdt_period = WDT_PERIOD_DEFAUL
 #define WDTP(x)		(TCR_WP(x))
 #endif
 
+static DEFINE_SPINLOCK(booke_wdt_lock);
+
+static void __booke_wdt_ping(void *data)
+{
+	mtspr(SPRN_TSR, TSR_ENW|TSR_WIS);
+}
+
 /*
  * booke_wdt_ping:
  */
 static __inline__ void booke_wdt_ping(void)
 {
-	mtspr(SPRN_TSR, TSR_ENW|TSR_WIS);
+	smp_call_function(__booke_wdt_ping, NULL, 0, 0);
+	__booke_wdt_ping(NULL);
 }
 
 /*
- * booke_wdt_enable:
+ * __booke_wdt_enable:
  */
-static __inline__ void booke_wdt_enable(void)
+static inline void __booke_wdt_enable(void *data)
 {
 	u32 val;
 
 	/* clear status before enabling watchdog */
-	booke_wdt_ping();
+	__booke_wdt_ping(NULL);
 	val = mfspr(SPRN_TCR);
 	val |= (TCR_WIE|TCR_WRC(WRC_CHIP)|WDTP(booke_wdt_period));
 
@@ -137,12 +146,15 @@ static int booke_wdt_ioctl (struct inode
  */
 static int booke_wdt_open (struct inode *inode, struct file *file)
 {
+	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
-		booke_wdt_enable();
+		__booke_wdt_enable(NULL);
+		smp_call_function(__booke_wdt_enable, NULL, 0, 0);
 		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
 				booke_wdt_period);
 	}
+	spin_unlock(&booke_wdt_lock);
 
 	return nonseekable_open(inode, file);
 }
@@ -183,11 +195,14 @@ static int __init booke_wdt_init(void)
 		return ret;
 	}
 
+	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 1) {
 		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
 				booke_wdt_period);
-		booke_wdt_enable();
+		__booke_wdt_enable(NULL);
+		smp_call_function(__booke_wdt_enable, NULL, 0, 0);
 	}
+	spin_unlock(&booke_wdt_lock);
 
 	return ret;
 }
_

Patches currently in -mm which might be from g.chen@freescale.com are

watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix.patch

