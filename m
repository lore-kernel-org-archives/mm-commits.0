From: akpm@linux-foundation.org
Subject: + gigaset-clean-up-urb-status-usage.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:50:41 -0800
Message-ID: <200711152250.lAFMof68019968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934106AbXKOWus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:50:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, gregkh@suse.de, hjlipp@web.de, kkeil@suse.de


The patch titled
     gigaset: clean up urb->status usage
has been added to the -mm tree.  Its filename is
     gigaset-clean-up-urb-status-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gigaset: clean up urb->status usage
From: Tilman Schmidt <tilman@imap.cc>

Make there only be one reference to urb->status per URB callback, and none
outside, in preparation for removal of that field.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <gregkh@suse.de>
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/bas-gigaset.c |   84 +++++++++++++++------------
 drivers/isdn/gigaset/gigaset.h     |    3 
 drivers/isdn/gigaset/usb-gigaset.c |   12 ++-
 3 files changed, 58 insertions(+), 41 deletions(-)

diff -puN drivers/isdn/gigaset/bas-gigaset.c~gigaset-clean-up-urb-status-usage drivers/isdn/gigaset/bas-gigaset.c
--- a/drivers/isdn/gigaset/bas-gigaset.c~gigaset-clean-up-urb-status-usage
+++ a/drivers/isdn/gigaset/bas-gigaset.c
@@ -248,12 +248,12 @@ static inline void dump_urb(enum debugle
 	if (urb) {
 		gig_dbg(level,
 			"  dev=0x%08lx, pipe=%s:EP%d/DV%d:%s, "
-			"status=%d, hcpriv=0x%08lx, transfer_flags=0x%x,",
+			"hcpriv=0x%08lx, transfer_flags=0x%x,",
 			(unsigned long) urb->dev,
 			usb_pipetype_str(urb->pipe),
 			usb_pipeendpoint(urb->pipe), usb_pipedevice(urb->pipe),
 			usb_pipein(urb->pipe) ? "in" : "out",
-			urb->status, (unsigned long) urb->hcpriv,
+			(unsigned long) urb->hcpriv,
 			urb->transfer_flags);
 		gig_dbg(level,
 			"  transfer_buffer=0x%08lx[%d], actual_length=%d, "
@@ -459,6 +459,7 @@ static void read_ctrl_callback(struct ur
 	struct inbuf_t *inbuf = urb->context;
 	struct cardstate *cs = inbuf->cs;
 	struct bas_cardstate *ucs = cs->hw.bas;
+	int status = urb->status;
 	int have_data = 0;
 	unsigned numbytes;
 	int rc;
@@ -472,7 +473,7 @@ static void read_ctrl_callback(struct ur
 
 	del_timer(&ucs->timer_cmd_in);
 
-	switch (urb->status) {
+	switch (status) {
 	case 0:				/* normal completion */
 		numbytes = urb->actual_length;
 		if (unlikely(numbytes != ucs->rcvbuf_size)) {
@@ -506,12 +507,12 @@ static void read_ctrl_callback(struct ur
 	case -ESHUTDOWN:		/* device shut down */
 		/* no action necessary */
 		gig_dbg(DEBUG_USBREQ, "%s: %s",
-			__func__, get_usb_statmsg(urb->status));
+			__func__, get_usb_statmsg(status));
 		break;
 
 	default:			/* severe trouble */
 		dev_warn(cs->dev, "control read: %s\n",
-			 get_usb_statmsg(urb->status));
+			 get_usb_statmsg(status));
 		if (ucs->retry_cmd_in++ < BAS_RETRY) {
 			dev_notice(cs->dev, "control read: retry %d\n",
 				   ucs->retry_cmd_in);
@@ -601,12 +602,13 @@ static void read_int_callback(struct urb
 	struct cardstate *cs = urb->context;
 	struct bas_cardstate *ucs = cs->hw.bas;
 	struct bc_state *bcs;
+	int status = urb->status;
 	unsigned long flags;
 	int rc;
 	unsigned l;
 	int channel;
 
-	switch (urb->status) {
+	switch (status) {
 	case 0:			/* success */
 		break;
 	case -ENOENT:			/* cancelled */
@@ -614,7 +616,7 @@ static void read_int_callback(struct urb
 	case -EINPROGRESS:		/* pending */
 		/* ignore silently */
 		gig_dbg(DEBUG_USBREQ, "%s: %s",
-			__func__, get_usb_statmsg(urb->status));
+			__func__, get_usb_statmsg(status));
 		return;
 	case -ENODEV:			/* device removed */
 	case -ESHUTDOWN:		/* device shut down */
@@ -623,7 +625,7 @@ static void read_int_callback(struct urb
 		return;
 	default:		/* severe trouble */
 		dev_warn(cs->dev, "interrupt read: %s\n",
-			 get_usb_statmsg(urb->status));
+			 get_usb_statmsg(status));
 		//FIXME corrective action? resubmission always ok?
 		goto resubmit;
 	}
@@ -766,17 +768,18 @@ static void read_iso_callback(struct urb
 {
 	struct bc_state *bcs;
 	struct bas_bc_state *ubc;
+	int status = urb->status;
 	unsigned long flags;
 	int i, rc;
 
 	/* status codes not worth bothering the tasklet with */
-	if (unlikely(urb->status == -ENOENT ||
-		     urb->status == -ECONNRESET ||
-		     urb->status == -EINPROGRESS ||
-		     urb->status == -ENODEV ||
-		     urb->status == -ESHUTDOWN)) {
+	if (unlikely(status == -ENOENT ||
+		     status == -ECONNRESET ||
+		     status == -EINPROGRESS ||
+		     status == -ENODEV ||
+		     status == -ESHUTDOWN)) {
 		gig_dbg(DEBUG_ISO, "%s: %s",
-			__func__, get_usb_statmsg(urb->status));
+			__func__, get_usb_statmsg(status));
 		return;
 	}
 
@@ -787,10 +790,11 @@ static void read_iso_callback(struct urb
 	if (likely(ubc->isoindone == NULL)) {
 		/* pass URB to tasklet */
 		ubc->isoindone = urb;
+		ubc->isoinstatus = status;
 		tasklet_schedule(&ubc->rcvd_tasklet);
 	} else {
 		/* tasklet still busy, drop data and resubmit URB */
-		ubc->loststatus = urb->status;
+		ubc->loststatus = status;
 		for (i = 0; i < BAS_NUMFRAMES; i++) {
 			ubc->isoinlost += urb->iso_frame_desc[i].actual_length;
 			if (unlikely(urb->iso_frame_desc[i].status != 0 &&
@@ -831,22 +835,24 @@ static void write_iso_callback(struct ur
 {
 	struct isow_urbctx_t *ucx;
 	struct bas_bc_state *ubc;
+	int status = urb->status;
 	unsigned long flags;
 
 	/* status codes not worth bothering the tasklet with */
-	if (unlikely(urb->status == -ENOENT ||
-		     urb->status == -ECONNRESET ||
-		     urb->status == -EINPROGRESS ||
-		     urb->status == -ENODEV ||
-		     urb->status == -ESHUTDOWN)) {
+	if (unlikely(status == -ENOENT ||
+		     status == -ECONNRESET ||
+		     status == -EINPROGRESS ||
+		     status == -ENODEV ||
+		     status == -ESHUTDOWN)) {
 		gig_dbg(DEBUG_ISO, "%s: %s",
-			__func__, get_usb_statmsg(urb->status));
+			__func__, get_usb_statmsg(status));
 		return;
 	}
 
 	/* pass URB context to tasklet */
 	ucx = urb->context;
 	ubc = ucx->bcs->hw.bas;
+	ucx->status = status;
 
 	spin_lock_irqsave(&ubc->isooutlock, flags);
 	ubc->isooutovfl = ubc->isooutdone;
@@ -1070,6 +1076,7 @@ static void write_iso_tasklet(unsigned l
 	struct cardstate *cs = bcs->cs;
 	struct isow_urbctx_t *done, *next, *ovfl;
 	struct urb *urb;
+	int status;
 	struct usb_iso_packet_descriptor *ifd;
 	int offset;
 	unsigned long flags;
@@ -1126,7 +1133,8 @@ static void write_iso_tasklet(unsigned l
 
 		/* process completed URB */
 		urb = done->urb;
-		switch (urb->status) {
+		status = done->status;
+		switch (status) {
 		case -EXDEV:			/* partial completion */
 			gig_dbg(DEBUG_ISO, "%s: URB partially completed",
 				__func__);
@@ -1179,7 +1187,7 @@ static void write_iso_tasklet(unsigned l
 			break;
 		default:			/* severe trouble */
 			dev_warn(cs->dev, "isochronous write: %s\n",
-				 get_usb_statmsg(urb->status));
+				 get_usb_statmsg(status));
 		}
 
 		/* mark the write buffer area covered by this URB as free */
@@ -1233,6 +1241,7 @@ static void read_iso_tasklet(unsigned lo
 	struct bas_bc_state *ubc = bcs->hw.bas;
 	struct cardstate *cs = bcs->cs;
 	struct urb *urb;
+	int status;
 	char *rcvbuf;
 	unsigned long flags;
 	int totleft, numbytes, offset, frame, rc;
@@ -1245,6 +1254,7 @@ static void read_iso_tasklet(unsigned lo
 			spin_unlock_irqrestore(&ubc->isoinlock, flags);
 			return;
 		}
+		status = ubc->isoinstatus;
 		ubc->isoindone = NULL;
 		if (unlikely(ubc->loststatus != -EINPROGRESS)) {
 			dev_warn(cs->dev,
@@ -1260,11 +1270,11 @@ static void read_iso_tasklet(unsigned lo
 			gig_dbg(DEBUG_ISO,
 				"%s: channel not running, "
 				"dropped URB with status: %s",
-				__func__, get_usb_statmsg(urb->status));
+				__func__, get_usb_statmsg(status));
 			return;
 		}
 
-		switch (urb->status) {
+		switch (status) {
 		case 0:				/* normal completion */
 			break;
 		case -EXDEV:			/* inspect individual frames
@@ -1276,7 +1286,7 @@ static void read_iso_tasklet(unsigned lo
 		case -ECONNRESET:
 		case -EINPROGRESS:
 			gig_dbg(DEBUG_ISO, "%s: %s",
-				__func__, get_usb_statmsg(urb->status));
+				__func__, get_usb_statmsg(status));
 			continue;		/* -> skip */
 		case -EPIPE:
 			dev_err(cs->dev, "isochronous read stalled\n");
@@ -1284,7 +1294,7 @@ static void read_iso_tasklet(unsigned lo
 			continue;		/* -> skip */
 		default:			/* severe trouble */
 			dev_warn(cs->dev, "isochronous read: %s\n",
-				 get_usb_statmsg(urb->status));
+				 get_usb_statmsg(status));
 			goto error;
 		}
 
@@ -1418,11 +1428,12 @@ static void req_timeout(unsigned long da
 static void write_ctrl_callback(struct urb *urb)
 {
 	struct bas_cardstate *ucs = urb->context;
+	int status = urb->status;
 	int rc;
 	unsigned long flags;
 
 	/* check status */
-	switch (urb->status) {
+	switch (status) {
 	case 0:					/* normal completion */
 		spin_lock_irqsave(&ucs->lock, flags);
 		switch (ucs->pending) {
@@ -1441,7 +1452,7 @@ static void write_ctrl_callback(struct u
 	case -ESHUTDOWN:		/* device shut down */
 		/* ignore silently */
 		gig_dbg(DEBUG_USBREQ, "%s: %s",
-			__func__, get_usb_statmsg(urb->status));
+			__func__, get_usb_statmsg(status));
 		break;
 
 	default:				/* any failure */
@@ -1449,12 +1460,12 @@ static void write_ctrl_callback(struct u
 			dev_err(&ucs->interface->dev,
 				"control request 0x%02x failed: %s\n",
 				ucs->dr_ctrl.bRequest,
-				get_usb_statmsg(urb->status));
+				get_usb_statmsg(status));
 			break;		/* give up */
 		}
 		dev_notice(&ucs->interface->dev,
 			   "control request 0x%02x: %s, retry %d\n",
-			   ucs->dr_ctrl.bRequest, get_usb_statmsg(urb->status),
+			   ucs->dr_ctrl.bRequest, get_usb_statmsg(status),
 			   ucs->retry_ctrl);
 		/* urb->dev is clobbered by USB subsystem */
 		urb->dev = ucs->udev;
@@ -1665,12 +1676,13 @@ static void write_command_callback(struc
 {
 	struct cardstate *cs = urb->context;
 	struct bas_cardstate *ucs = cs->hw.bas;
+	int status = urb->status;
 	unsigned long flags;
 
 	update_basstate(ucs, 0, BS_ATWRPEND);
 
 	/* check status */
-	switch (urb->status) {
+	switch (status) {
 	case 0:					/* normal completion */
 		break;
 	case -ENOENT:			/* cancelled */
@@ -1680,14 +1692,14 @@ static void write_command_callback(struc
 	case -ESHUTDOWN:		/* device shut down */
 		/* ignore silently */
 		gig_dbg(DEBUG_USBREQ, "%s: %s",
-			__func__, get_usb_statmsg(urb->status));
+			__func__, get_usb_statmsg(status));
 		return;
 	default:				/* any failure */
 		if (++ucs->retry_cmd_out > BAS_RETRY) {
 			dev_warn(cs->dev,
 				 "command write: %s, "
 				 "giving up after %d retries\n",
-				 get_usb_statmsg(urb->status),
+				 get_usb_statmsg(status),
 				 ucs->retry_cmd_out);
 			break;
 		}
@@ -1695,11 +1707,11 @@ static void write_command_callback(struc
 			dev_warn(cs->dev,
 				 "command write: %s, "
 				 "cannot retry - cmdbuf gone\n",
-				 get_usb_statmsg(urb->status));
+				 get_usb_statmsg(status));
 			break;
 		}
 		dev_notice(cs->dev, "command write: %s, retry %d\n",
-			   get_usb_statmsg(urb->status), ucs->retry_cmd_out);
+			   get_usb_statmsg(status), ucs->retry_cmd_out);
 		if (atwrite_submit(cs, cs->cmdbuf->buf, cs->cmdbuf->len) >= 0)
 			/* resubmitted - bypass regular exit block */
 			return;
diff -puN drivers/isdn/gigaset/gigaset.h~gigaset-clean-up-urb-status-usage drivers/isdn/gigaset/gigaset.h
--- a/drivers/isdn/gigaset/gigaset.h~gigaset-clean-up-urb-status-usage
+++ a/drivers/isdn/gigaset/gigaset.h
@@ -356,11 +356,13 @@ struct isowbuf_t {
  * - urb: pointer to the URB itself
  * - bcs: pointer to the B Channel control structure
  * - limit: end of write buffer area covered by this URB
+ * - status: URB completion status
  */
 struct isow_urbctx_t {
 	struct urb *urb;
 	struct bc_state *bcs;
 	int limit;
+	int status;
 };
 
 /* AT state structure
@@ -580,6 +582,7 @@ struct bas_bc_state {
 	struct urb *isoinurbs[BAS_INURBS];
 	unsigned char isoinbuf[BAS_INBUFSIZE * BAS_INURBS];
 	struct urb *isoindone;		/* completed isoc read URB */
+	int isoinstatus;		/* status of completed URB */
 	int loststatus;			/* status of dropped URB */
 	unsigned isoinlost;		/* number of bytes lost */
 	/* state of bit unstuffing algorithm
diff -puN drivers/isdn/gigaset/usb-gigaset.c~gigaset-clean-up-urb-status-usage drivers/isdn/gigaset/usb-gigaset.c
--- a/drivers/isdn/gigaset/usb-gigaset.c~gigaset-clean-up-urb-status-usage
+++ a/drivers/isdn/gigaset/usb-gigaset.c
@@ -361,13 +361,14 @@ static void gigaset_read_int_callback(st
 {
 	struct inbuf_t *inbuf = urb->context;
 	struct cardstate *cs = inbuf->cs;
+	int status = urb->status;
 	int resubmit = 0;
 	int r;
 	unsigned numbytes;
 	unsigned char *src;
 	unsigned long flags;
 
-	if (!urb->status) {
+	if (!status) {
 		if (!cs->connected) {
 			err("%s: disconnected", __func__); /* should never happen */
 			return;
@@ -393,8 +394,8 @@ static void gigaset_read_int_callback(st
 	} else {
 		/* The urb might have been killed. */
 		gig_dbg(DEBUG_ANY, "%s - nonzero read bulk status received: %d",
-			__func__, urb->status);
-		if (urb->status != -ENOENT) { /* not killed */
+			__func__, status);
+		if (status != -ENOENT) { /* not killed */
 			if (!cs->connected) {
 				err("%s: disconnected", __func__); /* should never happen */
 				return;
@@ -418,11 +419,12 @@ static void gigaset_read_int_callback(st
 static void gigaset_write_bulk_callback(struct urb *urb)
 {
 	struct cardstate *cs = urb->context;
+	int status = urb->status;
 	unsigned long flags;
 
-	if (urb->status)
+	if (status)
 		dev_err(cs->dev, "bulk transfer failed (status %d)\n",
-			-urb->status);
+			-status);
 		/* That's all we can do. Communication problems
 		   are handled by timeouts or network protocols. */
 
_

Patches currently in -mm which might be from tilman@imap.cc are

usb-power-managementtxt-disconnect-clarification.patch
gigaset-clean-up-urb-status-usage.patch
gigaset-code-cleanups.patch
bas_gigaset-suspend-support-v2.patch
usb_gigaset-suspend-support-v3.patch
