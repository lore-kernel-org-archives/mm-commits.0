From: akpm@linux-foundation.org
Subject: - watchdog-iop-watchdog-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:11 -0700
Message-ID: <200807162136.m6GLaBmj014170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757048AbYGPVgy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:36:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: iop: watchdog switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-iop-watchdog-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: iop: watchdog switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/iop_wdt.c |   46 ++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff -puN drivers/watchdog/iop_wdt.c~watchdog-iop-watchdog-switch-to-unlocked_ioctl drivers/watchdog/iop_wdt.c
--- a/drivers/watchdog/iop_wdt.c~watchdog-iop-watchdog-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/iop_wdt.c
@@ -37,6 +37,7 @@
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned long wdt_status;
 static unsigned long boot_status;
+static spinlock_t wdt_lock;
 
 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
@@ -68,8 +69,10 @@ static void wdt_enable(void)
 	/* Arm and enable the Timer to starting counting down from 0xFFFF.FFFF
 	 * Takes approx. 10.7s to timeout
 	 */
+	spin_lock(&wdt_lock);
 	write_wdtcr(IOP_WDTCR_EN_ARM);
 	write_wdtcr(IOP_WDTCR_EN);
+	spin_unlock(&wdt_lock);
 }
 
 /* returns 0 if the timer was successfully disabled */
@@ -77,9 +80,11 @@ static int wdt_disable(void)
 {
 	/* Stop Counting */
 	if (wdt_supports_disable()) {
+		spin_lock(&wdt_lock);
 		write_wdtcr(IOP_WDTCR_DIS_ARM);
 		write_wdtcr(IOP_WDTCR_DIS);
 		clear_bit(WDT_ENABLED, &wdt_status);
+		spin_unlock(&wdt_lock);
 		printk(KERN_INFO "WATCHDOG: Disabled\n");
 		return 0;
 	} else
@@ -92,16 +97,12 @@ static int iop_wdt_open(struct inode *in
 		return -EBUSY;
 
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
 	wdt_enable();
-
 	set_bit(WDT_ENABLED, &wdt_status);
-
 	return nonseekable_open(inode, file);
 }
 
-static ssize_t
-iop_wdt_write(struct file *file, const char *data, size_t len,
+static ssize_t iop_wdt_write(struct file *file, const char *data, size_t len,
 		  loff_t *ppos)
 {
 	if (len) {
@@ -121,41 +122,39 @@ iop_wdt_write(struct file *file, const c
 		}
 		wdt_enable();
 	}
-
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
 	.identity = "iop watchdog",
 };
 
-static int
-iop_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		  unsigned long arg)
+static long iop_wdt_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	int options;
 	int ret = -ENOTTY;
+	int __user *argp = (int __user *)arg;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user
-		    ((struct watchdog_info *)arg, &ident, sizeof ident))
+		if (copy_to_user(argp, &ident, sizeof ident))
 			ret = -EFAULT;
 		else
 			ret = 0;
 		break;
 
 	case WDIOC_GETSTATUS:
-		ret = put_user(0, (int *)arg);
+		ret = put_user(0, argp);
 		break;
 
 	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(boot_status, (int *)arg);
+		ret = put_user(boot_status, argp);
 		break;
 
 	case WDIOC_GETTIMEOUT:
-		ret = put_user(iop_watchdog_timeout(), (int *)arg);
+		ret = put_user(iop_watchdog_timeout(), argp);
 		break;
 
 	case WDIOC_KEEPALIVE:
@@ -177,14 +176,12 @@ iop_wdt_ioctl(struct inode *inode, struc
 			} else
 				ret = 0;
 		}
-
 		if (options & WDIOS_ENABLECARD) {
 			wdt_enable();
 			ret = 0;
 		}
 		break;
 	}
-
 	return ret;
 }
 
@@ -214,7 +211,7 @@ static const struct file_operations iop_
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = iop_wdt_write,
-	.ioctl = iop_wdt_ioctl,
+	.unlocked_ioctl = iop_wdt_ioctl,
 	.open = iop_wdt_open,
 	.release = iop_wdt_release,
 };
@@ -229,10 +226,8 @@ static int __init iop_wdt_init(void)
 {
 	int ret;
 
-	ret = misc_register(&iop_wdt_miscdev);
-	if (ret == 0)
-		printk("iop watchdog timer: timeout %lu sec\n",
-		       iop_watchdog_timeout());
+	spin_lock_init(&wdt_lock);
+
 
 	/* check if the reset was caused by the watchdog timer */
 	boot_status = (read_rcsr() & IOP_RCSR_WDT) ? WDIOF_CARDRESET : 0;
@@ -242,6 +237,13 @@ static int __init iop_wdt_init(void)
 	 */
 	write_wdtsr(IOP13XX_WDTCR_IB_RESET);
 
+	/* Register after we have the device set up so we cannot race
+	   with an open */
+	ret = misc_register(&iop_wdt_miscdev);
+	if (ret == 0)
+		printk("iop watchdog timer: timeout %lu sec\n",
+		       iop_watchdog_timeout());
+
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

