From: akpm@linux-foundation.org
Subject: + bas_gigaset-suspend-support-v2.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:51:29 -0800
Message-ID: <200711152251.lAFMpTQP020058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300AbXKOWvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, gregkh@suse.de, hjlipp@web.de, kkeil@suse.de


The patch titled
     bas_gigaset: suspend support
has been added to the -mm tree.  Its filename is
     bas_gigaset-suspend-support-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bas_gigaset: suspend support
From: Tilman Schmidt <tilman@imap.cc>

Add basic suspend/resume support to the bas_gigaset ISDN driver for the
Siemens Gigaset SX255 series of ISDN DECT bases.

Only the USB aspects are handled so far; the ISDN subsystem is not notified in
any way, for lack of information about how to do that.  The driver will refuse
to suspend if a connection is active.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <gregkh@suse.de>
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/bas-gigaset.c |  166 ++++++++++++++++++++++++++-
 1 file changed, 164 insertions(+), 2 deletions(-)

diff -puN drivers/isdn/gigaset/bas-gigaset.c~bas_gigaset-suspend-support-v2 drivers/isdn/gigaset/bas-gigaset.c
--- a/drivers/isdn/gigaset/bas-gigaset.c~bas_gigaset-suspend-support-v2
+++ a/drivers/isdn/gigaset/bas-gigaset.c
@@ -73,6 +73,14 @@ static int gigaset_probe(struct usb_inte
 /* Function will be called if the device is unplugged */
 static void gigaset_disconnect(struct usb_interface *interface);
 
+/* functions called before/after suspend */
+static int gigaset_suspend(struct usb_interface *intf, pm_message_t message);
+static int gigaset_resume(struct usb_interface *intf);
+
+/* functions called before/after device reset */
+static int gigaset_pre_reset(struct usb_interface *intf);
+static int gigaset_post_reset(struct usb_interface *intf);
+
 static int atread_submit(struct cardstate *, int);
 static void stopurbs(struct bas_bc_state *);
 static int req_submit(struct bc_state *, int, int, int);
@@ -107,6 +115,7 @@ struct bas_cardstate {
 	spinlock_t		lock;		/* locks all following */
 	atomic_t		basstate;	/* bitmap (BS_*) */
 	int			pending;	/* uncompleted base request */
+	wait_queue_head_t	waitqueue;
 	int			rcvbuf_size;	/* size of AT receive buffer */
 						/* 0: no receive in progress */
 	int			retry_cmd_in;	/* receive req retry count */
@@ -121,6 +130,7 @@ struct bas_cardstate {
 #define BS_ATTIMER	0x020	/* waiting for HD_READY_SEND_ATDATA */
 #define BS_ATRDPEND	0x040	/* urb_cmd_in in use */
 #define BS_ATWRPEND	0x080	/* urb_cmd_out in use */
+#define BS_SUSPEND	0x100	/* USB port suspended */
 
 
 static struct gigaset_driver *driver = NULL;
@@ -132,6 +142,11 @@ static struct usb_driver gigaset_usb_dri
 	.probe =        gigaset_probe,
 	.disconnect =   gigaset_disconnect,
 	.id_table =     gigaset_table,
+	.suspend =	gigaset_suspend,
+	.resume =	gigaset_resume,
+	.reset_resume =	gigaset_post_reset,
+	.pre_reset =	gigaset_pre_reset,
+	.post_reset =	gigaset_post_reset,
 };
 
 /* get message text for usb_submit_urb return code
@@ -465,6 +480,7 @@ static void read_ctrl_callback(struct ur
 	int rc;
 
 	update_basstate(ucs, 0, BS_ATRDPEND);
+	wake_up(&ucs->waitqueue);
 
 	if (!ucs->rcvbuf_size) {
 		dev_warn(cs->dev, "%s: no receive in progress\n", __func__);
@@ -551,17 +567,28 @@ static void read_ctrl_callback(struct ur
 static int atread_submit(struct cardstate *cs, int timeout)
 {
 	struct bas_cardstate *ucs = cs->hw.bas;
+	int basstate;
 	int ret;
 
 	gig_dbg(DEBUG_USBREQ, "-------> HD_READ_ATMESSAGE (%d)",
 		ucs->rcvbuf_size);
 
-	if (update_basstate(ucs, BS_ATRDPEND, 0) & BS_ATRDPEND) {
+	basstate = update_basstate(ucs, BS_ATRDPEND, 0);
+	if (basstate & BS_ATRDPEND) {
 		dev_err(cs->dev,
 			"could not submit HD_READ_ATMESSAGE: URB busy\n");
 		return -EBUSY;
 	}
 
+	if (basstate & BS_SUSPEND) {
+		dev_notice(cs->dev,
+			   "HD_READ_ATMESSAGE not submitted, "
+			   "suspend in progress\n");
+		update_basstate(ucs, 0, BS_ATRDPEND);
+		/* treat like disconnect */
+		return -ENODEV;
+	}
+
 	ucs->dr_cmd_in.bRequestType = IN_VENDOR_REQ;
 	ucs->dr_cmd_in.bRequest = HD_READ_ATMESSAGE;
 	ucs->dr_cmd_in.wValue = 0;
@@ -747,6 +774,7 @@ static void read_int_callback(struct urb
 	}
 
 	check_pending(ucs);
+	wake_up(&ucs->waitqueue);
 
 resubmit:
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
@@ -1416,6 +1444,8 @@ static void req_timeout(unsigned long da
 		dev_warn(bcs->cs->dev, "request 0x%02x timed out, clearing\n",
 			 pending);
 	}
+
+	wake_up(&ucs->waitqueue);
 }
 
 /* write_ctrl_callback
@@ -1456,7 +1486,9 @@ static void write_ctrl_callback(struct u
 		break;
 
 	default:				/* any failure */
