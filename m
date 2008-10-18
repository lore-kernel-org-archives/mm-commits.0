From: akpm@linux-foundation.org
Subject: - alpha-use-iommu_num_pages-function-in-iommu-code.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:02 -0700
Message-ID: <200810182313.m9IND2Vi028109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973AbYJRXNO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, muli@il.ibm.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: use iommu_num_pages function in IOMMU code
has been removed from the -mm tree.  Its filename was
     alpha-use-iommu_num_pages-function-in-iommu-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: use iommu_num_pages function in IOMMU code
From: Joerg Roedel <joerg.roedel@amd.com>

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN arch/alpha/kernel/pci_iommu.c~alpha-use-iommu_num_pages-function-in-iommu-code arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-use-iommu_num_pages-function-in-iommu-code
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -41,13 +41,6 @@ mk_iommu_pte(unsigned long paddr)
 	return (paddr >> (PAGE_SHIFT-1)) | 1;
 }
 
-static inline long
-calc_npages(long bytes)
-{
-	return (bytes + PAGE_SIZE - 1) >> PAGE_SHIFT;
-}
-
-
 /* Return the minimum of MAX or the first power of two larger
    than main memory.  */
 
@@ -287,7 +280,7 @@ pci_map_single_1(struct pci_dev *pdev, v
 	if (!arena || arena->dma_base + arena->size - 1 > max_dma)
 		arena = hose->sg_isa;
 
-	npages = calc_npages((paddr & ~PAGE_MASK) + size);
+	npages = iommu_num_pages(paddr, size, PAGE_SIZE);
 
 	/* Force allocation to 64KB boundary for ISA bridges. */
 	if (pdev && pdev == isa_bridge)
@@ -387,7 +380,7 @@ pci_unmap_single(struct pci_dev *pdev, d
 		BUG();
 	}
 
-	npages = calc_npages((dma_addr & ~PAGE_MASK) + size);
+	npages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 
 	spin_lock_irqsave(&arena->lock, flags);
 
@@ -580,7 +573,7 @@ sg_fill(struct device *dev, struct scatt
 	   contiguous.  */
 
 	paddr &= ~PAGE_MASK;
-	npages = calc_npages(paddr + size);
+	npages = iommu_num_pages(paddr, size, PAGE_SIZE);
 	dma_ofs = iommu_arena_alloc(dev, arena, npages, 0);
 	if (dma_ofs < 0) {
 		/* If we attempted a direct map above but failed, die.  */
@@ -616,7 +609,7 @@ sg_fill(struct device *dev, struct scatt
 			sg++;
 		}
 
-		npages = calc_npages((paddr & ~PAGE_MASK) + size);
+		npages = iommu_num_pages(paddr, size, PAGE_SIZE);
 
 		paddr &= PAGE_MASK;
 		for (i = 0; i < npages; ++i, paddr += PAGE_SIZE)
@@ -775,7 +768,7 @@ pci_unmap_sg(struct pci_dev *pdev, struc
 		DBGA("    (%ld) sg [%lx,%lx]\n",
 		     sg - end + nents, addr, size);
 
-		npages = calc_npages((addr & ~PAGE_MASK) + size);
+		npages = iommu_num_pages(addr, size, PAGE_SIZE);
 		ofs = (addr - arena->dma_base) >> PAGE_SHIFT;
 		iommu_arena_free(arena, ofs, npages);
 
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

origin.patch

