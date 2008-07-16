From: akpm@linux-foundation.org
Subject: - watchdog-sbc_epx_c3_wdt-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:55 -0700
Message-ID: <200807162136.m6GLatv3014255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757313AbYGPVqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: sbc_epx_c3_wdt: switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-sbc_epx_c3_wdt-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: sbc_epx_c3_wdt: switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/sbc_epx_c3.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/watchdog/sbc_epx_c3.c~watchdog-sbc_epx_c3_wdt-switch-to-unlocked_ioctl drivers/watchdog/sbc_epx_c3.c
--- a/drivers/watchdog/sbc_epx_c3.c~watchdog-sbc_epx_c3_wdt-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/sbc_epx_c3.c
@@ -25,8 +25,8 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define PFX "epx_c3: "
 static int epx_c3_alive;
@@ -100,12 +100,12 @@ static ssize_t epx_c3_write(struct file 
 	return len;
 }
 
-static int epx_c3_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long epx_c3_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int options, retval = -EINVAL;
 	int __user *argp = (void __user *)arg;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options		= WDIOF_KEEPALIVEPING |
 					  WDIOF_MAGICCLOSE,
 		.firmware_version	= 0,
@@ -158,7 +158,7 @@ static const struct file_operations epx_
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= epx_c3_write,
-	.ioctl		= epx_c3_ioctl,
+	.unlocked_ioctl	= epx_c3_ioctl,
 	.open		= epx_c3_open,
 	.release	= epx_c3_release,
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

