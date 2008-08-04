From: akpm@linux-foundation.org
Subject: + x86-convert-gart-driver-to-generic-iommu_num_pages-function.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:22:08 -0700
Message-ID: <200808042122.m74LM8AS031528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757535AbYHDVXL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:23:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, airlied@linux.ie, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de


The patch titled
     x86: convert GART driver to generic iommu_num_pages function
has been added to the -mm tree.  Its filename is
     x86-convert-gart-driver-to-generic-iommu_num_pages-function.patch

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
Subject: x86: convert GART driver to generic iommu_num_pages function
From: Joerg Roedel <joerg.roedel@amd.com>

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-gart_64.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/pci-gart_64.c~x86-convert-gart-driver-to-generic-iommu_num_pages-function arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c~x86-convert-gart-driver-to-generic-iommu_num_pages-function
+++ a/arch/x86/kernel/pci-gart_64.c
@@ -240,7 +240,7 @@ nonforced_iommu(struct device *dev, unsi
 static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 			       size_t size, int dir, u64 align_mask)
 {
-	unsigned long npages = iommu_nr_pages(phys_mem, size);
+	unsigned long npages = iommu_num_pages(phys_mem, size, PAGE_SIZE);
  	unsigned long palign_mask = align_mask >> PAGE_SHIFT;
  	unsigned long iommu_page = alloc_iommu(dev, npages, palign_mask);
 	int i;
@@ -305,7 +305,7 @@ static void gart_unmap_single(struct dev
 		return;
 
 	iommu_page = (dma_addr - iommu_bus_base)>>PAGE_SHIFT;
-	npages = iommu_nr_pages(dma_addr, size);
+	npages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 	for (i = 0; i < npages; i++) {
 		iommu_gatt_base[iommu_page + i] = gart_unmapped_entry;
 		CLEAR_LEAK(iommu_page + i);
@@ -388,7 +388,7 @@ static int __dma_map_cont(struct device 
 		}
 
 		addr = phys_addr;
-		pages = iommu_nr_pages(s->offset, s->length);
+		pages = iommu_num_pages(s->offset, s->length, PAGE_SIZE);
 		while (pages--) {
 			iommu_gatt_base[iommu_page] = GPTE_ENCODE(addr);
 			SET_LEAK(iommu_page);
@@ -471,7 +471,7 @@ gart_map_sg(struct device *dev, struct s
 
 		seg_size += s->length;
 		need = nextneed;
-		pages += iommu_nr_pages(s->offset, s->length);
+		pages += iommu_num_pages(s->offset, s->length, PAGE_SIZE);
 		ps = s;
 	}
 	if (dma_map_cont(dev, start_sg, i - start, sgmap, pages, need) < 0)
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

