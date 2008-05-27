From: akpm@linux-foundation.org
Subject: - watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch removed from -mm tree
Date: Tue, 27 May 2008 00:28:30 -0700
Message-ID: <200805270728.m4R7SUPp014946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756071AbYE0H3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:29:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.chen@freescale.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     watchdog: fix booke_wdt.c on MPC85xx SMP system
has been removed from the -mm tree.  Its filename was
     watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Chen Gong <g.chen@freescale.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/booke_wdt.c |   88 +++++++++++++++------------------
 1 file changed, 40 insertions(+), 48 deletions(-)

diff -puN drivers/watchdog/booke_wdt.c~watchdog-fix-booke_wdtc-on-mpc85xx-smp-system drivers/watchdog/booke_wdt.c
--- a/drivers/watchdog/booke_wdt.c~watchdog-fix-booke_wdtc-on-mpc85xx-smp-system
+++ a/drivers/watchdog/booke_wdt.c
@@ -1,12 +1,10 @@
 /*
- * drivers/char/watchdog/booke_wdt.c
- *
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
@@ -16,6 +14,7 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/smp.h>
 #include <linux/miscdevice.h>
 #include <linux/notifier.h>
 #include <linux/watchdog.h>
@@ -38,7 +37,7 @@
 #define WDT_PERIOD_DEFAULT 3	/* Refer to the PPC40x and PPC4xx manuals */
 #endif				/* for timing information */
 
-u32 booke_wdt_enabled = 0;
+u32 booke_wdt_enabled;
 u32 booke_wdt_period = WDT_PERIOD_DEFAULT;
 
 #ifdef	CONFIG_FSL_BOOKE
@@ -47,33 +46,31 @@ u32 booke_wdt_period = WDT_PERIOD_DEFAUL
 #define WDTP(x)		(TCR_WP(x))
 #endif
 
-/*
- * booke_wdt_ping:
- */
-static __inline__ void booke_wdt_ping(void)
+static DEFINE_SPINLOCK(booke_wdt_lock);
+
+static void __booke_wdt_ping(void *data)
 {
 	mtspr(SPRN_TSR, TSR_ENW|TSR_WIS);
 }
 
-/*
- * booke_wdt_enable:
- */
-static __inline__ void booke_wdt_enable(void)
+static void booke_wdt_ping(void)
+{
+	on_each_cpu(__booke_wdt_ping, NULL, 0, 0);
+}
+
+static void __booke_wdt_enable(void *data)
 {
 	u32 val;
 
 	/* clear status before enabling watchdog */
-	booke_wdt_ping();
+	__booke_wdt_ping(NULL);
 	val = mfspr(SPRN_TCR);
 	val |= (TCR_WIE|TCR_WRC(WRC_CHIP)|WDTP(booke_wdt_period));
 
 	mtspr(SPRN_TCR, val);
 }
 
-/*
- * booke_wdt_write:
- */
-static ssize_t booke_wdt_write (struct file *file, const char __user *buf,
+static ssize_t booke_wdt_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	booke_wdt_ping();
@@ -81,15 +78,11 @@ static ssize_t booke_wdt_write (struct f
 }
 
 static struct watchdog_info ident = {
-  .options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
-  .firmware_version = 0,
-  .identity = "PowerPC Book-E Watchdog",
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "PowerPC Book-E Watchdog",
 };
 
-/*
- * booke_wdt_ioctl:
- */
-static int booke_wdt_ioctl (struct inode *inode, struct file *file,
+static int booke_wdt_ioctl(struct inode *inode, struct file *file,
 			    unsigned int cmd, unsigned long arg)
 {
 	u32 tmp = 0;
@@ -97,7 +90,7 @@ static int booke_wdt_ioctl (struct inode
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user ((struct watchdog_info __user *) arg, &ident,
+		if (copy_to_user((struct watchdog_info __user *)arg, &ident,
 				sizeof(struct watchdog_info)))
 			return -EFAULT;
 	case WDIOC_GETSTATUS:
@@ -132,33 +125,33 @@ static int booke_wdt_ioctl (struct inode
 
 	return 0;
 }
-/*
- * booke_wdt_open:
- */
-static int booke_wdt_open (struct inode *inode, struct file *file)
+
+static int booke_wdt_open(struct inode *inode, struct file *file)
 {
+	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
-		booke_wdt_enable();
-		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
-				booke_wdt_period);
+		on_each_cpu(__booke_wdt_enable, NULL, 0, 0);
+		printk(KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
+				"(wdt_period=%d)\n", booke_wdt_period);
 	}
+	spin_unlock(&booke_wdt_lock);
 
 	return nonseekable_open(inode, file);
 }
 
 static const struct file_operations booke_wdt_fops = {
-  .owner = THIS_MODULE,
-  .llseek = no_llseek,
-  .write = booke_wdt_write,
-  .ioctl = booke_wdt_ioctl,
-  .open = booke_wdt_open,
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = booke_wdt_write,
+	.ioctl = booke_wdt_ioctl,
+	.open = booke_wdt_open,
 };
 
 static struct miscdevice booke_wdt_miscdev = {
-  .minor = WATCHDOG_MINOR,
-  .name = "watchdog",
-  .fops = &booke_wdt_fops,
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &booke_wdt_fops,
 };
 
 static void __exit booke_wdt_exit(void)
@@ -166,28 +159,27 @@ static void __exit booke_wdt_exit(void)
 	misc_deregister(&booke_wdt_miscdev);
 }
 
-/*
- * booke_wdt_init:
- */
 static int __init booke_wdt_init(void)
 {
 	int ret = 0;
 
-	printk (KERN_INFO "PowerPC Book-E Watchdog Timer Loaded\n");
+	printk(KERN_INFO "PowerPC Book-E Watchdog Timer Loaded\n");
 	ident.firmware_version = cur_cpu_spec->pvr_value;
 
 	ret = misc_register(&booke_wdt_miscdev);
 	if (ret) {
-		printk (KERN_CRIT "Cannot register miscdev on minor=%d (err=%d)\n",
+		printk(KERN_CRIT "Cannot register miscdev on minor=%d: %d\n",
 				WATCHDOG_MINOR, ret);
 		return ret;
 	}
 
+	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 1) {
-		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
-				booke_wdt_period);
-		booke_wdt_enable();
+		printk(KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
+				"(wdt_period=%d)\n", booke_wdt_period);
+		on_each_cpu(__booke_wdt_enable, NULL, 0, 0);
 	}
+	spin_unlock(&booke_wdt_lock);
 
 	return ret;
 }
_

Patches currently in -mm which might be from g.chen@freescale.com are


