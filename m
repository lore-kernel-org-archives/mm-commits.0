From: akpm@linux-foundation.org
Subject: [merged] amd-use-pci_zalloc_consistent.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:42:31 -0700
Message-ID: <53ea6e27.Z5DK2G9HtT0vqhqF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:62649 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbaHLTmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:31 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2670897pab.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, pcnet32@frontier.com, mm-commits@vger.kernel.org


The patch titled
     Subject: amd: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     amd-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: amd: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Don Fry <pcnet32@frontier.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/amd/pcnet32.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/net/ethernet/amd/pcnet32.c~amd-use-pci_zalloc_consistent drivers/net/ethernet/amd/pcnet32.c
--- a/drivers/net/ethernet/amd/pcnet32.c~amd-use-pci_zalloc_consistent
+++ a/drivers/net/ethernet/amd/pcnet32.c
@@ -484,15 +484,14 @@ static void pcnet32_realloc_tx_ring(stru
 
 	pcnet32_purge_tx_ring(dev);
 
-	new_tx_ring = pci_alloc_consistent(lp->pci_dev,
-					   sizeof(struct pcnet32_tx_head) *
-					   (1 << size),
-					   &new_ring_dma_addr);
+	new_tx_ring = pci_zalloc_consistent(lp->pci_dev,
+					    sizeof(struct pcnet32_tx_head) *
+					    (1 << size),
+					    &new_ring_dma_addr);
 	if (new_tx_ring == NULL) {
 		netif_err(lp, drv, dev, "Consistent memory allocation failed\n");
 		return;
 	}
-	memset(new_tx_ring, 0, sizeof(struct pcnet32_tx_head) * (1 << size));
 
 	new_dma_addr_list = kcalloc(1 << size, sizeof(dma_addr_t),
 				    GFP_ATOMIC);
@@ -551,15 +550,14 @@ static void pcnet32_realloc_rx_ring(stru
 	int new, overlap;
 	unsigned int entries = 1 << size;
 
-	new_rx_ring = pci_alloc_consistent(lp->pci_dev,
-					   sizeof(struct pcnet32_rx_head) *
-					   entries,
-					   &new_ring_dma_addr);
+	new_rx_ring = pci_zalloc_consistent(lp->pci_dev,
+					    sizeof(struct pcnet32_rx_head) *
+					    entries,
+					    &new_ring_dma_addr);
 	if (new_rx_ring == NULL) {
 		netif_err(lp, drv, dev, "Consistent memory allocation failed\n");
 		return;
 	}
-	memset(new_rx_ring, 0, sizeof(struct pcnet32_rx_head) * entries);
 
 	new_dma_addr_list = kcalloc(entries, sizeof(dma_addr_t), GFP_ATOMIC);
 	if (!new_dma_addr_list)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

