From: akpm@linux-foundation.org
Subject: + b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch added to -mm tree
Date: Tue, 16 Feb 2010 13:40:39 -0800
Message-ID: <201002162140.o1GLedQY006614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933090Ab0BPVko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 16:40:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, zambrano@broadcom.com


The patch titled
     b44: replace the ssb_dma API with the generic DMA API
has been added to the -mm tree.  Its filename is
     b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: b44: replace the ssb_dma API with the generic DMA API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Note that dma_sync_single_for_device and dma_sync_single_for_cpu support a
partial sync.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Gary Zambrano <zambrano@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/b44.c |  144 +++++++++++++++++++++-----------------------
 1 file changed, 70 insertions(+), 74 deletions(-)

diff -puN drivers/net/b44.c~b44-replace-the-ssb_dma-api-with-the-generic-dma-api drivers/net/b44.c
--- a/drivers/net/b44.c~b44-replace-the-ssb_dma-api-with-the-generic-dma-api
+++ a/drivers/net/b44.c
@@ -148,9 +148,8 @@ static inline void b44_sync_dma_desc_for
 						unsigned long offset,
 						enum dma_data_direction dir)
 {
-	ssb_dma_sync_single_range_for_device(sdev, dma_base,
-					     offset & dma_desc_align_mask,
-					     dma_desc_sync_size, dir);
+	dma_sync_single_for_device(sdev->dma_dev, dma_base + offset,
+				   dma_desc_sync_size, dir);
 }
 
 static inline void b44_sync_dma_desc_for_cpu(struct ssb_device *sdev,
@@ -158,9 +157,8 @@ static inline void b44_sync_dma_desc_for
 					     unsigned long offset,
 					     enum dma_data_direction dir)
 {
-	ssb_dma_sync_single_range_for_cpu(sdev, dma_base,
-					  offset & dma_desc_align_mask,
-					  dma_desc_sync_size, dir);
+	dma_sync_single_for_cpu(sdev->dma_dev, dma_base + offset,
+				dma_desc_sync_size, dir);
 }
 
 static inline unsigned long br32(const struct b44 *bp, unsigned long reg)
@@ -613,10 +611,10 @@ static void b44_tx(struct b44 *bp)
 
 		BUG_ON(skb == NULL);
 
-		ssb_dma_unmap_single(bp->sdev,
-				     rp->mapping,
-				     skb->len,
-				     DMA_TO_DEVICE);
+		dma_unmap_single(bp->sdev->dma_dev,
+				 rp->mapping,
+				 skb->len,
+				 DMA_TO_DEVICE);
 		rp->skb = NULL;
 		dev_kfree_skb_irq(skb);
 	}
