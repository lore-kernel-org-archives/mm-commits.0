From: akpm@linux-foundation.org
Subject: + watchdog-iop-watchdog-switch-to-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:04 -0700
Message-ID: <200805200828.m4K8S4QI013119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760147AbYETI2W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: iop: watchdog switch to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-iop-watchdog-switch-to-unlocked_ioctl.patch

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

