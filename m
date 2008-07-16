From: akpm@linux-foundation.org
Subject: - watchdog-w83627hf-coding-style-clean-up-and-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:37:13 -0700
Message-ID: <200807162137.m6GLbDEb014362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757627AbYGPVqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: w83627hf: coding style, clean up and switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-w83627hf-coding-style-clean-up-and-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: w83627hf: coding style, clean up and switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/w83627hf_wdt.c |  175 ++++++++++++++----------------
 1 file changed, 83 insertions(+), 92 deletions(-)

diff -puN drivers/watchdog/w83627hf_wdt.c~watchdog-w83627hf-coding-style-clean-up-and-switch-to-unlocked_ioctl drivers/watchdog/w83627hf_wdt.c
--- a/drivers/watchdog/w83627hf_wdt.c~watchdog-w83627hf-coding-style-clean-up-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/w83627hf_wdt.c
@@ -37,9 +37,9 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #define WATCHDOG_NAME "w83627hf/thf/hg WDT"
@@ -57,22 +57,26 @@ MODULE_PARM_DESC(wdt_io, "w83627hf/thf W
 
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=255, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in seconds. 1 <= timeout <= 255, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Kernel methods.
  */
 
 #define WDT_EFER (wdt_io+0)   /* Extended Function Enable Registers */
-#define WDT_EFIR (wdt_io+0)   /* Extended Function Index Register (same as EFER) */
+#define WDT_EFIR (wdt_io+0)   /* Extended Function Index Register
+							(same as EFER) */
 #define WDT_EFDR (WDT_EFIR+1) /* Extended Function Data Register */
 
-static void
-w83627hf_select_wd_register(void)
+static void w83627hf_select_wd_register(void)
 {
 	unsigned char c;
 	outb_p(0x87, WDT_EFER); /* Enter extended function mode */
@@ -93,43 +97,45 @@ w83627hf_select_wd_register(void)
 	outb_p(0x01, WDT_EFDR); /* set bit 0 to activate GPIO2 */
 }
 
-static void
-w83627hf_unselect_wd_register(void)
+static void w83627hf_unselect_wd_register(void)
 {
 	outb_p(0xAA, WDT_EFER); /* Leave extended function mode */
 }
 
 /* tyan motherboards seem to set F5 to 0x4C ?
  * So explicitly init to appropriate value. */
-static void
-w83627hf_init(void)
+
+static void w83627hf_init(void)
 {
 	unsigned char t;
 
 	w83627hf_select_wd_register();
 
 	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
-	t=inb_p(WDT_EFDR);      /* read CRF6 */
+	t = inb_p(WDT_EFDR);      /* read CRF6 */
 	if (t != 0) {
-		printk (KERN_INFO PFX "Watchdog already running. Resetting timeout to %d sec\n", timeout);
+		printk(KERN_INFO PFX
+		     "Watchdog already running. Resetting timeout to %d sec\n",
+								timeout);
 		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
 	}
 
 	outb_p(0xF5, WDT_EFER); /* Select CRF5 */
-	t=inb_p(WDT_EFDR);      /* read CRF5 */
-	t&=~0x0C;               /* set second mode & disable keyboard turning off watchdog */
+	t = inb_p(WDT_EFDR);      /* read CRF5 */
+	t &= ~0x0C;               /* set second mode & disable keyboard
+				    turning off watchdog */
 	outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
 
 	outb_p(0xF7, WDT_EFER); /* Select CRF7 */
-	t=inb_p(WDT_EFDR);      /* read CRF7 */
-	t&=~0xC0;               /* disable keyboard & mouse turning off watchdog */
+	t = inb_p(WDT_EFDR);      /* read CRF7 */
+	t &= ~0xC0;               /* disable keyboard & mouse turning off
+				    watchdog */
 	outb_p(t, WDT_EFDR);    /* Write back to CRF7 */
 
 	w83627hf_unselect_wd_register();
 }
 
-static void
-wdt_ctrl(int timeout)
+static void wdt_ctrl(int timeout)
 {
 	spin_lock(&io_lock);
 
@@ -143,32 +149,28 @@ wdt_ctrl(int timeout)
 	spin_unlock(&io_lock);
 }
 
-static int
-wdt_ping(void)
+static int wdt_ping(void)
 {
 	wdt_ctrl(timeout);
 	return 0;
 }
 
-static int
-wdt_disable(void)
+static int wdt_disable(void)
 {
 	wdt_ctrl(0);
 	return 0;
 }
 
-static int
-wdt_set_heartbeat(int t)
+static int wdt_set_heartbeat(int t)
 {
-	if ((t < 1) || (t > 255))
+	if (t < 1 || t > 255)
 		return -EINVAL;
-
 	timeout = t;
 	return 0;
 }
 
-static ssize_t
-wdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t wdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -189,72 +191,61 @@ wdt_write(struct file *file, const char 
 	return count;
 }
 
-static int
-wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_timeout;
 	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+							WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "W83627HF WDT",
 	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-	  if (copy_to_user(argp, &ident, sizeof(ident)))
-	    return -EFAULT;
-	  break;
-
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-	  return put_user(0, p);
-
+		return put_user(0, p);
 	case WDIOC_KEEPALIVE:
-	  wdt_ping();
-	  break;
-
+		wdt_ping();
+		break;
 	case WDIOC_SETTIMEOUT:
-	  if (get_user(new_timeout, p))
-		  return -EFAULT;
-	  if (wdt_set_heartbeat(new_timeout))
-		  return -EINVAL;
-	  wdt_ping();
-	  /* Fall */
-
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (wdt_set_heartbeat(new_timeout))
+			return -EINVAL;
+		wdt_ping();
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
-	    wdt_disable();
-	    retval = 0;
-	  }
-
-	  if (options & WDIOS_ENABLECARD) {
-	    wdt_ping();
-	    retval = 0;
-	  }
-
-	  return retval;
+		if (get_user(options, p))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			wdt_disable();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			wdt_ping();
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
-wdt_open(struct inode *inode, struct file *file)
+static int wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
@@ -266,13 +257,13 @@ wdt_open(struct inode *inode, struct fil
 	return nonseekable_open(inode, file);
 }
 
