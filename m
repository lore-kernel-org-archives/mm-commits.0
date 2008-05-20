From: akpm@linux-foundation.org
Subject: + watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:29 -0700
Message-ID: <200805200828.m4K8STJq013170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761097AbYETI3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:29:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: s3c2410: watchdog cleanup and switch to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl.patch

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
Subject: watchdog: s3c2410: watchdog cleanup and switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/s3c2410_wdt.c |  148 ++++++++++++++++---------------
 1 file changed, 80 insertions(+), 68 deletions(-)

diff -puN drivers/watchdog/s3c2410_wdt.c~watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl drivers/watchdog/s3c2410_wdt.c
--- a/drivers/watchdog/s3c2410_wdt.c~watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/s3c2410_wdt.c
@@ -46,9 +46,8 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/clk.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <asm/arch/map.h>
 
@@ -65,8 +64,8 @@
 static int nowayout	= WATCHDOG_NOWAYOUT;
 static int tmr_margin	= CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME;
 static int tmr_atboot	= CONFIG_S3C2410_WATCHDOG_ATBOOT;
-static int soft_noboot	= 0;
-static int debug	= 0;
+static int soft_noboot;
+static int debug;
 
 module_param(tmr_margin,  int, 0);
 module_param(tmr_atboot,  int, 0);
@@ -74,24 +73,23 @@ module_param(nowayout,    int, 0);
 module_param(soft_noboot, int, 0);
 module_param(debug,	  int, 0);
 
-MODULE_PARM_DESC(tmr_margin, "Watchdog tmr_margin in seconds. default=" __MODULE_STRING(CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME) ")");
-
-MODULE_PARM_DESC(tmr_atboot, "Watchdog is started at boot time if set to 1, default=" __MODULE_STRING(CONFIG_S3C2410_WATCHDOG_ATBOOT));
-
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-
+MODULE_PARM_DESC(tmr_margin, "Watchdog tmr_margin in seconds. default="
+		__MODULE_STRING(CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME) ")");
+MODULE_PARM_DESC(tmr_atboot,
+		"Watchdog is started at boot time if set to 1, default="
+			__MODULE_STRING(CONFIG_S3C2410_WATCHDOG_ATBOOT));
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+			__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 MODULE_PARM_DESC(soft_noboot, "Watchdog action, set to 1 to ignore reboots, 0 to reboot (default depends on ONLY_TESTING)");
-
 MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug, (default 0)");
 
 
 typedef enum close_state {
 	CLOSE_STATE_NOT,
-	CLOSE_STATE_ALLOW=0x4021
+	CLOSE_STATE_ALLOW = 0x4021
 } close_state_t;
 
-static DECLARE_MUTEX(open_lock);
-
+static unsigned long open_lock;
 static struct device    *wdt_dev;	/* platform device attached to */
 static struct resource	*wdt_mem;
 static struct resource	*wdt_irq;
@@ -99,38 +97,58 @@ static struct clk	*wdt_clock;
 static void __iomem	*wdt_base;
 static unsigned int	 wdt_count;
 static close_state_t	 allow_close;
+static DEFINE_SPINLOCK(wdt_lock);
 
 /* watchdog control routines */
 
 #define DBG(msg...) do { \
 	if (debug) \
 		printk(KERN_INFO msg); \
-	} while(0)
+	} while (0)
 
 /* functions */
 
-static int s3c2410wdt_keepalive(void)
+static void s3c2410wdt_keepalive(void)
 {
+	spin_lock(&wdt_lock);
 	writel(wdt_count, wdt_base + S3C2410_WTCNT);
-	return 0;
+	spin_unlock(&wdt_lock);
 }
 
-static int s3c2410wdt_stop(void)
+static void __s3c2410wdt_stop(void)
 {
 	unsigned long wtcon;
 
+	spin_lock(&wdt_lock);
 	wtcon = readl(wdt_base + S3C2410_WTCON);
 	wtcon &= ~(S3C2410_WTCON_ENABLE | S3C2410_WTCON_RSTEN);
 	writel(wtcon, wdt_base + S3C2410_WTCON);
+	spin_unlock(&wdt_lock);
+}
 
-	return 0;
+static void __s3c2410wdt_stop(void)
+{
+	unsigned long wtcon;
+
+	wtcon = readl(wdt_base + S3C2410_WTCON);
+	wtcon &= ~(S3C2410_WTCON_ENABLE | S3C2410_WTCON_RSTEN);
+	writel(wtcon, wdt_base + S3C2410_WTCON);
+}
+
+static void s3c2410wdt_stop(void)
+{
+	spin_lock(&wdt_lock);
+	__s3c2410wdt_stop();
+	spin_unlock(&wdt_lock);
 }
 
-static int s3c2410wdt_start(void)
+static void s3c2410wdt_start(void)
 {
 	unsigned long wtcon;
 
-	s3c2410wdt_stop();
+	spin_lock(&wdt_lock);
+
+	__s3c2410wdt_stop();
 
 	wtcon = readl(wdt_base + S3C2410_WTCON);
 	wtcon |= S3C2410_WTCON_ENABLE | S3C2410_WTCON_DIV128;
@@ -149,6 +167,7 @@ static int s3c2410wdt_start(void)
 	writel(wdt_count, wdt_base + S3C2410_WTDAT);
 	writel(wdt_count, wdt_base + S3C2410_WTCNT);
 	writel(wtcon, wdt_base + S3C2410_WTCON);
+	spin_unlock(&wdt_lock);
 
 	return 0;
 }
