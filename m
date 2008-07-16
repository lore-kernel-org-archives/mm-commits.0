From: akpm@linux-foundation.org
Subject: - watchdog-sbc60xxwdt-clean-up-and-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:49 -0700
Message-ID: <200807162136.m6GLanuH014245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759251AbYGPVhh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:37:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: sbc60xxwdt: clean up and switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-sbc60xxwdt-clean-up-and-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: sbc60xxwdt: clean up and switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/sbc60xxwdt.c |  223 +++++++++++++++-----------------
 1 file changed, 110 insertions(+), 113 deletions(-)

diff -puN drivers/watchdog/sbc60xxwdt.c~watchdog-sbc60xxwdt-clean-up-and-switch-to-unlocked_ioctl drivers/watchdog/sbc60xxwdt.c
--- a/drivers/watchdog/sbc60xxwdt.c~watchdog-sbc60xxwdt-clean-up-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/sbc60xxwdt.c
@@ -16,19 +16,23 @@
  *
  *           12/4 - 2000      [Initial revision]
  *           25/4 - 2000      Added /dev/watchdog support
- *           09/5 - 2001      [smj@oro.net] fixed fop_write to "return 1" on success
+ *           09/5 - 2001      [smj@oro.net] fixed fop_write to "return 1"
+ *					on success
  *           12/4 - 2002      [rob@osinvestor.com] eliminate fop_read
  *                            fix possible wdt_is_open race
  *                            add CONFIG_WATCHDOG_NOWAYOUT support
  *                            remove lock_kernel/unlock_kernel pairs
  *                            added KERN_* to printk's
  *                            got rid of extraneous comments
- *                            changed watchdog_info to correctly reflect what the driver offers
- *                            added WDIOC_GETSTATUS, WDIOC_GETBOOTSTATUS, WDIOC_SETTIMEOUT,
- *                            WDIOC_GETTIMEOUT, and WDIOC_SETOPTIONS ioctls
+ *                            changed watchdog_info to correctly reflect what
+ *			      the driver offers
+ *			      added WDIOC_GETSTATUS, WDIOC_GETBOOTSTATUS,
+ *			      WDIOC_SETTIMEOUT, WDIOC_GETTIMEOUT, and
+ *			      WDIOC_SETOPTIONS ioctls
  *           09/8 - 2003      [wim@iguana.be] cleanup of trailing spaces
  *                            use module_param
- *                            made timeout (the emulated heartbeat) a module_param
+ *                            made timeout (the emulated heartbeat) a
+ *			      module_param
  *                            made the keepalive ping an internal subroutine
  *                            made wdt_stop and wdt_start module params
  *                            added extra printk's for startup problems
@@ -56,9 +60,9 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #define OUR_NAME "sbc60xxwdt"
@@ -94,13 +98,18 @@ MODULE_PARM_DESC(wdt_start, "SBC60xx WDT
  */
 
 #define WATCHDOG_TIMEOUT 30		/* 30 sec default timeout */
-static int timeout = WATCHDOG_TIMEOUT;	/* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+static int timeout = WATCHDOG_TIMEOUT;	/* in seconds, multiplied by HZ to
+					   get seconds to wait for a ping */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=3600, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1<=timeout<=3600, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wdt_timer_ping(unsigned long);
 static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
@@ -117,15 +126,14 @@ static void wdt_timer_ping(unsigned long
 	/* If we got a heartbeat pulse within the WDT_US_INTERVAL
 	 * we agree to ping the WDT
 	 */
-	if(time_before(jiffies, next_heartbeat))
-	{
+	if (time_before(jiffies, next_heartbeat)) {
 		/* Ping the WDT by reading from wdt_start */
 		inb_p(wdt_start);
 		/* Re-set the timer interval */
 		mod_timer(&timer, jiffies + WDT_INTERVAL);
-	} else {
-		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
-	}
+	} else
+		printk(KERN_WARNING PFX
+			"Heartbeat lost! Will not ping the watchdog\n");
 }
 
 /*
@@ -159,40 +167,40 @@ static void wdt_keepalive(void)
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
+			/* note: just in case someone wrote the
+			   magic character five months ago... */
 			wdt_expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
-			for(ofs = 0; ofs != count; ofs++)
-			{
+			/* scan to see whether or not we got the
+			   magic character */
+			for (ofs = 0; ofs != count; ofs++) {
 				char c;
-				if(get_user(c, buf+ofs))
+				if (get_user(c, buf+ofs))
 					return -EFAULT;
-				if(c == 'V')
+				if (c == 'V')
 					wdt_expect_close = 42;
 			}
 		}
 
-		/* Well, anyhow someone wrote to us, we should return that favour */
+		/* Well, anyhow someone wrote to us, we should
+		   return that favour */
 		wdt_keepalive();
 	}
 	return count;
 }
 
