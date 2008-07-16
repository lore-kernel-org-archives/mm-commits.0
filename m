From: akpm@linux-foundation.org
Subject: - watchdog-sbc8360-clean-up.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:53 -0700
Message-ID: <200807162136.m6GLarhr014251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328AbYGPVqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: sbc8360: clean up
has been removed from the -mm tree.  Its filename was
     watchdog-sbc8360-clean-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: sbc8360: clean up
From: Alan Cox <alan@redhat.com>

Needs a proper ioctl method adding and stuff

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/sbc8360.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff -puN drivers/watchdog/sbc8360.c~watchdog-sbc8360-clean-up drivers/watchdog/sbc8360.c
--- a/drivers/watchdog/sbc8360.c~watchdog-sbc8360-clean-up
+++ a/drivers/watchdog/sbc8360.c
@@ -48,13 +48,12 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/moduleparam.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static unsigned long sbc8360_is_open;
-static DEFINE_SPINLOCK(sbc8360_lock);
 static char expect_close;
 
 #define PFX "sbc8360: "
@@ -204,7 +203,8 @@ module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout, "Index into timeout table (0-63) (default=27 (60s))");
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout,
-		 "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+		 "Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Kernel methods.
@@ -232,8 +232,8 @@ static void sbc8360_ping(void)
 }
 
 /* Userspace pings kernel driver, or requests clean close */
-static ssize_t sbc8360_write(struct file *file, const char __user * buf,
-			     size_t count, loff_t * ppos)
+static ssize_t sbc8360_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -257,16 +257,12 @@ static ssize_t sbc8360_write(struct file
 
 static int sbc8360_open(struct inode *inode, struct file *file)
 {
-	spin_lock(&sbc8360_lock);
-	if (test_and_set_bit(0, &sbc8360_is_open)) {
-		spin_unlock(&sbc8360_lock);
+	if (test_and_set_bit(0, &sbc8360_is_open))
 		return -EBUSY;
-	}
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
 	/* Activate and ping once to start the countdown */
-	spin_unlock(&sbc8360_lock);
 	sbc8360_activate();
 	sbc8360_ping();
 	return nonseekable_open(inode, file);
@@ -274,16 +270,14 @@ static int sbc8360_open(struct inode *in
 
 static int sbc8360_close(struct inode *inode, struct file *file)
 {
-	spin_lock(&sbc8360_lock);
 	if (expect_close == 42)
 		outb(0, SBC8360_ENABLE);
 	else
 		printk(KERN_CRIT PFX
-		       "SBC8360 device closed unexpectedly.  SBC8360 will not stop!\n");
+			"SBC8360 device closed unexpectedly.  SBC8360 will not stop!\n");
 
 	clear_bit(0, &sbc8360_is_open);
 	expect_close = 0;
-	spin_unlock(&sbc8360_lock);
 	return 0;
 }
 
@@ -382,13 +376,13 @@ static int __init sbc8360_init(void)
 
 	return 0;
 
-      out_nomisc:
+out_nomisc:
 	unregister_reboot_notifier(&sbc8360_notifier);
-      out_noreboot:
+out_noreboot:
 	release_region(SBC8360_BASETIME, 1);
-      out_nobasetimereg:
+out_nobasetimereg:
 	release_region(SBC8360_ENABLE, 1);
-      out:
+out:
 	return res;
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

