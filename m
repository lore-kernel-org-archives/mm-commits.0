From: akpm@linux-foundation.org
Subject: - watchdog-omap_wdt-locking-unlocked_ioctl-tidy.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:35 -0700
Message-ID: <200807162136.m6GLaZfH014224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752433AbYGPVqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: omap_wdt: locking, unlocked_ioctl, tidy
has been removed from the -mm tree.  Its filename was
     watchdog-omap_wdt-locking-unlocked_ioctl-tidy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: omap_wdt: locking, unlocked_ioctl, tidy
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/omap_wdt.c |   35 ++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff -puN drivers/watchdog/omap_wdt.c~watchdog-omap_wdt-locking-unlocked_ioctl-tidy drivers/watchdog/omap_wdt.c
--- a/drivers/watchdog/omap_wdt.c~watchdog-omap_wdt-locking-unlocked_ioctl-tidy
+++ a/drivers/watchdog/omap_wdt.c
@@ -41,9 +41,9 @@
 #include <linux/clk.h>
 #include <linux/bitops.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
-#include <asm/hardware.h>
+#include </io.h>
+#include <linux/uaccess.h>
+#include <linux/hardware.h>
 
 #include <asm/arch/prcm.h>
 
@@ -54,11 +54,12 @@ module_param(timer_margin, uint, 0);
 MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
 
 static int omap_wdt_users;
-static struct clk *armwdt_ck = NULL;
-static struct clk *mpu_wdt_ick = NULL;
-static struct clk *mpu_wdt_fck = NULL;
+static struct clk *armwdt_ck;
+static struct clk *mpu_wdt_ick;
+static struct clk *mpu_wdt_fck;
 
 static unsigned int wdt_trgr_pattern = 0x1234;
+static spinlock_t wdt_lock;
 
 static void omap_wdt_ping(void)
 {
@@ -174,22 +175,23 @@ static int omap_wdt_release(struct inode
 	return 0;
 }
 
-static ssize_t
-omap_wdt_write(struct file *file, const char __user *data,
+static ssize_t omap_wdt_write(struct file *file, const char __user *data,
 		size_t len, loff_t *ppos)
 {
 	/* Refresh LOAD_TIME. */
-	if (len)
+	if (len) {
+		spin_lock(&wdt_lock);
 		omap_wdt_ping();
+		spin_unlock(&wdt_lock);
+	}
 	return len;
 }
 
-static int
-omap_wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int new_margin;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.identity = "OMAP Watchdog",
 		.options = WDIOF_SETTIMEOUT,
 		.firmware_version = 0,
@@ -211,18 +213,22 @@ omap_wdt_ioctl(struct inode *inode, stru
 			return put_user(omap_prcm_get_reset_sources(),
 					(int __user *)arg);
 	case WDIOC_KEEPALIVE:
+		spin_lock(&wdt_lock);
 		omap_wdt_ping();
+		spin_unlock(&wdt_lock);
 		return 0;
 	case WDIOC_SETTIMEOUT:
 		if (get_user(new_margin, (int __user *)arg))
 			return -EFAULT;
 		omap_wdt_adjust_timeout(new_margin);
 
+		spin_lock(&wdt_lock);
 		omap_wdt_disable();
 		omap_wdt_set_timeout();
 		omap_wdt_enable();
 
 		omap_wdt_ping();
+		spin_unlock(&wdt_lock);
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
 		return put_user(timer_margin, (int __user *)arg);
@@ -232,7 +238,7 @@ omap_wdt_ioctl(struct inode *inode, stru
 static const struct file_operations omap_wdt_fops = {
 	.owner = THIS_MODULE,
 	.write = omap_wdt_write,
-	.ioctl = omap_wdt_ioctl,
+	.unlocked_ioctl = omap_wdt_ioctl,
 	.open = omap_wdt_open,
 	.release = omap_wdt_release,
 };
@@ -373,6 +379,7 @@ static struct platform_driver omap_wdt_d
 
 static int __init omap_wdt_init(void)
 {
+	spin_lock_init(&wdt_lock);
 	return platform_driver_register(&omap_wdt_driver);
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

