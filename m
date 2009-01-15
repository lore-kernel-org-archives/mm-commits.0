From: akpm@linux-foundation.org
Subject: + drivers-usb-core-hubc-fix-config_usb_otg=y-build.patch added to -mm tree
Date: Thu, 15 Jan 2009 09:50:12 -0800
Message-ID: <200901151750.n0FHoCNC027753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763472AbZAORuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 12:50:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, felipe.balbi@nokia.com, greg@kroah.com, rmk@arm.linux.org.uk, stern@rowland.harvard.edu, tony@atomide.com


The patch titled
     drivers/usb/core/hub.c: fix CONFIG_USB_OTG=y build
has been added to the -mm tree.  Its filename is
     drivers-usb-core-hubc-fix-config_usb_otg=y-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/core/hub.c: fix CONFIG_USB_OTG=y build
From: David Brownell <dbrownell@users.sourceforge.net>

Carry out the PM-routine interface change in the USB OTG pathway.  This
was omitted from the earlier interface-change patch by mistake.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/core/hub.c~drivers-usb-core-hubc-fix-config_usb_otg=y-build drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~drivers-usb-core-hubc-fix-config_usb_otg=y-build
+++ a/drivers/usb/core/hub.c
@@ -1554,7 +1554,7 @@ static int usb_configure_device_otg(stru
 		 * (Includes HNP test device.)
 		 */
 		if (udev->bus->b_hnp_enable || udev->bus->is_b_host) {
-			err = usb_port_suspend(udev);
+			err = usb_port_suspend(udev, PMSG_SUSPEND);
 			if (err < 0)
 				dev_dbg(&udev->dev, "HNP fail, %d\n", err);
 		}
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
rtc-tw4030-add-alarm-update-interfaces-v2.patch
rtc-rtc-twl4030-dont-mask-alarm-interrupts-on-shutdown.patch
drivers-usb-core-hubc-fix-config_usb_otg=y-build.patch
linux-next.patch
mmc-fixes-and-enhancements-for-the-mmc-spi-driver.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller-update.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch

