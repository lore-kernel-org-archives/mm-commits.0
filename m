From: akpm@linux-foundation.org
Subject: + watchdog-ks8695_wdt-clean-up-coding-style-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:10 -0700
Message-ID: <200805200828.m4K8SADv013134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760725AbYETI2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: ks8695_wdt: clean up, coding style, unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-ks8695_wdt-clean-up-coding-style-unlocked_ioctl.patch

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

