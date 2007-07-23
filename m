From: akpm@linux-foundation.org
Subject: + 0-null-drivers-usb-gadget.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:18:41 -0700
Message-ID: <200707232118.l6NLIftg012326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38997 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbXGWVSt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:18:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: padator@wanadoo.fr, greg@kroah.com


The patch titled
     0 -> NULL, drivers/usb/gadget/
has been added to the -mm tree.  Its filename is
     0-null-drivers-usb-gadget.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 0 -> NULL, drivers/usb/gadget/
From: Yoann Padioleau <padator@wanadoo.fr>

When comparing a pointer, it's clearer to compare it to NULL than to 0.

Here is the semantic patch:

@@
expression *E;
@@

  E ==
- 0
+ NULL

@@
expression *E;
@@

- 0
+ NULL
  == E

@@
expression *E;
@@

  E !=
- 0
+ NULL

@@
expression *E;
@@

- 0
+ NULL
  != E

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/config.c      |    2 +-
 drivers/usb/gadget/ether.c       |    2 +-
 drivers/usb/gadget/goku_udc.c    |    2 +-
 drivers/usb/gadget/inode.c       |    2 +-
 drivers/usb/gadget/lh7a40x_udc.c |    2 +-
 drivers/usb/gadget/m66592-udc.c  |    2 +-
 drivers/usb/gadget/net2280.c     |    8 ++++----
 drivers/usb/gadget/pxa2xx_udc.c  |    4 ++--
 drivers/usb/gadget/pxa2xx_udc.h  |    2 +-
 drivers/usb/gadget/s3c2410_udc.c |    2 +-
 10 files changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/usb/gadget/config.c~0-null-drivers-usb-gadget drivers/usb/gadget/config.c
