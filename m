From: akpm@osdl.org
Subject: + spidernet-dma-coalescing.patch added to -mm tree
Date: Wed, 06 Dec 2006 21:36:27 -0800
Message-ID: <200612070536.kB75aR26031637@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51213 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031326AbWLGFsy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 00:48:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, jschopp@austin.ibm.com


The patch titled
     spidernet: DMA coalescing
has been added to the -mm tree.  Its filename is
     spidernet-dma-coalescing.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spidernet: DMA coalescing
From: Linas Vepstas <linas@austin.ibm.com>

The current driver code performs 512 DMA mappings of a bunch of 32-byte
structures.  This is silly, as they are all in contiguous memory.  Ths patch
changes the code to DMA map the entie area with just one call.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Acked-by: Joel Schopp <jschopp@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |  107 ++++++++++++++++++-------------------
 drivers/net/spider_net.h |   16 ++---
 2 files changed, 59 insertions(+), 64 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-dma-coalescing drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-dma-coalescing
+++ a/drivers/net/spider_net.c
@@ -269,25 +269,6 @@ spider_net_get_descr_status(struct spide
 }
 
 /**
- * spider_net_free_chain - free descriptor chain
- * @card: card structure
- * @chain: address of chain
- *
- */
-static void
-spider_net_free_chain(struct spider_net_card *card,
-		      struct spider_net_descr_chain *chain)
-{
-	struct spider_net_descr *descr;
-
-	for (descr = chain->tail; !descr->bus_addr; descr = descr->next) {
-		pci_unmap_single(card->pdev, descr->bus_addr,
-				 SPIDER_NET_DESCR_SIZE, PCI_DMA_BIDIRECTIONAL);
-		descr->bus_addr = 0;
-	}
-}
-
-/**
  * spider_net_init_chain - links descriptor chain
  * @card: card structure
  * @chain: address of chain
@@ -299,15 +280,15 @@ spider_net_free_chain(struct spider_net_
  *
  * returns 0 on success, <0 on failure
  */
