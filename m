From: akpm@linux-foundation.org
Subject: - watchdog-indydog-clean-up-and-tidy.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:09 -0700
Message-ID: <200807162136.m6GLa9bb014167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394AbYGPVjg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:39:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: indydog: Clean up and tidy
has been removed from the -mm tree.  Its filename was
     watchdog-indydog-clean-up-and-tidy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
ia64-hp-sim-simserialc-adapt-to-new-tty-framework.patch
remove-is_tty.patch
mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch
hamradio-add-missing-sanity-check-to-tty-operation.patch
git-watchdog.patch
serial-8250_gscc-add-module_license.patch
serial-add-support-for-a-no-name-4-ports-multiserial-card.patch
istallion-remove-unused-variable.patch
stallion-removed-unused-variable.patch
spidev-bkl-removal.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
unexport-proc_clear_tty.patch

