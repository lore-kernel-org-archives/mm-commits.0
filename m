From: akpm@linux-foundation.org
Subject: + watchdog-sc520_wdt-clean-up-and-switch-to-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:41 -0700
Message-ID: <200805200828.m4K8SfEC013194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761450AbYETI3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:29:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: sc520_wdt: Clean up and switch to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-sc520_wdt-clean-up-and-switch-to-unlocked_ioctl.patch

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
Subject: watchdog: sc520_wdt: Clean up and switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/sc520_wdt.c |  161 +++++++++++++++++----------------
 1 file changed, 86 insertions(+), 75 deletions(-)

diff -puN drivers/watchdog/sc520_wdt.c~watchdog-sc520_wdt-clean-up-and-switch-to-unlocked_ioctl drivers/watchdog/sc520_wdt.c
--- a/drivers/watchdog/sc520_wdt.c~watchdog-sc520_wdt-clean-up-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/sc520_wdt.c
@@ -64,9 +64,9 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #define OUR_NAME "sc520_wdt"
@@ -91,13 +91,18 @@
  */
 
 #define WATCHDOG_TIMEOUT 30		/* 30 sec default timeout */
-static int timeout = WATCHDOG_TIMEOUT;	/* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+/* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+static int timeout = WATCHDOG_TIMEOUT;
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=3600, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1 <= timeout <= 3600, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * AMD Elan SC520 - Watchdog Timer Registers
@@ -136,8 +141,7 @@ static void wdt_timer_ping(unsigned long
 	/* If we got a heartbeat pulse within the WDT_US_INTERVAL
 	 * we agree to ping the WDT
 	 */
-	if(time_before(jiffies, next_heartbeat))
-	{
+	if (time_before(jiffies, next_heartbeat)) {
 		/* Ping the WDT */
 		spin_lock(&wdt_spinlock);
 		writew(0xAAAA, wdtmrctl);
@@ -146,9 +150,9 @@ static void wdt_timer_ping(unsigned long
 
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
@@ -162,7 +166,7 @@ static void wdt_config(int writeval)
 
 	/* buy some time (ping) */
 	spin_lock_irqsave(&wdt_spinlock, flags);
-	dummy=readw(wdtmrctl);	/* ensure write synchronization */
+	dummy = readw(wdtmrctl);	/* ensure write synchronization */
 	writew(0xAAAA, wdtmrctl);
 	writew(0x5555, wdtmrctl);
 	/* unlock WDT = make WDT configuration register writable one time */
@@ -219,10 +223,11 @@ static int wdt_set_heartbeat(int t)
  *	/dev/watchdog handling
  */
 
-static ssize_t fop_write(struct file * file, const char __user * buf, size_t count, loff_t * ppos)
+static ssize_t fop_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-	if(count) {
+	if (count) {
 		if (!nowayout) {
 			size_t ofs;
 
@@ -231,25 +236,26 @@ static ssize_t fop_write(struct file * f
 			wdt_expect_close = 0;
 
 			/* now scan */
-			for(ofs = 0; ofs != count; ofs++) {
+			for (ofs = 0; ofs != count; ofs++) {
 				char c;
 				if (get_user(c, buf + ofs))
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
 		__module_get(THIS_MODULE);
@@ -259,12 +265,13 @@ static int fop_open(struct inode * inode
 	return nonseekable_open(inode, file);
 }
 
-static int fop_close(struct inode * inode, struct file * file)
+static int fop_close(struct inode *inode, struct file *file)
 {
-	if(wdt_expect_close == 42) {
+	if (wdt_expect_close == 42)
 		wdt_turnoff();
-	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		wdt_keepalive();
 	}
 	clear_bit(0, &wdt_is_open);
@@ -272,63 +279,63 @@ static int fop_close(struct inode * inod
 	return 0;
 }
 
-static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	unsigned long arg)
+static int fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static const struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "SC520",
 	};
 
-	switch(cmd)
+	switch (cmd)
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
+	{
+		int new_options, retval = -EINVAL;
 
-			if(new_options & WDIOS_ENABLECARD) {
-				wdt_startup();
-				retval = 0;
-			}
+		if (get_user(new_options, p))
+			return -EFAULT;
+
+		if (new_options & WDIOS_DISABLECARD) {
+			wdt_turnoff();
+			retval = 0;
+		}
 
-			return retval;
+		if (new_options & WDIOS_ENABLECARD) {
+			wdt_startup();
+			retval = 0;
 		}
-		case WDIOC_SETTIMEOUT:
-		{
-			int new_timeout;
 
-			if(get_user(new_timeout, p))
-				return -EFAULT;
+		return retval;
+	}
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_timeout;
 
-			if(wdt_set_heartbeat(new_timeout))
-				return -EINVAL;
+		if (get_user(new_timeout, p))
+			return -EFAULT;
 
-			wdt_keepalive();
-			/* Fall through */
-		}
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
+		if (wdt_set_heartbeat(new_timeout))
+			return -EINVAL;
+
+		wdt_keepalive();
+		/* Fall through */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
 	}
 }
 
@@ -354,7 +361,7 @@ static struct miscdevice wdt_miscdev = {
 static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_turnoff();
 	return NOTIFY_DONE;
 }
@@ -383,11 +390,13 @@ static int __init sc520_wdt_init(void)
 {
 	int rc = -EBUSY;
 
-	/* Check that the timeout value is within it's range ; if not reset to the default */
+	/* Check that the timeout value is within it's range ;
+	   if not reset to the default */
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX "timeout value must be 1<=timeout<=3600, using %d\n",
-			WATCHDOG_TIMEOUT);
+		printk(KERN_INFO PFX
+		    "timeout value must be 1 <= timeout <= 3600, using %d\n",
+							WATCHDOG_TIMEOUT);
 	}
 
 	wdtmrctl = ioremap((unsigned long)(MMCR_BASE + OFFS_WDTMRCTL), 2);
@@ -399,20 +408,22 @@ static int __init sc520_wdt_init(void)
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_ioremap;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, rc);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, rc);
 		goto err_out_notifier;
 	}
 
-	printk(KERN_INFO PFX "WDT driver for SC520 initialised. timeout=%d sec (nowayout=%d)\n",
-		timeout,nowayout);
+	printk(KERN_INFO PFX
+	   "WDT driver for SC520 initialised. timeout=%d sec (nowayout=%d)\n",
+							timeout, nowayout);
 
 	return 0;
 
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

