From: akpm@linux-foundation.org
Subject: + usbtouchscreen-fix-nexio-ack-and-usb-disconnect.patch added to -mm tree
Date: Fri, 04 Dec 2009 07:34:56 -0800
Message-ID: <200912041534.nB4FYuge022011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081AbZLDPfE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2009 10:35:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, daniel.ritz@gmx.ch, ddstreet@ieee.org, dmitry.torokhov@gmail.com, floe@butterbrot.org, greg@kroah.com, jim-linux@nurd.se, oliver@neukum.org


The patch titled
     usbtouchscreen: fix NEXIO ACK and USB disconnect
has been added to the -mm tree.  Its filename is
     usbtouchscreen-fix-nexio-ack-and-usb-disconnect.patch

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
Subject: usbtouchscreen: fix NEXIO ACK and USB disconnect
From: Ondrej Zary <linux@rainbow-software.org>

Fix sending ACK urbs and oops on USB disconnecting NEXIO touchscreen.

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

 drivers/input/touchscreen/usbtouchscreen.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-fix-nexio-ack-and-usb-disconnect drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-fix-nexio-ack-and-usb-disconnect
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -728,6 +728,10 @@ struct nexio_touch_packet {
 static unsigned char nexio_ack_pkt[2] = { 0xaa, 0x02 };
 static unsigned char nexio_init_pkt[4] = { 0x82, 0x04, 0x0a, 0x0f };
 
+static void nexio_ack_complete(struct urb *urb)
+{
+}
+
 static int nexio_init(struct usbtouch_usb *usbtouch)
 {
 	struct usb_device *dev = interface_to_usbdev(usbtouch->interface);
@@ -811,8 +815,8 @@ static int nexio_init(struct usbtouch_us
 		goto err_ack_buf;
 	}
 	usb_fill_bulk_urb(priv->ack, dev, usb_sndbulkpipe(dev, output_ep),
-			  priv->ack_buf, sizeof(priv->ack_buf), NULL,
-			  usbtouch);
+			  priv->ack_buf, sizeof(nexio_ack_pkt),
+			  nexio_ack_complete, usbtouch);
 	ret = 0;
 	goto out_buf;
 err_ack_buf:
@@ -1227,6 +1231,7 @@ static void usbtouch_irq(struct urb *urb
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
+	case -EPIPE:
 		/* this urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
 		    __func__, urb->status);
_

Patches currently in -mm which might be from linux@rainbow-software.org are

usbtouchscreen-convert-from-usb_device-to-usb_interface.patch
usbtouchscreen-find-input-endpoint-automatically.patch
usbtouchscreen-add-nexio-or-inexio-support.patch
usbtouchscreen-fix-nexio-ack-and-usb-disconnect.patch

