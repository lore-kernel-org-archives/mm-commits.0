From: akpm@linux-foundation.org
Subject: + sparc64-use-iommu_num_pages-function-in-iommu-code.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:22:19 -0700
Message-ID: <200808042122.m74LMJ0E031546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757530AbYHDVbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:31:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com


The patch titled
     sparc64: use iommu_num_pages function in IOMMU code
has been added to the -mm tree.  Its filename is
     sparc64-use-iommu_num_pages-function-in-iommu-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc64: use iommu_num_pages function in IOMMU code
From: Joerg Roedel <joerg.roedel@amd.com>

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/iommu.c        |    7 ++++---
 arch/sparc64/kernel/iommu_common.h |   14 ++------------
 arch/sparc64/kernel/pci_sun4v.c    |    7 ++++---
 3 files changed, 10 insertions(+), 18 deletions(-)

diff -puN arch/sparc64/kernel/iommu.c~sparc64-use-iommu_num_pages-function-in-iommu-code arch/sparc64/kernel/iommu.c
--- a/arch/sparc64/kernel/iommu.c~sparc64-use-iommu_num_pages-function-in-iommu-code
+++ a/arch/sparc64/kernel/iommu.c
@@ -575,7 +575,7 @@ static int dma_4u_map_sg(struct device *
 		}
 		/* Allocate iommu entries for that segment */
 		paddr = (unsigned long) SG_ENT_PHYS_ADDRESS(s);
-		npages = iommu_nr_pages(paddr, slen);
+		npages = iommu_num_pages(paddr, slen, IO_PAGE_SIZE);
 		entry = iommu_range_alloc(dev, iommu, npages, &handle);
 
 		/* Handle failure */
@@ -647,7 +647,8 @@ iommu_map_failed:
 			iopte_t *base;
 
 			vaddr = s->dma_address & IO_PAGE_MASK;
-			npages = iommu_nr_pages(s->dma_address, s->dma_length);
+			npages = iommu_num_pages(s->dma_address, s->dma_length,
+						 IO_PAGE_SIZE);
 			iommu_range_free(iommu, vaddr, npages);
 
 			entry = (vaddr - iommu->page_table_map_base)
@@ -715,7 +716,7 @@ static void dma_4u_unmap_sg(struct devic
 
 		if (!len)
 			break;
-		npages = iommu_nr_pages(dma_handle, len);
+		npages = iommu_num_pages(dma_handle, len, IO_PAGE_SIZE);
 		iommu_range_free(iommu, dma_handle, npages);
 
 		entry = ((dma_handle - iommu->page_table_map_base)
diff -puN arch/sparc64/kernel/iommu_common.h~sparc64-use-iommu_num_pages-function-in-iommu-code arch/sparc64/kernel/iommu_common.h
--- a/arch/sparc64/kernel/iommu_common.h~sparc64-use-iommu_num_pages-function-in-iommu-code
+++ a/arch/sparc64/kernel/iommu_common.h
@@ -35,17 +35,6 @@
 
 #define SG_ENT_PHYS_ADDRESS(SG)	(__pa(sg_virt((SG))))
 
-static inline unsigned long iommu_nr_pages(unsigned long vaddr,
-					    unsigned long slen)
-{
-	unsigned long npages;
-
-	npages = IO_PAGE_ALIGN(vaddr + slen) - (vaddr & IO_PAGE_MASK);
-	npages >>= IO_PAGE_SHIFT;
-
-	return npages;
-}
-
 static inline int is_span_boundary(unsigned long entry,
 				   unsigned long shift,
 				   unsigned long boundary_size,
@@ -53,7 +42,8 @@ static inline int is_span_boundary(unsig
 				   struct scatterlist *sg)
 {
 	unsigned long paddr = SG_ENT_PHYS_ADDRESS(outs);
-	int nr = iommu_nr_pages(paddr, outs->dma_length + sg->length);
+	int nr = iommu_num_pages(paddr, outs->dma_length + sg->length,
+				 IO_PAGE_SIZE);
 
 	return iommu_is_span_boundary(entry, nr, shift, boundary_size);
 }
diff -puN arch/sparc64/kernel/pci_sun4v.c~sparc64-use-iommu_num_pages-function-in-iommu-code arch/sparc64/kernel/pci_sun4v.c
--- a/arch/sparc64/kernel/pci_sun4v.c~sparc64-use-iommu_num_pages-function-in-iommu-code
+++ a/arch/sparc64/kernel/pci_sun4v.c
@@ -382,7 +382,7 @@ static int dma_4v_map_sg(struct device *
 		}
 		/* Allocate iommu entries for that segment */
 		paddr = (unsigned long) SG_ENT_PHYS_ADDRESS(s);
-		npages = iommu_nr_pages(paddr, slen);
+		npages = iommu_num_pages(paddr, slen, IO_PAGE_SIZE);
 		entry = iommu_range_alloc(dev, iommu, npages, &handle);
 
 		/* Handle failure */
@@ -459,7 +459,8 @@ iommu_map_failed:
 			unsigned long vaddr, npages;
 
 			vaddr = s->dma_address & IO_PAGE_MASK;
-			npages = iommu_nr_pages(s->dma_address, s->dma_length);
+			npages = iommu_num_pages(s->dma_address, s->dma_length,
+						 IO_PAGE_SIZE);
 			iommu_range_free(iommu, vaddr, npages);
 			/* XXX demap? XXX */
 			s->dma_address = DMA_ERROR_CODE;
@@ -498,7 +499,7 @@ static void dma_4v_unmap_sg(struct devic
 
 		if (!len)
 			break;
-		npages = iommu_nr_pages(dma_handle, len);
+		npages = iommu_num_pages(dma_handle, len, IO_PAGE_SIZE);
 		iommu_range_free(iommu, dma_handle, npages);
 
 		entry = ((dma_handle - iommu->page_table_map_base) >> IO_PAGE_SHIFT);
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

origin.patch
linux-next.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
powerpc-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
x86-convert-gart-driver-to-generic-iommu_num_pages-function.patch
x86-amd-iommu-convert-driver-to-generic-iommu_num_pages-function.patch
x86-convert-calgary-iommu-driver-to-generic-iommu_num_pages-function.patch
powerpc-use-iommu_num_pages-function-in-iommu-code.patch
alpha-use-iommu_num_pages-function-in-iommu-code.patch
sparc64-use-iommu_num_pages-function-in-iommu-code.patch

