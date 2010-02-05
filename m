From: akpm@linux-foundation.org
Subject: [merged] usbtouchscreen-convert-from-usb_device-to-usb_interface.patch removed from -mm tree
Date: Fri, 05 Feb 2010 11:58:27 -0800
Message-ID: <201002051958.o15JwRlK017871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933837Ab0BET65 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 14:58:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rainbow-software.org, daniel.ritz@gmx.ch, ddstreet@ieee.org, dmitry.torokhov@gmail.com, floe@butterbrot.org, greg@kroah.com, jim-linux@nurd.se, oliver@neukum.org, mm-commits@vger


The patch titled
     usbtouchscreen: convert from usb_device to usb_interface
has been removed from the -mm tree.  Its filename was
     usbtouchscreen-convert-from-usb_device-to-usb_interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usbtouchscreen: convert from usb_device to usb_interface
From: Ondrej Zary <linux@rainbow-software.org>

Convert usbtouchscreen from storing usb_device to usb_interface. This is
needed for multi-interface touchscreen devices such as iNexio.

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

 drivers/input/touchscreen/usbtouchscreen.c |   22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-convert-from-usb_device-to-usb_interface drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-convert-from-usb_device-to-usb_interface
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -104,7 +104,7 @@ struct usbtouch_usb {
 	unsigned char *buffer;
 	int buf_len;
 	struct urb *irq;
-	struct usb_device *udev;
+	struct usb_interface *interface;
 	struct input_dev *input;
 	struct usbtouch_device_info *type;
 	char name[128];
@@ -234,8 +234,9 @@ static const struct usb_device_id usbtou
 static int e2i_init(struct usbtouch_usb *usbtouch)
 {
 	int ret;
+	struct usb_device *udev = interface_to_usbdev(usbtouch->interface);
 
-	ret = usb_control_msg(usbtouch->udev, usb_rcvctrlpipe(usbtouch->udev, 0),
+	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 	                      0x01, 0x02, 0x0000, 0x0081,
 	                      NULL, 0, USB_CTRL_SET_TIMEOUT);
 
@@ -344,8 +345,9 @@ static int mtouch_read_data(struct usbto
 static int mtouch_init(struct usbtouch_usb *usbtouch)
 {
 	int ret, i;
+	struct usb_device *udev = interface_to_usbdev(usbtouch->interface);
 
-	ret = usb_control_msg(usbtouch->udev, usb_rcvctrlpipe(usbtouch->udev, 0),
+	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 	                      MTOUCHUSB_RESET,
 	                      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 	                      1, 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
@@ -356,7 +358,7 @@ static int mtouch_init(struct usbtouch_u
 	msleep(150);
 
 	for (i = 0; i < 3; i++) {
-		ret = usb_control_msg(usbtouch->udev, usb_rcvctrlpipe(usbtouch->udev, 0),
+		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				      MTOUCHUSB_ASYNC_REPORT,
 				      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				      1, 1, NULL, 0, USB_CTRL_SET_TIMEOUT);
@@ -489,7 +491,7 @@ static int gunze_read_data(struct usbtou
 
 static int dmc_tsc10_init(struct usbtouch_usb *usbtouch)
 {
-	struct usb_device *dev = usbtouch->udev;
+	struct usb_device *dev = interface_to_usbdev(usbtouch->interface);
 	int ret = -ENOMEM;
 	unsigned char *buf;
 
@@ -1021,7 +1023,7 @@ static int usbtouch_open(struct input_de
 {
 	struct usbtouch_usb *usbtouch = input_get_drvdata(input);
 
-	usbtouch->irq->dev = usbtouch->udev;
+	usbtouch->irq->dev = interface_to_usbdev(usbtouch->interface);
 
 	if (!usbtouch->type->irq_always) {
 		if (usb_submit_urb(usbtouch->irq, GFP_KERNEL))
@@ -1094,7 +1096,7 @@ static int usbtouch_probe(struct usb_int
 		goto out_free_buffers;
 	}
 
-	usbtouch->udev = udev;
+	usbtouch->interface = intf;
 	usbtouch->input = input_dev;
 
 	if (udev->manufacturer)
@@ -1133,12 +1135,12 @@ static int usbtouch_probe(struct usb_int
 		input_set_abs_params(input_dev, ABS_PRESSURE, type->min_press,
 		                     type->max_press, 0, 0);
 
-	usb_fill_int_urb(usbtouch->irq, usbtouch->udev,
-			 usb_rcvintpipe(usbtouch->udev, endpoint->bEndpointAddress),
+	usb_fill_int_urb(usbtouch->irq, udev,
+			 usb_rcvintpipe(udev, endpoint->bEndpointAddress),
 			 usbtouch->data, type->rept_size,
 			 usbtouch_irq, usbtouch, endpoint->bInterval);
 
-	usbtouch->irq->dev = usbtouch->udev;
+	usbtouch->irq->dev = udev;
 	usbtouch->irq->transfer_dma = usbtouch->data_dma;
 	usbtouch->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
_

Patches currently in -mm which might be from linux@rainbow-software.org are

linux-next.patch
g_ncr5380-remove-misleading-pnp-error-message.patch
g_ncr5380-fix-broken-mmio-compilation.patch
g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod.patch

