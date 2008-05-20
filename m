From: akpm@linux-foundation.org
Subject: + watchdog-w83877f_wdt-clean-up-code-coding-style-switch-to-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:52 -0700
Message-ID: <200805200828.m4K8SqnN013215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761499AbYETI3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: w83877f_wdt: clean up code, coding style, switch to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-w83877f_wdt-clean-up-code-coding-style-switch-to-unlocked_ioctl.patch

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
Subject: watchdog: w83877f_wdt: clean up code, coding style, switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/w83877f_wdt.c |  203 +++++++++++++++----------------
 1 file changed, 103 insertions(+), 100 deletions(-)

diff -puN drivers/watchdog/w83877f_wdt.c~watchdog-w83877f_wdt-clean-up-code-coding-style-switch-to-unlocked_ioctl drivers/watchdog/w83877f_wdt.c
--- a/drivers/watchdog/w83877f_wdt.c~watchdog-w83877f_wdt-clean-up-code-coding-style-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/w83877f_wdt.c
@@ -23,13 +23,16 @@
  *                            Added KERN_* tags to printks
  *                            add CONFIG_WATCHDOG_NOWAYOUT support
  *                            fix possible wdt_is_open race
- *                            changed watchdog_info to correctly reflect what the driver offers
- *                            added WDIOC_GETSTATUS, WDIOC_GETBOOTSTATUS, WDIOC_SETTIMEOUT,
+ *                            changed watchdog_info to correctly reflect what
+ *			      the driver offers
+ *                            added WDIOC_GETSTATUS, WDIOC_GETBOOTSTATUS,
+ *			      WDIOC_SETTIMEOUT,
  *                            WDIOC_GETTIMEOUT, and WDIOC_SETOPTIONS ioctls
  *           09/8 - 2003      [wim@iguana.be] cleanup of trailing spaces
  *                            added extra printk's for startup problems
  *                            use module_param
- *                            made timeout (the emulated heartbeat) a module_param
+ *                            made timeout (the emulated heartbeat) a
+ *			      module_param
  *                            made the keepalive ping an internal subroutine
  *
  *  This WDT driver is different from most other Linux WDT
@@ -51,8 +54,8 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/system.h>
 
 #define OUR_NAME "w83877f_wdt"
@@ -80,14 +83,19 @@
  */
 
 #define WATCHDOG_TIMEOUT 30            /* 30 sec default timeout */
-static int timeout = WATCHDOG_TIMEOUT; /* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+/* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+static int timeout = WATCHDOG_TIMEOUT;
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=3600, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1<=timeout<=3600, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wdt_timer_ping(unsigned long);
 static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
@@ -105,8 +113,7 @@ static void wdt_timer_ping(unsigned long
 	/* If we got a heartbeat pulse within the WDT_US_INTERVAL
 	 * we agree to ping the WDT
 	 */
-	if(time_before(jiffies, next_heartbeat))
-	{
+	if (time_before(jiffies, next_heartbeat)) {
 		/* Ping the WDT */
 		spin_lock(&wdt_spinlock);
 
@@ -118,9 +125,9 @@ static void wdt_timer_ping(unsigned long
 
 		spin_unlock(&wdt_spinlock);
 
-	} else {
-		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
-	}
+	} else
+		printk(KERN_WARNING PFX
+			"Heartbeat lost! Will not ping the watchdog\n");
 }
 
 /*
@@ -181,22 +188,21 @@ static void wdt_keepalive(void)
  * /dev/watchdog handling
  */
 
