From: akpm@linux-foundation.org
Subject: + usbtouchscreen-dont-send-interrupt-urbs-to-bulk-endpoints.patch added to -mm tree
Date: Fri, 11 Dec 2009 13:21:37 -0800
Message-ID: <200912112121.nBBLLbQO011610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758850AbZLKVW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Dec 2009 16:22:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, daniel.ritz@gmx.ch, ddstreet@ieee.org, dmitry.torokhov@gmail.com, floe@butterbrot.org, greg@kroah.com, jim-linux@nurd.se, oliver@neukum.org


The patch titled
     usbtouchscreen: don't send interrupt urbs to bulk endpoints
has been added to the -mm tree.  Its filename is
     usbtouchscreen-dont-send-interrupt-urbs-to-bulk-endpoints.patch

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
Subject: usbtouchscreen: don't send interrupt urbs to bulk endpoints
From: Ondrej Zary <linux@rainbow-software.org>

Don't send interrupt urbs to bulk endpoints.
This fixes EHCI corruption after rmmod with NEXIO touchscreen.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jim Persson <jim-linux@nurd.se>
Cc: Florian Echtler <floe@butterbrot.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/usbtouchscreen.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-dont-send-interrupt-urbs-to-bulk-endpoints drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-dont-send-interrupt-urbs-to-bulk-endpoints
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -1375,10 +1375,16 @@ static int usbtouch_probe(struct usb_int
 		input_set_abs_params(input_dev, ABS_PRESSURE, type->min_press,
 		                     type->max_press, 0, 0);
 
-	usb_fill_int_urb(usbtouch->irq, udev,
+	if (usb_endpoint_type(endpoint) == USB_ENDPOINT_XFER_INT)
+		usb_fill_int_urb(usbtouch->irq, udev,
 			 usb_rcvintpipe(udev, endpoint->bEndpointAddress),
 			 usbtouch->data, type->rept_size,
 			 usbtouch_irq, usbtouch, endpoint->bInterval);
+	else
+		usb_fill_bulk_urb(usbtouch->irq, udev,
+			 usb_rcvbulkpipe(udev, endpoint->bEndpointAddress),
+			 usbtouch->data, type->rept_size,
+			 usbtouch_irq, usbtouch);
 
 	usbtouch->irq->dev = udev;
 	usbtouch->irq->transfer_dma = usbtouch->data_dma;
_

Patches currently in -mm which might be from linux@rainbow-software.org are

origin.patch
usbtouchscreen-convert-from-usb_device-to-usb_interface.patch
usbtouchscreen-find-input-endpoint-automatically.patch
usbtouchscreen-add-nexio-or-inexio-support.patch
usbtouchscreen-fix-nexio-ack-and-usb-disconnect.patch
usbtouchscreen-dont-send-interrupt-urbs-to-bulk-endpoints.patch

