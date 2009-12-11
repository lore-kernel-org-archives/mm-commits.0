From: akpm@linux-foundation.org
Subject: + usbtouchscreen-fix-leaks-and-check-return-value-of-usb_submit_urb.patch added to -mm tree
Date: Fri, 11 Dec 2009 14:26:13 -0800
Message-ID: <200912112226.nBBMQD6J012432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762880AbZLKW0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Dec 2009 17:26:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, daniel.ritz@gmx.ch, ddstreet@ieee.org, dmitry.torokhov@gmail.com, floe@butterbrot.org, greg@kroah.com, jim-linux@nurd.se, oliver@neukum.org


The patch titled
     usbtouchscreen: fix leaks and check return value of usb_submit_urb()
has been added to the -mm tree.  Its filename is
     usbtouchscreen-fix-leaks-and-check-return-value-of-usb_submit_urb.patch

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
Subject: usbtouchscreen: fix leaks and check return value of usb_submit_urb()
From: Ondrej Zary <linux@rainbow-software.org>

Fix urb and priv leaks in error paths of initialization and NEXIO ack_buf
leak.

Also check usb_submit_urb() return value.

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

 drivers/input/touchscreen/usbtouchscreen.c |   21 +++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-fix-leaks-and-check-return-value-of-usb_submit_urb drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-fix-leaks-and-check-return-value-of-usb_submit_urb
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -834,6 +834,7 @@ static void nexio_exit(struct usbtouch_u
 
 	usb_kill_urb(priv->ack);
 	usb_free_urb(priv->ack);
+	kfree(priv->ack_buf);
 	kfree(priv);
 }
 
@@ -1395,23 +1396,35 @@ static int usbtouch_probe(struct usb_int
 		err = type->init(usbtouch);
 		if (err) {
 			dbg("%s - type->init() failed, err: %d", __func__, err);
-			goto out_free_buffers;
+			goto out_free_urb;
 		}
 	}
 
 	err = input_register_device(usbtouch->input);
 	if (err) {
 		dbg("%s - input_register_device failed, err: %d", __func__, err);
-		goto out_free_buffers;
+		goto out_exit;
 	}
 
 	usb_set_intfdata(intf, usbtouch);
 
-	if (usbtouch->type->irq_always)
-		usb_submit_urb(usbtouch->irq, GFP_KERNEL);
+	if (usbtouch->type->irq_always) {
+		err = usb_submit_urb(usbtouch->irq, GFP_KERNEL);
+		if (err) {
+			err("%s - usb_submit_urb failed with result: %d",
+			    __func__, err);
+			input_unregister_device(usbtouch->input);
+			goto out_exit;
+		}
+	}
 
 	return 0;
 
+out_exit:
+	if (type->exit)
+		type->exit(usbtouch);
+out_free_urb:
+	usb_free_urb(usbtouch->irq);
 out_free_buffers:
 	usbtouch_free_buffers(udev, usbtouch);
 out_free:
_

Patches currently in -mm which might be from linux@rainbow-software.org are

origin.patch
usbtouchscreen-convert-from-usb_device-to-usb_interface.patch
usbtouchscreen-find-input-endpoint-automatically.patch
usbtouchscreen-add-nexio-or-inexio-support.patch
usbtouchscreen-fix-nexio-ack-and-usb-disconnect.patch
usbtouchscreen-dont-send-interrupt-urbs-to-bulk-endpoints.patch
usbtouchscreen-fix-leaks-and-check-return-value-of-usb_submit_urb.patch

