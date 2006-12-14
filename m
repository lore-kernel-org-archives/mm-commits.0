From: akpm@osdl.org
Subject: - spidernet-rx-skb-mem-leak.patch removed from -mm tree
Date: Wed, 13 Dec 2006 16:20:57 -0800
Message-ID: <200612140021.kBE0L2cw025959@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:32915 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbWLNAVH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:21:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spidernet: RX skb mem leak
has been removed from the -mm tree.  Its filename was
     spidernet-rx-skb-mem-leak.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: spidernet: RX skb mem leak
From: Linas Vepstas <linas@austin.ibm.com>

One of the unlikely error branches has an skb memory leak.  Fix this by
handling the error conditions consistently.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-rx-skb-mem-leak drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-rx-skb-mem-leak
+++ a/drivers/net/spider_net.c
@@ -884,8 +884,8 @@ spider_net_do_ioctl(struct net_device *n
  *
  * returns 1 on success, 0 if no packet was passed to the stack
  *
- * iommu-unmaps the skb, fills out skb structure and passes the data to the
- * stack. The descriptor state is not changed.
+ * Fills out skb structure and passes the data to the stack.
+ * The descriptor state is not changed.
  */
 static int
 spider_net_pass_skb_up(struct spider_net_descr *descr,
@@ -900,10 +900,6 @@ spider_net_pass_skb_up(struct spider_net
 
 	netdev = card->netdev;
 
-	/* unmap descriptor */
-	pci_unmap_single(card->pdev, descr->buf_addr, SPIDER_NET_MAX_FRAME,
-			PCI_DMA_FROMDEVICE);
-
 	/* the cases we'll throw away the packet immediately */
 	if (data_error & SPIDER_NET_DESTROY_RX_FLAGS) {
 		if (netif_msg_rx_err(card))
@@ -998,6 +994,11 @@ spider_net_decode_one_descr(struct spide
 	spin_unlock_irqrestore(&chain->lock, flags);
 
 	result = 0;
+
+	/* unmap descriptor */
+	pci_unmap_single(card->pdev, descr->buf_addr,
+			SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
+
 	if ( (status == SPIDER_NET_DESCR_RESPONSE_ERROR) ||
 	     (status == SPIDER_NET_DESCR_PROTECTION_ERROR) ||
 	     (status == SPIDER_NET_DESCR_FORCE_END) ) {
@@ -1005,8 +1006,6 @@ spider_net_decode_one_descr(struct spide
 			pr_err("%s: dropping RX descriptor with state %d\n",
 			       card->netdev->name, status);
 		card->netdev_stats.rx_dropped++;
-		pci_unmap_single(card->pdev, descr->buf_addr,
-				SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
 		dev_kfree_skb_irq(descr->skb);
 		goto refill;
 	}
@@ -1014,9 +1013,10 @@ spider_net_decode_one_descr(struct spide
 	if ( (status != SPIDER_NET_DESCR_COMPLETE) &&
 	     (status != SPIDER_NET_DESCR_FRAME_END) ) {
 		if (netif_msg_rx_err(card))
-			pr_err("%s: RX descriptor with state %d\n",
+			pr_err("%s: RX descriptor with unkown state %d\n",
 			       card->netdev->name, status);
 		card->spider_stats.rx_desc_unk_state++;
+		dev_kfree_skb_irq(descr->skb);
 		goto refill;
 	}
 
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
spidernet-rx-skb-mem-leak.patch
spidernet-another-skb-mem-leak.patch
spidernet-cleanup-return-codes.patch
spidernet-rx-refill.patch
spidernet-merge-error-branches.patch
spidernet-remove-unused-variable.patch
spidernet-rx-chain-tail.patch
spidernet-turn-rx-irq-back-on.patch
spidernet-memory-barrier.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

