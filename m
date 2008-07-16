From: akpm@linux-foundation.org
Subject: - watchdog-ks8695_wdt-clean-up-coding-style-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:21 -0700
Message-ID: <200807162136.m6GLaLnb014188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757149AbYGPVhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: ks8695_wdt: clean up, coding style, unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-ks8695_wdt-clean-up-coding-style-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: ks8695_wdt: clean up, coding style, unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/ks8695_wdt.c |  119 ++++++++++++++++----------------
 1 file changed, 62 insertions(+), 57 deletions(-)

diff -puN drivers/watchdog/ks8695_wdt.c~watchdog-ks8695_wdt-clean-up-coding-style-unlocked_ioctl drivers/watchdog/ks8695_wdt.c
--- a/drivers/watchdog/ks8695_wdt.c~watchdog-ks8695_wdt-clean-up-coding-style-unlocked_ioctl
+++ a/drivers/watchdog/ks8695_wdt.c
@@ -19,8 +19,8 @@
 #include <linux/platform_device.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/arch/regs-timer.h>
 
 
@@ -31,38 +31,44 @@ static int wdt_time = WDT_DEFAULT_TIME;
 static int nowayout = WATCHDOG_NOWAYOUT;
 
 module_param(wdt_time, int, 0);
-MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="__MODULE_STRING(WDT_DEFAULT_TIME) ")");
+MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="
+					__MODULE_STRING(WDT_DEFAULT_TIME) ")");
 
 #ifdef CONFIG_WATCHDOG_NOWAYOUT
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 #endif
 
 
 static unsigned long ks8695wdt_busy;
+static spinlock_t ks8695_lock;
 
 /* ......................................................................... */
 
 /*
  * Disable the watchdog.
  */
