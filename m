From: akpm@osdl.org
Subject: + fix-for-bugzilla-7544-keyspan-usb-to-serial-converter.patch added to -mm tree
Date: Wed, 03 Jan 2007 15:49:42 -0800
Message-ID: <200701032349.l03NngT6003292@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33076 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200AbXACXtq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 18:49:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rainer.weikusat@sncag.com, rweikusat@sncag.com


The patch titled
     fix for bugzilla #7544 (keyspan USB-to-serial converter)
has been added to the -mm tree.  Its filename is
     fix-for-bugzilla-7544-keyspan-usb-to-serial-converter.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix for bugzilla #7544 (keyspan USB-to-serial converter)
From: Rainer Weikusat <rainer.weikusat@sncag.com>

At least the Keyspan USA-19HS USB-to-serial converter supports two
different configurations, one where the input endpoints have interrupt
transfer type and one where they are bulk endpoints.

The default UHCI configuration uses the interrupt input endpoints.  The
keyspan driver, OTOH, assumes that the device has only bulk endpoints (all
URBs are initialized by calling usb_fill_bulk_urb in keyspan.c/
keyspan_setup_urb).  This causes the interval field of the input URBs to
have a value of zero instead of one, which 'accidentally' worked with Linux
at least up to 2.6.17.11 but stopped to with 2.6.18, which changed the UHCI
support code handling URBs for interrupt endpoints.

The patch modifies the driver to initialize its input URBs either as
interrupt or as bulk URBs, depending on the transfertype contained in the
associated endpoint descriptor (only tested with the default configuration)
enabling the driver to again receive data from the serial converter.

Signed-off-by: Rainer Weikusat <rweikusat@sncag.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/serial/keyspan.c |   51 ++++++++++++++++++++++++++++++---
 1 files changed, 47 insertions(+), 4 deletions(-)

diff -puN drivers/usb/serial/keyspan.c~fix-for-bugzilla-7544-keyspan-usb-to-serial-converter drivers/usb/serial/keyspan.c
--- a/drivers/usb/serial/keyspan.c~fix-for-bugzilla-7544-keyspan-usb-to-serial-converter
+++ a/drivers/usb/serial/keyspan.c
@@ -1275,11 +1275,32 @@ static int keyspan_fake_startup (struct 
 }
 
 /* Helper functions used by keyspan_setup_urbs */
+static struct usb_endpoint_descriptor const *
+find_ep_desc_for(struct usb_serial const *serial, int endpoint)
+{
+	struct usb_host_endpoint const *p, *e;
+
+	p = serial->interface->cur_altsetting->endpoint;
+	e = p + serial->interface->cur_altsetting->desc.bNumEndpoints;
+	while (p < e && p->desc.bEndpointAddress != endpoint) ++p;
+
+	if (p == e) {
+		printk(KERN_WARNING "%s - found no endpoint descriptor for "
+		       "endpoint %d\n", __func__, endpoint);
+		return NULL;
+	}
+
+	return &p->desc;
+}
+
 static struct urb *keyspan_setup_urb (struct usb_serial *serial, int endpoint,
 				      int dir, void *ctx, char *buf, int len,
 				      void (*callback)(struct urb *))
 {
 	struct urb *urb;
+	struct usb_endpoint_descriptor const *ep_desc;
+	char const *ep_type_name;
+	unsigned ep_type;
 
 	if (endpoint == -1)
 		return NULL;		/* endpoint not needed */
@@ -1291,11 +1312,33 @@ static struct urb *keyspan_setup_urb (st
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
+		ep_type_name = "INT";
+		usb_fill_int_urb(urb, serial->dev,
+				 usb_sndintpipe(serial->dev, endpoint) | dir,
+				 buf, len, callback, ctx,
+				 ep_desc->bInterval);
+		break;
+
+	case USB_ENDPOINT_XFER_BULK:
+		ep_type_name = "BULK";
+		usb_fill_bulk_urb(urb, serial->dev,
+				  usb_sndbulkpipe(serial->dev, endpoint) | dir,
+				  buf, len, callback, ctx);
+		break;
+
+	default:
+		printk(KERN_WARNING "%s - unsupported endpoint type %d\n",
+		       __func__, ep_type);
+		usb_free_urb(urb);
+		return NULL;
+	}
 
+	dbg("%s - using urb %p for %s endpoint %d",
+	    __func__, urb, ep_type_name, endpoint);
 	return urb;
 }
 
_

Patches currently in -mm which might be from rainer.weikusat@sncag.com are

fix-for-bugzilla-7544-keyspan-usb-to-serial-converter.patch
