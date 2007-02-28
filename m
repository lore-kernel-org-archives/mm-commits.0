From: akpm@linux-foundation.org
Subject: - spidernet-fix-racy-double-free-of-skb.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:53:03 -0800
Message-ID: <200702282353.l1SNr3eL031052@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48613 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932778AbXB1X4z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:56:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, Jens.Osterkamp@de.ibm.com, kou.ishizaki@toshiba.co.jp, mm-commits@vger.kernel.org


The patch titled
     spidernet: fix racy double-free of skb
has been removed from the -mm tree.  Its filename was
     spidernet-fix-racy-double-free-of-skb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spidernet: fix racy double-free of skb
From: Linas Vepstas <linas@austin.ibm.com>

It appears that under certain circumstances, a race will result in a
double-free of an skb.  This patch null's out the skb pointer upon the skb
free, avoiding the inadvertent deref of bogus data.  The next patch fixes the
actual race.

Cc: Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
Cc: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/spider_net.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-fix-racy-double-free-of-skb drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-fix-racy-double-free-of-skb
+++ a/drivers/net/spider_net.c
@@ -396,10 +396,11 @@ spider_net_free_rx_chain_contents(struct
 	descr = card->rx_chain.head;
 	do {
 		if (descr->skb) {
-			dev_kfree_skb(descr->skb);
 			pci_unmap_single(card->pdev, descr->hwdescr->buf_addr,
 					 SPIDER_NET_MAX_FRAME,
 					 PCI_DMA_BIDIRECTIONAL);
+			dev_kfree_skb(descr->skb);
+			descr->skb = NULL;
 		}
 		descr = descr->next;
 	} while (descr != card->rx_chain.head);
@@ -453,6 +454,7 @@ spider_net_prepare_rx_descr(struct spide
 			SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
 	if (pci_dma_mapping_error(buf)) {
 		dev_kfree_skb_any(descr->skb);
+		descr->skb = NULL;
 		if (netif_msg_rx_err(card) && net_ratelimit())
 			pr_err("Could not iommu-map rx buffer\n");
 		card->spider_stats.rx_iommu_map_error++;
@@ -682,6 +684,7 @@ static int
 spider_net_prepare_tx_descr(struct spider_net_card *card,
 			    struct sk_buff *skb)
 {
+	struct spider_net_descr_chain *chain = &card->tx_chain;
 	struct spider_net_descr *descr;
 	struct spider_net_hw_descr *hwdescr;
 	dma_addr_t buf;
@@ -696,10 +699,15 @@ spider_net_prepare_tx_descr(struct spide
 		return -ENOMEM;
 	}
 
-	spin_lock_irqsave(&card->tx_chain.lock, flags);
+	spin_lock_irqsave(&chain->lock, flags);
 	descr = card->tx_chain.head;
+	if (descr->next == chain->tail->prev) {
+		spin_unlock_irqrestore(&chain->lock, flags);
+		pci_unmap_single(card->pdev, buf, skb->len, PCI_DMA_TODEVICE);
+		return -ENOMEM;
+	}
 	hwdescr = descr->hwdescr;
-	card->tx_chain.head = descr->next;
+	chain->head = descr->next;
 
 	descr->skb = skb;
 	hwdescr->buf_addr = buf;
@@ -709,7 +717,7 @@ spider_net_prepare_tx_descr(struct spide
 
 	hwdescr->dmac_cmd_status =
 			SPIDER_NET_DESCR_CARDOWNED | SPIDER_NET_DMAC_NOCS;
-	spin_unlock_irqrestore(&card->tx_chain.lock, flags);
+	spin_unlock_irqrestore(&chain->lock, flags);
 
 	if (skb->protocol == htons(ETH_P_IP))
 		switch (skb->nh.iph->protocol) {
@@ -838,6 +846,7 @@ spider_net_release_tx_chain(struct spide
 		chain->tail = descr->next;
 		hwdescr->dmac_cmd_status |= SPIDER_NET_DESCR_NOT_IN_USE;
 		skb = descr->skb;
+		descr->skb = NULL;
 		buf_addr = hwdescr->buf_addr;
 		spin_unlock_irqrestore(&chain->lock, flags);
 
@@ -903,13 +912,10 @@ spider_net_xmit(struct sk_buff *skb, str
 {
 	int cnt;
 	struct spider_net_card *card = netdev_priv(netdev);
-	struct spider_net_descr_chain *chain = &card->tx_chain;
 
 	spider_net_release_tx_chain(card, 0);
 
-	if ((chain->head->next == chain->tail->prev) ||
-	   (spider_net_prepare_tx_descr(card, skb) != 0)) {
-
+	if (spider_net_prepare_tx_descr(card, skb) != 0) {
 		card->netdev_stats.tx_dropped++;
 		netif_stop_queue(netdev);
 		return NETDEV_TX_BUSY;
@@ -1127,6 +1133,7 @@ spider_net_decode_one_descr(struct spide
 
 bad_desc:
 	dev_kfree_skb_irq(descr->skb);
+	descr->skb = NULL;
 	hwdescr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
 	return 0;
 }
_

Patches currently in -mm which might be from linas@austin.ibm.com are

s2io-add-pci-error-recovery-support.patch
