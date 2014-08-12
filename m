From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-tsi721_dma-rework-scatter-gather-list-handling.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:40:32 -0700
Message-ID: <53ea6db0.I58zUT0cPUwJLgSd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:46875 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbaHLTkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:33 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2667582pab.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, dan.j.williams@intel.com, mporter@kernel.crashing.org, stef.van.os@prodrive-technologies.com, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721_dma: rework scatter-gather list handling
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721_dma-rework-scatter-gather-list-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721_dma: rework scatter-gather list handling

Rework Tsi721 RapidIO DMA engine support to allow handling data
scatter/gather lists longer than number of hardware buffer descriptors in
the DMA channel's descriptor list.

The current implementation of Tsi721 DMA transfers requires that number of
entries in a scatter/gather list provided by a caller of
dmaengine_prep_rio_sg() should not exceed number of allocated hardware
buffer descriptors.

This patch removes the limitation by processing long scatter/gather lists
by sections that can be transferred using hardware descriptor ring of
configured size.  It also introduces a module parameter
"dma_desc_per_channel" to allow run-time configuration of Tsi721 hardware
buffer descriptor rings.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Stef van Os <stef.van.os@prodrive-technologies.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rapidio/tsi721.txt     |   19 
 drivers/rapidio/devices/tsi721.h     |   12 
 drivers/rapidio/devices/tsi721_dma.c |  718 ++++++++++++-------------
 3 files changed, 394 insertions(+), 355 deletions(-)

diff -puN Documentation/rapidio/tsi721.txt~rapidio-tsi721_dma-rework-scatter-gather-list-handling Documentation/rapidio/tsi721.txt
--- a/Documentation/rapidio/tsi721.txt~rapidio-tsi721_dma-rework-scatter-gather-list-handling
+++ a/Documentation/rapidio/tsi721.txt
@@ -20,13 +20,26 @@ II. Known problems
 
   None.
 
-III. To do
+III. DMA Engine Support
 
- Add DMA data transfers (non-messaging).
- Add inbound region (SRIO-to-PCIe) mapping.
+Tsi721 mport driver supports DMA data transfers between local system memory and
+remote RapidIO devices. This functionality is implemented according to SLAVE
+mode API defined by common Linux kernel DMA Engine framework.
+
+Depending on system requirements RapidIO DMA operations can be included/excluded
+by setting CONFIG_RAPIDIO_DMA_ENGINE option. Tsi721 miniport driver uses seven
+out of eight available BDMA channels to support DMA data transfers.
+One BDMA channel is reserved for generation of maintenance read/write requests.
+
+If Tsi721 mport driver have been built with RAPIDIO_DMA_ENGINE support included,
+this driver will accept DMA-specific module parameter:
+  "dma_desc_per_channel" - defines number of hardware buffer descriptors used by
+                           each BDMA channel of Tsi721 (by default - 128).
 
 IV. Version History
 
+  1.1.0 - DMA operations re-worked to support data scatter/gather lists larger
+          than hardware buffer descriptors ring.
   1.0.0 - Initial driver release.
 
 V.  License
