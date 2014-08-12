From: akpm@linux-foundation.org
Subject: [merged] amd-neaten-and-remove-unnecessary-oom-messages.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:01 -0700
Message-ID: <53ea6e45.0anpAYfSAZIHJEcQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:56840 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbaHLTnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:04 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so1069616igd.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, pcnet32@frontier.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/net/ethernet/amd/pcnet32.c: neaten and remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     amd-neaten-and-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: drivers/net/ethernet/amd/pcnet32.c: neaten and remove unnecessary OOM messages

Make the code flow a little better for 80 columns.

Use a consistent style for the RX and TX rings allocation.
Use BIT macro.
Use a temporary unsiged int entries for (1<<size).
Remove the OOM messages as they duplicate the generic
OOM and dump_stack() provided by the memory subsystem.
Reflow allocs to 80 columns.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Don Fry <pcnet32@frontier.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/amd/pcnet32.c |   43 +++++++++++----------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff -puN drivers/net/ethernet/amd/pcnet32.c~amd-neaten-and-remove-unnecessary-oom-messages drivers/net/ethernet/amd/pcnet32.c
--- a/drivers/net/ethernet/amd/pcnet32.c~amd-neaten-and-remove-unnecessary-oom-messages
+++ a/drivers/net/ethernet/amd/pcnet32.c
@@ -481,36 +481,32 @@ static void pcnet32_realloc_tx_ring(stru
 	dma_addr_t *new_dma_addr_list;
 	struct pcnet32_tx_head *new_tx_ring;
 	struct sk_buff **new_skb_list;
+	unsigned int entries = BIT(size);
 
 	pcnet32_purge_tx_ring(dev);
 
-	new_tx_ring = pci_zalloc_consistent(lp->pci_dev,
-					    sizeof(struct pcnet32_tx_head) *
-					    (1 << size),
-					    &new_ring_dma_addr);
-	if (new_tx_ring == NULL) {
-		netif_err(lp, drv, dev, "Consistent memory allocation failed\n");
+	new_tx_ring =
+		pci_zalloc_consistent(lp->pci_dev,
+				      sizeof(struct pcnet32_tx_head) * entries,
+				      &new_ring_dma_addr);
+	if (new_tx_ring == NULL)
 		return;
-	}
 
-	new_dma_addr_list = kcalloc(1 << size, sizeof(dma_addr_t),
-				    GFP_ATOMIC);
+	new_dma_addr_list = kcalloc(entries, sizeof(dma_addr_t), GFP_ATOMIC);
 	if (!new_dma_addr_list)
 		goto free_new_tx_ring;
 
-	new_skb_list = kcalloc(1 << size, sizeof(struct sk_buff *),
-			       GFP_ATOMIC);
+	new_skb_list = kcalloc(entries, sizeof(struct sk_buff *), GFP_ATOMIC);
 	if (!new_skb_list)
 		goto free_new_lists;
 
 	kfree(lp->tx_skbuff);
 	kfree(lp->tx_dma_addr);
 	pci_free_consistent(lp->pci_dev,
-			    sizeof(struct pcnet32_tx_head) *
-			    lp->tx_ring_size, lp->tx_ring,
-			    lp->tx_ring_dma_addr);
+			    sizeof(struct pcnet32_tx_head) * lp->tx_ring_size,
+			    lp->tx_ring, lp->tx_ring_dma_addr);
 
-	lp->tx_ring_size = (1 << size);
+	lp->tx_ring_size = entries;
 	lp->tx_mod_mask = lp->tx_ring_size - 1;
 	lp->tx_len_bits = (size << 12);
 	lp->tx_ring = new_tx_ring;
@@ -523,8 +519,7 @@ free_new_lists:
 	kfree(new_dma_addr_list);
 free_new_tx_ring:
 	pci_free_consistent(lp->pci_dev,
-			    sizeof(struct pcnet32_tx_head) *
-			    (1 << size),
+			    sizeof(struct pcnet32_tx_head) * entries,
 			    new_tx_ring,
 			    new_ring_dma_addr);
 }
@@ -548,16 +543,14 @@ static void pcnet32_realloc_rx_ring(stru
 	struct pcnet32_rx_head *new_rx_ring;
 	struct sk_buff **new_skb_list;
 	int new, overlap;
-	unsigned int entries = 1 << size;
+	unsigned int entries = BIT(size);
 
-	new_rx_ring = pci_zalloc_consistent(lp->pci_dev,
-					    sizeof(struct pcnet32_rx_head) *
-					    entries,
-					    &new_ring_dma_addr);
-	if (new_rx_ring == NULL) {
-		netif_err(lp, drv, dev, "Consistent memory allocation failed\n");
+	new_rx_ring =
+		pci_zalloc_consistent(lp->pci_dev,
+				      sizeof(struct pcnet32_rx_head) * entries,
+				      &new_ring_dma_addr);
+	if (new_rx_ring == NULL)
 		return;
-	}
 
 	new_dma_addr_list = kcalloc(entries, sizeof(dma_addr_t), GFP_ATOMIC);
 	if (!new_dma_addr_list)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

