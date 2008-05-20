From: akpm@linux-foundation.org
Subject: + watchdog-bfin-watchdog-cleanup-and-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:06 -0700
Message-ID: <200805200828.m4K8S6DY013125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760453AbYETI2Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: bfin: watchdog cleanup and unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-bfin-watchdog-cleanup-and-unlocked_ioctl.patch

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
Subject: watchdog: bfin: watchdog cleanup and unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Scan, tidy and check for unlocked_ioctl

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/bfin_wdt.c |  147 ++++++++++++++++------------------
 1 file changed, 71 insertions(+), 76 deletions(-)

diff -puN drivers/watchdog/bfin_wdt.c~watchdog-bfin-watchdog-cleanup-and-unlocked_ioctl drivers/watchdog/bfin_wdt.c
--- a/drivers/watchdog/bfin_wdt.c~watchdog-bfin-watchdog-cleanup-and-unlocked_ioctl
+++ a/drivers/watchdog/bfin_wdt.c
@@ -25,7 +25,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/blackfin.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
 #define stampit() stamp("here i am")
@@ -148,7 +148,8 @@ static int bfin_wdt_set_timeout(unsigned
 		int run = bfin_wdt_running();
 		bfin_wdt_stop();
 		bfin_write_WDOG_CNT(cnt);
-		if (run) bfin_wdt_start();
+		if (run)
+			bfin_wdt_start();
 	}
 	spin_unlock_irqrestore(&bfin_wdt_spinlock, flags);
 
@@ -191,16 +192,15 @@ static int bfin_wdt_release(struct inode
 {
 	stampit();
 
-	if (expect_close == 42) {
+	if (expect_close == 42)
 		bfin_wdt_stop();
-	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		bfin_wdt_keepalive();
 	}
-
 	expect_close = 0;
 	clear_bit(0, &open_check);
-
 	return 0;
 }
 
@@ -214,7 +214,7 @@ static int bfin_wdt_release(struct inode
  *	Pings the watchdog on write.
  */
 static ssize_t bfin_wdt_write(struct file *file, const char __user *data,
-                              size_t len, loff_t *ppos)
+						size_t len, loff_t *ppos)
 {
 	stampit();
 
@@ -241,7 +241,6 @@ static ssize_t bfin_wdt_write(struct fil
 
 /**
  *	bfin_wdt_ioctl - Query Device
- *	@inode: inode of device
  *	@file: file handle of device
  *	@cmd: watchdog command
  *	@arg: argument
@@ -249,8 +248,8 @@ static ssize_t bfin_wdt_write(struct fil
  *	Query basic information from the device or ping it, as outlined by the
  *	watchdog API.
  */
-static int bfin_wdt_ioctl(struct inode *inode, struct file *file,
-                          unsigned int cmd, unsigned long arg)
+static long bfin_wdt_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -258,59 +257,49 @@ static int bfin_wdt_ioctl(struct inode *
 	stampit();
 
 	switch (cmd) {
-		default:
-			return -ENOTTY;
-
-		case WDIOC_GETSUPPORT:
-			if (copy_to_user(argp, &bfin_wdt_info, sizeof(bfin_wdt_info)))
-				return -EFAULT;
-			else
-				return 0;
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(!!(_bfin_swrst & SWRST_RESET_WDOG), p);
-
-		case WDIOC_KEEPALIVE:
-			bfin_wdt_keepalive();
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &bfin_wdt_info, sizeof(bfin_wdt_info)))
+			return -EFAULT;
+		else
 			return 0;
-
-		case WDIOC_SETTIMEOUT: {
-			int new_timeout;
-
-			if (get_user(new_timeout, p))
-				return -EFAULT;
-
-			if (bfin_wdt_set_timeout(new_timeout))
-				return -EINVAL;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(!!(_bfin_swrst & SWRST_RESET_WDOG), p);
+	case WDIOC_KEEPALIVE:
+		bfin_wdt_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT: {
+		int new_timeout;
+
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (bfin_wdt_set_timeout(new_timeout))
+			return -EINVAL;
+	}
+	/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	case WDIOC_SETOPTIONS: {
+		unsigned long flags;
+		int options, ret = -EINVAL;
+
+		if (get_user(options, p))
+			return -EFAULT;
+
+		spin_lock_irqsave(&bfin_wdt_spinlock, flags);
+		if (options & WDIOS_DISABLECARD) {
+			bfin_wdt_stop();
+			ret = 0;
 		}
-			/* Fall */
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
-
-		case WDIOC_SETOPTIONS: {
-			unsigned long flags;
-			int options, ret = -EINVAL;
-
-			if (get_user(options, p))
-				return -EFAULT;
-
-			spin_lock_irqsave(&bfin_wdt_spinlock, flags);
-
-			if (options & WDIOS_DISABLECARD) {
-				bfin_wdt_stop();
-				ret = 0;
-			}
-
-			if (options & WDIOS_ENABLECARD) {
-				bfin_wdt_start();
-				ret = 0;
-			}
-
-			spin_unlock_irqrestore(&bfin_wdt_spinlock, flags);
-
-			return ret;
+		if (options & WDIOS_ENABLECARD) {
+			bfin_wdt_start();
+			ret = 0;
 		}
+		spin_unlock_irqrestore(&bfin_wdt_spinlock, flags);
+		return ret;
+	}
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -323,8 +312,8 @@ static int bfin_wdt_ioctl(struct inode *
  *	Handles specific events, such as turning off the watchdog during a
  *	shutdown event.
  */
-static int bfin_wdt_notify_sys(struct notifier_block *this, unsigned long code,
-                               void *unused)
+static int bfin_wdt_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
 	stampit();
 
@@ -379,12 +368,12 @@ static int bfin_wdt_resume(struct platfo
 #endif
 
 static const struct file_operations bfin_wdt_fops = {
-	.owner    = THIS_MODULE,
-	.llseek   = no_llseek,
-	.write    = bfin_wdt_write,
-	.ioctl    = bfin_wdt_ioctl,
-	.open     = bfin_wdt_open,
-	.release  = bfin_wdt_release,
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write    	= bfin_wdt_write,
+	.unlocked_ioctl	= bfin_wdt_ioctl,
+	.open		= bfin_wdt_open,
+	.release	= bfin_wdt_release,
 };
 
 static struct miscdevice bfin_wdt_miscdev = {
@@ -396,8 +385,8 @@ static struct miscdevice bfin_wdt_miscde
 static struct watchdog_info bfin_wdt_info = {
 	.identity = "Blackfin Watchdog",
 	.options  = WDIOF_SETTIMEOUT |
-	            WDIOF_KEEPALIVEPING |
-	            WDIOF_MAGICCLOSE,
+		    WDIOF_KEEPALIVEPING |
+		    WDIOF_MAGICCLOSE,
 };
 
 static struct notifier_block bfin_wdt_notifier = {
@@ -416,14 +405,16 @@ static int __devinit bfin_wdt_probe(stru
 
 	ret = register_reboot_notifier(&bfin_wdt_notifier);
 	if (ret) {
-		pr_devinit(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
+		pr_devinit(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&bfin_wdt_miscdev);
 	if (ret) {
-		pr_devinit(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-		       WATCHDOG_MINOR, ret);
+		pr_devinit(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+					WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&bfin_wdt_notifier);
 		return ret;
 	}
@@ -516,7 +507,11 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(timeout, uint, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=((2^32)/SCLK), default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1<=timeout<=((2^32)/SCLK), default="
+		__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
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

