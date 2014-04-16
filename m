From: akpm@linux-foundation.org
Subject: + x86-enable-dma-cma-with-swiotlb.patch added to -mm tree
Date: Wed, 16 Apr 2014 12:44:46 -0700
Message-ID: <534eddae.QcVi02eehunF3jfX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaDPTor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 15:44:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de, mingo@redhat.com, m.szyprowski@samsung.com, konrad.wilk@oracle.com, hpa@zytor.com, dwmw2@infradead.org, ddutile@redhat.com, andi@firstfloor.org, akinobu.mita@gmail.com

Subject: + x86-enable-dma-cma-with-swiotlb.patch added to -mm tree
To: akinobu.mita@gmail.com,andi@firstfloor.org,ddutile@redhat.com,dwmw2@infradead.org,hpa@zytor.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mingo@redhat.com,tglx@linutronix.de,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 12:44:46 -0700


The patch titled
     Subject: x86: enable DMA CMA with swiotlb
has been added to the -mm tree.  Its filename is
     x86-enable-dma-cma-with-swiotlb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-enable-dma-cma-with-swiotlb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-enable-dma-cma-with-swiotlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: x86: enable DMA CMA with swiotlb

The DMA Contiguous Memory Allocator support on x86 is disabled when
swiotlb config option is enabled.  So DMA CMA is always disabled on x86_64
because swiotlb is always enabled.  This attempts to support for DMA CMA
with enabling swiotlb config option.

The contiguous memory allocator on x86 is integrated in the function
dma_generic_alloc_coherent() which is .alloc callback in nommu_dma_ops for
dma_alloc_coherent().

x86_swiotlb_alloc_coherent() which is .alloc callback in swiotlb_dma_ops
tries to allocate with dma_generic_alloc_coherent() firstly and then
swiotlb_alloc_coherent() is called as a fallback.

The main part of supporting DMA CMA with swiotlb is that changing
x86_swiotlb_free_coherent() which is .free callback in swiotlb_dma_ops for
dma_free_coherent() so that it can distinguish memory allocated by
dma_generic_alloc_coherent() from one allocated by
swiotlb_alloc_coherent() and release it with dma_generic_free_coherent()
which can handle contiguous memory.  This change requires making
is_swiotlb_buffer() global function.

This also needs to change .free callback in the dma_map_ops for amd_gart
and sta2x11, because these dma_ops are also using
dma_generic_alloc_coherent().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig               |    2 +-
 arch/x86/include/asm/swiotlb.h |    7 +++++++
 arch/x86/kernel/amd_gart_64.c  |    2 +-
 arch/x86/kernel/pci-swiotlb.c  |    9 ++++++---
 arch/x86/pci/sta2x11-fixup.c   |    6 ++----
 include/linux/swiotlb.h        |    2 ++
 lib/swiotlb.c                  |    2 +-
 7 files changed, 20 insertions(+), 10 deletions(-)

diff -puN arch/x86/Kconfig~x86-enable-dma-cma-with-swiotlb arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-enable-dma-cma-with-swiotlb
+++ a/arch/x86/Kconfig
@@ -41,7 +41,7 @@ config X86
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_DMA_ATTRS
-	select HAVE_DMA_CONTIGUOUS if !SWIOTLB
+	select HAVE_DMA_CONTIGUOUS
 	select HAVE_KRETPROBES
 	select GENERIC_EARLY_IOREMAP
 	select HAVE_OPTPROBES
diff -puN arch/x86/include/asm/swiotlb.h~x86-enable-dma-cma-with-swiotlb arch/x86/include/asm/swiotlb.h
--- a/arch/x86/include/asm/swiotlb.h~x86-enable-dma-cma-with-swiotlb
+++ a/arch/x86/include/asm/swiotlb.h
@@ -29,4 +29,11 @@ static inline void pci_swiotlb_late_init
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
 
+extern void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
+					dma_addr_t *dma_handle, gfp_t flags,
+					struct dma_attrs *attrs);
+extern void x86_swiotlb_free_coherent(struct device *dev, size_t size,
+					void *vaddr, dma_addr_t dma_addr,
+					struct dma_attrs *attrs);
+
 #endif /* _ASM_X86_SWIOTLB_H */
diff -puN arch/x86/kernel/amd_gart_64.c~x86-enable-dma-cma-with-swiotlb arch/x86/kernel/amd_gart_64.c
--- a/arch/x86/kernel/amd_gart_64.c~x86-enable-dma-cma-with-swiotlb
+++ a/arch/x86/kernel/amd_gart_64.c
@@ -512,7 +512,7 @@ gart_free_coherent(struct device *dev, s
 		   dma_addr_t dma_addr, struct dma_attrs *attrs)
 {
 	gart_unmap_page(dev, dma_addr, size, DMA_BIDIRECTIONAL, NULL);
-	free_pages((unsigned long)vaddr, get_order(size));
+	dma_generic_free_coherent(dev, size, vaddr, dma_addr, attrs);
 }
 
 static int gart_mapping_error(struct device *dev, dma_addr_t dma_addr)
