From: akpm@linux-foundation.org
Subject: + i-oat-tighten-descriptor-setup-performance.patch added to -mm tree
Date: Wed, 17 Oct 2007 17:34:30 -0700
Message-ID: <200710180034.l9I0YUfY016114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35712 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760208AbXJRAed (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 20:34:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shannon.nelson@intel.com, dan.j.williams@intel.com


The patch titled
     I/OAT: Tighten descriptor setup performance
has been added to the -mm tree.  Its filename is
     i-oat-tighten-descriptor-setup-performance.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: I/OAT: Tighten descriptor setup performance
From: Shannon Nelson <shannon.nelson@intel.com>

The change to the async_tx interface cost this driver some performance by
spreading the descriptor setup across several functions, including multiple
passes over the new descriptor chain.  Here we bring the work back into one
primary function and only do one pass.

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat_dma.c |  170 ++++++++++++++++++++-------------------
 drivers/dma/ioatdma.h  |    6 -
 2 files changed, 93 insertions(+), 83 deletions(-)

diff -puN drivers/dma/ioat_dma.c~i-oat-tighten-descriptor-setup-performance drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~i-oat-tighten-descriptor-setup-performance
+++ a/drivers/dma/ioat_dma.c
@@ -46,9 +46,12 @@
 /* internal functions */
 static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan);
 static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
+static inline struct ioat_desc_sw *ioat_dma_get_next_descriptor(
+					      struct ioat_dma_chan *ioat_chan);
 
-static struct ioat_dma_chan *ioat_lookup_chan_by_index(struct ioatdma_device *device,
-						       int index)
+static inline struct ioat_dma_chan *ioat_lookup_chan_by_index(
+						struct ioatdma_device *device,
+						int index)
 {
 	return device->idx[index];
 }
@@ -148,57 +151,90 @@ static void ioat_set_src(dma_addr_t addr
 			 struct dma_async_tx_descriptor *tx,
 			 int index)
 {
-	struct ioat_desc_sw *iter, *desc = tx_to_ioat_desc(tx);
-	struct ioat_dma_chan *ioat_chan = to_ioat_chan(tx->chan);
-
-	pci_unmap_addr_set(desc, src, addr);
-
-	list_for_each_entry(iter, &desc->async_tx.tx_list, node) {
-		iter->hw->src_addr = addr;
-		addr += ioat_chan->xfercap;
-	}
-
+	tx_to_ioat_desc(tx)->src = addr;
 }
 
 static void ioat_set_dest(dma_addr_t addr,
 			  struct dma_async_tx_descriptor *tx,
 			  int index)
 {
-	struct ioat_desc_sw *iter, *desc = tx_to_ioat_desc(tx);
-	struct ioat_dma_chan *ioat_chan = to_ioat_chan(tx->chan);
-
-	pci_unmap_addr_set(desc, dst, addr);
-
-	list_for_each_entry(iter, &desc->async_tx.tx_list, node) {
-		iter->hw->dst_addr = addr;
-		addr += ioat_chan->xfercap;
-	}
+	tx_to_ioat_desc(tx)->dst = addr;
 }
 
 static dma_cookie_t ioat_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(tx->chan);
-	struct ioat_desc_sw *desc = tx_to_ioat_desc(tx);
+	struct ioat_desc_sw *first = tx_to_ioat_desc(tx);
+	struct ioat_desc_sw *prev, *new;
+	struct ioat_dma_descriptor *hw;
 	int append = 0;
 	dma_cookie_t cookie;
-	struct ioat_desc_sw *group_start;
+	LIST_HEAD(new_chain);
+	u32 copy;
+	size_t len;
+	dma_addr_t src, dst;
+	int orig_ack;
+	unsigned int desc_count = 0;
+
+	/* src and dest and len are stored in the initial descriptor */
+	len = first->len;
+	src = first->src;
+	dst = first->dst;
+	orig_ack = first->async_tx.ack;
+	new = first;
 
-	group_start = list_entry(desc->async_tx.tx_list.next,
-				 struct ioat_desc_sw, node);
 	spin_lock_bh(&ioat_chan->desc_lock);
