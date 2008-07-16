From: akpm@linux-foundation.org
Subject: - watchdog-stg7240_wdt-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:51 -0700
Message-ID: <200807162136.m6GLapqn014248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759368AbYGPVhj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:37:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: stg7240_wdt: unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-stg7240_wdt-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: stg7240_wdt: unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/sbc7240_wdt.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/watchdog/sbc7240_wdt.c~watchdog-stg7240_wdt-unlocked_ioctl drivers/watchdog/sbc7240_wdt.c
--- a/drivers/watchdog/sbc7240_wdt.c~watchdog-stg7240_wdt-unlocked_ioctl
+++ a/drivers/watchdog/sbc7240_wdt.c
@@ -27,10 +27,10 @@
 #include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/atomic.h>
-#include <asm/io.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #define SBC7240_PREFIX "sbc7240_wdt: "
 
@@ -159,7 +159,7 @@ static int fop_close(struct inode *inode
 	return 0;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_KEEPALIVEPING|
 		   WDIOF_SETTIMEOUT|
 		   WDIOF_MAGICCLOSE,
@@ -168,14 +168,12 @@ static struct watchdog_info ident = {
 };
 
 
-static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		return copy_to_user
-			((void __user *)arg, &ident, sizeof(ident))
-			 ? -EFAULT : 0;
+		return copy_to_user((void __user *)arg, &ident, sizeof(ident))
+						 ? -EFAULT : 0;
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, (int __user *)arg);
@@ -225,7 +223,7 @@ static const struct file_operations wdt_
 	.write = fop_write,
 	.open = fop_open,
 	.release = fop_close,
-	.ioctl = fop_ioctl,
+	.unlocked_ioctl = fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {
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

