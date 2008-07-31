From: akpm@linux-foundation.org
Subject: - x86-calgary-replace-num_dma_pages-with-iommu_num_pages.patch removed from -mm tree
Date: Thu, 31 Jul 2008 02:39:00 -0700
Message-ID: <200807310939.m6V9d1Y1015614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755533AbYGaJkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 05:40:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, muli@il.ibm.com, mm-commits@vger.kernel.org


The patch titled
     x86 calgary: replace num_dma_pages() with iommu_num_pages()
has been removed from the -mm tree.  Its filename was
     x86-calgary-replace-num_dma_pages-with-iommu_num_pages.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 calgary: replace num_dma_pages() with iommu_num_pages()
From: Joerg Roedel <joerg.roedel@amd.com>

Remove the num_dma_pages() function from Calgary IOMMU code and replace
it with the generic iommu_num_pages() function.

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-calgary_64.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN arch/x86/kernel/pci-calgary_64.c~x86-calgary-replace-num_dma_pages-with-iommu_num_pages arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~x86-calgary-replace-num_dma_pages-with-iommu_num_pages
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -217,16 +217,6 @@ static inline unsigned long verify_bit_r
 
 #endif /* CONFIG_IOMMU_DEBUG */
 
-static inline unsigned int num_dma_pages(unsigned long dma, unsigned int dmalen)
-{
-	unsigned int npages;
-
-	npages = PAGE_ALIGN(dma + dmalen) - (dma & PAGE_MASK);
-	npages >>= PAGE_SHIFT;
-
-	return npages;
-}
-
 static inline int translation_enabled(struct iommu_table *tbl)
 {
 	/* only PHBs with translation enabled have an IOMMU table */
@@ -408,7 +398,7 @@ static void calgary_unmap_sg(struct devi
 		if (dmalen == 0)
 			break;
 
-		npages = num_dma_pages(dma, dmalen);
+		npages = iommu_num_pages(dma, dmalen);
 		iommu_free(tbl, dma, npages);
 	}
 }
@@ -427,7 +417,7 @@ static int calgary_map_sg(struct device 
 		BUG_ON(!sg_page(s));
 
 		vaddr = (unsigned long) sg_virt(s);
-		npages = num_dma_pages(vaddr, s->length);
+		npages = iommu_num_pages(vaddr, s->length);
 
 		entry = iommu_range_alloc(dev, tbl, npages);
 		if (entry == bad_dma_address) {
@@ -464,7 +454,7 @@ static dma_addr_t calgary_map_single(str
 	struct iommu_table *tbl = find_iommu_table(dev);
 
 	uaddr = (unsigned long)vaddr;
-	npages = num_dma_pages(uaddr, size);
+	npages = iommu_num_pages(uaddr, size);
 
 	return iommu_alloc(dev, tbl, vaddr, npages, direction);
 }
@@ -475,7 +465,7 @@ static void calgary_unmap_single(struct 
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
-	npages = num_dma_pages(dma_handle, size);
+	npages = iommu_num_pages(dma_handle, size);
 	iommu_free(tbl, dma_handle, npages);
 }
 
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

origin.patch
linux-next.patch
x86-calgary-replace-num_dma_pages-with-iommu_num_pages.patch

