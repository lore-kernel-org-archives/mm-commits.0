From: akpm@linux-foundation.org
Subject: - watchdog-wdt285-switch-to-unlocked_ioctl-and-tidy-up-oddments-of-coding-style.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:37:23 -0700
Message-ID: <200807162137.m6GLbNda014378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757345AbYGPViZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: wdt285: switch to unlocked_ioctl and tidy up oddments of coding style
has been removed from the -mm tree.  Its filename was
     watchdog-wdt285-switch-to-unlocked_ioctl-and-tidy-up-oddments-of-coding-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: wdt285: switch to unlocked_ioctl and tidy up oddments of coding style
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/wdt285.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff -puN drivers/watchdog/wdt285.c~watchdog-wdt285-switch-to-unlocked_ioctl-and-tidy-up-oddments-of-coding-style drivers/watchdog/wdt285.c
--- a/drivers/watchdog/wdt285.c~watchdog-wdt285-switch-to-unlocked_ioctl-and-tidy-up-oddments-of-coding-style
+++ a/drivers/watchdog/wdt285.c
@@ -26,9 +26,9 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/uaccess.h>
+#include <linux/irq.h>
 
-#include <asm/irq.h>
-#include <asm/uaccess.h>
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/hardware/dec21285.h>
@@ -115,8 +115,8 @@ static int watchdog_release(struct inode
 	return 0;
 }
 
-static ssize_t
-watchdog_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t watchdog_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	/*
 	 *	Refresh the timer.
@@ -127,19 +127,18 @@ watchdog_write(struct file *file, const 
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_SETTIMEOUT,
 	.identity	= "Footbridge Watchdog",
 };
 
-static int
-watchdog_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	       unsigned long arg)
+static long watchdog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	unsigned int new_margin;
 	int ret = -ENOTTY;
 
-	switch(cmd) {
+	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		ret = 0;
 		if (copy_to_user((void *)arg, &ident, sizeof(ident)))
@@ -148,7 +147,7 @@ watchdog_ioctl(struct inode *inode, stru
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0,(int *)arg);
+		ret = put_user(0, (int *)arg);
 		break;
 
 	case WDIOC_KEEPALIVE:
@@ -182,7 +181,7 @@ static const struct file_operations watc
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= watchdog_write,
-	.ioctl		= watchdog_ioctl,
+	.unlocked_ioctl	= watchdog_ioctl,
 	.open		= watchdog_open,
 	.release	= watchdog_release,
 };
@@ -204,11 +203,13 @@ static int __init footbridge_watchdog_in
 	if (retval < 0)
 		return retval;
 
-	printk("Footbridge Watchdog Timer: 0.01, timer margin: %d sec\n",
-	       soft_margin);
+	printk(KERN_INFO
+		"Footbridge Watchdog Timer: 0.01, timer margin: %d sec\n",
+								soft_margin);
 
 	if (machine_is_cats())
-		printk("Warning: Watchdog reset may not work on this machine.\n");
+		printk(KERN_WARN
+		  "Warning: Watchdog reset may not work on this machine.\n");
 	return 0;
 }
 
@@ -223,7 +224,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(soft_margin, int, 0);
-MODULE_PARM_DESC(soft_margin,"Watchdog timeout in seconds");
+MODULE_PARM_DESC(soft_margin, "Watchdog timeout in seconds");
 
 module_init(footbridge_watchdog_init);
 module_exit(footbridge_watchdog_exit);
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

