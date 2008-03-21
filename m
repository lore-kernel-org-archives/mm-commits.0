From: akpm@linux-foundation.org
Subject: + drivers-net-usb-pegasusc-remove-in_atomic-check.patch added to -mm tree
Date: Fri, 21 Mar 2008 16:00:58 -0700
Message-ID: <200803212300.m2LN0w7w015178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764829AbYCUXBW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 19:01:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, greg@kroah.com, jeff@garzik.org


The patch titled
     drivers/net/usb/pegasus.c: remove in_atomic() check
has been added to the -mm tree.  Its filename is
     drivers-net-usb-pegasusc-remove-in_atomic-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-avr32.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc-update.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch
drivers-net-usb-pegasusc-remove-in_atomic-check.patch
spi-pxa2xx_spi-sparse-fixes.patch
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
rtc-replace-remaining-__function__-occurrences.patch
remove-duplicated-unlikely-in-is_err.patch