-static int
-wdt_close(struct inode *inode, struct file *file)
+static int wdt_close(struct inode *inode, struct file *file)
 {
-	if (expect_close == 42) {
+	if (expect_close == 42)
 		wdt_disable();
-	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		wdt_ping();
 	}
 	expect_close = 0;
@@ -284,8 +275,7 @@ wdt_close(struct inode *inode, struct fi
  *	Notifier for system down
  */
 
-static int
-wdt_notify_sys(struct notifier_block *this, unsigned long code,
+static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT) {
@@ -303,7 +293,7 @@ static const struct file_operations wdt_
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdt_write,
-	.ioctl		= wdt_ioctl,
+	.unlocked_ioctl	= wdt_ioctl,
 	.open		= wdt_open,
 	.release	= wdt_close,
 };
@@ -323,8 +313,7 @@ static struct notifier_block wdt_notifie
 	.notifier_call = wdt_notify_sys,
 };
 
-static int __init
-wdt_init(void)
+static int __init wdt_init(void)
 {
 	int ret;
 
@@ -332,12 +321,13 @@ wdt_init(void)
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk (KERN_INFO PFX "timeout value must be 1<=timeout<=255, using %d\n",
-			WATCHDOG_TIMEOUT);
+		printk(KERN_INFO PFX
+		     "timeout value must be 1 <= timeout <= 255, using %d\n",
+				WATCHDOG_TIMEOUT);
 	}
 
 	if (!request_region(wdt_io, 1, WATCHDOG_NAME)) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			wdt_io);
 		ret = -EIO;
 		goto out;
@@ -347,20 +337,22 @@ wdt_init(void)
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		goto unreg_regions;
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	printk (KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
-		timeout, nowayout);
+	printk(KERN_INFO PFX
+			"initialized. timeout=%d sec (nowayout=%d)\n",
+							timeout, nowayout);
 
 out:
 	return ret;
@@ -371,12 +363,11 @@ unreg_regions:
 	goto out;
 }
 
-static void __exit
-wdt_exit(void)
+static void __exit wdt_exit(void)
 {
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
-	release_region(wdt_io,1);
+	release_region(wdt_io, 1);
 }
 
 module_init(wdt_init);
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

