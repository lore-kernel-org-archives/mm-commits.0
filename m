From: akpm@linux-foundation.org
Subject: - input-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Mon, 05 May 2008 12:16:30 -0700
Message-ID: <200805051916.m45JGUFS000301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761804AbYEETQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:16:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     input-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/iforce/iforce-usb.c |    6 ++---
 drivers/input/joystick/xpad.c              |   18 ++++++++-------
 drivers/input/keyboard/lkkbd.c             |    6 ++---
 drivers/input/misc/ati_remote.c            |   18 +++++++--------
 drivers/input/misc/ati_remote2.c           |   18 +++++++--------
 drivers/input/misc/keyspan_remote.c        |   20 ++++++++---------
 drivers/input/misc/powermate.c             |    6 ++---
 drivers/input/misc/yealink.c               |   12 +++++-----
 drivers/input/mouse/appletouch.c           |    8 +++---
 drivers/input/tablet/acecad.c              |    4 +--
 drivers/input/tablet/aiptek.c              |    6 ++---
 drivers/input/tablet/kbtab.c               |    6 ++---
 drivers/input/tablet/wacom_sys.c           |    6 ++---
 drivers/input/touchscreen/usbtouchscreen.c |   22 +++++++++----------
 14 files changed, 79 insertions(+), 77 deletions(-)

diff -puN drivers/input/joystick/iforce/iforce-usb.c~input-replace-remaining-__function__-occurrences drivers/input/joystick/iforce/iforce-usb.c
--- a/drivers/input/joystick/iforce/iforce-usb.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/joystick/iforce/iforce-usb.c
@@ -89,10 +89,10 @@ static void iforce_usb_irq(struct urb *u
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		return;
 	default:
-		dbg("%s - urb has status of: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb has status of: %d", __func__, urb->status);
 		goto exit;
 	}
 
@@ -103,7 +103,7 @@ exit:
 	status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status)
 		err ("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, status);
+		     __func__, status);
 }
 
 static void iforce_usb_out(struct urb *urb)
diff -puN drivers/input/joystick/xpad.c~input-replace-remaining-__function__-occurrences drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/joystick/xpad.c
@@ -418,11 +418,11 @@ static void xpad_irq_in(struct urb *urb)
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
-			__FUNCTION__, status);
+			__func__, status);
 		return;
 	default:
 		dbg("%s - nonzero urb status received: %d",
-			__FUNCTION__, status);
+			__func__, status);
 		goto exit;
 	}
 
@@ -441,7 +441,7 @@ exit:
 	retval = usb_submit_urb (urb, GFP_ATOMIC);
 	if (retval)
 		err ("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, retval);
+		     __func__, retval);
 }
 
 static void xpad_bulk_out(struct urb *urb)
@@ -454,10 +454,12 @@ static void xpad_bulk_out(struct urb *ur
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__,
+			urb->status);
 		break;
 	default:
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__,
+			urb->status);
 	}
 }
 
@@ -477,11 +479,11 @@ static void xpad_irq_out(struct urb *urb
 		case -ESHUTDOWN:
 			/* this urb is terminated, clean up */
 			dbg("%s - urb shutting down with status: %d",
-				__FUNCTION__, status);
+				__func__, status);
 			return;
 		default:
 			dbg("%s - nonzero urb status received: %d",
-				__FUNCTION__, status);
+				__func__, status);
 			goto exit;
 	}
 
@@ -489,7 +491,7 @@ exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		err("%s - usb_submit_urb failed with result %d",
-		    __FUNCTION__, retval);
+		    __func__, retval);
 }
 
 static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad)
diff -puN drivers/input/keyboard/lkkbd.c~input-replace-remaining-__function__-occurrences drivers/input/keyboard/lkkbd.c
--- a/drivers/input/keyboard/lkkbd.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/keyboard/lkkbd.c
@@ -538,11 +538,11 @@ lkkbd_event (struct input_dev *dev, unsi
 			switch (code) {
 				case SND_CLICK:
 					if (value == 0) {
-						DBG ("%s: Deactivating key clicks\n", __FUNCTION__);
+						DBG ("%s: Deactivating key clicks\n", __func__);
 						lk->serio->write (lk->serio, LK_CMD_DISABLE_KEYCLICK);
 						lk->serio->write (lk->serio, LK_CMD_DISABLE_CTRCLICK);
 					} else {
-						DBG ("%s: Activating key clicks\n", __FUNCTION__);
+						DBG ("%s: Activating key clicks\n", __func__);
 						lk->serio->write (lk->serio, LK_CMD_ENABLE_KEYCLICK);
 						lk->serio->write (lk->serio, volume_to_hw (lk->keyclick_volume));
 						lk->serio->write (lk->serio, LK_CMD_ENABLE_CTRCLICK);
@@ -560,7 +560,7 @@ lkkbd_event (struct input_dev *dev, unsi
 
 		default:
 			printk (KERN_ERR "%s (): Got unknown type %d, code %d, value %d\n",
-					__FUNCTION__, type, code, value);
+					__func__, type, code, value);
 	}
 
 	return -1;
diff -puN drivers/input/misc/ati_remote.c~input-replace-remaining-__function__-occurrences drivers/input/misc/ati_remote.c
--- a/drivers/input/misc/ati_remote.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/misc/ati_remote.c
@@ -330,7 +330,7 @@ static int ati_remote_open(struct input_
 	ati_remote->irq_urb->dev = ati_remote->udev;
 	if (usb_submit_urb(ati_remote->irq_urb, GFP_KERNEL)) {
 		dev_err(&ati_remote->interface->dev,
-			"%s: usb_submit_urb failed!\n", __FUNCTION__);
+			"%s: usb_submit_urb failed!\n", __func__);
 		return -EIO;
 	}
 
@@ -356,7 +356,7 @@ static void ati_remote_irq_out(struct ur
 
 	if (urb->status) {
 		dev_dbg(&ati_remote->interface->dev, "%s: status %d\n",
-			__FUNCTION__, urb->status);
+			__func__, urb->status);
 		return;
 	}
 
@@ -601,17 +601,17 @@ static void ati_remote_irq_in(struct urb
 	case -ENOENT:
 	case -ESHUTDOWN:
 		dev_dbg(&ati_remote->interface->dev, "%s: urb error status, unlink? \n",
-			__FUNCTION__);
+			__func__);
 		return;
 	default:		/* error */
 		dev_dbg(&ati_remote->interface->dev, "%s: Nonzero urb status %d\n",
-			__FUNCTION__, urb->status);
+			__func__, urb->status);
 	}
 
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		dev_err(&ati_remote->interface->dev, "%s: usb_submit_urb()=%d\n",
-			__FUNCTION__, retval);
+			__func__, retval);
 }
 
 /*
@@ -734,7 +734,7 @@ static int ati_remote_probe(struct usb_i
 	int err = -ENOMEM;
 
 	if (iface_host->desc.bNumEndpoints != 2) {
-		err("%s: Unexpected desc.bNumEndpoints\n", __FUNCTION__);
+		err("%s: Unexpected desc.bNumEndpoints\n", __func__);
 		return -ENODEV;
 	}
 
@@ -742,11 +742,11 @@ static int ati_remote_probe(struct usb_i
 	endpoint_out = &iface_host->endpoint[1].desc;
 
 	if (!usb_endpoint_is_int_in(endpoint_in)) {
-		err("%s: Unexpected endpoint_in\n", __FUNCTION__);
+		err("%s: Unexpected endpoint_in\n", __func__);
 		return -ENODEV;
 	}
 	if (le16_to_cpu(endpoint_in->wMaxPacketSize) == 0) {
-		err("%s: endpoint_in message size==0? \n", __FUNCTION__);
+		err("%s: endpoint_in message size==0? \n", __func__);
 		return -ENODEV;
 	}
 
@@ -814,7 +814,7 @@ static void ati_remote_disconnect(struct
 	ati_remote = usb_get_intfdata(interface);
 	usb_set_intfdata(interface, NULL);
 	if (!ati_remote) {
-		warn("%s - null device?\n", __FUNCTION__);
+		warn("%s - null device?\n", __func__);
 		return;
 	}
 
diff -puN drivers/input/misc/ati_remote2.c~input-replace-remaining-__function__-occurrences drivers/input/misc/ati_remote2.c
--- a/drivers/input/misc/ati_remote2.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/misc/ati_remote2.c
@@ -137,14 +137,14 @@ static int ati_remote2_open(struct input
 	r = usb_submit_urb(ar2->urb[0], GFP_KERNEL);
 	if (r) {
 		dev_err(&ar2->intf[0]->dev,
-			"%s: usb_submit_urb() = %d\n", __FUNCTION__, r);
+			"%s: usb_submit_urb() = %d\n", __func__, r);
 		return r;
 	}
 	r = usb_submit_urb(ar2->urb[1], GFP_KERNEL);
 	if (r) {
 		usb_kill_urb(ar2->urb[0]);
 		dev_err(&ar2->intf[1]->dev,
-			"%s: usb_submit_urb() = %d\n", __FUNCTION__, r);
+			"%s: usb_submit_urb() = %d\n", __func__, r);
 		return r;
 	}
 
@@ -294,17 +294,17 @@ static void ati_remote2_complete_mouse(s
 	case -ECONNRESET:
 	case -ESHUTDOWN:
 		dev_dbg(&ar2->intf[0]->dev,
-			"%s(): urb status = %d\n", __FUNCTION__, urb->status);
+			"%s(): urb status = %d\n", __func__, urb->status);
 		return;
 	default:
 		dev_err(&ar2->intf[0]->dev,
-			"%s(): urb status = %d\n", __FUNCTION__, urb->status);
+			"%s(): urb status = %d\n", __func__, urb->status);
 	}
 
 	r = usb_submit_urb(urb, GFP_ATOMIC);
 	if (r)
 		dev_err(&ar2->intf[0]->dev,
-			"%s(): usb_submit_urb() = %d\n", __FUNCTION__, r);
+			"%s(): usb_submit_urb() = %d\n", __func__, r);
 }
 
 static void ati_remote2_complete_key(struct urb *urb)
@@ -321,17 +321,17 @@ static void ati_remote2_complete_key(str
 	case -ECONNRESET:
 	case -ESHUTDOWN:
 		dev_dbg(&ar2->intf[1]->dev,
-			"%s(): urb status = %d\n", __FUNCTION__, urb->status);
+			"%s(): urb status = %d\n", __func__, urb->status);
 		return;
 	default:
 		dev_err(&ar2->intf[1]->dev,
-			"%s(): urb status = %d\n", __FUNCTION__, urb->status);
+			"%s(): urb status = %d\n", __func__, urb->status);
 	}
 
 	r = usb_submit_urb(urb, GFP_ATOMIC);
 	if (r)
 		dev_err(&ar2->intf[1]->dev,
-			"%s(): usb_submit_urb() = %d\n", __FUNCTION__, r);
+			"%s(): usb_submit_urb() = %d\n", __func__, r);
 }
 
 static int ati_remote2_input_init(struct ati_remote2 *ar2)
@@ -438,7 +438,7 @@ static int ati_remote2_setup(struct ati_
 			    channel, 0x0, NULL, 0, USB_CTRL_SET_TIMEOUT);
 	if (r) {
 		dev_err(&ar2->udev->dev, "%s - failed to set channel due to error: %d\n",
-			__FUNCTION__, r);
+			__func__, r);
 		return r;
 	}
 
diff -puN drivers/input/misc/keyspan_remote.c~input-replace-remaining-__function__-occurrences drivers/input/misc/keyspan_remote.c
--- a/drivers/input/misc/keyspan_remote.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/misc/keyspan_remote.c
@@ -159,7 +159,7 @@ static int keyspan_load_tester(struct us
 	if (dev->data.pos >= dev->data.len) {
 		dev_dbg(&dev->udev->dev,
 			"%s - Error ran out of data. pos: %d, len: %d\n",
-			__FUNCTION__, dev->data.pos, dev->data.len);
+			__func__, dev->data.pos, dev->data.len);
 		return -1;
 	}
 
@@ -267,7 +267,7 @@ static void keyspan_check_data(struct us
 				remote->data.tester = remote->data.tester >> 6;
 				remote->data.bits_left -= 6;
 			} else {
-				err("%s - Unknown sequence found in system data.\n", __FUNCTION__);
+				err("%s - Unknown sequence found in system data.\n", __func__);
 				remote->stage = 0;
 				return;
 			}
@@ -286,7 +286,7 @@ static void keyspan_check_data(struct us
 				remote->data.tester = remote->data.tester >> 6;
 				remote->data.bits_left -= 6;
 			} else {
-				err("%s - Unknown sequence found in button data.\n", __FUNCTION__);
+				err("%s - Unknown sequence found in button data.\n", __func__);
 				remote->stage = 0;
 				return;
 			}
@@ -302,7 +302,7 @@ static void keyspan_check_data(struct us
 			remote->data.tester = remote->data.tester >> 6;
 			remote->data.bits_left -= 6;
 		} else {
-			err("%s - Error in message, invalid toggle.\n", __FUNCTION__);
+			err("%s - Error in message, invalid toggle.\n", __func__);
 			remote->stage = 0;
 			return;
 		}
@@ -317,7 +317,7 @@ static void keyspan_check_data(struct us
 
 		dev_dbg(&remote->udev->dev,
 			"%s found valid message: system: %d, button: %d, toggle: %d\n",
-			__FUNCTION__, message.system, message.button, message.toggle);
+			__func__, message.system, message.button, message.toggle);
 
 		if (message.toggle != remote->toggle) {
 			keyspan_report_button(remote, message.button, 1);
@@ -341,7 +341,7 @@ static int keyspan_setup(struct usb_devi
 				 0x11, 0x40, 0x5601, 0x0, NULL, 0, 0);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to set bit rate due to error: %d\n",
-			__FUNCTION__, retval);
+			__func__, retval);
 		return(retval);
 	}
 
@@ -349,7 +349,7 @@ static int keyspan_setup(struct usb_devi
 				 0x44, 0x40, 0x0, 0x0, NULL, 0, 0);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to set resume sensitivity due to error: %d\n",
-			__FUNCTION__, retval);
+			__func__, retval);
 		return(retval);
 	}
 
@@ -357,11 +357,11 @@ static int keyspan_setup(struct usb_devi
 				 0x22, 0x40, 0x0, 0x0, NULL, 0, 0);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to turn receive on due to error: %d\n",
-			__FUNCTION__, retval);
+			__func__, retval);
 		return(retval);
 	}
 
-	dev_dbg(&dev->dev, "%s - Setup complete.\n", __FUNCTION__);
+	dev_dbg(&dev->dev, "%s - Setup complete.\n", __func__);
 	return(retval);
 }
 
@@ -397,7 +397,7 @@ static void keyspan_irq_recv(struct urb 
 resubmit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
-		err ("%s - usb_submit_urb failed with result: %d", __FUNCTION__, retval);
+		err ("%s - usb_submit_urb failed with result: %d", __func__, retval);
 }
 
 static int keyspan_open(struct input_dev *dev)
diff -puN drivers/input/misc/powermate.c~input-replace-remaining-__function__-occurrences drivers/input/misc/powermate.c
--- a/drivers/input/misc/powermate.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/misc/powermate.c
@@ -96,10 +96,10 @@ static void powermate_irq(struct urb *ur
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 		return;
 	default:
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 		goto exit;
 	}
 
@@ -112,7 +112,7 @@ exit:
 	retval = usb_submit_urb (urb, GFP_ATOMIC);
 	if (retval)
 		err ("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, retval);
+		     __func__, retval);
 }
 
 /* Decide if we need to issue a control message and do so. Must be called with pm->lock taken */
