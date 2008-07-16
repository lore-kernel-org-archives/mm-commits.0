From: akpm@linux-foundation.org
Subject: - watchdog-ixp2000_wdt-clean-up-and-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:17 -0700
Message-ID: <200807162136.m6GLaHvX014179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757125AbYGPVhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:37:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: ixp2000_wdt: clean up and unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-ixp2000_wdt-clean-up-and-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: ixp2000_wdt: clean up and unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/ixp2000_wdt.c |   50 ++++++++++++++-----------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff -puN drivers/watchdog/ixp2000_wdt.c~watchdog-ixp2000_wdt-clean-up-and-unlocked_ioctl drivers/watchdog/ixp2000_wdt.c
--- a/drivers/watchdog/ixp2000_wdt.c~watchdog-ixp2000_wdt-clean-up-and-unlocked_ioctl
+++ a/drivers/watchdog/ixp2000_wdt.c
@@ -25,42 +25,45 @@
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/uaccess.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned int heartbeat = 60;	/* (secs) Default is 1 minute */
 static unsigned long wdt_status;
+static spinlock_t wdt_lock;
 
 #define	WDT_IN_USE		0
 #define	WDT_OK_TO_CLOSE		1
 
 static unsigned long wdt_tick_rate;
 
-static void
-wdt_enable(void)
+static void wdt_enable(void)
 {
+	spin_lock(&wdt_lock);
 	ixp2000_reg_write(IXP2000_RESET0, *(IXP2000_RESET0) | WDT_RESET_ENABLE);
 	ixp2000_reg_write(IXP2000_TWDE, WDT_ENABLE);
 	ixp2000_reg_write(IXP2000_T4_CLD, heartbeat * wdt_tick_rate);
 	ixp2000_reg_write(IXP2000_T4_CTL, TIMER_DIVIDER_256 | TIMER_ENABLE);
+	spin_unlock(&wdt_lock);
 }
 
-static void
-wdt_disable(void)
+static void wdt_disable(void)
 {
+	spin_lock(&wdt_lock);
 	ixp2000_reg_write(IXP2000_T4_CTL, 0);
+	spin_unlock(&wdt_lock);
 }
 
-static void
-wdt_keepalive(void)
+static void wdt_keepalive(void)
 {
+	spin_lock(&wdt_lock);
 	ixp2000_reg_write(IXP2000_T4_CLD, heartbeat * wdt_tick_rate);
+	spin_unlock(&wdt_lock);
 }
 
-static int
-ixp2000_wdt_open(struct inode *inode, struct file *file)
+static int ixp2000_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
 		return -EBUSY;
@@ -72,8 +75,8 @@ ixp2000_wdt_open(struct inode *inode, st
 	return nonseekable_open(inode, file);
 }
 
-static ssize_t
-ixp2000_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t ixp2000_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	if (len) {
 		if (!nowayout) {
@@ -103,9 +106,8 @@ static struct watchdog_info ident = {
 	.identity	= "IXP2000 Watchdog",
 };
 
-static int
-ixp2000_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-			unsigned long arg)
+static long ixp2000_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -151,16 +153,13 @@ ixp2000_wdt_ioctl(struct inode *inode, s
 	return ret;
 }
 
-static int
-ixp2000_wdt_release(struct inode *inode, struct file *file)
+static int ixp2000_wdt_release(struct inode *inode, struct file *file)
 {
-	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
+	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_disable();
-	} else {
+	else
 		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
 					"timer will not stop\n");
-	}
-
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
@@ -168,18 +167,16 @@ ixp2000_wdt_release(struct inode *inode,
 }
 
 
-static const struct file_operations ixp2000_wdt_fops =
-{
+static const struct file_operations ixp2000_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= ixp2000_wdt_write,
-	.ioctl		= ixp2000_wdt_ioctl,
+	.unlocked_ioctl	= ixp2000_wdt_ioctl,
 	.open		= ixp2000_wdt_open,
 	.release	= ixp2000_wdt_release,
 };
 
-static struct miscdevice ixp2000_wdt_miscdev =
-{
+static struct miscdevice ixp2000_wdt_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &ixp2000_wdt_fops,
@@ -191,9 +188,8 @@ static int __init ixp2000_wdt_init(void)
 		printk(KERN_INFO "Unable to use IXP2000 watchdog due to IXP2800 erratum #25.\n");
 		return -EIO;
 	}
-
 	wdt_tick_rate = (*IXP2000_T1_CLD * HZ) / 256;
-
+	spin_lock_init(&wdt_lock);
 	return misc_register(&ixp2000_wdt_miscdev);
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

