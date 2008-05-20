From: akpm@linux-foundation.org
Subject: + watchdog-clean-acquirewdt-and-check-for-bkl-dependancies.patch added to -mm tree
Date: Tue, 20 May 2008 01:27:39 -0700
Message-ID: <200805200827.m4K8RdRu013038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757795AbYETI2B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: clean acquirewdt and check for BKL dependancies
has been added to the -mm tree.  Its filename is
     watchdog-clean-acquirewdt-and-check-for-bkl-dependancies.patch

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
Subject: watchdog: clean acquirewdt and check for BKL dependancies
From: Alan Cox <alan@redhat.com>

This brings the file into line with coding style.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/acquirewdt.c |  119 +++++++++++++++-----------------
 1 file changed, 58 insertions(+), 61 deletions(-)

diff -puN drivers/watchdog/acquirewdt.c~watchdog-clean-acquirewdt-and-check-for-bkl-dependancies drivers/watchdog/acquirewdt.c
--- a/drivers/watchdog/acquirewdt.c~watchdog-clean-acquirewdt-and-check-for-bkl-dependancies
+++ a/drivers/watchdog/acquirewdt.c
@@ -58,39 +58,46 @@
 #include <linux/types.h>		/* For standard types (like size_t) */
 #include <linux/errno.h>		/* For the -ENODEV/... values */
 #include <linux/kernel.h>		/* For printk/panic/... */
-#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) */
+#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV
+							(WATCHDOG_MINOR) */
 #include <linux/watchdog.h>		/* For the watchdog specific items */
 #include <linux/fs.h>			/* For file operations */
 #include <linux/ioport.h>		/* For io-port access */
 #include <linux/platform_device.h>	/* For platform_driver framework */
 #include <linux/init.h>			/* For __init/__exit/... */
 
-#include <asm/uaccess.h>		/* For copy_to_user/put_user/... */
-#include <asm/io.h>			/* For inb/outb/... */
+#include <linux/uaccess.h>		/* For copy_to_user/put_user/... */
+#include <linux/io.h>			/* For inb/outb/... */
 
 /* Module information */
 #define DRV_NAME "acquirewdt"
 #define PFX DRV_NAME ": "
 #define WATCHDOG_NAME "Acquire WDT"
-#define WATCHDOG_HEARTBEAT 0	/* There is no way to see what the correct time-out period is */
+/* There is no way to see what the correct time-out period is */
+#define WATCHDOG_HEARTBEAT 0
 
 /* internal variables */
-static struct platform_device *acq_platform_device;	/* the watchdog platform device */
+/* the watchdog platform device */
+static struct platform_device *acq_platform_device;
 static unsigned long acq_is_open;
 static char expect_close;
 
 /* module parameters */
-static int wdt_stop = 0x43;	/* You must set this - there is no sane way to probe for this board. */
+/* You must set this - there is no sane way to probe for this board. */
+static int wdt_stop = 0x43;
 module_param(wdt_stop, int, 0);
 MODULE_PARM_DESC(wdt_stop, "Acquire WDT 'stop' io port (default 0x43)");
 
-static int wdt_start = 0x443;	/* You must set this - there is no sane way to probe for this board. */
+/* You must set this - there is no sane way to probe for this board. */
+static int wdt_start = 0x443;
 module_param(wdt_start, int, 0);
 MODULE_PARM_DESC(wdt_start, "Acquire WDT 'start' io port (default 0x443)");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+	__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Watchdog Operations
@@ -112,18 +119,18 @@ static void acq_stop(void)
  *	/dev/watchdog handling
  */
 
