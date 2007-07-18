From: akpm@linux-foundation.org
Subject: + appletouch-powersaving.patch added to -mm tree
Date: Wed, 18 Jul 2007 15:58:03 -0700
Message-ID: <200707182258.l6IMw3M7000954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44229 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932568AbXGRW7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 18:59:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@nn7.de, dtor@mail.ru, frank@scirocco-5v-turbo.de, greg@kroah.com, johannes@sipsolutions.net, linux-kernel@hansmi.ch, mjg59@srcf.ucam.org, nicolas@boichat.ch, petero2@telia.com, stelian@popies.net


The patch titled
     appletouch powersaving
has been added to the -mm tree.  Its filename is
     appletouch-powersaving.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: appletouch powersaving
From: Soeren Sonnenburg <kernel@nn7.de>

The attached patch is based on Matthew Garret's patch 'Make appletouch shut
up when it has nothing to say' patches (e.g. 
http://lkml.org/lkml/2007/5/13/117): Matthews description follows / second
paragraph lists my additional changes.

The appletouch geyser3 devices found in the Intel Macs (and possibly some
later PPC ones?) send a constant stream of packets after the first touch. 
This results in the kernel waking up around once every couple of
milliseconds to process them, making it almost impossible to spend any
significant period of time in C3 state on a dynamic HZ kernel.  Sending the
mode initialization code makes the device shut up until it's touched again.
 This patch does so after receiving 10 packets with no interesting content.

In addition it now empties the work queue via cancel_work_sync on module
exit, keeps all error checking and only reports BTN_LEFT presses if bit 1
in the status byte (last byte in packet) is set.  This fixes the random
left clicks issue.  Furthermore it invalidates touchpad data before the
mode switch, which fixes the touchpad runs amok issue.

Credits:
Sven Anders found out that one should only check for bit 1 for BTN_LEFT.
Matthew Garrett did the initial 'Make appletouch shut up when it has
nothing to say' so I am adding him to the signed-off lines (hope that is
the correct way).

Signed-off-by: Soeren Sonnenburg <kernel@nn7.de>
Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Michael Hanselmann <linux-kernel@hansmi.ch>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Frank Arnold <frank@scirocco-5v-turbo.de>
Cc: Stelian Pop <stelian@popies.net>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/appletouch.c |  114 ++++++++++++++++++++---------
 1 files changed, 79 insertions(+), 35 deletions(-)

diff -puN drivers/input/mouse/appletouch.c~appletouch-powersaving drivers/input/mouse/appletouch.c
--- a/drivers/input/mouse/appletouch.c~appletouch-powersaving
+++ a/drivers/input/mouse/appletouch.c
@@ -155,6 +155,8 @@ struct atp {
 	int			xy_acc[ATP_XSENSORS + ATP_YSENSORS];
 	int			overflowwarn;	/* overflow warning printed? */
 	int			datalen;	/* size of an USB urb transfer */
+	int                     idlecount;      /* number of empty packets */
+	struct work_struct      work;
 };
 
 #define dbg_dump(msg, tab) \
@@ -208,6 +210,64 @@ static inline int atp_is_geyser_3(struct
 		(productId == GEYSER4_JIS_PRODUCT_ID);
 }
 
