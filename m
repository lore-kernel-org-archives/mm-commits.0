From: akpm@linux-foundation.org
Subject: + usb-another-ehci_iaa_watchdog-fix.patch added to -mm tree
Date: Wed, 02 Apr 2008 13:44:56 -0700
Message-ID: <200804022044.m32Kiu0D001197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764124AbYDBUp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 16:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, greg@kroah.com, mlord@pobox.com, rjw@sisk.pl, stern@rowland.harvard.edu


The patch titled
     usb: another ehci_iaa_watchdog fix
has been added to the -mm tree.  Its filename is
     usb-another-ehci_iaa_watchdog-fix.patch

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
Subject: usb: another ehci_iaa_watchdog fix
From: David Brownell <david-b@pacbell.net>

This patch, suggested by Alan Stern, fixes the hung USB issues on my notebook
from suspend/resume cycles.

It does so by eliminating some confusion about the internal state machine
associated with unlinking from the EHCI async schedule ring, which caused a
recent regression:

  http://bugzilla.kernel.org/show_bug.cgi?id=10345

Signed-off-by: Mark Lord <mlord@pobox.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ehci-hub.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/usb/host/ehci-hub.c~usb-another-ehci_iaa_watchdog-fix drivers/usb/host/ehci-hub.c
--- a/drivers/usb/host/ehci-hub.c~usb-another-ehci_iaa_watchdog-fix
+++ a/drivers/usb/host/ehci-hub.c
@@ -126,8 +126,6 @@ static int ehci_bus_suspend (struct usb_
 		hcd->state = HC_STATE_QUIESCING;
 	}
 	ehci->command = ehci_readl(ehci, &ehci->regs->command);
-	if (ehci->reclaim)
-		end_unlink_async(ehci);
 	ehci_work(ehci);
 
 	/* Unlike other USB host controller types, EHCI doesn't have
@@ -171,6 +169,9 @@ static int ehci_bus_suspend (struct usb_
 	ehci_halt (ehci);
 	hcd->state = HC_STATE_SUSPENDED;
 
+	if (ehci->reclaim)
+		end_unlink_async(ehci);
+
 	/* allow remote wakeup */
 	mask = INTR_MASK;
 	if (!device_may_wakeup(&hcd->self.root_hub->dev))
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
usb-another-ehci_iaa_watchdog-fix.patch
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