--- a/drivers/usb/gadget/config.c~0-null-drivers-usb-gadget
+++ a/drivers/usb/gadget/config.c
@@ -50,7 +50,7 @@ usb_descriptor_fillbuf(void *buf, unsign
 		return -EINVAL;
 
 	/* fill buffer from src[] until null descriptor ptr */
-	for (; 0 != *src; src++) {
+	for (; NULL != *src; src++) {
 		unsigned		len = (*src)->bLength;
 
 		if (len > buflen)
diff -puN drivers/usb/gadget/ether.c~0-null-drivers-usb-gadget drivers/usb/gadget/ether.c
--- a/drivers/usb/gadget/ether.c~0-null-drivers-usb-gadget
+++ a/drivers/usb/gadget/ether.c
@@ -1723,7 +1723,7 @@ rx_submit (struct eth_dev *dev, struct u
 		size += sizeof (struct rndis_packet_msg_type);
 	size -= size % dev->out_ep->maxpacket;
 
-	if ((skb = alloc_skb (size + NET_IP_ALIGN, gfp_flags)) == 0) {
+	if ((skb = alloc_skb (size + NET_IP_ALIGN, gfp_flags)) == NULL) {
 		DEBUG (dev, "no rx skb\n");
 		goto enomem;
 	}
diff -puN drivers/usb/gadget/goku_udc.c~0-null-drivers-usb-gadget drivers/usb/gadget/goku_udc.c
--- a/drivers/usb/gadget/goku_udc.c~0-null-drivers-usb-gadget
+++ a/drivers/usb/gadget/goku_udc.c
@@ -776,7 +776,7 @@ goku_queue(struct usb_ep *_ep, struct us
 
 	} /* else pio or dma irq handler advances the queue. */
 
-	if (likely(req != 0))
+	if (likely(req != NULL))
 		list_add_tail(&req->queue, &ep->queue);
 
 	if (likely(!list_empty(&ep->queue))
diff -puN drivers/usb/gadget/inode.c~0-null-drivers-usb-gadget drivers/usb/gadget/inode.c
--- a/drivers/usb/gadget/inode.c~0-null-drivers-usb-gadget
+++ a/drivers/usb/gadget/inode.c
@@ -1394,7 +1394,7 @@ gadgetfs_setup (struct usb_gadget *gadge
 	dev->setup_abort = 0;
 	if (dev->state == STATE_DEV_UNCONNECTED) {
 #ifdef	CONFIG_USB_GADGET_DUALSPEED
-		if (gadget->speed == USB_SPEED_HIGH && dev->hs_config == 0) {
+		if (gadget->speed == USB_SPEED_HIGH && dev->hs_config == NULL) {
 			spin_unlock(&dev->lock);
 			ERROR (dev, "no high speed config??\n");
 			return -EINVAL;
diff -puN drivers/usb/gadget/lh7a40x_udc.c~0-null-drivers-usb-gadget drivers/usb/gadget/lh7a40x_udc.c
--- a/drivers/usb/gadget/lh7a40x_udc.c~0-null-drivers-usb-gadget
+++ a/drivers/usb/gadget/lh7a40x_udc.c
@@ -1202,7 +1202,7 @@ static int lh7a40x_queue(struct usb_ep *
 	}
 
 	/* pio or dma irq handler advances the queue. */
-	if (likely(req != 0))
+	if (likely(req != NULL))
 		list_add_tail(&req->queue, &ep->queue);
 
 	spin_unlock_irqrestore(&dev->lock, flags);
diff -puN drivers/usb/gadget/m66592-udc.c~0-null-drivers-usb-gadget drivers/usb/gadget/m66592-udc.c
--- a/drivers/usb/gadget/m66592-udc.c~0-null-drivers-usb-gadget
+++ a/drivers/usb/gadget/m66592-udc.c
@@ -1299,7 +1299,7 @@ static int m66592_queue(struct usb_ep *_
 	req->req.actual = 0;
 	req->req.status = -EINPROGRESS;
 
-	if (ep->desc == 0)	/* control */
+	if (ep->desc == NULL)	/* control */
 		start_ep0(ep, req);
 	else {
 		if (request && !ep->busy)
diff -puN drivers/usb/gadget/net2280.c~0-null-drivers-usb-gadget drivers/usb/gadget/net2280.c
--- a/drivers/usb/gadget/net2280.c~0-null-drivers-usb-gadget
+++ a/drivers/usb/gadget/net2280.c
@@ -2120,7 +2120,7 @@ static void handle_ep_small (struct net2
 		return;
 
 	/* manual DMA queue advance after short OUT */
-	if (likely (ep->dma != 0)) {
+	if (likely (ep->dma != NULL)) {
 		if (t & (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT)) {
 			u32	count;
 			int	stopped = ep->stopped;
@@ -2380,7 +2380,7 @@ static void handle_stat0_irqs (struct ne
 			/* hw handles device and interface status */
 			if (u.r.bRequestType != (USB_DIR_IN|USB_RECIP_ENDPOINT))
 				goto delegate;
-			if ((e = get_ep_by_addr (dev, w_index)) == 0
+			if ((e = get_ep_by_addr (dev, w_index)) == NULL
 					|| w_length > 2)
 				goto do_stall;
 
@@ -2408,7 +2408,7 @@ static void handle_stat0_irqs (struct ne
 			if (w_value != USB_ENDPOINT_HALT
 					|| w_length != 0)
 				goto do_stall;
-			if ((e = get_ep_by_addr (dev, w_index)) == 0)
+			if ((e = get_ep_by_addr (dev, w_index)) == NULL)
 				goto do_stall;
 			clear_halt (e);
 			allow_status (ep);
@@ -2425,7 +2425,7 @@ static void handle_stat0_irqs (struct ne
 			if (w_value != USB_ENDPOINT_HALT
 					|| w_length != 0)
 				goto do_stall;
-			if ((e = get_ep_by_addr (dev, w_index)) == 0)
+			if ((e = get_ep_by_addr (dev, w_index)) == NULL)
 				goto do_stall;
 			set_halt (e);
 			allow_status (ep);
diff -puN drivers/usb/gadget/pxa2xx_udc.c~0-null-drivers-usb-gadget drivers/usb/gadget/pxa2xx_udc.c
--- a/drivers/usb/gadget/pxa2xx_udc.c~0-null-drivers-usb-gadget
+++ a/drivers/usb/gadget/pxa2xx_udc.c
@@ -688,7 +688,7 @@ pxa2xx_ep_queue(struct usb_ep *_ep, stru
 
 	/* kickstart this i/o queue? */
 	if (list_empty(&ep->queue) && !ep->stopped) {
-		if (ep->desc == 0 /* ep0 */) {
+		if (ep->desc == NULL /* ep0 */) {
 			unsigned	length = _req->length;
 
 			switch (dev->ep0state) {
@@ -742,7 +742,7 @@ pxa2xx_ep_queue(struct usb_ep *_ep, stru
 	}
 
 	/* pio or dma irq handler advances the queue. */
-	if (likely (req != 0))
+	if (likely (req != NULL))
 		list_add_tail(&req->queue, &ep->queue);
 	local_irq_restore(flags);
 
diff -puN drivers/usb/gadget/pxa2xx_udc.h~0-null-drivers-usb-gadget drivers/usb/gadget/pxa2xx_udc.h
--- a/drivers/usb/gadget/pxa2xx_udc.h~0-null-drivers-usb-gadget
+++ a/drivers/usb/gadget/pxa2xx_udc.h
@@ -232,7 +232,7 @@ dump_state(struct pxa2xx_udc *dev)
 		dev->stats.read.bytes, dev->stats.read.ops);
 
 	for (i = 1; i < PXA_UDC_NUM_ENDPOINTS; i++) {
-		if (dev->ep [i].desc == 0)
+		if (dev->ep [i].desc == NULL)
 			continue;
 		DMSG ("udccs%d = %02x\n", i, *dev->ep->reg_udccs);
 	}
diff -puN drivers/usb/gadget/s3c2410_udc.c~0-null-drivers-usb-gadget drivers/usb/gadget/s3c2410_udc.c
--- a/drivers/usb/gadget/s3c2410_udc.c~0-null-drivers-usb-gadget
+++ a/drivers/usb/gadget/s3c2410_udc.c
@@ -1294,7 +1294,7 @@ static int s3c2410_udc_queue(struct usb_
 	}
 
 	/* pio or dma irq handler advances the queue. */
-	if (likely (req != 0))
+	if (likely (req != NULL))
 		list_add_tail(&req->queue, &ep->queue);
 
 	local_irq_restore(flags);
_

Patches currently in -mm which might be from padator@wanadoo.fr are

git-dvb.patch
0-null-drivers-usb-gadget.patch