+	prev = to_ioat_desc(ioat_chan->used_desc.prev);
+	prefetch(prev->hw);
+	do {
+		copy = min((u32) len, ioat_chan->xfercap);
+
+		new->async_tx.ack = 1;
+
+		hw = new->hw;
+		hw->size = copy;
+		hw->ctl = 0;
+		hw->src_addr = src;
+		hw->dst_addr = dst;
+		hw->next = 0;
+
+		/* chain together the physical address list for the HW */
+		wmb();
+		prev->hw->next = (u64) new->async_tx.phys;
+
+		len -= copy;
+		dst += copy;
+		src += copy;
+
+		list_add_tail(&new->node, &new_chain);
+		desc_count++;
+		prev = new;
+	} while (len && (new = ioat_dma_get_next_descriptor(ioat_chan)));
+
+	hw->ctl = IOAT_DMA_DESCRIPTOR_CTL_CP_STS;
+	new->tx_cnt = desc_count;
+	new->async_tx.ack = orig_ack; /* client is in control of this ack */
+
+	/* store the original values for use in later cleanup */
+	if (new != first) {
+		new->src = first->src;
+		new->dst = first->dst;
+		new->len = first->len;
+	}
+
 	/* cookie incr and addition to used_list must be atomic */
 	cookie = ioat_chan->common.cookie;
 	cookie++;
 	if (cookie < 0)
 		cookie = 1;
-	ioat_chan->common.cookie = desc->async_tx.cookie = cookie;
+	ioat_chan->common.cookie = new->async_tx.cookie = cookie;
 
 	/* write address into NextDescriptor field of last desc in chain */
 	to_ioat_desc(ioat_chan->used_desc.prev)->hw->next =
-						group_start->async_tx.phys;
-	list_splice_init(&desc->async_tx.tx_list, ioat_chan->used_desc.prev);
+							first->async_tx.phys;
+	__list_splice(&new_chain, ioat_chan->used_desc.prev);
 
