From: akpm@osdl.org
Subject: - usb-interrupt-endpoint-support-for-keyspan-usb-to-serial.patch removed from -mm tree
Date: Wed, 03 Jan 2007 15:49:30 -0800
Message-ID: <200701032349.l03NnUh7003285@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33067 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbXACXtg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 18:49:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rweikusat@sncag.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: interrupt endpoint support for keyspan USB-to-serial
has been removed from the -mm tree.  Its filename was
     usb-interrupt-endpoint-support-for-keyspan-usb-to-serial.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: usb: interrupt endpoint support for keyspan USB-to-serial
From: Rainer Weikusat <rweikusat@sncag.com>

At least the Keyspan USA-19HS USB-to-serial converter supports two
different configurations, one where the input endpoints have interrupt
transfer type and one where they are bulk endpoints.

The default configuration uses the interrupt input endpoints.  The keyspan
driver, OTOH, assumes that the device has only bulk endpoints (all URBs are
initialized by calling usb_fill_bulk_urb in keyspan.c/ keyspan_setup_urb). 
This causes the interval field of the input URBs to have a value of zero
instead of one, which 'accidentally' worked with Linux at least up to
2.6.17.11 but stopped to with 2.6.18, which changed the code handling URBs
for interrupt endpoints.

The patch modifies to driver to initialize its input URBs either as
interrupt or as bulk URBs, depending on the transfertype contained in the
associated endpoint descriptor (only tested with the default configuration)
enabling the driver to again receive data from the serial converter.

Signed-off-by: Rainer Weikusat <rweikusat@sncag.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/serial/keyspan.c |   55 ++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 4 deletions(-)

diff -puN drivers/usb/serial/keyspan.c~usb-interrupt-endpoint-support-for-keyspan-usb-to-serial drivers/usb/serial/keyspan.c
--- a/drivers/usb/serial/keyspan.c~usb-interrupt-endpoint-support-for-keyspan-usb-to-serial
+++ a/drivers/usb/serial/keyspan.c
@@ -95,6 +95,7 @@
 */
 
 
+#include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
 #include <linux/errno.h>
@@ -1275,11 +1276,35 @@ static int keyspan_fake_startup (struct 
 }
 
 /* Helper functions used by keyspan_setup_urbs */
+static struct usb_endpoint_descriptor const *
+find_ep_desc_for(struct usb_serial const *serial, int endpoint)
+{
+	struct usb_host_interface const *setting;
+	struct usb_endpoint_descriptor const *ep_desc;
+	int n;
+
+	setting = serial->interface->cur_altsetting;
+	n = setting->desc.bNumEndpoints - 1;
+	do
+		ep_desc = &setting->endpoint[n].desc;
+	while (ep_desc->bEndpointAddress != endpoint && --n >= 0);
+
+	if (unlikely(n == -1)) {
+		printk(KERN_ERR "no endpoint descriptor found\n");
+		BUG();
+	}
+
+	dbg("%s - found endpoint descriptor @ %p", __func__, ep_desc);
+	return ep_desc;
+}
+
 static struct urb *keyspan_setup_urb (struct usb_serial *serial, int endpoint,
 				      int dir, void *ctx, char *buf, int len,
 				      void (*callback)(struct urb *))
 {
+	struct usb_endpoint_descriptor const *ep_desc;
 	struct urb *urb;
+	unsigned ep_type;
 
 	if (endpoint == -1)
 		return NULL;		/* endpoint not needed */
@@ -1291,10 +1316,32 @@ static struct urb *keyspan_setup_urb (st
 		return NULL;
 	}
 
-		/* Fill URB using supplied data. */
-	usb_fill_bulk_urb(urb, serial->dev,
-		      usb_sndbulkpipe(serial->dev, endpoint) | dir,
-		      buf, len, callback, ctx);
+	ep_desc = find_ep_desc_for(serial, endpoint);
+	ep_type = ep_desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
+	switch (ep_type) {
+	case USB_ENDPOINT_XFER_INT:
+		dbg("%s - filling urb %p for int endpoint",
+		    __func__, urb);
+
+		usb_fill_int_urb(urb, serial->dev,
+				 usb_sndintpipe(serial->dev, endpoint) | dir,
+				 buf, len, callback, ctx,
+				 ep_desc->bInterval);
+		break;
+
+	case USB_ENDPOINT_XFER_BULK:
+		dbg("%s - filling urb %p for bulk endpoint",
+		    __func__, urb);
+
+		usb_fill_bulk_urb(urb, serial->dev,
+				  usb_sndbulkpipe(serial->dev, endpoint) | dir,
+				  buf, len, callback, ctx);
+		break;
+
+	default:
+		printk(KERN_ERR "unexpected endpoint type %d", ep_type);
+		BUG();
+	}
 
 	return urb;
 }
_

Patches currently in -mm which might be from rweikusat@sncag.com are

usb-interrupt-endpoint-support-for-keyspan-usb-to-serial.patch
fix-for-bugzilla-7544-keyspan-usb-to-serial-converter.patch
