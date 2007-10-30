From: akpm@linux-foundation.org
Subject: + bas_gigaset-suspend-support.patch added to -mm tree
Date: Tue, 30 Oct 2007 14:01:30 -0700
Message-ID: <200710302101.l9UL1UhQ027909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56110 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024AbXJ3VCF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 17:02:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc


The patch titled
     bas_gigaset: suspend support
has been added to the -mm tree.  Its filename is
     bas_gigaset-suspend-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bas_gigaset: suspend support
From: Tilman Schmidt <tilman@imap.cc>

Add basic suspend/resume support to the bas_gigaset driver.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/bas-gigaset.c |  230 ++++++++++++++++++++++++---
 1 file changed, 207 insertions(+), 23 deletions(-)

diff -puN drivers/isdn/gigaset/bas-gigaset.c~bas_gigaset-suspend-support drivers/isdn/gigaset/bas-gigaset.c
--- a/drivers/isdn/gigaset/bas-gigaset.c~bas_gigaset-suspend-support
+++ a/drivers/isdn/gigaset/bas-gigaset.c
@@ -43,6 +43,9 @@ MODULE_PARM_DESC(cidmode, "Call-ID mode"
 #define GIGASET_MODULENAME "bas_gigaset"
 #define GIGASET_DEVNAME    "ttyGB"
 
+/* number of B channels */
+#define BAS_CHANNELS	2
+
 /* length limit according to Siemens 3070usb-protokoll.doc ch. 2.1 */
 #define IF_WRITEBUF 264
 
@@ -73,6 +76,14 @@ static int gigaset_probe(struct usb_inte
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
@@ -107,6 +118,7 @@ struct bas_cardstate {
 	spinlock_t		lock;		/* locks all following */
 	atomic_t		basstate;	/* bitmap (BS_*) */
 	int			pending;	/* uncompleted base request */
+	wait_queue_head_t	waitqueue;
 	int			rcvbuf_size;	/* size of AT receive buffer */
 						/* 0: no receive in progress */
 	int			retry_cmd_in;	/* receive req retry count */
@@ -121,6 +133,7 @@ struct bas_cardstate {
 #define BS_ATTIMER	0x020	/* waiting for HD_READY_SEND_ATDATA */
 #define BS_ATRDPEND	0x040	/* urb_cmd_in in use */
 #define BS_ATWRPEND	0x080	/* urb_cmd_out in use */
+#define BS_SUSPEND	0x100	/* USB port suspended */
 
 
 static struct gigaset_driver *driver = NULL;
@@ -132,6 +145,11 @@ static struct usb_driver gigaset_usb_dri
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
@@ -464,6 +482,7 @@ static void read_ctrl_callback(struct ur
 	int rc;
 
 	update_basstate(ucs, 0, BS_ATRDPEND);
+	wake_up(&ucs->waitqueue);
 
 	if (!ucs->rcvbuf_size) {
 		dev_warn(cs->dev, "%s: no receive in progress\n", __func__);
@@ -550,17 +569,27 @@ static void read_ctrl_callback(struct ur
 static int atread_submit(struct cardstate *cs, int timeout)
 {
 	struct bas_cardstate *ucs = cs->hw.bas;
+	int basstate;
 	int ret;
 
 	gig_dbg(DEBUG_USBREQ, "-------> HD_READ_ATMESSAGE (%d)",
 		ucs->rcvbuf_size);
 
-	if (update_basstate(ucs, BS_ATRDPEND, 0) & BS_ATRDPEND) {
+	if ((basstate = update_basstate(ucs, BS_ATRDPEND, 0)) & BS_ATRDPEND) {
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
@@ -745,6 +774,7 @@ static void read_int_callback(struct urb
 	}
 
 	check_pending(ucs);
+	wake_up(&ucs->waitqueue);
 
 resubmit:
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
@@ -932,15 +962,15 @@ static int starturbs(struct bc_state *bc
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
@@ -1406,6 +1436,8 @@ static void req_timeout(unsigned long da
 		dev_warn(bcs->cs->dev, "request 0x%02x timed out, clearing\n",
 			 pending);
 	}
+
+	wake_up(&ucs->waitqueue);
 }
 
 /* write_ctrl_callback
@@ -1445,7 +1477,9 @@ static void write_ctrl_callback(struct u
 		break;
 
 	default:				/* any failure */
-		if (++ucs->retry_ctrl > BAS_RETRY) {
+		/* don't retry if suspend requested */
+		if (++ucs->retry_ctrl > BAS_RETRY ||
+		    (atomic_read(&ucs->basstate) & BS_SUSPEND)) {
 			dev_err(&ucs->interface->dev,
 				"control request 0x%02x failed: %s\n",
 				ucs->dr_ctrl.bRequest,
@@ -1474,6 +1508,7 @@ static void write_ctrl_callback(struct u
 	del_timer(&ucs->timer_ctrl);
 	ucs->pending = 0;
 	spin_unlock_irqrestore(&ucs->lock, flags);
+	wake_up(&ucs->waitqueue);
 }
 
 /* req_submit
@@ -1548,37 +1583,46 @@ static int req_submit(struct bc_state *b
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
 
+	if (atomic_read(&cs->hw.bas->basstate) & BS_SUSPEND) {
+		dev_notice(cs->dev,
+			   "not starting isochronous I/O, "
+			   "suspend in progress\n");
+		spin_unlock_irqrestore(&cs->lock, flags);
+		return -EHOSTUNREACH;
+	}
+
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
 
@@ -1594,20 +1638,21 @@ static int gigaset_init_bchannel(struct 
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
@@ -1615,10 +1660,10 @@ static int gigaset_close_bchannel(struct
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
 
@@ -1668,6 +1713,7 @@ static void write_command_callback(struc
 	unsigned long flags;
 
 	update_basstate(ucs, 0, BS_ATWRPEND);
+	wake_up(&ucs->waitqueue);
 
 	/* check status */
 	switch (urb->status) {
@@ -1691,6 +1737,13 @@ static void write_command_callback(struc
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
@@ -1799,6 +1852,12 @@ static int start_cbsend(struct cardstate
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
@@ -2102,7 +2161,7 @@ static void freeurbs(struct cardstate *c
 	int i, j;
 
 	gig_dbg(DEBUG_INIT, "%s: killing URBs", __func__);
-	for (j = 0; j < 2; ++j) {
+	for (j = 0; j < BAS_CHANNELS; ++j) {
 		ubc = cs->bcs[j].hw.bas;
 		for (i = 0; i < BAS_OUTURBS; ++i) {
 			usb_kill_urb(ubc->isoouturbs[i].urb);
@@ -2203,7 +2262,7 @@ static int gigaset_probe(struct usb_inte
 	    !(ucs->urb_ctrl = usb_alloc_urb(0, GFP_KERNEL)))
 		goto allocerr;
 
-	for (j = 0; j < 2; ++j) {
+	for (j = 0; j < BAS_CHANNELS; ++j) {
 		ubc = cs->bcs[j].hw.bas;
 		for (i = 0; i < BAS_OUTURBS; ++i)
 			if (!(ubc->isoouturbs[i].urb =
@@ -2276,7 +2335,7 @@ static void gigaset_disconnect(struct us
 
 	/* tell LL all channels are down */
 	//FIXME shouldn't gigaset_stop() do this?
-	for (j = 0; j < 2; ++j)
+	for (j = 0; j < BAS_CHANNELS; ++j)
 		gigaset_bchannel_down(cs->bcs + j);
 
 	/* stop driver (common part) */
@@ -2298,6 +2357,131 @@ static void gigaset_disconnect(struct us
 	gigaset_unassign(cs);
 }
 
+/* gigaset_suspend
+ * This function is called before the USB connection is suspended.
+ */
+static int gigaset_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct cardstate *cs;
+	struct bas_cardstate *ucs;
+	int basstate;
+	int rc;
+
+	if ((cs = usb_get_intfdata(intf)) == NULL ||
+	    (ucs = cs->hw.bas) == NULL) {
+		err("%s: no cardstate", __func__);
+		return -EFAULT;
+	}
+
+	/* set suspend flag; this stops AT command/response traffic */
+	if (update_basstate(ucs, BS_SUSPEND, 0) & BS_SUSPEND) {
+		gig_dbg(DEBUG_INIT, "already suspended");
+		return 0;
+	}
+
+	//FIXME propagate to common module? ISDN_STAT_STOP? block open()?
+
+	/* wait a bit for blocking conditions to go away */
+	//FIXME actively terminate them?
+	rc = wait_event_timeout(ucs->waitqueue,
+			!(atomic_read(&ucs->basstate) &
+			  (BS_B1OPEN|BS_B2OPEN|BS_ATRDPEND|BS_ATWRPEND)),
+			BAS_TIMEOUT*HZ/10);
+	gig_dbg(DEBUG_INIT, "wait_event_timeout() -> %d", rc);
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
+		gig_dbg(DEBUG_INIT, "closing AT channel");
+		if ((rc = req_submit(cs->bcs, HD_CLOSE_ATCHANNEL, 0, 0)) != 0) {
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
+	gig_dbg(DEBUG_INIT, "suspend complete");
+	return 0;
+}
+
+/* gigaset_resume
+ * This function is called after the USB connection has been resumed.
+ */
+static int gigaset_resume(struct usb_interface *intf)
+{
+	struct cardstate *cs;
+	struct bas_cardstate *ucs;
+	int rc;
+
+	if ((cs = usb_get_intfdata(intf)) == NULL ||
+	    (ucs = cs->hw.bas) == NULL) {
+		err("%s: no cardstate", __func__);
+		return -EFAULT;
+	}
+
+	/* resubmit interrupt URB for messages from base */
+	if ((rc = usb_submit_urb(ucs->urb_int_in, GFP_KERNEL)) != 0) {
+		dev_err(cs->dev, "could not resubmit interrupt URB: %s\n",
+			get_usb_rcmsg(rc));
+		return rc;
+	}
+
+	/* clear suspend flag to reallow activity */
+	update_basstate(ucs, 0, BS_SUSPEND);
+
+	//FIXME propagate to common module? ISDN_STAT_STAR? unblock open()?
+
+	gig_dbg(DEBUG_INIT, "resume complete");
+	return 0;
+}
+
+/* gigaset_pre_reset
+ * This function is called before the USB connection is reset.
+ */
+static int gigaset_pre_reset(struct usb_interface *intf)
+{
+	/* handle just like suspend but always succeed */
+	gigaset_suspend(intf, PMSG_ON);
+	return 0;
+}
+
+/* gigaset_post_reset
+ * This function is called after the USB connection has been reset.
+ */
+static int gigaset_post_reset(struct usb_interface *intf)
+{
+	//struct cardstate *cs = usb_get_intfdata(intf);
+
+	/* reinitialize device */
+	//FIXME anything to do? eg send HD_DEVICE_INIT_ACK?
+
+	/* resume operations */
+	return gigaset_resume(intf);
+}
+
+
 static const struct gigaset_ops gigops = {
 	gigaset_write_cmd,
 	gigaset_write_room,
@@ -2331,7 +2515,7 @@ static int __init bas_gigaset_init(void)
 		goto error;
 
 	/* allocate memory for our device state and intialize it */
-	cardstate = gigaset_initcs(driver, 2, 0, 0, cidmode,
+	cardstate = gigaset_initcs(driver, BAS_CHANNELS, 0, 0, cidmode,
 				   GIGASET_MODULENAME);
 	if (!cardstate)
 		goto error;
_

Patches currently in -mm which might be from tilman@imap.cc are

usb_gigaset-suspend-support.patch
bas_gigaset-suspend-support.patch
