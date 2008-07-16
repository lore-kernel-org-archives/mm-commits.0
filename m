From: akpm@linux-foundation.org
Subject: - watchdog-atp-watchdog.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:49 -0700
Message-ID: <200807162135.m6GLZnwb014125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756784AbYGPVgh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:36:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: atp watchdog
has been removed from the -mm tree.  Its filename was
     watchdog-atp-watchdog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: atp watchdog
From: Alan Cox <alan@redhat.com>

Switch to unlocked_ioctl

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/at32ap700x_wdt.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/watchdog/at32ap700x_wdt.c~watchdog-atp-watchdog drivers/watchdog/at32ap700x_wdt.c
--- a/drivers/watchdog/at32ap700x_wdt.c~watchdog-atp-watchdog
+++ a/drivers/watchdog/at32ap700x_wdt.c
@@ -212,8 +212,8 @@ static struct watchdog_info at32_wdt_inf
 /*
  * Handle commands from user-space.
  */
-static int at32_wdt_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long at32_wdt_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -298,7 +298,7 @@ static ssize_t at32_wdt_write(struct fil
 static const struct file_operations at32_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= at32_wdt_ioctl,
+	.unlocked_ioctl	= at32_wdt_ioctl,
 	.open		= at32_wdt_open,
 	.release	= at32_wdt_close,
 	.write		= at32_wdt_write,
@@ -391,7 +391,6 @@ static int __exit at32_wdt_remove(struct
 		wdt = NULL;
 		platform_set_drvdata(pdev, NULL);
 	}
-
 	return 0;
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