-	ioat_chan->pending += desc->tx_cnt;
+	ioat_chan->pending += desc_count;
 	if (ioat_chan->pending >= 4) {
 		append = 1;
 		ioat_chan->pending = 0;
@@ -356,7 +392,7 @@ static void ioat_dma_free_chan_resources
  * channel's desc_lock held.  Allocates more descriptors if the channel
  * has run out.
  */
-static struct ioat_desc_sw *ioat_dma_get_next_descriptor(
+static inline struct ioat_desc_sw *ioat_dma_get_next_descriptor(
 						struct ioat_dma_chan *ioat_chan)
 {
 	struct ioat_desc_sw *new = NULL;
@@ -382,51 +418,11 @@ static struct dma_async_tx_descriptor *i
 						int int_en)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
-	struct ioat_desc_sw *first, *prev, *new;
-	LIST_HEAD(new_chain);
-	u32 copy;
-	size_t orig_len;
-	int desc_count = 0;
-
-	if (!len)
-		return NULL;
-
-	orig_len = len;
-
-	first = NULL;
-	prev = NULL;
+	struct ioat_desc_sw *new;
 
 	spin_lock_bh(&ioat_chan->desc_lock);
-	while (len) {
-		new = ioat_dma_get_next_descriptor(ioat_chan);
-		copy = min((u32) len, ioat_chan->xfercap);
-
-		new->hw->size = copy;
-		new->hw->ctl = 0;
-		new->async_tx.cookie = 0;
-		new->async_tx.ack = 1;
-
-		/* chain together the physical address list for the HW */
-		if (!first)
-			first = new;
-		else
-			prev->hw->next = (u64) new->async_tx.phys;
-
-		prev = new;
-		len  -= copy;
-		list_add_tail(&new->node, &new_chain);
-		desc_count++;
-	}
-
-	list_splice(&new_chain, &new->async_tx.tx_list);
-
-	new->hw->ctl = IOAT_DMA_DESCRIPTOR_CTL_CP_STS;
-	new->hw->next = 0;
-	new->tx_cnt = desc_count;
-	new->async_tx.ack = 0; /* client is in control of this ack */
-	new->async_tx.cookie = -EBUSY;
-
-	pci_unmap_len_set(new, len, orig_len);
+	new = ioat_dma_get_next_descriptor(ioat_chan);
+	new->len = len;
 	spin_unlock_bh(&ioat_chan->desc_lock);
 
 	return new ? &new->async_tx : NULL;
@@ -464,7 +460,7 @@ static void ioat_dma_memcpy_cleanup(stru
 
 	prefetch(ioat_chan->completion_virt);
 
-	if (!spin_trylock(&ioat_chan->cleanup_lock))
+	if (!spin_trylock_bh(&ioat_chan->cleanup_lock))
 		return;
 
 	/* The completion writeback can happen at any time,
@@ -474,12 +470,15 @@ static void ioat_dma_memcpy_cleanup(stru
 
 #if (BITS_PER_LONG == 64)
 	phys_complete =
-	ioat_chan->completion_virt->full & IOAT_CHANSTS_COMPLETED_DESCRIPTOR_ADDR;
+		ioat_chan->completion_virt->full
+		& IOAT_CHANSTS_COMPLETED_DESCRIPTOR_ADDR;
 #else
-	phys_complete = ioat_chan->completion_virt->low & IOAT_LOW_COMPLETION_MASK;
+	phys_complete =
+		ioat_chan->completion_virt->low & IOAT_LOW_COMPLETION_MASK;
 #endif
 
-	if ((ioat_chan->completion_virt->full & IOAT_CHANSTS_DMA_TRANSFER_STATUS) ==
+	if ((ioat_chan->completion_virt->full
+		& IOAT_CHANSTS_DMA_TRANSFER_STATUS) ==
 				IOAT_CHANSTS_DMA_TRANSFER_STATUS_HALTED) {
 		dev_err(&ioat_chan->device->pdev->dev,
 			"Channel halted, chanerr = %x\n",
@@ -489,7 +488,7 @@ static void ioat_dma_memcpy_cleanup(stru
 	}
 
 	if (phys_complete == ioat_chan->last_completion) {
-		spin_unlock(&ioat_chan->cleanup_lock);
+		spin_unlock_bh(&ioat_chan->cleanup_lock);
 		return;
 	}
 
@@ -548,7 +547,7 @@ static void ioat_dma_memcpy_cleanup(stru
 	if (cookie != 0)
 		ioat_chan->completed_cookie = cookie;
 
-	spin_unlock(&ioat_chan->cleanup_lock);
+	spin_unlock_bh(&ioat_chan->cleanup_lock);
 }
 
 static void ioat_dma_dependency_added(struct dma_chan *chan)
@@ -613,8 +612,13 @@ static void ioat_dma_start_null_desc(str
 	spin_lock_bh(&ioat_chan->desc_lock);
 
 	desc = ioat_dma_get_next_descriptor(ioat_chan);
-	desc->hw->ctl = IOAT_DMA_DESCRIPTOR_NUL;
+	desc->hw->ctl = IOAT_DMA_DESCRIPTOR_NUL
+				| IOAT_DMA_DESCRIPTOR_CTL_INT_GN
+				| IOAT_DMA_DESCRIPTOR_CTL_CP_STS;
 	desc->hw->next = 0;
+	desc->hw->size = 0;
+	desc->hw->src_addr = 0;
+	desc->hw->dst_addr = 0;
 	desc->async_tx.ack = 1;
 
 	list_add_tail(&desc->node, &ioat_chan->used_desc);
@@ -688,6 +692,12 @@ static int ioat_dma_self_test(struct ioa
 			DMA_FROM_DEVICE);
 	ioat_set_dest(addr, tx, 0);
 	cookie = ioat_tx_submit(tx);
+	if (cookie < 0) {
+		dev_err(&device->pdev->dev,
+			"Self-test setup failed, disabling\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
 	ioat_dma_memcpy_issue_pending(dma_chan);
 	msleep(1);
 
diff -puN drivers/dma/ioatdma.h~i-oat-tighten-descriptor-setup-performance drivers/dma/ioatdma.h
--- a/drivers/dma/ioatdma.h~i-oat-tighten-descriptor-setup-performance
+++ a/drivers/dma/ioatdma.h
@@ -124,9 +124,9 @@ struct ioat_desc_sw {
 	struct ioat_dma_descriptor *hw;
 	struct list_head node;
 	int tx_cnt;
-	DECLARE_PCI_UNMAP_LEN(len)
-	DECLARE_PCI_UNMAP_ADDR(src)
-	DECLARE_PCI_UNMAP_ADDR(dst)
+	size_t len;
+	dma_addr_t src;
+	dma_addr_t dst;
 	struct dma_async_tx_descriptor async_tx;
 };
 
_

Patches currently in -mm which might be from shannon.nelson@intel.com are

origin.patch
remove-unsafe-from-module-struct.patch
i-oat-cleanup-pci-issues.patch
i-oat-clean-up-of-dca-provider-start-and-stop.patch
i-oat-clean-up-error-handling-and-some-print-messages.patch
i-oat-tighten-descriptor-setup-performance.patch
