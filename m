From: akpm@linux-foundation.org
Subject: + watchdog-wafer5823wdt-clean-up-coding-style-switch-to-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:56 -0700
Message-ID: <200805200828.m4K8SuTc013221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761551AbYETI3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:29:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: wafer5823wdt: Clean up, coding style, switch to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-wafer5823wdt-clean-up-coding-style-switch-to-unlocked_ioctl.patch

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
Subject: watchdog: wafer5823wdt: Clean up, coding style, switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/wafer5823wdt.c |   80 +++++++++++++++++-------------
 1 file changed, 46 insertions(+), 34 deletions(-)

diff -puN drivers/watchdog/wafer5823wdt.c~watchdog-wafer5823wdt-clean-up-coding-style-switch-to-unlocked_ioctl drivers/watchdog/wafer5823wdt.c
--- a/drivers/watchdog/wafer5823wdt.c~watchdog-wafer5823wdt-clean-up-coding-style-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/wafer5823wdt.c
@@ -36,8 +36,8 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 #define WATCHDOG_NAME "Wafer 5823 WDT"
 #define PFX WATCHDOG_NAME ": "
@@ -61,11 +61,15 @@ static int wdt_start = 0x443;
 
 static int timeout = WD_TIMO;  /* in seconds */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=255, default=" __MODULE_STRING(WD_TIMO) ".");
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in seconds. 1 <= timeout <= 255, default="
+				__MODULE_STRING(WD_TIMO) ".");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wafwdt_ping(void)
 {
@@ -90,7 +94,8 @@ wafwdt_stop(void)
 	inb_p(wdt_stop);
 }
 
-static ssize_t wafwdt_write(struct file *file, const char __user *buf, size_t count, loff_t * ppos)
+static ssize_t wafwdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
 	if (count) {
@@ -100,7 +105,8 @@ static ssize_t wafwdt_write(struct file 
 			/* In case it was set long ago */
 			expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the magic
+			   character */
 			for (i = 0; i != count; i++) {
 				char c;
 				if (get_user(c, buf + i))
@@ -109,27 +115,29 @@ static ssize_t wafwdt_write(struct file 
 					expect_close = 42;
 			}
 		}
-		/* Well, anyhow someone wrote to us, we should return that favour */
+		/* Well, anyhow someone wrote to us, we should
+		   return that favour */
 		wafwdt_ping();
 	}
 	return count;
 }
 
-static int wafwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	     unsigned long arg)
+static long wafwdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static const struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+							WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "Wafer 5823 WDT",
 	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &ident, sizeof (ident)))
+		if (copy_to_user(argp, &ident, sizeof(ident)))
 			return -EFAULT;
 		break;
 
@@ -194,10 +202,11 @@ static int wafwdt_open(struct inode *ino
 static int
 wafwdt_close(struct inode *inode, struct file *file)
 {
-	if (expect_close == 42) {
+	if (expect_close == 42)
 		wafwdt_stop();
-	} else {
-		printk(KERN_CRIT PFX "WDT device closed unexpectedly.  WDT will not stop!\n");
+	else {
+		printk(KERN_CRIT PFX
+		    "WDT device closed unexpectedly.  WDT will not stop!\n");
 		wafwdt_ping();
 	}
 	clear_bit(0, &wafwdt_is_open);
@@ -209,12 +218,11 @@ wafwdt_close(struct inode *inode, struct
  *	Notifier for system down
  */
 
-static int wafwdt_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int wafwdt_notify_sys(struct notifier_block *this, unsigned long code,
+								void *unused)
 {
-	if (code == SYS_DOWN || code == SYS_HALT) {
-		/* Turn the WDT off */
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wafwdt_stop();
-	}
 	return NOTIFY_DONE;
 }
 
@@ -226,7 +234,7 @@ static const struct file_operations wafw
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wafwdt_write,
-	.ioctl		= wafwdt_ioctl,
+	.unlocked_ioctl	= wafwdt_ioctl,
 	.open		= wafwdt_open,
 	.release	= wafwdt_close,
 };
@@ -250,25 +258,28 @@ static int __init wafwdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "WDT driver for Wafer 5823 single board computer initialising.\n");
+	printk(KERN_INFO
+	  "WDT driver for Wafer 5823 single board computer initialising.\n");
 
 	if (timeout < 1 || timeout > 255) {
 		timeout = WD_TIMO;
-		printk (KERN_INFO PFX "timeout value must be 1<=x<=255, using %d\n",
-			timeout);
+		printk(KERN_INFO PFX
+			"timeout value must be 1 <= x <= 255, using %d\n",
+								timeout);
 	}
 
 	if (wdt_stop != wdt_start) {
-		if(!request_region(wdt_stop, 1, "Wafer 5823 WDT")) {
-			printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			wdt_stop);
+		if (!request_region(wdt_stop, 1, "Wafer 5823 WDT")) {
+			printk(KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+								wdt_stop);
 			ret = -EIO;
 			goto error;
 		}
 	}
 
-	if(!request_region(wdt_start, 1, "Wafer 5823 WDT")) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
+	if (!request_region(wdt_start, 1, "Wafer 5823 WDT")) {
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			wdt_start);
 		ret = -EIO;
 		goto error2;
@@ -276,19 +287,20 @@ static int __init wafwdt_init(void)
 
 	ret = register_reboot_notifier(&wafwdt_notifier);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		goto error3;
 	}
 
 	ret = misc_register(&wafwdt_miscdev);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						WATCHDOG_MINOR, ret);
 		goto error4;
 	}
 
-	printk (KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 	return ret;
@@ -307,7 +319,7 @@ static void __exit wafwdt_exit(void)
 {
 	misc_deregister(&wafwdt_miscdev);
 	unregister_reboot_notifier(&wafwdt_notifier);
-	if(wdt_stop != wdt_start)
+	if (wdt_stop != wdt_start)
 		release_region(wdt_stop, 1);
 	release_region(wdt_start, 1);
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

