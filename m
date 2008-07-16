From: akpm@linux-foundation.org
Subject: - watchdog-davinci_wdt-unlocked_ioctl-and-check-locking.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:55 -0700
Message-ID: <200807162135.m6GLZt6M014134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756953AbYGPVjB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:39:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: davinci_wdt: unlocked_ioctl and check locking
has been removed from the -mm tree.  Its filename was
     watchdog-davinci_wdt-unlocked_ioctl-and-check-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: davinci_wdt: unlocked_ioctl and check locking
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/davinci_wdt.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/watchdog/davinci_wdt.c~watchdog-davinci_wdt-unlocked_ioctl-and-check-locking drivers/watchdog/davinci_wdt.c
--- a/drivers/watchdog/davinci_wdt.c~watchdog-davinci_wdt-unlocked_ioctl-and-check-locking
+++ a/drivers/watchdog/davinci_wdt.c
@@ -22,10 +22,10 @@
 #include <linux/bitops.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
 
 #define MODULE_NAME "DAVINCI-WDT: "
 
@@ -143,9 +143,8 @@ static struct watchdog_info ident = {
 	.identity = "DaVinci Watchdog",
 };
 
-static int
-davinci_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		  unsigned long arg)
+static long davinci_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
 
@@ -184,7 +183,7 @@ static const struct file_operations davi
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = davinci_wdt_write,
-	.ioctl = davinci_wdt_ioctl,
+	.unlocked_ioctl = davinci_wdt_ioctl,
 	.open = davinci_wdt_open,
 	.release = davinci_wdt_release,
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

