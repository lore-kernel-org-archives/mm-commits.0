From: akpm@linux-foundation.org
Subject: - watchdog-sa1100_wdt-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:47 -0700
Message-ID: <200807162136.m6GLalW9014242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757880AbYGPVqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: sa1100_wdt: Switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-sa1100_wdt-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: sa1100_wdt: Switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/sa1100_wdt.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN drivers/watchdog/sa1100_wdt.c~watchdog-sa1100_wdt-switch-to-unlocked_ioctl drivers/watchdog/sa1100_wdt.c
--- a/drivers/watchdog/sa1100_wdt.c~watchdog-sa1100_wdt-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/sa1100_wdt.c
@@ -26,13 +26,13 @@
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/uaccess.h>
 
 #ifdef CONFIG_ARCH_PXA
 #include <asm/arch/pxa-regs.h>
 #endif
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
 
 #define OSCR_FREQ		CLOCK_TICK_RATE
 
@@ -45,7 +45,7 @@ static int boot_status;
  */
 static int sa1100dog_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(1,&sa1100wdt_users))
+	if (test_and_set_bit(1, &sa1100wdt_users))
 		return -EBUSY;
 
 	/* Activate SA1100 Watchdog timer */
@@ -66,28 +66,27 @@ static int sa1100dog_open(struct inode *
 static int sa1100dog_release(struct inode *inode, struct file *file)
 {
 	printk(KERN_CRIT "WATCHDOG: Device closed - timer will not stop\n");
-
 	clear_bit(1, &sa1100wdt_users);
-
 	return 0;
 }
 
-static ssize_t sa1100dog_write(struct file *file, const char __user *data, size_t len, loff_t *ppos)
+static ssize_t sa1100dog_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
 {
 	if (len)
 		/* Refresh OSMR3 timer. */
 		OSMR3 = OSCR + pre_margin;
-
 	return len;
 }
 
-static struct watchdog_info ident = {
-	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+static const struct watchdog_info ident = {
+	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT
+				| WDIOF_KEEPALIVEPING,
 	.identity	= "SA1100/PXA255 Watchdog",
 };
 
-static int sa1100dog_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long sa1100dog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -134,18 +133,16 @@ static int sa1100dog_ioctl(struct inode 
 	return ret;
 }
 
-static const struct file_operations sa1100dog_fops =
-{
+static const struct file_operations sa1100dog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= sa1100dog_write,
-	.ioctl		= sa1100dog_ioctl,
+	.unlocked_ioctl	= sa1100dog_ioctl,
 	.open		= sa1100dog_open,
 	.release	= sa1100dog_release,
 };
 
-static struct miscdevice sa1100dog_miscdev =
-{
+static struct miscdevice sa1100dog_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &sa1100dog_fops,
@@ -167,8 +164,9 @@ static int __init sa1100dog_init(void)
 
 	ret = misc_register(&sa1100dog_miscdev);
 	if (ret == 0)
-		printk("SA1100/PXA2xx Watchdog Timer: timer margin %d sec\n",
-		       margin);
+		printk(KERN_INFO
+			"SA1100/PXA2xx Watchdog Timer: timer margin %d sec\n",
+						margin);
 	return ret;
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

