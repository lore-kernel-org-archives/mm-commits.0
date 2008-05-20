From: akpm@linux-foundation.org
Subject: + watchdog-indydog-clean-up-and-tidy.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:02 -0700
Message-ID: <200805200828.m4K8S2u3013116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760267AbYETI2U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: indydog: Clean up and tidy
has been added to the -mm tree.  Its filename is
     watchdog-indydog-clean-up-and-tidy.patch

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
Subject: watchdog: indydog: Clean up and tidy
From: Alan Cox <alan@redhat.com>

Switch to unlocked_ioctl as well

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/indydog.c |  114 +++++++++++++++++++----------------
 1 file changed, 62 insertions(+), 52 deletions(-)

diff -puN drivers/watchdog/indydog.c~watchdog-indydog-clean-up-and-tidy drivers/watchdog/indydog.c
--- a/drivers/watchdog/indydog.c~watchdog-indydog-clean-up-and-tidy
+++ a/drivers/watchdog/indydog.c
@@ -1,7 +1,8 @@
 /*
  *	IndyDog	0.3	A Hardware Watchdog Device for SGI IP22
  *
- *	(c) Copyright 2002 Guido Guenther <agx@sigxcpu.org>, All Rights Reserved.
+ *	(c) Copyright 2002 Guido Guenther <agx@sigxcpu.org>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -22,32 +23,42 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/sgi/mc.h>
 
 #define PFX "indydog: "
-static int indydog_alive;
+static unsigned long indydog_alive;
+static spinlock_t indydog_lock;
 
 #define WATCHDOG_TIMEOUT 30		/* 30 sec default timeout */
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void indydog_start(void)
 {
-	u32 mc_ctrl0 = sgimc->cpuctrl0;
+	u32 mc_ctrl0;
 
+	spin_lock(&indydog_lock);
+	mc_ctrl0 = sgimc->cpuctrl0;
 	mc_ctrl0 = sgimc->cpuctrl0 | SGIMC_CCTRL0_WDOG;
 	sgimc->cpuctrl0 = mc_ctrl0;
+	spin_unlock(&indydog_lock);
 }
 
 static void indydog_stop(void)
 {
-	u32 mc_ctrl0 = sgimc->cpuctrl0;
+	u32 mc_ctrl0;
 
+	spin_lock(&indydog_lock);
+
+	mc_ctrl0 = sgimc->cpuctrl0;
 	mc_ctrl0 &= ~SGIMC_CCTRL0_WDOG;
 	sgimc->cpuctrl0 = mc_ctrl0;
+	spin_unlock(&indydog_lock);
 
 	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
 }
@@ -62,7 +73,7 @@ static void indydog_ping(void)
  */
 static int indydog_open(struct inode *inode, struct file *file)
 {
-	if (indydog_alive)
+	if (test_and_set_bit(0, &indydog_alive))
 		return -EBUSY;
 
 	if (nowayout)
@@ -84,23 +95,21 @@ static int indydog_release(struct inode 
 	 * Lock it in if it's a module and we defined ...NOWAYOUT */
 	if (!nowayout)
 		indydog_stop();		/* Turn the WDT off */
-
-	indydog_alive = 0;
-
+	clear_bit(0, &indydog_alive);
 	return 0;
 }
 
-static ssize_t indydog_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t indydog_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	/* Refresh the timer. */
-	if (len) {
+	if (len)
 		indydog_ping();
-	}
 	return len;
 }
 
-static int indydog_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long indydog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int options, retval = -EINVAL;
 	static struct watchdog_info ident = {
@@ -111,42 +120,40 @@ static int indydog_ioctl(struct inode *i
 	};
 
 	switch (cmd) {
-		default:
-			return -ENOTTY;
-		case WDIOC_GETSUPPORT:
-			if (copy_to_user((struct watchdog_info *)arg,
-					 &ident, sizeof(ident)))
-				return -EFAULT;
-			return 0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0,(int *)arg);
-		case WDIOC_KEEPALIVE:
-			indydog_ping();
-			return 0;
-		case WDIOC_GETTIMEOUT:
-			return put_user(WATCHDOG_TIMEOUT,(int *)arg);
-		case WDIOC_SETOPTIONS:
-		{
-			if (get_user(options, (int *)arg))
-				return -EFAULT;
-
-			if (options & WDIOS_DISABLECARD) {
-				indydog_stop();
-				retval = 0;
-			}
-
-			if (options & WDIOS_ENABLECARD) {
-				indydog_start();
-				retval = 0;
-			}
-
-			return retval;
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user((struct watchdog_info *)arg,
+				 &ident, sizeof(ident)))
+			return -EFAULT;
+		return 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, (int *)arg);
+	case WDIOC_KEEPALIVE:
+		indydog_ping();
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		return put_user(WATCHDOG_TIMEOUT, (int *)arg);
+	case WDIOC_SETOPTIONS:
+	{
+		if (get_user(options, (int *)arg))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			indydog_stop();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			indydog_start();
+			retval = 0;
 		}
+		return retval;
+	}
+	default:
+		return -ENOTTY;
 	}
 }
 
-static int indydog_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int indydog_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
 		indydog_stop();		/* Turn the WDT off */
@@ -158,7 +165,7 @@ static const struct file_operations indy
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= indydog_write,
-	.ioctl		= indydog_ioctl,
+	.unlocked_ioctl	= indydog_ioctl,
 	.open		= indydog_open,
 	.release	= indydog_release,
 };
@@ -180,17 +187,20 @@ static int __init watchdog_init(void)
 {
 	int ret;
 
+	spin_lock_init(&indydog_lock);
+
 	ret = register_reboot_notifier(&indydog_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&indydog_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&indydog_notifier);
 		return ret;
 	}
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

