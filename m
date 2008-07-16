From: akpm@linux-foundation.org
Subject: - watchdog-softdog-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:37:09 -0700
Message-ID: <200807162137.m6GLb9Jt014353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756295AbYGPVrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:47:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: softdog: clean up, coding style and switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-softdog-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: softdog: clean up, coding style and switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/softdog.c |   87 ++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 41 deletions(-)

diff -puN drivers/watchdog/softdog.c~watchdog-softdog-clean-up-coding-style-and-switch-to-unlocked_ioctl drivers/watchdog/softdog.c
--- a/drivers/watchdog/softdog.c~watchdog-softdog-clean-up-coding-style-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/softdog.c
@@ -47,19 +47,22 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
-
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #define PFX "SoftDog: "
 
 #define TIMER_MARGIN	60		/* Default is 60 seconds */
 static int soft_margin = TIMER_MARGIN;	/* in seconds */
 module_param(soft_margin, int, 0);
-MODULE_PARM_DESC(soft_margin, "Watchdog soft_margin in seconds. (0<soft_margin<65536, default=" __MODULE_STRING(TIMER_MARGIN) ")");
+MODULE_PARM_DESC(soft_margin,
+	"Watchdog soft_margin in seconds. (0 < soft_margin < 65536, default="
+					__MODULE_STRING(TIMER_MARGIN) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #ifdef ONLY_TESTING
 static int soft_noboot = 1;
@@ -93,8 +96,7 @@ static void watchdog_fire(unsigned long 
 
 	if (soft_noboot)
 		printk(KERN_CRIT PFX "Triggered - Reboot ignored.\n");
-	else
-	{
+	else {
 		printk(KERN_CRIT PFX "Initiating system reboot.\n");
 		emergency_restart();
 		printk(KERN_CRIT PFX "Reboot didn't ?????\n");
@@ -153,7 +155,8 @@ static int softdog_release(struct inode 
 		softdog_stop();
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		set_bit(0, &orphan_timer);
 		softdog_keepalive();
 	}
@@ -162,12 +165,13 @@ static int softdog_release(struct inode 
 	return 0;
 }
 
-static ssize_t softdog_write(struct file *file, const char __user *data, size_t len, loff_t *ppos)
+static ssize_t softdog_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
 {
 	/*
 	 *	Refresh the timer.
 	 */
-	if(len) {
+	if (len) {
 		if (!nowayout) {
 			size_t i;
 
@@ -188,13 +192,13 @@ static ssize_t softdog_write(struct file
 	return len;
 }
 
-static int softdog_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long softdog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_margin;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT |
 					WDIOF_KEEPALIVEPING |
 					WDIOF_MAGICCLOSE,
@@ -202,26 +206,25 @@ static int softdog_ioctl(struct inode *i
 		.identity =		"Software Watchdog",
 	};
 	switch (cmd) {
-		default:
-			return -ENOTTY;
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident,
-				sizeof(ident)) ? -EFAULT : 0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-		case WDIOC_KEEPALIVE:
-			softdog_keepalive();
-			return 0;
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_margin, p))
-				return -EFAULT;
-			if (softdog_set_heartbeat(new_margin))
-				return -EINVAL;
-			softdog_keepalive();
-			/* Fall */
-		case WDIOC_GETTIMEOUT:
-			return put_user(soft_margin, p);
+	default:
+		return -ENOTTY;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		softdog_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_margin, p))
+			return -EFAULT;
+		if (softdog_set_heartbeat(new_margin))
+			return -EINVAL;
+		softdog_keepalive();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(soft_margin, p);
 	}
 }
 
@@ -232,10 +235,9 @@ static int softdog_ioctl(struct inode *i
 static int softdog_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT) {
+	if (code == SYS_DOWN || code == SYS_HALT)
 		/* Turn the WDT off */
 		softdog_stop();
-	}
 	return NOTIFY_DONE;
 }
 
@@ -247,7 +249,7 @@ static const struct file_operations soft
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= softdog_write,
-	.ioctl		= softdog_ioctl,
+	.unlocked_ioctl	= softdog_ioctl,
 	.open		= softdog_open,
 	.release	= softdog_release,
 };
@@ -268,24 +270,27 @@ static int __init watchdog_init(void)
 {
 	int ret;
 
-	/* Check that the soft_margin value is within it's range ; if not reset to the default */
+	/* Check that the soft_margin value is within it's range;
+	   if not reset to the default */
 	if (softdog_set_heartbeat(soft_margin)) {
 		softdog_set_heartbeat(TIMER_MARGIN);
-		printk(KERN_INFO PFX "soft_margin value must be 0<soft_margin<65536, using %d\n",
+		printk(KERN_INFO PFX
+		    "soft_margin must be 0 < soft_margin < 65536, using %d\n",
 			TIMER_MARGIN);
 	}
 
 	ret = register_reboot_notifier(&softdog_notifier);
 	if (ret) {
-		printk (KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&softdog_miscdev);
 	if (ret) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&softdog_notifier);
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

