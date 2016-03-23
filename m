From: akpm@linux-foundation.org
Subject: [merged] rapidio-tsi721_dma-fix-synchronization-issues.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:42:07 -0700
Message-ID: <56f2d56f.3rdbYlASlsWYLZQi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbcCWRmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721_dma: fix synchronization issues
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721_dma-fix-synchronization-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721_dma: fix synchronization issues

Fix synchronization issues found during testing using multiple DMA
transfer requests to the same channel:
- lost MSI-X interrupt notifications
- non-synchronized attempts to start DMA channel HW resulting in error
  message from the driver
- cookie tracking/update race conditions resulting in incorrect DMA
  transfer status report

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Reported-by: Barry Wood <barry.wood@idt.com>
Tested-by: Barry Wood <barry.wood@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721_dma.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-fix-synchronization-issues drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-fix-synchronization-issues
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -84,7 +84,7 @@ static int tsi721_bdma_ch_init(struct ts
 	 */
 	bd_ptr = dma_zalloc_coherent(dev,
 				(bd_num + 1) * sizeof(struct tsi721_dma_desc),
-				&bd_phys, GFP_KERNEL);
+				&bd_phys, GFP_ATOMIC);
 	if (!bd_ptr)
 		return -ENOMEM;
 
@@ -102,7 +102,7 @@ static int tsi721_bdma_ch_init(struct ts
 	sts_size = roundup_pow_of_two(sts_size);
 	sts_ptr = dma_zalloc_coherent(dev,
 				     sts_size * sizeof(struct tsi721_dma_sts),
-				     &sts_phys, GFP_KERNEL);
+				     &sts_phys, GFP_ATOMIC);
 	if (!sts_ptr) {
 		/* Free space allocated for DMA descriptors */
 		dma_free_coherent(dev,
@@ -297,7 +297,8 @@ static irqreturn_t tsi721_bdma_msix(int
 {
 	struct tsi721_bdma_chan *bdma_chan = ptr;
 
-	tsi721_bdma_handler(bdma_chan);
+	if (bdma_chan->active)
+		tasklet_schedule(&bdma_chan->tasklet);
 	return IRQ_HANDLED;
 }
 #endif /* CONFIG_PCI_MSI */
@@ -618,14 +619,14 @@ static void tsi721_dma_tasklet(unsigned
 			}
 			list_add(&desc->desc_node, &bdma_chan->free_list);
 			bdma_chan->active_tx = NULL;
+			tsi721_advance_work(bdma_chan, NULL);
 			spin_unlock(&bdma_chan->lock);
 			if (callback)
 				callback(param);
-			spin_lock(&bdma_chan->lock);
+		} else {
+			tsi721_advance_work(bdma_chan, bdma_chan->active_tx);
+			spin_unlock(&bdma_chan->lock);
 		}
-
-		tsi721_advance_work(bdma_chan, bdma_chan->active_tx);
-		spin_unlock(&bdma_chan->lock);
 	}
 
 	/* Re-Enable BDMA channel interrupts */
@@ -681,7 +682,7 @@ static int tsi721_alloc_chan_resources(s
 
 	/* Allocate queue of transaction descriptors */
 	desc = kcalloc(TSI721_DMA_TX_QUEUE_SZ, sizeof(struct tsi721_tx_desc),
-			GFP_KERNEL);
+			GFP_ATOMIC);
 	if (!desc) {
 		tsi_err(&dchan->dev->device,
 			"DMAC%d Failed to allocate logical descriptors",
@@ -744,7 +745,13 @@ static
 enum dma_status tsi721_tx_status(struct dma_chan *dchan, dma_cookie_t cookie,
 				 struct dma_tx_state *txstate)
 {
-	return dma_cookie_status(dchan, cookie, txstate);
+	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
+	enum dma_status	status;
+
+	spin_lock_bh(&bdma_chan->lock);
+	status = dma_cookie_status(dchan, cookie, txstate);
+	spin_unlock_bh(&bdma_chan->lock);
+	return status;
 }
 
 static void tsi721_issue_pending(struct dma_chan *dchan)
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are


