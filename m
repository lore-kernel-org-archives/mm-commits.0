From: akpm@linux-foundation.org
Subject: + gigaset-code-cleanups.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:50:48 -0800
Message-ID: <200711152250.lAFMomsL019971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37913 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934170AbXKOWu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:50:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, gregkh@suse.de, hjlipp@web.de, kkeil@suse.de


The patch titled
     gigaset: code cleanups
has been added to the -mm tree.  Its filename is
     gigaset-code-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gigaset: code cleanups
From: Tilman Schmidt <tilman@imap.cc>

Some cleanups to the bas-gigaset and usb-gigaset USB ISDN drivers:
- simplified error handling
- improved debug messages
- readability improvements
- removal of obsolete defines and comments

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <gregkh@suse.de>
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/bas-gigaset.c |   45 ++++++-------
 drivers/isdn/gigaset/gigaset.h     |   18 +----
 drivers/isdn/gigaset/usb-gigaset.c |   92 ++++++++++++---------------
 3 files changed, 73 insertions(+), 82 deletions(-)

diff -puN drivers/isdn/gigaset/bas-gigaset.c~gigaset-code-cleanups drivers/isdn/gigaset/bas-gigaset.c
--- a/drivers/isdn/gigaset/bas-gigaset.c~gigaset-code-cleanups
+++ a/drivers/isdn/gigaset/bas-gigaset.c
@@ -938,15 +938,15 @@ static int starturbs(struct bc_state *bc
 		ubc->isoouturbs[k].limit = -1;
 	}
 