diff -puN arch/x86/kernel/pci-swiotlb.c~x86-enable-dma-cma-with-swiotlb arch/x86/kernel/pci-swiotlb.c
--- a/arch/x86/kernel/pci-swiotlb.c~x86-enable-dma-cma-with-swiotlb
+++ a/arch/x86/kernel/pci-swiotlb.c
@@ -14,7 +14,7 @@
 #include <asm/iommu_table.h>
 int swiotlb __read_mostly;
 
-static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
+void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags,
 					struct dma_attrs *attrs)
 {
@@ -28,11 +28,14 @@ static void *x86_swiotlb_alloc_coherent(
 	return swiotlb_alloc_coherent(hwdev, size, dma_handle, flags);
 }
 
-static void x86_swiotlb_free_coherent(struct device *dev, size_t size,
+void x86_swiotlb_free_coherent(struct device *dev, size_t size,
 				      void *vaddr, dma_addr_t dma_addr,
 				      struct dma_attrs *attrs)
 {
-	swiotlb_free_coherent(dev, size, vaddr, dma_addr);
+	if (is_swiotlb_buffer(dma_to_phys(dev, dma_addr)))
+		swiotlb_free_coherent(dev, size, vaddr, dma_addr);
+	else
+		dma_generic_free_coherent(dev, size, vaddr, dma_addr, attrs);
 }
 
 static struct dma_map_ops swiotlb_dma_ops = {
diff -puN arch/x86/pci/sta2x11-fixup.c~x86-enable-dma-cma-with-swiotlb arch/x86/pci/sta2x11-fixup.c
--- a/arch/x86/pci/sta2x11-fixup.c~x86-enable-dma-cma-with-swiotlb
+++ a/arch/x86/pci/sta2x11-fixup.c
@@ -173,9 +173,7 @@ static void *sta2x11_swiotlb_alloc_coher
 {
 	void *vaddr;
 
-	vaddr = dma_generic_alloc_coherent(dev, size, dma_handle, flags, attrs);
-	if (!vaddr)
-		vaddr = swiotlb_alloc_coherent(dev, size, dma_handle, flags);
+	vaddr = x86_swiotlb_alloc_coherent(dev, size, dma_handle, flags, attrs);
 	*dma_handle = p2a(*dma_handle, to_pci_dev(dev));
 	return vaddr;
 }
@@ -183,7 +181,7 @@ static void *sta2x11_swiotlb_alloc_coher
 /* We have our own dma_ops: the same as swiotlb but from alloc (above) */
 static struct dma_map_ops sta2x11_dma_ops = {
 	.alloc = sta2x11_swiotlb_alloc_coherent,
-	.free = swiotlb_free_coherent,
+	.free = x86_swiotlb_free_coherent,
 	.map_page = swiotlb_map_page,
 	.unmap_page = swiotlb_unmap_page,
 	.map_sg = swiotlb_map_sg_attrs,
diff -puN include/linux/swiotlb.h~x86-enable-dma-cma-with-swiotlb include/linux/swiotlb.h
--- a/include/linux/swiotlb.h~x86-enable-dma-cma-with-swiotlb
+++ a/include/linux/swiotlb.h
@@ -116,4 +116,6 @@ static inline void swiotlb_free(void) {
 #endif
 
 extern void swiotlb_print_info(void);
+extern int is_swiotlb_buffer(phys_addr_t paddr);
+
 #endif /* __LINUX_SWIOTLB_H */
diff -puN lib/swiotlb.c~x86-enable-dma-cma-with-swiotlb lib/swiotlb.c
--- a/lib/swiotlb.c~x86-enable-dma-cma-with-swiotlb
+++ a/lib/swiotlb.c
@@ -374,7 +374,7 @@ void __init swiotlb_free(void)
 	io_tlb_nslabs = 0;
 }
 
-static int is_swiotlb_buffer(phys_addr_t paddr)
+int is_swiotlb_buffer(phys_addr_t paddr)
 {
 	return paddr >= io_tlb_start && paddr < io_tlb_end;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch
x86-enable-dma-cma-with-swiotlb.patch
intel-iommu-integrate-dma-cma.patch
memblock-introduce-memblock_alloc_range.patch
cma-add-placement-specifier-for-cma=-kernel-parameter.patch

