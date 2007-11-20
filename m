From: akpm@linux-foundation.org
Subject: + gigaset-atomic-cleanup.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:23:53 -0800
Message-ID: <200711200723.lAK7NrF9021448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836AbXKTHYr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:24:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc


The patch titled
     gigaset: atomic cleanup
has been added to the -mm tree.  Its filename is
     gigaset-atomic-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gigaset: atomic cleanup
From: Tilman Schmidt <tilman@imap.cc>

Convert atomic_t variables that don't actually use atomic_t functionality
to int.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/asyncdata.c   |    8 +-
 drivers/isdn/gigaset/bas-gigaset.c |   86 ++++++++++-----------
 drivers/isdn/gigaset/common.c      |   30 +++----
 drivers/isdn/gigaset/ev-layer.c    |  106 +++++++++++++--------------
 drivers/isdn/gigaset/gigaset.h     |   16 ++--
 drivers/isdn/gigaset/interface.c   |   15 +--
 drivers/isdn/gigaset/isocdata.c    |   51 ++++++------
 drivers/isdn/gigaset/ser-gigaset.c |   10 +-
 drivers/isdn/gigaset/usb-gigaset.c |   22 ++---
 9 files changed, 169 insertions(+), 175 deletions(-)

diff -puN drivers/isdn/gigaset/asyncdata.c~gigaset-atomic-cleanup drivers/isdn/gigaset/asyncdata.c
--- a/drivers/isdn/gigaset/asyncdata.c~gigaset-atomic-cleanup
+++ a/drivers/isdn/gigaset/asyncdata.c
@@ -350,8 +350,8 @@ void gigaset_m10x_input(struct inbuf_t *
 	unsigned char *src, c;
 	int procbytes;
 
-	head = atomic_read(&inbuf->head);
-	tail = atomic_read(&inbuf->tail);
+	head = inbuf->head;
+	tail = inbuf->tail;
 	gig_dbg(DEBUG_INTR, "buffer state: %u -> %u", head, tail);
 
 	if (head != tail) {
@@ -361,7 +361,7 @@ void gigaset_m10x_input(struct inbuf_t *
 		gig_dbg(DEBUG_INTR, "processing %u bytes", numbytes);
 
 		while (numbytes) {
-			if (atomic_read(&cs->mstate) == MS_LOCKED) {
+			if (cs->mstate == MS_LOCKED) {
 				procbytes = lock_loop(src, numbytes, inbuf);
 				src += procbytes;
 				numbytes -= procbytes;
@@ -436,7 +436,7 @@ nextbyte:
 		}
 
 		gig_dbg(DEBUG_INTR, "setting head to %u", head);
-		atomic_set(&inbuf->head, head);
+		inbuf->head = head;
 	}
 }
 EXPORT_SYMBOL_GPL(gigaset_m10x_input);
diff -puN drivers/isdn/gigaset/bas-gigaset.c~gigaset-atomic-cleanup drivers/isdn/gigaset/bas-gigaset.c
--- a/drivers/isdn/gigaset/bas-gigaset.c~gigaset-atomic-cleanup
+++ a/drivers/isdn/gigaset/bas-gigaset.c
@@ -113,7 +113,7 @@ struct bas_cardstate {
 	unsigned char		int_in_buf[3];
 
 	spinlock_t		lock;		/* locks all following */
-	atomic_t		basstate;	/* bitmap (BS_*) */
+	int			basstate;	/* bitmap (BS_*) */
 	int			pending;	/* uncompleted base request */
 	wait_queue_head_t	waitqueue;
 	int			rcvbuf_size;	/* size of AT receive buffer */
@@ -370,27 +370,27 @@ static void check_pending(struct bas_car
 	case 0:
 		break;
 	case HD_OPEN_ATCHANNEL:
-		if (atomic_read(&ucs->basstate) & BS_ATOPEN)
+		if (ucs->basstate & BS_ATOPEN)
 			ucs->pending = 0;
 		break;
 	case HD_OPEN_B1CHANNEL:
-		if (atomic_read(&ucs->basstate) & BS_B1OPEN)
+		if (ucs->basstate & BS_B1OPEN)
 			ucs->pending = 0;
 		break;
 	case HD_OPEN_B2CHANNEL:
-		if (atomic_read(&ucs->basstate) & BS_B2OPEN)
+		if (ucs->basstate & BS_B2OPEN)
 			ucs->pending = 0;
 		break;
 	case HD_CLOSE_ATCHANNEL:
-		if (!(atomic_read(&ucs->basstate) & BS_ATOPEN))
+		if (!(ucs->basstate & BS_ATOPEN))
 			ucs->pending = 0;
 		break;
 	case HD_CLOSE_B1CHANNEL:
-		if (!(atomic_read(&ucs->basstate) & BS_B1OPEN))
+		if (!(ucs->basstate & BS_B1OPEN))
 			ucs->pending = 0;
 		break;
 	case HD_CLOSE_B2CHANNEL:
-		if (!(atomic_read(&ucs->basstate) & BS_B2OPEN))
+		if (!(ucs->basstate & BS_B2OPEN))
 			ucs->pending = 0;
 		break;
 	case HD_DEVICE_INIT_ACK:		/* no reply expected */
@@ -456,8 +456,8 @@ inline static int update_basstate(struct
 	int state;
 
 	spin_lock_irqsave(&ucs->lock, flags);
-	state = atomic_read(&ucs->basstate);
-	atomic_set(&ucs->basstate, (state & ~clear) | set);
+	state = ucs->basstate;
+	ucs->basstate = (state & ~clear) | set;
 	spin_unlock_irqrestore(&ucs->lock, flags);
 	return state;
 }
@@ -832,7 +832,7 @@ static void read_iso_callback(struct urb
 			urb->iso_frame_desc[i].status = 0;
 			urb->iso_frame_desc[i].actual_length = 0;
 		}
-		if (likely(atomic_read(&ubc->running))) {
+		if (likely(ubc->running)) {
 			/* urb->dev is clobbered by USB subsystem */
 			urb->dev = bcs->cs->hw.bas->udev;
 			urb->transfer_flags = URB_ISO_ASAP;
@@ -909,7 +909,7 @@ static int starturbs(struct bc_state *bc
 		bcs->inputstate |= INS_flag_hunt;
 
 	/* submit all isochronous input URBs */
-	atomic_set(&ubc->running, 1);
+	ubc->running = 1;
 	for (k = 0; k < BAS_INURBS; k++) {
 		urb = ubc->isoinurbs[k];
 		if (!urb) {
@@ -992,7 +992,7 @@ static void stopurbs(struct bas_bc_state
 {
 	int k, rc;
 
-	atomic_set(&ubc->running, 0);
+	ubc->running = 0;
 
 	for (k = 0; k < BAS_INURBS; ++k) {
 		rc = usb_unlink_urb(ubc->isoinurbs[k]);
@@ -1068,7 +1068,7 @@ static int submit_iso_write_urb(struct i
 			}
 			break;
 		}
-		ucx->limit = atomic_read(&ubc->isooutbuf->nextread);
+		ucx->limit = ubc->isooutbuf->nextread;
 		ifd->status = 0;
 		ifd->actual_length = 0;
 	}
@@ -1115,7 +1115,7 @@ static void write_iso_tasklet(unsigned l
 
 	/* loop while completed URBs arrive in time */
 	for (;;) {
-		if (unlikely(!(atomic_read(&ubc->running)))) {
+		if (unlikely(!(ubc->running))) {
 			gig_dbg(DEBUG_ISO, "%s: not running", __func__);
 			return;
 		}
@@ -1220,7 +1220,7 @@ static void write_iso_tasklet(unsigned l
 
 		/* mark the write buffer area covered by this URB as free */
 		if (done->limit >= 0)
-			atomic_set(&ubc->isooutbuf->read, done->limit);
+			ubc->isooutbuf->read = done->limit;
 
 		/* mark URB as free */
 		spin_lock_irqsave(&ubc->isooutlock, flags);
@@ -1294,7 +1294,7 @@ static void read_iso_tasklet(unsigned lo
 		}
 		spin_unlock_irqrestore(&ubc->isoinlock, flags);
 
-		if (unlikely(!(atomic_read(&ubc->running)))) {
+		if (unlikely(!(ubc->running))) {
 			gig_dbg(DEBUG_ISO,
 				"%s: channel not running, "
 				"dropped URB with status: %s",
@@ -1488,7 +1488,7 @@ static void write_ctrl_callback(struct u
 	default:				/* any failure */
 		/* don't retry if suspend requested */
 		if (++ucs->retry_ctrl > BAS_RETRY ||
-		    (atomic_read(&ucs->basstate) & BS_SUSPEND)) {
+		    (ucs->basstate & BS_SUSPEND)) {
 			dev_err(&ucs->interface->dev,
 				"control request 0x%02x failed: %s\n",
 				ucs->dr_ctrl.bRequest,
@@ -1603,7 +1603,7 @@ static int gigaset_init_bchannel(struct 
 		return -ENODEV;
 	}
 
-	if (atomic_read(&cs->hw.bas->basstate) & BS_SUSPEND) {
+	if (cs->hw.bas->basstate & BS_SUSPEND) {
 		dev_notice(cs->dev,
 			   "not starting isochronous I/O, "
 			   "suspend in progress\n");
@@ -1658,8 +1658,7 @@ static int gigaset_close_bchannel(struct
 		return -ENODEV;
 	}
 
-	if (!(atomic_read(&cs->hw.bas->basstate) &
-	      (bcs->channel ? BS_B2OPEN : BS_B1OPEN))) {
+	if (!(cs->hw.bas->basstate & (bcs->channel ? BS_B2OPEN : BS_B1OPEN))) {
 		/* channel not running: just signal common.c */
 		spin_unlock_irqrestore(&cs->lock, flags);
 		gigaset_bchannel_down(bcs);
@@ -1747,7 +1746,7 @@ static void write_command_callback(struc
 				 ucs->retry_cmd_out);
 			break;
 		}
-		if (atomic_read(&ucs->basstate) & BS_SUSPEND) {
+		if (ucs->basstate & BS_SUSPEND) {
 			dev_warn(cs->dev,
 				 "command write: %s, "
 				 "won't retry - suspend requested\n",
@@ -1863,13 +1862,13 @@ static int start_cbsend(struct cardstate
 	int retval = 0;
 
 	/* check if suspend requested */
-	if (atomic_read(&ucs->basstate) & BS_SUSPEND) {
+	if (ucs->basstate & BS_SUSPEND) {
 		gig_dbg(DEBUG_TRANSCMD|DEBUG_LOCKCMD, "suspending");
 		return -EHOSTUNREACH;
 	}
 
 	/* check if AT channel is open */
-	if (!(atomic_read(&ucs->basstate) & BS_ATOPEN)) {
+	if (!(ucs->basstate & BS_ATOPEN)) {
 		gig_dbg(DEBUG_TRANSCMD|DEBUG_LOCKCMD, "AT channel not open");
 		rc = req_submit(cs->bcs, HD_OPEN_ATCHANNEL, 0, BAS_TIMEOUT);
 		if (rc < 0) {
@@ -1885,8 +1884,7 @@ static int start_cbsend(struct cardstate
 	/* try to send first command in queue */
 	spin_lock_irqsave(&cs->cmdlock, flags);
 
-	while ((cb = cs->cmdbuf) != NULL &&
-	       atomic_read(&ucs->basstate) & BS_ATREADY) {
+	while ((cb = cs->cmdbuf) != NULL && (ucs->basstate & BS_ATREADY)) {
 		ucs->retry_cmd_out = 0;
 		rc = atwrite_submit(cs, cb->buf, cb->len);
 		if (unlikely(rc)) {
@@ -1924,7 +1922,7 @@ static int gigaset_write_cmd(struct card
 	unsigned long flags;
 	int rc;
 
-	gigaset_dbg_buffer(atomic_read(&cs->mstate) != MS_LOCKED ?
+	gigaset_dbg_buffer(cs->mstate != MS_LOCKED ?
 			     DEBUG_TRANSCMD : DEBUG_LOCKCMD,
 			   "CMD Transmit", len, buf);
 
@@ -2039,7 +2037,7 @@ static int gigaset_freebcshw(struct bc_s
 		return 0;
 
 	/* kill URBs and tasklets before freeing - better safe than sorry */
-	atomic_set(&ubc->running, 0);
+	ubc->running = 0;
 	gig_dbg(DEBUG_INIT, "%s: killing iso URBs", __func__);
 	for (i = 0; i < BAS_OUTURBS; ++i) {
 		usb_kill_urb(ubc->isoouturbs[i].urb);
@@ -2074,7 +2072,7 @@ static int gigaset_initbcshw(struct bc_s
 		return 0;
 	}
 
-	atomic_set(&ubc->running, 0);
+	ubc->running = 0;
 	atomic_set(&ubc->corrbytes, 0);
 	spin_lock_init(&ubc->isooutlock);
 	for (i = 0; i < BAS_OUTURBS; ++i) {
@@ -2119,7 +2117,7 @@ static void gigaset_reinitbcshw(struct b
 {
 	struct bas_bc_state *ubc = bcs->hw.bas;
 
-	atomic_set(&bcs->hw.bas->running, 0);
+	bcs->hw.bas->running = 0;
 	atomic_set(&bcs->hw.bas->corrbytes, 0);
 	bcs->hw.bas->numsub = 0;
 	spin_lock_init(&ubc->isooutlock);
@@ -2150,7 +2148,7 @@ static int gigaset_initcshw(struct cards
 	spin_lock_init(&ucs->lock);
 	ucs->pending = 0;
 
-	atomic_set(&ucs->basstate, 0);
+	ucs->basstate = 0;
 	init_timer(&ucs->timer_ctrl);
 	init_timer(&ucs->timer_atrdy);
 	init_timer(&ucs->timer_cmd_in);
@@ -2307,7 +2305,7 @@ static int gigaset_probe(struct usb_inte
 
 	/* tell common part that the device is ready */
 	if (startmode == SM_LOCKED)
-		atomic_set(&cs->mstate, MS_LOCKED);
+		cs->mstate = MS_LOCKED;
 
 	/* save address of controller structure */
 	usb_set_intfdata(interface, cs);
@@ -2342,7 +2340,7 @@ static void gigaset_disconnect(struct us
 	dev_info(cs->dev, "disconnecting Gigaset base\n");
 
 	/* mark base as not ready, all channels disconnected */
-	atomic_set(&ucs->basstate, 0);
+	ucs->basstate = 0;
 
 	/* tell LL all channels are down */
 	for (j = 0; j < BAS_CHANNELS; ++j)
@@ -2374,7 +2372,6 @@ static int gigaset_suspend(struct usb_in
 {
 	struct cardstate *cs = usb_get_intfdata(intf);
 	struct bas_cardstate *ucs = cs->hw.bas;
-	int basstate;
 	int rc;
 
 	/* set suspend flag; this stops AT command/response traffic */
@@ -2385,29 +2382,28 @@ static int gigaset_suspend(struct usb_in
 
 	/* wait a bit for blocking conditions to go away */
 	rc = wait_event_timeout(ucs->waitqueue,
-			!(atomic_read(&ucs->basstate) &
+			!(ucs->basstate &
 			  (BS_B1OPEN|BS_B2OPEN|BS_ATRDPEND|BS_ATWRPEND)),
 			BAS_TIMEOUT*HZ/10);
 	gig_dbg(DEBUG_SUSPEND, "wait_event_timeout() -> %d", rc);
 
 	/* check for conditions preventing suspend */
-	basstate = atomic_read(&ucs->basstate);
-	if (basstate & (BS_B1OPEN|BS_B2OPEN|BS_ATRDPEND|BS_ATWRPEND)) {
+	if (ucs->basstate & (BS_B1OPEN|BS_B2OPEN|BS_ATRDPEND|BS_ATWRPEND)) {
 		dev_warn(cs->dev, "cannot suspend:\n");
-		if (basstate & BS_B1OPEN)
+		if (ucs->basstate & BS_B1OPEN)
 			dev_warn(cs->dev, " B channel 1 open\n");
-		if (basstate & BS_B2OPEN)
+		if (ucs->basstate & BS_B2OPEN)
 			dev_warn(cs->dev, " B channel 2 open\n");
-		if (basstate & BS_ATRDPEND)
+		if (ucs->basstate & BS_ATRDPEND)
 			dev_warn(cs->dev, " receiving AT reply\n");
-		if (basstate & BS_ATWRPEND)
+		if (ucs->basstate & BS_ATWRPEND)
 			dev_warn(cs->dev, " sending AT command\n");
 		update_basstate(ucs, 0, BS_SUSPEND);
 		return -EBUSY;
 	}
 
 	/* close AT channel if open */
-	if (basstate & BS_ATOPEN) {
+	if (ucs->basstate & BS_ATOPEN) {
 		gig_dbg(DEBUG_SUSPEND, "closing AT channel");
 		rc = req_submit(cs->bcs, HD_CLOSE_ATCHANNEL, 0, 0);
 		if (rc) {
@@ -2546,25 +2542,25 @@ static void __exit bas_gigaset_exit(void
 	/* from now on, no isdn callback should be possible */
 
 	/* close all still open channels */
-	if (atomic_read(&ucs->basstate) & BS_B1OPEN) {
+	if (ucs->basstate & BS_B1OPEN) {
 		gig_dbg(DEBUG_INIT, "closing B1 channel");
 		usb_control_msg(ucs->udev, usb_sndctrlpipe(ucs->udev, 0),
 				HD_CLOSE_B1CHANNEL, OUT_VENDOR_REQ, 0, 0,
 				NULL, 0, BAS_TIMEOUT);
 	}
-	if (atomic_read(&ucs->basstate) & BS_B2OPEN) {
+	if (ucs->basstate & BS_B2OPEN) {
 		gig_dbg(DEBUG_INIT, "closing B2 channel");
 		usb_control_msg(ucs->udev, usb_sndctrlpipe(ucs->udev, 0),
 				HD_CLOSE_B2CHANNEL, OUT_VENDOR_REQ, 0, 0,
 				NULL, 0, BAS_TIMEOUT);
 	}
-	if (atomic_read(&ucs->basstate) & BS_ATOPEN) {
+	if (ucs->basstate & BS_ATOPEN) {
 		gig_dbg(DEBUG_INIT, "closing AT channel");
 		usb_control_msg(ucs->udev, usb_sndctrlpipe(ucs->udev, 0),
 				HD_CLOSE_ATCHANNEL, OUT_VENDOR_REQ, 0, 0,
 				NULL, 0, BAS_TIMEOUT);
 	}
-	atomic_set(&ucs->basstate, 0);
+	ucs->basstate = 0;
 
 	/* deregister this driver with the USB subsystem */
 	usb_deregister(&gigaset_usb_driver);
diff -puN drivers/isdn/gigaset/common.c~gigaset-atomic-cleanup drivers/isdn/gigaset/common.c
--- a/drivers/isdn/gigaset/common.c~gigaset-atomic-cleanup
+++ a/drivers/isdn/gigaset/common.c
@@ -501,11 +501,11 @@ static void gigaset_inbuf_init(struct in
 			       struct cardstate *cs, int inputstate)
 /* inbuf->read must be allocated before! */
 {
-	atomic_set(&inbuf->head, 0);
-	atomic_set(&inbuf->tail, 0);
+	inbuf->head = 0;
+	inbuf->tail = 0;
 	inbuf->cs = cs;
 	inbuf->bcs = bcs; /*base driver: NULL*/
-	inbuf->rcvbuf = NULL; //FIXME
+	inbuf->rcvbuf = NULL;
 	inbuf->inputstate = inputstate;
 }
 
@@ -521,8 +521,8 @@ int gigaset_fill_inbuf(struct inbuf_t *i
 		return 0;
 
 	bytesleft = numbytes;
-	tail = atomic_read(&inbuf->tail);
-	head = atomic_read(&inbuf->head);
+	tail = inbuf->tail;
+	head = inbuf->head;
 	gig_dbg(DEBUG_INTR, "buffer state: %u -> %u", head, tail);
 
 	while (bytesleft) {
@@ -546,7 +546,7 @@ int gigaset_fill_inbuf(struct inbuf_t *i
 		src += n;
 	}
 	gig_dbg(DEBUG_INTR, "setting tail to %u", tail);
-	atomic_set(&inbuf->tail, tail);
+	inbuf->tail = tail;
 	return numbytes != bytesleft;
 }
 EXPORT_SYMBOL_GPL(gigaset_fill_inbuf);
@@ -668,7 +668,7 @@ struct cardstate *gigaset_initcs(struct 
 
 	tasklet_init(&cs->event_tasklet, &gigaset_handle_event,
 		     (unsigned long) cs);
-	atomic_set(&cs->commands_pending, 0);
+	cs->commands_pending = 0;
 	cs->cur_at_seq = 0;
 	cs->gotfwver = -1;
 	cs->open_count = 0;
@@ -688,8 +688,8 @@ struct cardstate *gigaset_initcs(struct 
 	init_waitqueue_head(&cs->waitqueue);
 	cs->waiting = 0;
 
-	atomic_set(&cs->mode, M_UNKNOWN);
-	atomic_set(&cs->mstate, MS_UNINITIALIZED);
+	cs->mode = M_UNKNOWN;
+	cs->mstate = MS_UNINITIALIZED;
 
 	for (i = 0; i < channels; ++i) {
 		gig_dbg(DEBUG_INIT, "setting up bcs[%d].read", i);
@@ -806,8 +806,8 @@ static void cleanup_cs(struct cardstate 
 
 	spin_lock_irqsave(&cs->lock, flags);
 
-	atomic_set(&cs->mode, M_UNKNOWN);
-	atomic_set(&cs->mstate, MS_UNINITIALIZED);
+	cs->mode = M_UNKNOWN;
+	cs->mstate = MS_UNINITIALIZED;
 
 	clear_at_state(&cs->at_state);
 	dealloc_at_states(cs);
@@ -817,8 +817,8 @@ static void cleanup_cs(struct cardstate 
 	kfree(cs->inbuf->rcvbuf);
 	cs->inbuf->rcvbuf = NULL;
 	cs->inbuf->inputstate = INS_command;
-	atomic_set(&cs->inbuf->head, 0);
-	atomic_set(&cs->inbuf->tail, 0);
+	cs->inbuf->head = 0;
+	cs->inbuf->tail = 0;
 
 	cb = cs->cmdbuf;
 	while (cb) {
@@ -832,7 +832,7 @@ static void cleanup_cs(struct cardstate 
 	cs->gotfwver = -1;
 	cs->dle = 0;
 	cs->cur_at_seq = 0;
-	atomic_set(&cs->commands_pending, 0);
+	cs->commands_pending = 0;
 	cs->cbytes = 0;
 
 	spin_unlock_irqrestore(&cs->lock, flags);
@@ -862,7 +862,7 @@ int gigaset_start(struct cardstate *cs)
 	cs->connected = 1;
 	spin_unlock_irqrestore(&cs->lock, flags);
 
-	if (atomic_read(&cs->mstate) != MS_LOCKED) {
+	if (cs->mstate != MS_LOCKED) {
 		cs->ops->set_modem_ctrl(cs, 0, TIOCM_DTR|TIOCM_RTS);
 		cs->ops->baud_rate(cs, B115200);
 		cs->ops->set_line_ctrl(cs, CS8);
diff -puN drivers/isdn/gigaset/ev-layer.c~gigaset-atomic-cleanup drivers/isdn/gigaset/ev-layer.c
--- a/drivers/isdn/gigaset/ev-layer.c~gigaset-atomic-cleanup
+++ a/drivers/isdn/gigaset/ev-layer.c
@@ -735,7 +735,7 @@ static void disconnect(struct at_state_t
 	/* revert to selected idle mode */
 	if (!cs->cidmode) {
 		cs->at_state.pending_commands |= PC_UMMODE;
-		atomic_set(&cs->commands_pending, 1); //FIXME
+		cs->commands_pending = 1;
 		gig_dbg(DEBUG_CMD, "Scheduling PC_UMMODE");
 	}
 	spin_unlock_irqrestore(&cs->lock, flags);
@@ -793,15 +793,15 @@ static void init_failed(struct cardstate
 	struct at_state_t *at_state;
 
 	cs->at_state.pending_commands &= ~PC_INIT;
-	atomic_set(&cs->mode, mode);
-	atomic_set(&cs->mstate, MS_UNINITIALIZED);
+	cs->mode = mode;
+	cs->mstate = MS_UNINITIALIZED;
 	gigaset_free_channels(cs);
 	for (i = 0; i < cs->channels; ++i) {
 		at_state = &cs->bcs[i].at_state;
 		if (at_state->pending_commands & PC_CID) {
 			at_state->pending_commands &= ~PC_CID;
 			at_state->pending_commands |= PC_NOCID;
-			atomic_set(&cs->commands_pending, 1);
+			cs->commands_pending = 1;
 		}
 	}
 }
@@ -812,11 +812,11 @@ static void schedule_init(struct cardsta
 		gig_dbg(DEBUG_CMD, "not scheduling PC_INIT again");
 		return;
 	}
-	atomic_set(&cs->mstate, state);
-	atomic_set(&cs->mode, M_UNKNOWN);
+	cs->mstate = state;
+	cs->mode = M_UNKNOWN;
 	gigaset_block_channels(cs);
 	cs->at_state.pending_commands |= PC_INIT;
-	atomic_set(&cs->commands_pending, 1);
+	cs->commands_pending = 1;
 	gig_dbg(DEBUG_CMD, "Scheduling PC_INIT");
 }
 
@@ -953,13 +953,13 @@ static void start_dial(struct at_state_t
 
 	at_state->pending_commands |= PC_CID;
 	gig_dbg(DEBUG_CMD, "Scheduling PC_CID");
-	atomic_set(&cs->commands_pending, 1);
+	cs->commands_pending = 1;
 	return;
 
 error:
 	at_state->pending_commands |= PC_NOCID;
 	gig_dbg(DEBUG_CMD, "Scheduling PC_NOCID");
-	atomic_set(&cs->commands_pending, 1);
+	cs->commands_pending = 1;
 	return;
 }
 
@@ -973,12 +973,12 @@ static void start_accept(struct at_state
 	if (retval == 0) {
 		at_state->pending_commands |= PC_ACCEPT;
 		gig_dbg(DEBUG_CMD, "Scheduling PC_ACCEPT");
-		atomic_set(&cs->commands_pending, 1);
+		cs->commands_pending = 1;
 	} else {
-		//FIXME
+		/* error reset */
 		at_state->pending_commands |= PC_HUP;
 		gig_dbg(DEBUG_CMD, "Scheduling PC_HUP");
-		atomic_set(&cs->commands_pending, 1);
+		cs->commands_pending = 1;
 	}
 }
 
@@ -986,7 +986,7 @@ static void do_start(struct cardstate *c
 {
 	gigaset_free_channels(cs);
 
-	if (atomic_read(&cs->mstate) != MS_LOCKED)
+	if (cs->mstate != MS_LOCKED)
 		schedule_init(cs, MS_INIT);
 
 	cs->isdn_up = 1;
@@ -1000,9 +1000,9 @@ static void do_start(struct cardstate *c
 
 static void finish_shutdown(struct cardstate *cs)
 {
-	if (atomic_read(&cs->mstate) != MS_LOCKED) {
-		atomic_set(&cs->mstate, MS_UNINITIALIZED);
-		atomic_set(&cs->mode, M_UNKNOWN);
+	if (cs->mstate != MS_LOCKED) {
+		cs->mstate = MS_UNINITIALIZED;
+		cs->mode = M_UNKNOWN;
 	}
 
 	/* Tell the LL that the device is not available .. */
@@ -1022,10 +1022,10 @@ static void do_shutdown(struct cardstate
 {
 	gigaset_block_channels(cs);
 
-	if (atomic_read(&cs->mstate) == MS_READY) {
-		atomic_set(&cs->mstate, MS_SHUTDOWN);
+	if (cs->mstate == MS_READY) {
+		cs->mstate = MS_SHUTDOWN;
 		cs->at_state.pending_commands |= PC_SHUTDOWN;
-		atomic_set(&cs->commands_pending, 1);
+		cs->commands_pending = 1;
 		gig_dbg(DEBUG_CMD, "Scheduling PC_SHUTDOWN");
 	} else
 		finish_shutdown(cs);
@@ -1120,7 +1120,7 @@ static void handle_icall(struct cardstat
 		 * In fact it doesn't.
 		 */
 		at_state->pending_commands |= PC_HUP;
-		atomic_set(&cs->commands_pending, 1);
+		cs->commands_pending = 1;
 		break;
 	}
 }
@@ -1130,7 +1130,7 @@ static int do_lock(struct cardstate *cs)
 	int mode;
 	int i;
 
-	switch (atomic_read(&cs->mstate)) {
+	switch (cs->mstate) {
 	case MS_UNINITIALIZED:
 	case MS_READY:
 		if (cs->cur_at_seq || !list_empty(&cs->temp_at_states) ||
@@ -1152,20 +1152,20 @@ static int do_lock(struct cardstate *cs)
 		return -EBUSY;
 	}
 
-	mode = atomic_read(&cs->mode);
-	atomic_set(&cs->mstate, MS_LOCKED);
-	atomic_set(&cs->mode, M_UNKNOWN);
+	mode = cs->mode;
+	cs->mstate = MS_LOCKED;
+	cs->mode = M_UNKNOWN;
 
 	return mode;
 }
 
 static int do_unlock(struct cardstate *cs)
 {
-	if (atomic_read(&cs->mstate) != MS_LOCKED)
+	if (cs->mstate != MS_LOCKED)
 		return -EINVAL;
 
-	atomic_set(&cs->mstate, MS_UNINITIALIZED);
-	atomic_set(&cs->mode, M_UNKNOWN);
+	cs->mstate = MS_UNINITIALIZED;
+	cs->mode = M_UNKNOWN;
 	gigaset_free_channels(cs);
 	if (cs->connected)
 		schedule_init(cs, MS_INIT);
@@ -1198,17 +1198,17 @@ static void do_action(int action, struct
 	case ACT_INIT:
 		cs->at_state.pending_commands &= ~PC_INIT;
 		cs->cur_at_seq = SEQ_NONE;
-		atomic_set(&cs->mode, M_UNIMODEM);
+		cs->mode = M_UNIMODEM;
 		spin_lock_irqsave(&cs->lock, flags);
 		if (!cs->cidmode) {
 			spin_unlock_irqrestore(&cs->lock, flags);
 			gigaset_free_channels(cs);
-			atomic_set(&cs->mstate, MS_READY);
+			cs->mstate = MS_READY;
 			break;
 		}
 		spin_unlock_irqrestore(&cs->lock, flags);
 		cs->at_state.pending_commands |= PC_CIDMODE;
-		atomic_set(&cs->commands_pending, 1);
+		cs->commands_pending = 1;
 		gig_dbg(DEBUG_CMD, "Scheduling PC_CIDMODE");
 		break;
 	case ACT_FAILINIT:
@@ -1234,22 +1234,20 @@ static void do_action(int action, struct
 			| INS_command;
 		break;
 	case ACT_CMODESET:
-		if (atomic_read(&cs->mstate) == MS_INIT ||
-		    atomic_read(&cs->mstate) == MS_RECOVER) {
+		if (cs->mstate == MS_INIT || cs->mstate == MS_RECOVER) {
 			gigaset_free_channels(cs);
-			atomic_set(&cs->mstate, MS_READY);
+			cs->mstate = MS_READY;
 		}
-		atomic_set(&cs->mode, M_CID);
+		cs->mode = M_CID;
 		cs->cur_at_seq = SEQ_NONE;
 		break;
 	case ACT_UMODESET:
-		atomic_set(&cs->mode, M_UNIMODEM);
+		cs->mode = M_UNIMODEM;
 		cs->cur_at_seq = SEQ_NONE;
 		break;
 	case ACT_FAILCMODE:
 		cs->cur_at_seq = SEQ_NONE;
-		if (atomic_read(&cs->mstate) == MS_INIT ||
-		    atomic_read(&cs->mstate) == MS_RECOVER) {
+		if (cs->mstate == MS_INIT || cs->mstate == MS_RECOVER) {
 			init_failed(cs, M_UNKNOWN);
 			break;
 		}
@@ -1307,7 +1305,7 @@ static void do_action(int action, struct
 	case ACT_CONNECT:
 		if (cs->onechannel) {
 			at_state->pending_commands |= PC_DLE1;
-			atomic_set(&cs->commands_pending, 1);
+			cs->commands_pending = 1;
 			break;
 		}
 		bcs->chstate |= CHS_D_UP;
@@ -1333,7 +1331,7 @@ static void do_action(int action, struct
 			 * DLE only used for M10x with one B channel.
 			 */
 			at_state->pending_commands |= PC_DLE0;
-			atomic_set(&cs->commands_pending, 1);
+			cs->commands_pending = 1;
 		} else
 			disconnect(p_at_state);
 		break;
@@ -1369,7 +1367,7 @@ static void do_action(int action, struct
 			 "Could not enter DLE mode. Trying to hang up.\n");
 		channel = cs->curchannel;
 		cs->bcs[channel].at_state.pending_commands |= PC_HUP;
-		atomic_set(&cs->commands_pending, 1);
+		cs->commands_pending = 1;
 		break;
 
 	case ACT_CID: /* got cid; start dialing */
@@ -1379,7 +1377,7 @@ static void do_action(int action, struct
 			cs->bcs[channel].at_state.cid = ev->parameter;
 			cs->bcs[channel].at_state.pending_commands |=
 				PC_DIAL;
-			atomic_set(&cs->commands_pending, 1);
+			cs->commands_pending = 1;
 			break;
 		}
 		/* fall through */
@@ -1411,14 +1409,14 @@ static void do_action(int action, struct
 	case ACT_ABORTDIAL:	/* error/timeout during dial preparation */
 		cs->cur_at_seq = SEQ_NONE;
 		at_state->pending_commands |= PC_HUP;
-		atomic_set(&cs->commands_pending, 1);
+		cs->commands_pending = 1;
 		break;
 
 	case ACT_REMOTEREJECT:	/* DISCONNECT_IND after dialling */
 	case ACT_CONNTIMEOUT:	/* timeout waiting for ZSAU=ACTIVE */
 	case ACT_REMOTEHUP:	/* DISCONNECT_IND with established connection */
 		at_state->pending_commands |= PC_HUP;
-		atomic_set(&cs->commands_pending, 1);
+		cs->commands_pending = 1;
 		break;
 	case ACT_GETSTRING: /* warning: RING, ZDLE, ...
 			       are not handled properly anymore */
@@ -1515,7 +1513,7 @@ static void do_action(int action, struct
 		break;
 	case ACT_HUP:
 		at_state->pending_commands |= PC_HUP;
-		atomic_set(&cs->commands_pending, 1);
+		cs->commands_pending = 1;
 		gig_dbg(DEBUG_CMD, "Scheduling PC_HUP");
 		break;
 
@@ -1558,7 +1556,7 @@ static void do_action(int action, struct
 				cs->at_state.pending_commands |= PC_UMMODE;
 				gig_dbg(DEBUG_CMD, "Scheduling PC_UMMODE");
 			}
-			atomic_set(&cs->commands_pending, 1);
+			cs->commands_pending = 1;
 		}
 		spin_unlock_irqrestore(&cs->lock, flags);
 		cs->waiting = 0;
@@ -1741,7 +1739,7 @@ static void process_command_flags(struct
 	int sequence;
 	unsigned long flags;
 
-	atomic_set(&cs->commands_pending, 0);
+	cs->commands_pending = 0;
 
 	if (cs->cur_at_seq) {
 		gig_dbg(DEBUG_CMD, "not searching scheduled commands: busy");
@@ -1779,7 +1777,7 @@ static void process_command_flags(struct
 				~(PC_DLE1 | PC_ACCEPT | PC_DIAL);
 			if (at_state->cid > 0)
 				at_state->pending_commands |= PC_HUP;
-			if (atomic_read(&cs->mstate) == MS_RECOVER) {
+			if (cs->mstate == MS_RECOVER) {
 				if (at_state->pending_commands & PC_CID) {
 					at_state->pending_commands |= PC_NOCID;
 					at_state->pending_commands &= ~PC_CID;
@@ -1793,7 +1791,7 @@ static void process_command_flags(struct
 	if (cs->at_state.pending_commands == PC_UMMODE
 	    && !cs->cidmode
 	    && list_empty(&cs->temp_at_states)
-	    && atomic_read(&cs->mode) == M_CID) {
+	    && cs->mode == M_CID) {
 		sequence = SEQ_UMMODE;
 		at_state = &cs->at_state;
 		for (i = 0; i < cs->channels; ++i) {
@@ -1860,7 +1858,7 @@ static void process_command_flags(struct
 	}
 	if (cs->at_state.pending_commands & PC_CIDMODE) {
 		cs->at_state.pending_commands &= ~PC_CIDMODE;
-		if (atomic_read(&cs->mode) == M_UNIMODEM) {
+		if (cs->mode == M_UNIMODEM) {
 			cs->retry_count = 1;
 			schedule_sequence(cs, &cs->at_state, SEQ_CIDMODE);
 			return;
@@ -1886,11 +1884,11 @@ static void process_command_flags(struct
 			return;
 		}
 		if (bcs->at_state.pending_commands & PC_CID) {
-			switch (atomic_read(&cs->mode)) {
+			switch (cs->mode) {
 			case M_UNIMODEM:
 				cs->at_state.pending_commands |= PC_CIDMODE;
 				gig_dbg(DEBUG_CMD, "Scheduling PC_CIDMODE");
-				atomic_set(&cs->commands_pending, 1);
+				cs->commands_pending = 1;
 				return;
 #ifdef GIG_MAYINITONDIAL
 			case M_UNKNOWN:
@@ -1926,7 +1924,7 @@ static void process_events(struct cardst
 	for (i = 0; i < 2 * MAX_EVENTS; ++i) {
 		tail = cs->ev_tail;
 		if (tail == head) {
-			if (!check_flags && !atomic_read(&cs->commands_pending))
+			if (!check_flags && !cs->commands_pending)
 				break;
 			check_flags = 0;
 			spin_unlock_irqrestore(&cs->ev_lock, flags);
@@ -1934,7 +1932,7 @@ static void process_events(struct cardst
 			spin_lock_irqsave(&cs->ev_lock, flags);
 			tail = cs->ev_tail;
 			if (tail == head) {
-				if (!atomic_read(&cs->commands_pending))
+				if (!cs->commands_pending)
 					break;
 				continue;
 			}
@@ -1971,7 +1969,7 @@ void gigaset_handle_event(unsigned long 
 	struct cardstate *cs = (struct cardstate *) data;
 
 	/* handle incoming data on control/common channel */
-	if (atomic_read(&cs->inbuf->head) != atomic_read(&cs->inbuf->tail)) {
+	if (cs->inbuf->head != cs->inbuf->tail) {
 		gig_dbg(DEBUG_INTR, "processing new data");
 		cs->ops->handle_input(cs->inbuf);
 	}
diff -puN drivers/isdn/gigaset/gigaset.h~gigaset-atomic-cleanup drivers/isdn/gigaset/gigaset.h
--- a/drivers/isdn/gigaset/gigaset.h~gigaset-atomic-cleanup
+++ a/drivers/isdn/gigaset/gigaset.h
@@ -313,7 +313,7 @@ struct inbuf_t {
 	struct bc_state		*bcs;
 	struct cardstate	*cs;
 	int			inputstate;
-	atomic_t		head, tail;
+	int			head, tail;
 	unsigned char		data[RBUFSIZE];
 };
 
@@ -335,9 +335,9 @@ struct inbuf_t {
  *   are also filled with that value
  */
 struct isowbuf_t {
-	atomic_t	read;
-	atomic_t	nextread;
-	atomic_t	write;
+	int		read;
+	int		nextread;
+	int		write;
 	atomic_t	writesem;
 	int		wbits;
 	unsigned char	data[BAS_OUTBUFSIZE + BAS_OUTBUFPAD];
@@ -447,8 +447,8 @@ struct cardstate {
 	/* Stuff to handle communication */
 	wait_queue_head_t waitqueue;
 	int waiting;
-	atomic_t mode;			/* see M_XXXX */
-	atomic_t mstate;		/* Modem state: see MS_XXXX */
+	int mode;			/* see M_XXXX */
+	int mstate;			/* Modem state: see MS_XXXX */
 					/* only changed by the event layer */
 	int cmd_result;
 
@@ -505,7 +505,7 @@ struct cardstate {
 					   processed */
 	int curchannel;			/* channel those commands are meant
 					   for */
-	atomic_t commands_pending;	/* flag(s) in xxx.commands_pending have
+	int commands_pending;		/* flag(s) in xxx.commands_pending have
 					   been set */
 	struct tasklet_struct event_tasklet;
 					/* tasklet for serializing AT commands.
@@ -561,7 +561,7 @@ struct cmdbuf_t {
 
 struct bas_bc_state {
 	/* isochronous output state */
-	atomic_t	running;
+	int		running;
 	atomic_t	corrbytes;
 	spinlock_t	isooutlock;
 	struct isow_urbctx_t	isoouturbs[BAS_OUTURBS];
diff -puN drivers/isdn/gigaset/interface.c~gigaset-atomic-cleanup drivers/isdn/gigaset/interface.c
--- a/drivers/isdn/gigaset/interface.c~gigaset-atomic-cleanup
+++ a/drivers/isdn/gigaset/interface.c
@@ -28,12 +28,11 @@ static int if_lock(struct cardstate *cs,
 		return -EINVAL;
 
 	if (cmd < 0) {
-		*arg = atomic_read(&cs->mstate) == MS_LOCKED; //FIXME remove?
+		*arg = cs->mstate == MS_LOCKED;
 		return 0;
 	}
 
-	if (!cmd && atomic_read(&cs->mstate) == MS_LOCKED
-	    && cs->connected) {
+	if (!cmd && cs->mstate == MS_LOCKED && cs->connected) {
 		cs->ops->set_modem_ctrl(cs, 0, TIOCM_DTR|TIOCM_RTS);
 		cs->ops->baud_rate(cs, B115200);
 		cs->ops->set_line_ctrl(cs, CS8);
@@ -104,7 +103,7 @@ static int if_config(struct cardstate *c
 	if (*arg != 1)
 		return -EINVAL;
 
-	if (atomic_read(&cs->mstate) != MS_LOCKED)
+	if (cs->mstate != MS_LOCKED)
 		return -EBUSY;
 
 	if (!cs->connected) {
@@ -364,7 +363,7 @@ static int if_write(struct tty_struct *t
 
 	if (!cs->open_count)
 		warn("%s: device not opened", __func__);
-	else if (atomic_read(&cs->mstate) != MS_LOCKED) {
+	else if (cs->mstate != MS_LOCKED) {
 		warn("can't write to unlocked device");
 		retval = -EBUSY;
 	} else if (!cs->connected) {
@@ -398,9 +397,9 @@ static int if_write_room(struct tty_stru
 
 	if (!cs->open_count)
 		warn("%s: device not opened", __func__);
-	else if (atomic_read(&cs->mstate) != MS_LOCKED) {
+	else if (cs->mstate != MS_LOCKED) {
 		warn("can't write to unlocked device");
-		retval = -EBUSY; //FIXME
+		retval = -EBUSY;
 	} else if (!cs->connected) {
 		gig_dbg(DEBUG_ANY, "can't write to unplugged device");
 		retval = -EBUSY; //FIXME
@@ -430,7 +429,7 @@ static int if_chars_in_buffer(struct tty
 
 	if (!cs->open_count)
 		warn("%s: device not opened", __func__);
-	else if (atomic_read(&cs->mstate) != MS_LOCKED) {
+	else if (cs->mstate != MS_LOCKED) {
 		warn("can't write to unlocked device");
 		retval = -EBUSY;
 	} else if (!cs->connected) {
diff -puN drivers/isdn/gigaset/isocdata.c~gigaset-atomic-cleanup drivers/isdn/gigaset/isocdata.c
--- a/drivers/isdn/gigaset/isocdata.c~gigaset-atomic-cleanup
+++ a/drivers/isdn/gigaset/isocdata.c
@@ -23,9 +23,9 @@
  */
 void gigaset_isowbuf_init(struct isowbuf_t *iwb, unsigned char idle)
 {
-	atomic_set(&iwb->read, 0);
-	atomic_set(&iwb->nextread, 0);
-	atomic_set(&iwb->write, 0);
+	iwb->read = 0;
+	iwb->nextread = 0;
+	iwb->write = 0;
 	atomic_set(&iwb->writesem, 1);
 	iwb->wbits = 0;
 	iwb->idle = idle;
@@ -39,8 +39,8 @@ static inline int isowbuf_freebytes(stru
 {
 	int read, write, freebytes;
 
-	read = atomic_read(&iwb->read);
-	write = atomic_read(&iwb->write);
+	read = iwb->read;
+	write = iwb->write;
 	if ((freebytes = read - write) > 0) {
 		/* no wraparound: need padding space within regular area */
 		return freebytes - BAS_OUTBUFPAD;
@@ -62,7 +62,7 @@ static inline int isowbuf_poscmp(struct 
 	int read;
 	if (a == b)
 		return 0;
-	read = atomic_read(&iwb->read);
+	read = iwb->read;
 	if (a < b) {
 		if (a < read && read <= b)
 			return +1;
@@ -91,18 +91,18 @@ static inline int isowbuf_startwrite(str
 #ifdef CONFIG_GIGASET_DEBUG
 	gig_dbg(DEBUG_ISO,
 		"%s: acquired iso write semaphore, data[write]=%02x, nbits=%d",
-		__func__, iwb->data[atomic_read(&iwb->write)], iwb->wbits);
+		__func__, iwb->data[iwb->write], iwb->wbits);
 #endif
 	return 1;
 }
 
 /* finish writing
- * release the write semaphore and update the maximum buffer fill level
+ * release the write semaphore
  * returns the current write position
  */
 static inline int isowbuf_donewrite(struct isowbuf_t *iwb)
 {
-	int write = atomic_read(&iwb->write);
+	int write = iwb->write;
 	atomic_inc(&iwb->writesem);
 	return write;
 }
@@ -116,7 +116,7 @@ static inline int isowbuf_donewrite(stru
  */
 static inline void isowbuf_putbits(struct isowbuf_t *iwb, u32 data, int nbits)
 {
-	int write = atomic_read(&iwb->write);
+	int write = iwb->write;
 	data <<= iwb->wbits;
 	data |= iwb->data[write];
 	nbits += iwb->wbits;
@@ -128,7 +128,7 @@ static inline void isowbuf_putbits(struc
 	}
 	iwb->wbits = nbits;
 	iwb->data[write] = data & 0xff;
-	atomic_set(&iwb->write, write);
+	iwb->write = write;
 }
 
 /* put final flag on HDLC bitstream
@@ -142,7 +142,7 @@ static inline void isowbuf_putflag(struc
 	/* add two flags, thus reliably covering one byte */
 	isowbuf_putbits(iwb, 0x7e7e, 8);
 	/* recover the idle flag byte */
-	write = atomic_read(&iwb->write);
+	write = iwb->write;
 	iwb->idle = iwb->data[write];
 	gig_dbg(DEBUG_ISO, "idle fill byte %02x", iwb->idle);
 	/* mask extraneous bits in buffer */
@@ -160,8 +160,8 @@ int gigaset_isowbuf_getbytes(struct isow
 	int read, write, limit, src, dst;
 	unsigned char pbyte;
 
-	read = atomic_read(&iwb->nextread);
-	write = atomic_read(&iwb->write);
+	read = iwb->nextread;
+	write = iwb->write;
 	if (likely(read == write)) {
 		/* return idle frame */
 		return read < BAS_OUTBUFPAD ?
@@ -176,7 +176,7 @@ int gigaset_isowbuf_getbytes(struct isow
 		err("invalid size %d", size);
 		return -EINVAL;
 	}
-	src = atomic_read(&iwb->read);
+	src = iwb->read;
 	if (unlikely(limit > BAS_OUTBUFSIZE + BAS_OUTBUFPAD ||
 		     (read < src && limit >= src))) {
 		err("isoc write buffer frame reservation violated");
@@ -191,7 +191,8 @@ int gigaset_isowbuf_getbytes(struct isow
 			if (!isowbuf_startwrite(iwb))
 				return -EBUSY;
 			/* write position could have changed */
-			if (limit >= (write = atomic_read(&iwb->write))) {
+			write = iwb->write;
+			if (limit >= write) {
 				pbyte = iwb->data[write]; /* save
 							     partial byte */
 				limit = write + BAS_OUTBUFPAD;
@@ -213,7 +214,7 @@ int gigaset_isowbuf_getbytes(struct isow
 					__func__, pbyte, limit);
 				iwb->data[limit] = pbyte; /* restore
 							     partial byte */
-				atomic_set(&iwb->write, limit);
+				iwb->write = limit;
 			}
 			isowbuf_donewrite(iwb);
 		}
@@ -233,7 +234,7 @@ int gigaset_isowbuf_getbytes(struct isow
 			limit = src;
 		}
 	}
-	atomic_set(&iwb->nextread, limit);
+	iwb->nextread = limit;
 	return read;
 }
 
@@ -477,7 +478,7 @@ static inline int trans_buildframe(struc
 	unsigned char c;
 
 	if (unlikely(count <= 0))
-		return atomic_read(&iwb->write); /* better ideas? */
+		return iwb->write;
 
 	if (isowbuf_freebytes(iwb) < count ||
 	    !isowbuf_startwrite(iwb)) {
@@ -486,13 +487,13 @@ static inline int trans_buildframe(struc
 	}
 
 	gig_dbg(DEBUG_STREAM, "put %d bytes", count);
-	write = atomic_read(&iwb->write);
+	write = iwb->write;
 	do {
 		c = bitrev8(*in++);
 		iwb->data[write++] = c;
 		write %= BAS_OUTBUFSIZE;
 	} while (--count > 0);
-	atomic_set(&iwb->write, write);
+	iwb->write = write;
 	iwb->idle = c;
 
 	return isowbuf_donewrite(iwb);
@@ -947,8 +948,8 @@ void gigaset_isoc_input(struct inbuf_t *
 	unsigned tail, head, numbytes;
 	unsigned char *src;
 
-	head = atomic_read(&inbuf->head);
-	while (head != (tail = atomic_read(&inbuf->tail))) {
+	head = inbuf->head;
+	while (head != (tail = inbuf->tail)) {
 		gig_dbg(DEBUG_INTR, "buffer state: %u -> %u", head, tail);
 		if (head > tail)
 			tail = RBUFSIZE;
@@ -956,7 +957,7 @@ void gigaset_isoc_input(struct inbuf_t *
 		numbytes = tail - head;
 		gig_dbg(DEBUG_INTR, "processing %u bytes", numbytes);
 
-		if (atomic_read(&cs->mstate) == MS_LOCKED) {
+		if (cs->mstate == MS_LOCKED) {
 			gigaset_dbg_buffer(DEBUG_LOCKCMD, "received response",
 					   numbytes, src);
 			gigaset_if_receive(inbuf->cs, src, numbytes);
@@ -970,7 +971,7 @@ void gigaset_isoc_input(struct inbuf_t *
 		if (head == RBUFSIZE)
 			head = 0;
 		gig_dbg(DEBUG_INTR, "setting head to %u", head);
-		atomic_set(&inbuf->head, head);
+		inbuf->head = head;
 	}
 }
 
diff -puN drivers/isdn/gigaset/ser-gigaset.c~gigaset-atomic-cleanup drivers/isdn/gigaset/ser-gigaset.c
--- a/drivers/isdn/gigaset/ser-gigaset.c~gigaset-atomic-cleanup
+++ a/drivers/isdn/gigaset/ser-gigaset.c
@@ -240,7 +240,7 @@ static int gigaset_write_cmd(struct card
 	struct cmdbuf_t *cb;
 	unsigned long flags;
 
-	gigaset_dbg_buffer(atomic_read(&cs->mstate) != MS_LOCKED ?
+	gigaset_dbg_buffer(cs->mstate != MS_LOCKED ?
 	                     DEBUG_TRANSCMD : DEBUG_LOCKCMD,
 	                   "CMD Transmit", len, buf);
 
@@ -536,7 +536,7 @@ gigaset_tty_open(struct tty_struct *tty)
 	 * startup system and notify the LL that we are ready to run
 	 */
 	if (startmode == SM_LOCKED)
-		atomic_set(&cs->mstate, MS_LOCKED);
+		cs->mstate = MS_LOCKED;
 	if (!gigaset_start(cs)) {
 		tasklet_kill(&cs->write_tasklet);
 		goto error;
@@ -714,8 +714,8 @@ gigaset_tty_receive(struct tty_struct *t
 		return;
 	}
 
-	tail = atomic_read(&inbuf->tail);
-	head = atomic_read(&inbuf->head);
+	tail = inbuf->tail;
+	head = inbuf->head;
 	gig_dbg(DEBUG_INTR, "buffer state: %u -> %u, receive %u bytes",
 		head, tail, count);
 
@@ -742,7 +742,7 @@ gigaset_tty_receive(struct tty_struct *t
 	}
 
 	gig_dbg(DEBUG_INTR, "setting tail to %u", tail);
-	atomic_set(&inbuf->tail, tail);
+	inbuf->tail = tail;
 
 	/* Everything was received .. Push data into handler */
 	gig_dbg(DEBUG_INTR, "%s-->BH", __func__);
diff -puN drivers/isdn/gigaset/usb-gigaset.c~gigaset-atomic-cleanup drivers/isdn/gigaset/usb-gigaset.c
--- a/drivers/isdn/gigaset/usb-gigaset.c~gigaset-atomic-cleanup
+++ a/drivers/isdn/gigaset/usb-gigaset.c
@@ -133,7 +133,7 @@ static struct usb_driver gigaset_usb_dri
 struct usb_cardstate {
 	struct usb_device	*udev;		/* usb device pointer */
 	struct usb_interface	*interface;	/* interface for this device */
-	atomic_t		busy;		/* bulk output in progress */
+	int			busy;		/* bulk output in progress */
 
 	/* Output buffer */
 	unsigned char		*bulk_out_buffer;
@@ -325,7 +325,7 @@ static void gigaset_modem_fill(unsigned 
 
 	gig_dbg(DEBUG_OUTPUT, "modem_fill");
 
-	if (atomic_read(&cs->hw.usb->busy)) {
+	if (cs->hw.usb->busy) {
 		gig_dbg(DEBUG_OUTPUT, "modem_fill: busy");
 		return;
 	}
@@ -430,7 +430,7 @@ static void gigaset_write_bulk_callback(
 		break;
 	case -ENOENT:		/* killed */
 		gig_dbg(DEBUG_ANY, "%s: killed", __func__);
-		atomic_set(&cs->hw.usb->busy, 0);
+		cs->hw.usb->busy = 0;
 		return;
 	default:
 		dev_err(cs->dev, "bulk transfer failed (status %d)\n",
@@ -443,7 +443,7 @@ static void gigaset_write_bulk_callback(
 	if (!cs->connected) {
 		err("%s: not connected", __func__);
 	} else {
-		atomic_set(&cs->hw.usb->busy, 0);
+		cs->hw.usb->busy = 0;
 		tasklet_schedule(&cs->write_tasklet);
 	}
 	spin_unlock_irqrestore(&cs->lock, flags);
@@ -491,14 +491,14 @@ static int send_cb(struct cardstate *cs,
 
 			cb->offset += count;
 			cb->len -= count;
-			atomic_set(&ucs->busy, 1);
+			ucs->busy = 1;
 
 			spin_lock_irqsave(&cs->lock, flags);
 			status = cs->connected ? usb_submit_urb(ucs->bulk_out_urb, GFP_ATOMIC) : -ENODEV;
 			spin_unlock_irqrestore(&cs->lock, flags);
 
 			if (status) {
-				atomic_set(&ucs->busy, 0);
+				ucs->busy = 0;
 				err("could not submit urb (error %d)\n",
 				    -status);
 				cb->len = 0; /* skip urb => remove cb+wakeup
@@ -517,7 +517,7 @@ static int gigaset_write_cmd(struct card
 	struct cmdbuf_t *cb;
 	unsigned long flags;
 
-	gigaset_dbg_buffer(atomic_read(&cs->mstate) != MS_LOCKED ?
+	gigaset_dbg_buffer(cs->mstate != MS_LOCKED ?
 			     DEBUG_TRANSCMD : DEBUG_LOCKCMD,
 			   "CMD Transmit", len, buf);
 
@@ -654,7 +654,7 @@ static int write_modem(struct cardstate 
 	count = min(bcs->tx_skb->len, (unsigned) ucs->bulk_out_size);
 	skb_copy_from_linear_data(bcs->tx_skb, ucs->bulk_out_buffer, count);
 	skb_pull(bcs->tx_skb, count);
-	atomic_set(&ucs->busy, 1);
+	ucs->busy = 1;
 	gig_dbg(DEBUG_OUTPUT, "write_modem: send %d bytes", count);
 
 	spin_lock_irqsave(&cs->lock, flags);
@@ -672,7 +672,7 @@ static int write_modem(struct cardstate 
 
 	if (ret) {
 		err("could not submit urb (error %d)\n", -ret);
-		atomic_set(&ucs->busy, 0);
+		ucs->busy = 0;
 	}
 
 	if (!bcs->tx_skb->len) {
@@ -764,7 +764,7 @@ static int gigaset_probe(struct usb_inte
 
 	endpoint = &hostif->endpoint[1].desc;
 
-	atomic_set(&ucs->busy, 0);
+	ucs->busy = 0;
 
 	ucs->read_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!ucs->read_urb) {
@@ -797,7 +797,7 @@ static int gigaset_probe(struct usb_inte
 
 	/* tell common part that the device is ready */
 	if (startmode == SM_LOCKED)
-		atomic_set(&cs->mstate, MS_LOCKED);
+		cs->mstate = MS_LOCKED;
 
 	if (!gigaset_start(cs)) {
 		tasklet_kill(&cs->write_tasklet);
_

Patches currently in -mm which might be from tilman@imap.cc are

gigaset-clean-up-urb-status-usage.patch
gigaset-code-cleanups.patch
bas_gigaset-suspend-support-v2.patch
usb_gigaset-suspend-support-v3.patch
gigaset-atomic-cleanup.patch
