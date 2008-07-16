From: akpm@linux-foundation.org
Subject: - watchdog-pnx4008_wdt-unlocked_ioctl-setup.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:41 -0700
Message-ID: <200807162136.m6GLafPl014233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755304AbYGPVqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: pnx4008_wdt: unlocked_ioctl setup
has been removed from the -mm tree.  Its filename was
     watchdog-pnx4008_wdt-unlocked_ioctl-setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: pnx4008_wdt: unlocked_ioctl setup
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/pnx4008_wdt.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/watchdog/pnx4008_wdt.c~watchdog-pnx4008_wdt-unlocked_ioctl-setup drivers/watchdog/pnx4008_wdt.c
--- a/drivers/watchdog/pnx4008_wdt.c~watchdog-pnx4008_wdt-unlocked_ioctl-setup
+++ a/drivers/watchdog/pnx4008_wdt.c
@@ -30,8 +30,8 @@
 #include <linux/spinlock.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define MODULE_NAME "PNX4008-WDT: "
 
@@ -144,9 +144,8 @@ static int pnx4008_wdt_open(struct inode
 	return nonseekable_open(inode, file);
 }
 
-static ssize_t
-pnx4008_wdt_write(struct file *file, const char *data, size_t len,
-		  loff_t * ppos)
+static ssize_t pnx4008_wdt_write(struct file *file, const char *data,
+					size_t len, loff_t *ppos)
 {
 	if (len) {
 		if (!nowayout) {
@@ -169,15 +168,14 @@ pnx4008_wdt_write(struct file *file, con
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE |
 	    WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity = "PNX4008 Watchdog",
 };
 
-static int
-pnx4008_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		  unsigned long arg)
+static long pnx4008_wdt_ioctl(struct inode *inode, struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -238,7 +236,7 @@ static const struct file_operations pnx4
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = pnx4008_wdt_write,
-	.ioctl = pnx4008_wdt_ioctl,
+	.unlocked_ioctl = pnx4008_wdt_ioctl,
 	.open = pnx4008_wdt_open,
 	.release = pnx4008_wdt_release,
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

