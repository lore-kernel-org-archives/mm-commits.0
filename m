From: akpm@linux-foundation.org
Subject: + watchdog-mixcomwd-coding-style-locking-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:14 -0700
Message-ID: <200805200828.m4K8SE39013140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760365AbYETI2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: mixcomwd: coding style locking, unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-mixcomwd-coding-style-locking-unlocked_ioctl.patch

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
Subject: watchdog: mixcomwd: coding style locking, unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/mixcomwd.c |  133 ++++++++++++++++------------------
 1 file changed, 63 insertions(+), 70 deletions(-)

diff -puN drivers/watchdog/mixcomwd.c~watchdog-mixcomwd-coding-style-locking-unlocked_ioctl drivers/watchdog/mixcomwd.c
--- a/drivers/watchdog/mixcomwd.c~watchdog-mixcomwd-coding-style-locking-unlocked_ioctl
+++ a/drivers/watchdog/mixcomwd.c
@@ -29,7 +29,8 @@
  *		- support for one more type board
  *
  * Version 0.5 (2001/12/14) Matt Domsch <Matt_Domsch@dell.com>
- *		- added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
+ *		- added nowayout module option to override
+ *		  CONFIG_WATCHDOG_NOWAYOUT
  *
  * Version 0.6 (2002/04/12): Rob Radez <rob@osinvestor.com>
  *		- make mixcomwd_opened unsigned,
@@ -53,8 +54,8 @@
 #include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/timer.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 /*
  * We have two types of cards that can be probed:
@@ -108,18 +109,19 @@ static char expect_close;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void mixcomwd_ping(void)
 {
-	outb_p(55,watchdog_port);
+	outb_p(55, watchdog_port);
 	return;
 }
 
 static void mixcomwd_timerfun(unsigned long d)
 {
 	mixcomwd_ping();
-
 	mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
 }
 
