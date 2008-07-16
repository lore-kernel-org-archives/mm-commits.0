From: akpm@linux-foundation.org
Subject: - watchdog-mv64x60_wdt-clean-up-and-locking-checks.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:33 -0700
Message-ID: <200807162136.m6GLaXoa014221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754356AbYGPVqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: mv64x60_wdt: clean up and locking checks
has been removed from the -mm tree.  Its filename was
     watchdog-mv64x60_wdt-clean-up-and-locking-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: mv64x60_wdt: clean up and locking checks
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/mv64x60_wdt.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN drivers/watchdog/mv64x60_wdt.c~watchdog-mv64x60_wdt-clean-up-and-locking-checks drivers/watchdog/mv64x60_wdt.c
--- a/drivers/watchdog/mv64x60_wdt.c~watchdog-mv64x60_wdt-clean-up-and-locking-checks
+++ a/drivers/watchdog/mv64x60_wdt.c
@@ -8,7 +8,7 @@
  * and services the watchdog.
  *
  * Derived from mpc8xx_wdt.c, with the following copyright.
- * 
+ *
  * 2002 (c) Florian Schirmer <jolt@tuxbox.org> This file is licensed under
  * the terms of the GNU General Public License version 2. This program
  * is licensed "as is" without any warranty of any kind, whether express
@@ -24,8 +24,8 @@
 #include <linux/platform_device.h>
 
 #include <linux/mv643xx.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define MV64x60_WDT_WDC_OFFSET	0
 
@@ -61,7 +61,9 @@ static DEFINE_SPINLOCK(mv64x60_wdt_spinl
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static int mv64x60_wdt_toggle_wdc(int enabled_predicate, int field_shift)
 {
@@ -150,7 +152,7 @@ static int mv64x60_wdt_release(struct in
 }
 
 static ssize_t mv64x60_wdt_write(struct file *file, const char __user *data,
-				 size_t len, loff_t * ppos)
+				 size_t len, loff_t *ppos)
 {
 	if (len) {
 		if (!nowayout) {
@@ -160,7 +162,7 @@ static ssize_t mv64x60_wdt_write(struct 
 
 			for (i = 0; i != len; i++) {
 				char c;
-				if(get_user(c, data + i))
+				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_close = 42;
@@ -172,8 +174,8 @@ static ssize_t mv64x60_wdt_write(struct 
 	return len;
 }
 
-static int mv64x60_wdt_ioctl(struct inode *inode, struct file *file,
-			     unsigned int cmd, unsigned long arg)
+static long mv64x60_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int timeout;
 	int options;
@@ -240,7 +242,7 @@ static const struct file_operations mv64
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = mv64x60_wdt_write,
-	.ioctl = mv64x60_wdt_ioctl,
+	.unlocked_ioctl = mv64x60_wdt_ioctl,
 	.open = mv64x60_wdt_open,
 	.release = mv64x60_wdt_release,
 };
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

