From: akpm@linux-foundation.org
Subject: - watchdog-ib700wdt-clean-up-and-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:03 -0700
Message-ID: <200807162136.m6GLa3jO014158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbYGPVkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:40:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: ib700wdt: clean up and switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-ib700wdt-clean-up-and-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: ib700wdt: clean up and switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/ib700wdt.c |  103 +++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 51 deletions(-)

diff -puN drivers/watchdog/ib700wdt.c~watchdog-ib700wdt-clean-up-and-switch-to-unlocked_ioctl drivers/watchdog/ib700wdt.c
--- a/drivers/watchdog/ib700wdt.c~watchdog-ib700wdt-clean-up-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/ib700wdt.c
@@ -42,8 +42,8 @@
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/system.h>
 
 static struct platform_device *ibwdt_platform_device;
@@ -120,7 +120,9 @@ static int wd_margin = WD_TIMO;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 
 /*
@@ -165,8 +167,8 @@ ibwdt_set_heartbeat(int t)
  *	/dev/watchdog handling
  */
 
-static ssize_t
-ibwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t ibwdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -188,77 +190,71 @@ ibwdt_write(struct file *file, const cha
 	return count;
 }
 
-static int
-ibwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long ibwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_margin;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 
 	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "IB700 WDT",
 	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-	  if (copy_to_user(argp, &ident, sizeof(ident)))
-	    return -EFAULT;
-	  break;
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-	  return put_user(0, p);
+		return put_user(0, p);
 
 	case WDIOC_KEEPALIVE:
-	  ibwdt_ping();
-	  break;
+		ibwdt_ping();
+		break;
 
 	case WDIOC_SETTIMEOUT:
-	  if (get_user(new_margin, p))
-		  return -EFAULT;
-	  if (ibwdt_set_heartbeat(new_margin))
-		  return -EINVAL;
-	  ibwdt_ping();
-	  /* Fall */
+		if (get_user(new_margin, p))
+			return -EFAULT;
+		if (ibwdt_set_heartbeat(new_margin))
+			return -EINVAL;
+		ibwdt_ping();
+		/* Fall */
 
 	case WDIOC_GETTIMEOUT:
-	  return put_user(wd_times[wd_margin], p);
+		return put_user(wd_times[wd_margin], p);
 
 	case WDIOC_SETOPTIONS:
 	{
-	  int options, retval = -EINVAL;
+		int options, retval = -EINVAL;
 
-	  if (get_user(options, p))
-	    return -EFAULT;
+		if (get_user(options, p))
+			return -EFAULT;
 
-	  if (options & WDIOS_DISABLECARD) {
-	    ibwdt_disable();
-	    retval = 0;
-	  }
-
-	  if (options & WDIOS_ENABLECARD) {
-	    ibwdt_ping();
-	    retval = 0;
-	  }
-
-	  return retval;
+		if (options & WDIOS_DISABLECARD) {
+			ibwdt_disable();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			ibwdt_ping();
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
-ibwdt_open(struct inode *inode, struct file *file)
+static int ibwdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &ibwdt_is_open)) {
+	if (test_and_set_bit(0, &ibwdt_is_open))
 		return -EBUSY;
-	}
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
@@ -273,7 +269,8 @@ ibwdt_close(struct inode *inode, struct 
 	if (expect_close == 42) {
 		ibwdt_disable();
 	} else {
-		printk(KERN_CRIT PFX "WDT device closed unexpectedly.  WDT will not stop!\n");
+		printk(KERN_CRIT PFX
+		     "WDT device closed unexpectedly.  WDT will not stop!\n");
 		ibwdt_ping();
 	}
 	clear_bit(0, &ibwdt_is_open);
@@ -289,7 +286,7 @@ static const struct file_operations ibwd
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= ibwdt_write,
-	.ioctl		= ibwdt_ioctl,
+	.unlocked_ioctl	= ibwdt_ioctl,
 	.open		= ibwdt_open,
 	.release	= ibwdt_close,
 };
@@ -310,21 +307,23 @@ static int __devinit ibwdt_probe(struct 
 
 #if WDT_START != WDT_STOP
 	if (!request_region(WDT_STOP, 1, "IB700 WDT")) {
-		printk (KERN_ERR PFX "STOP method I/O %X is not available.\n", WDT_STOP);
+		printk(KERN_ERR PFX "STOP method I/O %X is not available.\n",
+								WDT_STOP);
 		res = -EIO;
 		goto out_nostopreg;
 	}
 #endif
 
 	if (!request_region(WDT_START, 1, "IB700 WDT")) {
-		printk (KERN_ERR PFX "START method I/O %X is not available.\n", WDT_START);
+		printk(KERN_ERR PFX "START method I/O %X is not available.\n",
+								WDT_START);
 		res = -EIO;
 		goto out_nostartreg;
 	}
 
 	res = misc_register(&ibwdt_miscdev);
 	if (res) {
-		printk (KERN_ERR PFX "failed to register misc device\n");
+		printk(KERN_ERR PFX "failed to register misc device\n");
 		goto out_nomisc;
 	}
 	return 0;
@@ -342,9 +341,9 @@ out_nostopreg:
 static int __devexit ibwdt_remove(struct platform_device *dev)
 {
 	misc_deregister(&ibwdt_miscdev);
-	release_region(WDT_START,1);
+	release_region(WDT_START, 1);
 #if WDT_START != WDT_STOP
-	release_region(WDT_STOP,1);
+	release_region(WDT_STOP, 1);
 #endif
 	return 0;
 }
@@ -369,13 +368,15 @@ static int __init ibwdt_init(void)
 {
 	int err;
 
-	printk(KERN_INFO PFX "WDT driver for IB700 single board computer initialising.\n");
+	printk(KERN_INFO PFX
+		"WDT driver for IB700 single board computer initialising.\n");
 
 	err = platform_driver_register(&ibwdt_driver);
 	if (err)
 		return err;
 
-	ibwdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	ibwdt_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(ibwdt_platform_device)) {
 		err = PTR_ERR(ibwdt_platform_device);
 		goto unreg_platform_driver;
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