@@ -129,22 +131,22 @@ static void mixcomwd_timerfun(unsigned l
 
 static int mixcomwd_open(struct inode *inode, struct file *file)
 {
-	if(test_and_set_bit(0,&mixcomwd_opened)) {
+	if (test_and_set_bit(0, &mixcomwd_opened))
 		return -EBUSY;
-	}
+
 	mixcomwd_ping();
 
-	if (nowayout) {
+	if (nowayout)
 		/*
 		 * fops_get() code via open() has already done
 		 * a try_module_get() so it is safe to do the
 		 * __module_get().
 		 */
 		__module_get(THIS_MODULE);
-	} else {
-		if(mixcomwd_timer_alive) {
+	else {
+		if (mixcomwd_timer_alive) {
 			del_timer(&mixcomwd_timer);
-			mixcomwd_timer_alive=0;
+			mixcomwd_timer_alive = 0;
 		}
 	}
 	return nonseekable_open(inode, file);
@@ -153,26 +155,27 @@ static int mixcomwd_open(struct inode *i
 static int mixcomwd_release(struct inode *inode, struct file *file)
 {
 	if (expect_close == 42) {
-		if(mixcomwd_timer_alive) {
-			printk(KERN_ERR PFX "release called while internal timer alive");
+		if (mixcomwd_timer_alive) {
+			printk(KERN_ERR PFX
+				"release called while internal timer alive");
 			return -EBUSY;
 		}
-		mixcomwd_timer_alive=1;
+		mixcomwd_timer_alive = 1;
 		mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
-	} else {
-		printk(KERN_CRIT PFX "WDT device closed unexpectedly.  WDT will not stop!\n");
-	}
+	} else
+		printk(KERN_CRIT PFX
+		    "WDT device closed unexpectedly.  WDT will not stop!\n");
 
-	clear_bit(0,&mixcomwd_opened);
-	expect_close=0;
+	clear_bit(0, &mixcomwd_opened);
+	expect_close = 0;
 	return 0;
 }
 
 
-static ssize_t mixcomwd_write(struct file *file, const char __user *data, size_t len, loff_t *ppos)
+static ssize_t mixcomwd_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
 {
-	if(len)
-	{
+	if (len) {
 		if (!nowayout) {
 			size_t i;
 
@@ -192,8 +195,8 @@ static ssize_t mixcomwd_write(struct fil
 	return len;
 }
 
-static int mixcomwd_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long mixcomwd_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -204,32 +207,23 @@ static int mixcomwd_ioctl(struct inode *
 		.identity = "MixCOM watchdog",
 	};
 
-	switch(cmd)
-	{
-		case WDIOC_GETSTATUS:
-			status=mixcomwd_opened;
-			if (!nowayout) {
-				status|=mixcomwd_timer_alive;
-			}
-			if (copy_to_user(p, &status, sizeof(int))) {
-				return -EFAULT;
-			}
-			break;
-		case WDIOC_GETBOOTSTATUS:
-			if (copy_to_user(p, &status, sizeof(int))) {
-				return -EFAULT;
-			}
-			break;
-		case WDIOC_GETSUPPORT:
-			if (copy_to_user(argp, &ident, sizeof(ident))) {
-				return -EFAULT;
-			}
-			break;
-		case WDIOC_KEEPALIVE:
-			mixcomwd_ping();
-			break;
-		default:
-			return -ENOTTY;
+	switch (cmd) {
+	case WDIOC_GETSTATUS:
+		status = mixcomwd_opened;
+		if (!nowayout)
+			status |= mixcomwd_timer_alive;
+		return put_user(status, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
+	case WDIOC_KEEPALIVE:
+		mixcomwd_ping();
+		break;
+	default:
+		return -ENOTTY;
 	}
 	return 0;
 }
@@ -238,7 +232,7 @@ static const struct file_operations mixc
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= mixcomwd_write,
-	.ioctl		= mixcomwd_ioctl,
+	.unlocked_ioctl	= mixcomwd_ioctl,
 	.open		= mixcomwd_open,
 	.release	= mixcomwd_release,
 };
@@ -253,15 +247,14 @@ static int __init checkcard(int port, in
 {
 	int id;
 
-	if (!request_region(port, 1, "MixCOM watchdog")) {
+	if (!request_region(port, 1, "MixCOM watchdog"))
 		return 0;
-	}
 
-	id=inb_p(port);
-	if (card_id==MIXCOM_ID)
+	id = inb_p(port);
+	if (card_id == MIXCOM_ID)
 		id &= 0x3f;
 
-	if (id!=card_id) {
+	if (id != card_id) {
 		release_region(port, 1);
 		return 0;
 	}
@@ -270,9 +263,7 @@ static int __init checkcard(int port, in
 
 static int __init mixcomwd_init(void)
 {
-	int i;
-	int ret;
-	int found=0;
+	int i, ret, found = 0;
 
 	for (i = 0; !found && mixcomwd_io_info[i].ioport != 0; i++) {
 		if (checkcard(mixcomwd_io_info[i].ioport,
@@ -283,20 +274,22 @@ static int __init mixcomwd_init(void)
 	}
 
 	if (!found) {
-		printk(KERN_ERR PFX "No card detected, or port not available.\n");
+		printk(KERN_ERR PFX
+			"No card detected, or port not available.\n");
 		return -ENODEV;
 	}
 
 	ret = misc_register(&mixcomwd_miscdev);
-	if (ret)
-	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+	if (ret) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+					WATCHDOG_MINOR, ret);
 		goto error_misc_register_watchdog;
 	}
 
-	printk(KERN_INFO "MixCOM watchdog driver v%s, watchdog port at 0x%3x\n",
-		VERSION, watchdog_port);
+	printk(KERN_INFO
+		"MixCOM watchdog driver v%s, watchdog port at 0x%3x\n",
+					VERSION, watchdog_port);
 
 	return 0;
 
@@ -309,15 +302,15 @@ error_misc_register_watchdog:
 static void __exit mixcomwd_exit(void)
 {
 	if (!nowayout) {
-		if(mixcomwd_timer_alive) {
+		if (mixcomwd_timer_alive) {
 			printk(KERN_WARNING PFX "I quit now, hardware will"
 			       " probably reboot!\n");
 			del_timer_sync(&mixcomwd_timer);
-			mixcomwd_timer_alive=0;
+			mixcomwd_timer_alive = 0;
 		}
 	}
 	misc_deregister(&mixcomwd_miscdev);
-	release_region(watchdog_port,1);
+	release_region(watchdog_port, 1);
 }
 
 module_init(mixcomwd_init);
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