-static ssize_t fop_write(struct file * file, const char __user * buf, size_t count, loff_t * ppos)
+static ssize_t fop_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-	if(count)
-	{
-		if (!nowayout)
-		{
+	if (count) {
+		if (!nowayout) {
 			size_t ofs;
 
-			/* note: just in case someone wrote the magic character
-			 * five months ago... */
+			/* note: just in case someone wrote the magic
+			   character five months ago... */
 			wdt_expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
-			for(ofs = 0; ofs != count; ofs++)
-			{
+			/* scan to see whether or not we got the
+			   magic character */
+			for (ofs = 0; ofs != count; ofs++) {
 				char c;
 				if (get_user(c, buf + ofs))
 					return -EFAULT;
@@ -211,10 +217,10 @@ static ssize_t fop_write(struct file * f
 	return count;
 }
 
-static int fop_open(struct inode * inode, struct file * file)
+static int fop_open(struct inode *inode, struct file *file)
 {
 	/* Just in case we're already talking to someone... */
-	if(test_and_set_bit(0, &wdt_is_open))
+	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
 
 	/* Good, fire up the show */
@@ -222,78 +228,78 @@ static int fop_open(struct inode * inode
 	return nonseekable_open(inode, file);
 }
 
-static int fop_close(struct inode * inode, struct file * file)
+static int fop_close(struct inode *inode, struct file *file)
 {
-	if(wdt_expect_close == 42)
+	if (wdt_expect_close == 42)
 		wdt_turnoff();
 	else {
 		del_timer(&timer);
-		printk(KERN_CRIT PFX "device file closed unexpectedly. Will not stop the WDT!\n");
+		printk(KERN_CRIT PFX
+		  "device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
 	wdt_expect_close = 0;
 	return 0;
 }
 
-static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	unsigned long arg)
+static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident=
-	{
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static const struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "W83877F",
 	};
 
-	switch(cmd)
+	switch (cmd) {
+	default:
+		return -ENOTTY;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		wdt_keepalive();
+		return 0;
+	case WDIOC_SETOPTIONS:
 	{
-		default:
-			return -ENOTTY;
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident, sizeof(ident))?-EFAULT:0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-		case WDIOC_KEEPALIVE:
-			wdt_keepalive();
-			return 0;
-		case WDIOC_SETOPTIONS:
-		{
-			int new_options, retval = -EINVAL;
-
-			if(get_user(new_options, p))
-				return -EFAULT;
-
-			if(new_options & WDIOS_DISABLECARD) {
-				wdt_turnoff();
-				retval = 0;
-			}
+		int new_options, retval = -EINVAL;
 
-			if(new_options & WDIOS_ENABLECARD) {
-				wdt_startup();
-				retval = 0;
-			}
+		if (get_user(new_options, p))
+			return -EFAULT;
 
-			return retval;
+		if (new_options & WDIOS_DISABLECARD) {
+			wdt_turnoff();
+			retval = 0;
 		}
-		case WDIOC_SETTIMEOUT:
-		{
-			int new_timeout;
-
-			if(get_user(new_timeout, p))
-				return -EFAULT;
-
-			if(new_timeout < 1 || new_timeout > 3600) /* arbitrary upper limit */
-				return -EINVAL;
-
-			timeout = new_timeout;
-			wdt_keepalive();
-			/* Fall through */
+
+		if (new_options & WDIOS_ENABLECARD) {
+			wdt_startup();
+			retval = 0;
 		}
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
+
+		return retval;
+	}
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_timeout;
+
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+
+		/* arbitrary upper limit */
+		if (new_timeout < 1 || new_timeout > 3600)
+			return -EINVAL;
+
+		timeout = new_timeout;
+		wdt_keepalive();
+		/* Fall through */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
 	}
 }
 
@@ -303,7 +309,7 @@ static const struct file_operations wdt_
 	.write		= fop_write,
 	.open		= fop_open,
 	.release	= fop_close,
-	.ioctl		= fop_ioctl,
+	.unlocked_ioctl	= fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {
@@ -319,7 +325,7 @@ static struct miscdevice wdt_miscdev = {
 static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_turnoff();
 	return NOTIFY_DONE;
 }
@@ -329,8 +335,7 @@ static int wdt_notify_sys(struct notifie
  *	turn the timebomb registers off.
  */
 
-static struct notifier_block wdt_notifier=
-{
+static struct notifier_block wdt_notifier = {
 	.notifier_call = wdt_notify_sys,
 };
 
@@ -342,31 +347,29 @@ static void __exit w83877f_wdt_unload(vo
 	misc_deregister(&wdt_miscdev);
 
 	unregister_reboot_notifier(&wdt_notifier);
-	release_region(WDT_PING,1);
-	release_region(ENABLE_W83877F_PORT,2);
+	release_region(WDT_PING, 1);
+	release_region(ENABLE_W83877F_PORT, 2);
 }
 
 static int __init w83877f_wdt_init(void)
 {
 	int rc = -EBUSY;
 
-	if(timeout < 1 || timeout > 3600) /* arbitrary upper limit */
-	{
+	if (timeout < 1 || timeout > 3600) { /* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX "timeout value must be 1<=x<=3600, using %d\n",
-			timeout);
+		printk(KERN_INFO PFX
+			"timeout value must be 1 <= x <= 3600, using %d\n",
+							timeout);
 	}
 
-	if (!request_region(ENABLE_W83877F_PORT, 2, "W83877F WDT"))
-	{
+	if (!request_region(ENABLE_W83877F_PORT, 2, "W83877F WDT")) {
 		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			ENABLE_W83877F_PORT);
 		rc = -EIO;
 		goto err_out;
 	}
 
-	if (!request_region(WDT_PING, 1, "W8387FF WDT"))
-	{
+	if (!request_region(WDT_PING, 1, "W8387FF WDT")) {
 		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			WDT_PING);
 		rc = -EIO;
@@ -374,22 +377,22 @@ static int __init w83877f_wdt_init(void)
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region2;
 	}
 
 	rc = misc_register(&wdt_miscdev);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX "WDT driver for W83877F initialised. timeout=%d sec (nowayout=%d)\n",
+	printk(KERN_INFO PFX
+	  "WDT driver for W83877F initialised. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 	return 0;
@@ -397,9 +400,9 @@ static int __init w83877f_wdt_init(void)
 err_out_reboot:
 	unregister_reboot_notifier(&wdt_notifier);
 err_out_region2:
-	release_region(WDT_PING,1);
+	release_region(WDT_PING, 1);
 err_out_region1:
-	release_region(ENABLE_W83877F_PORT,2);
+	release_region(ENABLE_W83877F_PORT, 2);
 err_out:
 	return rc;
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