-		if (++ucs->retry_ctrl > BAS_RETRY) {
+		/* don't retry if suspend requested */
+		if (++ucs->retry_ctrl > BAS_RETRY ||
+		    (atomic_read(&ucs->basstate) & BS_SUSPEND)) {
 			dev_err(&ucs->interface->dev,
 				"control request 0x%02x failed: %s\n",
 				ucs->dr_ctrl.bRequest,
@@ -1485,6 +1517,7 @@ static void write_ctrl_callback(struct u
 	del_timer(&ucs->timer_ctrl);
 	ucs->pending = 0;
 	spin_unlock_irqrestore(&ucs->lock, flags);
+	wake_up(&ucs->waitqueue);
 }
 
 /* req_submit
@@ -1570,6 +1603,14 @@ static int gigaset_init_bchannel(struct 
 		return -ENODEV;
 	}
 
+	if (atomic_read(&cs->hw.bas->basstate) & BS_SUSPEND) {
+		dev_notice(cs->dev,
+			   "not starting isochronous I/O, "
+			   "suspend in progress\n");
+		spin_unlock_irqrestore(&cs->lock, flags);
+		return -EHOSTUNREACH;
+	}
+
 	if ((ret = starturbs(bcs)) < 0) {
 		dev_err(cs->dev,
 			"could not start isochronous I/O for channel B%d: %s\n",
@@ -1682,6 +1723,7 @@ static void write_command_callback(struc
 	unsigned long flags;
 
 	update_basstate(ucs, 0, BS_ATWRPEND);
+	wake_up(&ucs->waitqueue);
 
 	/* check status */
 	switch (status) {
@@ -1705,6 +1747,13 @@ static void write_command_callback(struc
 				 ucs->retry_cmd_out);
 			break;
 		}
+		if (atomic_read(&ucs->basstate) & BS_SUSPEND) {
+			dev_warn(cs->dev,
+				 "command write: %s, "
+				 "won't retry - suspend requested\n",
+				 get_usb_statmsg(status));
+			break;
+		}
 		if (cs->cmdbuf == NULL) {
 			dev_warn(cs->dev,
 				 "command write: %s, "
@@ -1813,6 +1862,12 @@ static int start_cbsend(struct cardstate
 	int rc;
 	int retval = 0;
 
+	/* check if suspend requested */
+	if (atomic_read(&ucs->basstate) & BS_SUSPEND) {
+		gig_dbg(DEBUG_TRANSCMD|DEBUG_LOCKCMD, "suspending");
+		return -EHOSTUNREACH;
+	}
+
 	/* check if AT channel is open */
 	if (!(atomic_read(&ucs->basstate) & BS_ATOPEN)) {
 		gig_dbg(DEBUG_TRANSCMD|DEBUG_LOCKCMD, "AT channel not open");
@@ -2099,6 +2154,7 @@ static int gigaset_initcshw(struct cards
 	init_timer(&ucs->timer_ctrl);
 	init_timer(&ucs->timer_atrdy);
 	init_timer(&ucs->timer_cmd_in);
+	init_waitqueue_head(&ucs->waitqueue);
 
 	return 1;
 }
@@ -2311,6 +2367,112 @@ static void gigaset_disconnect(struct us
 	gigaset_unassign(cs);
 }
 
+/* gigaset_suspend
+ * This function is called before the USB connection is suspended.
+ */
+static int gigaset_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct cardstate *cs = usb_get_intfdata(intf);
+	struct bas_cardstate *ucs = cs->hw.bas;
+	int basstate;
+	int rc;
+
+	/* set suspend flag; this stops AT command/response traffic */
+	if (update_basstate(ucs, BS_SUSPEND, 0) & BS_SUSPEND) {
+		gig_dbg(DEBUG_SUSPEND, "already suspended");
+		return 0;
+	}
+
+	/* wait a bit for blocking conditions to go away */
+	rc = wait_event_timeout(ucs->waitqueue,
+			!(atomic_read(&ucs->basstate) &
+			  (BS_B1OPEN|BS_B2OPEN|BS_ATRDPEND|BS_ATWRPEND)),
+			BAS_TIMEOUT*HZ/10);
+	gig_dbg(DEBUG_SUSPEND, "wait_event_timeout() -> %d", rc);
+
+	/* check for conditions preventing suspend */
+	basstate = atomic_read(&ucs->basstate);
+	if (basstate & (BS_B1OPEN|BS_B2OPEN|BS_ATRDPEND|BS_ATWRPEND)) {
+		dev_warn(cs->dev, "cannot suspend:\n");
+		if (basstate & BS_B1OPEN)
+			dev_warn(cs->dev, " B channel 1 open\n");
+		if (basstate & BS_B2OPEN)
+			dev_warn(cs->dev, " B channel 2 open\n");
+		if (basstate & BS_ATRDPEND)
+			dev_warn(cs->dev, " receiving AT reply\n");
+		if (basstate & BS_ATWRPEND)
+			dev_warn(cs->dev, " sending AT command\n");
+		update_basstate(ucs, 0, BS_SUSPEND);
+		return -EBUSY;
+	}
+
+	/* close AT channel if open */
+	if (basstate & BS_ATOPEN) {
+		gig_dbg(DEBUG_SUSPEND, "closing AT channel");
+		rc = req_submit(cs->bcs, HD_CLOSE_ATCHANNEL, 0, 0);
+		if (rc) {
+			update_basstate(ucs, 0, BS_SUSPEND);
+			return rc;
+		}
+		wait_event_timeout(ucs->waitqueue, !ucs->pending,
+				   BAS_TIMEOUT*HZ/10);
+		/* in case of timeout, proceed anyway */
+	}
+
+	/* kill all URBs and timers that might still be pending */
+	usb_kill_urb(ucs->urb_ctrl);
+	usb_kill_urb(ucs->urb_int_in);
+	del_timer_sync(&ucs->timer_ctrl);
+
+	gig_dbg(DEBUG_SUSPEND, "suspend complete");
+	return 0;
+}
+
+/* gigaset_resume
+ * This function is called after the USB connection has been resumed.
+ */
+static int gigaset_resume(struct usb_interface *intf)
+{
+	struct cardstate *cs = usb_get_intfdata(intf);
+	struct bas_cardstate *ucs = cs->hw.bas;
+	int rc;
+
+	/* resubmit interrupt URB for spontaneous messages from base */
+	rc = usb_submit_urb(ucs->urb_int_in, GFP_KERNEL);
+	if (rc) {
+		dev_err(cs->dev, "could not resubmit interrupt URB: %s\n",
+			get_usb_rcmsg(rc));
+		return rc;
+	}
+
+	/* clear suspend flag to reallow activity */
+	update_basstate(ucs, 0, BS_SUSPEND);
+
+	gig_dbg(DEBUG_SUSPEND, "resume complete");
+	return 0;
+}
+
+/* gigaset_pre_reset
+ * This function is called before the USB connection is reset.
+ */
+static int gigaset_pre_reset(struct usb_interface *intf)
+{
+	/* handle just like suspend */
+	return gigaset_suspend(intf, PMSG_ON);
+}
+
+/* gigaset_post_reset
+ * This function is called after the USB connection has been reset.
+ */
+static int gigaset_post_reset(struct usb_interface *intf)
+{
+	/* FIXME: send HD_DEVICE_INIT_ACK? */
+
+	/* resume operations */
+	return gigaset_resume(intf);
+}
+
+
 static const struct gigaset_ops gigops = {
 	gigaset_write_cmd,
 	gigaset_write_room,
_

Patches currently in -mm which might be from tilman@imap.cc are

usb-power-managementtxt-disconnect-clarification.patch
gigaset-clean-up-urb-status-usage.patch
gigaset-code-cleanups.patch
bas_gigaset-suspend-support-v2.patch
usb_gigaset-suspend-support-v3.patch
