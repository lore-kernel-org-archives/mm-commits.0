From: akpm@linux-foundation.org
Subject: - x86-convert-gart-driver-to-generic-iommu_num_pages-function.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:54 -0700
Message-ID: <200810182312.m9INCsOq028077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbYJRXNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, airlied@linux.ie, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: convert GART driver to generic iommu_num_pages function
has been removed from the -mm tree.  Its filename was
     x86-convert-gart-driver-to-generic-iommu_num_pages-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -231,7 +231,7 @@ nonforced_iommu(struct device *dev, unsi
 static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 				size_t size, int dir, unsigned long align_mask)
 {
-	unsigned long npages = iommu_nr_pages(phys_mem, size);
+	unsigned long npages = iommu_num_pages(phys_mem, size, PAGE_SIZE);
 	unsigned long iommu_page = alloc_iommu(dev, npages, align_mask);
 	int i;
 
@@ -285,7 +285,7 @@ static void gart_unmap_single(struct dev
 		return;
 
 	iommu_page = (dma_addr - iommu_bus_base)>>PAGE_SHIFT;
-	npages = iommu_nr_pages(dma_addr, size);
+	npages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 	for (i = 0; i < npages; i++) {
 		iommu_gatt_base[iommu_page + i] = gart_unmapped_entry;
 		CLEAR_LEAK(iommu_page + i);
@@ -368,7 +368,7 @@ static int __dma_map_cont(struct device 
 		}
 
 		addr = phys_addr;
-		pages = iommu_nr_pages(s->offset, s->length);
+		pages = iommu_num_pages(s->offset, s->length, PAGE_SIZE);
 		while (pages--) {
 			iommu_gatt_base[iommu_page] = GPTE_ENCODE(addr);
 			SET_LEAK(iommu_page);
@@ -451,7 +451,7 @@ gart_map_sg(struct device *dev, struct s
 
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

