From: akpm@linux-foundation.org
Subject: + watchdog-clean-up-and-check-advantech-watchdog.patch added to -mm tree
Date: Tue, 20 May 2008 01:27:41 -0700
Message-ID: <200805200827.m4K8Rf4k013041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758525AbYETI2C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: clean up and check advantech watchdog
has been added to the -mm tree.  Its filename is
     watchdog-clean-up-and-check-advantech-watchdog.patch

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
Subject: watchdog: clean up and check advantech watchdog
From: Alan Cox <alan@redhat.com>

Clean up the advantech watchdog code and inspect for BKL problems

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/advantechwdt.c |  133 +++++++++++++-----------------
 1 file changed, 61 insertions(+), 72 deletions(-)

diff -puN drivers/watchdog/advantechwdt.c~watchdog-clean-up-and-check-advantech-watchdog drivers/watchdog/advantechwdt.c
--- a/drivers/watchdog/advantechwdt.c~watchdog-clean-up-and-check-advantech-watchdog
+++ a/drivers/watchdog/advantechwdt.c
@@ -72,35 +72,35 @@ MODULE_PARM_DESC(wdt_start, "Advantech W
 
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=63, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. 1<= timeout <=63, default="
+		__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Watchdog Operations
  */
 
-static void
-advwdt_ping(void)
+static void advwdt_ping(void)
 {
 	/* Write a watchdog value */
 	outb_p(timeout, wdt_start);
 }
 
-static void
-advwdt_disable(void)
+static void advwdt_disable(void)
 {
 	inb_p(wdt_stop);
 }
 
-static int
-advwdt_set_heartbeat(int t)
+static int advwdt_set_heartbeat(int t)
 {
-	if ((t < 1) || (t > 63))
+	if (t < 1 || t > 63)
 		return -EINVAL;
-
 	timeout = t;
 	return 0;
 }
@@ -109,8 +109,8 @@ advwdt_set_heartbeat(int t)
  *	/dev/watchdog handling
  */
 
-static ssize_t
-advwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t advwdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -131,9 +131,7 @@ advwdt_write(struct file *file, const ch
 	return count;
 }
 
-static int
-advwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long advwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
@@ -146,57 +144,50 @@ advwdt_ioctl(struct inode *inode, struct
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-	  if (copy_to_user(argp, &ident, sizeof(ident)))
-	    return -EFAULT;
-	  break;
+	if (copy_to_user(argp, &ident, sizeof(ident)))
+		return -EFAULT;
+		break;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-	  return put_user(0, p);
+		return put_user(0, p);
 
 	case WDIOC_KEEPALIVE:
-	  advwdt_ping();
-	  break;
+		advwdt_ping();
+		break;
 
 	case WDIOC_SETTIMEOUT:
-	  if (get_user(new_timeout, p))
-		  return -EFAULT;
-	  if (advwdt_set_heartbeat(new_timeout))
-		  return -EINVAL;
-	  advwdt_ping();
-	  /* Fall */
-
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (advwdt_set_heartbeat(new_timeout))
+			return -EINVAL;
+		advwdt_ping();
+		/* Fall */
 	case WDIOC_GETTIMEOUT:
-	  return put_user(timeout, p);
-
+		return put_user(timeout, p);
 	case WDIOC_SETOPTIONS:
 	{
-	  int options, retval = -EINVAL;
-
-	  if (get_user(options, p))
-	    return -EFAULT;
+		int options, retval = -EINVAL;
 
-	  if (options & WDIOS_DISABLECARD) {
-	    advwdt_disable();
-	    retval = 0;
-	  }
-
-	  if (options & WDIOS_ENABLECARD) {
-	    advwdt_ping();
-	    retval = 0;
-	  }
-
-	  return retval;
+		if (get_user(options, p))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			advwdt_disable();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			advwdt_ping();
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
-advwdt_open(struct inode *inode, struct file *file)
+static int advwdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(0, &advwdt_is_open))
 		return -EBUSY;
@@ -214,7 +205,8 @@ advwdt_close(struct inode *inode, struct
 	if (adv_expect_close == 42) {
 		advwdt_disable();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+				"Unexpected close, not stopping watchdog!\n");
 		advwdt_ping();
 	}
 	clear_bit(0, &advwdt_is_open);
@@ -230,7 +222,7 @@ static const struct file_operations advw
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= advwdt_write,
-	.ioctl		= advwdt_ioctl,
+	.unlocked_ioctl	= advwdt_ioctl,
 	.open		= advwdt_open,
 	.release	= advwdt_close,
 };
@@ -245,23 +237,24 @@ static struct miscdevice advwdt_miscdev 
  *	Init & exit routines
  */
 
-static int __devinit
-advwdt_probe(struct platform_device *dev)
+static int __devinit advwdt_probe(struct platform_device *dev)
 {
 	int ret;
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
-			printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-				wdt_stop);
+			printk (KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+								wdt_stop);
 			ret = -EIO;
 			goto out;
 		}
 	}
 
 	if (!request_region(wdt_start, 1, WATCHDOG_NAME)) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			wdt_start);
+		printk (KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+								wdt_start);
 		ret = -EIO;
 		goto unreg_stop;
 	}
@@ -269,20 +262,19 @@ advwdt_probe(struct platform_device *dev
 	/* Check that the heartbeat value is within it's range ; if not reset to the default */
 	if (advwdt_set_heartbeat(timeout)) {
 		advwdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk (KERN_INFO PFX "timeout value must be 1<=x<=63, using %d\n",
-			timeout);
+		printk (KERN_INFO PFX
+			"timeout value must be 1<=x<=63, using %d\n", timeout);
 	}
 
 	ret = misc_register(&advwdt_miscdev);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk (KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto unreg_regions;
 	}
-
 	printk (KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
-
 out:
 	return ret;
 unreg_regions:
@@ -293,8 +285,7 @@ unreg_stop:
 	goto out;
 }
 
-static int __devexit
-advwdt_remove(struct platform_device *dev)
+static int __devexit advwdt_remove(struct platform_device *dev)
 {
 	misc_deregister(&advwdt_miscdev);
 	release_region(wdt_start,1);
@@ -304,8 +295,7 @@ advwdt_remove(struct platform_device *de
 	return 0;
 }
 
-static void
-advwdt_shutdown(struct platform_device *dev)
+static void advwdt_shutdown(struct platform_device *dev)
 {
 	/* Turn the WDT off if we have a soft shutdown */
 	advwdt_disable();
@@ -321,8 +311,7 @@ static struct platform_driver advwdt_dri
 	},
 };
 
-static int __init
-advwdt_init(void)
+static int __init advwdt_init(void)
 {
 	int err;
 
@@ -332,7 +321,8 @@ advwdt_init(void)
 	if (err)
 		return err;
 
-	advwdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	advwdt_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(advwdt_platform_device)) {
 		err = PTR_ERR(advwdt_platform_device);
 		goto unreg_platform_driver;
@@ -345,8 +335,7 @@ unreg_platform_driver:
 	return err;
 }
 
-static void __exit
-advwdt_exit(void)
+static void __exit advwdt_exit(void)
 {
 	platform_device_unregister(advwdt_platform_device);
 	platform_driver_unregister(&advwdt_driver);
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