@@ -211,7 +230,7 @@ static int s3c2410wdt_set_heartbeat(int 
 
 static int s3c2410wdt_open(struct inode *inode, struct file *file)
 {
-	if(!down_nowait(&open_lock))
+	if (test_and_set_bit(0, &open_lock))
 		return -EBUSY;
 
 	if (nowayout)
@@ -231,15 +250,14 @@ static int s3c2410wdt_release(struct ino
 	 * 	Lock it in if it's a module and we set nowayout
 	 */
 
-	if (allow_close == CLOSE_STATE_ALLOW) {
+	if (allow_close == CLOSE_STATE_ALLOW)
 		s3c2410wdt_stop();
-	} else {
+	else {
 		dev_err(wdt_dev, "Unexpected close, not stopping watchdog\n");
 		s3c2410wdt_keepalive();
 	}
-
 	allow_close = CLOSE_STATE_NOT;
-	up(&open_lock);
+	clear_bit(0, &open_lock);
 	return 0;
 }
 
@@ -249,7 +267,7 @@ static ssize_t s3c2410wdt_write(struct f
 	/*
 	 *	Refresh the timer.
 	 */
-	if(len) {
+	if (len) {
 		if (!nowayout) {
 			size_t i;
 
@@ -265,7 +283,6 @@ static ssize_t s3c2410wdt_write(struct f
 					allow_close = CLOSE_STATE_ALLOW;
 			}
 		}
-
 		s3c2410wdt_keepalive();
 	}
 	return len;
@@ -273,48 +290,41 @@ static ssize_t s3c2410wdt_write(struct f
 
 #define OPTIONS WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE
 
-static struct watchdog_info s3c2410_wdt_ident = {
+static const struct watchdog_info s3c2410_wdt_ident = {
 	.options          =     OPTIONS,
 	.firmware_version =	0,
 	.identity         =	"S3C2410 Watchdog",
 };
 
 
-static int s3c2410wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long s3c2410wdt_ioctl(struct file *file,	unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_margin;
 
 	switch (cmd) {
-		default:
-			return -ENOTTY;
-
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &s3c2410_wdt_ident,
-				sizeof(s3c2410_wdt_ident)) ? -EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-
-		case WDIOC_KEEPALIVE:
-			s3c2410wdt_keepalive();
-			return 0;
-
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_margin, p))
-				return -EFAULT;
-
-			if (s3c2410wdt_set_heartbeat(new_margin))
-				return -EINVAL;
-
-			s3c2410wdt_keepalive();
-			return put_user(tmr_margin, p);
-
-		case WDIOC_GETTIMEOUT:
-			return put_user(tmr_margin, p);
+	default:
+		return -ENOTTY;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &s3c2410_wdt_ident,
+			sizeof(s3c2410_wdt_ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		s3c2410wdt_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_margin, p))
+			return -EFAULT;
+		if (s3c2410wdt_set_heartbeat(new_margin))
+			return -EINVAL;
+		s3c2410wdt_keepalive();
+		return put_user(tmr_margin, p);
+	case WDIOC_GETTIMEOUT:
+		return put_user(tmr_margin, p);
 	}
 }
 
@@ -324,7 +334,7 @@ static const struct file_operations s3c2
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= s3c2410wdt_write,
-	.ioctl		= s3c2410wdt_ioctl,
+	.unlocked_ioctl	= s3c2410wdt_ioctl,
 	.open		= s3c2410wdt_open,
 	.release	= s3c2410wdt_release,
 };
@@ -411,14 +421,15 @@ static int s3c2410wdt_probe(struct platf
 	 * not, try the default value */
 
 	if (s3c2410wdt_set_heartbeat(tmr_margin)) {
-		started = s3c2410wdt_set_heartbeat(CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME);
+		started = s3c2410wdt_set_heartbeat(
+					CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME);
 
-		if (started == 0) {
-			dev_info(dev,"tmr_margin value out of range, default %d used\n",
+		if (started == 0)
+			dev_info(dev,
+			   "tmr_margin value out of range, default %d used\n",
 			       CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME);
-		} else {
+		else
 			dev_info(dev, "default timer value is out of range, cannot start\n");
-		}
 	}
 
 	ret = misc_register(&s3c2410wdt_miscdev);
@@ -447,7 +458,7 @@ static int s3c2410wdt_probe(struct platf
 		 (wtcon & S3C2410_WTCON_ENABLE) ?  "" : "in",
 		 (wtcon & S3C2410_WTCON_RSTEN) ? "" : "dis",
 		 (wtcon & S3C2410_WTCON_INTEN) ? "" : "en");
-	
+
 	return 0;
 
  err_clk:
@@ -487,7 +498,7 @@ static int s3c2410wdt_remove(struct plat
 
 static void s3c2410wdt_shutdown(struct platform_device *dev)
 {
-	s3c2410wdt_stop();	
+	s3c2410wdt_stop();
 }
 
 #ifdef CONFIG_PM
@@ -540,7 +551,8 @@ static struct platform_driver s3c2410wdt
 };
 
 
-static char banner[] __initdata = KERN_INFO "S3C2410 Watchdog Timer, (c) 2004 Simtec Electronics\n";
+static char banner[] __initdata =
+	KERN_INFO "S3C2410 Watchdog Timer, (c) 2004 Simtec Electronics\n";
 
 static int __init watchdog_init(void)
 {
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

