From: akpm@linux-foundation.org
Subject: [merged] drivers-usb-core-hubc-fix-config_usb_otg=y-build.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:18:05 -0800
Message-ID: <200901161918.n0GJI5bf026665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754188AbZAPT2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:28:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, felipe.balbi@nokia.com, greg@kroah.com, rmk@arm.linux.org.uk, stern@rowland.harvard.edu, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/core/hub.c: fix CONFIG_USB_OTG=y build
has been removed from the -mm tree.  Its filename was
     drivers-usb-core-hubc-fix-config_usb_otg=y-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
mmc-fixes-and-enhancements-for-the-mmc-spi-driver.patch
regulator-minor-cleanup-of-virtual-consumer-fix.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller-update.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch

