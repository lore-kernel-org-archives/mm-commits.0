From: akpm@osdl.org
Subject: - slab-remove-slab_atomic.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:13 -0800
Message-ID: <200612072258.kB7MwDWr029374@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50716 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163583AbWLGW6T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: remove SLAB_ATOMIC
has been removed from the -mm tree.  Its filename was
     slab-remove-slab_atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: remove SLAB_ATOMIC
From: Christoph Lameter <clameter@sgi.com>

SLAB_ATOMIC is an alias of GFP_ATOMIC

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/atm/he.c                        |    2 -
 drivers/base/dmapool.c                  |    2 -
 drivers/block/DAC960.c                  |    4 +-
 drivers/char/watchdog/pcwd_usb.c        |    2 -
 drivers/ieee1394/raw1394.c              |   30 +++++++++++-----------
 drivers/infiniband/hw/amso1100/c2_vq.c  |    2 -
 drivers/infiniband/hw/mthca/mthca_av.c  |    2 -
 drivers/isdn/gigaset/bas-gigaset.c      |   20 +++++++-------
 drivers/isdn/gigaset/usb-gigaset.c      |    6 ++--
 drivers/media/dvb/dvb-usb/usb-urb.c     |    2 -
 drivers/media/dvb/ttusb-dec/ttusb_dec.c |    2 -
 drivers/s390/scsi/zfcp_fsf.c            |    2 -
 drivers/usb/core/hub.c                  |    2 -
 drivers/usb/core/message.c              |    2 -
 drivers/usb/host/ehci-dbg.c             |    2 -
 drivers/usb/host/hc_crisv10.c           |   10 +++----
 drivers/usb/host/ohci-dbg.c             |    2 -
 drivers/usb/host/uhci-q.c               |    2 -
 drivers/usb/input/aiptek.c              |    2 -
 drivers/usb/input/ati_remote.c          |    6 ++--
 drivers/usb/input/hid-core.c            |   10 +++----
 drivers/usb/input/keyspan_remote.c      |    2 -
 drivers/usb/input/mtouchusb.c           |    2 -
 drivers/usb/input/powermate.c           |    4 +-
 drivers/usb/input/touchkitusb.c         |    2 -
 drivers/usb/input/usbkbd.c              |    8 ++---
 drivers/usb/input/usbmouse.c            |    4 +-
 drivers/usb/input/xpad.c                |    2 -
 drivers/usb/input/yealink.c             |    6 ++--
 drivers/usb/misc/phidgetkit.c           |    4 +-
 drivers/usb/misc/phidgetmotorcontrol.c  |    4 +-
 drivers/usb/misc/usbtest.c              |    8 ++---
 drivers/usb/mon/mon_text.c              |    4 +-
 drivers/usb/net/catc.c                  |    2 -
 drivers/usb/net/net1080.c               |    2 -
 drivers/usb/net/pegasus.c               |    2 -
 drivers/usb/net/rtl8150.c               |    2 -
 drivers/usb/serial/mos7720.c            |    2 -
 drivers/usb/serial/mos7840.c            |    4 +-
 drivers/usb/storage/onetouch.c          |    4 +-
 include/linux/slab.h                    |    1 
 include/net/request_sock.h              |    2 -
 net/core/dst.c                          |    2 -
 net/core/flow.c                         |    2 -
 net/core/neighbour.c                    |    2 -
 net/dccp/ccids/ccid3.c                  |    6 ++--
 net/dccp/ccids/lib/loss_interval.c      |    2 -
 net/ipv4/inet_hashtables.c              |    2 -
 net/ipv4/inet_timewait_sock.c           |    2 -
 net/ipv6/ip6_fib.c                      |    2 -
 net/ipv6/xfrm6_tunnel.c                 |    2 -
 net/sctp/sm_make_chunk.c                |    2 -
 net/sctp/socket.c                       |    2 -
 net/xfrm/xfrm_input.c                   |    2 -
 security/selinux/avc.c                  |    2 -
 55 files changed, 107 insertions(+), 108 deletions(-)

diff -puN drivers/atm/he.c~slab-remove-slab_atomic drivers/atm/he.c
--- a/drivers/atm/he.c~slab-remove-slab_atomic
+++ a/drivers/atm/he.c
@@ -1724,7 +1724,7 @@ __alloc_tpd(struct he_dev *he_dev)
 	struct he_tpd *tpd;
 	dma_addr_t dma_handle; 
 
-	tpd = pci_pool_alloc(he_dev->tpd_pool, SLAB_ATOMIC|SLAB_DMA, &dma_handle);              
+	tpd = pci_pool_alloc(he_dev->tpd_pool, GFP_ATOMIC|SLAB_DMA, &dma_handle);
 	if (tpd == NULL)
 		return NULL;
 			
diff -puN drivers/base/dmapool.c~slab-remove-slab_atomic drivers/base/dmapool.c
--- a/drivers/base/dmapool.c~slab-remove-slab_atomic
+++ a/drivers/base/dmapool.c
@@ -297,7 +297,7 @@ restart:
 			}
 		}
 	}
-	if (!(page = pool_alloc_page (pool, SLAB_ATOMIC))) {
+	if (!(page = pool_alloc_page (pool, GFP_ATOMIC))) {
 		if (mem_flags & __GFP_WAIT) {
 			DECLARE_WAITQUEUE (wait, current);
 
diff -puN drivers/block/DAC960.c~slab-remove-slab_atomic drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~slab-remove-slab_atomic
+++ a/drivers/block/DAC960.c
@@ -324,13 +324,13 @@ static boolean DAC960_CreateAuxiliaryStr
       Command->Next = Controller->FreeCommands;
       Controller->FreeCommands = Command;
       Controller->Commands[CommandIdentifier-1] = Command;
-      ScatterGatherCPU = pci_pool_alloc(ScatterGatherPool, SLAB_ATOMIC,
+      ScatterGatherCPU = pci_pool_alloc(ScatterGatherPool, GFP_ATOMIC,
 							&ScatterGatherDMA);
       if (ScatterGatherCPU == NULL)
 	  return DAC960_Failure(Controller, "AUXILIARY STRUCTURE CREATION");
 
       if (RequestSensePool != NULL) {
-  	  RequestSenseCPU = pci_pool_alloc(RequestSensePool, SLAB_ATOMIC,
+  	  RequestSenseCPU = pci_pool_alloc(RequestSensePool, GFP_ATOMIC,
 						&RequestSenseDMA);
   	  if (RequestSenseCPU == NULL) {
                 pci_pool_free(ScatterGatherPool, ScatterGatherCPU,
diff -puN drivers/char/watchdog/pcwd_usb.c~slab-remove-slab_atomic drivers/char/watchdog/pcwd_usb.c
--- a/drivers/char/watchdog/pcwd_usb.c~slab-remove-slab_atomic
+++ a/drivers/char/watchdog/pcwd_usb.c
@@ -634,7 +634,7 @@ static int usb_pcwd_probe(struct usb_int
 	usb_pcwd->intr_size = (le16_to_cpu(endpoint->wMaxPacketSize) > 8 ? le16_to_cpu(endpoint->wMaxPacketSize) : 8);
 
 	/* set up the memory buffer's */
-	if (!(usb_pcwd->intr_buffer = usb_buffer_alloc(udev, usb_pcwd->intr_size, SLAB_ATOMIC, &usb_pcwd->intr_dma))) {
+	if (!(usb_pcwd->intr_buffer = usb_buffer_alloc(udev, usb_pcwd->intr_size, GFP_ATOMIC, &usb_pcwd->intr_dma))) {
 		printk(KERN_ERR PFX "Out of memory\n");
 		goto error;
 	}
diff -puN drivers/ieee1394/raw1394.c~slab-remove-slab_atomic drivers/ieee1394/raw1394.c
--- a/drivers/ieee1394/raw1394.c~slab-remove-slab_atomic
+++ a/drivers/ieee1394/raw1394.c
@@ -259,7 +259,7 @@ static void host_reset(struct hpsb_host 
 	if (hi != NULL) {
 		list_for_each_entry(fi, &hi->file_info_list, list) {
 			if (fi->notification == RAW1394_NOTIFY_ON) {
-				req = __alloc_pending_request(SLAB_ATOMIC);
+				req = __alloc_pending_request(GFP_ATOMIC);
 
 				if (req != NULL) {
 					req->file_info = fi;
@@ -306,13 +306,13 @@ static void iso_receive(struct hpsb_host
 			if (!(fi->listen_channels & (1ULL << channel)))
 				continue;
 
-			req = __alloc_pending_request(SLAB_ATOMIC);
+			req = __alloc_pending_request(GFP_ATOMIC);
 			if (!req)
 				break;
 
 			if (!ibs) {
 				ibs = kmalloc(sizeof(*ibs) + length,
-					      SLAB_ATOMIC);
+					      GFP_ATOMIC);
 				if (!ibs) {
 					kfree(req);
 					break;
@@ -367,13 +367,13 @@ static void fcp_request(struct hpsb_host
 			if (!fi->fcp_buffer)
 				continue;
 
-			req = __alloc_pending_request(SLAB_ATOMIC);
+			req = __alloc_pending_request(GFP_ATOMIC);
 			if (!req)
 				break;
 
 			if (!ibs) {
 				ibs = kmalloc(sizeof(*ibs) + length,
-					      SLAB_ATOMIC);
+					      GFP_ATOMIC);
 				if (!ibs) {
 					kfree(req);
 					break;
@@ -593,7 +593,7 @@ static int state_initialized(struct file
 	switch (req->req.type) {
 	case RAW1394_REQ_LIST_CARDS:
 		spin_lock_irqsave(&host_info_lock, flags);
-		khl = kmalloc(sizeof(*khl) * host_count, SLAB_ATOMIC);
+		khl = kmalloc(sizeof(*khl) * host_count, GFP_ATOMIC);
 
 		if (khl) {
 			req->req.misc = host_count;
@@ -1045,7 +1045,7 @@ static int arm_read(struct hpsb_host *ho
 	}
 	if (arm_addr->notification_options & ARM_READ) {
 		DBGMSG("arm_read -> entering notification-section");
-		req = __alloc_pending_request(SLAB_ATOMIC);
+		req = __alloc_pending_request(GFP_ATOMIC);
 		if (!req) {
 			DBGMSG("arm_read -> rcode_conflict_error");
 			spin_unlock_irqrestore(&host_info_lock, irqflags);
@@ -1064,7 +1064,7 @@ static int arm_read(struct hpsb_host *ho
 			    sizeof(struct arm_response) +
 			    sizeof(struct arm_request_response);
 		}
-		req->data = kmalloc(size, SLAB_ATOMIC);
+		req->data = kmalloc(size, GFP_ATOMIC);
 		if (!(req->data)) {
 			free_pending_request(req);
 			DBGMSG("arm_read -> rcode_conflict_error");
@@ -1198,7 +1198,7 @@ static int arm_write(struct hpsb_host *h
 	}
 	if (arm_addr->notification_options & ARM_WRITE) {
 		DBGMSG("arm_write -> entering notification-section");
-		req = __alloc_pending_request(SLAB_ATOMIC);
+		req = __alloc_pending_request(GFP_ATOMIC);
 		if (!req) {
 			DBGMSG("arm_write -> rcode_conflict_error");
 			spin_unlock_irqrestore(&host_info_lock, irqflags);
@@ -1209,7 +1209,7 @@ static int arm_write(struct hpsb_host *h
 		    sizeof(struct arm_request) + sizeof(struct arm_response) +
 		    (length) * sizeof(byte_t) +
 		    sizeof(struct arm_request_response);
-		req->data = kmalloc(size, SLAB_ATOMIC);
+		req->data = kmalloc(size, GFP_ATOMIC);
 		if (!(req->data)) {
 			free_pending_request(req);
 			DBGMSG("arm_write -> rcode_conflict_error");
@@ -1400,7 +1400,7 @@ static int arm_lock(struct hpsb_host *ho
 	if (arm_addr->notification_options & ARM_LOCK) {
 		byte_t *buf1, *buf2;
 		DBGMSG("arm_lock -> entering notification-section");
-		req = __alloc_pending_request(SLAB_ATOMIC);
+		req = __alloc_pending_request(GFP_ATOMIC);
 		if (!req) {
 			DBGMSG("arm_lock -> rcode_conflict_error");
 			spin_unlock_irqrestore(&host_info_lock, irqflags);
@@ -1408,7 +1408,7 @@ static int arm_lock(struct hpsb_host *ho
 							   The request may be retried */
 		}
 		size = sizeof(struct arm_request) + sizeof(struct arm_response) + 3 * sizeof(*store) + sizeof(struct arm_request_response);	/* maximum */
-		req->data = kmalloc(size, SLAB_ATOMIC);
+		req->data = kmalloc(size, GFP_ATOMIC);
 		if (!(req->data)) {
 			free_pending_request(req);
 			DBGMSG("arm_lock -> rcode_conflict_error");
@@ -1628,7 +1628,7 @@ static int arm_lock64(struct hpsb_host *
 	if (arm_addr->notification_options & ARM_LOCK) {
 		byte_t *buf1, *buf2;
 		DBGMSG("arm_lock64 -> entering notification-section");
-		req = __alloc_pending_request(SLAB_ATOMIC);
+		req = __alloc_pending_request(GFP_ATOMIC);
 		if (!req) {
 			spin_unlock_irqrestore(&host_info_lock, irqflags);
 			DBGMSG("arm_lock64 -> rcode_conflict_error");
@@ -1636,7 +1636,7 @@ static int arm_lock64(struct hpsb_host *
 							   The request may be retried */
 		}
 		size = sizeof(struct arm_request) + sizeof(struct arm_response) + 3 * sizeof(*store) + sizeof(struct arm_request_response);	/* maximum */
-		req->data = kmalloc(size, SLAB_ATOMIC);
+		req->data = kmalloc(size, GFP_ATOMIC);
 		if (!(req->data)) {
 			free_pending_request(req);
 			spin_unlock_irqrestore(&host_info_lock, irqflags);
@@ -2443,7 +2443,7 @@ static void queue_rawiso_event(struct fi
 	/* only one ISO activity event may be in the queue */
 	if (!__rawiso_event_in_queue(fi)) {
 		struct pending_request *req =
-		    __alloc_pending_request(SLAB_ATOMIC);
+		    __alloc_pending_request(GFP_ATOMIC);
 
 		if (req) {
 			req->file_info = fi;
diff -puN drivers/infiniband/hw/amso1100/c2_vq.c~slab-remove-slab_atomic drivers/infiniband/hw/amso1100/c2_vq.c
--- a/drivers/infiniband/hw/amso1100/c2_vq.c~slab-remove-slab_atomic
+++ a/drivers/infiniband/hw/amso1100/c2_vq.c
@@ -164,7 +164,7 @@ void vq_req_put(struct c2_dev *c2dev, st
  */
 void *vq_repbuf_alloc(struct c2_dev *c2dev)
 {
-	return kmem_cache_alloc(c2dev->host_msg_cache, SLAB_ATOMIC);
+	return kmem_cache_alloc(c2dev->host_msg_cache, GFP_ATOMIC);
 }
 
 /*
diff -puN drivers/infiniband/hw/mthca/mthca_av.c~slab-remove-slab_atomic drivers/infiniband/hw/mthca/mthca_av.c
--- a/drivers/infiniband/hw/mthca/mthca_av.c~slab-remove-slab_atomic
+++ a/drivers/infiniband/hw/mthca/mthca_av.c
@@ -189,7 +189,7 @@ int mthca_create_ah(struct mthca_dev *de
 on_hca_fail:
 	if (ah->type == MTHCA_AH_PCI_POOL) {
 		ah->av = pci_pool_alloc(dev->av_table.pool,
-					SLAB_ATOMIC, &ah->avdma);
+					GFP_ATOMIC, &ah->avdma);
 		if (!ah->av)
 			return -ENOMEM;
 
diff -puN drivers/isdn/gigaset/bas-gigaset.c~slab-remove-slab_atomic drivers/isdn/gigaset/bas-gigaset.c
--- a/drivers/isdn/gigaset/bas-gigaset.c~slab-remove-slab_atomic
+++ a/drivers/isdn/gigaset/bas-gigaset.c
@@ -572,7 +572,7 @@ static int atread_submit(struct cardstat
 			     ucs->rcvbuf, ucs->rcvbuf_size,
 			     read_ctrl_callback, cs->inbuf);
 
-	if ((ret = usb_submit_urb(ucs->urb_cmd_in, SLAB_ATOMIC)) != 0) {
+	if ((ret = usb_submit_urb(ucs->urb_cmd_in, GFP_ATOMIC)) != 0) {
 		update_basstate(ucs, 0, BS_ATRDPEND);
 		dev_err(cs->dev, "could not submit HD_READ_ATMESSAGE: %s\n",
 			get_usb_rcmsg(ret));
@@ -747,7 +747,7 @@ static void read_int_callback(struct urb
 	check_pending(ucs);
 
 resubmit:
-	rc = usb_submit_urb(urb, SLAB_ATOMIC);
+	rc = usb_submit_urb(urb, GFP_ATOMIC);
 	if (unlikely(rc != 0 && rc != -ENODEV)) {
 		dev_err(cs->dev, "could not resubmit interrupt URB: %s\n",
 			get_usb_rcmsg(rc));
@@ -807,7 +807,7 @@ static void read_iso_callback(struct urb
 			urb->number_of_packets = BAS_NUMFRAMES;
 			gig_dbg(DEBUG_ISO, "%s: isoc read overrun/resubmit",
 				__func__);
-			rc = usb_submit_urb(urb, SLAB_ATOMIC);
+			rc = usb_submit_urb(urb, GFP_ATOMIC);
 			if (unlikely(rc != 0 && rc != -ENODEV)) {
 				dev_err(bcs->cs->dev,
 					"could not resubmit isochronous read "
@@ -900,7 +900,7 @@ static int starturbs(struct bc_state *bc
 		}
 
 		dump_urb(DEBUG_ISO, "Initial isoc read", urb);
-		if ((rc = usb_submit_urb(urb, SLAB_ATOMIC)) != 0)
+		if ((rc = usb_submit_urb(urb, GFP_ATOMIC)) != 0)
 			goto error;
 	}
 
@@ -935,7 +935,7 @@ static int starturbs(struct bc_state *bc
 	/* submit two URBs, keep third one */
 	for (k = 0; k < 2; ++k) {
 		dump_urb(DEBUG_ISO, "Initial isoc write", urb);
-		rc = usb_submit_urb(ubc->isoouturbs[k].urb, SLAB_ATOMIC);
+		rc = usb_submit_urb(ubc->isoouturbs[k].urb, GFP_ATOMIC);
 		if (rc != 0)
 			goto error;
 	}
@@ -1042,7 +1042,7 @@ static int submit_iso_write_urb(struct i
 		return 0;	/* no data to send */
 	urb->number_of_packets = nframe;
 
-	rc = usb_submit_urb(urb, SLAB_ATOMIC);
+	rc = usb_submit_urb(urb, GFP_ATOMIC);
 	if (unlikely(rc)) {
 		if (rc == -ENODEV)
 			/* device removed - give up silently */
@@ -1341,7 +1341,7 @@ static void read_iso_tasklet(unsigned lo
 		urb->dev = bcs->cs->hw.bas->udev;
 		urb->transfer_flags = URB_ISO_ASAP;
 		urb->number_of_packets = BAS_NUMFRAMES;
-		rc = usb_submit_urb(urb, SLAB_ATOMIC);
+		rc = usb_submit_urb(urb, GFP_ATOMIC);
 		if (unlikely(rc != 0 && rc != -ENODEV)) {
 			dev_err(cs->dev,
 				"could not resubmit isochronous read URB: %s\n",
@@ -1458,7 +1458,7 @@ static void write_ctrl_callback(struct u
 			   ucs->retry_ctrl);
 		/* urb->dev is clobbered by USB subsystem */
 		urb->dev = ucs->udev;
-		rc = usb_submit_urb(urb, SLAB_ATOMIC);
+		rc = usb_submit_urb(urb, GFP_ATOMIC);
 		if (unlikely(rc)) {
 			dev_err(&ucs->interface->dev,
 				"could not resubmit request 0x%02x: %s\n",
@@ -1517,7 +1517,7 @@ static int req_submit(struct bc_state *b
 			     (unsigned char*) &ucs->dr_ctrl, NULL, 0,
 			     write_ctrl_callback, ucs);
 	ucs->retry_ctrl = 0;
-	ret = usb_submit_urb(ucs->urb_ctrl, SLAB_ATOMIC);
+	ret = usb_submit_urb(ucs->urb_ctrl, GFP_ATOMIC);
 	if (unlikely(ret)) {
 		dev_err(bcs->cs->dev, "could not submit request 0x%02x: %s\n",
 			req, get_usb_rcmsg(ret));
@@ -1763,7 +1763,7 @@ static int atwrite_submit(struct cardsta
 			     usb_sndctrlpipe(ucs->udev, 0),
 			     (unsigned char*) &ucs->dr_cmd_out, buf, len,
 			     write_command_callback, cs);
-	rc = usb_submit_urb(ucs->urb_cmd_out, SLAB_ATOMIC);
+	rc = usb_submit_urb(ucs->urb_cmd_out, GFP_ATOMIC);
 	if (unlikely(rc)) {
 		update_basstate(ucs, 0, BS_ATWRPEND);
 		dev_err(cs->dev, "could not submit HD_WRITE_ATMESSAGE: %s\n",
diff -puN drivers/isdn/gigaset/usb-gigaset.c~slab-remove-slab_atomic drivers/isdn/gigaset/usb-gigaset.c
--- a/drivers/isdn/gigaset/usb-gigaset.c~slab-remove-slab_atomic
+++ a/drivers/isdn/gigaset/usb-gigaset.c
@@ -410,7 +410,7 @@ static void gigaset_read_int_callback(st
 
 	if (resubmit) {
 		spin_lock_irqsave(&cs->lock, flags);
-		r = cs->connected ? usb_submit_urb(urb, SLAB_ATOMIC) : -ENODEV;
+		r = cs->connected ? usb_submit_urb(urb, GFP_ATOMIC) : -ENODEV;
 		spin_unlock_irqrestore(&cs->lock, flags);
 		if (r)
 			dev_err(cs->dev, "error %d when resubmitting urb.\n",
@@ -486,7 +486,7 @@ static int send_cb(struct cardstate *cs,
 			atomic_set(&ucs->busy, 1);
 
 			spin_lock_irqsave(&cs->lock, flags);
-			status = cs->connected ? usb_submit_urb(ucs->bulk_out_urb, SLAB_ATOMIC) : -ENODEV;
+			status = cs->connected ? usb_submit_urb(ucs->bulk_out_urb, GFP_ATOMIC) : -ENODEV;
 			spin_unlock_irqrestore(&cs->lock, flags);
 
 			if (status) {
@@ -664,7 +664,7 @@ static int write_modem(struct cardstate 
 						  ucs->bulk_out_endpointAddr & 0x0f),
 				  ucs->bulk_out_buffer, count,
 				  gigaset_write_bulk_callback, cs);
-		ret = usb_submit_urb(ucs->bulk_out_urb, SLAB_ATOMIC);
+		ret = usb_submit_urb(ucs->bulk_out_urb, GFP_ATOMIC);
 	} else {
 		ret = -ENODEV;
 	}
diff -puN drivers/media/dvb/dvb-usb/usb-urb.c~slab-remove-slab_atomic drivers/media/dvb/dvb-usb/usb-urb.c
--- a/drivers/media/dvb/dvb-usb/usb-urb.c~slab-remove-slab_atomic
+++ a/drivers/media/dvb/dvb-usb/usb-urb.c
@@ -116,7 +116,7 @@ static int usb_allocate_stream_buffers(s
 	for (stream->buf_num = 0; stream->buf_num < num; stream->buf_num++) {
 		deb_mem("allocating buffer %d\n",stream->buf_num);
 		if (( stream->buf_list[stream->buf_num] =
-					usb_buffer_alloc(stream->udev, size, SLAB_ATOMIC,
+					usb_buffer_alloc(stream->udev, size, GFP_ATOMIC,
 					&stream->dma_addr[stream->buf_num]) ) == NULL) {
 			deb_mem("not enough memory for urb-buffer allocation.\n");
 			usb_free_stream_buffers(stream);
diff -puN drivers/media/dvb/ttusb-dec/ttusb_dec.c~slab-remove-slab_atomic drivers/media/dvb/ttusb-dec/ttusb_dec.c
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c~slab-remove-slab_atomic
+++ a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -1244,7 +1244,7 @@ static int ttusb_dec_init_usb(struct ttu
 			return -ENOMEM;
 		}
 		dec->irq_buffer = usb_buffer_alloc(dec->udev,IRQ_PACKET_SIZE,
-					SLAB_ATOMIC, &dec->irq_dma_handle);
+					GFP_ATOMIC, &dec->irq_dma_handle);
 		if(!dec->irq_buffer) {
 			return -ENOMEM;
 		}
diff -puN drivers/s390/scsi/zfcp_fsf.c~slab-remove-slab_atomic drivers/s390/scsi/zfcp_fsf.c
--- a/drivers/s390/scsi/zfcp_fsf.c~slab-remove-slab_atomic
+++ a/drivers/s390/scsi/zfcp_fsf.c
@@ -109,7 +109,7 @@ zfcp_fsf_req_alloc(mempool_t *pool, int 
 			ptr = kmalloc(size, GFP_ATOMIC);
 		else
 			ptr = kmem_cache_alloc(zfcp_data.fsf_req_qtcb_cache,
-					       SLAB_ATOMIC);
+					       GFP_ATOMIC);
 	}
 
 	if (unlikely(!ptr))
diff -puN drivers/usb/core/hub.c~slab-remove-slab_atomic drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~slab-remove-slab_atomic
+++ a/drivers/usb/core/hub.c
@@ -460,7 +460,7 @@ void usb_hub_tt_clear_buffer (struct usb
 	 * since each TT has "at least two" buffers that can need it (and
 	 * there can be many TTs per hub).  even if they're uncommon.
 	 */
-	if ((clear = kmalloc (sizeof *clear, SLAB_ATOMIC)) == NULL) {
+	if ((clear = kmalloc (sizeof *clear, GFP_ATOMIC)) == NULL) {
 		dev_err (&udev->dev, "can't save CLEAR_TT_BUFFER state\n");
 		/* FIXME recover somehow ... RESET_TT? */
 		return;
diff -puN drivers/usb/core/message.c~slab-remove-slab_atomic drivers/usb/core/message.c
--- a/drivers/usb/core/message.c~slab-remove-slab_atomic
+++ a/drivers/usb/core/message.c
@@ -488,7 +488,7 @@ void usb_sg_wait (struct usb_sg_request 
 		int	retval;
 
 		io->urbs [i]->dev = io->dev;
-		retval = usb_submit_urb (io->urbs [i], SLAB_ATOMIC);
+		retval = usb_submit_urb (io->urbs [i], GFP_ATOMIC);
 
 		/* after we submit, let completions or cancelations fire;
 		 * we handshake using io->status.
diff -puN drivers/usb/host/ehci-dbg.c~slab-remove-slab_atomic drivers/usb/host/ehci-dbg.c
--- a/drivers/usb/host/ehci-dbg.c~slab-remove-slab_atomic
+++ a/drivers/usb/host/ehci-dbg.c
@@ -492,7 +492,7 @@ show_periodic (struct class_device *clas
 	unsigned		i;
 	__le32			tag;
 
-	if (!(seen = kmalloc (DBG_SCHED_LIMIT * sizeof *seen, SLAB_ATOMIC)))
+	if (!(seen = kmalloc (DBG_SCHED_LIMIT * sizeof *seen, GFP_ATOMIC)))
 		return 0;
 	seen_count = 0;
 
diff -puN drivers/usb/host/hc_crisv10.c~slab-remove-slab_atomic drivers/usb/host/hc_crisv10.c
--- a/drivers/usb/host/hc_crisv10.c~slab-remove-slab_atomic
+++ a/drivers/usb/host/hc_crisv10.c
@@ -188,7 +188,7 @@ static DEFINE_TIMER(bulk_eot_timer, NULL
 #define CHECK_ALIGN(x) if (((__u32)(x)) & 0x00000003) \
 {panic("Alignment check (DWORD) failed at %s:%s:%d\n", __FILE__, __FUNCTION__, __LINE__);}
 
-#define SLAB_FLAG     (in_interrupt() ? SLAB_ATOMIC : SLAB_KERNEL)
+#define SLAB_FLAG     (in_interrupt() ? GFP_ATOMIC : SLAB_KERNEL)
 #define KMALLOC_FLAG  (in_interrupt() ? GFP_ATOMIC : GFP_KERNEL)
 
 /* Most helpful debugging aid */
@@ -1743,7 +1743,7 @@ static irqreturn_t etrax_usb_tx_interrup
 
 		*R_DMA_CH8_SUB3_CLR_INTR = IO_STATE(R_DMA_CH8_SUB3_CLR_INTR, clr_descr, do);
 
-		comp_data = (usb_isoc_complete_data_t*)kmem_cache_alloc(isoc_compl_cache, SLAB_ATOMIC);
+		comp_data = (usb_isoc_complete_data_t*)kmem_cache_alloc(isoc_compl_cache, GFP_ATOMIC);
 		assert(comp_data != NULL);
 
                 INIT_WORK(&comp_data->usb_bh, etrax_usb_isoc_descr_interrupt_bottom_half, comp_data);
@@ -3010,7 +3010,7 @@ static void etrax_usb_add_to_isoc_sb_lis
 			if (!urb->iso_frame_desc[i].length)
 				continue;
 
-			next_sb_desc = (USB_SB_Desc_t*)kmem_cache_alloc(usb_desc_cache, SLAB_ATOMIC);
+			next_sb_desc = (USB_SB_Desc_t*)kmem_cache_alloc(usb_desc_cache, GFP_ATOMIC);
 			assert(next_sb_desc != NULL);
 
 			if (urb->iso_frame_desc[i].length > 0) {
@@ -3063,7 +3063,7 @@ static void etrax_usb_add_to_isoc_sb_lis
 		if (TxIsocEPList[epid].sub == 0) {
 			dbg_isoc("Isoc traffic not already running, allocating SB");
 
-			next_sb_desc = (USB_SB_Desc_t*)kmem_cache_alloc(usb_desc_cache, SLAB_ATOMIC);
+			next_sb_desc = (USB_SB_Desc_t*)kmem_cache_alloc(usb_desc_cache, GFP_ATOMIC);
 			assert(next_sb_desc != NULL);
 
 			next_sb_desc->command = (IO_STATE(USB_SB_command, tt, in) |
@@ -3317,7 +3317,7 @@ static irqreturn_t etrax_usb_hc_interrup
 
 	restore_flags(flags);
 
-	reg = (usb_interrupt_registers_t *)kmem_cache_alloc(top_half_reg_cache, SLAB_ATOMIC);
+	reg = (usb_interrupt_registers_t *)kmem_cache_alloc(top_half_reg_cache, GFP_ATOMIC);
 
 	assert(reg != NULL);
 
diff -puN drivers/usb/host/ohci-dbg.c~slab-remove-slab_atomic drivers/usb/host/ohci-dbg.c
--- a/drivers/usb/host/ohci-dbg.c~slab-remove-slab_atomic
+++ a/drivers/usb/host/ohci-dbg.c
@@ -505,7 +505,7 @@ show_periodic (struct class_device *clas
 	char			*next;
 	unsigned		i;
 
-	if (!(seen = kmalloc (DBG_SCHED_LIMIT * sizeof *seen, SLAB_ATOMIC)))
+	if (!(seen = kmalloc (DBG_SCHED_LIMIT * sizeof *seen, GFP_ATOMIC)))
 		return 0;
 	seen_count = 0;
 
diff -puN drivers/usb/host/uhci-q.c~slab-remove-slab_atomic drivers/usb/host/uhci-q.c
--- a/drivers/usb/host/uhci-q.c~slab-remove-slab_atomic
+++ a/drivers/usb/host/uhci-q.c
@@ -498,7 +498,7 @@ static inline struct urb_priv *uhci_allo
 {
 	struct urb_priv *urbp;
 
-	urbp = kmem_cache_alloc(uhci_up_cachep, SLAB_ATOMIC);
+	urbp = kmem_cache_alloc(uhci_up_cachep, GFP_ATOMIC);
 	if (!urbp)
 		return NULL;
 
diff -puN drivers/usb/input/aiptek.c~slab-remove-slab_atomic drivers/usb/input/aiptek.c
--- a/drivers/usb/input/aiptek.c~slab-remove-slab_atomic
+++ a/drivers/usb/input/aiptek.c
@@ -1988,7 +1988,7 @@ aiptek_probe(struct usb_interface *intf,
 		goto fail1;
 
 	aiptek->data = usb_buffer_alloc(usbdev, AIPTEK_PACKET_LENGTH,
-					SLAB_ATOMIC, &aiptek->data_dma);
+					GFP_ATOMIC, &aiptek->data_dma);
 	if (!aiptek->data)
 		goto fail1;
 
diff -puN drivers/usb/input/ati_remote.c~slab-remove-slab_atomic drivers/usb/input/ati_remote.c
--- a/drivers/usb/input/ati_remote.c~slab-remove-slab_atomic
+++ a/drivers/usb/input/ati_remote.c
@@ -592,7 +592,7 @@ static void ati_remote_irq_in(struct urb
 			__FUNCTION__, urb->status);
 	}
 
-	retval = usb_submit_urb(urb, SLAB_ATOMIC);
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		dev_err(&ati_remote->interface->dev, "%s: usb_submit_urb()=%d\n",
 			__FUNCTION__, retval);
@@ -604,12 +604,12 @@ static void ati_remote_irq_in(struct urb
 static int ati_remote_alloc_buffers(struct usb_device *udev,
 				    struct ati_remote *ati_remote)
 {
-	ati_remote->inbuf = usb_buffer_alloc(udev, DATA_BUFSIZE, SLAB_ATOMIC,
+	ati_remote->inbuf = usb_buffer_alloc(udev, DATA_BUFSIZE, GFP_ATOMIC,
 					     &ati_remote->inbuf_dma);
 	if (!ati_remote->inbuf)
 		return -1;
 
-	ati_remote->outbuf = usb_buffer_alloc(udev, DATA_BUFSIZE, SLAB_ATOMIC,
+	ati_remote->outbuf = usb_buffer_alloc(udev, DATA_BUFSIZE, GFP_ATOMIC,
 					      &ati_remote->outbuf_dma);
 	if (!ati_remote->outbuf)
 		return -1;
diff -puN drivers/usb/input/hid-core.c~slab-remove-slab_atomic drivers/usb/input/hid-core.c
--- a/drivers/usb/input/hid-core.c~slab-remove-slab_atomic
+++ a/drivers/usb/input/hid-core.c
@@ -1079,7 +1079,7 @@ static void hid_irq_in(struct urb *urb)
 			warn("input irq status %d received", urb->status);
 	}
 
-	status = usb_submit_urb(urb, SLAB_ATOMIC);
+	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status) {
 		clear_bit(HID_IN_RUNNING, &hid->iofl);
 		if (status != -EPERM) {
@@ -1864,13 +1864,13 @@ static void hid_find_max_report(struct h
 
 static int hid_alloc_buffers(struct usb_device *dev, struct hid_device *hid)
 {
-	if (!(hid->inbuf = usb_buffer_alloc(dev, hid->bufsize, SLAB_ATOMIC, &hid->inbuf_dma)))
+	if (!(hid->inbuf = usb_buffer_alloc(dev, hid->bufsize, GFP_ATOMIC, &hid->inbuf_dma)))
 		return -1;
-	if (!(hid->outbuf = usb_buffer_alloc(dev, hid->bufsize, SLAB_ATOMIC, &hid->outbuf_dma)))
+	if (!(hid->outbuf = usb_buffer_alloc(dev, hid->bufsize, GFP_ATOMIC, &hid->outbuf_dma)))
 		return -1;
-	if (!(hid->cr = usb_buffer_alloc(dev, sizeof(*(hid->cr)), SLAB_ATOMIC, &hid->cr_dma)))
+	if (!(hid->cr = usb_buffer_alloc(dev, sizeof(*(hid->cr)), GFP_ATOMIC, &hid->cr_dma)))
 		return -1;
-	if (!(hid->ctrlbuf = usb_buffer_alloc(dev, hid->bufsize, SLAB_ATOMIC, &hid->ctrlbuf_dma)))
+	if (!(hid->ctrlbuf = usb_buffer_alloc(dev, hid->bufsize, GFP_ATOMIC, &hid->ctrlbuf_dma)))
 		return -1;
 
 	return 0;
diff -puN drivers/usb/input/keyspan_remote.c~slab-remove-slab_atomic drivers/usb/input/keyspan_remote.c
--- a/drivers/usb/input/keyspan_remote.c~slab-remove-slab_atomic
+++ a/drivers/usb/input/keyspan_remote.c
@@ -456,7 +456,7 @@ static int keyspan_probe(struct usb_inte
 	remote->in_endpoint = endpoint;
 	remote->toggle = -1;	/* Set to -1 so we will always not match the toggle from the first remote message. */
 
-	remote->in_buffer = usb_buffer_alloc(udev, RECV_SIZE, SLAB_ATOMIC, &remote->in_dma);
+	remote->in_buffer = usb_buffer_alloc(udev, RECV_SIZE, GFP_ATOMIC, &remote->in_dma);
 	if (!remote->in_buffer) {
 		retval = -ENOMEM;
 		goto fail1;
diff -puN drivers/usb/input/mtouchusb.c~slab-remove-slab_atomic drivers/usb/input/mtouchusb.c
--- a/drivers/usb/input/mtouchusb.c~slab-remove-slab_atomic
+++ a/drivers/usb/input/mtouchusb.c
@@ -164,7 +164,7 @@ static int mtouchusb_alloc_buffers(struc
 	dbg("%s - called", __FUNCTION__);
 
 	mtouch->data = usb_buffer_alloc(udev, MTOUCHUSB_REPORT_DATA_SIZE,
-					SLAB_ATOMIC, &mtouch->data_dma);
+					GFP_ATOMIC, &mtouch->data_dma);
 
 	if (!mtouch->data)
 		return -1;
diff -puN drivers/usb/input/powermate.c~slab-remove-slab_atomic drivers/usb/input/powermate.c
--- a/drivers/usb/input/powermate.c~slab-remove-slab_atomic
+++ a/drivers/usb/input/powermate.c
@@ -277,12 +277,12 @@ static int powermate_input_event(struct 
 static int powermate_alloc_buffers(struct usb_device *udev, struct powermate_device *pm)
 {
 	pm->data = usb_buffer_alloc(udev, POWERMATE_PAYLOAD_SIZE_MAX,
-				    SLAB_ATOMIC, &pm->data_dma);
+				    GFP_ATOMIC, &pm->data_dma);
 	if (!pm->data)
 		return -1;
 
 	pm->configcr = usb_buffer_alloc(udev, sizeof(*(pm->configcr)),
-					SLAB_ATOMIC, &pm->configcr_dma);
+					GFP_ATOMIC, &pm->configcr_dma);
 	if (!pm->configcr)
 		return -1;
 
diff -puN drivers/usb/input/touchkitusb.c~slab-remove-slab_atomic drivers/usb/input/touchkitusb.c
--- a/drivers/usb/input/touchkitusb.c~slab-remove-slab_atomic
+++ a/drivers/usb/input/touchkitusb.c
@@ -248,7 +248,7 @@ static int touchkit_alloc_buffers(struct
 				  struct touchkit_usb *touchkit)
 {
 	touchkit->data = usb_buffer_alloc(udev, TOUCHKIT_REPORT_DATA_SIZE,
-	                                  SLAB_ATOMIC, &touchkit->data_dma);
+	                                  GFP_ATOMIC, &touchkit->data_dma);
 
 	if (!touchkit->data)
 		return -1;
diff -puN drivers/usb/input/usbkbd.c~slab-remove-slab_atomic drivers/usb/input/usbkbd.c
--- a/drivers/usb/input/usbkbd.c~slab-remove-slab_atomic
+++ a/drivers/usb/input/usbkbd.c
@@ -122,7 +122,7 @@ static void usb_kbd_irq(struct urb *urb)
 	memcpy(kbd->old, kbd->new, 8);
 
 resubmit:
-	i = usb_submit_urb (urb, SLAB_ATOMIC);
+	i = usb_submit_urb (urb, GFP_ATOMIC);
 	if (i)
 		err ("can't resubmit intr, %s-%s/input0, status %d",
 				kbd->usbdev->bus->bus_name,
@@ -196,11 +196,11 @@ static int usb_kbd_alloc_mem(struct usb_
 		return -1;
 	if (!(kbd->led = usb_alloc_urb(0, GFP_KERNEL)))
 		return -1;
-	if (!(kbd->new = usb_buffer_alloc(dev, 8, SLAB_ATOMIC, &kbd->new_dma)))
+	if (!(kbd->new = usb_buffer_alloc(dev, 8, GFP_ATOMIC, &kbd->new_dma)))
 		return -1;
-	if (!(kbd->cr = usb_buffer_alloc(dev, sizeof(struct usb_ctrlrequest), SLAB_ATOMIC, &kbd->cr_dma)))
+	if (!(kbd->cr = usb_buffer_alloc(dev, sizeof(struct usb_ctrlrequest), GFP_ATOMIC, &kbd->cr_dma)))
 		return -1;
-	if (!(kbd->leds = usb_buffer_alloc(dev, 1, SLAB_ATOMIC, &kbd->leds_dma)))
+	if (!(kbd->leds = usb_buffer_alloc(dev, 1, GFP_ATOMIC, &kbd->leds_dma)))
 		return -1;
 
 	return 0;
diff -puN drivers/usb/input/usbmouse.c~slab-remove-slab_atomic drivers/usb/input/usbmouse.c
--- a/drivers/usb/input/usbmouse.c~slab-remove-slab_atomic
+++ a/drivers/usb/input/usbmouse.c
@@ -86,7 +86,7 @@ static void usb_mouse_irq(struct urb *ur
 
 	input_sync(dev);
 resubmit:
-	status = usb_submit_urb (urb, SLAB_ATOMIC);
+	status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status)
 		err ("can't resubmit intr, %s-%s/input0, status %d",
 				mouse->usbdev->bus->bus_name,
@@ -137,7 +137,7 @@ static int usb_mouse_probe(struct usb_in
 	if (!mouse || !input_dev)
 		goto fail1;
 
-	mouse->data = usb_buffer_alloc(dev, 8, SLAB_ATOMIC, &mouse->data_dma);
+	mouse->data = usb_buffer_alloc(dev, 8, GFP_ATOMIC, &mouse->data_dma);
 	if (!mouse->data)
 		goto fail1;
 
diff -puN drivers/usb/input/xpad.c~slab-remove-slab_atomic drivers/usb/input/xpad.c
--- a/drivers/usb/input/xpad.c~slab-remove-slab_atomic
+++ a/drivers/usb/input/xpad.c
@@ -325,7 +325,7 @@ static int xpad_probe(struct usb_interfa
 		goto fail1;
 
 	xpad->idata = usb_buffer_alloc(udev, XPAD_PKT_LEN,
-				       SLAB_ATOMIC, &xpad->idata_dma);
+				       GFP_ATOMIC, &xpad->idata_dma);
 	if (!xpad->idata)
 		goto fail1;
 
diff -puN drivers/usb/input/yealink.c~slab-remove-slab_atomic drivers/usb/input/yealink.c
--- a/drivers/usb/input/yealink.c~slab-remove-slab_atomic
+++ a/drivers/usb/input/yealink.c
@@ -874,17 +874,17 @@ static int usb_probe(struct usb_interfac
 
 	/* allocate usb buffers */
 	yld->irq_data = usb_buffer_alloc(udev, USB_PKT_LEN,
-					SLAB_ATOMIC, &yld->irq_dma);
+					GFP_ATOMIC, &yld->irq_dma);
 	if (yld->irq_data == NULL)
 		return usb_cleanup(yld, -ENOMEM);
 
 	yld->ctl_data = usb_buffer_alloc(udev, USB_PKT_LEN,
-					SLAB_ATOMIC, &yld->ctl_dma);
+					GFP_ATOMIC, &yld->ctl_dma);
 	if (!yld->ctl_data)
 		return usb_cleanup(yld, -ENOMEM);
 
 	yld->ctl_req = usb_buffer_alloc(udev, sizeof(*(yld->ctl_req)),
-					SLAB_ATOMIC, &yld->ctl_req_dma);
+					GFP_ATOMIC, &yld->ctl_req_dma);
 	if (yld->ctl_req == NULL)
 		return usb_cleanup(yld, -ENOMEM);
 
diff -puN drivers/usb/misc/phidgetkit.c~slab-remove-slab_atomic drivers/usb/misc/phidgetkit.c
--- a/drivers/usb/misc/phidgetkit.c~slab-remove-slab_atomic
+++ a/drivers/usb/misc/phidgetkit.c
@@ -377,7 +377,7 @@ static void interfacekit_irq(struct urb 
 		schedule_delayed_work(&kit->do_notify, 0);
 
 resubmit:
-	status = usb_submit_urb(urb, SLAB_ATOMIC);
+	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status)
 		err("can't resubmit intr, %s-%s/interfacekit0, status %d",
 			kit->udev->bus->bus_name,
@@ -568,7 +568,7 @@ static int interfacekit_probe(struct usb
 
 	kit->dev_no = -1;
 	kit->ifkit = ifkit;
-	kit->data = usb_buffer_alloc(dev, URB_INT_SIZE, SLAB_ATOMIC, &kit->data_dma);
+	kit->data = usb_buffer_alloc(dev, URB_INT_SIZE, GFP_ATOMIC, &kit->data_dma);
 	if (!kit->data)
 		goto out;
 
diff -puN drivers/usb/misc/phidgetmotorcontrol.c~slab-remove-slab_atomic drivers/usb/misc/phidgetmotorcontrol.c
--- a/drivers/usb/misc/phidgetmotorcontrol.c~slab-remove-slab_atomic
+++ a/drivers/usb/misc/phidgetmotorcontrol.c
@@ -151,7 +151,7 @@ static void motorcontrol_irq(struct urb 
 		schedule_delayed_work(&mc->do_notify, 0);
 
 resubmit:
-	status = usb_submit_urb(urb, SLAB_ATOMIC);
+	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status)
 		dev_err(&mc->intf->dev,
 			"can't resubmit intr, %s-%s/motorcontrol0, status %d",
@@ -338,7 +338,7 @@ static int motorcontrol_probe(struct usb
 		goto out;
 
 	mc->dev_no = -1;
-	mc->data = usb_buffer_alloc(dev, URB_INT_SIZE, SLAB_ATOMIC, &mc->data_dma);
+	mc->data = usb_buffer_alloc(dev, URB_INT_SIZE, GFP_ATOMIC, &mc->data_dma);
 	if (!mc->data)
 		goto out;
 
diff -puN drivers/usb/misc/usbtest.c~slab-remove-slab_atomic drivers/usb/misc/usbtest.c
--- a/drivers/usb/misc/usbtest.c~slab-remove-slab_atomic
+++ a/drivers/usb/misc/usbtest.c
@@ -819,7 +819,7 @@ error:
 
 	/* resubmit if we need to, else mark this as done */
 	if ((status == 0) && (ctx->pending < ctx->count)) {
-		if ((status = usb_submit_urb (urb, SLAB_ATOMIC)) != 0) {
+		if ((status = usb_submit_urb (urb, GFP_ATOMIC)) != 0) {
 			dbg ("can't resubmit ctrl %02x.%02x, err %d",
 				reqp->bRequestType, reqp->bRequest, status);
 			urb->dev = NULL;
@@ -999,7 +999,7 @@ test_ctrl_queue (struct usbtest_dev *dev
 	context.urb = urb;
 	spin_lock_irq (&context.lock);
 	for (i = 0; i < param->sglen; i++) {
-		context.status = usb_submit_urb (urb [i], SLAB_ATOMIC);
+		context.status = usb_submit_urb (urb [i], GFP_ATOMIC);
 		if (context.status != 0) {
 			dbg ("can't submit urb[%d], status %d",
 					i, context.status);
@@ -1041,7 +1041,7 @@ static void unlink1_callback (struct urb
 
 	// we "know" -EPIPE (stall) never happens
 	if (!status)
-		status = usb_submit_urb (urb, SLAB_ATOMIC);
+		status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status) {
 		urb->status = status;
 		complete ((struct completion *) urb->context);
@@ -1481,7 +1481,7 @@ test_iso_queue (struct usbtest_dev *dev,
 	spin_lock_irq (&context.lock);
 	for (i = 0; i < param->sglen; i++) {
 		++context.pending;
-		status = usb_submit_urb (urbs [i], SLAB_ATOMIC);
+		status = usb_submit_urb (urbs [i], GFP_ATOMIC);
 		if (status < 0) {
 			ERROR (dev, "submit iso[%d], error %d\n", i, status);
 			if (i == 0) {
diff -puN drivers/usb/mon/mon_text.c~slab-remove-slab_atomic drivers/usb/mon/mon_text.c
--- a/drivers/usb/mon/mon_text.c~slab-remove-slab_atomic
+++ a/drivers/usb/mon/mon_text.c
@@ -147,7 +147,7 @@ static void mon_text_event(struct mon_re
 	stamp = mon_get_timestamp();
 
 	if (rp->nevents >= EVENT_MAX ||
-	    (ep = kmem_cache_alloc(rp->e_slab, SLAB_ATOMIC)) == NULL) {
+	    (ep = kmem_cache_alloc(rp->e_slab, GFP_ATOMIC)) == NULL) {
 		rp->r.m_bus->cnt_text_lost++;
 		return;
 	}
@@ -188,7 +188,7 @@ static void mon_text_error(void *data, s
 	struct mon_event_text *ep;
 
 	if (rp->nevents >= EVENT_MAX ||
-	    (ep = kmem_cache_alloc(rp->e_slab, SLAB_ATOMIC)) == NULL) {
+	    (ep = kmem_cache_alloc(rp->e_slab, GFP_ATOMIC)) == NULL) {
 		rp->r.m_bus->cnt_text_lost++;
 		return;
 	}
diff -puN drivers/usb/net/catc.c~slab-remove-slab_atomic drivers/usb/net/catc.c
--- a/drivers/usb/net/catc.c~slab-remove-slab_atomic
+++ a/drivers/usb/net/catc.c
@@ -345,7 +345,7 @@ static void catc_irq_done(struct urb *ur
 		} 
 	}
 resubmit:
-	status = usb_submit_urb (urb, SLAB_ATOMIC);
+	status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status)
 		err ("can't resubmit intr, %s-%s, status %d",
 				catc->usbdev->bus->bus_name,
diff -puN drivers/usb/net/net1080.c~slab-remove-slab_atomic drivers/usb/net/net1080.c
--- a/drivers/usb/net/net1080.c~slab-remove-slab_atomic
+++ a/drivers/usb/net/net1080.c
@@ -383,7 +383,7 @@ static void nc_ensure_sync(struct usbnet
 		int			status;
 
 		/* Send a flush */
-		urb = usb_alloc_urb(0, SLAB_ATOMIC);
+		urb = usb_alloc_urb(0, GFP_ATOMIC);
 		if (!urb)
 			return;
 
diff -puN drivers/usb/net/pegasus.c~slab-remove-slab_atomic drivers/usb/net/pegasus.c
--- a/drivers/usb/net/pegasus.c~slab-remove-slab_atomic
+++ a/drivers/usb/net/pegasus.c
@@ -856,7 +856,7 @@ static void intr_callback(struct urb *ur
 		pegasus->stats.rx_missed_errors += ((d[3] & 0x7f) << 8) | d[4];
 	}
 
-	status = usb_submit_urb(urb, SLAB_ATOMIC);
+	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status == -ENODEV)
 		netif_device_detach(pegasus->net);
 	if (status && netif_msg_timer(pegasus))
diff -puN drivers/usb/net/rtl8150.c~slab-remove-slab_atomic drivers/usb/net/rtl8150.c
--- a/drivers/usb/net/rtl8150.c~slab-remove-slab_atomic
+++ a/drivers/usb/net/rtl8150.c
@@ -587,7 +587,7 @@ static void intr_callback(struct urb *ur
 	}
 
 resubmit:
-	status = usb_submit_urb (urb, SLAB_ATOMIC);
+	status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status == -ENODEV)
 		netif_device_detach(dev->netdev);
 	else if (status)
diff -puN drivers/usb/serial/mos7720.c~slab-remove-slab_atomic drivers/usb/serial/mos7720.c
--- a/drivers/usb/serial/mos7720.c~slab-remove-slab_atomic
+++ a/drivers/usb/serial/mos7720.c
@@ -363,7 +363,7 @@ static int mos7720_open(struct usb_seria
 
 	/* Initialising the write urb pool */
 	for (j = 0; j < NUM_URBS; ++j) {
-		urb = usb_alloc_urb(0,SLAB_ATOMIC);
+		urb = usb_alloc_urb(0,GFP_ATOMIC);
 		mos7720_port->write_urb_pool[j] = urb;
 
 		if (urb == NULL) {
diff -puN drivers/usb/serial/mos7840.c~slab-remove-slab_atomic drivers/usb/serial/mos7840.c
--- a/drivers/usb/serial/mos7840.c~slab-remove-slab_atomic
+++ a/drivers/usb/serial/mos7840.c
@@ -826,7 +826,7 @@ static int mos7840_open(struct usb_seria
 
 	/* Initialising the write urb pool */
 	for (j = 0; j < NUM_URBS; ++j) {
-		urb = usb_alloc_urb(0, SLAB_ATOMIC);
+		urb = usb_alloc_urb(0, GFP_ATOMIC);
 		mos7840_port->write_urb_pool[j] = urb;
 
 		if (urb == NULL) {
@@ -2786,7 +2786,7 @@ static int mos7840_startup(struct usb_se
 				    i + 1, status);
 
 		}
-		mos7840_port->control_urb = usb_alloc_urb(0, SLAB_ATOMIC);
+		mos7840_port->control_urb = usb_alloc_urb(0, GFP_ATOMIC);
 		mos7840_port->ctrl_buf = kmalloc(16, GFP_KERNEL);
 
 	}
diff -puN drivers/usb/storage/onetouch.c~slab-remove-slab_atomic drivers/usb/storage/onetouch.c
--- a/drivers/usb/storage/onetouch.c~slab-remove-slab_atomic
+++ a/drivers/usb/storage/onetouch.c
@@ -76,7 +76,7 @@ static void usb_onetouch_irq(struct urb 
 	input_sync(dev);
 
 resubmit:
-	status = usb_submit_urb (urb, SLAB_ATOMIC);
+	status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status)
 		err ("can't resubmit intr, %s-%s/input0, status %d",
 			onetouch->udev->bus->bus_name,
@@ -154,7 +154,7 @@ int onetouch_connect_input(struct us_dat
 		goto fail1;
 
 	onetouch->data = usb_buffer_alloc(udev, ONETOUCH_PKT_LEN,
-					  SLAB_ATOMIC, &onetouch->data_dma);
+					  GFP_ATOMIC, &onetouch->data_dma);
 	if (!onetouch->data)
 		goto fail1;
 
diff -puN include/linux/slab.h~slab-remove-slab_atomic include/linux/slab.h
--- a/include/linux/slab.h~slab-remove-slab_atomic
+++ a/include/linux/slab.h
@@ -19,7 +19,6 @@ typedef struct kmem_cache kmem_cache_t;
 #include	<asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 
 /* flags for kmem_cache_alloc() */
-#define	SLAB_ATOMIC		GFP_ATOMIC
 #define	SLAB_KERNEL		GFP_KERNEL
 #define	SLAB_DMA		GFP_DMA
 
diff -puN include/net/request_sock.h~slab-remove-slab_atomic include/net/request_sock.h
--- a/include/net/request_sock.h~slab-remove-slab_atomic
+++ a/include/net/request_sock.h
@@ -60,7 +60,7 @@ struct request_sock {
 
 static inline struct request_sock *reqsk_alloc(const struct request_sock_ops *ops)
 {
-	struct request_sock *req = kmem_cache_alloc(ops->slab, SLAB_ATOMIC);
+	struct request_sock *req = kmem_cache_alloc(ops->slab, GFP_ATOMIC);
 
 	if (req != NULL)
 		req->rsk_ops = ops;
diff -puN net/core/dst.c~slab-remove-slab_atomic net/core/dst.c
--- a/net/core/dst.c~slab-remove-slab_atomic
+++ a/net/core/dst.c
@@ -125,7 +125,7 @@ void * dst_alloc(struct dst_ops * ops)
 		if (ops->gc())
 			return NULL;
 	}
-	dst = kmem_cache_alloc(ops->kmem_cachep, SLAB_ATOMIC);
+	dst = kmem_cache_alloc(ops->kmem_cachep, GFP_ATOMIC);
 	if (!dst)
 		return NULL;
 	memset(dst, 0, ops->entry_size);
diff -puN net/core/flow.c~slab-remove-slab_atomic net/core/flow.c
--- a/net/core/flow.c~slab-remove-slab_atomic
+++ a/net/core/flow.c
@@ -211,7 +211,7 @@ void *flow_cache_lookup(struct flowi *ke
 		if (flow_count(cpu) > flow_hwm)
 			flow_cache_shrink(cpu);
 
-		fle = kmem_cache_alloc(flow_cachep, SLAB_ATOMIC);
+		fle = kmem_cache_alloc(flow_cachep, GFP_ATOMIC);
 		if (fle) {
 			fle->next = *head;
 			*head = fle;
diff -puN net/core/neighbour.c~slab-remove-slab_atomic net/core/neighbour.c
--- a/net/core/neighbour.c~slab-remove-slab_atomic
+++ a/net/core/neighbour.c
@@ -251,7 +251,7 @@ static struct neighbour *neigh_alloc(str
 			goto out_entries;
 	}
 
-	n = kmem_cache_alloc(tbl->kmem_cachep, SLAB_ATOMIC);
+	n = kmem_cache_alloc(tbl->kmem_cachep, GFP_ATOMIC);
 	if (!n)
 		goto out_entries;
 
diff -puN net/dccp/ccids/ccid3.c~slab-remove-slab_atomic net/dccp/ccids/ccid3.c
--- a/net/dccp/ccids/ccid3.c~slab-remove-slab_atomic
+++ a/net/dccp/ccids/ccid3.c
@@ -295,7 +295,7 @@ static int ccid3_hc_tx_send_packet(struc
 	new_packet = dccp_tx_hist_head(&hctx->ccid3hctx_hist);
 	if (new_packet == NULL || new_packet->dccphtx_sent) {
 		new_packet = dccp_tx_hist_entry_new(ccid3_tx_hist,
-						    SLAB_ATOMIC);
+						    GFP_ATOMIC);
 
 		if (unlikely(new_packet == NULL)) {
 			DCCP_WARN("%s, sk=%p, not enough mem to add to history,"
@@ -889,7 +889,7 @@ static void ccid3_hc_rx_update_li(struct
 		/* new loss event detected */
 		/* calculate last interval length */
 		seq_temp = dccp_delta_seqno(head->dccplih_seqno, seq_loss);
-		entry = dccp_li_hist_entry_new(ccid3_li_hist, SLAB_ATOMIC);
+		entry = dccp_li_hist_entry_new(ccid3_li_hist, GFP_ATOMIC);
 
 		if (entry == NULL) {
 			DCCP_BUG("out of memory - can not allocate entry");
@@ -1011,7 +1011,7 @@ static void ccid3_hc_rx_packet_recv(stru
 	}
 
 	packet = dccp_rx_hist_entry_new(ccid3_rx_hist, sk, opt_recv->dccpor_ndp,
-					skb, SLAB_ATOMIC);
+					skb, GFP_ATOMIC);
 	if (unlikely(packet == NULL)) {
 		DCCP_WARN("%s, sk=%p, Not enough mem to add rx packet "
 			  "to history, consider it lost!\n", dccp_role(sk), sk);
diff -puN net/dccp/ccids/lib/loss_interval.c~slab-remove-slab_atomic net/dccp/ccids/lib/loss_interval.c
--- a/net/dccp/ccids/lib/loss_interval.c~slab-remove-slab_atomic
+++ a/net/dccp/ccids/lib/loss_interval.c
@@ -125,7 +125,7 @@ int dccp_li_hist_interval_new(struct dcc
 	int i;
 
 	for (i = 0; i < DCCP_LI_HIST_IVAL_F_LENGTH; i++) {
-		entry = dccp_li_hist_entry_new(hist, SLAB_ATOMIC);
+		entry = dccp_li_hist_entry_new(hist, GFP_ATOMIC);
 		if (entry == NULL) {
 			dccp_li_hist_purge(hist, list);
 			DCCP_BUG("loss interval list entry is NULL");
diff -puN net/ipv4/inet_hashtables.c~slab-remove-slab_atomic net/ipv4/inet_hashtables.c
--- a/net/ipv4/inet_hashtables.c~slab-remove-slab_atomic
+++ a/net/ipv4/inet_hashtables.c
@@ -31,7 +31,7 @@ struct inet_bind_bucket *inet_bind_bucke
 						 struct inet_bind_hashbucket *head,
 						 const unsigned short snum)
 {
-	struct inet_bind_bucket *tb = kmem_cache_alloc(cachep, SLAB_ATOMIC);
+	struct inet_bind_bucket *tb = kmem_cache_alloc(cachep, GFP_ATOMIC);
 
 	if (tb != NULL) {
 		tb->port      = snum;
diff -puN net/ipv4/inet_timewait_sock.c~slab-remove-slab_atomic net/ipv4/inet_timewait_sock.c
--- a/net/ipv4/inet_timewait_sock.c~slab-remove-slab_atomic
+++ a/net/ipv4/inet_timewait_sock.c
@@ -91,7 +91,7 @@ struct inet_timewait_sock *inet_twsk_all
 {
 	struct inet_timewait_sock *tw =
 		kmem_cache_alloc(sk->sk_prot_creator->twsk_prot->twsk_slab,
-				 SLAB_ATOMIC);
+				 GFP_ATOMIC);
 	if (tw != NULL) {
 		const struct inet_sock *inet = inet_sk(sk);
 
diff -puN net/ipv6/ip6_fib.c~slab-remove-slab_atomic net/ipv6/ip6_fib.c
--- a/net/ipv6/ip6_fib.c~slab-remove-slab_atomic
+++ a/net/ipv6/ip6_fib.c
@@ -150,7 +150,7 @@ static __inline__ struct fib6_node * nod
 {
 	struct fib6_node *fn;
 
-	if ((fn = kmem_cache_alloc(fib6_node_kmem, SLAB_ATOMIC)) != NULL)
+	if ((fn = kmem_cache_alloc(fib6_node_kmem, GFP_ATOMIC)) != NULL)
 		memset(fn, 0, sizeof(struct fib6_node));
 
 	return fn;
diff -puN net/ipv6/xfrm6_tunnel.c~slab-remove-slab_atomic net/ipv6/xfrm6_tunnel.c
--- a/net/ipv6/xfrm6_tunnel.c~slab-remove-slab_atomic
+++ a/net/ipv6/xfrm6_tunnel.c
@@ -180,7 +180,7 @@ try_next_2:;
 	spi = 0;
 	goto out;
 alloc_spi:
-	x6spi = kmem_cache_alloc(xfrm6_tunnel_spi_kmem, SLAB_ATOMIC);
+	x6spi = kmem_cache_alloc(xfrm6_tunnel_spi_kmem, GFP_ATOMIC);
 	if (!x6spi)
 		goto out;
 
diff -puN net/sctp/sm_make_chunk.c~slab-remove-slab_atomic net/sctp/sm_make_chunk.c
--- a/net/sctp/sm_make_chunk.c~slab-remove-slab_atomic
+++ a/net/sctp/sm_make_chunk.c
@@ -979,7 +979,7 @@ struct sctp_chunk *sctp_chunkify(struct 
 {
 	struct sctp_chunk *retval;
 
-	retval = kmem_cache_alloc(sctp_chunk_cachep, SLAB_ATOMIC);
+	retval = kmem_cache_alloc(sctp_chunk_cachep, GFP_ATOMIC);
 
 	if (!retval)
 		goto nodata;
diff -puN net/sctp/socket.c~slab-remove-slab_atomic net/sctp/socket.c
--- a/net/sctp/socket.c~slab-remove-slab_atomic
+++ a/net/sctp/socket.c
@@ -4989,7 +4989,7 @@ static struct sctp_bind_bucket *sctp_buc
 {
 	struct sctp_bind_bucket *pp;
 
-	pp = kmem_cache_alloc(sctp_bucket_cachep, SLAB_ATOMIC);
+	pp = kmem_cache_alloc(sctp_bucket_cachep, GFP_ATOMIC);
 	SCTP_DBG_OBJCNT_INC(bind_bucket);
 	if (pp) {
 		pp->port = snum;
diff -puN net/xfrm/xfrm_input.c~slab-remove-slab_atomic net/xfrm/xfrm_input.c
--- a/net/xfrm/xfrm_input.c~slab-remove-slab_atomic
+++ a/net/xfrm/xfrm_input.c
@@ -27,7 +27,7 @@ struct sec_path *secpath_dup(struct sec_
 {
 	struct sec_path *sp;
 
-	sp = kmem_cache_alloc(secpath_cachep, SLAB_ATOMIC);
+	sp = kmem_cache_alloc(secpath_cachep, GFP_ATOMIC);
 	if (!sp)
 		return NULL;
 
diff -puN security/selinux/avc.c~slab-remove-slab_atomic security/selinux/avc.c
--- a/security/selinux/avc.c~slab-remove-slab_atomic
+++ a/security/selinux/avc.c
@@ -332,7 +332,7 @@ static struct avc_node *avc_alloc_node(v
 {
 	struct avc_node *node;
 
-	node = kmem_cache_alloc(avc_node_cachep, SLAB_ATOMIC);
+	node = kmem_cache_alloc(avc_node_cachep, GFP_ATOMIC);
 	if (!node)
 		goto out;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
ia64-resolve-name-clash-by-renaming-is_available_memory.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch

