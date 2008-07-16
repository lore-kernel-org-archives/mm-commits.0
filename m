From: akpm@linux-foundation.org
Subject: - watchdog-ixp4xx_wdt-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:19 -0700
Message-ID: <200807162136.m6GLaJno014184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757864AbYGPVqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: ixp4xx_wdt: unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-ixp4xx_wdt-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: ixp4xx_wdt: unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/ixp4xx_wdt.c |   41 +++++++++++++-------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff -puN drivers/watchdog/ixp4xx_wdt.c~watchdog-ixp4xx_wdt-unlocked_ioctl drivers/watchdog/ixp4xx_wdt.c
--- a/drivers/watchdog/ixp4xx_wdt.c~watchdog-ixp4xx_wdt-unlocked_ioctl
+++ a/drivers/watchdog/ixp4xx_wdt.c
@@ -30,40 +30,40 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 static int heartbeat = 60;	/* (secs) Default is 1 minute */
 static unsigned long wdt_status;
 static unsigned long boot_status;
+static spin_lock_t wdt_lock;
 
 #define WDT_TICK_RATE (IXP4XX_PERIPHERAL_BUS_CLOCK * 1000000UL)
 
 #define	WDT_IN_USE		0
 #define	WDT_OK_TO_CLOSE		1
 
-static void
-wdt_enable(void)
+static void wdt_enable(void)
 {
+	spin_lock(&wdt_lock);
 	*IXP4XX_OSWK = IXP4XX_WDT_KEY;
 	*IXP4XX_OSWE = 0;
 	*IXP4XX_OSWT = WDT_TICK_RATE * heartbeat;
 	*IXP4XX_OSWE = IXP4XX_WDT_COUNT_ENABLE | IXP4XX_WDT_RESET_ENABLE;
 	*IXP4XX_OSWK = 0;
+	spin_unlock(&wdt_lock);
 }
 
-static void
-wdt_disable(void)
+static void wdt_disable(void)
 {
+	spin_lock(&wdt_lock);
 	*IXP4XX_OSWK = IXP4XX_WDT_KEY;
 	*IXP4XX_OSWE = 0;
 	*IXP4XX_OSWK = 0;
+	spin_unlock(&wdt_lock);
 }
 
-static int
-ixp4xx_wdt_open(struct inode *inode, struct file *file)
+static int ixp4xx_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
 		return -EBUSY;
 
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
 	wdt_enable();
-
 	return nonseekable_open(inode, file);
 }
 
@@ -87,7 +87,6 @@ ixp4xx_wdt_write(struct file *file, cons
 		}
 		wdt_enable();
 	}
-
 	return len;
 }
 
@@ -98,9 +97,8 @@ static struct watchdog_info ident = {
 };
 
 
-static int
-ixp4xx_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-			unsigned long arg)
+static long ixp4xx_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -145,16 +143,13 @@ ixp4xx_wdt_ioctl(struct inode *inode, st
 	return ret;
 }
 
-static int
-ixp4xx_wdt_release(struct inode *inode, struct file *file)
+static int ixp4xx_wdt_release(struct inode *inode, struct file *file)
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
 
@@ -167,7 +162,7 @@ static const struct file_operations ixp4
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= ixp4xx_wdt_write,
-	.ioctl		= ixp4xx_wdt_ioctl,
+	.unlocked_ioctl	= ixp4xx_wdt_ioctl,
 	.open		= ixp4xx_wdt_open,
 	.release	= ixp4xx_wdt_release,
 };
@@ -191,14 +186,12 @@ static int __init ixp4xx_wdt_init(void)
 
 		return -ENODEV;
 	}
-
+	spin_lock_init(&wdt_lock);
+	boot_status = (*IXP4XX_OSST & IXP4XX_OSST_TIMER_WARM_RESET) ?
+			WDIOF_CARDRESET : 0;
 	ret = misc_register(&ixp4xx_wdt_miscdev);
 	if (ret == 0)
 		printk("IXP4xx Watchdog Timer: heartbeat %d sec\n", heartbeat);
-
-	boot_status = (*IXP4XX_OSST & IXP4XX_OSST_TIMER_WARM_RESET) ?
-			WDIOF_CARDRESET : 0;
-
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

