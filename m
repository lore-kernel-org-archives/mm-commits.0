From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-tsi721_dma-optimize-use-of-bdma-descriptors.patch removed from -mm
 tree
Date: Tue, 08 Apr 2014 14:25:25 -0700
Message-ID: <53446945.O4J7NR89whYWyUKg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbaDHVZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mporter@kernel.crashing.org, alexandre.bounine@idt.com

Subject: [merged] rapidio-tsi721_dma-optimize-use-of-bdma-descriptors.patch removed from -mm tree
To: alexandre.bounine@idt.com,mporter@kernel.crashing.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:25:25 -0700


The patch titled
     Subject: drivers/rapidio/devices/tsi721_dma.c: optimize use of BDMA descriptors
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721_dma-optimize-use-of-bdma-descriptors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: drivers/rapidio/devices/tsi721_dma.c: optimize use of BDMA descriptors

Combine SG entries describing single contiguous memory block into one
Tsi721 BDMA descriptor.  This reduces number of hardware descriptors
required for large data transfers and improves performance on the PCIe
side by reducing number of descriptor fetch requests.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.h     |    4 
 drivers/rapidio/devices/tsi721_dma.c |  111 +++++++++++++++++--------
 2 files changed, 82 insertions(+), 33 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.h~rapidio-tsi721_dma-optimize-use-of-bdma-descriptors drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-tsi721_dma-optimize-use-of-bdma-descriptors
