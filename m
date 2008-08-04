From: akpm@linux-foundation.org
Subject: + sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:22:02 -0700
Message-ID: <200808042122.m74LM2rD031519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757498AbYHDVWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:22:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com


The patch titled
     sparc64: rename iommu_num_pages function to iommu_nr_pages
has been added to the -mm tree.  Its filename is
     sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages.patch

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
Subject: sparc64: rename iommu_num_pages function to iommu_nr_pages
From: Joerg Roedel <joerg.roedel@amd.com>

This is a preparation patch for introducing a generic iommu_num_pages function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/iommu.c        |    6 +++---
 arch/sparc64/kernel/iommu_common.h |    4 ++--
 arch/sparc64/kernel/pci_sun4v.c    |    6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/sparc64/kernel/iommu.c~sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages arch/sparc64/kernel/iommu.c
--- a/arch/sparc64/kernel/iommu.c~sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages
+++ a/arch/sparc64/kernel/iommu.c
@@ -575,7 +575,7 @@ static int dma_4u_map_sg(struct device *
 		}
 		/* Allocate iommu entries for that segment */
 		paddr = (unsigned long) SG_ENT_PHYS_ADDRESS(s);
-		npages = iommu_num_pages(paddr, slen);
+		npages = iommu_nr_pages(paddr, slen);
 		entry = iommu_range_alloc(dev, iommu, npages, &handle);
 
 		/* Handle failure */
@@ -647,7 +647,7 @@ iommu_map_failed:
 			iopte_t *base;
 
 			vaddr = s->dma_address & IO_PAGE_MASK;
-			npages = iommu_num_pages(s->dma_address, s->dma_length);
+			npages = iommu_nr_pages(s->dma_address, s->dma_length);
 			iommu_range_free(iommu, vaddr, npages);
 
 			entry = (vaddr - iommu->page_table_map_base)
@@ -715,7 +715,7 @@ static void dma_4u_unmap_sg(struct devic
 
 		if (!len)
 			break;
-		npages = iommu_num_pages(dma_handle, len);
+		npages = iommu_nr_pages(dma_handle, len);
 		iommu_range_free(iommu, dma_handle, npages);
 
 		entry = ((dma_handle - iommu->page_table_map_base)
diff -puN arch/sparc64/kernel/iommu_common.h~sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages arch/sparc64/kernel/iommu_common.h
--- a/arch/sparc64/kernel/iommu_common.h~sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages
+++ a/arch/sparc64/kernel/iommu_common.h
@@ -35,7 +35,7 @@
 
 #define SG_ENT_PHYS_ADDRESS(SG)	(__pa(sg_virt((SG))))
 
-static inline unsigned long iommu_num_pages(unsigned long vaddr,
+static inline unsigned long iommu_nr_pages(unsigned long vaddr,
 					    unsigned long slen)
 {
 	unsigned long npages;
@@ -53,7 +53,7 @@ static inline int is_span_boundary(unsig
 				   struct scatterlist *sg)
 {
 	unsigned long paddr = SG_ENT_PHYS_ADDRESS(outs);
-	int nr = iommu_num_pages(paddr, outs->dma_length + sg->length);
+	int nr = iommu_nr_pages(paddr, outs->dma_length + sg->length);
 
 	return iommu_is_span_boundary(entry, nr, shift, boundary_size);
 }
diff -puN arch/sparc64/kernel/pci_sun4v.c~sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages arch/sparc64/kernel/pci_sun4v.c
--- a/arch/sparc64/kernel/pci_sun4v.c~sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages
+++ a/arch/sparc64/kernel/pci_sun4v.c
@@ -382,7 +382,7 @@ static int dma_4v_map_sg(struct device *
 		}
 		/* Allocate iommu entries for that segment */
 		paddr = (unsigned long) SG_ENT_PHYS_ADDRESS(s);
-		npages = iommu_num_pages(paddr, slen);
+		npages = iommu_nr_pages(paddr, slen);
 		entry = iommu_range_alloc(dev, iommu, npages, &handle);
 
 		/* Handle failure */
@@ -459,7 +459,7 @@ iommu_map_failed:
 			unsigned long vaddr, npages;
 
 			vaddr = s->dma_address & IO_PAGE_MASK;
-			npages = iommu_num_pages(s->dma_address, s->dma_length);
+			npages = iommu_nr_pages(s->dma_address, s->dma_length);
 			iommu_range_free(iommu, vaddr, npages);
 			/* XXX demap? XXX */
 			s->dma_address = DMA_ERROR_CODE;
@@ -498,7 +498,7 @@ static void dma_4v_unmap_sg(struct devic
 
 		if (!len)
 			break;
-		npages = iommu_num_pages(dma_handle, len);
+		npages = iommu_nr_pages(dma_handle, len);
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

