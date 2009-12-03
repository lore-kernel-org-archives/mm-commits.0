From: akpm@linux-foundation.org
Subject: + usbtouchscreen-find-input-endpoint-automatically.patch added to -mm tree
Date: Thu, 03 Dec 2009 14:43:43 -0800
Message-ID: <200912032243.nB3Mhhqa001675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772AbZLCWoB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 17:44:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, daniel.ritz@gmx.ch, ddstreet@ieee.org, dmitry.torokhov@gmail.com, floe@butterbrot.org, greg@kroah.com, jim-linux@nurd.se, oliver@neukum.org


The patch titled
     usbtouchscreen: find input endpoint automatically
has been added to the -mm tree.  Its filename is
     usbtouchscreen-find-input-endpoint-automatically.patch

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
Subject: usbtouchscreen: find input endpoint automatically
From: Ondrej Zary <linux@rainbow-software.org>

Find input enpoint automatically instead of assuming that the first one is
OK.  This is needed for devices with multiple endpoints such as iNexio
where the first endpoint might be output.

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

 drivers/input/touchscreen/usbtouchscreen.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-find-input-endpoint-automatically drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-find-input-endpoint-automatically
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -1057,17 +1057,25 @@ static int usbtouch_probe(struct usb_int
 	struct usbtouch_usb *usbtouch;
 	struct input_dev *input_dev;
 	struct usb_host_interface *interface;
-	struct usb_endpoint_descriptor *endpoint;
+	struct usb_endpoint_descriptor *endpoint = NULL;
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct usbtouch_device_info *type;
 	int err = -ENOMEM;
+	int i;
 
 	/* some devices are ignored */
 	if (id->driver_info == DEVTYPE_IGNORE)
 		return -ENODEV;
 
 	interface = intf->cur_altsetting;
-	endpoint = &interface->endpoint[0].desc;
+	/* find first input endpoint */
+	for (i = 0; i < interface->desc.bNumEndpoints; i++)
+		if (usb_endpoint_dir_in(&interface->endpoint[i].desc)) {
+			endpoint = &interface->endpoint[i].desc;
+			break;
+		}
+	if (!endpoint)
+		return -ENXIO;
 
 	usbtouch = kzalloc(sizeof(struct usbtouch_usb), GFP_KERNEL);
 	input_dev = input_allocate_device();
_

Patches currently in -mm which might be from linux@rainbow-software.org are

usbtouchscreen-convert-from-usb_device-to-usb_interface.patch
usbtouchscreen-find-input-endpoint-automatically.patch
usbtouchscreen-add-nexio-or-inexio-support.patch

