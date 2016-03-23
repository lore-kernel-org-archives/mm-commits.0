From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:42:05 -0700
Message-ID: <56f2d56d.qwanB4HYKFlZSJJc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505AbcCWRmG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721_dma: update error reporting from prep_sg callback
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721_dma: update error reporting from prep_sg callback

Switch to returning error-valued pointer instead of simple NULL pointer. 
This allows to properly identify situation when request queue is full and
therefore gives to upper layer an option to retry operation later.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721_dma.c |   37 ++++++++++++++-----------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -767,7 +767,7 @@ struct dma_async_tx_descriptor *tsi721_p
 			void *tinfo)
 {
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
-	struct tsi721_tx_desc *desc, *_d;
+	struct tsi721_tx_desc *desc;
 	struct rio_dma_ext *rext = tinfo;
 	enum dma_rtype rtype;
 	struct dma_async_tx_descriptor *txd = NULL;
@@ -775,7 +775,7 @@ struct dma_async_tx_descriptor *tsi721_p
 	if (!sgl || !sg_len) {
 		tsi_err(&dchan->dev->device, "DMAC%d No SG list",
 			bdma_chan->id);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	tsi_debug(DMA, &dchan->dev->device, "DMAC%d %s", bdma_chan->id,
@@ -800,28 +800,33 @@ struct dma_async_tx_descriptor *tsi721_p
 		tsi_err(&dchan->dev->device,
 			"DMAC%d Unsupported DMA direction option",
 			bdma_chan->id);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	spin_lock_bh(&bdma_chan->lock);
 
-	list_for_each_entry_safe(desc, _d, &bdma_chan->free_list, desc_node) {
-		if (async_tx_test_ack(&desc->txd)) {
-			list_del_init(&desc->desc_node);
-			desc->destid = rext->destid;
-			desc->rio_addr = rext->rio_addr;
-			desc->rio_addr_u = 0;
-			desc->rtype = rtype;
-			desc->sg_len	= sg_len;
-			desc->sg	= sgl;
-			txd		= &desc->txd;
-			txd->flags	= flags;
-			break;
-		}
+	if (!list_empty(&bdma_chan->free_list)) {
+		desc = list_first_entry(&bdma_chan->free_list,
+				struct tsi721_tx_desc, desc_node);
+		list_del_init(&desc->desc_node);
+		desc->destid = rext->destid;
+		desc->rio_addr = rext->rio_addr;
+		desc->rio_addr_u = 0;
+		desc->rtype = rtype;
+		desc->sg_len	= sg_len;
+		desc->sg	= sgl;
+		txd		= &desc->txd;
+		txd->flags	= flags;
 	}
 
 	spin_unlock_bh(&bdma_chan->lock);
 
+	if (!txd) {
+		tsi_debug(DMA, &dchan->dev->device,
+			  "DMAC%d free TXD is not available", bdma_chan->id);
+		return ERR_PTR(-EBUSY);
+	}
+
 	return txd;
 }
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are


