From: akpm@linux-foundation.org
Subject: [merged] replace-all-dma_30bit_mask-macro-with-dma_bit_mask30.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:08:02 -0700
Message-ID: <200904071908.n37J8214011606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939AbZDGTJW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:09:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanghy@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: replace all DMA_30BIT_MASK macro with DMA_BIT_MASK(30)
has been removed from the -mm tree.  Its filename was
     replace-all-dma_30bit_mask-macro-with-dma_bit_mask30.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: replace all DMA_30BIT_MASK macro with DMA_BIT_MASK(30)
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Replace all DMA_30BIT_MASK macro with DMA_BIT_MASK(30)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/b44.c                    |   14 +++++++-------
 drivers/net/wireless/b43/dma.c       |    6 +++---
 drivers/net/wireless/b43legacy/dma.c |    6 +++---
 sound/pci/sis7019.c                  |    2 +-
 sound/pci/trident/trident_main.c     |    4 ++--
 5 files changed, 16 insertions(+), 16 deletions(-)

diff -puN drivers/net/b44.c~replace-all-dma_30bit_mask-macro-with-dma_bit_mask30 drivers/net/b44.c
--- a/drivers/net/b44.c~replace-all-dma_30bit_mask-macro-with-dma_bit_mask30
+++ a/drivers/net/b44.c
@@ -660,7 +660,7 @@ static int b44_alloc_rx_skb(struct b44 *
 	/* Hardware bug work-around, the chip is unable to do PCI DMA
 	   to/from anything above 1GB :-( */
 	if (ssb_dma_mapping_error(bp->sdev, mapping) ||
-		mapping + RX_PKT_BUF_SZ > DMA_30BIT_MASK) {
+		mapping + RX_PKT_BUF_SZ > DMA_BIT_MASK(30)) {
 		/* Sigh... */
 		if (!ssb_dma_mapping_error(bp->sdev, mapping))
 			ssb_dma_unmap_single(bp->sdev, mapping,
@@ -673,7 +673,7 @@ static int b44_alloc_rx_skb(struct b44 *
 					     RX_PKT_BUF_SZ,
 					     DMA_FROM_DEVICE);
 		if (ssb_dma_mapping_error(bp->sdev, mapping) ||
-			mapping + RX_PKT_BUF_SZ > DMA_30BIT_MASK) {
+			mapping + RX_PKT_BUF_SZ > DMA_BIT_MASK(30)) {
 			if (!ssb_dma_mapping_error(bp->sdev, mapping))
 				ssb_dma_unmap_single(bp->sdev, mapping, RX_PKT_BUF_SZ,DMA_FROM_DEVICE);
 			dev_kfree_skb_any(skb);
@@ -965,7 +965,7 @@ static int b44_start_xmit(struct sk_buff
 	}
 
 	mapping = ssb_dma_map_single(bp->sdev, skb->data, len, DMA_TO_DEVICE);
-	if (ssb_dma_mapping_error(bp->sdev, mapping) || mapping + len > DMA_30BIT_MASK) {
+	if (ssb_dma_mapping_error(bp->sdev, mapping) || mapping + len > DMA_BIT_MASK(30)) {
 		struct sk_buff *bounce_skb;
 
 		/* Chip can't handle DMA to/from >1GB, use bounce buffer */
@@ -979,7 +979,7 @@ static int b44_start_xmit(struct sk_buff
 
 		mapping = ssb_dma_map_single(bp->sdev, bounce_skb->data,
 					     len, DMA_TO_DEVICE);
-		if (ssb_dma_mapping_error(bp->sdev, mapping) || mapping + len > DMA_30BIT_MASK) {
+		if (ssb_dma_mapping_error(bp->sdev, mapping) || mapping + len > DMA_BIT_MASK(30)) {
 			if (!ssb_dma_mapping_error(bp->sdev, mapping))
 				ssb_dma_unmap_single(bp->sdev, mapping,
 						     len, DMA_TO_DEVICE);
@@ -1204,7 +1204,7 @@ static int b44_alloc_consistent(struct b
 						 DMA_BIDIRECTIONAL);
 
 		if (ssb_dma_mapping_error(bp->sdev, rx_ring_dma) ||
-			rx_ring_dma + size > DMA_30BIT_MASK) {
+			rx_ring_dma + size > DMA_BIT_MASK(30)) {
 			kfree(rx_ring);
 			goto out_err;
 		}
@@ -1231,7 +1231,7 @@ static int b44_alloc_consistent(struct b
 			                    DMA_TO_DEVICE);
 
 		if (ssb_dma_mapping_error(bp->sdev, tx_ring_dma) ||
-			tx_ring_dma + size > DMA_30BIT_MASK) {
+			tx_ring_dma + size > DMA_BIT_MASK(30)) {
 			kfree(tx_ring);
 			goto out_err;
 		}
@@ -2180,7 +2180,7 @@ static int __devinit b44_init_one(struct
 			"Failed to powerup the bus\n");
 		goto err_out_free_dev;
 	}
-	err = ssb_dma_set_mask(sdev, DMA_30BIT_MASK);
+	err = ssb_dma_set_mask(sdev, DMA_BIT_MASK(30));
 	if (err) {
 		dev_err(sdev->dev,
 			"Required 30BIT DMA mask unsupported by the system.\n");
diff -puN drivers/net/wireless/b43/dma.c~replace-all-dma_30bit_mask-macro-with-dma_bit_mask30 drivers/net/wireless/b43/dma.c
--- a/drivers/net/wireless/b43/dma.c~replace-all-dma_30bit_mask-macro-with-dma_bit_mask30
+++ a/drivers/net/wireless/b43/dma.c
@@ -779,12 +779,12 @@ static u64 supported_dma_mask(struct b43
 	if (tmp & B43_DMA32_TXADDREXT_MASK)
 		return DMA_BIT_MASK(32);
 
-	return DMA_30BIT_MASK;
+	return DMA_BIT_MASK(30);
 }
 
 static enum b43_dmatype dma_mask_to_engine_type(u64 dmamask)
 {
-	if (dmamask == DMA_30BIT_MASK)
+	if (dmamask == DMA_BIT_MASK(30))
 		return B43_DMA_30BIT;
 	if (dmamask == DMA_BIT_MASK(32))
 		return B43_DMA_32BIT;
@@ -1005,7 +1005,7 @@ static int b43_dma_set_mask(struct b43_w
 			continue;
 		}
 		if (mask == DMA_BIT_MASK(32)) {
-			mask = DMA_30BIT_MASK;
+			mask = DMA_BIT_MASK(30);
 			fallback = 1;
 			continue;
 		}
diff -puN drivers/net/wireless/b43legacy/dma.c~replace-all-dma_30bit_mask-macro-with-dma_bit_mask30 drivers/net/wireless/b43legacy/dma.c
--- a/drivers/net/wireless/b43legacy/dma.c~replace-all-dma_30bit_mask-macro-with-dma_bit_mask30
+++ a/drivers/net/wireless/b43legacy/dma.c
@@ -856,12 +856,12 @@ static u64 supported_dma_mask(struct b43
 	if (tmp & B43legacy_DMA32_TXADDREXT_MASK)
 		return DMA_BIT_MASK(32);
 
-	return DMA_30BIT_MASK;
+	return DMA_BIT_MASK(30);
 }
 
 static enum b43legacy_dmatype dma_mask_to_engine_type(u64 dmamask)
 {
-	if (dmamask == DMA_30BIT_MASK)
+	if (dmamask == DMA_BIT_MASK(30))
 		return B43legacy_DMA_30BIT;
 	if (dmamask == DMA_BIT_MASK(32))
 		return B43legacy_DMA_32BIT;
@@ -1048,7 +1048,7 @@ static int b43legacy_dma_set_mask(struct
 			continue;
 		}
 		if (mask == DMA_BIT_MASK(32)) {
-			mask = DMA_30BIT_MASK;
+			mask = DMA_BIT_MASK(30);
 			fallback = 1;
 			continue;
 		}
diff -puN sound/pci/sis7019.c~replace-all-dma_30bit_mask-macro-with-dma_bit_mask30 sound/pci/sis7019.c
--- a/sound/pci/sis7019.c~replace-all-dma_30bit_mask-macro-with-dma_bit_mask30
+++ a/sound/pci/sis7019.c
@@ -1300,7 +1300,7 @@ static int __devinit sis_chip_create(str
 	if (rc)
 		goto error_out;
 
-	if (pci_set_dma_mask(pci, DMA_30BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(30)) < 0) {
 		printk(KERN_ERR "sis7019: architecture does not support "
 					"30-bit PCI busmaster DMA");
 		goto error_out_enabled;
diff -puN sound/pci/trident/trident_main.c~replace-all-dma_30bit_mask-macro-with-dma_bit_mask30 sound/pci/trident/trident_main.c
--- a/sound/pci/trident/trident_main.c~replace-all-dma_30bit_mask-macro-with-dma_bit_mask30
+++ a/sound/pci/trident/trident_main.c
@@ -3559,8 +3559,8 @@ int __devinit snd_trident_create(struct 
 	if ((err = pci_enable_device(pci)) < 0)
 		return err;
 	/* check, if we can restrict PCI DMA transfers to 30 bits */
-	if (pci_set_dma_mask(pci, DMA_30BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_30BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(30)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(30)) < 0) {
 		snd_printk(KERN_ERR "architecture does not support 30bit PCI busmaster DMA\n");
 		pci_disable_device(pci);
 		return -ENXIO;
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

origin.patch