-static int fop_open(struct inode * inode, struct file * file)
+static int fop_open(struct inode *inode, struct file *file)
 {
 	/* Just in case we're already talking to someone... */
-	if(test_and_set_bit(0, &wdt_is_open))
+	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
 
 	if (nowayout)
@@ -203,78 +211,72 @@ static int fop_open(struct inode * inode
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
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+							WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "SBC60xx",
 	};
 
-	switch(cmd)
+	switch (cmd) {
+	default:
+		return -ENOTTY;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident))? -EFAULT : 0;
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
-
-			if(new_options & WDIOS_ENABLECARD) {
-				wdt_startup();
-				retval = 0;
-			}
-
-			return retval;
+		int new_options, retval = -EINVAL;
+		if (get_user(new_options, p))
+			return -EFAULT;
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
+		if (new_options & WDIOS_ENABLECARD) {
+			wdt_startup();
+			retval = 0;
 		}
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
+		return retval;
+	}
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_timeout;
+		if (get_user(new_timeout, p))
+			return -EFAULT;
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
 
@@ -284,7 +286,7 @@ static const struct file_operations wdt_
 	.write		= fop_write,
 	.open		= fop_open,
 	.release	= fop_close,
-	.ioctl		= fop_ioctl,
+	.unlocked_ioctl	= fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {
@@ -300,7 +302,7 @@ static struct miscdevice wdt_miscdev = {
 static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_turnoff();
 	return NOTIFY_DONE;
 }
@@ -310,8 +312,7 @@ static int wdt_notify_sys(struct notifie
  *	turn the timebomb registers off.
  */
 
-static struct notifier_block wdt_notifier=
-{
+static struct notifier_block wdt_notifier = {
 	.notifier_call = wdt_notify_sys,
 };
 
@@ -324,23 +325,22 @@ static void __exit sbc60xxwdt_unload(voi
 
 	unregister_reboot_notifier(&wdt_notifier);
 	if ((wdt_stop != 0x45) && (wdt_stop != wdt_start))
-		release_region(wdt_stop,1);
-	release_region(wdt_start,1);
+		release_region(wdt_stop, 1);
+	release_region(wdt_start, 1);
 }
 
 static int __init sbc60xxwdt_init(void)
 {
 	int rc = -EBUSY;
 
-	if(timeout < 1 || timeout > 3600) /* arbitrary upper limit */
-	{
+	if (timeout < 1 || timeout > 3600) { /* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX "timeout value must be 1<=x<=3600, using %d\n",
-			timeout);
- 	}
+		printk(KERN_INFO PFX
+			"timeout value must be 1 <= x <= 3600, using %d\n",
+								timeout);
+	}
 
-	if (!request_region(wdt_start, 1, "SBC 60XX WDT"))
-	{
+	if (!request_region(wdt_start, 1, "SBC 60XX WDT")) {
 		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			wdt_start);
 		rc = -EIO;
@@ -348,33 +348,30 @@ static int __init sbc60xxwdt_init(void)
 	}
 
 	/* We cannot reserve 0x45 - the kernel already has! */
-	if ((wdt_stop != 0x45) && (wdt_stop != wdt_start))
-	{
-		if (!request_region(wdt_stop, 1, "SBC 60XX WDT"))
-		{
-			printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-				wdt_stop);
+	if (wdt_stop != 0x45 && wdt_stop != wdt_start) {
+		if (!request_region(wdt_stop, 1, "SBC 60XX WDT")) {
+			printk(KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+							wdt_stop);
 			rc = -EIO;
 			goto err_out_region1;
 		}
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
+						wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
-
 	printk(KERN_INFO PFX "WDT driver for 60XX single board computer initialised. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
@@ -383,10 +380,10 @@ static int __init sbc60xxwdt_init(void)
 err_out_reboot:
 	unregister_reboot_notifier(&wdt_notifier);
 err_out_region2:
-	if ((wdt_stop != 0x45) && (wdt_stop != wdt_start))
-		release_region(wdt_stop,1);
+	if (wdt_stop != 0x45 && wdt_stop != wdt_start)
+		release_region(wdt_stop, 1);
 err_out_region1:
-	release_region(wdt_start,1);
+	release_region(wdt_start, 1);
 err_out:
 	return rc;
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

