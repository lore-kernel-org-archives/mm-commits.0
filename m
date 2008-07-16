From: akpm@linux-foundation.org
Subject: - watchdog-mpcore-watchdog-unlocked_ioctl-and-bkl-work.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:29 -0700
Message-ID: <200807162136.m6GLaTQG014209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757198AbYGPVhS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: mpcore watchdog: unlocked_ioctl and BKl work
has been removed from the -mm tree.  Its filename was
     watchdog-mpcore-watchdog-unlocked_ioctl-and-bkl-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

