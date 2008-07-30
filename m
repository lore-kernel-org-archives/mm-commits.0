From: akpm@linux-foundation.org
Subject: + x86-calgary-replace-num_dma_pages-with-iommu_num_pages.patch added to -mm tree
Date: Wed, 30 Jul 2008 01:20:13 -0700
Message-ID: <200807300820.m6U8KDVN015899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688AbYG3IVO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 04:21:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, muli@il.ibm.com


The patch titled
     x86 calgary: replace num_dma_pages() with iommu_num_pages()
has been added to the -mm tree.  Its filename is
     x86-calgary-replace-num_dma_pages-with-iommu_num_pages.patch

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

introduce-lower_32_bits-macro.patch
linux-next.patch
x86-calgary-replace-num_dma_pages-with-iommu_num_pages.patch