+/*
+ * By default Geyser 3 device sends standard USB HID mouse
+ * packets (Report ID 2). This code changes device mode, so it
+ * sends raw sensor reports (Report ID 5).
+ */
+static int atp_geyser3_init(struct usb_device *udev)
+{
+	char data[8];
+	int size;
+	int i;
+
+	size = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+			       ATP_GEYSER3_MODE_READ_REQUEST_ID,
+			       USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+			       ATP_GEYSER3_MODE_REQUEST_VALUE,
+			       ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);
+
+
+	if (size != 8) {
+		printk("appletouch atp_geyser3_init READ error\n");
+		for (i=0; i<8; i++)
+			printk("appletouch[%d]: %d\n", i, (int) data[i]);
+
+		err("Could not do mode read request from device"
+		    " (Geyser 3 mode)");
+		return -EIO;
+	}
+
+	/* Apply the mode switch */
+	data[0] = ATP_GEYSER3_MODE_VENDOR_VALUE;
+
+	size = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			       ATP_GEYSER3_MODE_WRITE_REQUEST_ID,
+			       USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+			       ATP_GEYSER3_MODE_REQUEST_VALUE,
+			       ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);
+
+	if (size != 8) {
+		printk("appletouch atp_geyser3_init WRITE error\n");
+		for (i=0; i<8; i++)
+			printk("appletouch[%d]: %d\n", i, (int) data[i]);
+		err("Could not do mode write request to device"
+		    " (Geyser 3 mode)");
+		return -EIO;
+	}
+	return 0;
+}
+
+/* Reinitialise the device if it's a geyser 3 */
+static void atp_reinit(struct work_struct *work)
+{
+	struct atp *dev = container_of(work, struct atp, work);
+	struct usb_device *udev = dev->udev;
+
+	dev->idlecount = 0;
+	atp_geyser3_init(udev);
+}
+
 static int atp_calculate_abs(int *xy_sensors, int nb_sensors, int fact,
 			     int *z, int *fingers)
 {
@@ -418,6 +478,8 @@ static void atp_complete(struct urb* urb
 	y = atp_calculate_abs(dev->xy_acc + ATP_XSENSORS, ATP_YSENSORS,
 			      ATP_YFACT, &y_z, &y_f);
 
+	input_report_key(dev->input, BTN_LEFT, dev->data[dev->datalen-1] & 1);
+
 	if (x && y) {
 		if (dev->x_old != -1) {
 			x = (dev->x_old * 3 + x) >> 2;
@@ -449,10 +511,19 @@ static void atp_complete(struct urb* urb
 
 		/* reset the accumulator on release */
 		memset(dev->xy_acc, 0, sizeof(dev->xy_acc));
-	}
 
-	input_report_key(dev->input, BTN_LEFT,
-			 !!dev->data[dev->datalen - 1]);
+		/* Geyser 3 will continue to send packets continually after
+		   the first touch unless reinitialised. Do so if it's been
+		   idle for a while in order to avoid waking the kernel up
+		   several hundred times a second */
+		if (atp_is_geyser_3(dev)) {
+			dev->idlecount++;
+			if (dev->idlecount == 10) {
+				dev->valid=0;
+				schedule_work (&dev->work);
+			}
+		}
+	}
 
 	input_sync(dev->input);
 
@@ -528,40 +599,10 @@ static int atp_probe(struct usb_interfac
 		dev->datalen = 81;
 
 	if (atp_is_geyser_3(dev)) {
-		/*
-		 * By default Geyser 3 device sends standard USB HID mouse
-		 * packets (Report ID 2). This code changes device mode, so it
-		 * sends raw sensor reports (Report ID 5).
-		 */
-		char data[8];
-		int size;
-
-		size = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
-			ATP_GEYSER3_MODE_READ_REQUEST_ID,
-			USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-			ATP_GEYSER3_MODE_REQUEST_VALUE,
-			ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);
-
-		if (size != 8) {
-			err("Could not do mode read request from device"
-							" (Geyser 3 mode)");
+		/* switch to raw sensor mode */
+		if (atp_geyser3_init(udev))
 			goto err_free_devs;
-		}
 
-		/* Apply the mode switch */
-		data[0] = ATP_GEYSER3_MODE_VENDOR_VALUE;
-
-		size = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
-			ATP_GEYSER3_MODE_WRITE_REQUEST_ID,
-			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-			ATP_GEYSER3_MODE_REQUEST_VALUE,
-			ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);
-
-		if (size != 8) {
-			err("Could not do mode write request to device"
-							" (Geyser 3 mode)");
-			goto err_free_devs;
-		}
 		printk("appletouch Geyser 3 inited.\n");
 	}
 
@@ -636,6 +677,8 @@ static int atp_probe(struct usb_interfac
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(iface, dev);
 
+	INIT_WORK(&dev->work, atp_reinit);
+
 	return 0;
 
  err_free_buffer:
@@ -656,6 +699,7 @@ static void atp_disconnect(struct usb_in
 
 	usb_set_intfdata(iface, NULL);
 	if (dev) {
+		cancel_work_sync(&dev->work);
 		usb_kill_urb(dev->urb);
 		input_unregister_device(dev->input);
 		usb_buffer_free(dev->udev, dev->datalen,
_

Patches currently in -mm which might be from kernel@nn7.de are

appletouch-powersaving.patch
