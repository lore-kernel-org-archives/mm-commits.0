From: akpm@linux-foundation.org
Subject: + watchdog-shwdt-coding-style-cleanup-switch-to-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:44 -0700
Message-ID: <200805200828.m4K8SiuR013200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761224AbYETI3P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:29:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: shwdt: coding style, cleanup, switch to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-shwdt-coding-style-cleanup-switch-to-unlocked_ioctl.patch

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
Subject: watchdog: shwdt: coding style, cleanup, switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/shwdt.c |  139 +++++++++++++++++++++----------------
 1 file changed, 82 insertions(+), 57 deletions(-)

diff -puN drivers/watchdog/shwdt.c~watchdog-shwdt-coding-style-cleanup-switch-to-unlocked_ioctl drivers/watchdog/shwdt.c
--- a/drivers/watchdog/shwdt.c~watchdog-shwdt-coding-style-cleanup-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/shwdt.c
@@ -28,9 +28,9 @@
 #include <linux/ioport.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
-#include <asm/watchdog.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
 
 #define PFX "shwdt: "
 
@@ -72,6 +72,7 @@ static struct watchdog_info sh_wdt_info;
 static char shwdt_expect_close;
 static DEFINE_TIMER(timer, sh_wdt_ping, 0, 0);
 static unsigned long next_heartbeat;
+static DEFINE_SPINLOCK(shwdt_lock);
 
 #define WATCHDOG_HEARTBEAT 30			/* 30 sec default heartbeat */
 static int heartbeat = WATCHDOG_HEARTBEAT;	/* in seconds */
@@ -86,6 +87,9 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 static void sh_wdt_start(void)
 {
 	__u8 csr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
 
 	next_heartbeat = jiffies + (heartbeat * HZ);
 	mod_timer(&timer, next_ping_period(clock_division_ratio));
@@ -123,6 +127,7 @@ static void sh_wdt_start(void)
 	csr &= ~RSTCSR_RSTS;
 	sh_wdt_write_rstcsr(csr);
 #endif
+	spin_unlock_irqrestore(&wdt_lock, flags);
 }
 
 /**
@@ -132,12 +137,16 @@ static void sh_wdt_start(void)
 static void sh_wdt_stop(void)
 {
 	__u8 csr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
 
 	del_timer(&timer);
 
 	csr = sh_wdt_read_csr();
 	csr &= ~WTCSR_TME;
 	sh_wdt_write_csr(csr);
+	spin_unlock_irqrestore(&wdt_lock, flags);
 }
 
 /**
@@ -146,7 +155,11 @@ static void sh_wdt_stop(void)
  */
 static inline void sh_wdt_keepalive(void)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
 	next_heartbeat = jiffies + (heartbeat * HZ);
+	spin_unlock_irqrestore(&wdt_lock, flags);
 }
 
 /**
@@ -155,10 +168,14 @@ static inline void sh_wdt_keepalive(void
  */
 static int sh_wdt_set_heartbeat(int t)
 {
-	if (unlikely((t < 1) || (t > 3600))) /* arbitrary upper limit */
+	unsigned long flags;
+
+	if (unlikely(t < 1 || t > 3600)) /* arbitrary upper limit */
 		return -EINVAL;
 
+	spin_lock_irqsave(&wdt_lock, flags);
 	heartbeat = t;
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
 }
 
@@ -170,6 +187,9 @@ static int sh_wdt_set_heartbeat(int t)
  */
 static void sh_wdt_ping(unsigned long data)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
 	if (time_before(jiffies, next_heartbeat)) {
 		__u8 csr;
 
@@ -183,6 +203,7 @@ static void sh_wdt_ping(unsigned long da
 	} else
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping "
 		       "the watchdog\n");
+	spin_unlock_irqrestore(&wdt_lock, flags);
 }
 
 /**
@@ -310,7 +331,6 @@ static int sh_wdt_mmap(struct file *file
 
 /**
  * 	sh_wdt_ioctl - Query Device
- * 	@inode: inode of device
  * 	@file: file handle of device
  * 	@cmd: watchdog command
  * 	@arg: argument
@@ -318,53 +338,51 @@ static int sh_wdt_mmap(struct file *file
  * 	Query basic information from the device or ping it, as outlined by the
  * 	watchdog API.
  */
