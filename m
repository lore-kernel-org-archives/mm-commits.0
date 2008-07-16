From: akpm@linux-foundation.org
Subject: - via-velocity-remove-the-bounce-buffers.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:22 -0700
Message-ID: <200807162135.m6GLZMHo014080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757279AbYGPVgB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:36:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, rseguier@e-teleport.net, mm-commits@vger.kernel.org


The patch titled
     via-velocity: remove the bounce buffers
has been removed from the -mm tree.  Its filename was
     via-velocity-remove-the-bounce-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: via-velocity: remove the bounce buffers
From: Francois Romieu <romieu@fr.zoreil.com>

Executive summary: the bounce buffers are in my way

- they use something like a 64 * 1500 bytes area of PCI
  consistent area
- they are not resized when the MTU changes
- they are used
  - to hand-pad undersized packets. skb_pad anyone ?
  - to linearize fragmented skbs whose fragment count
    goes beyond the 7 fragments hardware limit in order
    to claim scatter-gather support

Actually the SG code is commented out and I wonder if it
could not be implemented (ab-)using the large send feature
of the chipset since the latter should support some
multi-descriptor packet transmitting.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Fixed-by: Seguier Regis <rseguier@e-teleport.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/via-velocity.c |   72 ++++++++---------------------------
 drivers/net/via-velocity.h |    5 --
 2 files changed, 18 insertions(+), 59 deletions(-)

