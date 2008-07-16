From: akpm@linux-foundation.org
Subject: - watchdog-mixcomwd-coding-style-locking-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:25 -0700
Message-ID: <200807162136.m6GLaPBQ014198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754920AbYGPVqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: mixcomwd: coding style locking, unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-mixcomwd-coding-style-locking-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

