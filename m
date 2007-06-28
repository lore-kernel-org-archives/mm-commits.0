From: akpm@linux-foundation.org
Subject: + extract-chip-specific-code-out-of-lasi_82596c-update-2.patch added to -mm tree
Date: Thu, 28 Jun 2007 13:41:23 -0700
Message-ID: <200706282041.l5SKfNql001130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45156 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760105AbXF1Uld (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 16:41:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsbogend@alpha.franken.de


The patch titled
     extract-chip-specific-code-out-of-lasi_82596c-update 2
has been added to the -mm tree.  Its filename is
     extract-chip-specific-code-out-of-lasi_82596c-update-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: extract-chip-specific-code-out-of-lasi_82596c-update 2
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)

Changes to last version:
- use netdev_alloc_skb
- make init_rx_bufs just fail and not panic, if skb alloc fails
- don/t free_irq, if request_irq failed

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/lib82596.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/net/lib82596.c~extract-chip-specific-code-out-of-lasi_82596c-update-2 drivers/net/lib82596.c
--- a/drivers/net/lib82596.c~extract-chip-specific-code-out-of-lasi_82596c-update-2
+++ a/drivers/net/lib82596.c
@@ -460,7 +460,7 @@ static void i596_display_data(struct net
 
 #define virt_to_dma(lp, v) ((lp)->dma_addr + (dma_addr_t)((unsigned long)(v)-(unsigned long)((lp)->dma)))
 
-static inline void init_rx_bufs(struct net_device *dev)
+static inline int init_rx_bufs(struct net_device *dev)
 {
 	struct i596_private *lp = netdev_priv(dev);
 	struct i596_dma *dma = lp->dma;
@@ -472,14 +472,13 @@ static inline void init_rx_bufs(struct n
 
 	for (i = 0, rbd = dma->rbds; i < rx_ring_size; i++, rbd++) {
 		dma_addr_t dma_addr;
-		struct sk_buff *skb = dev_alloc_skb(PKT_BUF_SZ + 4);
+		struct sk_buff *skb = netdev_alloc_skb(dev, PKT_BUF_SZ + 4);
 
 		if (skb == NULL)
-			panic(KERN_ERR "%s: alloc_skb() failed", __FILE__);
+			return -1;
 		skb_reserve(skb, 2);
 		dma_addr = dma_map_single(dev->dev.parent, skb->data,
 					  PKT_BUF_SZ, DMA_FROM_DEVICE);
-		skb->dev = dev;
 		rbd->v_next = rbd+1;
 		rbd->b_next = SWAP32(virt_to_dma(lp, rbd+1));
 		rbd->b_addr = SWAP32(virt_to_dma(lp, rbd));
@@ -513,6 +512,7 @@ static inline void init_rx_bufs(struct n
 	rfd->cmd = SWAP16(CMD_EOL|CMD_FLEX);
 
 	DMA_WBACK_INV(dev, dma, sizeof(struct i596_dma));
+	return 0;
 }
 
 static inline void remove_rx_bufs(struct net_device *dev)
@@ -592,7 +592,7 @@ static int init_i596_mem(struct net_devi
 
 	if (request_irq(dev->irq, &i596_interrupt, 0, "i82596", dev)) {
 		printk(KERN_ERR "%s: IRQ %d not free\n", dev->name, dev->irq);
-		goto failed_free_irq;
+		goto failed;
 	}
 
 	/* Ensure rx frame/buffer descriptors are tidy */
@@ -699,7 +699,7 @@ static inline int i596_rx(struct net_dev
 						 (dma_addr_t)SWAP32(rbd->b_data),
 						 PKT_BUF_SZ, DMA_FROM_DEVICE);
 				/* Get fresh skbuff to replace filled one. */
-				newskb = dev_alloc_skb(PKT_BUF_SZ + 4);
+				newskb = netdev_alloc_skb(dev, PKT_BUF_SZ + 4);
 				if (newskb == NULL) {
 					skb = NULL;	/* drop pkt */
 					goto memory_squeeze;
@@ -710,7 +710,6 @@ static inline int i596_rx(struct net_dev
 				skb_put(skb, pkt_len);
 				rx_in_place = 1;
 				rbd->skb = newskb;
-				newskb->dev = dev;
 				dma_addr = dma_map_single(dev->dev.parent,
 							  newskb->data,
 							  PKT_BUF_SZ,
@@ -719,7 +718,7 @@ static inline int i596_rx(struct net_dev
 				rbd->b_data = SWAP32(dma_addr);
 				DMA_WBACK_INV(dev, rbd, sizeof(struct i596_rbd));
 			} else
-				skb = dev_alloc_skb(pkt_len + 2);
+				skb = netdev_alloc_skb(dev, pkt_len + 2);
 memory_squeeze:
 			if (skb == NULL) {
 				/* XXX tulip.c can defer packets here!! */
@@ -728,7 +727,6 @@ memory_squeeze:
 				       dev->name);
 				lp->stats.rx_dropped++;
 			} else {
-				skb->dev = dev;
 				if (!rx_in_place) {
 					/* 16 byte align the data fields */
 					dma_sync_single_for_cpu(dev->dev.parent,
@@ -927,8 +925,10 @@ static int i596_open(struct net_device *
 	DEB(DEB_OPEN, printk(KERN_DEBUG
 			     "%s: i596_open() irq %d.\n", dev->name, dev->irq));
 
-	init_rx_bufs(dev);
-
+	if (init_rx_bufs(dev)) {
+		printk(KERN_ERR "%s: Failed to init rx bufs\n", dev->name);
+		return -EAGAIN;
+	}
 	if (init_i596_mem(dev)) {
 		printk(KERN_ERR "%s: Failed to init memory\n", dev->name);
 		goto out_remove_rx_bufs;
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

extract-chip-specific-code-out-of-lasi_82596c.patch
extract-chip-specific-code-out-of-lasi_82596c-update.patch
extract-chip-specific-code-out-of-lasi_82596c-update-2.patch
ethernet-driver-for-eisa-only-sni-rm200-rm400-machines.patch
ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update.patch
git-scsi-misc.patch
rtc-driver-for-ds1216-chips.patch
rtc-driver-for-ds1216-chips-fix.patch
