From: akpm@linux-foundation.org
Subject: + cxgb3-fix-dma-mapping-error-path.patch added to -mm tree
Date: Wed, 21 May 2008 17:20:35 -0700
Message-ID: <200805220020.m4M0KZ4k008183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758591AbYEVAVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 20:21:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: divy@chelsio.com, awise@opengridcomputing.com


The patch titled
     cxgb3: fix dma mapping error path
has been added to the -mm tree.  Its filename is
     cxgb3-fix-dma-mapping-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cxgb3: fix dma mapping error path
From: Divy Le Ray <divy@chelsio.com>

Take potential dma mapping errors in account.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Cc: Steve Wise <awise@opengridcomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/sge.c |   55 +++++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 13 deletions(-)

diff -puN drivers/net/cxgb3/sge.c~cxgb3-fix-dma-mapping-error-path drivers/net/cxgb3/sge.c
--- a/drivers/net/cxgb3/sge.c~cxgb3-fix-dma-mapping-error-path
+++ a/drivers/net/cxgb3/sge.c
@@ -376,13 +376,16 @@ static void free_rx_bufs(struct pci_dev 
  *	Add a buffer of the given length to the supplied HW and SW Rx
  *	descriptors.
  */
-static inline void add_one_rx_buf(void *va, unsigned int len,
-				  struct rx_desc *d, struct rx_sw_desc *sd,
-				  unsigned int gen, struct pci_dev *pdev)
+static inline int add_one_rx_buf(void *va, unsigned int len,
+				 struct rx_desc *d, struct rx_sw_desc *sd,
+				 unsigned int gen, struct pci_dev *pdev)
 {
 	dma_addr_t mapping;
 
 	mapping = pci_map_single(pdev, va, len, PCI_DMA_FROMDEVICE);
+	if (unlikely(pci_dma_mapping_error(mapping)))
+		return -ENOMEM;
+
 	pci_unmap_addr_set(sd, dma_addr, mapping);
 
 	d->addr_lo = cpu_to_be32(mapping);
@@ -390,6 +393,7 @@ static inline void add_one_rx_buf(void *
 	wmb();
 	d->len_gen = cpu_to_be32(V_FLD_GEN1(gen));
 	d->gen2 = cpu_to_be32(V_FLD_GEN2(gen));
+	return 0;
 }
 
 static int alloc_pg_chunk(struct sge_fl *q, struct rx_sw_desc *sd, gfp_t gfp)
@@ -424,13 +428,16 @@ static int alloc_pg_chunk(struct sge_fl 
  *	allocated with the supplied gfp flags.  The caller must assure that
  *	@n does not exceed the queue's capacity.
  */
-static void refill_fl(struct adapter *adap, struct sge_fl *q, int n, gfp_t gfp)
+static int refill_fl(struct adapter *adap, struct sge_fl *q, int n, gfp_t gfp)
 {
 	void *buf_start;
 	struct rx_sw_desc *sd = &q->sdesc[q->pidx];
 	struct rx_desc *d = &q->desc[q->pidx];
+	unsigned int count = 0;
 
 	while (n--) {
+		int err;
+
 		if (q->use_pages) {
 			if (unlikely(alloc_pg_chunk(q, sd, gfp))) {
 nomem:				q->alloc_failed++;
@@ -447,8 +454,16 @@ nomem:				q->alloc_failed++;
 			buf_start = skb->data;
 		}
 
-		add_one_rx_buf(buf_start, q->buf_size, d, sd, q->gen,
-			       adap->pdev);
+		err = add_one_rx_buf(buf_start, q->buf_size, d, sd, q->gen,
+				     adap->pdev);
+		if (unlikely(err)) {
+			if (!q->use_pages) {
+				kfree_skb(sd->skb);
+				sd->skb = NULL;
+			}
+			break;
+		}
+
 		d++;
 		sd++;
 		if (++q->pidx == q->size) {
@@ -458,9 +473,13 @@ nomem:				q->alloc_failed++;
 			d = q->desc;
 		}
 		q->credits++;
+		count++;
 	}
 	wmb();
-	t3_write_reg(adap, A_SG_KDOORBELL, V_EGRCNTX(q->cntxt_id));
+	if (likely(count))
+		t3_write_reg(adap, A_SG_KDOORBELL, V_EGRCNTX(q->cntxt_id));
+
+	return count;
 }
 
 static inline void __refill_fl(struct adapter *adap, struct sge_fl *fl)
@@ -2618,7 +2637,7 @@ int t3_sge_alloc_qset(struct adapter *ad
 		      int irq_vec_idx, const struct qset_params *p,
 		      int ntxq, struct net_device *dev)
 {
-	int i, ret = -ENOMEM;
+	int i, avail, ret = -ENOMEM;
 	struct sge_qset *q = &adapter->sge.qs[id];
 
 	init_qset_cntxt(q, id);
@@ -2741,9 +2760,19 @@ int t3_sge_alloc_qset(struct adapter *ad
 	q->adap = adapter;
 	q->netdev = dev;
 	t3_update_qset_coalesce(q, p);
-
-	refill_fl(adapter, &q->fl[0], q->fl[0].size, GFP_KERNEL);
-	refill_fl(adapter, &q->fl[1], q->fl[1].size, GFP_KERNEL);
+	avail = refill_fl(adapter, &q->fl[0], q->fl[0].size, GFP_KERNEL);
+	if (!avail) {
+		CH_ALERT(adapter, "free list queue 0 initialization failed\n");
+		goto err;
+	}
+	if (avail < q->fl[0].size)
+		CH_WARN(adapter, "free list queue 0 enabled with %d credits\n",
+			avail);
+
+	avail = refill_fl(adapter, &q->fl[1], q->fl[1].size, GFP_KERNEL);
+	if (avail < q->fl[1].size)
+		CH_WARN(adapter, "free list queue 1 enabled with %d credits\n",
+			avail);
 	refill_rspq(adapter, &q->rspq, q->rspq.size - 1);
 
 	t3_write_reg(adapter, A_SG_GTS, V_RSPQ(q->rspq.cntxt_id) |
@@ -2752,9 +2781,9 @@ int t3_sge_alloc_qset(struct adapter *ad
 	mod_timer(&q->tx_reclaim_timer, jiffies + TX_RECLAIM_PERIOD);
 	return 0;
 
-      err_unlock:
+err_unlock:
 	spin_unlock_irq(&adapter->sge.reg_lock);
-      err:
+err:
 	t3_free_qset(adapter, q);
 	return ret;
 }
_

Patches currently in -mm which might be from divy@chelsio.com are

cxgb3-fix-dma-mapping-error-path.patch
cxgb3-add-page-support-to-jumbo-frame-rx-queue.patch
cxgb3-add-lro-support.patch
a.patch
b.patch