-static int
+static void
 spider_net_init_chain(struct spider_net_card *card,
 		       struct spider_net_descr_chain *chain,
 		       struct spider_net_descr *start_descr,
+		       dma_addr_t buf,
 		       int no)
 {
 	int i;
 	struct spider_net_descr *descr;
-	dma_addr_t buf;
 
 	descr = start_descr;
 	memset(descr, 0, sizeof(*descr) * no);
@@ -316,17 +297,12 @@ spider_net_init_chain(struct spider_net_
 	for (i=0; i<no; i++, descr++) {
 		descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
 
-		buf = pci_map_single(card->pdev, descr,
-				     SPIDER_NET_DESCR_SIZE,
-				     PCI_DMA_BIDIRECTIONAL);
-
-		if (pci_dma_mapping_error(buf))
-			goto iommu_error;
-
 		descr->bus_addr = buf;
+		descr->next_descr_addr = 0;
 		descr->next = descr + 1;
 		descr->prev = descr - 1;
 
+		buf += sizeof(struct spider_net_descr);
 	}
 	/* do actual circular list */
 	(descr-1)->next = start_descr;
@@ -335,17 +311,6 @@ spider_net_init_chain(struct spider_net_
 	spin_lock_init(&chain->lock);
 	chain->head = start_descr;
 	chain->tail = start_descr;
-
-	return 0;
-
-iommu_error:
-	descr = start_descr;
-	for (i=0; i < no; i++, descr++)
-		if (descr->bus_addr)
-			pci_unmap_single(card->pdev, descr->bus_addr,
-					 SPIDER_NET_DESCR_SIZE,
-					 PCI_DMA_BIDIRECTIONAL);
-	return -ENOMEM;
 }
 
 /**
@@ -1652,24 +1617,32 @@ spider_net_open(struct net_device *netde
 {
 	struct spider_net_card *card = netdev_priv(netdev);
 	struct spider_net_descr *descr;
-	int i, result;
+	int result = -ENOMEM;
 
-	result = -ENOMEM;
-	if (spider_net_init_chain(card, &card->tx_chain, card->descr,
-	                          card->num_tx_desc))
-		goto alloc_tx_failed;
+	card->descr_dma_addr = pci_map_single(card->pdev, card->descr,
+	        (card->num_tx_desc+card->num_rx_desc)*sizeof(struct spider_net_descr),
+				     PCI_DMA_BIDIRECTIONAL);
+	if (pci_dma_mapping_error(card->descr_dma_addr))
+		return -ENOMEM;
+
+	spider_net_init_chain(card, &card->tx_chain, card->descr,
+	                          card->descr_dma_addr,
+	                          card->num_tx_desc);
 
 	card->low_watermark = NULL;
 
 	/* rx_chain is after tx_chain, so offset is descr + tx_count */
-	if (spider_net_init_chain(card, &card->rx_chain,
+	spider_net_init_chain(card, &card->rx_chain,
 	                          card->descr + card->num_tx_desc,
-	                          card->num_rx_desc))
-		goto alloc_rx_failed;
+	                          card->descr_dma_addr
+					+ card->num_tx_desc * sizeof(struct spider_net_descr),
+	                          card->num_rx_desc);
 
 	descr = card->rx_chain.head;
-	for (i=0; i < card->num_rx_desc; i++, descr++)
+	do {
 		descr->next_descr_addr = descr->next->bus_addr;
+		descr = descr->next;
+	} while (descr != card->rx_chain.head);
 
 	/* allocate rx skbs */
 	if (spider_net_alloc_rx_skbs(card))
@@ -1695,10 +1668,21 @@ spider_net_open(struct net_device *netde
 register_int_failed:
 	spider_net_free_rx_chain_contents(card);
 alloc_skbs_failed:
-	spider_net_free_chain(card, &card->rx_chain);
-alloc_rx_failed:
-	spider_net_free_chain(card, &card->tx_chain);
-alloc_tx_failed:
+	descr = card->rx_chain.head;
+	do {
+		descr->bus_addr = 0;
+		descr = descr->next;
+	} while (descr != card->rx_chain.head);
+
+	descr = card->tx_chain.head;
+	do {
+		descr->bus_addr = 0;
+		descr = descr->next;
+	} while (descr != card->tx_chain.head);
+
+	pci_unmap_single(card->pdev, card->descr_dma_addr,
+	   (card->num_tx_desc+card->num_rx_desc)*sizeof(struct spider_net_descr),
+	                 PCI_DMA_BIDIRECTIONAL);
 	return result;
 }
 
@@ -1901,6 +1885,7 @@ int
 spider_net_stop(struct net_device *netdev)
 {
 	struct spider_net_card *card = netdev_priv(netdev);
+	struct spider_net_descr *descr;
 
 	tasklet_kill(&card->rxram_full_tl);
 	netif_poll_disable(netdev);
@@ -1924,9 +1909,23 @@ spider_net_stop(struct net_device *netde
 
 	/* release chains */
 	spider_net_release_tx_chain(card, 1);
+	spider_net_free_rx_chain_contents(card);
+
+	descr = card->rx_chain.head;
+	do {
+		descr->bus_addr = 0;
+		descr = descr->next;
+	} while (descr != card->rx_chain.head);
+
+	descr = card->tx_chain.head;
+	do {
+		descr->bus_addr = 0;
+		descr = descr->next;
+	} while (descr != card->tx_chain.head);
 
-	spider_net_free_chain(card, &card->tx_chain);
-	spider_net_free_chain(card, &card->rx_chain);
+	pci_unmap_single(card->pdev, card->descr_dma_addr,
+	      (card->num_tx_desc+card->num_rx_desc)*sizeof(struct spider_net_descr),
+	                 PCI_DMA_BIDIRECTIONAL);
 
 	return 0;
 }
diff -puN drivers/net/spider_net.h~spidernet-dma-coalescing drivers/net/spider_net.h
--- a/drivers/net/spider_net.h~spidernet-dma-coalescing
+++ a/drivers/net/spider_net.h
@@ -397,8 +397,6 @@ struct spider_net_descr_chain {
  * 701b8000 would be correct, but every packets gets that flag */
 #define SPIDER_NET_DESTROY_RX_FLAGS	0x700b8000
 
-#define SPIDER_NET_DESCR_SIZE		32
-
 /* this will be bigger some time */
 struct spider_net_options {
 	int rx_csum; /* for rx: if 0 ip_summed=NONE,
@@ -437,28 +435,26 @@ struct spider_net_card {
 
 	void __iomem *regs;
 
+	int num_rx_desc;
+	int num_tx_desc;
 	struct spider_net_descr_chain tx_chain;
 	struct spider_net_descr_chain rx_chain;
 	struct spider_net_descr *low_watermark;
+	dma_addr_t descr_dma_addr;
 
-	struct net_device_stats netdev_stats;
-
-	struct spider_net_options options;
-
-	spinlock_t intmask_lock;
 	struct tasklet_struct rxram_full_tl;
 	struct timer_list tx_timer;
-
 	struct work_struct tx_timeout_task;
 	atomic_t tx_timeout_task_counter;
 	wait_queue_head_t waitq;
 
 	/* for ethtool */
 	int msg_enable;
-	int num_rx_desc;
-	int num_tx_desc;
+	struct net_device_stats netdev_stats;
 	struct spider_net_extra_stats spider_stats;
+	struct spider_net_options options;
 
+	/* Must be last element in the structure */
 	struct spider_net_descr descr[0];
 };
 
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
hvcs-char-driver-janitoring-move-block-of-code.patch
spidernet-dma-coalescing.patch
spidernet-add-net_ratelimit-to-suppress-long-output.patch
spidernet-rx-locking.patch
spidernet-refactor-rx-refill.patch
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

