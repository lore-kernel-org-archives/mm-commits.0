From: akpm@linux-foundation.org
Subject: [merged] micrel-use-pci_zalloc_consistent.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:42:39 -0700
Message-ID: <53ea6e2f.lQ8CejHyUPiWey7s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:53681 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaHLTmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:40 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2666846pab.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: micrel: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     micrel-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: micrel: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/micrel/ksz884x.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/net/ethernet/micrel/ksz884x.c~micrel-use-pci_zalloc_consistent drivers/net/ethernet/micrel/ksz884x.c
--- a/drivers/net/ethernet/micrel/ksz884x.c~micrel-use-pci_zalloc_consistent
+++ a/drivers/net/ethernet/micrel/ksz884x.c
@@ -4409,14 +4409,13 @@ static int ksz_alloc_desc(struct dev_inf
 		DESC_ALIGNMENT;
 
 	adapter->desc_pool.alloc_virt =
-		pci_alloc_consistent(
-			adapter->pdev, adapter->desc_pool.alloc_size,
-			&adapter->desc_pool.dma_addr);
+		pci_zalloc_consistent(adapter->pdev,
+				      adapter->desc_pool.alloc_size,
+				      &adapter->desc_pool.dma_addr);
 	if (adapter->desc_pool.alloc_virt == NULL) {
 		adapter->desc_pool.alloc_size = 0;
 		return 1;
 	}
-	memset(adapter->desc_pool.alloc_virt, 0, adapter->desc_pool.alloc_size);
 
 	/* Align to the next cache line boundary. */
 	offset = (((ulong) adapter->desc_pool.alloc_virt % DESC_ALIGNMENT) ?
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

