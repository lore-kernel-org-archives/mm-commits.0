From: akpm@linux-foundation.org
Subject: - drivers-net-usb-pegasusc-remove-in_atomic-check.patch removed from -mm tree
Date: Wed, 02 Apr 2008 12:20:35 -0700
Message-ID: <200804021920.m32JKZl6030277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757390AbYDBTVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 15:21:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, greg@kroah.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/usb/pegasus.c: remove in_atomic() check
has been removed from the -mm tree.  Its filename was
     drivers-net-usb-pegasusc-remove-in_atomic-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/usb/pegasus.c: remove in_atomic() check
From: David Brownell <david-b@pacbell.net>

Remove superfluous in-atomic() check; ethtool MII ops are called from task
context.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/pegasus.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/net/usb/pegasus.c~drivers-net-usb-pegasusc-remove-in_atomic-check drivers/net/usb/pegasus.c
--- a/drivers/net/usb/pegasus.c~drivers-net-usb-pegasusc-remove-in_atomic-check
+++ a/drivers/net/usb/pegasus.c
@@ -1128,12 +1128,8 @@ pegasus_get_settings(struct net_device *
 {
 	pegasus_t *pegasus;
 
-	if (in_atomic())
-		return 0;
-
 	pegasus = netdev_priv(dev);
 	mii_ethtool_gset(&pegasus->mii, ecmd);
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-acpi.patch
git-arm.patch
git-avr32.patch
git-input.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch
usb-ohci-fix-2-timers-to-fire-at-jiffies-1s.patch
spi-pxa2xx_spi-sparse-fixes.patch
atmel_spi-support-zero-length-transfer.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-avoid-legacy-drivers-with-generic-framework-update.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
kerneldoc-for-linux-clkh.patch
kerneldoc-for-linux-clkh-fix.patch
rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-replace-remaining-__function__-occurrences.patch
remove-duplicated-unlikely-in-is_err.patch

