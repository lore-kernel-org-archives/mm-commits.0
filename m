From: akpm@linux-foundation.org
Subject: - watchdog-ep93xx_wdt-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:57 -0700
Message-ID: <200807162135.m6GLZvPq014139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756900AbYGPVgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:36:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: ep93xx_wdt: unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-ep93xx_wdt-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: ep93xx_wdt: unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/ep93xx_wdt.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/watchdog/ep93xx_wdt.c~watchdog-ep93xx_wdt-unlocked_ioctl drivers/watchdog/ep93xx_wdt.c
--- a/drivers/watchdog/ep93xx_wdt.c~watchdog-ep93xx_wdt-unlocked_ioctl
+++ a/drivers/watchdog/ep93xx_wdt.c
@@ -28,9 +28,9 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/timer.h>
+#include <linux/uaccess.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
 
 #define WDT_VERSION	"0.3"
 #define PFX		"ep93xx_wdt: "
@@ -136,9 +136,8 @@ static struct watchdog_info ident = {
 	.identity = "EP93xx Watchdog",
 };
 
-static int
-ep93xx_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		 unsigned long arg)
+static long ep93xx_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
 
@@ -174,8 +173,8 @@ static int ep93xx_wdt_release(struct ino
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_shutdown();
 	else
-		printk(KERN_CRIT PFX "Device closed unexpectedly - "
-			"timer will not stop\n");
+		printk(KERN_CRIT PFX
+			"Device closed unexpectedly - timer will not stop\n");
 
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
@@ -186,7 +185,7 @@ static int ep93xx_wdt_release(struct ino
 static const struct file_operations ep93xx_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ep93xx_wdt_write,
-	.ioctl		= ep93xx_wdt_ioctl,
+	.unlocked_ioctl	= ep93xx_wdt_ioctl,
 	.open		= ep93xx_wdt_open,
 	.release	= ep93xx_wdt_release,
 };
@@ -243,7 +242,9 @@ module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
 
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=3600, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1<=timeout<=3600, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 MODULE_AUTHOR("Ray Lehtiniemi <rayl@mail.com>,"
 		"Alessandro Zummo <a.zummo@towertech.it>");
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

