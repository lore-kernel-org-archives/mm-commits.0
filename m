From: akpm@linux-foundation.org
Subject: + usbatm-detect-usb-device-shutdown-and-ignore-failed-urbs.patch added to -mm tree
Date: Fri, 20 Apr 2007 16:09:55 -0700
Message-ID: <200704202309.l3KN9t9a026028@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712AbXDTXKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 19:10:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@fire.lp0.eu, duncan.sands@math.u-psud.fr, greg@kroah.com


The patch titled
     usbatm: Detect usb device shutdown and ignore failed urbs
has been added to the -mm tree.  Its filename is
     usbatm-detect-usb-device-shutdown-and-ignore-failed-urbs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usbatm: Detect usb device shutdown and ignore failed urbs
From: Simon Arlott <simon@fire.lp0.eu>

Detect usb device shutdown and ignore failed urbs.  This happens when the
driver is unloaded or the device is unplugged.

I'm not sure what other urb statuses should be ignored, and the warning
message doesn't need to be shown when the module is unloaded or the device
is removed.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/usbatm.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/usb/atm/usbatm.c~usbatm-detect-usb-device-shutdown-and-ignore-failed-urbs drivers/usb/atm/usbatm.c
--- a/drivers/usb/atm/usbatm.c~usbatm-detect-usb-device-shutdown-and-ignore-failed-urbs
+++ a/drivers/usb/atm/usbatm.c
@@ -274,6 +274,9 @@ static void usbatm_complete(struct urb *
 			(!(channel->usbatm->flags & UDSL_IGNORE_EILSEQ) ||
 			 urb->status != -EILSEQ ))
 	{
+		if (urb->status == -ESHUTDOWN)
+			return;
+
 		if (printk_ratelimit())
 			atm_warn(channel->usbatm, "%s: urb 0x%p failed (%d)!\n",
 				__func__, urb, urb->status);
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

usbatm-detect-usb-device-shutdown-and-ignore-failed-urbs.patch
usb-cxacru-adsl-state-management.patch