diff -puN drivers/input/misc/yealink.c~input-replace-remaining-__function__-occurrences drivers/input/misc/yealink.c
--- a/drivers/input/misc/yealink.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/misc/yealink.c
@@ -427,7 +427,7 @@ static void urb_irq_callback(struct urb 
 	int ret;
 
 	if (urb->status)
-		err("%s - urb status %d", __FUNCTION__, urb->status);
+		err("%s - urb status %d", __func__, urb->status);
 
 	switch (yld->irq_data->cmd) {
 	case CMD_KEYPRESS:
@@ -449,7 +449,7 @@ static void urb_irq_callback(struct urb 
 
 	ret = usb_submit_urb(yld->urb_ctl, GFP_ATOMIC);
 	if (ret)
-		err("%s - usb_submit_urb failed %d", __FUNCTION__, ret);
+		err("%s - usb_submit_urb failed %d", __func__, ret);
 }
 
 static void urb_ctl_callback(struct urb *urb)
@@ -458,7 +458,7 @@ static void urb_ctl_callback(struct urb 
 	int ret;
 
 	if (urb->status)
-		err("%s - urb status %d", __FUNCTION__, urb->status);
+		err("%s - urb status %d", __func__, urb->status);
 
 	switch (yld->ctl_data->cmd) {
 	case CMD_KEYPRESS:
@@ -473,7 +473,7 @@ static void urb_ctl_callback(struct urb 
 	}
 
 	if (ret)
-		err("%s - usb_submit_urb failed %d", __FUNCTION__, ret);
+		err("%s - usb_submit_urb failed %d", __func__, ret);
 }
 
 /*******************************************************************************
@@ -505,7 +505,7 @@ static int input_open(struct input_dev *
 	struct yealink_dev *yld = input_get_drvdata(dev);
 	int i, ret;
 
-	dbg("%s", __FUNCTION__);
+	dbg("%s", __func__);
 
 	/* force updates to device */
 	for (i = 0; i<sizeof(yld->master); i++)
@@ -521,7 +521,7 @@ static int input_open(struct input_dev *
 	yld->ctl_data->sum	= 0x100-CMD_INIT-10;
 	if ((ret = usb_submit_urb(yld->urb_ctl, GFP_KERNEL)) != 0) {
 		dbg("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, ret);
+		     __func__, ret);
 		return ret;
 	}
 	return 0;
diff -puN drivers/input/mouse/appletouch.c~input-replace-remaining-__function__-occurrences drivers/input/mouse/appletouch.c
--- a/drivers/input/mouse/appletouch.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/mouse/appletouch.c
@@ -287,7 +287,7 @@ static void atp_reinit(struct work_struc
 	retval = usb_submit_urb(dev->urb, GFP_ATOMIC);
 	if (retval) {
 		err("%s - usb_submit_urb failed with result %d",
-		    __FUNCTION__, retval);
+		    __func__, retval);
 	}
 }
 
@@ -379,11 +379,11 @@ static void atp_complete(struct urb* urb
 	case -ESHUTDOWN:
 		/* This urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		return;
 	default:
 		dbg("%s - nonzero urb status received: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		goto exit;
 	}
 
@@ -565,7 +565,7 @@ exit:
 	retval = usb_submit_urb(dev->urb, GFP_ATOMIC);
 	if (retval) {
 		err("%s - usb_submit_urb failed with result %d",
-		    __FUNCTION__, retval);
+		    __func__, retval);
 	}
 }
 
diff -puN drivers/input/tablet/acecad.c~input-replace-remaining-__function__-occurrences drivers/input/tablet/acecad.c
--- a/drivers/input/tablet/acecad.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/tablet/acecad.c
@@ -73,10 +73,10 @@ static void usb_acecad_irq(struct urb *u
 		case -ENOENT:
 		case -ESHUTDOWN:
 			/* this urb is terminated, clean up */
-			dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+			dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 			return;
 		default:
-			dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+			dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 			goto resubmit;
 	}
 
diff -puN drivers/input/tablet/aiptek.c~input-replace-remaining-__function__-occurrences drivers/input/tablet/aiptek.c
--- a/drivers/input/tablet/aiptek.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/tablet/aiptek.c
@@ -449,12 +449,12 @@ static void aiptek_irq(struct urb *urb)
 	case -ESHUTDOWN:
 		/* This urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		return;
 
 	default:
 		dbg("%s - nonzero urb status received: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		goto exit;
 	}
 
@@ -813,7 +813,7 @@ exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval != 0) {
 		err("%s - usb_submit_urb failed with result %d",
-		    __FUNCTION__, retval);
+		    __func__, retval);
 	}
 }
 
diff -puN drivers/input/tablet/kbtab.c~input-replace-remaining-__function__-occurrences drivers/input/tablet/kbtab.c
--- a/drivers/input/tablet/kbtab.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/tablet/kbtab.c
@@ -56,10 +56,10 @@ static void kbtab_irq(struct urb *urb)
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 		return;
 	default:
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 		goto exit;
 	}
 
@@ -88,7 +88,7 @@ static void kbtab_irq(struct urb *urb)
 	retval = usb_submit_urb (urb, GFP_ATOMIC);
 	if (retval)
 		err ("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, retval);
+		     __func__, retval);
 }
 
 static struct usb_device_id kbtab_ids[] = {
diff -puN drivers/input/tablet/wacom_sys.c~input-replace-remaining-__function__-occurrences drivers/input/tablet/wacom_sys.c
--- a/drivers/input/tablet/wacom_sys.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/tablet/wacom_sys.c
@@ -56,10 +56,10 @@ static void wacom_sys_irq(struct urb *ur
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 		return;
 	default:
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 		goto exit;
 	}
 
@@ -74,7 +74,7 @@ static void wacom_sys_irq(struct urb *ur
 	retval = usb_submit_urb (urb, GFP_ATOMIC);
 	if (retval)
 		err ("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, retval);
+		     __func__, retval);
 }
 
 void wacom_report_key(void *wcombo, unsigned int key_type, int key_data)
diff -puN drivers/input/touchscreen/usbtouchscreen.c~input-replace-remaining-__function__-occurrences drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~input-replace-remaining-__function__-occurrences
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -262,7 +262,7 @@ static int mtouch_init(struct usbtouch_u
 	                      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 	                      1, 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
 	dbg("%s - usb_control_msg - MTOUCHUSB_RESET - bytes|err: %d",
-	    __FUNCTION__, ret);
+	    __func__, ret);
 	if (ret < 0)
 		return ret;
 	msleep(150);
@@ -273,7 +273,7 @@ static int mtouch_init(struct usbtouch_u
 				      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				      1, 1, NULL, 0, USB_CTRL_SET_TIMEOUT);
 		dbg("%s - usb_control_msg - MTOUCHUSB_ASYNC_REPORT - bytes|err: %d",
-		    __FUNCTION__, ret);
+		    __func__, ret);
 		if (ret >= 0)
 			break;
 		if (ret != -EPIPE)
@@ -793,18 +793,18 @@ static void usbtouch_irq(struct urb *urb
 	case -ETIME:
 		/* this urb is timing out */
 		dbg("%s - urb timed out - was the device unplugged?",
-		    __FUNCTION__);
+		    __func__);
 		return;
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		return;
 	default:
 		dbg("%s - nonzero urb status received: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		goto exit;
 	}
 
@@ -814,7 +814,7 @@ exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		err("%s - usb_submit_urb failed with result: %d",
-		    __FUNCTION__, retval);
+		    __func__, retval);
 }
 
 static int usbtouch_open(struct input_dev *input)
