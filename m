From: akpm@osdl.org
Subject: + spidernet-dma-coalescing.patch added to -mm tree
Date: Thu, 14 Dec 2006 13:45:26 -0800
Message-ID: <200612142145.kBELjQis029515@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33013 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932947AbWLNVrI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 16:47:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com


The patch titled
     Spidernet: DMA coalescing
has been added to the -mm tree.  Its filename is
     spidernet-dma-coalescing.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Spidernet: DMA coalescing
From: Linas Vepstas <linas@austin.ibm.com>

The current driver code performs 512 DMA mappings of a bunch of 32-byte ring
descriptor structures.  This is silly, as they are all in contiguous memory. 
This patch changes the code to dma_map_coherent() each rx/tx ring as a whole.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c         |  101 ++++++++++++-----------------
 drivers/net/spider_net.h         |   17 +---
 drivers/net/spider_net_ethtool.c |    4 -
 3 files changed, 52 insertions(+), 70 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-dma-coalescing drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-dma-coalescing
+++ a/drivers/net/spider_net.c
@@ -280,72 +280,65 @@ spider_net_free_chain(struct spider_net_
 {
 	struct spider_net_descr *descr;
 
-	for (descr = chain->tail; !descr->bus_addr; descr = descr->next) {
-		pci_unmap_single(card->pdev, descr->bus_addr,
-				 SPIDER_NET_DESCR_SIZE, PCI_DMA_BIDIRECTIONAL);
+	descr = chain->ring;
+	do {
 		descr->bus_addr = 0;
-	}
+		descr->next_descr_addr = 0;
+		descr = descr->next;
+	} while (descr != chain->ring);
+
+	dma_free_coherent(&card->pdev->dev, chain->num_desc,
+	    chain->ring, chain->dma_addr);
 }
 
 /**
- * spider_net_init_chain - links descriptor chain
+ * spider_net_init_chain - alloc and link descriptor chain
  * @card: card structure
  * @chain: address of chain
- * @start_descr: address of descriptor array
- * @no: number of descriptors
  *
- * we manage a circular list that mirrors the hardware structure,
+ * We manage a circular list that mirrors the hardware structure,
  * except that the hardware uses bus addresses.
  *
- * returns 0 on success, <0 on failure
+ * Returns 0 on success, <0 on failure
  */
 static int
 spider_net_init_chain(struct spider_net_card *card,
-		       struct spider_net_descr_chain *chain,
-		       struct spider_net_descr *start_descr,
-		       int no)
+		       struct spider_net_descr_chain *chain)
 {
 	int i;
 	struct spider_net_descr *descr;
 	dma_addr_t buf;
+	size_t alloc_size;
 
-	descr = start_descr;
-	memset(descr, 0, sizeof(*descr) * no);
+	alloc_size = chain->num_desc * sizeof (struct spider_net_descr);
 
-	/* set up the hardware pointers in each descriptor */
-	for (i=0; i<no; i++, descr++) {
-		descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
+	chain->ring = dma_alloc_coherent(&card->pdev->dev, alloc_size,
+		&chain->dma_addr, GFP_KERNEL);
 
-		buf = pci_map_single(card->pdev, descr,
-				     SPIDER_NET_DESCR_SIZE,
-				     PCI_DMA_BIDIRECTIONAL);
+	if (!chain->ring)
+		return -ENOMEM;
 
-		if (pci_dma_mapping_error(buf))
-			goto iommu_error;
+	/* Set up the hardware pointers in each descriptor */
+	descr = chain->ring;
+	buf = chain->dma_addr;
+	for (i=0; i < chain->num_desc; i++, descr++) {
+		descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
 
 		descr->bus_addr = buf;
+		descr->next_descr_addr = 0;
 		descr->next = descr + 1;
 		descr->prev = descr - 1;
 
+		buf += sizeof(struct spider_net_descr);
 	}
 	/* do actual circular list */
-	(descr-1)->next = start_descr;
-	start_descr->prev = descr-1;
+	(descr-1)->next = chain->ring;
+	chain->ring->prev = descr-1;
 
 	spin_lock_init(&chain->lock);
-	chain->head = start_descr;
-	chain->tail = start_descr;
-
+	chain->head = chain->ring;
+	chain->tail = chain->ring;
 	return 0;
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
@@ -707,7 +700,7 @@ spider_net_set_low_watermark(struct spid
 	}
 
 	/* If TX queue is short, don't even bother with interrupts */
-	if (cnt < card->num_tx_desc/4)
+	if (cnt < card->tx_chain.num_desc/4)
 		return cnt;
 
 	/* Set low-watermark 3/4th's of the way into the queue. */
@@ -1652,26 +1645,25 @@ spider_net_open(struct net_device *netde
 {
 	struct spider_net_card *card = netdev_priv(netdev);
 	struct spider_net_descr *descr;
-	int i, result;
+	int result;
 
-	result = -ENOMEM;
-	if (spider_net_init_chain(card, &card->tx_chain, card->descr,
-	                          card->num_tx_desc))
+	result = spider_net_init_chain(card, &card->tx_chain);
+	if (result)
 		goto alloc_tx_failed;
-
 	card->low_watermark = NULL;
 
-	/* rx_chain is after tx_chain, so offset is descr + tx_count */
-	if (spider_net_init_chain(card, &card->rx_chain,
-	                          card->descr + card->num_tx_desc,
-	                          card->num_rx_desc))
+	result = spider_net_init_chain(card, &card->rx_chain);
+	if (result)
 		goto alloc_rx_failed;
 
-	descr = card->rx_chain.head;
-	for (i=0; i < card->num_rx_desc; i++, descr++)
+	/* Make a ring of of bus addresses */
+	descr = card->rx_chain.ring;
+	do {
 		descr->next_descr_addr = descr->next->bus_addr;
+		descr = descr->next;
+	} while (descr != card->rx_chain.ring);
 
-	/* allocate rx skbs */
+	/* Allocate rx skbs */
 	if (spider_net_alloc_rx_skbs(card))
 		goto alloc_skbs_failed;
 
@@ -1924,6 +1916,7 @@ spider_net_stop(struct net_device *netde
 
 	/* release chains */
 	spider_net_release_tx_chain(card, 1);
+	spider_net_free_rx_chain_contents(card);
 
 	spider_net_free_chain(card, &card->tx_chain);
 	spider_net_free_chain(card, &card->rx_chain);
@@ -2055,8 +2048,8 @@ spider_net_setup_netdev(struct spider_ne
 
 	card->options.rx_csum = SPIDER_NET_RX_CSUM_DEFAULT;
 
-	card->num_tx_desc = tx_descriptors;
-	card->num_rx_desc = rx_descriptors;
+	card->tx_chain.num_desc = tx_descriptors;
+	card->rx_chain.num_desc = rx_descriptors;
 
 	spider_net_setup_netdev_ops(netdev);
 
@@ -2105,12 +2098,8 @@ spider_net_alloc_card(void)
 {
 	struct net_device *netdev;
 	struct spider_net_card *card;
-	size_t alloc_size;
 
-	alloc_size = sizeof (*card) +
-		sizeof (struct spider_net_descr) * rx_descriptors +
-		sizeof (struct spider_net_descr) * tx_descriptors;
-	netdev = alloc_etherdev(alloc_size);
+	netdev = alloc_etherdev(sizeof(struct spider_net_card));
 	if (!netdev)
 		return NULL;
 
diff -puN drivers/net/spider_net.h~spidernet-dma-coalescing drivers/net/spider_net.h
--- a/drivers/net/spider_net.h~spidernet-dma-coalescing
+++ a/drivers/net/spider_net.h
@@ -378,6 +378,9 @@ struct spider_net_descr_chain {
 	spinlock_t lock;
 	struct spider_net_descr *head;
 	struct spider_net_descr *tail;
+	struct spider_net_descr *ring;
+	int num_desc;
+	dma_addr_t dma_addr;
 };
 
 /* descriptor data_status bits */
@@ -397,8 +400,6 @@ struct spider_net_descr_chain {
  * 701b8000 would be correct, but every packets gets that flag */
 #define SPIDER_NET_DESTROY_RX_FLAGS	0x700b8000
 
-#define SPIDER_NET_DESCR_SIZE		32
-
 /* this will be bigger some time */
 struct spider_net_options {
 	int rx_csum; /* for rx: if 0 ip_summed=NONE,
@@ -441,25 +442,17 @@ struct spider_net_card {
 	struct spider_net_descr_chain rx_chain;
 	struct spider_net_descr *low_watermark;
 
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
-
-	struct spider_net_descr descr[0];
+	struct spider_net_options options;
 };
 
 #define pr_err(fmt,arg...) \
diff -puN drivers/net/spider_net_ethtool.c~spidernet-dma-coalescing drivers/net/spider_net_ethtool.c
--- a/drivers/net/spider_net_ethtool.c~spidernet-dma-coalescing
+++ a/drivers/net/spider_net_ethtool.c
@@ -158,9 +158,9 @@ spider_net_ethtool_get_ringparam(struct 
 	struct spider_net_card *card = netdev->priv;
 
 	ering->tx_max_pending = SPIDER_NET_TX_DESCRIPTORS_MAX;
-	ering->tx_pending = card->num_tx_desc;
+	ering->tx_pending = card->tx_chain.num_desc;
 	ering->rx_max_pending = SPIDER_NET_RX_DESCRIPTORS_MAX;
-	ering->rx_pending = card->num_rx_desc;
+	ering->rx_pending = card->rx_chain.num_desc;
 }
 
 static int spider_net_get_stats_count(struct net_device *netdev)
_

Patches currently in -mm which might be from linas@austin.ibm.com are

spidernet-dma-coalescing.patch
spidernet-add-net_ratelimit-to-suppress-long-output.patch
spidernet-remove-rxramfull-tasklet.patch
spidernet-cleanup-un-needed-api.patch
spidernet-rx-skb-mem-leak.patch
spidernet-another-skb-mem-leak.patch
spidernet-cleanup-return-codes.patch
spidernet-rx-refill.patch
spidernet-remove-unused-variable.patch
spidernet-rx-chain-tail.patch
spidernet-memory-barrier.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

