From: akpm@linux-foundation.org
Subject: - watchdog-rm9k_wdt-clean-up.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:43 -0700
Message-ID: <200807162136.m6GLahBj014236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758108AbYGPVqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: rm9k_wdt: clean up
has been removed from the -mm tree.  Its filename was
     watchdog-rm9k_wdt-clean-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: rm9k_wdt: clean up
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/rm9k_wdt.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/watchdog/rm9k_wdt.c~watchdog-rm9k_wdt-clean-up drivers/watchdog/rm9k_wdt.c
--- a/drivers/watchdog/rm9k_wdt.c~watchdog-rm9k_wdt-clean-up
+++ a/drivers/watchdog/rm9k_wdt.c
@@ -29,10 +29,10 @@
 #include <linux/notifier.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
-#include <asm/io.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/atomic.h>
 #include <asm/processor.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/rm9k-ocd.h>
 
@@ -53,10 +53,12 @@ static void wdt_gpi_stop(void);
 static void wdt_gpi_set_timeout(unsigned int);
 static int wdt_gpi_open(struct inode *, struct file *);
 static int wdt_gpi_release(struct inode *, struct file *);
-static ssize_t wdt_gpi_write(struct file *, const char __user *, size_t, loff_t *);
+static ssize_t wdt_gpi_write(struct file *, const char __user *, size_t,
+								loff_t *);
 static long wdt_gpi_ioctl(struct file *, unsigned int, unsigned long);
 static int wdt_gpi_notify(struct notifier_block *, unsigned long, void *);
-static const struct resource *wdt_gpi_get_resource(struct platform_device *, const char *, unsigned int);
+static const struct resource *wdt_gpi_get_resource(struct platform_device *,
+						const char *, unsigned int);
 static int __init wdt_gpi_probe(struct device *);
 static int __exit wdt_gpi_remove(struct device *);
 
@@ -68,7 +70,7 @@ static int locked;
 
 
 /* These are set from device resources */
-static void __iomem * wd_regs;
+static void __iomem *wd_regs;
 static unsigned int wd_irq, wd_ctr;
 
 
@@ -216,7 +218,8 @@ static int wdt_gpi_release(struct inode 
 		if (expect_close) {
 			wdt_gpi_stop();
 			free_irq(wd_irq, &miscdev);
-			printk(KERN_INFO "%s: watchdog stopped\n", wdt_gpi_name);
+			printk(KERN_INFO "%s: watchdog stopped\n",
+							wdt_gpi_name);
 		} else {
 			printk(KERN_CRIT "%s: unexpected close() -"
 				" watchdog left running\n",
@@ -241,8 +244,7 @@ wdt_gpi_write(struct file *f, const char
 	return s ? 1 : 0;
 }
 
-static long
-wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+static long wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	long res = -ENOTTY;
 	const long size = _IOC_SIZE(cmd);
@@ -271,7 +273,8 @@ wdt_gpi_ioctl(struct file *f, unsigned i
 	case WDIOC_GETSUPPORT:
 		wdinfo.options = nowayout ?
 			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING :
-			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE;
+			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+			WDIOF_MAGICCLOSE;
 		res = __copy_to_user(argp, &wdinfo, size) ?  -EFAULT : size;
 		break;
 
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