-static ssize_t acq_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t acq_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-	if(count) {
+	if (count) {
 		if (!nowayout) {
 			size_t i;
-
 			/* note: just in case someone wrote the magic character
 			 * five months ago... */
 			expect_close = 0;
-
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the
+			   magic character */
 			for (i = 0; i != count; i++) {
 				char c;
 				if (get_user(c, buf + i))
@@ -132,64 +139,55 @@ static ssize_t acq_write(struct file *fi
 					expect_close = 42;
 			}
 		}
-
-		/* Well, anyhow someone wrote to us, we should return that favour */
+		/* Well, anyhow someone wrote to us, we should
+				return that favour */
 		acq_keepalive();
 	}
 	return count;
 }
 
-static int acq_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	unsigned long arg)
+static long acq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int options, retval = -EINVAL;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident =
-	{
+	static struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = WATCHDOG_NAME,
 	};
 
-	switch(cmd)
-	{
+	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-	  return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-	  return put_user(0, p);
+		return put_user(0, p);
 
 	case WDIOC_KEEPALIVE:
-	  acq_keepalive();
-	  return 0;
+		acq_keepalive();
+		return 0;
 
 	case WDIOC_GETTIMEOUT:
 	  return put_user(WATCHDOG_HEARTBEAT, p);
 
 	case WDIOC_SETOPTIONS:
 	{
-	    if (get_user(options, p))
-	      return -EFAULT;
-
-	    if (options & WDIOS_DISABLECARD)
-	    {
-	      acq_stop();
-	      retval = 0;
-	    }
-
-	    if (options & WDIOS_ENABLECARD)
-	    {
-	      acq_keepalive();
-	      retval = 0;
-	    }
-
-	    return retval;
+		if (get_user(options, p))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			acq_stop();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			acq_keepalive();
+			retval = 0;
+		}
+		return retval;
 	}
-
 	default:
-	  return -ENOTTY;
+		return -ENOTTY;
 	}
 }
 
@@ -211,7 +209,8 @@ static int acq_close(struct inode *inode
 	if (expect_close == 42) {
 		acq_stop();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		acq_keepalive();
 	}
 	clear_bit(0, &acq_is_open);
@@ -227,7 +226,7 @@ static const struct file_operations acq_
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= acq_write,
-	.ioctl		= acq_ioctl,
+	.unlocked_ioctl	= acq_ioctl,
 	.open		= acq_open,
 	.release	= acq_close,
 };
@@ -248,32 +247,29 @@ static int __devinit acq_probe(struct pl
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
-			printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-				wdt_stop);
+			printk(KERN_ERR PFX
+			    "I/O address 0x%04x already in use\n", wdt_stop);
 			ret = -EIO;
 			goto out;
 		}
 	}
 
 	if (!request_region(wdt_start, 1, WATCHDOG_NAME)) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			wdt_start);
 		ret = -EIO;
 		goto unreg_stop;
 	}
-
 	ret = misc_register(&acq_miscdev);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto unreg_regions;
 	}
-
-	printk (KERN_INFO PFX "initialized. (nowayout=%d)\n",
-		nowayout);
+	printk(KERN_INFO PFX "initialized. (nowayout=%d)\n", nowayout);
 
 	return 0;
-
 unreg_regions:
 	release_region(wdt_start, 1);
 unreg_stop:
@@ -286,9 +282,9 @@ out:
 static int __devexit acq_remove(struct platform_device *dev)
 {
 	misc_deregister(&acq_miscdev);
-	release_region(wdt_start,1);
-	if(wdt_stop != wdt_start)
-		release_region(wdt_stop,1);
+	release_region(wdt_start, 1);
+	if (wdt_stop != wdt_start)
+		release_region(wdt_stop, 1);
 
 	return 0;
 }
@@ -313,18 +309,19 @@ static int __init acq_init(void)
 {
 	int err;
 
-	printk(KERN_INFO "WDT driver for Acquire single board computer initialising.\n");
+	printk(KERN_INFO
+	      "WDT driver for Acquire single board computer initialising.\n");
 
 	err = platform_driver_register(&acquirewdt_driver);
 	if (err)
 		return err;
 
-	acq_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	acq_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(acq_platform_device)) {
 		err = PTR_ERR(acq_platform_device);
 		goto unreg_platform_driver;
 	}
-
 	return 0;
 
 unreg_platform_driver:
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

