From: akpm@linux-foundation.org
Subject: + x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:21:58 -0700
Message-ID: <200808042121.m74LLwPS031510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758175AbYHDVXS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:23:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, airlied@linux.ie, benh@kernel.crashing.org, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, mingo@elte.hu, muli@il.ibm.com, paulus@samba.org, rth@twiddle.net, tglx@linutronix.de


The patch titled
     x86: rename iommu_num_pages function to iommu_nr_pages
has been added to the -mm tree.  Its filename is
     x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch

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
Subject: x86: rename iommu_num_pages function to iommu_nr_pages
From: Joerg Roedel <joerg.roedel@amd.com>

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
@@ -182,7 +182,7 @@ static int iommu_flush_pages(struct amd_
 		u64 address, size_t size)
 {
 	int s = 0;
-	unsigned pages = iommu_num_pages(address, size);
+	unsigned pages = iommu_nr_pages(address, size);
 
 	address &= PAGE_MASK;
 
@@ -554,7 +554,7 @@ static struct dma_ops_domain *dma_ops_do
 	if (iommu->exclusion_start &&
 	    iommu->exclusion_start < dma_dom->aperture_size) {
 		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
-		int pages = iommu_num_pages(iommu->exclusion_start,
+		int pages = iommu_nr_pages(iommu->exclusion_start,
 					    iommu->exclusion_length);
 		dma_ops_reserve_addresses(dma_dom, startpage, pages);
 	}
@@ -764,7 +764,7 @@ static dma_addr_t __map_single(struct de
 	unsigned int pages;
 	int i;
 
-	pages = iommu_num_pages(paddr, size);
+	pages = iommu_nr_pages(paddr, size);
 	paddr &= PAGE_MASK;
 
 	address = dma_ops_alloc_addresses(dev, dma_dom, pages);
@@ -799,7 +799,7 @@ static void __unmap_single(struct amd_io
 	if ((dma_addr == 0) || (dma_addr + size > dma_dom->aperture_size))
 		return;
 
-	pages = iommu_num_pages(dma_addr, size);
+	pages = iommu_nr_pages(dma_addr, size);
 	dma_addr &= PAGE_MASK;
 	start = dma_addr;
 
diff -puN arch/x86/kernel/pci-dma.c~x86-rename-iommu_num_pages-function-to-iommu_nr_pages arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~x86-rename-iommu_num_pages-function-to-iommu_nr_pages
+++ a/arch/x86/kernel/pci-dma.c
@@ -124,13 +124,13 @@ void __init pci_iommu_alloc(void)
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
 
 /*
diff -puN arch/x86/kernel/pci-gart_64.c~x86-rename-iommu_num_pages-function-to-iommu_nr_pages arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c~x86-rename-iommu_num_pages-function-to-iommu_nr_pages
+++ a/arch/x86/kernel/pci-gart_64.c
@@ -240,7 +240,7 @@ nonforced_iommu(struct device *dev, unsi
 static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 			       size_t size, int dir, u64 align_mask)
 {
-	unsigned long npages = iommu_num_pages(phys_mem, size);
+	unsigned long npages = iommu_nr_pages(phys_mem, size);
  	unsigned long palign_mask = align_mask >> PAGE_SHIFT;
  	unsigned long iommu_page = alloc_iommu(dev, npages, palign_mask);
 	int i;
@@ -305,7 +305,7 @@ static void gart_unmap_single(struct dev
 		return;
 
 	iommu_page = (dma_addr - iommu_bus_base)>>PAGE_SHIFT;
-	npages = iommu_num_pages(dma_addr, size);
+	npages = iommu_nr_pages(dma_addr, size);
 	for (i = 0; i < npages; i++) {
 		iommu_gatt_base[iommu_page + i] = gart_unmapped_entry;
 		CLEAR_LEAK(iommu_page + i);
@@ -388,7 +388,7 @@ static int __dma_map_cont(struct device 
 		}
 
 		addr = phys_addr;
-		pages = iommu_num_pages(s->offset, s->length);
+		pages = iommu_nr_pages(s->offset, s->length);
 		while (pages--) {
 			iommu_gatt_base[iommu_page] = GPTE_ENCODE(addr);
 			SET_LEAK(iommu_page);
@@ -471,7 +471,7 @@ gart_map_sg(struct device *dev, struct s
 
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
@@ -7,7 +7,7 @@ extern struct dma_mapping_ops nommu_dma_
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 
-extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
+extern unsigned long iommu_nr_pages(unsigned long addr, unsigned long len);
 
 #ifdef CONFIG_GART_IOMMU
 extern int gart_iommu_aperture;
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