diff -puN drivers/rapidio/devices/tsi721.h~rapidio-tsi721_dma-rework-scatter-gather-list-handling drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-tsi721_dma-rework-scatter-gather-list-handling
+++ a/drivers/rapidio/devices/tsi721.h
@@ -644,27 +644,26 @@ enum tsi721_smsg_int_flag {
 
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 
-#define TSI721_BDMA_BD_RING_SZ	128
 #define TSI721_BDMA_MAX_BCOUNT	(TSI721_DMAD_BCOUNT1 + 1)
 
 struct tsi721_tx_desc {
 	struct dma_async_tx_descriptor	txd;
-	struct tsi721_dma_desc		*hw_desc;
 	u16				destid;
 	/* low 64-bits of 66-bit RIO address */
 	u64				rio_addr;
 	/* upper 2-bits of 66-bit RIO address */
 	u8				rio_addr_u;
-	u32				bcount;
-	bool				interrupt;
+	enum dma_rtype			rtype;
 	struct list_head		desc_node;
-	struct list_head		tx_list;
+	struct scatterlist		*sg;
+	unsigned int			sg_len;
+	enum dma_status			status;
 };
 
 struct tsi721_bdma_chan {
 	int		id;
 	void __iomem	*regs;
-	int		bd_num;		/* number of buffer descriptors */
+	int		bd_num;		/* number of HW buffer descriptors */
 	void		*bd_base;	/* start of DMA descriptors */
 	dma_addr_t	bd_phys;
 	void		*sts_base;	/* start of DMA BD status FIFO */
@@ -680,7 +679,6 @@ struct tsi721_bdma_chan {
 	struct list_head	active_list;
 	struct list_head	queue;
 	struct list_head	free_list;
-	dma_cookie_t		completed_cookie;
 	struct tasklet_struct	tasklet;
 	bool			active;
 };
diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-rework-scatter-gather-list-handling drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-rework-scatter-gather-list-handling
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -1,7 +1,7 @@
 /*
  * DMA Engine support for Tsi721 PCIExpress-to-SRIO bridge
  *
- * Copyright 2011 Integrated Device Technology, Inc.
+ * Copyright (c) 2011-2014 Integrated Device Technology, Inc.
  * Alexandre Bounine <alexandre.bounine@idt.com>
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -14,9 +14,8 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59
- * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ * The full GNU General Public License is included in this distribution in the
+ * file called COPYING.
  */
 
 #include <linux/io.h>
@@ -32,9 +31,22 @@
 #include <linux/interrupt.h>
 #include <linux/kfifo.h>
 #include <linux/delay.h>
+#include "../../dma/dmaengine.h"
 
 #include "tsi721.h"
 
+#define TSI721_DMA_TX_QUEUE_SZ	16	/* number of transaction descriptors */
+
+#ifdef CONFIG_PCI_MSI
+static irqreturn_t tsi721_bdma_msix(int irq, void *ptr);
+#endif
+static int tsi721_submit_sg(struct tsi721_tx_desc *desc);
+
+static unsigned int dma_desc_per_channel = 128;
+module_param(dma_desc_per_channel, uint, S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(dma_desc_per_channel,
+		 "Number of DMA descriptors per channel (default: 128)");
+
 static inline struct tsi721_bdma_chan *to_tsi721_chan(struct dma_chan *chan)
 {
 	return container_of(chan, struct tsi721_bdma_chan, dchan);
@@ -59,7 +71,7 @@ struct tsi721_tx_desc *tsi721_dma_first_
 				struct tsi721_tx_desc, desc_node);
 }
 
-static int tsi721_bdma_ch_init(struct tsi721_bdma_chan *bdma_chan)
+static int tsi721_bdma_ch_init(struct tsi721_bdma_chan *bdma_chan, int bd_num)
 {
 	struct tsi721_dma_desc *bd_ptr;
 	struct device *dev = bdma_chan->dchan.device->dev;
@@ -67,17 +79,23 @@ static int tsi721_bdma_ch_init(struct ts
 	dma_addr_t	bd_phys;
 	dma_addr_t	sts_phys;
 	int		sts_size;
-	int		bd_num = bdma_chan->bd_num;
+#ifdef CONFIG_PCI_MSI
+	struct tsi721_device *priv = to_tsi721(bdma_chan->dchan.device);
+#endif
 
 	dev_dbg(dev, "Init Block DMA Engine, CH%d\n", bdma_chan->id);
 
-	/* Allocate space for DMA descriptors */
+	/*
+	 * Allocate space for DMA descriptors
+	 * (add an extra element for link descriptor)
+	 */
 	bd_ptr = dma_zalloc_coherent(dev,
-				bd_num * sizeof(struct tsi721_dma_desc),
+				(bd_num + 1) * sizeof(struct tsi721_dma_desc),
 				&bd_phys, GFP_KERNEL);
 	if (!bd_ptr)
 		return -ENOMEM;
 
+	bdma_chan->bd_num = bd_num;
 	bdma_chan->bd_phys = bd_phys;
 	bdma_chan->bd_base = bd_ptr;
 
@@ -85,8 +103,8 @@ static int tsi721_bdma_ch_init(struct ts
 		bd_ptr, (unsigned long long)bd_phys);
 
 	/* Allocate space for descriptor status FIFO */
-	sts_size = (bd_num >= TSI721_DMA_MINSTSSZ) ?
-					bd_num : TSI721_DMA_MINSTSSZ;
+	sts_size = ((bd_num + 1) >= TSI721_DMA_MINSTSSZ) ?
+					(bd_num + 1) : TSI721_DMA_MINSTSSZ;
 	sts_size = roundup_pow_of_two(sts_size);
 	sts_ptr = dma_zalloc_coherent(dev,
 				     sts_size * sizeof(struct tsi721_dma_sts),
@@ -94,7 +112,7 @@ static int tsi721_bdma_ch_init(struct ts
 	if (!sts_ptr) {
 		/* Free space allocated for DMA descriptors */
 		dma_free_coherent(dev,
-				  bd_num * sizeof(struct tsi721_dma_desc),
+				  (bd_num + 1) * sizeof(struct tsi721_dma_desc),
 				  bd_ptr, bd_phys);
 		bdma_chan->bd_base = NULL;
 		return -ENOMEM;
@@ -108,11 +126,11 @@ static int tsi721_bdma_ch_init(struct ts
 		"desc status FIFO @ %p (phys = %llx) size=0x%x\n",
 		sts_ptr, (unsigned long long)sts_phys, sts_size);
 
-	/* Initialize DMA descriptors ring */
-	bd_ptr[bd_num - 1].type_id = cpu_to_le32(DTYPE3 << 29);
-	bd_ptr[bd_num - 1].next_lo = cpu_to_le32((u64)bd_phys &
+	/* Initialize DMA descriptors ring using added link descriptor */
+	bd_ptr[bd_num].type_id = cpu_to_le32(DTYPE3 << 29);
+	bd_ptr[bd_num].next_lo = cpu_to_le32((u64)bd_phys &
 						 TSI721_DMAC_DPTRL_MASK);
-	bd_ptr[bd_num - 1].next_hi = cpu_to_le32((u64)bd_phys >> 32);
+	bd_ptr[bd_num].next_hi = cpu_to_le32((u64)bd_phys >> 32);
 
 	/* Setup DMA descriptor pointers */
 	iowrite32(((u64)bd_phys >> 32),
@@ -134,6 +152,55 @@ static int tsi721_bdma_ch_init(struct ts
 
 	ioread32(bdma_chan->regs + TSI721_DMAC_INT);
 
+#ifdef CONFIG_PCI_MSI
+	/* Request interrupt service if we are in MSI-X mode */
+	if (priv->flags & TSI721_USING_MSIX) {
+		int rc, idx;
+
+		idx = TSI721_VECT_DMA0_DONE + bdma_chan->id;
+
+		rc = request_irq(priv->msix[idx].vector, tsi721_bdma_msix, 0,
+				 priv->msix[idx].irq_name, (void *)bdma_chan);
+
+		if (rc) {
+			dev_dbg(dev, "Unable to get MSI-X for BDMA%d-DONE\n",
+				bdma_chan->id);
+			goto err_out;
+		}
+
+		idx = TSI721_VECT_DMA0_INT + bdma_chan->id;
+
+		rc = request_irq(priv->msix[idx].vector, tsi721_bdma_msix, 0,
+				priv->msix[idx].irq_name, (void *)bdma_chan);
+
+		if (rc)	{
+			dev_dbg(dev, "Unable to get MSI-X for BDMA%d-INT\n",
+				bdma_chan->id);
+			free_irq(
+				priv->msix[TSI721_VECT_DMA0_DONE +
+					    bdma_chan->id].vector,
+				(void *)bdma_chan);
+		}
+
+err_out:
+		if (rc) {
+			/* Free space allocated for DMA descriptors */
+			dma_free_coherent(dev,
+				(bd_num + 1) * sizeof(struct tsi721_dma_desc),
+				bd_ptr, bd_phys);
+			bdma_chan->bd_base = NULL;
+
+			/* Free space allocated for status descriptors */
+			dma_free_coherent(dev,
+				sts_size * sizeof(struct tsi721_dma_sts),
+				sts_ptr, sts_phys);
+			bdma_chan->sts_base = NULL;
+
+			return -EIO;
+		}
+	}
+#endif /* CONFIG_PCI_MSI */
+
 	/* Toggle DMA channel initialization */
 	iowrite32(TSI721_DMAC_CTL_INIT,	bdma_chan->regs + TSI721_DMAC_CTL);
 	ioread32(bdma_chan->regs + TSI721_DMAC_CTL);
@@ -147,6 +214,9 @@ static int tsi721_bdma_ch_init(struct ts
 static int tsi721_bdma_ch_free(struct tsi721_bdma_chan *bdma_chan)
 {
 	u32 ch_stat;
+#ifdef CONFIG_PCI_MSI
+	struct tsi721_device *priv = to_tsi721(bdma_chan->dchan.device);
+#endif
 
 	if (bdma_chan->bd_base == NULL)
 		return 0;
@@ -159,9 +229,18 @@ static int tsi721_bdma_ch_free(struct ts
 	/* Put DMA channel into init state */
 	iowrite32(TSI721_DMAC_CTL_INIT,	bdma_chan->regs + TSI721_DMAC_CTL);
 
+#ifdef CONFIG_PCI_MSI
+	if (priv->flags & TSI721_USING_MSIX) {
+		free_irq(priv->msix[TSI721_VECT_DMA0_DONE +
+				    bdma_chan->id].vector, (void *)bdma_chan);
+		free_irq(priv->msix[TSI721_VECT_DMA0_INT +
+				    bdma_chan->id].vector, (void *)bdma_chan);
+	}
+#endif /* CONFIG_PCI_MSI */
+
 	/* Free space allocated for DMA descriptors */
 	dma_free_coherent(bdma_chan->dchan.device->dev,
-		bdma_chan->bd_num * sizeof(struct tsi721_dma_desc),
+		(bdma_chan->bd_num + 1) * sizeof(struct tsi721_dma_desc),
 		bdma_chan->bd_base, bdma_chan->bd_phys);
 	bdma_chan->bd_base = NULL;
 
@@ -243,8 +322,8 @@ static void tsi721_start_dma(struct tsi7
 	}
 
 	dev_dbg(bdma_chan->dchan.device->dev,
-		"tx_chan: %p, chan: %d, regs: %p\n",
-		bdma_chan, bdma_chan->dchan.chan_id, bdma_chan->regs);
+		"%s: chan_%d (wrc=%d)\n", __func__, bdma_chan->id,
+		bdma_chan->wr_count_next);
 
 	iowrite32(bdma_chan->wr_count_next,
 		bdma_chan->regs + TSI721_DMAC_DWRCNT);
@@ -253,72 +332,19 @@ static void tsi721_start_dma(struct tsi7
 	bdma_chan->wr_count = bdma_chan->wr_count_next;
 }
 
-static void tsi721_desc_put(struct tsi721_bdma_chan *bdma_chan,
-			    struct tsi721_tx_desc *desc)
-{
-	dev_dbg(bdma_chan->dchan.device->dev,
-		"Put desc: %p into free list\n", desc);
-
-	if (desc) {
-		spin_lock_bh(&bdma_chan->lock);
-		list_splice_init(&desc->tx_list, &bdma_chan->free_list);
-		list_add(&desc->desc_node, &bdma_chan->free_list);
-		bdma_chan->wr_count_next = bdma_chan->wr_count;
-		spin_unlock_bh(&bdma_chan->lock);
-	}
-}
-
-static
-struct tsi721_tx_desc *tsi721_desc_get(struct tsi721_bdma_chan *bdma_chan)
-{
-	struct tsi721_tx_desc *tx_desc, *_tx_desc;
-	struct tsi721_tx_desc *ret = NULL;
-	int i;
-
-	spin_lock_bh(&bdma_chan->lock);
-	list_for_each_entry_safe(tx_desc, _tx_desc,
-				 &bdma_chan->free_list, desc_node) {
-		if (async_tx_test_ack(&tx_desc->txd)) {
-			list_del(&tx_desc->desc_node);
-			ret = tx_desc;
-			break;
-		}
-		dev_dbg(bdma_chan->dchan.device->dev,
-			"desc %p not ACKed\n", tx_desc);
-	}
-
-	if (ret == NULL) {
-		dev_dbg(bdma_chan->dchan.device->dev,
-			"%s: unable to obtain tx descriptor\n", __func__);
-		goto err_out;
-	}
-
-	i = bdma_chan->wr_count_next % bdma_chan->bd_num;
-	if (i == bdma_chan->bd_num - 1) {
-		i = 0;
-		bdma_chan->wr_count_next++; /* skip link descriptor */
-	}
-
-	bdma_chan->wr_count_next++;
-	tx_desc->txd.phys = bdma_chan->bd_phys +
-				i * sizeof(struct tsi721_dma_desc);
-	tx_desc->hw_desc = &((struct tsi721_dma_desc *)bdma_chan->bd_base)[i];
-err_out:
-	spin_unlock_bh(&bdma_chan->lock);
-
-	return ret;
-}
-
 static int
-tsi721_desc_fill_init(struct tsi721_tx_desc *desc, struct scatterlist *sg,
-	enum dma_rtype rtype, u32 sys_size)
+tsi721_desc_fill_init(struct tsi721_tx_desc *desc,
+		      struct tsi721_dma_desc *bd_ptr,
+		      struct scatterlist *sg, u32 sys_size)
 {
-	struct tsi721_dma_desc *bd_ptr = desc->hw_desc;
 	u64 rio_addr;
 
+	if (bd_ptr == NULL)
+		return -EINVAL;
+
 	/* Initialize DMA descriptor */
 	bd_ptr->type_id = cpu_to_le32((DTYPE1 << 29) |
-					(rtype << 19) | desc->destid);
+				      (desc->rtype << 19) | desc->destid);
 	bd_ptr->bcount = cpu_to_le32(((desc->rio_addr & 0x3) << 30) |
 				     (sys_size << 26));
 	rio_addr = (desc->rio_addr >> 2) |
@@ -335,51 +361,32 @@ tsi721_desc_fill_init(struct tsi721_tx_d
 }
 
 static int
-tsi721_desc_fill_end(struct tsi721_tx_desc *desc)
+tsi721_desc_fill_end(struct tsi721_dma_desc *bd_ptr, u32 bcount, bool interrupt)
 {
-	struct tsi721_dma_desc *bd_ptr = desc->hw_desc;
+	if (bd_ptr == NULL)
+		return -EINVAL;
 
 	/* Update DMA descriptor */
-	if (desc->interrupt)
+	if (interrupt)
 		bd_ptr->type_id |= cpu_to_le32(TSI721_DMAD_IOF);
-	bd_ptr->bcount |= cpu_to_le32(desc->bcount & TSI721_DMAD_BCOUNT1);
+	bd_ptr->bcount |= cpu_to_le32(bcount & TSI721_DMAD_BCOUNT1);
 
 	return 0;
 }
 
-
-static void tsi721_dma_chain_complete(struct tsi721_bdma_chan *bdma_chan,
-				      struct tsi721_tx_desc *desc)
+static void tsi721_dma_tx_err(struct tsi721_bdma_chan *bdma_chan,
+			      struct tsi721_tx_desc *desc)
 {
 	struct dma_async_tx_descriptor *txd = &desc->txd;
 	dma_async_tx_callback callback = txd->callback;
 	void *param = txd->callback_param;
 
-	list_splice_init(&desc->tx_list, &bdma_chan->free_list);
 	list_move(&desc->desc_node, &bdma_chan->free_list);
-	bdma_chan->completed_cookie = txd->cookie;
 
 	if (callback)
 		callback(param);
 }
 
-static void tsi721_dma_complete_all(struct tsi721_bdma_chan *bdma_chan)
-{
-	struct tsi721_tx_desc *desc, *_d;
-	LIST_HEAD(list);
-
-	BUG_ON(!tsi721_dma_is_idle(bdma_chan));
-
-	if (!list_empty(&bdma_chan->queue))
-		tsi721_start_dma(bdma_chan);
-
-	list_splice_init(&bdma_chan->active_list, &list);
-	list_splice_init(&bdma_chan->queue, &bdma_chan->active_list);
-
-	list_for_each_entry_safe(desc, _d, &list, desc_node)
-		tsi721_dma_chain_complete(bdma_chan, desc);
-}
-
 static void tsi721_clr_stat(struct tsi721_bdma_chan *bdma_chan)
 {
 	u32 srd_ptr;
@@ -403,20 +410,159 @@ static void tsi721_clr_stat(struct tsi72
 	bdma_chan->sts_rdptr = srd_ptr;
 }
 
+/* Must be called with the channel spinlock held */
+static int tsi721_submit_sg(struct tsi721_tx_desc *desc)
+{
+	struct dma_chan *dchan = desc->txd.chan;
+	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
+	u32 sys_size;
+	u64 rio_addr;
+	dma_addr_t next_addr;
+	u32 bcount;
+	struct scatterlist *sg;
+	unsigned int i;
+	int err = 0;
+	struct tsi721_dma_desc *bd_ptr = NULL;
+	u32 idx, rd_idx;
+	u32 add_count = 0;
+
+	if (!tsi721_dma_is_idle(bdma_chan)) {
+		dev_err(bdma_chan->dchan.device->dev,
+			"BUG: Attempt to use non-idle channel\n");
+		return -EIO;
+	}
+
+	/*
+	 * Fill DMA channel's hardware buffer descriptors.
+	 * (NOTE: RapidIO destination address is limited to 64 bits for now)
+	 */
+	rio_addr = desc->rio_addr;
+	next_addr = -1;
+	bcount = 0;
+	sys_size = dma_to_mport(bdma_chan->dchan.device)->sys_size;
+
+	rd_idx = ioread32(bdma_chan->regs + TSI721_DMAC_DRDCNT);
+	rd_idx %= (bdma_chan->bd_num + 1);
+
+	idx = bdma_chan->wr_count_next % (bdma_chan->bd_num + 1);
+	if (idx == bdma_chan->bd_num) {
+		/* wrap around link descriptor */
+		idx = 0;
+		add_count++;
+	}
+
+	dev_dbg(dchan->device->dev, "%s: BD ring status: rdi=%d wri=%d\n",
+		__func__, rd_idx, idx);
+
+	for_each_sg(desc->sg, sg, desc->sg_len, i) {
+
+		dev_dbg(dchan->device->dev, "sg%d/%d addr: 0x%llx len: %d\n",
+			i, desc->sg_len,
+			(unsigned long long)sg_dma_address(sg), sg_dma_len(sg));
+
+		if (sg_dma_len(sg) > TSI721_BDMA_MAX_BCOUNT) {
+			dev_err(dchan->device->dev,
+				"%s: SG entry %d is too large\n", __func__, i);
+			err = -EINVAL;
+			break;
+		}
+
+		/*
+		 * If this sg entry forms contiguous block with previous one,
+		 * try to merge it into existing DMA descriptor
+		 */
+		if (next_addr == sg_dma_address(sg) &&
+		    bcount + sg_dma_len(sg) <= TSI721_BDMA_MAX_BCOUNT) {
+			/* Adjust byte count of the descriptor */
+			bcount += sg_dma_len(sg);
+			goto entry_done;
+		} else if (next_addr != -1) {
+			/* Finalize descriptor using total byte count value */
+			tsi721_desc_fill_end(bd_ptr, bcount, 0);
+			dev_dbg(dchan->device->dev,
+				"%s: prev desc final len: %d\n",
+				__func__, bcount);
+		}
+
+		desc->rio_addr = rio_addr;
+
+		if (i && idx == rd_idx) {
+			dev_dbg(dchan->device->dev,
+				"%s: HW descriptor ring is full @ %d\n",
+				__func__, i);
+			desc->sg = sg;
+			desc->sg_len -= i;
+			break;
+		}
+
+		bd_ptr = &((struct tsi721_dma_desc *)bdma_chan->bd_base)[idx];
+		err = tsi721_desc_fill_init(desc, bd_ptr, sg, sys_size);
+		if (err) {
+			dev_err(dchan->device->dev,
+				"Failed to build desc: err=%d\n", err);
+			break;
+		}
+
+		dev_dbg(dchan->device->dev, "bd_ptr = %p did=%d raddr=0x%llx\n",
+			bd_ptr, desc->destid, desc->rio_addr);
+
+		next_addr = sg_dma_address(sg);
+		bcount = sg_dma_len(sg);
+
+		add_count++;
+		if (++idx == bdma_chan->bd_num) {
+			/* wrap around link descriptor */
+			idx = 0;
+			add_count++;
+		}
+
+entry_done:
+		if (sg_is_last(sg)) {
+			tsi721_desc_fill_end(bd_ptr, bcount, 0);
+			dev_dbg(dchan->device->dev, "%s: last desc final len: %d\n",
+				__func__, bcount);
+			desc->sg_len = 0;
+		} else {
+			rio_addr += sg_dma_len(sg);
+			next_addr += sg_dma_len(sg);
+		}
+	}
+
+	if (!err)
+		bdma_chan->wr_count_next += add_count;
+
+	return err;
+}
+
 static void tsi721_advance_work(struct tsi721_bdma_chan *bdma_chan)
 {
-	if (list_empty(&bdma_chan->active_list) ||
-		list_is_singular(&bdma_chan->active_list)) {
-		dev_dbg(bdma_chan->dchan.device->dev,
-			"%s: Active_list empty\n", __func__);
-		tsi721_dma_complete_all(bdma_chan);
-	} else {
-		dev_dbg(bdma_chan->dchan.device->dev,
-			"%s: Active_list NOT empty\n", __func__);
-		tsi721_dma_chain_complete(bdma_chan,
-					tsi721_dma_first_active(bdma_chan));
-		tsi721_start_dma(bdma_chan);
+	struct tsi721_tx_desc *desc;
+	int err;
+
+	dev_dbg(bdma_chan->dchan.device->dev, "%s: Enter\n", __func__);
+
+	/*
+	 * If there are any new transactions in the queue add them
+	 * into the processing list
+	 */
+	if (!list_empty(&bdma_chan->queue))
+		list_splice_init(&bdma_chan->queue, &bdma_chan->active_list);
+
+	/* Start new transaction (if available) */
+	if (!list_empty(&bdma_chan->active_list)) {
+		desc = tsi721_dma_first_active(bdma_chan);
+		err = tsi721_submit_sg(desc);
+		if (!err)
+			tsi721_start_dma(bdma_chan);
+		else {
+			tsi721_dma_tx_err(bdma_chan, desc);
+			dev_dbg(bdma_chan->dchan.device->dev,
+				"ERR: tsi721_submit_sg failed with err=%d\n",
+				err);
+		}
 	}
+
+	dev_dbg(bdma_chan->dchan.device->dev, "%s: Exit\n", __func__);
 }
 
 static void tsi721_dma_tasklet(unsigned long data)
@@ -444,8 +590,29 @@ static void tsi721_dma_tasklet(unsigned
 	}
 
 	if (dmac_int & (TSI721_DMAC_INT_DONE | TSI721_DMAC_INT_IOFDONE)) {
+		struct tsi721_tx_desc *desc;
+
 		tsi721_clr_stat(bdma_chan);
 		spin_lock(&bdma_chan->lock);
+		desc = tsi721_dma_first_active(bdma_chan);
+
+		if (desc->sg_len == 0) {
+			dma_async_tx_callback callback = NULL;
+			void *param = NULL;
+
+			desc->status = DMA_COMPLETE;
+			dma_cookie_complete(&desc->txd);
+			if (desc->txd.flags & DMA_PREP_INTERRUPT) {
+				callback = desc->txd.callback;
+				param = desc->txd.callback_param;
+			}
+			list_move(&desc->desc_node, &bdma_chan->free_list);
+			spin_unlock(&bdma_chan->lock);
+			if (callback)
+				callback(param);
+			spin_lock(&bdma_chan->lock);
+		}
+
 		tsi721_advance_work(bdma_chan);
 		spin_unlock(&bdma_chan->lock);
 	}
@@ -460,21 +627,24 @@ static dma_cookie_t tsi721_tx_submit(str
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(txd->chan);
 	dma_cookie_t cookie;
 
+	/* Check if the descriptor is detached from any lists */
+	if (!list_empty(&desc->desc_node)) {
+		dev_err(bdma_chan->dchan.device->dev,
+			"%s: wrong state of descriptor %p\n", __func__, txd);
+		return -EIO;
+	}
+
 	spin_lock_bh(&bdma_chan->lock);
 
-	cookie = txd->chan->cookie;
-	if (++cookie < 0)
-		cookie = 1;
-	txd->chan->cookie = cookie;
-	txd->cookie = cookie;
-
-	if (list_empty(&bdma_chan->active_list)) {
-		list_add_tail(&desc->desc_node, &bdma_chan->active_list);
-		tsi721_start_dma(bdma_chan);
-	} else {
-		list_add_tail(&desc->desc_node, &bdma_chan->queue);
+	if (!bdma_chan->active) {
+		spin_unlock_bh(&bdma_chan->lock);
+		return -ENODEV;
 	}
 
+	cookie = dma_cookie_assign(txd);
+	desc->status = DMA_IN_PROGRESS;
+	list_add_tail(&desc->desc_node, &bdma_chan->queue);
+
 	spin_unlock_bh(&bdma_chan->lock);
 	return cookie;
 }
@@ -482,115 +652,52 @@ static dma_cookie_t tsi721_tx_submit(str
 static int tsi721_alloc_chan_resources(struct dma_chan *dchan)
 {
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
-#ifdef CONFIG_PCI_MSI
-	struct tsi721_device *priv = to_tsi721(dchan->device);
-#endif
 	struct tsi721_tx_desc *desc = NULL;
-	LIST_HEAD(tmp_list);
 	int i;
-	int rc;
+
+	dev_dbg(dchan->device->dev, "%s: for channel %d\n",
+		__func__, bdma_chan->id);
 
 	if (bdma_chan->bd_base)
-		return bdma_chan->bd_num - 1;
+		return TSI721_DMA_TX_QUEUE_SZ;
 
 	/* Initialize BDMA channel */
-	if (tsi721_bdma_ch_init(bdma_chan)) {
+	if (tsi721_bdma_ch_init(bdma_chan, dma_desc_per_channel)) {
 		dev_err(dchan->device->dev, "Unable to initialize data DMA"
 			" channel %d, aborting\n", bdma_chan->id);
-		return -ENOMEM;
+		return -ENODEV;
 	}
 
-	/* Alocate matching number of logical descriptors */
-	desc = kcalloc((bdma_chan->bd_num - 1), sizeof(struct tsi721_tx_desc),
+	/* Allocate queue of transaction descriptors */
+	desc = kcalloc(TSI721_DMA_TX_QUEUE_SZ, sizeof(struct tsi721_tx_desc),
 			GFP_KERNEL);
 	if (!desc) {
 		dev_err(dchan->device->dev,
 			"Failed to allocate logical descriptors\n");
-		rc = -ENOMEM;
-		goto err_out;
+		tsi721_bdma_ch_free(bdma_chan);
+		return -ENOMEM;
 	}
 
 	bdma_chan->tx_desc = desc;
 
-	for (i = 0; i < bdma_chan->bd_num - 1; i++) {
+	for (i = 0; i < TSI721_DMA_TX_QUEUE_SZ; i++) {
 		dma_async_tx_descriptor_init(&desc[i].txd, dchan);
 		desc[i].txd.tx_submit = tsi721_tx_submit;
 		desc[i].txd.flags = DMA_CTRL_ACK;
-		INIT_LIST_HEAD(&desc[i].tx_list);
-		list_add_tail(&desc[i].desc_node, &tmp_list);
+		list_add(&desc[i].desc_node, &bdma_chan->free_list);
 	}
 
-	spin_lock_bh(&bdma_chan->lock);
-	list_splice(&tmp_list, &bdma_chan->free_list);
-	bdma_chan->completed_cookie = dchan->cookie = 1;
-	spin_unlock_bh(&bdma_chan->lock);
-
-#ifdef CONFIG_PCI_MSI
-	if (priv->flags & TSI721_USING_MSIX) {
-		/* Request interrupt service if we are in MSI-X mode */
-		rc = request_irq(
-			priv->msix[TSI721_VECT_DMA0_DONE +
-				   bdma_chan->id].vector,
-			tsi721_bdma_msix, 0,
-			priv->msix[TSI721_VECT_DMA0_DONE +
-				   bdma_chan->id].irq_name,
-			(void *)bdma_chan);
-
-		if (rc) {
-			dev_dbg(dchan->device->dev,
-				"Unable to allocate MSI-X interrupt for "
-				"BDMA%d-DONE\n", bdma_chan->id);
-			goto err_out;
-		}
-
-		rc = request_irq(priv->msix[TSI721_VECT_DMA0_INT +
-					    bdma_chan->id].vector,
-				tsi721_bdma_msix, 0,
-				priv->msix[TSI721_VECT_DMA0_INT +
-					   bdma_chan->id].irq_name,
-				(void *)bdma_chan);
-
-		if (rc)	{
-			dev_dbg(dchan->device->dev,
-				"Unable to allocate MSI-X interrupt for "
-				"BDMA%d-INT\n", bdma_chan->id);
-			free_irq(
-				priv->msix[TSI721_VECT_DMA0_DONE +
-					   bdma_chan->id].vector,
-				(void *)bdma_chan);
-			rc = -EIO;
-			goto err_out;
-		}
-	}
-#endif /* CONFIG_PCI_MSI */
+	dma_cookie_init(dchan);
 
 	bdma_chan->active = true;
 	tsi721_bdma_interrupt_enable(bdma_chan, 1);
 
-	return bdma_chan->bd_num - 1;
-
-err_out:
-	kfree(desc);
-	tsi721_bdma_ch_free(bdma_chan);
-	return rc;
+	return TSI721_DMA_TX_QUEUE_SZ;
 }
 
-static void tsi721_free_chan_resources(struct dma_chan *dchan)
+static void tsi721_sync_dma_irq(struct tsi721_bdma_chan *bdma_chan)
 {
-	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
-	struct tsi721_device *priv = to_tsi721(dchan->device);
-	LIST_HEAD(list);
-
-	dev_dbg(dchan->device->dev, "%s: Entry\n", __func__);
-
-	if (bdma_chan->bd_base == NULL)
-		return;
-
-	BUG_ON(!list_empty(&bdma_chan->active_list));
-	BUG_ON(!list_empty(&bdma_chan->queue));
-
-	tsi721_bdma_interrupt_enable(bdma_chan, 0);
-	bdma_chan->active = false;
+	struct tsi721_device *priv = to_tsi721(bdma_chan->dchan.device);
 
 #ifdef CONFIG_PCI_MSI
 	if (priv->flags & TSI721_USING_MSIX) {
@@ -601,64 +708,48 @@ static void tsi721_free_chan_resources(s
 	} else
 #endif
 	synchronize_irq(priv->pdev->irq);
+}
 
-	tasklet_kill(&bdma_chan->tasklet);
+static void tsi721_free_chan_resources(struct dma_chan *dchan)
+{
+	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
 
-	spin_lock_bh(&bdma_chan->lock);
-	list_splice_init(&bdma_chan->free_list, &list);
-	spin_unlock_bh(&bdma_chan->lock);
+	dev_dbg(dchan->device->dev, "%s: for channel %d\n",
+		__func__, bdma_chan->id);
 
-#ifdef CONFIG_PCI_MSI
-	if (priv->flags & TSI721_USING_MSIX) {
-		free_irq(priv->msix[TSI721_VECT_DMA0_DONE +
-				    bdma_chan->id].vector, (void *)bdma_chan);
-		free_irq(priv->msix[TSI721_VECT_DMA0_INT +
-				    bdma_chan->id].vector, (void *)bdma_chan);
-	}
-#endif /* CONFIG_PCI_MSI */
+	if (bdma_chan->bd_base == NULL)
+		return;
 
-	tsi721_bdma_ch_free(bdma_chan);
+	BUG_ON(!list_empty(&bdma_chan->active_list));
+	BUG_ON(!list_empty(&bdma_chan->queue));
+
+	tsi721_bdma_interrupt_enable(bdma_chan, 0);
+	bdma_chan->active = false;
+	tsi721_sync_dma_irq(bdma_chan);
+	tasklet_kill(&bdma_chan->tasklet);
+	INIT_LIST_HEAD(&bdma_chan->free_list);
 	kfree(bdma_chan->tx_desc);
+	tsi721_bdma_ch_free(bdma_chan);
 }
 
 static
 enum dma_status tsi721_tx_status(struct dma_chan *dchan, dma_cookie_t cookie,
 				 struct dma_tx_state *txstate)
 {
-	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
-	dma_cookie_t		last_used;
-	dma_cookie_t		last_completed;
-	int			ret;
-
-	spin_lock_bh(&bdma_chan->lock);
-	last_completed = bdma_chan->completed_cookie;
-	last_used = dchan->cookie;
-	spin_unlock_bh(&bdma_chan->lock);
-
-	ret = dma_async_is_complete(cookie, last_completed, last_used);
-
-	dma_set_tx_state(txstate, last_completed, last_used, 0);
-
-	dev_dbg(dchan->device->dev,
-		"%s: exit, ret: %d, last_completed: %d, last_used: %d\n",
-		__func__, ret, last_completed, last_used);
-
-	return ret;
+	return dma_cookie_status(dchan, cookie, txstate);
 }
 
 static void tsi721_issue_pending(struct dma_chan *dchan)
 {
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
 
-	dev_dbg(dchan->device->dev, "%s: Entry\n", __func__);
+	dev_dbg(dchan->device->dev, "%s: Enter\n", __func__);
 
-	if (tsi721_dma_is_idle(bdma_chan)) {
+	if (tsi721_dma_is_idle(bdma_chan) && bdma_chan->active) {
 		spin_lock_bh(&bdma_chan->lock);
 		tsi721_advance_work(bdma_chan);
 		spin_unlock_bh(&bdma_chan->lock);
-	} else
-		dev_dbg(dchan->device->dev,
-			"%s: DMA channel still busy\n", __func__);
+	}
 }
 
 static
@@ -668,21 +759,19 @@ struct dma_async_tx_descriptor *tsi721_p
 			void *tinfo)
 {
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
-	struct tsi721_tx_desc *desc = NULL;
-	struct tsi721_tx_desc *first = NULL;
-	struct scatterlist *sg;
+	struct tsi721_tx_desc *desc, *_d;
 	struct rio_dma_ext *rext = tinfo;
-	u64 rio_addr = rext->rio_addr; /* limited to 64-bit rio_addr for now */
-	unsigned int i;
-	u32 sys_size = dma_to_mport(dchan->device)->sys_size;
 	enum dma_rtype rtype;
-	dma_addr_t next_addr = -1;
+	struct dma_async_tx_descriptor *txd = NULL;
 
 	if (!sgl || !sg_len) {
 		dev_err(dchan->device->dev, "%s: No SG list\n", __func__);
 		return NULL;
 	}
 
+	dev_dbg(dchan->device->dev, "%s: %s\n", __func__,
+		(dir == DMA_DEV_TO_MEM)?"READ":"WRITE");
+
 	if (dir == DMA_DEV_TO_MEM)
 		rtype = NREAD;
 	else if (dir == DMA_MEM_TO_DEV) {
@@ -704,97 +793,26 @@ struct dma_async_tx_descriptor *tsi721_p
 		return NULL;
 	}
 
-	for_each_sg(sgl, sg, sg_len, i) {
-		int err;
-
-		if (sg_dma_len(sg) > TSI721_BDMA_MAX_BCOUNT) {
-			dev_err(dchan->device->dev,
-				"%s: SG entry %d is too large\n", __func__, i);
-			goto err_desc_put;
-		}
-
-		/*
-		 * If this sg entry forms contiguous block with previous one,
-		 * try to merge it into existing DMA descriptor
-		 */
-		if (desc) {
-			if (next_addr == sg_dma_address(sg) &&
-			    desc->bcount + sg_dma_len(sg) <=
-						TSI721_BDMA_MAX_BCOUNT) {
-				/* Adjust byte count of the descriptor */
-				desc->bcount += sg_dma_len(sg);
-				goto entry_done;
-			}
-
-			/*
-			 * Finalize this descriptor using total
-			 * byte count value.
-			 */
-			tsi721_desc_fill_end(desc);
-			dev_dbg(dchan->device->dev, "%s: desc final len: %d\n",
-				__func__, desc->bcount);
-		}
-
-		/*
-		 * Obtain and initialize a new descriptor
-		 */
-		desc = tsi721_desc_get(bdma_chan);
-		if (!desc) {
-			dev_err(dchan->device->dev,
-				"%s: Failed to get new descriptor for SG %d\n",
-				__func__, i);
-			goto err_desc_put;
-		}
-
-		desc->destid = rext->destid;
-		desc->rio_addr = rio_addr;
-		desc->rio_addr_u = 0;
-		desc->bcount = sg_dma_len(sg);
-
-		dev_dbg(dchan->device->dev,
-			"sg%d desc: 0x%llx, addr: 0x%llx len: %d\n",
-			i, (u64)desc->txd.phys,
-			(unsigned long long)sg_dma_address(sg),
-			sg_dma_len(sg));
-
-		dev_dbg(dchan->device->dev,
-			"bd_ptr = %p did=%d raddr=0x%llx\n",
-			desc->hw_desc, desc->destid, desc->rio_addr);
-
-		err = tsi721_desc_fill_init(desc, sg, rtype, sys_size);
-		if (err) {
-			dev_err(dchan->device->dev,
-				"Failed to build desc: %d\n", err);
-			goto err_desc_put;
-		}
-
-		next_addr = sg_dma_address(sg);
-
-		if (!first)
-			first = desc;
-		else
-			list_add_tail(&desc->desc_node, &first->tx_list);
+	spin_lock_bh(&bdma_chan->lock);
 
-entry_done:
-		if (sg_is_last(sg)) {
-			desc->interrupt = (flags & DMA_PREP_INTERRUPT) != 0;
-			tsi721_desc_fill_end(desc);
-			dev_dbg(dchan->device->dev, "%s: desc final len: %d\n",
-				__func__, desc->bcount);
-		} else {
-			rio_addr += sg_dma_len(sg);
-			next_addr += sg_dma_len(sg);
+	list_for_each_entry_safe(desc, _d, &bdma_chan->free_list, desc_node) {
+		if (async_tx_test_ack(&desc->txd)) {
+			list_del_init(&desc->desc_node);
+			desc->destid = rext->destid;
+			desc->rio_addr = rext->rio_addr;
+			desc->rio_addr_u = 0;
+			desc->rtype = rtype;
+			desc->sg_len	= sg_len;
+			desc->sg	= sgl;
+			txd		= &desc->txd;
+			txd->flags	= flags;
+			break;
 		}
 	}
 
-	first->txd.cookie = -EBUSY;
-	desc->txd.flags = flags;
-
-	return &first->txd;
+	spin_unlock_bh(&bdma_chan->lock);
 
-err_desc_put:
-	tsi721_desc_put(bdma_chan, first);
-	return NULL;
+	return txd;
 }
 
 static int tsi721_device_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
@@ -802,23 +820,34 @@ static int tsi721_device_control(struct
 {
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
 	struct tsi721_tx_desc *desc, *_d;
+	u32 dmac_int;
 	LIST_HEAD(list);
 
 	dev_dbg(dchan->device->dev, "%s: Entry\n", __func__);
 
 	if (cmd != DMA_TERMINATE_ALL)
-		return -ENXIO;
+		return -ENOSYS;
 
 	spin_lock_bh(&bdma_chan->lock);
 
-	/* make sure to stop the transfer */
-	iowrite32(TSI721_DMAC_CTL_SUSP, bdma_chan->regs + TSI721_DMAC_CTL);
+	bdma_chan->active = false;
+
+	if (!tsi721_dma_is_idle(bdma_chan)) {
+		/* make sure to stop the transfer */
+		iowrite32(TSI721_DMAC_CTL_SUSP,
+			  bdma_chan->regs + TSI721_DMAC_CTL);
+
+		/* Wait until DMA channel stops */
+		do {
+			dmac_int = ioread32(bdma_chan->regs + TSI721_DMAC_INT);
+		} while ((dmac_int & TSI721_DMAC_INT_SUSP) == 0);
+	}
 
 	list_splice_init(&bdma_chan->active_list, &list);
 	list_splice_init(&bdma_chan->queue, &list);
 
 	list_for_each_entry_safe(desc, _d, &list, desc_node)
-		tsi721_dma_chain_complete(bdma_chan, desc);
+		tsi721_dma_tx_err(bdma_chan, desc);
 
 	spin_unlock_bh(&bdma_chan->lock);
 
@@ -828,22 +857,18 @@ static int tsi721_device_control(struct
 int tsi721_register_dma(struct tsi721_device *priv)
 {
 	int i;
-	int nr_channels = TSI721_DMA_MAXCH;
+	int nr_channels = 0;
 	int err;
 	struct rio_mport *mport = priv->mport;
 
-	mport->dma.dev = &priv->pdev->dev;
-	mport->dma.chancnt = nr_channels;
-
 	INIT_LIST_HEAD(&mport->dma.channels);
 
-	for (i = 0; i < nr_channels; i++) {
+	for (i = 0; i < TSI721_DMA_MAXCH; i++) {
 		struct tsi721_bdma_chan *bdma_chan = &priv->bdma[i];
 
 		if (i == TSI721_DMACH_MAINT)
 			continue;
 
-		bdma_chan->bd_num = TSI721_BDMA_BD_RING_SZ;
 		bdma_chan->regs = priv->regs + TSI721_DMAC_BASE(i);
 
 		bdma_chan->dchan.device = &mport->dma;
@@ -862,12 +887,15 @@ int tsi721_register_dma(struct tsi721_de
 			     (unsigned long)bdma_chan);
 		list_add_tail(&bdma_chan->dchan.device_node,
 			      &mport->dma.channels);
+		nr_channels++;
 	}
 
+	mport->dma.chancnt = nr_channels;
 	dma_cap_zero(mport->dma.cap_mask);
 	dma_cap_set(DMA_PRIVATE, mport->dma.cap_mask);
 	dma_cap_set(DMA_SLAVE, mport->dma.cap_mask);
 
+	mport->dma.dev = &priv->pdev->dev;
 	mport->dma.device_alloc_chan_resources = tsi721_alloc_chan_resources;
 	mport->dma.device_free_chan_resources = tsi721_free_chan_resources;
 	mport->dma.device_tx_status = tsi721_tx_status;
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