@@ -653,29 +651,29 @@ static int b44_alloc_rx_skb(struct b44 *
 	if (skb == NULL)
 		return -ENOMEM;
 
-	mapping = ssb_dma_map_single(bp->sdev, skb->data,
-				     RX_PKT_BUF_SZ,
-				     DMA_FROM_DEVICE);
+	mapping = dma_map_single(bp->sdev->dma_dev, skb->data,
+				 RX_PKT_BUF_SZ,
+				 DMA_FROM_DEVICE);
 
 	/* Hardware bug work-around, the chip is unable to do PCI DMA
 	   to/from anything above 1GB :-( */
-	if (ssb_dma_mapping_error(bp->sdev, mapping) ||
+	if (dma_mapping_error(bp->sdev->dma_dev, mapping) ||
 		mapping + RX_PKT_BUF_SZ > DMA_BIT_MASK(30)) {
 		/* Sigh... */
-		if (!ssb_dma_mapping_error(bp->sdev, mapping))
-			ssb_dma_unmap_single(bp->sdev, mapping,
+		if (!dma_mapping_error(bp->sdev->dma_dev, mapping))
+			dma_unmap_single(bp->sdev->dma_dev, mapping,
 					     RX_PKT_BUF_SZ, DMA_FROM_DEVICE);
 		dev_kfree_skb_any(skb);
 		skb = __netdev_alloc_skb(bp->dev, RX_PKT_BUF_SZ, GFP_ATOMIC|GFP_DMA);
 		if (skb == NULL)
 			return -ENOMEM;
-		mapping = ssb_dma_map_single(bp->sdev, skb->data,
-					     RX_PKT_BUF_SZ,
-					     DMA_FROM_DEVICE);
-		if (ssb_dma_mapping_error(bp->sdev, mapping) ||
-			mapping + RX_PKT_BUF_SZ > DMA_BIT_MASK(30)) {
-			if (!ssb_dma_mapping_error(bp->sdev, mapping))
-				ssb_dma_unmap_single(bp->sdev, mapping, RX_PKT_BUF_SZ,DMA_FROM_DEVICE);
+		mapping = dma_map_single(bp->sdev->dma_dev, skb->data,
+					 RX_PKT_BUF_SZ,
+					 DMA_FROM_DEVICE);
+		if (dma_mapping_error(bp->sdev->dma_dev, mapping) ||
+		    mapping + RX_PKT_BUF_SZ > DMA_BIT_MASK(30)) {
+			if (!dma_mapping_error(bp->sdev->dma_dev, mapping))
+				dma_unmap_single(bp->sdev->dma_dev, mapping, RX_PKT_BUF_SZ,DMA_FROM_DEVICE);
 			dev_kfree_skb_any(skb);
 			return -ENOMEM;
 		}
@@ -750,9 +748,9 @@ static void b44_recycle_rx(struct b44 *b
 					     dest_idx * sizeof(*dest_desc),
 					     DMA_BIDIRECTIONAL);
 
-	ssb_dma_sync_single_for_device(bp->sdev, dest_map->mapping,
-				       RX_PKT_BUF_SZ,
-				       DMA_FROM_DEVICE);
+	dma_sync_single_for_device(bp->sdev->dma_dev, dest_map->mapping,
+				   RX_PKT_BUF_SZ,
+				   DMA_FROM_DEVICE);
 }
 
 static int b44_rx(struct b44 *bp, int budget)
@@ -772,9 +770,9 @@ static int b44_rx(struct b44 *bp, int bu
 		struct rx_header *rh;
 		u16 len;
 
-		ssb_dma_sync_single_for_cpu(bp->sdev, map,
-					    RX_PKT_BUF_SZ,
-					    DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(bp->sdev->dma_dev, map,
+					RX_PKT_BUF_SZ,
+					DMA_FROM_DEVICE);
 		rh = (struct rx_header *) skb->data;
 		len = le16_to_cpu(rh->len);
 		if ((len > (RX_PKT_BUF_SZ - RX_PKT_OFFSET)) ||
@@ -806,8 +804,8 @@ static int b44_rx(struct b44 *bp, int bu
 			skb_size = b44_alloc_rx_skb(bp, cons, bp->rx_prod);
 			if (skb_size < 0)
 				goto drop_it;
-			ssb_dma_unmap_single(bp->sdev, map,
-					     skb_size, DMA_FROM_DEVICE);
+			dma_unmap_single(bp->sdev->dma_dev, map,
+					 skb_size, DMA_FROM_DEVICE);
 			/* Leave out rx_header */
 			skb_put(skb, len + RX_PKT_OFFSET);
 			skb_pull(skb, RX_PKT_OFFSET);
@@ -961,24 +959,24 @@ static netdev_tx_t b44_start_xmit(struct
 		goto err_out;
 	}
 
-	mapping = ssb_dma_map_single(bp->sdev, skb->data, len, DMA_TO_DEVICE);
-	if (ssb_dma_mapping_error(bp->sdev, mapping) || mapping + len > DMA_BIT_MASK(30)) {
+	mapping = dma_map_single(bp->sdev->dma_dev, skb->data, len, DMA_TO_DEVICE);
+	if (dma_mapping_error(bp->sdev->dma_dev, mapping) || mapping + len > DMA_BIT_MASK(30)) {
 		struct sk_buff *bounce_skb;
 
 		/* Chip can't handle DMA to/from >1GB, use bounce buffer */
-		if (!ssb_dma_mapping_error(bp->sdev, mapping))
-			ssb_dma_unmap_single(bp->sdev, mapping, len,
+		if (!dma_mapping_error(bp->sdev->dma_dev, mapping))
+			dma_unmap_single(bp->sdev->dma_dev, mapping, len,
 					     DMA_TO_DEVICE);
 
 		bounce_skb = __netdev_alloc_skb(dev, len, GFP_ATOMIC | GFP_DMA);
 		if (!bounce_skb)
 			goto err_out;
 
-		mapping = ssb_dma_map_single(bp->sdev, bounce_skb->data,
-					     len, DMA_TO_DEVICE);
-		if (ssb_dma_mapping_error(bp->sdev, mapping) || mapping + len > DMA_BIT_MASK(30)) {
-			if (!ssb_dma_mapping_error(bp->sdev, mapping))
-				ssb_dma_unmap_single(bp->sdev, mapping,
+		mapping = dma_map_single(bp->sdev->dma_dev, bounce_skb->data,
+					 len, DMA_TO_DEVICE);
+		if (dma_mapping_error(bp->sdev->dma_dev, mapping) || mapping + len > DMA_BIT_MASK(30)) {
+			if (!dma_mapping_error(bp->sdev->dma_dev, mapping))
+				dma_unmap_single(bp->sdev->dma_dev, mapping,
 						     len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(bounce_skb);
 			goto err_out;
@@ -1077,8 +1075,8 @@ static void b44_free_rings(struct b44 *b
 
 		if (rp->skb == NULL)
 			continue;
-		ssb_dma_unmap_single(bp->sdev, rp->mapping, RX_PKT_BUF_SZ,
-				     DMA_FROM_DEVICE);
+		dma_unmap_single(bp->sdev->dma_dev, rp->mapping, RX_PKT_BUF_SZ,
+				 DMA_FROM_DEVICE);
 		dev_kfree_skb_any(rp->skb);
 		rp->skb = NULL;
 	}
@@ -1089,8 +1087,8 @@ static void b44_free_rings(struct b44 *b
 
 		if (rp->skb == NULL)
 			continue;
-		ssb_dma_unmap_single(bp->sdev, rp->mapping, rp->skb->len,
-				     DMA_TO_DEVICE);
+		dma_unmap_single(bp->sdev->dma_dev, rp->mapping, rp->skb->len,
+				 DMA_TO_DEVICE);
 		dev_kfree_skb_any(rp->skb);
 		rp->skb = NULL;
 	}
@@ -1112,14 +1110,12 @@ static void b44_init_rings(struct b44 *b
 	memset(bp->tx_ring, 0, B44_TX_RING_BYTES);
 
 	if (bp->flags & B44_FLAG_RX_RING_HACK)
-		ssb_dma_sync_single_for_device(bp->sdev, bp->rx_ring_dma,
-					       DMA_TABLE_BYTES,
-					       DMA_BIDIRECTIONAL);
+		dma_sync_single_for_device(bp->sdev->dma_dev, bp->rx_ring_dma,
+					   DMA_TABLE_BYTES, DMA_BIDIRECTIONAL);
 
 	if (bp->flags & B44_FLAG_TX_RING_HACK)
-		ssb_dma_sync_single_for_device(bp->sdev, bp->tx_ring_dma,
-					       DMA_TABLE_BYTES,
-					       DMA_TO_DEVICE);
+		dma_sync_single_for_device(bp->sdev->dma_dev, bp->tx_ring_dma,
+					   DMA_TABLE_BYTES, DMA_TO_DEVICE);
 
 	for (i = 0; i < bp->rx_pending; i++) {
 		if (b44_alloc_rx_skb(bp, -1, i) < 0)
@@ -1139,27 +1135,23 @@ static void b44_free_consistent(struct b
 	bp->tx_buffers = NULL;
 	if (bp->rx_ring) {
 		if (bp->flags & B44_FLAG_RX_RING_HACK) {
-			ssb_dma_unmap_single(bp->sdev, bp->rx_ring_dma,
-					     DMA_TABLE_BYTES,
-					     DMA_BIDIRECTIONAL);
+			dma_unmap_single(bp->sdev->dma_dev, bp->rx_ring_dma,
+					 DMA_TABLE_BYTES, DMA_BIDIRECTIONAL);
 			kfree(bp->rx_ring);
 		} else
-			ssb_dma_free_consistent(bp->sdev, DMA_TABLE_BYTES,
-						bp->rx_ring, bp->rx_ring_dma,
-						GFP_KERNEL);
+			dma_free_coherent(bp->sdev->dma_dev, DMA_TABLE_BYTES,
+					  bp->rx_ring, bp->rx_ring_dma);
 		bp->rx_ring = NULL;
 		bp->flags &= ~B44_FLAG_RX_RING_HACK;
 	}
 	if (bp->tx_ring) {
 		if (bp->flags & B44_FLAG_TX_RING_HACK) {
-			ssb_dma_unmap_single(bp->sdev, bp->tx_ring_dma,
-					     DMA_TABLE_BYTES,
-					     DMA_TO_DEVICE);
+			dma_unmap_single(bp->sdev->dma_dev, bp->tx_ring_dma,
+					 DMA_TABLE_BYTES, DMA_TO_DEVICE);
 			kfree(bp->tx_ring);
 		} else
-			ssb_dma_free_consistent(bp->sdev, DMA_TABLE_BYTES,
-						bp->tx_ring, bp->tx_ring_dma,
-						GFP_KERNEL);
+			dma_free_coherent(bp->sdev->dma_dev, DMA_TABLE_BYTES,
+					  bp->tx_ring, bp->tx_ring_dma);
 		bp->tx_ring = NULL;
 		bp->flags &= ~B44_FLAG_TX_RING_HACK;
 	}
@@ -1184,7 +1176,8 @@ static int b44_alloc_consistent(struct b
 		goto out_err;
 
 	size = DMA_TABLE_BYTES;
-	bp->rx_ring = ssb_dma_alloc_consistent(bp->sdev, size, &bp->rx_ring_dma, gfp);
+	bp->rx_ring = dma_alloc_coherent(bp->sdev->dma_dev, size,
+					 &bp->rx_ring_dma, gfp);
 	if (!bp->rx_ring) {
 		/* Allocation may have failed due to pci_alloc_consistent
 		   insisting on use of GFP_DMA, which is more restrictive
@@ -1196,11 +1189,11 @@ static int b44_alloc_consistent(struct b
 		if (!rx_ring)
 			goto out_err;
 
-		rx_ring_dma = ssb_dma_map_single(bp->sdev, rx_ring,
-						 DMA_TABLE_BYTES,
-						 DMA_BIDIRECTIONAL);
+		rx_ring_dma = dma_map_single(bp->sdev->dma_dev, rx_ring,
+					     DMA_TABLE_BYTES,
+					     DMA_BIDIRECTIONAL);
 
-		if (ssb_dma_mapping_error(bp->sdev, rx_ring_dma) ||
+		if (dma_mapping_error(bp->sdev->dma_dev, rx_ring_dma) ||
 			rx_ring_dma + size > DMA_BIT_MASK(30)) {
 			kfree(rx_ring);
 			goto out_err;
@@ -1211,7 +1204,8 @@ static int b44_alloc_consistent(struct b
 		bp->flags |= B44_FLAG_RX_RING_HACK;
 	}
 
-	bp->tx_ring = ssb_dma_alloc_consistent(bp->sdev, size, &bp->tx_ring_dma, gfp);
+	bp->tx_ring = dma_alloc_coherent(bp->sdev->dma_dev, size,
+					 &bp->tx_ring_dma, gfp);
 	if (!bp->tx_ring) {
 		/* Allocation may have failed due to ssb_dma_alloc_consistent
 		   insisting on use of GFP_DMA, which is more restrictive
@@ -1223,11 +1217,11 @@ static int b44_alloc_consistent(struct b
 		if (!tx_ring)
 			goto out_err;
 
-		tx_ring_dma = ssb_dma_map_single(bp->sdev, tx_ring,
-			                    DMA_TABLE_BYTES,
-			                    DMA_TO_DEVICE);
+		tx_ring_dma = dma_map_single(bp->sdev->dma_dev, tx_ring,
+					     DMA_TABLE_BYTES,
+					     DMA_TO_DEVICE);
 
-		if (ssb_dma_mapping_error(bp->sdev, tx_ring_dma) ||
+		if (dma_mapping_error(bp->sdev->dma_dev, tx_ring_dma) ||
 			tx_ring_dma + size > DMA_BIT_MASK(30)) {
 			kfree(tx_ring);
 			goto out_err;
@@ -2183,12 +2177,14 @@ static int __devinit b44_init_one(struct
 			"Failed to powerup the bus\n");
 		goto err_out_free_dev;
 	}
-	err = ssb_dma_set_mask(sdev, DMA_BIT_MASK(30));
-	if (err) {
+
+	if (dma_set_mask(sdev->dma_dev, DMA_BIT_MASK(30)) ||
+	    dma_set_coherent_mask(sdev->dma_dev, DMA_BIT_MASK(30))) {
 		dev_err(sdev->dev,
 			"Required 30BIT DMA mask unsupported by the system.\n");
 		goto err_out_powerdown;
 	}
+
 	err = b44_get_invariants(bp);
 	if (err) {
 		dev_err(sdev->dev,
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg.patch
documentation-dma-apitxt-remove-deprecated-function-descriptions.patch
dma-apitxt-add-dma_sync_single-sg-api-description.patch
dma-apitxt-remove-dma_sync_single_range-description.patch
alpha-remove-dma_sync_single_range.patch
um-remove-dma_sync_single_range.patch
pci-dma-add-include-linux-pci-dmah.patch
pci-dma-x86-use-include-linux-pci-dmah.patch
pci-dma-alpha-use-include-linux-pci-dmah.patch
pci-dma-arm-use-include-linux-pci-dmah.patch
pci-dma-frv-use-include-linux-pci-dmah.patch
pci-dma-ia64-use-include-linux-pci-dmah.patch
pci-dma-mips-use-include-linux-pci-dmah.patch
pci-dma-parisc-use-include-linux-pci-dmah.patch
pci-dma-powerpc-use-include-linux-pci-dmah.patch
pci-dma-sh-use-include-linux-pci-dmah.patch
pci-dma-sparc-use-include-linux-pci-dmah.patch
pci-dma-xtensa-use-include-linux-pci-dmah.patch
pci-dma-cris-use-include-linux-pci-dmah.patch
pci-dma-add-linux-pci-dmah-to-linux-pcih.patch
dma-mappingh-add-the-dma_unmap-state-api.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch
dma-mapping-alpha-use-include-linux-pci-dma-compath.patch
dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch
dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch
dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

