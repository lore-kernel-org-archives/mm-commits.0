From: akpm@linux-foundation.org
Subject: + i-oat-fixups-from-code-comments.patch added to -mm tree
Date: Mon, 19 Nov 2007 16:49:15 -0800
Message-ID: <200711200049.lAK0nFsc005172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50183 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158AbXKTAtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 19:49:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shannon.nelson@intel.com, dan.j.williams@intel.com


The patch titled
     I/OAT: fixups from code comments
has been added to the -mm tree.  Its filename is
     i-oat-fixups-from-code-comments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: I/OAT: fixups from code comments
From: Shannon Nelson <shannon.nelson@intel.com>

A few fixups from Andrew's code comments.
  - removed "static inline" forward-declares
  - changed use of min() to min_t()
  - removed some unnecessary NULL initializations
  - removed a couple of BUG() calls

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat_dma.c |  142 +++++++++++++++++++++------------------
 drivers/dma/ioatdma.h  |    2 
 2 files changed, 78 insertions(+), 66 deletions(-)

diff -puN drivers/dma/ioat_dma.c~i-oat-fixups-from-code-comments drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~i-oat-fixups-from-code-comments
+++ a/drivers/dma/ioat_dma.c
@@ -173,10 +173,47 @@ static void ioat_set_dest(dma_addr_t add
 	tx_to_ioat_desc(tx)->dst = addr;
 }
 
