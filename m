From: akpm@linux-foundation.org
Subject: [merged] usbtouchscreen-dont-send-interrupt-urbs-to-bulk-endpoints.patch removed from -mm tree
Date: Fri, 05 Feb 2010 11:58:42 -0800
Message-ID: <201002051958.o15JwgC3017887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933832Ab0BET66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 14:58:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rainbow-software.org, daniel.ritz@gmx.ch, ddstreet@ieee.org, dmitry.torokhov@gmail.com, floe@butterbrot.org, greg@kroah.com, jim-linux@nurd.se, oliver@neukum.org, mm-commits@vger


The patch titled
     usbtouchscreen: don't send interrupt urbs to bulk endpoints
has been removed from the -mm tree.  Its filename was
     usbtouchscreen-dont-send-interrupt-urbs-to-bulk-endpoints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
g_ncr5380-remove-misleading-pnp-error-message.patch
g_ncr5380-fix-broken-mmio-compilation.patch
g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod.patch

