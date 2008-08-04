From: akpm@linux-foundation.org
Subject: + x86-convert-calgary-iommu-driver-to-generic-iommu_num_pages-function.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:22:12 -0700
Message-ID: <200808042122.m74LMCDE031535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764688AbYHDVd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:33:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de


The patch titled
     x86: convert Calgary IOMMU driver to generic iommu_num_pages function
has been added to the -mm tree.  Its filename is
     x86-convert-calgary-iommu-driver-to-generic-iommu_num_pages-function.patch

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
Subject: x86: convert Calgary IOMMU driver to generic iommu_num_pages function
From: Joerg Roedel <joerg.roedel@amd.com>

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-calgary_64.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN arch/x86/kernel/pci-calgary_64.c~x86-convert-calgary-iommu-driver-to-generic-iommu_num_pages-function arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~x86-convert-calgary-iommu-driver-to-generic-iommu_num_pages-function
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
+		npages = iommu_num_pages(dma, dmalen, PAGE_SIZE);
 		iommu_free(tbl, dma, npages);
 	}
 }
@@ -427,7 +417,7 @@ static int calgary_map_sg(struct device 
 		BUG_ON(!sg_page(s));
 
 		vaddr = (unsigned long) sg_virt(s);
-		npages = num_dma_pages(vaddr, s->length);
+		npages = iommu_num_pages(vaddr, s->length, PAGE_SIZE);
 
 		entry = iommu_range_alloc(dev, tbl, npages);
 		if (entry == bad_dma_address) {
@@ -464,7 +454,7 @@ static dma_addr_t calgary_map_single(str
 	struct iommu_table *tbl = find_iommu_table(dev);
 
 	uaddr = (unsigned long)vaddr;
-	npages = num_dma_pages(uaddr, size);
+	npages = iommu_num_pages(uaddr, size, PAGE_SIZE);
 
 	return iommu_alloc(dev, tbl, vaddr, npages, direction);
 }
@@ -475,7 +465,7 @@ static void calgary_unmap_single(struct 
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
-	npages = num_dma_pages(dma_handle, size);
+	npages = iommu_num_pages(dma_handle, size, PAGE_SIZE);
 	iommu_free(tbl, dma_handle, npages);
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