@@ -883,7 +883,7 @@ static int usbtouch_probe(struct usb_int
 
 	usbtouch->irq = usb_alloc_urb(0, GFP_KERNEL);
 	if (!usbtouch->irq) {
-		dbg("%s - usb_alloc_urb failed: usbtouch->irq", __FUNCTION__);
+		dbg("%s - usb_alloc_urb failed: usbtouch->irq", __func__);
 		goto out_free_buffers;
 	}
 
@@ -939,14 +939,14 @@ static int usbtouch_probe(struct usb_int
 	if (type->init) {
 		err = type->init(usbtouch);
 		if (err) {
-			dbg("%s - type->init() failed, err: %d", __FUNCTION__, err);
+			dbg("%s - type->init() failed, err: %d", __func__, err);
 			goto out_free_buffers;
 		}
 	}
 
 	err = input_register_device(usbtouch->input);
 	if (err) {
-		dbg("%s - input_register_device failed, err: %d", __FUNCTION__, err);
+		dbg("%s - input_register_device failed, err: %d", __func__, err);
 		goto out_free_buffers;
 	}
 
@@ -966,12 +966,12 @@ static void usbtouch_disconnect(struct u
 {
 	struct usbtouch_usb *usbtouch = usb_get_intfdata(intf);
 
-	dbg("%s - called", __FUNCTION__);
+	dbg("%s - called", __func__);
 
 	if (!usbtouch)
 		return;
 
-	dbg("%s - usbtouch is initialized, cleaning up", __FUNCTION__);
+	dbg("%s - usbtouch is initialized, cleaning up", __func__);
 	usb_set_intfdata(intf, NULL);
 	usb_kill_urb(usbtouch->irq);
 	input_unregister_device(usbtouch->input);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
misc-fix-integer-as-null-pointer-warnings.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
block-use-get_unaligned_-helpers.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
usb-use-get_unaligned_-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
wireless-use-get-put_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch

