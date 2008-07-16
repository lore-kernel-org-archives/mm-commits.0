From: akpm@linux-foundation.org
Subject: - watchdog-shwdt-coding-style-cleanup-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:37:05 -0700
Message-ID: <200807162137.m6GLb5kj014347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757917AbYGPVqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: shwdt: coding style, cleanup, switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-shwdt-coding-style-cleanup-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

