From: akpm@linux-foundation.org
Subject: + watchdog-mpcore-watchdog-unlocked_ioctl-and-bkl-work.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:18 -0700
Message-ID: <200805200828.m4K8SISK013146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760874AbYETI2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: mpcore watchdog: unlocked_ioctl and BKl work
has been added to the -mm tree.  Its filename is
     watchdog-mpcore-watchdog-unlocked_ioctl-and-bkl-work.patch

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
Subject: watchdog: mpcore watchdog: unlocked_ioctl and BKl work
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/mpcore_wdt.c |   53 +++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff -puN drivers/watchdog/mpcore_wdt.c~watchdog-mpcore-watchdog-unlocked_ioctl-and-bkl-work drivers/watchdog/mpcore_wdt.c
--- a/drivers/watchdog/mpcore_wdt.c~watchdog-mpcore-watchdog-unlocked_ioctl-and-bkl-work
+++ a/drivers/watchdog/mpcore_wdt.c
@@ -29,9 +29,9 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/uaccess.h>
 
 #include <asm/hardware/arm_twd.h>
-#include <asm/uaccess.h>
 
 struct mpcore_wdt {
 	unsigned long	timer_alive;
@@ -43,17 +43,20 @@ struct mpcore_wdt {
 };
 
 static struct platform_device *mpcore_wdt_dev;
-
 extern unsigned int mpcore_timer_rate;
 
 #define TIMER_MARGIN	60
 static int mpcore_margin = TIMER_MARGIN;
 module_param(mpcore_margin, int, 0);
-MODULE_PARM_DESC(mpcore_margin, "MPcore timer margin in seconds. (0<mpcore_margin<65536, default=" __MODULE_STRING(TIMER_MARGIN) ")");
+MODULE_PARM_DESC(mpcore_margin,
+	"MPcore timer margin in seconds. (0 < mpcore_margin < 65536, default="
+				__MODULE_STRING(TIMER_MARGIN) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #define ONLY_TESTING	0
 static int mpcore_noboot = ONLY_TESTING;
@@ -70,14 +73,12 @@ static irqreturn_t mpcore_wdt_fire(int i
 
 	/* Check it really was our interrupt */
 	if (readl(wdt->base + TWD_WDOG_INTSTAT)) {
-		dev_printk(KERN_CRIT, wdt->dev, "Triggered - Reboot ignored.\n");
-
+		dev_printk(KERN_CRIT, wdt->dev,
+					"Triggered - Reboot ignored.\n");
 		/* Clear the interrupt on the watchdog */
 		writel(1, wdt->base + TWD_WDOG_INTSTAT);
-
 		return IRQ_HANDLED;
 	}
-
 	return IRQ_NONE;
 }
 
@@ -96,22 +97,26 @@ static void mpcore_wdt_keepalive(struct 
 	count = (mpcore_timer_rate / 256) * mpcore_margin;
 
 	/* Reload the counter */
+	spin_lock(&wdt_lock);
 	writel(count + wdt->perturb, wdt->base + TWD_WDOG_LOAD);
-
 	wdt->perturb = wdt->perturb ? 0 : 1;
+	spin_unlock(&wdt_lock);
 }
 
 static void mpcore_wdt_stop(struct mpcore_wdt *wdt)
 {
+	spin_lock(&wdt_lock);
 	writel(0x12345678, wdt->base + TWD_WDOG_DISABLE);
 	writel(0x87654321, wdt->base + TWD_WDOG_DISABLE);
 	writel(0x0, wdt->base + TWD_WDOG_CONTROL);
+	spin_unlock(&wdt_lock);
 }
 
 static void mpcore_wdt_start(struct mpcore_wdt *wdt)
 {
 	dev_printk(KERN_INFO, wdt->dev, "enabling watchdog.\n");
 
+	spin_lock(&wdt_lock);
 	/* This loads the count register but does NOT start the count yet */
 	mpcore_wdt_keepalive(wdt);
 
@@ -122,6 +127,7 @@ static void mpcore_wdt_start(struct mpco
 		/* Enable watchdog - prescale=256, watchdog mode=1, enable=1 */
 		writel(0x0000FF09, wdt->base + TWD_WDOG_CONTROL);
 	}
+	spin_unlock(&wdt_lock);
 }
 
 static int mpcore_wdt_set_heartbeat(int t)
@@ -164,10 +170,11 @@ static int mpcore_wdt_release(struct ino
 	 *	Shut off the timer.
 	 * 	Lock it in if it's a module and we set nowayout
 	 */
-	if (wdt->expect_close == 42) {
+	if (wdt->expect_close == 42)
 		mpcore_wdt_stop(wdt);
-	} else {
-		dev_printk(KERN_CRIT, wdt->dev, "unexpected close, not stopping watchdog!\n");
+	else {
+		dev_printk(KERN_CRIT, wdt->dev,
+				"unexpected close, not stopping watchdog!\n");
 		mpcore_wdt_keepalive(wdt);
 	}
 	clear_bit(0, &wdt->timer_alive);
@@ -175,7 +182,8 @@ static int mpcore_wdt_release(struct ino
 	return 0;
 }
 
-static ssize_t mpcore_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t mpcore_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	struct mpcore_wdt *wdt = file->private_data;
 
@@ -210,8 +218,8 @@ static struct watchdog_info ident = {
 	.identity		= "MPcore Watchdog",
 };
 
-static int mpcore_wdt_ioctl(struct inode *inode, struct file *file,
-			     unsigned int cmd, unsigned long arg)
+static long mpcore_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	struct mpcore_wdt *wdt = file->private_data;
 	int ret;
@@ -301,7 +309,7 @@ static const struct file_operations mpco
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= mpcore_wdt_write,
-	.ioctl		= mpcore_wdt_ioctl,
+	.unlocked_ioctl	= mpcore_wdt_ioctl,
 	.open		= mpcore_wdt_open,
 	.release	= mpcore_wdt_release,
 };
@@ -349,14 +357,17 @@ static int __devinit mpcore_wdt_probe(st
 	mpcore_wdt_miscdev.parent = &dev->dev;
 	ret = misc_register(&mpcore_wdt_miscdev);
 	if (ret) {
-		dev_printk(KERN_ERR, _dev, "cannot register miscdev on minor=%d (err=%d)\n",
-			   WATCHDOG_MINOR, ret);
+		dev_printk(KERN_ERR, _dev,
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto err_misc;
 	}
 
-	ret = request_irq(wdt->irq, mpcore_wdt_fire, IRQF_DISABLED, "mpcore_wdt", wdt);
+	ret = request_irq(wdt->irq, mpcore_wdt_fire, IRQF_DISABLED,
+							"mpcore_wdt", wdt);
 	if (ret) {
-		dev_printk(KERN_ERR, _dev, "cannot register IRQ%d for watchdog\n", wdt->irq);
+		dev_printk(KERN_ERR, _dev,
+			"cannot register IRQ%d for watchdog\n", wdt->irq);
 		goto err_irq;
 	}
 
@@ -415,7 +426,7 @@ static int __init mpcore_wdt_init(void)
 	 */
 	if (mpcore_wdt_set_heartbeat(mpcore_margin)) {
 		mpcore_wdt_set_heartbeat(TIMER_MARGIN);
-		printk(KERN_INFO "mpcore_margin value must be 0<mpcore_margin<65536, using %d\n",
+		printk(KERN_INFO "mpcore_margin value must be 0 < mpcore_margin < 65536, using %d\n",
 			TIMER_MARGIN);
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

