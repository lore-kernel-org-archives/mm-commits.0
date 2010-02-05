From: akpm@linux-foundation.org
Subject: [merged] usbtouchscreen-fix-nexio-ack-and-usb-disconnect.patch removed from -mm tree
Date: Fri, 05 Feb 2010 11:58:39 -0800
Message-ID: <201002051958.o15Jwdw6017884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933836Ab0BET65 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 14:58:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rainbow-software.org, daniel.ritz@gmx.ch, ddstreet@ieee.org, dmitry.torokhov@gmail.com, floe@butterbrot.org, greg@kroah.com, jim-linux@nurd.se, oliver@neukum.org, mm-commits@vger


The patch titled
     usbtouchscreen: fix NEXIO ACK and USB disconnect
has been removed from the -mm tree.  Its filename was
     usbtouchscreen-fix-nexio-ack-and-usb-disconnect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
g_ncr5380-remove-misleading-pnp-error-message.patch
g_ncr5380-fix-broken-mmio-compilation.patch
g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod.patch

