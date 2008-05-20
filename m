From: akpm@linux-foundation.org
Subject: + watchdog-ib700wdt-clean-up-and-switch-to-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:27:56 -0700
Message-ID: <200805200827.m4K8Ru2r013101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760244AbYETI2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: ib700wdt: clean up and switch to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-ib700wdt-clean-up-and-switch-to-unlocked_ioctl.patch

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
Subject: watchdog: ib700wdt: clean up and switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/ib700wdt.c |  103 +++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 51 deletions(-)

diff -puN drivers/watchdog/ib700wdt.c~watchdog-ib700wdt-clean-up-and-switch-to-unlocked_ioctl drivers/watchdog/ib700wdt.c
--- a/drivers/watchdog/ib700wdt.c~watchdog-ib700wdt-clean-up-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/ib700wdt.c
@@ -42,8 +42,8 @@
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/system.h>
 
 static struct platform_device *ibwdt_platform_device;
@@ -120,7 +120,9 @@ static int wd_margin = WD_TIMO;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 
 /*
@@ -165,8 +167,8 @@ ibwdt_set_heartbeat(int t)
  *	/dev/watchdog handling
  */
 
-static ssize_t
-ibwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t ibwdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -188,77 +190,71 @@ ibwdt_write(struct file *file, const cha
 	return count;
 }
 
-static int
-ibwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long ibwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_margin;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 
 	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "IB700 WDT",
 	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-	  if (copy_to_user(argp, &ident, sizeof(ident)))
-	    return -EFAULT;
-	  break;
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-	  return put_user(0, p);
+		return put_user(0, p);
 
 	case WDIOC_KEEPALIVE:
-	  ibwdt_ping();
-	  break;
+		ibwdt_ping();
+		break;
 
 	case WDIOC_SETTIMEOUT:
-	  if (get_user(new_margin, p))
-		  return -EFAULT;
-	  if (ibwdt_set_heartbeat(new_margin))
-		  return -EINVAL;
-	  ibwdt_ping();
-	  /* Fall */
+		if (get_user(new_margin, p))
+			return -EFAULT;
+		if (ibwdt_set_heartbeat(new_margin))
+			return -EINVAL;
+		ibwdt_ping();
+		/* Fall */
 
 	case WDIOC_GETTIMEOUT:
-	  return put_user(wd_times[wd_margin], p);
+		return put_user(wd_times[wd_margin], p);
 
 	case WDIOC_SETOPTIONS:
 	{
-	  int options, retval = -EINVAL;
+		int options, retval = -EINVAL;
 
-	  if (get_user(options, p))
-	    return -EFAULT;
+		if (get_user(options, p))
+			return -EFAULT;
 
-	  if (options & WDIOS_DISABLECARD) {
-	    ibwdt_disable();
-	    retval = 0;
-	  }
-
-	  if (options & WDIOS_ENABLECARD) {
-	    ibwdt_ping();
-	    retval = 0;
-	  }
-
-	  return retval;
+		if (options & WDIOS_DISABLECARD) {
+			ibwdt_disable();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			ibwdt_ping();
+			retval = 0;
+		}
+		return retval;
 	}
-
 	default:
-	  return -ENOTTY;
+		return -ENOTTY;
 	}
 	return 0;
 }
 
-static int
-ibwdt_open(struct inode *inode, struct file *file)
+static int ibwdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &ibwdt_is_open)) {
+	if (test_and_set_bit(0, &ibwdt_is_open))
 		return -EBUSY;
-	}
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
@@ -273,7 +269,8 @@ ibwdt_close(struct inode *inode, struct 
 	if (expect_close == 42) {
 		ibwdt_disable();
 	} else {
-		printk(KERN_CRIT PFX "WDT device closed unexpectedly.  WDT will not stop!\n");
+		printk(KERN_CRIT PFX
+		     "WDT device closed unexpectedly.  WDT will not stop!\n");
 		ibwdt_ping();
 	}
 	clear_bit(0, &ibwdt_is_open);
@@ -289,7 +286,7 @@ static const struct file_operations ibwd
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= ibwdt_write,
-	.ioctl		= ibwdt_ioctl,
+	.unlocked_ioctl	= ibwdt_ioctl,
 	.open		= ibwdt_open,
 	.release	= ibwdt_close,
 };
@@ -310,21 +307,23 @@ static int __devinit ibwdt_probe(struct 
 
 #if WDT_START != WDT_STOP
 	if (!request_region(WDT_STOP, 1, "IB700 WDT")) {
-		printk (KERN_ERR PFX "STOP method I/O %X is not available.\n", WDT_STOP);
+		printk(KERN_ERR PFX "STOP method I/O %X is not available.\n",
+								WDT_STOP);
 		res = -EIO;
 		goto out_nostopreg;
 	}
 #endif
 
 	if (!request_region(WDT_START, 1, "IB700 WDT")) {
-		printk (KERN_ERR PFX "START method I/O %X is not available.\n", WDT_START);
+		printk(KERN_ERR PFX "START method I/O %X is not available.\n",
+								WDT_START);
 		res = -EIO;
 		goto out_nostartreg;
 	}
 
 	res = misc_register(&ibwdt_miscdev);
 	if (res) {
-		printk (KERN_ERR PFX "failed to register misc device\n");
+		printk(KERN_ERR PFX "failed to register misc device\n");
 		goto out_nomisc;
 	}
 	return 0;
@@ -342,9 +341,9 @@ out_nostopreg:
 static int __devexit ibwdt_remove(struct platform_device *dev)
 {
 	misc_deregister(&ibwdt_miscdev);
-	release_region(WDT_START,1);
+	release_region(WDT_START, 1);
 #if WDT_START != WDT_STOP
-	release_region(WDT_STOP,1);
+	release_region(WDT_STOP, 1);
 #endif
 	return 0;
 }
@@ -369,13 +368,15 @@ static int __init ibwdt_init(void)
 {
 	int err;
 
-	printk(KERN_INFO PFX "WDT driver for IB700 single board computer initialising.\n");
+	printk(KERN_INFO PFX
+		"WDT driver for IB700 single board computer initialising.\n");
 
 	err = platform_driver_register(&ibwdt_driver);
 	if (err)
 		return err;
 
-	ibwdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	ibwdt_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(ibwdt_platform_device)) {
 		err = PTR_ERR(ibwdt_platform_device);
 		goto unreg_platform_driver;
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