-	/* submit two URBs, keep third one */
-	for (k = 0; k < 2; ++k) {
+	/* keep one URB free, submit the others */
+	for (k = 0; k < BAS_OUTURBS-1; ++k) {
 		dump_urb(DEBUG_ISO, "Initial isoc write", urb);
 		rc = usb_submit_urb(ubc->isoouturbs[k].urb, GFP_ATOMIC);
 		if (rc != 0)
 			goto error;
 	}
 	dump_urb(DEBUG_ISO, "Initial isoc write (free)", urb);
-	ubc->isooutfree = &ubc->isoouturbs[2];
+	ubc->isooutfree = &ubc->isoouturbs[BAS_OUTURBS-1];
 	ubc->isooutdone = ubc->isooutovfl = NULL;
 	return 0;
  error:
@@ -1559,37 +1559,38 @@ static int req_submit(struct bc_state *b
  */
 static int gigaset_init_bchannel(struct bc_state *bcs)
 {
+	struct cardstate *cs = bcs->cs;
 	int req, ret;
 	unsigned long flags;
 
-	spin_lock_irqsave(&bcs->cs->lock, flags);
-	if (unlikely(!bcs->cs->connected)) {
+	spin_lock_irqsave(&cs->lock, flags);
+	if (unlikely(!cs->connected)) {
 		gig_dbg(DEBUG_USBREQ, "%s: not connected", __func__);
-		spin_unlock_irqrestore(&bcs->cs->lock, flags);
+		spin_unlock_irqrestore(&cs->lock, flags);
 		return -ENODEV;
 	}
 
 	if ((ret = starturbs(bcs)) < 0) {
-		dev_err(bcs->cs->dev,
+		dev_err(cs->dev,
 			"could not start isochronous I/O for channel B%d: %s\n",
 			bcs->channel + 1,
 			ret == -EFAULT ? "null URB" : get_usb_rcmsg(ret));
 		if (ret != -ENODEV)
 			error_hangup(bcs);
-		spin_unlock_irqrestore(&bcs->cs->lock, flags);
+		spin_unlock_irqrestore(&cs->lock, flags);
 		return ret;
 	}
 
 	req = bcs->channel ? HD_OPEN_B2CHANNEL : HD_OPEN_B1CHANNEL;
 	if ((ret = req_submit(bcs, req, 0, BAS_TIMEOUT)) < 0) {
-		dev_err(bcs->cs->dev, "could not open channel B%d\n",
+		dev_err(cs->dev, "could not open channel B%d\n",
 			bcs->channel + 1);
 		stopurbs(bcs->hw.bas);
 		if (ret != -ENODEV)
 			error_hangup(bcs);
 	}
 
-	spin_unlock_irqrestore(&bcs->cs->lock, flags);
+	spin_unlock_irqrestore(&cs->lock, flags);
 	return ret;
 }
 
@@ -1605,20 +1606,21 @@ static int gigaset_init_bchannel(struct 
  */
 static int gigaset_close_bchannel(struct bc_state *bcs)
 {
+	struct cardstate *cs = bcs->cs;
 	int req, ret;
 	unsigned long flags;
 
-	spin_lock_irqsave(&bcs->cs->lock, flags);
-	if (unlikely(!bcs->cs->connected)) {
-		spin_unlock_irqrestore(&bcs->cs->lock, flags);
+	spin_lock_irqsave(&cs->lock, flags);
+	if (unlikely(!cs->connected)) {
+		spin_unlock_irqrestore(&cs->lock, flags);
 		gig_dbg(DEBUG_USBREQ, "%s: not connected", __func__);
 		return -ENODEV;
 	}
 
-	if (!(atomic_read(&bcs->cs->hw.bas->basstate) &
+	if (!(atomic_read(&cs->hw.bas->basstate) &
 	      (bcs->channel ? BS_B2OPEN : BS_B1OPEN))) {
 		/* channel not running: just signal common.c */
-		spin_unlock_irqrestore(&bcs->cs->lock, flags);
+		spin_unlock_irqrestore(&cs->lock, flags);
 		gigaset_bchannel_down(bcs);
 		return 0;
 	}
@@ -1626,10 +1628,10 @@ static int gigaset_close_bchannel(struct
 	/* channel running: tell device to close it */
 	req = bcs->channel ? HD_CLOSE_B2CHANNEL : HD_CLOSE_B1CHANNEL;
 	if ((ret = req_submit(bcs, req, 0, BAS_TIMEOUT)) < 0)
-		dev_err(bcs->cs->dev, "closing channel B%d failed\n",
+		dev_err(cs->dev, "closing channel B%d failed\n",
 			bcs->channel + 1);
 
-	spin_unlock_irqrestore(&bcs->cs->lock, flags);
+	spin_unlock_irqrestore(&cs->lock, flags);
 	return ret;
 }
 
@@ -2114,7 +2116,7 @@ static void freeurbs(struct cardstate *c
 	int i, j;
 
 	gig_dbg(DEBUG_INIT, "%s: killing URBs", __func__);
-	for (j = 0; j < 2; ++j) {
+	for (j = 0; j < BAS_CHANNELS; ++j) {
 		ubc = cs->bcs[j].hw.bas;
 		for (i = 0; i < BAS_OUTURBS; ++i) {
 			usb_kill_urb(ubc->isoouturbs[i].urb);
@@ -2215,7 +2217,7 @@ static int gigaset_probe(struct usb_inte
 	    !(ucs->urb_ctrl = usb_alloc_urb(0, GFP_KERNEL)))
 		goto allocerr;
 
-	for (j = 0; j < 2; ++j) {
+	for (j = 0; j < BAS_CHANNELS; ++j) {
 		ubc = cs->bcs[j].hw.bas;
 		for (i = 0; i < BAS_OUTURBS; ++i)
 			if (!(ubc->isoouturbs[i].urb =
@@ -2287,8 +2289,7 @@ static void gigaset_disconnect(struct us
 	atomic_set(&ucs->basstate, 0);
 
 	/* tell LL all channels are down */
-	//FIXME shouldn't gigaset_stop() do this?
-	for (j = 0; j < 2; ++j)
+	for (j = 0; j < BAS_CHANNELS; ++j)
 		gigaset_bchannel_down(cs->bcs + j);
 
 	/* stop driver (common part) */
@@ -2343,7 +2344,7 @@ static int __init bas_gigaset_init(void)
 		goto error;
 
 	/* allocate memory for our device state and intialize it */
-	cardstate = gigaset_initcs(driver, 2, 0, 0, cidmode,
+	cardstate = gigaset_initcs(driver, BAS_CHANNELS, 0, 0, cidmode,
 				   GIGASET_MODULENAME);
 	if (!cardstate)
 		goto error;
diff -puN drivers/isdn/gigaset/gigaset.h~gigaset-code-cleanups drivers/isdn/gigaset/gigaset.h
--- a/drivers/isdn/gigaset/gigaset.h~gigaset-code-cleanups
+++ a/drivers/isdn/gigaset/gigaset.h
@@ -70,22 +70,13 @@
 
 extern int gigaset_debuglevel;	/* "needs" cast to (enum debuglevel) */
 
-/* any combination of these can be given with the 'debug=' parameter to insmod,
- * e.g. 'insmod usb_gigaset.o debug=0x2c' will set DEBUG_OPEN, DEBUG_CMD and
- * DEBUG_INTR.
- */
+/* debug flags, combine by adding/bitwise OR */
 enum debuglevel {
-	DEBUG_REG	  = 0x0002, /* serial port I/O register operations */
-	DEBUG_OPEN	  = 0x0004, /* open/close serial port */
-	DEBUG_INTR	  = 0x0008, /* interrupt processing */
-	DEBUG_INTR_DUMP	  = 0x0010, /* Activating hexdump debug output on
-				       interrupt requests, not available as
-				       run-time option */
+	DEBUG_INTR	  = 0x00008, /* interrupt processing */
 	DEBUG_CMD	  = 0x00020, /* sent/received LL commands */
 	DEBUG_STREAM	  = 0x00040, /* application data stream I/O events */
 	DEBUG_STREAM_DUMP = 0x00080, /* application data stream content */
 	DEBUG_LLDATA	  = 0x00100, /* sent/received LL data */
-	DEBUG_INTR_0	  = 0x00200, /* serial port interrupt processing */
 	DEBUG_DRIVER	  = 0x00400, /* driver structure */
 	DEBUG_HDLC	  = 0x00800, /* M10x HDLC processing */
 	DEBUG_WRITE	  = 0x01000, /* M105 data write */
@@ -93,7 +84,7 @@ enum debuglevel {
 	DEBUG_MCMD	  = 0x04000, /* COMMANDS THAT ARE SENT VERY OFTEN */
 	DEBUG_INIT	  = 0x08000, /* (de)allocation+initialization of data
 					structures */
-	DEBUG_LOCK	  = 0x10000, /* semaphore operations */
+	DEBUG_SUSPEND	  = 0x10000, /* suspend/resume processing */
 	DEBUG_OUTPUT	  = 0x20000, /* output to device */
 	DEBUG_ISO	  = 0x40000, /* isochronous transfers */
 	DEBUG_IF	  = 0x80000, /* character device operations */
@@ -197,6 +188,9 @@ void gigaset_dbg_buffer(enum debuglevel 
 #define	HD_OPEN_ATCHANNEL		(0x28)		// 3070
 #define	HD_CLOSE_ATCHANNEL		(0x29)		// 3070
 
+/* number of B channels supported by base driver */
+#define BAS_CHANNELS	2
+
 /* USB frames for isochronous transfer */
 #define BAS_FRAMETIME	1	/* number of milliseconds between frames */
 #define BAS_NUMFRAMES	8	/* number of frames per URB */
diff -puN drivers/isdn/gigaset/usb-gigaset.c~gigaset-code-cleanups drivers/isdn/gigaset/usb-gigaset.c
--- a/drivers/isdn/gigaset/usb-gigaset.c~gigaset-code-cleanups
+++ a/drivers/isdn/gigaset/usb-gigaset.c
@@ -104,6 +104,7 @@ MODULE_DEVICE_TABLE(usb, gigaset_table);
  * flags per packet.
  */
 
+/* functions called if a device of this driver is connected/disconnected */
 static int gigaset_probe(struct usb_interface *interface,
 			 const struct usb_device_id *id);
 static void gigaset_disconnect(struct usb_interface *interface);
@@ -362,18 +363,12 @@ static void gigaset_read_int_callback(st
 	struct inbuf_t *inbuf = urb->context;
 	struct cardstate *cs = inbuf->cs;
 	int status = urb->status;
-	int resubmit = 0;
 	int r;
 	unsigned numbytes;
 	unsigned char *src;
 	unsigned long flags;
 
 	if (!status) {
-		if (!cs->connected) {
-			err("%s: disconnected", __func__); /* should never happen */
-			return;
-		}
-
 		numbytes = urb->actual_length;
 
 		if (numbytes) {
@@ -390,28 +385,26 @@ static void gigaset_read_int_callback(st
 			}
 		} else
 			gig_dbg(DEBUG_INTR, "Received zero block length");
-		resubmit = 1;
 	} else {
 		/* The urb might have been killed. */
-		gig_dbg(DEBUG_ANY, "%s - nonzero read bulk status received: %d",
+		gig_dbg(DEBUG_ANY, "%s - nonzero status received: %d",
 			__func__, status);
-		if (status != -ENOENT) { /* not killed */
-			if (!cs->connected) {
-				err("%s: disconnected", __func__); /* should never happen */
-				return;
-			}
-			resubmit = 1;
-		}
+		if (status == -ENOENT || status == -ESHUTDOWN)
+			/* killed or endpoint shutdown: don't resubmit */
+			return;
 	}
 
-	if (resubmit) {
-		spin_lock_irqsave(&cs->lock, flags);
-		r = cs->connected ? usb_submit_urb(urb, GFP_ATOMIC) : -ENODEV;
+	/* resubmit URB */
+	spin_lock_irqsave(&cs->lock, flags);
+	if (!cs->connected) {
 		spin_unlock_irqrestore(&cs->lock, flags);
-		if (r)
-			dev_err(cs->dev, "error %d when resubmitting urb.\n",
-				-r);
+		err("%s: disconnected", __func__);
+		return;
 	}
+	r = usb_submit_urb(urb, GFP_ATOMIC);
+	spin_unlock_irqrestore(&cs->lock, flags);
+	if (r)
+		dev_err(cs->dev, "error %d resubmitting URB\n", -r);
 }
 
 
@@ -422,11 +415,19 @@ static void gigaset_write_bulk_callback(
 	int status = urb->status;
 	unsigned long flags;
 
-	if (status)
+	switch (status) {
+	case 0:			/* normal completion */
+		break;
+	case -ENOENT:		/* killed */
+		gig_dbg(DEBUG_ANY, "%s: killed", __func__);
+		atomic_set(&cs->hw.usb->busy, 0);
+		return;
+	default:
 		dev_err(cs->dev, "bulk transfer failed (status %d)\n",
 			-status);
 		/* That's all we can do. Communication problems
 		   are handled by timeouts or network protocols. */
+	}
 
 	spin_lock_irqsave(&cs->lock, flags);
 	if (!cs->connected) {
@@ -682,43 +683,35 @@ static int gigaset_probe(struct usb_inte
 {
 	int retval;
 	struct usb_device *udev = interface_to_usbdev(interface);
-	unsigned int ifnum;
-	struct usb_host_interface *hostif;
+	struct usb_host_interface *hostif = interface->cur_altsetting;
 	struct cardstate *cs = NULL;
 	struct usb_cardstate *ucs = NULL;
 	struct usb_endpoint_descriptor *endpoint;
 	int buffer_size;
-	int alt;
-
-	gig_dbg(DEBUG_ANY,
-		"%s: Check if device matches .. (Vendor: 0x%x, Product: 0x%x)",
-		__func__, le16_to_cpu(udev->descriptor.idVendor),
-		le16_to_cpu(udev->descriptor.idProduct));
 
-	retval = -ENODEV; //FIXME
+	gig_dbg(DEBUG_ANY, "%s: Check if device matches ...", __func__);
 
 	/* See if the device offered us matches what we can accept */
 	if ((le16_to_cpu(udev->descriptor.idVendor)  != USB_M105_VENDOR_ID) ||
-	    (le16_to_cpu(udev->descriptor.idProduct) != USB_M105_PRODUCT_ID))
+	    (le16_to_cpu(udev->descriptor.idProduct) != USB_M105_PRODUCT_ID)) {
+		gig_dbg(DEBUG_ANY, "device ID (0x%x, 0x%x) not for me - skip",
+			le16_to_cpu(udev->descriptor.idVendor),
+			le16_to_cpu(udev->descriptor.idProduct));
 		return -ENODEV;
-
-	/* this starts to become ascii art... */
-	hostif = interface->cur_altsetting;
-	alt = hostif->desc.bAlternateSetting;
-	ifnum = hostif->desc.bInterfaceNumber; // FIXME ?
-
-	if (alt != 0 || ifnum != 0) {
-		dev_warn(&udev->dev, "ifnum %d, alt %d\n", ifnum, alt);
+	}
+	if (hostif->desc.bInterfaceNumber != 0) {
+		gig_dbg(DEBUG_ANY, "interface %d not for me - skip",
+			hostif->desc.bInterfaceNumber);
+		return -ENODEV;
+	}
+	if (hostif->desc.bAlternateSetting != 0) {
+		dev_notice(&udev->dev, "unsupported altsetting %d - skip",
+			   hostif->desc.bAlternateSetting);
 		return -ENODEV;
 	}
-
-	/* Reject application specific intefaces
-	 *
-	 */
 	if (hostif->desc.bInterfaceClass != 255) {
-		dev_info(&udev->dev,
-		"%s: Device matched but iface_desc[%d]->bInterfaceClass==%d!\n",
-			 __func__, ifnum, hostif->desc.bInterfaceClass);
+		dev_notice(&udev->dev, "unsupported interface class %d - skip",
+			   hostif->desc.bInterfaceClass);
 		return -ENODEV;
 	}
 
@@ -826,6 +819,9 @@ static void gigaset_disconnect(struct us
 
 	cs = usb_get_intfdata(interface);
 	ucs = cs->hw.usb;
+
+	dev_info(cs->dev, "disconnecting Gigaset USB adapter\n");
+
 	usb_kill_urb(ucs->read_urb);
 
 	gigaset_stop(cs);
@@ -833,7 +829,7 @@ static void gigaset_disconnect(struct us
 	usb_set_intfdata(interface, NULL);
 	tasklet_kill(&cs->write_tasklet);
 
-	usb_kill_urb(ucs->bulk_out_urb);	/* FIXME: only if active? */
+	usb_kill_urb(ucs->bulk_out_urb);
 
 	kfree(ucs->bulk_out_buffer);
 	usb_free_urb(ucs->bulk_out_urb);
_

Patches currently in -mm which might be from tilman@imap.cc are

usb-power-managementtxt-disconnect-clarification.patch
gigaset-clean-up-urb-status-usage.patch
gigaset-code-cleanups.patch
bas_gigaset-suspend-support-v2.patch
usb_gigaset-suspend-support-v3.patch