+++ a/drivers/rapidio/devices/tsi721.h
@@ -644,6 +644,9 @@ enum tsi721_smsg_int_flag {
 
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 
+#define TSI721_BDMA_BD_RING_SZ	128
+#define TSI721_BDMA_MAX_BCOUNT	(TSI721_DMAD_BCOUNT1 + 1)
+
 struct tsi721_tx_desc {
 	struct dma_async_tx_descriptor	txd;
 	struct tsi721_dma_desc		*hw_desc;
@@ -652,6 +655,7 @@ struct tsi721_tx_desc {
 	u64				rio_addr;
 	/* upper 2-bits of 66-bit RIO address */
 	u8				rio_addr_u;
+	u32				bcount;
 	bool				interrupt;
 	struct list_head		desc_node;
 	struct list_head		tx_list;
diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-optimize-use-of-bdma-descriptors drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-optimize-use-of-bdma-descriptors
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -304,35 +304,17 @@ struct tsi721_tx_desc *tsi721_desc_get(s
 }
 
 static int
-tsi721_fill_desc(struct tsi721_bdma_chan *bdma_chan,
-	struct tsi721_tx_desc *desc, struct scatterlist *sg,
+tsi721_desc_fill_init(struct tsi721_tx_desc *desc, struct scatterlist *sg,
 	enum dma_rtype rtype, u32 sys_size)
 {
 	struct tsi721_dma_desc *bd_ptr = desc->hw_desc;
 	u64 rio_addr;
 
-	if (sg_dma_len(sg) > TSI721_DMAD_BCOUNT1 + 1) {
-		dev_err(bdma_chan->dchan.device->dev,
-			"SG element is too large\n");
-		return -EINVAL;
-	}
-
-	dev_dbg(bdma_chan->dchan.device->dev,
-		"desc: 0x%llx, addr: 0x%llx len: 0x%x\n",
-		(u64)desc->txd.phys, (unsigned long long)sg_dma_address(sg),
-		sg_dma_len(sg));
-
-	dev_dbg(bdma_chan->dchan.device->dev,
-		"bd_ptr = %p did=%d raddr=0x%llx\n",
-		bd_ptr, desc->destid, desc->rio_addr);
-
 	/* Initialize DMA descriptor */
 	bd_ptr->type_id = cpu_to_le32((DTYPE1 << 29) |
 					(rtype << 19) | desc->destid);
-	if (desc->interrupt)
-		bd_ptr->type_id |= cpu_to_le32(TSI721_DMAD_IOF);
 	bd_ptr->bcount = cpu_to_le32(((desc->rio_addr & 0x3) << 30) |
-					(sys_size << 26) | sg_dma_len(sg));
+				     (sys_size << 26));
 	rio_addr = (desc->rio_addr >> 2) |
 				((u64)(desc->rio_addr_u & 0x3) << 62);
 	bd_ptr->raddr_lo = cpu_to_le32(rio_addr & 0xffffffff);
@@ -346,6 +328,20 @@ tsi721_fill_desc(struct tsi721_bdma_chan
 	return 0;
 }
 
+static int
+tsi721_desc_fill_end(struct tsi721_tx_desc *desc)
+{
+	struct tsi721_dma_desc *bd_ptr = desc->hw_desc;
+
+	/* Update DMA descriptor */
+	if (desc->interrupt)
+		bd_ptr->type_id |= cpu_to_le32(TSI721_DMAD_IOF);
+	bd_ptr->bcount |= cpu_to_le32(desc->bcount & TSI721_DMAD_BCOUNT1);
+
+	return 0;
+}
+
+
 static void tsi721_dma_chain_complete(struct tsi721_bdma_chan *bdma_chan,
 				      struct tsi721_tx_desc *desc)
 {
@@ -674,6 +670,7 @@ struct dma_async_tx_descriptor *tsi721_p
 	unsigned int i;
 	u32 sys_size = dma_to_mport(dchan->device)->sys_size;
 	enum dma_rtype rtype;
+	dma_addr_t next_addr = -1;
 
 	if (!sgl || !sg_len) {
 		dev_err(dchan->device->dev, "%s: No SG list\n", __func__);
@@ -704,36 +701,84 @@ struct dma_async_tx_descriptor *tsi721_p
 	for_each_sg(sgl, sg, sg_len, i) {
 		int err;
 
-		dev_dbg(dchan->device->dev, "%s: sg #%d\n", __func__, i);
+		if (sg_dma_len(sg) > TSI721_BDMA_MAX_BCOUNT) {
+			dev_err(dchan->device->dev,
+				"%s: SG entry %d is too large\n", __func__, i);
+			goto err_desc_put;
+		}
+
+		/*
+		 * If this sg entry forms contiguous block with previous one,
+		 * try to merge it into existing DMA descriptor
+		 */
+		if (desc) {
+			if (next_addr == sg_dma_address(sg) &&
+			    desc->bcount + sg_dma_len(sg) <=
+						TSI721_BDMA_MAX_BCOUNT) {
+				/* Adjust byte count of the descriptor */
+				desc->bcount += sg_dma_len(sg);
+				goto entry_done;
+			}
+
+			/*
+			 * Finalize this descriptor using total
+			 * byte count value.
+			 */
+			tsi721_desc_fill_end(desc);
+			dev_dbg(dchan->device->dev, "%s: desc final len: %d\n",
+				__func__, desc->bcount);
+		}
+
+		/*
+		 * Obtain and initialize a new descriptor
+		 */
 		desc = tsi721_desc_get(bdma_chan);
 		if (!desc) {
 			dev_err(dchan->device->dev,
-				"Not enough descriptors available\n");
-			goto err_desc_get;
+				"%s: Failed to get new descriptor for SG %d\n",
+				__func__, i);
+			goto err_desc_put;
 		}
 
-		if (sg_is_last(sg))
-			desc->interrupt = (flags & DMA_PREP_INTERRUPT) != 0;
-		else
-			desc->interrupt = false;
-
 		desc->destid = rext->destid;
 		desc->rio_addr = rio_addr;
 		desc->rio_addr_u = 0;
+		desc->bcount = sg_dma_len(sg);
+
+		dev_dbg(dchan->device->dev,
+			"sg%d desc: 0x%llx, addr: 0x%llx len: %d\n",
+			i, (u64)desc->txd.phys,
+			(unsigned long long)sg_dma_address(sg),
+			sg_dma_len(sg));
+
+		dev_dbg(dchan->device->dev,
+			"bd_ptr = %p did=%d raddr=0x%llx\n",
+			desc->hw_desc, desc->destid, desc->rio_addr);
 
-		err = tsi721_fill_desc(bdma_chan, desc, sg, rtype, sys_size);
+		err = tsi721_desc_fill_init(desc, sg, rtype, sys_size);
 		if (err) {
 			dev_err(dchan->device->dev,
 				"Failed to build desc: %d\n", err);
-			goto err_desc_get;
+			goto err_desc_put;
 		}
 
-		rio_addr += sg_dma_len(sg);
+		next_addr = sg_dma_address(sg);
 
 		if (!first)
 			first = desc;
 		else
 			list_add_tail(&desc->desc_node, &first->tx_list);
+
+entry_done:
+		if (sg_is_last(sg)) {
+			desc->interrupt = (flags & DMA_PREP_INTERRUPT) != 0;
+			tsi721_desc_fill_end(desc);
+			dev_dbg(dchan->device->dev, "%s: desc final len: %d\n",
+				__func__, desc->bcount);
+		} else {
+			rio_addr += sg_dma_len(sg);
+			next_addr += sg_dma_len(sg);
+		}
 	}
 
 	first->txd.cookie = -EBUSY;
@@ -741,7 +786,7 @@ struct dma_async_tx_descriptor *tsi721_p
 
 	return &first->txd;
 
-err_desc_get:
+err_desc_put:
 	tsi721_desc_put(bdma_chan, first);
 	return NULL;
 }
@@ -792,7 +837,7 @@ int tsi721_register_dma(struct tsi721_de
 		if (i == TSI721_DMACH_MAINT)
 			continue;
 
-		bdma_chan->bd_num = 64;
+		bdma_chan->bd_num = TSI721_BDMA_BD_RING_SZ;
 		bdma_chan->regs = priv->regs + TSI721_DMAC_BASE(i);
 
 		bdma_chan->dchan.device = &mport->dma;
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

