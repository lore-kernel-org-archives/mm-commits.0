From: akpm@linux-foundation.org
Subject: - watchdog-at91-watchdog-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:51 -0700
Message-ID: <200807162135.m6GLZpEh014128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756890AbYGPVgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: at91: watchdog to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-at91-watchdog-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: at91: watchdog to unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Review and switch to unlocked_ioctl

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/at91rm9200_wdt.c |  108 ++++++++++++++--------------
 1 file changed, 54 insertions(+), 54 deletions(-)

diff -puN drivers/watchdog/at91rm9200_wdt.c~watchdog-at91-watchdog-to-unlocked_ioctl drivers/watchdog/at91rm9200_wdt.c
--- a/drivers/watchdog/at91rm9200_wdt.c~watchdog-at91-watchdog-to-unlocked_ioctl
+++ a/drivers/watchdog/at91rm9200_wdt.c
@@ -20,7 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/arch/at91_st.h>
 
 
@@ -31,11 +31,14 @@ static int wdt_time = WDT_DEFAULT_TIME;
 static int nowayout = WATCHDOG_NOWAYOUT;
 
 module_param(wdt_time, int, 0);
-MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="__MODULE_STRING(WDT_DEFAULT_TIME) ")");
+MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="
+				__MODULE_STRING(WDT_DEFAULT_TIME) ")");
 
 #ifdef CONFIG_WATCHDOG_NOWAYOUT
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 #endif
 
 
@@ -46,7 +49,7 @@ static unsigned long at91wdt_busy;
 /*
  * Disable the watchdog.
  */
-static void inline at91_wdt_stop(void)
+static inline void at91_wdt_stop(void)
 {
 	at91_sys_write(AT91_ST_WDMR, AT91_ST_EXTEN);
 }
@@ -54,16 +57,17 @@ static void inline at91_wdt_stop(void)
 /*
  * Enable and reset the watchdog.
  */
-static void inline at91_wdt_start(void)
+static inline void at91_wdt_start(void)
 {
-	at91_sys_write(AT91_ST_WDMR, AT91_ST_EXTEN | AT91_ST_RSTEN | (((65536 * wdt_time) >> 8) & AT91_ST_WDV));
+	at91_sys_write(AT91_ST_WDMR, AT91_ST_EXTEN | AT91_ST_RSTEN |
+				(((65536 * wdt_time) >> 8) & AT91_ST_WDV));
 	at91_sys_write(AT91_ST_CR, AT91_ST_WDRST);
 }
 
 /*
  * Reload the watchdog timer.  (ie, pat the watchdog)
  */
-static void inline at91_wdt_reload(void)
+static inline void at91_wdt_reload(void)
 {
 	at91_sys_write(AT91_ST_CR, AT91_ST_WDRST);
 }
@@ -89,8 +93,9 @@ static int at91_wdt_open(struct inode *i
  */
 static int at91_wdt_close(struct inode *inode, struct file *file)
 {
+	/* Disable the watchdog when file is closed */
 	if (!nowayout)
-		at91_wdt_stop();	/* Disable the watchdog when file is closed */
+		at91_wdt_stop();
 
 	clear_bit(0, &at91wdt_busy);
 	return 0;
@@ -110,7 +115,8 @@ static int at91_wdt_settimeout(int new_t
 	if ((new_time <= 0) || (new_time > WDT_MAX_TIME))
 		return -EINVAL;
 
-	/* Set new watchdog time. It will be used when at91_wdt_start() is called. */
+	/* Set new watchdog time. It will be used when
+	   at91_wdt_start() is called. */
 	wdt_time = new_time;
 	return 0;
 }
@@ -123,60 +129,52 @@ static struct watchdog_info at91_wdt_inf
 /*
  * Handle commands from user-space.
  */
-static int at91_wdt_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long at91_wdt_ioct(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_value;
 
-	switch(cmd) {
-		case WDIOC_KEEPALIVE:
-			at91_wdt_reload();	/* pat the watchdog */
-			return 0;
-
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &at91_wdt_info, sizeof(at91_wdt_info)) ? -EFAULT : 0;
-
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_value, p))
-				return -EFAULT;
-
-			if (at91_wdt_settimeout(new_value))
-				return -EINVAL;
-
-			/* Enable new time value */
+	switch (cmd) {
+	case WDIOC_KEEPALIVE:
+		at91_wdt_reload();	/* pat the watchdog */
+		return 0;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &at91_wdt_info,
+				sizeof(at91_wdt_info)) ? -EFAULT : 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		if (at91_wdt_settimeout(new_value))
+			return -EINVAL;
+		/* Enable new time value */
+		at91_wdt_start();
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
+			at91_wdt_stop();
+		if (new_value & WDIOS_ENABLECARD)
 			at91_wdt_start();
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
-				at91_wdt_stop();
-			if (new_value & WDIOS_ENABLECARD)
-				at91_wdt_start();
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
-static ssize_t at91_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t at91_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	at91_wdt_reload();		/* pat the watchdog */
 	return len;
@@ -187,7 +185,7 @@ static ssize_t at91_wdt_write(struct fil
 static const struct file_operations at91wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= at91_wdt_ioctl,
+	.unlocked_ioctl	= at91_wdt_ioctl,
 	.open		= at91_wdt_open,
 	.release	= at91_wdt_close,
 	.write		= at91_wdt_write,
@@ -211,7 +209,8 @@ static int __init at91wdt_probe(struct p
 	if (res)
 		return res;
 
-	printk("AT91 Watchdog Timer enabled (%d seconds%s)\n", wdt_time, nowayout ? ", nowayout" : "");
+	printk(KERN_INFO "AT91 Watchdog Timer enabled (%d seconds%s)\n",
+				wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
@@ -265,7 +264,8 @@ static struct platform_driver at91wdt_dr
 
 static int __init at91_wdt_init(void)
 {
-	/* Check that the heartbeat value is within range; if not reset to the default */
+	/* Check that the heartbeat value is within range;
+	   if not reset to the default */
 	if (at91_wdt_settimeout(wdt_time)) {
 		at91_wdt_settimeout(WDT_DEFAULT_TIME);
 		pr_info("at91_wdt: wdt_time value must be 1 <= wdt_time <= 256, using %d\n", wdt_time);
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

