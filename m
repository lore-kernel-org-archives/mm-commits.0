From: akpm@linux-foundation.org
Subject: - watchdog-wafer5823wdt-clean-up-coding-style-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:37:19 -0700
Message-ID: <200807162137.m6GLbJYC014371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887AbYGPVqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: wafer5823wdt: Clean up, coding style, switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-wafer5823wdt-clean-up-coding-style-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

