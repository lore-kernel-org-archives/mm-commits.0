From: akpm@linux-foundation.org
Subject: [merged] usbtouchscreen-fix-leaks-and-check-return-value-of-usb_submit_urb.patch removed from -mm tree
Date: Fri, 05 Feb 2010 11:58:45 -0800
Message-ID: <201002051958.o15JwjQO017894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933837Ab0BET7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 14:59:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rainbow-software.org, daniel.ritz@gmx.ch, ddstreet@ieee.org, dmitry.torokhov@gmail.com, floe@butterbrot.org, greg@kroah.com, jim-linux@nurd.se, oliver@neukum.org, mm-commits@vger


The patch titled
     usbtouchscreen: fix leaks and check return value of usb_submit_urb()
has been removed from the -mm tree.  Its filename was
     usbtouchscreen-fix-leaks-and-check-return-value-of-usb_submit_urb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
g_ncr5380-remove-misleading-pnp-error-message.patch
g_ncr5380-fix-broken-mmio-compilation.patch
g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod.patch

