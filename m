From: akpm@linux-foundation.org
Subject: + watchdog-mtx-1_wdt-clean-up-coding-style-unlocked-ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:19 -0700
Message-ID: <200805200828.m4K8SJZ4013149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760952AbYETI2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: mtx-1_wdt: clean up, coding style, unlocked ioctl
has been added to the -mm tree.  Its filename is
     watchdog-mtx-1_wdt-clean-up-coding-style-unlocked-ioctl.patch

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
Subject: watchdog: mtx-1_wdt: clean up, coding style, unlocked ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/mtx-1_wdt.c |  107 ++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 55 deletions(-)

diff -puN drivers/watchdog/mtx-1_wdt.c~watchdog-mtx-1_wdt-clean-up-coding-style-unlocked-ioctl drivers/watchdog/mtx-1_wdt.c
--- a/drivers/watchdog/mtx-1_wdt.c~watchdog-mtx-1_wdt-clean-up-coding-style-unlocked-ioctl
+++ a/drivers/watchdog/mtx-1_wdt.c
@@ -1,7 +1,8 @@
 /*
  *      Driver for the MTX-1 Watchdog.
  *
- *      (C) Copyright 2005 4G Systems <info@4g-systems.biz>, All Rights Reserved.
+ *      (C) Copyright 2005 4G Systems <info@4g-systems.biz>,
+ *							All Rights Reserved.
  *                              http://www.4g-systems.biz
  *
  * 	(C) Copyright 2007 OpenWrt.org, Florian Fainelli <florian@openwrt.org>
@@ -46,12 +47,11 @@
 #include <linux/jiffies.h>
 #include <linux/watchdog.h>
 #include <linux/platform_device.h>
-
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/gpio.h>
 
 #include <asm/mach-au1x00/au1000.h>
-#include <asm/gpio.h>
 
 #define MTX1_WDT_INTERVAL	(5 * HZ)
 
@@ -59,6 +59,7 @@ static int ticks = 100 * HZ;
 
 static struct {
 	struct completion stop;
+	spinlock_t lock;
 	int running;
 	struct timer_list timer;
 	int queue;
@@ -71,6 +72,7 @@ static void mtx1_wdt_trigger(unsigned lo
 {
 	u32 tmp;
 
+	spin_lock(&mtx1_wdt_device.lock);
 	if (mtx1_wdt_device.running)
 		ticks--;
 	/*
@@ -79,13 +81,13 @@ static void mtx1_wdt_trigger(unsigned lo
 	tmp = au_readl(GPIO2_DIR);
 	tmp = (tmp & ~(1 << mtx1_wdt_device.gpio)) |
 	      ((~tmp) & (1 << mtx1_wdt_device.gpio));
-	au_writel (tmp, GPIO2_DIR);
+	au_writel(tmp, GPIO2_DIR);
 
 	if (mtx1_wdt_device.queue && ticks)
 		mod_timer(&mtx1_wdt_device.timer, jiffies + MTX1_WDT_INTERVAL);
-	else {
+	else
 		complete(&mtx1_wdt_device.stop);
-	}
+	spin_unlock(&mtx1_wdt_device.lock);
 }
 
 static void mtx1_wdt_reset(void)
@@ -96,23 +98,25 @@ static void mtx1_wdt_reset(void)
 
 static void mtx1_wdt_start(void)
 {
+	spin_lock_irqsave(&mtx1_wdt_device.lock, flags);
 	if (!mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 1;
 		gpio_set_value(mtx1_wdt_device.gpio, 1);
 		mod_timer(&mtx1_wdt_device.timer, jiffies + MTX1_WDT_INTERVAL);
 	}
 	mtx1_wdt_device.running++;
+	spin_unlock_irqrestore(&mtx1_wdt_device.lock, flags);
 }
 
 static int mtx1_wdt_stop(void)
 {
+	spin_lock_irqsave(&mtx1_wdt_device.lock, flags);
 	if (mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 0;
 		gpio_set_value(mtx1_wdt_device.gpio, 0);
 	}
-
 	ticks = mtx1_wdt_device.default_ticks;
-
+	spin_unlock_irqrestore(&mtx1_wdt_device.lock, flags);
 	return 0;
 }
 
@@ -122,7 +126,6 @@ static int mtx1_wdt_open(struct inode *i
 {
 	if (test_and_set_bit(0, &mtx1_wdt_device.inuse))
 		return -EBUSY;
-
 	return nonseekable_open(inode, file);
 }
 
@@ -133,54 +136,51 @@ static int mtx1_wdt_release(struct inode
 	return 0;
 }
 
-static int mtx1_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long mtx1_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
+	int __user *p = (int __user *)argp;
 	unsigned int value;
-	static struct watchdog_info ident =
-	{
+	static const struct watchdog_info ident = {
 		.options = WDIOF_CARDRESET,
 		.identity = "MTX-1 WDT",
 	};
 
-	switch(cmd) {
-		case WDIOC_KEEPALIVE:
-			mtx1_wdt_reset();
-			break;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			if ( copy_to_user(argp, &value, sizeof(int)) )
-				return -EFAULT;
-			break;
-		case WDIOC_GETSUPPORT:
-			if ( copy_to_user(argp, &ident, sizeof(ident)) )
-				return -EFAULT;
-			break;
-		case WDIOC_SETOPTIONS:
-			if ( copy_from_user(&value, argp, sizeof(int)) )
-				return -EFAULT;
-			switch(value) {
-				case WDIOS_ENABLECARD:
-					mtx1_wdt_start();
-					break;
-				case WDIOS_DISABLECARD:
-					return mtx1_wdt_stop();
-				default:
-					return -EINVAL;
-			}
-			break;
-		default:
-			return -ENOTTY;
+	switch (cmd) {
+	case WDIOC_KEEPALIVE:
+		mtx1_wdt_reset();
+		break;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		put_user(0, p);
+		break;
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
+	case WDIOC_SETOPTIONS:
+		if (get_user(value, p))
+			return -EFAULT;
+		if (value & WDIOS_ENABLECARD)
+			mtx1_wdt_start();
+		else if (value & WDIOS_DISABLECARD)
+			mtx1_wdt_stop();
+		else
+			return -EINVAL;
+		return 0;
+	default:
+		return -ENOTTY;
 	}
 	return 0;
 }
 
 
-static ssize_t mtx1_wdt_write(struct file *file, const char *buf, size_t count, loff_t *ppos)
+static ssize_t mtx1_wdt_write(struct file *file, const char *buf,
+						size_t count, loff_t *ppos)
 {
 	if (!count)
 		return -EIO;
-
 	mtx1_wdt_reset();
 	return count;
 }
@@ -188,7 +188,7 @@ static ssize_t mtx1_wdt_write(struct fil
 static const struct file_operations mtx1_wdt_fops = {
 	.owner 		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= mtx1_wdt_ioctl,
+	.unlocked_ioctl	= mtx1_wdt_ioctl,
 	.open 		= mtx1_wdt_open,
 	.write 		= mtx1_wdt_write,
 	.release 	= mtx1_wdt_release
@@ -208,29 +208,26 @@ static int mtx1_wdt_probe(struct platfor
 
 	mtx1_wdt_device.gpio = pdev->resource[0].start;
 
-	if ((ret = misc_register(&mtx1_wdt_misc)) < 0) {
-		printk(KERN_ERR " mtx-1_wdt : failed to register\n");
-		return ret;
-	}
-
+	spin_lock_init(&mtx1_wdt_device.lock);
 	init_completion(&mtx1_wdt_device.stop);
 	mtx1_wdt_device.queue = 0;
-
 	clear_bit(0, &mtx1_wdt_device.inuse);
-
 	setup_timer(&mtx1_wdt_device.timer, mtx1_wdt_trigger, 0L);
-
 	mtx1_wdt_device.default_ticks = ticks;
 
+	ret = misc_register(&mtx1_wdt_misc);
+	if (ret < 0) {
+		printk(KERN_ERR " mtx-1_wdt : failed to register\n");
+		return ret;
+	}
 	mtx1_wdt_start();
-
 	printk(KERN_INFO "MTX-1 Watchdog driver\n");
-
 	return 0;
 }
 
 static int mtx1_wdt_remove(struct platform_device *pdev)
 {
+	/* FIXME: do we need to lock this test ? */
 	if (mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 0;
 		wait_for_completion(&mtx1_wdt_device.stop);
_

Patches currently in -mm which might be from alan@redhat.com are

linux-next.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
watchdog-clean-acquirewdt-and-check-for-bkl-dependancies.patch
watchdog-clean-up-and-check-advantech-watchdog.patch
watchdog-ali-watchdog-locking-and-style.patch
watchdog-ar7-watchdog.patch
watchdog-atp-watchdog.patch
watchdog-at91-watchdog-to-unlocked_ioctl.patch
watchdog-cpu5_wdt-switch-to-unlocked_ioctl.patch
watchdog-davinci_wdt-unlocked_ioctl-and-check-locking.patch
watchdog-ep93xx_wdt-unlocked_ioctl.patch
watchdog-eurotechwdt-unlocked_ioctl-code-lock-check-and-tidy.patch
watchdog-hpwdt-couple-of-include-cleanups.patch
watchdog-ib700wdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-i6300esb-style-unlocked_ioctl-cleanup.patch
watchdog-ibmasr-coding-style-locking-verify.patch
watchdog-indydog-clean-up-and-tidy.patch
watchdog-iop-watchdog-switch-to-unlocked_ioctl.patch
watchdog-it8712f-unlocked_ioctl.patch
watchdog-bfin-watchdog-cleanup-and-unlocked_ioctl.patch
watchdog-ixp2000_wdt-clean-up-and-unlocked_ioctl.patch
watchdog-ixp4xx_wdt-unlocked_ioctl.patch
watchdog-ks8695_wdt-clean-up-coding-style-unlocked_ioctl.patch
watchdog-machzwd-clean-up-coding-style-unlocked_ioctl.patch
watchdog-mixcomwd-coding-style-locking-unlocked_ioctl.patch
watchdog-mpc-watchdog-clean-up-and-locking.patch
watchdog-mpcore-watchdog-unlocked_ioctl-and-bkl-work.patch
watchdog-mtx-1_wdt-clean-up-coding-style-unlocked-ioctl.patch
watchdog-mv64x60_wdt-clean-up-and-locking-checks.patch
watchdog-omap_wdt-locking-unlocked_ioctl-tidy.patch
watchdog-pc87413_wdt-clean-up-coding-style-unlocked_ioctl.patch
watchdog-pcwd-clean-up-unlocked_ioctl-usage.patch
watchdog-pnx4008_wdt-unlocked_ioctl-setup.patch
watchdog-rm9k_wdt-clean-up.patch
watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl.patch
watchdog-sa1100_wdt-switch-to-unlocked_ioctl.patch
watchdog-sbc60xxwdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-stg7240_wdt-unlocked_ioctl.patch
watchdog-sbc8360-clean-up.patch
watchdog-sbc_epx_c3_wdt-switch-to-unlocked_ioctl.patch
watchdog-sb_wdog-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-sc1200_wdt-clean-up-fix-locking-and-use-unlocked_ioctl.patch
watchdog-sc520_wdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-scx200_wdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-shwdt-coding-style-cleanup-switch-to-unlocked_ioctl.patch
watchdog-smsc37b787_wdt-coding-style-switch-to-unlocked_ioctl.patch
watchdog-softdog-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
watchdog-txx9-fix-locking-switch-to-unlocked_ioctl.patch
watchdog-w83627hf-coding-style-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-w83877f_wdt-clean-up-code-coding-style-switch-to-unlocked_ioctl.patch
watchdog-w83977f_wdt-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
watchdog-wafer5823wdt-clean-up-coding-style-switch-to-unlocked_ioctl.patch
watchdog-wdrtas-clean-up-coding-style-switch-to-unlocked_ioctl.patch
watchdog-wdt285-switch-to-unlocked_ioctl-and-tidy-up-oddments-of-coding-style.patch
watchdog-wdt977-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
mm-fix-atomic_t-overflow-in-vm.patch
serial-8250_gscc-add-module_license.patch
remove-is_tty.patch
riscom8-remove-redundant-null-pointer-test.patch
unexport-proc_clear_tty.patch