diff -puN drivers/net/via-velocity.c~via-velocity-remove-the-bounce-buffers drivers/net/via-velocity.c
--- a/drivers/net/via-velocity.c~via-velocity-remove-the-bounce-buffers
+++ a/drivers/net/via-velocity.c
@@ -1104,7 +1104,6 @@ static int velocity_init_rings(struct ve
 {
 	int i;
 	unsigned int psize;
-	unsigned int tsize;
 	dma_addr_t pool_dma;
 	u8 *pool;
 
@@ -1133,19 +1132,6 @@ static int velocity_init_rings(struct ve
 
 	vptr->rd_pool_dma = pool_dma;
 
-	tsize = vptr->options.numtx * PKT_BUF_SZ * vptr->num_txq;
-	vptr->tx_bufs = pci_alloc_consistent(vptr->pdev, tsize,
-						&vptr->tx_bufs_dma);
-
-	if (vptr->tx_bufs == NULL) {
-		printk(KERN_ERR "%s: DMA memory allocation failed.\n",
-					vptr->dev->name);
-		pci_free_consistent(vptr->pdev, psize, pool, pool_dma);
-		return -ENOMEM;
-	}
-
-	memset(vptr->tx_bufs, 0, vptr->options.numtx * PKT_BUF_SZ * vptr->num_txq);
-
 	i = vptr->options.numrx * sizeof(struct rx_desc);
 	pool += i;
 	pool_dma += i;
@@ -1169,16 +1155,10 @@ static int velocity_init_rings(struct ve
 
 static void velocity_free_rings(struct velocity_info *vptr)
 {
-	int size;
-
-	size = vptr->options.numrx * sizeof(struct rx_desc) +
-	       vptr->options.numtx * sizeof(struct tx_desc) * vptr->num_txq;
+	const int size = vptr->options.numrx * sizeof(struct rx_desc) +
+		vptr->options.numtx * sizeof(struct tx_desc) * vptr->num_txq;
 
 	pci_free_consistent(vptr->pdev, size, vptr->rd_ring, vptr->rd_pool_dma);
-
-	size = vptr->options.numtx * PKT_BUF_SZ * vptr->num_txq;
-
-	pci_free_consistent(vptr->pdev, size, vptr->tx_bufs, vptr->tx_bufs_dma);
 }
 
 static inline void velocity_give_many_rx_descs(struct velocity_info *vptr)
@@ -1313,10 +1293,8 @@ static void velocity_free_rd_ring(struct
 
 static int velocity_init_td_ring(struct velocity_info *vptr)
 {
-	int i, j;
 	dma_addr_t curr;
-	struct tx_desc *td;
-	struct velocity_td_info *td_info;
+	unsigned int j;
 
 	/* Init the TD ring entries */
 	for (j = 0; j < vptr->num_txq; j++) {
@@ -1331,14 +1309,6 @@ static int velocity_init_td_ring(struct 
 			return -ENOMEM;
 		}
 
-		for (i = 0; i < vptr->options.numtx; i++, curr += sizeof(struct tx_desc)) {
-			td = &(vptr->td_rings[j][i]);
-			td_info = &(vptr->td_infos[j][i]);
-			td_info->buf = vptr->tx_bufs +
-				(j * vptr->options.numtx + i) * PKT_BUF_SZ;
-			td_info->buf_dma = vptr->tx_bufs_dma +
-				(j * vptr->options.numtx + i) * PKT_BUF_SZ;
-		}
 		vptr->td_tail[j] = vptr->td_curr[j] = vptr->td_used[j] = 0;
 	}
 	return 0;
@@ -1867,7 +1837,7 @@ static void velocity_free_tx_buf(struct 
 	/*
 	 *	Don't unmap the pre-allocated tx_bufs
 	 */
-	if (tdinfo->skb_dma && (tdinfo->skb_dma[0] != tdinfo->buf_dma)) {
+	if (tdinfo->skb_dma) {
 
 		for (i = 0; i < tdinfo->nskb_dma; i++) {
 #ifdef VELOCITY_ZERO_COPY_SUPPORT
@@ -2063,9 +2033,19 @@ static int velocity_xmit(struct sk_buff 
 	struct tx_desc *td_ptr;
 	struct velocity_td_info *tdinfo;
 	unsigned long flags;
-	int index;
 	int pktlen = skb->len;
-	__le16 len = cpu_to_le16(pktlen);
+	__le16 len;
+	int index;
+
+
+
+	if (skb->len < ETH_ZLEN) {
+		if (skb_padto(skb, ETH_ZLEN))
+			goto out;
+		pktlen = ETH_ZLEN;
+	}
+
+	len = cpu_to_le16(pktlen);
 
 #ifdef VELOCITY_ZERO_COPY_SUPPORT
 	if (skb_shinfo(skb)->nr_frags > 6 && __skb_linearize(skb)) {
@@ -2083,23 +2063,6 @@ static int velocity_xmit(struct sk_buff 
 	td_ptr->tdesc1.TCR = TCR0_TIC;
 	td_ptr->td_buf[0].size &= ~TD_QUEUE;
 
-	/*
-	 *	Pad short frames.
-	 */
-	if (pktlen < ETH_ZLEN) {
-		/* Cannot occur until ZC support */
-		pktlen = ETH_ZLEN;
-		len = cpu_to_le16(ETH_ZLEN);
-		skb_copy_from_linear_data(skb, tdinfo->buf, skb->len);
-		memset(tdinfo->buf + skb->len, 0, ETH_ZLEN - skb->len);
-		tdinfo->skb = skb;
-		tdinfo->skb_dma[0] = tdinfo->buf_dma;
-		td_ptr->tdesc0.len = len;
-		td_ptr->td_buf[0].pa_low = cpu_to_le32(tdinfo->skb_dma[0]);
-		td_ptr->td_buf[0].pa_high = 0;
-		td_ptr->td_buf[0].size = len;	/* queue is 0 anyway */
-		tdinfo->nskb_dma = 1;
-	} else
 #ifdef VELOCITY_ZERO_COPY_SUPPORT
 	if (skb_shinfo(skb)->nr_frags > 0) {
 		int nfrags = skb_shinfo(skb)->nr_frags;
@@ -2191,7 +2154,8 @@ static int velocity_xmit(struct sk_buff 
 	}
 	dev->trans_start = jiffies;
 	spin_unlock_irqrestore(&vptr->lock, flags);
-	return 0;
+out:
+	return NETDEV_TX_OK;
 }
 
 /**
diff -puN drivers/net/via-velocity.h~via-velocity-remove-the-bounce-buffers drivers/net/via-velocity.h
--- a/drivers/net/via-velocity.h~via-velocity-remove-the-bounce-buffers
+++ a/drivers/net/via-velocity.h
@@ -236,10 +236,8 @@ struct velocity_rd_info {
 
 struct velocity_td_info {
 	struct sk_buff *skb;
-	u8 *buf;
 	int nskb_dma;
 	dma_addr_t skb_dma[7];
-	dma_addr_t buf_dma;
 };
 
 enum  velocity_owner {
@@ -1506,9 +1504,6 @@ struct velocity_info {
 	dma_addr_t rd_pool_dma;
 	dma_addr_t td_pool_dma[TX_QUEUE_NO];
 
-	dma_addr_t tx_bufs_dma;
-	u8 *tx_bufs;
