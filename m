From: akpm@linux-foundation.org
Subject: + powerpc-use-iommu_num_pages-function-in-iommu-code.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:22:14 -0700
Message-ID: <200808042122.m74LMEFL031540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763706AbYHDVeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com, paulus@samba.org


The patch titled
     powerpc: use iommu_num_pages function in IOMMU code
has been added to the -mm tree.  Its filename is
     powerpc-use-iommu_num_pages-function-in-iommu-code.patch

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
Subject: powerpc: use iommu_num_pages function in IOMMU code
From: Joerg Roedel <joerg.roedel@amd.com>

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/iommu.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff -puN arch/powerpc/kernel/iommu.c~powerpc-use-iommu_num_pages-function-in-iommu-code arch/powerpc/kernel/iommu.c
--- a/arch/powerpc/kernel/iommu.c~powerpc-use-iommu_num_pages-function-in-iommu-code
+++ a/arch/powerpc/kernel/iommu.c
@@ -51,17 +51,6 @@ static int protect4gb = 1;
 
 static void __iommu_free(struct iommu_table *, dma_addr_t, unsigned int);
 
-static inline unsigned long iommu_nr_pages(unsigned long vaddr,
-					    unsigned long slen)
-{
-	unsigned long npages;
-
-	npages = IOMMU_PAGE_ALIGN(vaddr + slen) - (vaddr & IOMMU_PAGE_MASK);
-	npages >>= IOMMU_PAGE_SHIFT;
-
-	return npages;
-}
-
 static int __init setup_protect4gb(char *str)
 {
 	if (strcmp(str, "on") == 0)
@@ -325,7 +314,7 @@ int iommu_map_sg(struct device *dev, str
 		}
 		/* Allocate iommu entries for that segment */
 		vaddr = (unsigned long) sg_virt(s);
-		npages = iommu_nr_pages(vaddr, slen);
+		npages = iommu_num_pages(vaddr, slen, IOMMU_PAGE_SIZE);
 		align = 0;
 		if (IOMMU_PAGE_SHIFT < PAGE_SHIFT && slen >= PAGE_SIZE &&
 		    (vaddr & ~PAGE_MASK) == 0)
@@ -418,7 +407,8 @@ int iommu_map_sg(struct device *dev, str
 			unsigned long vaddr, npages;
 
 			vaddr = s->dma_address & IOMMU_PAGE_MASK;
-			npages = iommu_nr_pages(s->dma_address, s->dma_length);
+			npages = iommu_num_pages(s->dma_address, s->dma_length,
+						 IOMMU_PAGE_SIZE);
 			__iommu_free(tbl, vaddr, npages);
 			s->dma_address = DMA_ERROR_CODE;
 			s->dma_length = 0;
@@ -452,7 +442,8 @@ void iommu_unmap_sg(struct iommu_table *
 
 		if (sg->dma_length == 0)
 			break;
-		npages = iommu_nr_pages(dma_handle, sg->dma_length);
+		npages = iommu_num_pages(dma_handle, sg->dma_length,
+					 IOMMU_PAGE_SIZE);
 		__iommu_free(tbl, dma_handle, npages);
 		sg = sg_next(sg);
 	}
@@ -584,7 +575,7 @@ dma_addr_t iommu_map_single(struct devic
 	BUG_ON(direction == DMA_NONE);
 
 	uaddr = (unsigned long)vaddr;
-	npages = iommu_nr_pages(uaddr, size);
+	npages = iommu_num_pages(uaddr, size, IOMMU_PAGE_SIZE);
 
 	if (tbl) {
 		align = 0;
@@ -617,7 +608,7 @@ void iommu_unmap_single(struct iommu_tab
 	BUG_ON(direction == DMA_NONE);
 
 	if (tbl) {
-		npages = iommu_nr_pages(dma_handle, size);
+		npages = iommu_num_pages(dma_handle, size, IOMMU_PAGE_SIZE);
 		iommu_free(tbl, dma_handle, npages);
 	}
 }
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