-static int sh_wdt_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long sh_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int new_heartbeat;
 	int options, retval = -EINVAL;
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user((struct watchdog_info *)arg,
-					  &sh_wdt_info,
-					  sizeof(sh_wdt_info)) ? -EFAULT : 0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, (int *)arg);
-		case WDIOC_KEEPALIVE:
-			sh_wdt_keepalive();
-			return 0;
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_heartbeat, (int *)arg))
-				return -EFAULT;
-
-			if (sh_wdt_set_heartbeat(new_heartbeat))
-				return -EINVAL;
-
-			sh_wdt_keepalive();
-			/* Fall */
-		case WDIOC_GETTIMEOUT:
-			return put_user(heartbeat, (int *)arg);
-		case WDIOC_SETOPTIONS:
-			if (get_user(options, (int *)arg))
-				return -EFAULT;
-
-			if (options & WDIOS_DISABLECARD) {
-				sh_wdt_stop();
-				retval = 0;
-			}
+	case WDIOC_GETSUPPORT:
+		return copy_to_user((struct watchdog_info *)arg,
+			  &sh_wdt_info, sizeof(sh_wdt_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, (int *)arg);
+	case WDIOC_KEEPALIVE:
+		sh_wdt_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_heartbeat, (int *)arg))
+			return -EFAULT;
 
-			if (options & WDIOS_ENABLECARD) {
-				sh_wdt_start();
-				retval = 0;
-			}
+		if (sh_wdt_set_heartbeat(new_heartbeat))
+			return -EINVAL;
 
-			return retval;
-		default:
-			return -ENOTTY;
-	}
+		sh_wdt_keepalive();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, (int *)arg);
+	case WDIOC_SETOPTIONS:
+		if (get_user(options, (int *)arg))
+			return -EFAULT;
+
+		if (options & WDIOS_DISABLECARD) {
+			sh_wdt_stop();
+			retval = 0;
+		}
 
+		if (options & WDIOS_ENABLECARD) {
+			sh_wdt_start();
+			retval = 0;
+		}
+
+		return retval;
+	default:
+		return -ENOTTY;
+	}
 	return 0;
 }
 
@@ -390,13 +408,13 @@ static const struct file_operations sh_w
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= sh_wdt_write,
-	.ioctl		= sh_wdt_ioctl,
+	.unlocked_ioctl	= sh_wdt_ioctl,
 	.open		= sh_wdt_open,
 	.release	= sh_wdt_close,
 	.mmap		= sh_wdt_mmap,
 };
 
-static struct watchdog_info sh_wdt_info = {
+static const struct watchdog_info sh_wdt_info = {
 	.options		= WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
 				  WDIOF_MAGICCLOSE,
 	.firmware_version	= 1,
@@ -422,30 +440,33 @@ static int __init sh_wdt_init(void)
 {
 	int rc;
 
-	if ((clock_division_ratio < 0x5) || (clock_division_ratio > 0x7)) {
+	if (clock_division_ratio < 0x5 || clock_division_ratio > 0x7) {
 		clock_division_ratio = WTCSR_CKS_4096;
-		printk(KERN_INFO PFX "clock_division_ratio value must "
-		       "be 0x5<=x<=0x7, using %d\n", clock_division_ratio);
+		printk(KERN_INFO PFX
+		  "clock_division_ratio value must be 0x5<=x<=0x7, using %d\n",
+				clock_division_ratio);
 	}
 
 	rc = sh_wdt_set_heartbeat(heartbeat);
 	if (unlikely(rc)) {
 		heartbeat = WATCHDOG_HEARTBEAT;
-		printk(KERN_INFO PFX "heartbeat value must "
-		       "be 1<=x<=3600, using %d\n", heartbeat);
+		printk(KERN_INFO PFX
+			"heartbeat value must be 1<=x<=3600, using %d\n",
+								heartbeat);
 	}
 
 	rc = register_reboot_notifier(&sh_wdt_notifier);
 	if (unlikely(rc)) {
-		printk(KERN_ERR PFX "Can't register reboot notifier (err=%d)\n",
-		       rc);
+		printk(KERN_ERR PFX
+			"Can't register reboot notifier (err=%d)\n", rc);
 		return rc;
 	}
 
 	rc = misc_register(&sh_wdt_miscdev);
 	if (unlikely(rc)) {
-		printk(KERN_ERR PFX "Can't register miscdev on "
-		       "minor=%d (err=%d)\n", sh_wdt_miscdev.minor, rc);
+		printk(KERN_ERR PFX
+			"Can't register miscdev on minor=%d (err=%d)\n",
+						sh_wdt_miscdev.minor, rc);
 		unregister_reboot_notifier(&sh_wdt_notifier);
 		return rc;
 	}
@@ -476,10 +497,14 @@ module_param(clock_division_ratio, int, 
 MODULE_PARM_DESC(clock_division_ratio, "Clock division ratio. Valid ranges are from 0x5 (1.31ms) to 0x7 (5.25ms). (default=" __MODULE_STRING(clock_division_ratio) ")");
 
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (1<=heartbeat<=3600, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat,
+	"Watchdog heartbeat in seconds. (1 <= heartbeat <= 3600, default="
+				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 module_init(sh_wdt_init);
 module_exit(sh_wdt_exit);
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

