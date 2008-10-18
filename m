From: akpm@linux-foundation.org
Subject: - x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:43 -0700
Message-ID: <200810182312.m9INCh1p028040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbYJRXNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, airlied@linux.ie, benh@kernel.crashing.org, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, mingo@elte.hu, muli@il.ibm.com, paulus@


The patch titled
     x86: rename iommu_num_pages function to iommu_nr_pages
has been removed from the -mm tree.  Its filename was
     x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: rename iommu_num_pages function to iommu_nr_pages

ffffffffffffffFrom: Joerg Roedel <joerg.roedel@amd.com>

This series of patches re-introduces the iommu_num_pages function so that
it can be used by each architecture specific IOMMU implementations.  The
series also changes IOMMU implementations for X86, Alpha, PowerPC and
UltraSparc.  The other implementations are not yet changed because the
modifications required are not obvious and I can't test them on real
hardware.


This patch:

This is a preparation patch for introducing a generic iommu_num_pages function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/amd_iommu.c   |    8 ++++----
 arch/x86/kernel/pci-dma.c     |    4 ++--
 arch/x86/kernel/pci-gart_64.c |    8 ++++----
 include/asm-x86/iommu.h       |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/x86/kernel/amd_iommu.c~x86-rename-iommu_num_pages-function-to-iommu_nr_pages arch/x86/kernel/amd_iommu.c
--- a/arch/x86/kernel/amd_iommu.c~x86-rename-iommu_num_pages-function-to-iommu_nr_pages
+++ a/arch/x86/kernel/amd_iommu.c
@@ -295,7 +295,7 @@ static int iommu_flush_pages(struct amd_
 		u64 address, size_t size)
 {
 	int s = 0;
-	unsigned pages = iommu_num_pages(address, size);
+	unsigned pages = iommu_nr_pages(address, size);
 
 	address &= PAGE_MASK;
 
@@ -679,7 +679,7 @@ static struct dma_ops_domain *dma_ops_do
 	if (iommu->exclusion_start &&
 	    iommu->exclusion_start < dma_dom->aperture_size) {
 		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
-		int pages = iommu_num_pages(iommu->exclusion_start,
+		int pages = iommu_nr_pages(iommu->exclusion_start,
 					    iommu->exclusion_length);
 		dma_ops_reserve_addresses(dma_dom, startpage, pages);
 	}
@@ -935,7 +935,7 @@ static dma_addr_t __map_single(struct de
 	unsigned long align_mask = 0;
 	int i;
 
-	pages = iommu_num_pages(paddr, size);
+	pages = iommu_nr_pages(paddr, size);
 	paddr &= PAGE_MASK;
 
 	if (align)
@@ -980,7 +980,7 @@ static void __unmap_single(struct amd_io
 	if ((dma_addr == 0) || (dma_addr + size > dma_dom->aperture_size))
 		return;
 
-	pages = iommu_num_pages(dma_addr, size);
+	pages = iommu_nr_pages(dma_addr, size);
 	dma_addr &= PAGE_MASK;
 	start = dma_addr;
 
diff -puN arch/x86/kernel/pci-dma.c~x86-rename-iommu_num_pages-function-to-iommu_nr_pages arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~x86-rename-iommu_num_pages-function-to-iommu_nr_pages
+++ a/arch/x86/kernel/pci-dma.c
@@ -125,13 +125,13 @@ void __init pci_iommu_alloc(void)
 	pci_swiotlb_init();
 }
 
-unsigned long iommu_num_pages(unsigned long addr, unsigned long len)
+unsigned long iommu_nr_pages(unsigned long addr, unsigned long len)
 {
 	unsigned long size = roundup((addr & ~PAGE_MASK) + len, PAGE_SIZE);
 
 	return size >> PAGE_SHIFT;
 }
-EXPORT_SYMBOL(iommu_num_pages);
+EXPORT_SYMBOL(iommu_nr_pages);
 #endif
 
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
diff -puN arch/x86/kernel/pci-gart_64.c~x86-rename-iommu_num_pages-function-to-iommu_nr_pages arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c~x86-rename-iommu_num_pages-function-to-iommu_nr_pages
+++ a/arch/x86/kernel/pci-gart_64.c
@@ -231,7 +231,7 @@ nonforced_iommu(struct device *dev, unsi
 static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 				size_t size, int dir, unsigned long align_mask)
 {
-	unsigned long npages = iommu_num_pages(phys_mem, size);
+	unsigned long npages = iommu_nr_pages(phys_mem, size);
 	unsigned long iommu_page = alloc_iommu(dev, npages, align_mask);
 	int i;
 
@@ -285,7 +285,7 @@ static void gart_unmap_single(struct dev
 		return;
 
 	iommu_page = (dma_addr - iommu_bus_base)>>PAGE_SHIFT;
-	npages = iommu_num_pages(dma_addr, size);
+	npages = iommu_nr_pages(dma_addr, size);
 	for (i = 0; i < npages; i++) {
 		iommu_gatt_base[iommu_page + i] = gart_unmapped_entry;
 		CLEAR_LEAK(iommu_page + i);
@@ -368,7 +368,7 @@ static int __dma_map_cont(struct device 
 		}
 
 		addr = phys_addr;
-		pages = iommu_num_pages(s->offset, s->length);
+		pages = iommu_nr_pages(s->offset, s->length);
 		while (pages--) {
 			iommu_gatt_base[iommu_page] = GPTE_ENCODE(addr);
 			SET_LEAK(iommu_page);
@@ -451,7 +451,7 @@ gart_map_sg(struct device *dev, struct s
 
 		seg_size += s->length;
 		need = nextneed;
-		pages += iommu_num_pages(s->offset, s->length);
+		pages += iommu_nr_pages(s->offset, s->length);
 		ps = s;
 	}
 	if (dma_map_cont(dev, start_sg, i - start, sgmap, pages, need) < 0)
diff -puN include/asm-x86/iommu.h~x86-rename-iommu_num_pages-function-to-iommu_nr_pages include/asm-x86/iommu.h
--- a/include/asm-x86/iommu.h~x86-rename-iommu_num_pages-function-to-iommu_nr_pages
+++ a/include/asm-x86/iommu.h
@@ -8,7 +8,7 @@ extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int dmar_disabled;
 
-extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
+extern unsigned long iommu_nr_pages(unsigned long addr, unsigned long len);
 
 #ifdef CONFIG_GART_IOMMU
 extern int gart_iommu_aperture;
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

origin.patch

