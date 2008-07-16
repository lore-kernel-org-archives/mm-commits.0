From: akpm@linux-foundation.org
Subject: - watchdog-clean-up-and-check-advantech-watchdog.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:43 -0700
Message-ID: <200807162135.m6GLZhF1014116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757288AbYGPVmD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:42:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: clean up and check advantech watchdog
has been removed from the -mm tree.  Its filename was
     watchdog-clean-up-and-check-advantech-watchdog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