+/**
+ * ioat_dma_memcpy_issue_pending - push potentially unrecognized appended
+ *                                 descriptors to hw
+ * @chan: DMA channel handle
+ */
 static inline void __ioat1_dma_memcpy_issue_pending(
-					       struct ioat_dma_chan *ioat_chan);
+						struct ioat_dma_chan *ioat_chan)
+{
+	ioat_chan->pending = 0;
+	writeb(IOAT_CHANCMD_APPEND, ioat_chan->reg_base + IOAT1_CHANCMD_OFFSET);
+}
+
+static void ioat1_dma_memcpy_issue_pending(struct dma_chan *chan)
+{
+	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
+
+	if (ioat_chan->pending != 0) {
+		spin_lock_bh(&ioat_chan->desc_lock);
+		__ioat1_dma_memcpy_issue_pending(ioat_chan);
+		spin_unlock_bh(&ioat_chan->desc_lock);
+	}
+}
+
 static inline void __ioat2_dma_memcpy_issue_pending(
-					       struct ioat_dma_chan *ioat_chan);
+						struct ioat_dma_chan *ioat_chan)
+{
+	ioat_chan->pending = 0;
+	writew(ioat_chan->dmacount,
+	       ioat_chan->reg_base + IOAT_CHAN_DMACOUNT_OFFSET);
+}
+
+static void ioat2_dma_memcpy_issue_pending(struct dma_chan *chan)
+{
+	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
+
+	if (ioat_chan->pending != 0) {
+		spin_lock_bh(&ioat_chan->desc_lock);
+		__ioat2_dma_memcpy_issue_pending(ioat_chan);
+		spin_unlock_bh(&ioat_chan->desc_lock);
+	}
+}
 
 static dma_cookie_t ioat1_tx_submit(struct dma_async_tx_descriptor *tx)
 {
@@ -203,7 +240,7 @@ static dma_cookie_t ioat1_tx_submit(stru
 	prev = to_ioat_desc(ioat_chan->used_desc.prev);
 	prefetch(prev->hw);
 	do {
-		copy = min((u32) len, ioat_chan->xfercap);
+		copy = min_t(size_t, len, ioat_chan->xfercap);
 
 		new->async_tx.ack = 1;
 
@@ -291,10 +328,12 @@ static dma_cookie_t ioat2_tx_submit(stru
 	orig_ack = first->async_tx.ack;
 	new = first;
 
-	/* ioat_chan->desc_lock is still in force in version 2 path */
-
+	/*
+	 * ioat_chan->desc_lock is still in force in version 2 path
+	 * it gets unlocked at end of this function
+	 */
 	do {
-		copy = min((u32) len, ioat_chan->xfercap);
+		copy = min_t(size_t, len, ioat_chan->xfercap);
 
 		new->async_tx.ack = 1;
 
@@ -432,7 +471,7 @@ static void ioat2_dma_massage_chan_desc(
 static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
-	struct ioat_desc_sw *desc = NULL;
+	struct ioat_desc_sw *desc;
 	u16 chanctrl;
 	u32 chanerr;
 	int i;
@@ -575,7 +614,7 @@ static void ioat_dma_free_chan_resources
 static struct ioat_desc_sw *
 ioat1_dma_get_next_descriptor(struct ioat_dma_chan *ioat_chan)
 {
-	struct ioat_desc_sw *new = NULL;
+	struct ioat_desc_sw *new;
 
 	if (!list_empty(&ioat_chan->free_desc)) {
 		new = to_ioat_desc(ioat_chan->free_desc.next);
@@ -583,9 +622,11 @@ ioat1_dma_get_next_descriptor(struct ioa
 	} else {
 		/* try to get another desc */
 		new = ioat_dma_alloc_descriptor(ioat_chan, GFP_ATOMIC);
-		/* will this ever happen? */
-		/* TODO add upper limit on these */
-		BUG_ON(!new);
+		if (!new) {
+			dev_err(&ioat_chan->device->pdev->dev,
+				"alloc failed\n");
+			return NULL;
+		}
 	}
 
 	prefetch(new->hw);
@@ -595,7 +636,7 @@ ioat1_dma_get_next_descriptor(struct ioa
 static struct ioat_desc_sw *
 ioat2_dma_get_next_descriptor(struct ioat_dma_chan *ioat_chan)
 {
-	struct ioat_desc_sw *new = NULL;
+	struct ioat_desc_sw *new;
 
 	/*
 	 * used.prev points to where to start processing
@@ -609,8 +650,8 @@ ioat2_dma_get_next_descriptor(struct ioa
 	if (ioat_chan->used_desc.prev &&
 	    ioat_chan->used_desc.next == ioat_chan->used_desc.prev->prev) {
 
-		struct ioat_desc_sw *desc = NULL;
-		struct ioat_desc_sw *noop_desc = NULL;
+		struct ioat_desc_sw *desc;
+		struct ioat_desc_sw *noop_desc;
 		int i;
 
 		/* set up the noop descriptor */
@@ -624,10 +665,14 @@ ioat2_dma_get_next_descriptor(struct ioa
 		ioat_chan->pending++;
 		ioat_chan->dmacount++;
 
-		/* get a few more descriptors */
+		/* try to get a few more descriptors */
 		for (i = 16; i; i--) {
 			desc = ioat_dma_alloc_descriptor(ioat_chan, GFP_ATOMIC);
-			BUG_ON(!desc);
+			if (!desc) {
+				dev_err(&ioat_chan->device->pdev->dev,
+					"alloc failed\n");
+				break;
+			}
 			list_add_tail(&desc->node, ioat_chan->used_desc.next);
 
 			desc->hw->next
@@ -677,10 +722,13 @@ static struct dma_async_tx_descriptor *i
 
 	spin_lock_bh(&ioat_chan->desc_lock);
 	new = ioat_dma_get_next_descriptor(ioat_chan);
-	new->len = len;
 	spin_unlock_bh(&ioat_chan->desc_lock);
 
-	return new ? &new->async_tx : NULL;
+	if (new) {
+		new->len = len;
+		return &new->async_tx;
+	} else
+		return NULL;
 }
 
 static struct dma_async_tx_descriptor *ioat2_dma_prep_memcpy(
@@ -693,53 +741,17 @@ static struct dma_async_tx_descriptor *i
 
 	spin_lock_bh(&ioat_chan->desc_lock);
 	new = ioat2_dma_get_next_descriptor(ioat_chan);
-	new->len = len;
-
-	/* leave ioat_chan->desc_lock set in version 2 path */
-	return new ? &new->async_tx : NULL;
-}
-
-
-/**
- * ioat_dma_memcpy_issue_pending - push potentially unrecognized appended
- *                                 descriptors to hw
- * @chan: DMA channel handle
- */
-static inline void __ioat1_dma_memcpy_issue_pending(
-						struct ioat_dma_chan *ioat_chan)
-{
-	ioat_chan->pending = 0;
-	writeb(IOAT_CHANCMD_APPEND, ioat_chan->reg_base + IOAT1_CHANCMD_OFFSET);
-}
-
-static void ioat1_dma_memcpy_issue_pending(struct dma_chan *chan)
-{
-	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
-
-	if (ioat_chan->pending != 0) {
-		spin_lock_bh(&ioat_chan->desc_lock);
-		__ioat1_dma_memcpy_issue_pending(ioat_chan);
-		spin_unlock_bh(&ioat_chan->desc_lock);
-	}
-}
-
-static inline void __ioat2_dma_memcpy_issue_pending(
-						struct ioat_dma_chan *ioat_chan)
-{
-	ioat_chan->pending = 0;
-	writew(ioat_chan->dmacount,
-	       ioat_chan->reg_base + IOAT_CHAN_DMACOUNT_OFFSET);
-}
 
-static void ioat2_dma_memcpy_issue_pending(struct dma_chan *chan)
-{
-	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
+	/*
+	 * leave ioat_chan->desc_lock set in ioat 2 path
+	 * it will get unlocked at end of tx_submit
+	 */
 
-	if (ioat_chan->pending != 0) {
-		spin_lock_bh(&ioat_chan->desc_lock);
-		__ioat2_dma_memcpy_issue_pending(ioat_chan);
-		spin_unlock_bh(&ioat_chan->desc_lock);
-	}
+	if (new) {
+		new->len = len;
+		return &new->async_tx;
+	} else
+		return NULL;
 }
 
 static void ioat_dma_cleanup_tasklet(unsigned long data)
@@ -1019,7 +1031,7 @@ static void ioat_dma_start_null_desc(str
 static void ioat_dma_test_callback(void *dma_async_param)
 {
 	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(%p)\n",
-			dma_async_param);
+		dma_async_param);
 }
 
 /**
@@ -1032,7 +1044,7 @@ static int ioat_dma_self_test(struct ioa
 	u8 *src;
 	u8 *dest;
 	struct dma_chan *dma_chan;
-	struct dma_async_tx_descriptor *tx = NULL;
+	struct dma_async_tx_descriptor *tx;
 	dma_addr_t addr;
 	dma_cookie_t cookie;
 	int err = 0;
diff -puN drivers/dma/ioatdma.h~i-oat-fixups-from-code-comments drivers/dma/ioatdma.h
--- a/drivers/dma/ioatdma.h~i-oat-fixups-from-code-comments
+++ a/drivers/dma/ioatdma.h
@@ -76,7 +76,7 @@ struct ioat_dma_chan {
 	dma_cookie_t completed_cookie;
 	unsigned long last_completion;
 
-	u32 xfercap;	/* XFERCAP register value expanded out */
+	size_t xfercap;	/* XFERCAP register value expanded out */
 
 	spinlock_t cleanup_lock;
 	spinlock_t desc_lock;
_

Patches currently in -mm which might be from shannon.nelson@intel.com are

i-oat-fixups-from-code-comments.patch
dca-convert-struct-class_device-to-struct-device.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix.patch
