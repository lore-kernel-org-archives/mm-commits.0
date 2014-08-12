From: akpm@linux-foundation.org
Subject: [merged] atl1e-use-pci_zalloc_consistent.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:42:33 -0700
Message-ID: <53ea6e29.pQ4RiE++RJev7CAt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:56302 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbaHLTmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:33 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so2669802pdj.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: atl1e: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     atl1e-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: atl1e: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/net/ethernet/atheros/atl1e/atl1e_main.c~atl1e-use-pci_zalloc_consistent drivers/net/ethernet/atheros/atl1e/atl1e_main.c
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c~atl1e-use-pci_zalloc_consistent
+++ a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -831,17 +831,14 @@ static int atl1e_setup_ring_resources(st
 	/* real ring DMA buffer */
 
 	size = adapter->ring_size;
-	adapter->ring_vir_addr = pci_alloc_consistent(pdev,
-			adapter->ring_size, &adapter->ring_dma);
-
+	adapter->ring_vir_addr = pci_zalloc_consistent(pdev, adapter->ring_size,
+						       &adapter->ring_dma);
 	if (adapter->ring_vir_addr == NULL) {
 		netdev_err(adapter->netdev,
 			   "pci_alloc_consistent failed, size = D%d\n", size);
 		return -ENOMEM;
 	}
 
-	memset(adapter->ring_vir_addr, 0, adapter->ring_size);