-static void inline ks8695_wdt_stop(void)
+static inline void ks8695_wdt_stop(void)
 {
 	unsigned long tmcon;
 
+	spin_lock(&ks8695_lock);
 	/* disable timer0 */
 	tmcon = __raw_readl(KS8695_TMR_VA + KS8695_TMCON);
 	__raw_writel(tmcon & ~TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
+	spin_unlock(&ks8695_lock);
 }
 
 /*
  * Enable and reset the watchdog.
  */
-static void inline ks8695_wdt_start(void)
+static inline void ks8695_wdt_start(void)
 {
 	unsigned long tmcon;
 	unsigned long tval = wdt_time * CLOCK_TICK_RATE;
 
+	spin_lock(&ks8695_lock);
 	/* disable timer0 */
 	tmcon = __raw_readl(KS8695_TMR_VA + KS8695_TMCON);
 	__raw_writel(tmcon & ~TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
@@ -73,19 +79,22 @@ static void inline ks8695_wdt_start(void
 	/* re-enable timer0 */
 	tmcon = __raw_readl(KS8695_TMR_VA + KS8695_TMCON);
 	__raw_writel(tmcon | TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
+	spin_unlock(&ks8695_lock);
 }
 
 /*
  * Reload the watchdog timer.  (ie, pat the watchdog)
  */
-static void inline ks8695_wdt_reload(void)
+static inline void ks8695_wdt_reload(void)
 {
 	unsigned long tmcon;
 
+	spin_lock(&ks8695_lock);
 	/* disable, then re-enable timer0 */
 	tmcon = __raw_readl(KS8695_TMR_VA + KS8695_TMCON);
 	__raw_writel(tmcon & ~TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
 	__raw_writel(tmcon | TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
+	spin_unlock(&ks8695_lock);
 }
 
 /*
@@ -102,7 +111,8 @@ static int ks8695_wdt_settimeout(int new
 	if ((new_time <= 0) || (new_time > WDT_MAX_TIME))
 		return -EINVAL;
 
-	/* Set new watchdog time. It will be used when ks8695_wdt_start() is called. */
+	/* Set new watchdog time. It will be used when
+	   ks8695_wdt_start() is called. */
 	wdt_time = new_time;
 	return 0;
 }
@@ -128,9 +138,9 @@ static int ks8695_wdt_open(struct inode 
  */
 static int ks8695_wdt_close(struct inode *inode, struct file *file)
 {
+	/* Disable the watchdog when file is closed */
 	if (!nowayout)
-		ks8695_wdt_stop();	/* Disable the watchdog when file is closed */
-
+		ks8695_wdt_stop();
 	clear_bit(0, &ks8695wdt_busy);
 	return 0;
 }
@@ -143,60 +153,52 @@ static struct watchdog_info ks8695_wdt_i
 /*
  * Handle commands from user-space.
  */
-static int ks8695_wdt_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long ks8695_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_value;
 
-	switch(cmd) {
-		case WDIOC_KEEPALIVE:
-			ks8695_wdt_reload();	/* pat the watchdog */
-			return 0;
-
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ks8695_wdt_info, sizeof(ks8695_wdt_info)) ? -EFAULT : 0;
-
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_value, p))
-				return -EFAULT;
-
-			if (ks8695_wdt_settimeout(new_value))
-				return -EINVAL;
-
-			/* Enable new time value */
+	switch (cmd) {
+	case WDIOC_KEEPALIVE:
+		ks8695_wdt_reload();	/* pat the watchdog */
+		return 0;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ks8695_wdt_info,
+					sizeof(ks8695_wdt_info)) ? -EFAULT : 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		if (ks8695_wdt_settimeout(new_value))
+			return -EINVAL;
+		/* Enable new time value */
+		ks8695_wdt_start();
+		/* Return current value */
+		return put_user(wdt_time, p);
+	case WDIOC_GETTIMEOUT:
+		return put_user(wdt_time, p);
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		if (new_value & WDIOS_DISABLECARD)
+			ks8695_wdt_stop();
+		if (new_value & WDIOS_ENABLECARD)
 			ks8695_wdt_start();
-
-			/* Return current value */
-			return put_user(wdt_time, p);
-
-		case WDIOC_GETTIMEOUT:
-			return put_user(wdt_time, p);
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-
-		case WDIOC_SETOPTIONS:
-			if (get_user(new_value, p))
-				return -EFAULT;
-
-			if (new_value & WDIOS_DISABLECARD)
-				ks8695_wdt_stop();
-			if (new_value & WDIOS_ENABLECARD)
-				ks8695_wdt_start();
-			return 0;
-
-		default:
-			return -ENOTTY;
+		return 0;
+	default:
+		return -ENOTTY;
 	}
 }
 
 /*
  * Pat the watchdog whenever device is written to.
  */
-static ssize_t ks8695_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t ks8695_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	ks8695_wdt_reload();		/* pat the watchdog */
 	return len;
@@ -207,7 +209,7 @@ static ssize_t ks8695_wdt_write(struct f
 static const struct file_operations ks8695wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= ks8695_wdt_ioctl,
+	.unlocked_ioctl	= ks8695_wdt_ioctl,
 	.open		= ks8695_wdt_open,
 	.release	= ks8695_wdt_close,
 	.write		= ks8695_wdt_write,
@@ -231,7 +233,8 @@ static int __init ks8695wdt_probe(struct
 	if (res)
 		return res;
 
-	printk("KS8695 Watchdog Timer enabled (%d seconds%s)\n", wdt_time, nowayout ? ", nowayout" : "");
+	printk(KERN_INFO "KS8695 Watchdog Timer enabled (%d seconds%s)\n",
+				wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
@@ -285,12 +288,14 @@ static struct platform_driver ks8695wdt_
 
 static int __init ks8695_wdt_init(void)
 {
-	/* Check that the heartbeat value is within range; if not reset to the default */
+	spin_lock_init(&ks8695_lock);
+	/* Check that the heartbeat value is within range;
+	   if not reset to the default */
 	if (ks8695_wdt_settimeout(wdt_time)) {
 		ks8695_wdt_settimeout(WDT_DEFAULT_TIME);
-		pr_info("ks8695_wdt: wdt_time value must be 1 <= wdt_time <= %i, using %d\n", wdt_time, WDT_MAX_TIME);
+		pr_info("ks8695_wdt: wdt_time value must be 1 <= wdt_time <= %i, using %d\n",
+							wdt_time, WDT_MAX_TIME);
 	}
-
 	return platform_driver_register(&ks8695wdt_driver);
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

