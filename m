From: akpm@linux-foundation.org
Subject: + usb-isp1362-hcd-removes-config_usb_otg-dependent-code-fix-build-breakage.patch added to -mm tree
Date: Fri, 10 Sep 2010 17:05:03 -0700
Message-ID: <201009110005.o8B05363010787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755038Ab0IKAFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 20:05:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: martinez.javier@gmail.com, greg@kroah.com, sfr@canb.auug.org.au, vapier@gentoo.org


The patch titled
     usb: isp1362-hcd: Removes CONFIG_USB_OTG dependent code, fix build breakage
has been added to the -mm tree.  Its filename is
     usb-isp1362-hcd-removes-config_usb_otg-dependent-code-fix-build-breakage.patch

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
Subject: usb: isp1362-hcd: Removes CONFIG_USB_OTG dependent code, fix build breakage
From: Javier Martinez Canillas <martinez.javier@gmail.com>

In today linux-next I got a compile error on usb/host/isp1362-hcd:

drivers/usb/host/isp1362-hcd.c: In function `isp1362_hub_control':
drivers/usb/host/isp1362-hcd.c:1680: error: `ohci' undeclared (first use in this function)

The problem is when the CONFIG_USB_OTG option is enabled.

ohci variable is never declared and there isn't any CONFIG_USB_OTG
dependent code besides the portion defined in isp1362_hub_control.

So I think that maybe USB OTG support is not needed/supported.

This patch removes the CONFIG_USB_OTG dependent block so the driver can
compile cleanly.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/isp1362-hcd.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/usb/host/isp1362-hcd.c~usb-isp1362-hcd-removes-config_usb_otg-dependent-code-fix-build-breakage drivers/usb/host/isp1362-hcd.c
--- a/drivers/usb/host/isp1362-hcd.c~usb-isp1362-hcd-removes-config_usb_otg-dependent-code-fix-build-breakage
+++ a/drivers/usb/host/isp1362-hcd.c
@@ -1676,13 +1676,6 @@ static int isp1362_hub_control(struct us
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
 			_DBG(0, "USB_PORT_FEAT_SUSPEND\n");
-#ifdef	CONFIG_USB_OTG
-			if (ohci->hcd.self.otg_port == (wIndex + 1) &&
-			    ohci->hcd.self.b_hnp_enable) {
-				start_hnp(ohci);
-				break;
-			}
-#endif
 			spin_lock_irqsave(&isp1362_hcd->lock, flags);
 			isp1362_write_reg32(isp1362_hcd, HCRHPORT1 + wIndex, RH_PS_PSS);
 			isp1362_hcd->rhport[wIndex] =
_

Patches currently in -mm which might be from martinez.javier@gmail.com are

linux-next.patch
usb-isp1362-hcd-removes-config_usb_otg-dependent-code-fix-build-breakage.patch

