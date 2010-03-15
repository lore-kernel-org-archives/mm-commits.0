From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-alpha-use-include-linux-pci-dma-compath.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:03:37 -0400
Message-ID: <201003150704.o2F74AKa016994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935969Ab0COHET (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:04:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: alpha: use include/linux/pci-dma-compat.h
has been removed from the -mm tree.  Its filename was
     dma-mapping-alpha-use-include-linux-pci-dma-compath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: alpha: use include/linux/pci-dma-compat.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This converts Alpha to use include/linux/pci-dma-compat.h.  Alpha is the
only architecutre that implements the PCI DMA API in the own way.  That
makes it difficult to implement the generic DMA API via the PCI bus
specific DMA API.

The generic DMA API calls the PCI DMA API implementation in
arch/alpha/kernel/pci_iommu.c on non Jensen systems.  It calls the DMA API
in arch/alpha/kernel/pci-noop.c on Jensen systems.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig                   |    1 
 arch/alpha/include/asm/dma-mapping.h |   91 ++++-------
 arch/alpha/include/asm/pci.h         |  125 ---------------
 arch/alpha/kernel/pci-noop.c         |  101 ++++--------
 arch/alpha/kernel/pci_iommu.c        |  201 +++++++++++--------------
 5 files changed, 171 insertions(+), 348 deletions(-)

diff -puN arch/alpha/Kconfig~dma-mapping-alpha-use-include-linux-pci-dma-compath arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~dma-mapping-alpha-use-include-linux-pci-dma-compath
+++ a/arch/alpha/Kconfig
@@ -10,6 +10,7 @@ config ALPHA
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_PERF_EVENTS
+	select HAVE_DMA_ATTRS
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff -puN arch/alpha/include/asm/dma-mapping.h~dma-mapping-alpha-use-include-linux-pci-dma-compath arch/alpha/include/asm/dma-mapping.h
--- a/arch/alpha/include/asm/dma-mapping.h~dma-mapping-alpha-use-include-linux-pci-dma-compath
+++ a/arch/alpha/include/asm/dma-mapping.h
@@ -1,70 +1,49 @@
 #ifndef _ALPHA_DMA_MAPPING_H
 #define _ALPHA_DMA_MAPPING_H
 
+#include <linux/dma-attrs.h>
 
-#ifdef CONFIG_PCI
+extern struct dma_map_ops *dma_ops;
 
-#include <linux/pci.h>
-
-#define dma_map_single(dev, va, size, dir)		\
-		pci_map_single(alpha_gendev_to_pci(dev), va, size, dir)
-#define dma_unmap_single(dev, addr, size, dir)		\
-		pci_unmap_single(alpha_gendev_to_pci(dev), addr, size, dir)
-#define dma_alloc_coherent(dev, size, addr, gfp)	\
-	      __pci_alloc_consistent(alpha_gendev_to_pci(dev), size, addr, gfp)
-#define dma_free_coherent(dev, size, va, addr)		\
-		pci_free_consistent(alpha_gendev_to_pci(dev), size, va, addr)
-#define dma_map_page(dev, page, off, size, dir)		\
-		pci_map_page(alpha_gendev_to_pci(dev), page, off, size, dir)
-#define dma_unmap_page(dev, addr, size, dir)		\
-		pci_unmap_page(alpha_gendev_to_pci(dev), addr, size, dir)
-#define dma_map_sg(dev, sg, nents, dir)			\
-		pci_map_sg(alpha_gendev_to_pci(dev), sg, nents, dir)
-#define dma_unmap_sg(dev, sg, nents, dir)		\
-		pci_unmap_sg(alpha_gendev_to_pci(dev), sg, nents, dir)
-#define dma_supported(dev, mask)			\
-		pci_dma_supported(alpha_gendev_to_pci(dev), mask)
-#define dma_mapping_error(dev, addr)				\
-		pci_dma_mapping_error(alpha_gendev_to_pci(dev), addr)
-
-#else	/* no PCI - no IOMMU. */
-
-#include <asm/io.h>	/* for virt_to_phys() */
-
-struct scatterlist;
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *dma_handle, gfp_t gfp);
-int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	       enum dma_data_direction direction);
-
-#define dma_free_coherent(dev, size, va, addr)		\
-		free_pages((unsigned long)va, get_order(size))
-#define dma_supported(dev, mask)		(mask < 0x00ffffffUL ? 0 : 1)
-#define dma_map_single(dev, va, size, dir)	virt_to_phys(va)
-#define dma_map_page(dev, page, off, size, dir)	(page_to_pa(page) + off)
-
-#define dma_unmap_single(dev, addr, size, dir)	((void)0)
-#define dma_unmap_page(dev, addr, size, dir)	((void)0)
-#define dma_unmap_sg(dev, sg, nents, dir)	((void)0)
-
-#define dma_mapping_error(dev, addr)  (0)
-
-#endif	/* !CONFIG_PCI */
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	return dma_ops;
+}
+
+#include <asm-generic/dma-mapping-common.h>
+
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t gfp)
+{
+	return get_dma_ops(dev)->alloc_coherent(dev, size, dma_handle, gfp);
+}
+
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *vaddr, dma_addr_t dma_handle)
+{
+	get_dma_ops(dev)->free_coherent(dev, size, vaddr, dma_handle);
+}
+
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return get_dma_ops(dev)->mapping_error(dev, dma_addr);
+}
+
+static inline int dma_supported(struct device *dev, u64 mask)
+{
+	return get_dma_ops(dev)->dma_supported(dev, mask);
+}
+
+static inline int dma_set_mask(struct device *dev, u64 mask)
+{
+	return get_dma_ops(dev)->set_dma_mask(dev, mask);
+}
 
 #define dma_alloc_noncoherent(d, s, h, f)	dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h)	dma_free_coherent(d, s, v, h)
 #define dma_is_consistent(d, h)			(1)
 
-int dma_set_mask(struct device *dev, u64 mask);
-
-#define dma_sync_single_for_cpu(dev, addr, size, dir)	  ((void)0)
-#define dma_sync_single_for_device(dev, addr, size, dir)  ((void)0)
-#define dma_sync_sg_for_cpu(dev, sg, nents, dir)	  ((void)0)
-#define dma_sync_sg_for_device(dev, sg, nents, dir)	  ((void)0)
 #define dma_cache_sync(dev, va, size, dir)		  ((void)0)
-#define dma_sync_single_range_for_cpu(dev, addr, offset, size, dir)	((void)0)
-#define dma_sync_single_range_for_device(dev, addr, offset, size, dir)	((void)0)
-
 #define dma_get_cache_alignment()			  L1_CACHE_BYTES
 
 #endif	/* _ALPHA_DMA_MAPPING_H */
diff -puN arch/alpha/include/asm/pci.h~dma-mapping-alpha-use-include-linux-pci-dma-compath arch/alpha/include/asm/pci.h
--- a/arch/alpha/include/asm/pci.h~dma-mapping-alpha-use-include-linux-pci-dma-compath
+++ a/arch/alpha/include/asm/pci.h
@@ -70,128 +70,11 @@ extern inline void pcibios_penalize_isa_
    decisions.  */
 #define PCI_DMA_BUS_IS_PHYS  0
 
-/* Allocate and map kernel buffer using consistent mode DMA for PCI
-   device.  Returns non-NULL cpu-view pointer to the buffer if
-   successful and sets *DMA_ADDRP to the pci side dma address as well,
-   else DMA_ADDRP is undefined.  */
-
-extern void *__pci_alloc_consistent(struct pci_dev *, size_t,
-				    dma_addr_t *, gfp_t);
-static inline void *
-pci_alloc_consistent(struct pci_dev *dev, size_t size, dma_addr_t *dma)
-{
-	return __pci_alloc_consistent(dev, size, dma, GFP_ATOMIC);
-}
-
-/* Free and unmap a consistent DMA buffer.  CPU_ADDR and DMA_ADDR must
-   be values that were returned from pci_alloc_consistent.  SIZE must
-   be the same as what as passed into pci_alloc_consistent.
-   References to the memory and mappings associated with CPU_ADDR or
-   DMA_ADDR past this call are illegal.  */
-
-extern void pci_free_consistent(struct pci_dev *, size_t, void *, dma_addr_t);
-
-/* Map a single buffer of the indicate size for PCI DMA in streaming mode.
-   The 32-bit PCI bus mastering address to use is returned.  Once the device
-   is given the dma address, the device owns this memory until either
-   pci_unmap_single or pci_dma_sync_single_for_cpu is performed.  */
-
-extern dma_addr_t pci_map_single(struct pci_dev *, void *, size_t, int);
-
-/* Likewise, but for a page instead of an address.  */
-extern dma_addr_t pci_map_page(struct pci_dev *, struct page *,
-			       unsigned long, size_t, int);
-
-/* Test for pci_map_single or pci_map_page having generated an error.  */
-
-static inline int
-pci_dma_mapping_error(struct pci_dev *pdev, dma_addr_t dma_addr)
-{
-	return dma_addr == 0;
-}
-
-/* Unmap a single streaming mode DMA translation.  The DMA_ADDR and
-   SIZE must match what was provided for in a previous pci_map_single
-   call.  All other usages are undefined.  After this call, reads by
-   the cpu to the buffer are guaranteed to see whatever the device
-   wrote there.  */
-
-extern void pci_unmap_single(struct pci_dev *, dma_addr_t, size_t, int);
-extern void pci_unmap_page(struct pci_dev *, dma_addr_t, size_t, int);
-
-/* Map a set of buffers described by scatterlist in streaming mode for
-   PCI DMA.  This is the scatter-gather version of the above
-   pci_map_single interface.  Here the scatter gather list elements
-   are each tagged with the appropriate PCI dma address and length.
-   They are obtained via sg_dma_{address,length}(SG).
-
-   NOTE: An implementation may be able to use a smaller number of DMA
-   address/length pairs than there are SG table elements.  (for
-   example via virtual mapping capabilities) The routine returns the
-   number of addr/length pairs actually used, at most nents.
-
-   Device ownership issues as mentioned above for pci_map_single are
-   the same here.  */
-
-extern int pci_map_sg(struct pci_dev *, struct scatterlist *, int, int);
-
-/* Unmap a set of streaming mode DMA translations.  Again, cpu read
-   rules concerning calls here are the same as for pci_unmap_single()
-   above.  */
-
-extern void pci_unmap_sg(struct pci_dev *, struct scatterlist *, int, int);
-
-/* Make physical memory consistent for a single streaming mode DMA
-   translation after a transfer and device currently has ownership
-   of the buffer.
-
-   If you perform a pci_map_single() but wish to interrogate the
-   buffer using the cpu, yet do not wish to teardown the PCI dma
-   mapping, you must call this function before doing so.  At the next
-   point you give the PCI dma address back to the card, you must first
-   perform a pci_dma_sync_for_device, and then the device again owns
-   the buffer.  */
-
-static inline void
-pci_dma_sync_single_for_cpu(struct pci_dev *dev, dma_addr_t dma_addr,
-			    long size, int direction)
-{
-	/* Nothing to do.  */
-}
-
-static inline void
-pci_dma_sync_single_for_device(struct pci_dev *dev, dma_addr_t dma_addr,
-			       size_t size, int direction)
-{
-	/* Nothing to do.  */
-}
-
-/* Make physical memory consistent for a set of streaming mode DMA
-   translations after a transfer.  The same as pci_dma_sync_single_*
-   but for a scatter-gather list, same rules and usage.  */
-
-static inline void
-pci_dma_sync_sg_for_cpu(struct pci_dev *dev, struct scatterlist *sg,
-			int nents, int direction)
-{
-	/* Nothing to do.  */
-}
-
-static inline void
-pci_dma_sync_sg_for_device(struct pci_dev *dev, struct scatterlist *sg,
-			   int nents, int direction)
-{
-	/* Nothing to do.  */
-}
-
-/* Return whether the given PCI device DMA address mask can
-   be supported properly.  For example, if your device can
-   only drive the low 24-bits during PCI bus mastering, then
-   you would pass 0x00ffffff as the mask to this function.  */
+#ifdef CONFIG_PCI
 
-extern int pci_dma_supported(struct pci_dev *hwdev, u64 mask);
+/* implement the pci_ DMA API in terms of the generic device dma_ one */
+#include <asm-generic/pci-dma-compat.h>
 
-#ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
 					unsigned long *strategy_parameter)
@@ -230,8 +113,6 @@ static inline int pci_proc_domain(struct
 	return hose->need_domain_info;
 }
 
-struct pci_dev *alpha_gendev_to_pci(struct device *dev);
-
 #endif /* __KERNEL__ */
 
 /* Values for the `which' argument to sys_pciconfig_iobase.  */
diff -puN arch/alpha/kernel/pci-noop.c~dma-mapping-alpha-use-include-linux-pci-dma-compath arch/alpha/kernel/pci-noop.c
--- a/arch/alpha/kernel/pci-noop.c~dma-mapping-alpha-use-include-linux-pci-dma-compath
+++ a/arch/alpha/kernel/pci-noop.c
@@ -106,58 +106,8 @@ sys_pciconfig_write(unsigned long bus, u
 		return -ENODEV;
 }
 
-/* Stubs for the routines in pci_iommu.c: */
-
-void *
-__pci_alloc_consistent(struct pci_dev *pdev, size_t size,
-		       dma_addr_t *dma_addrp, gfp_t gfp)
-{
-	return NULL;
-}
-
-void
-pci_free_consistent(struct pci_dev *pdev, size_t size, void *cpu_addr,
-		    dma_addr_t dma_addr)
-{
-}
-
-dma_addr_t
-pci_map_single(struct pci_dev *pdev, void *cpu_addr, size_t size,
-	       int direction)
-{
-	return (dma_addr_t) 0;
-}
-
-void
-pci_unmap_single(struct pci_dev *pdev, dma_addr_t dma_addr, size_t size,
-		 int direction)
-{
-}
-
-int
-pci_map_sg(struct pci_dev *pdev, struct scatterlist *sg, int nents,
-	   int direction)
-{
-	return 0;
-}
-
-void
-pci_unmap_sg(struct pci_dev *pdev, struct scatterlist *sg, int nents,
-	     int direction)
-{
-}
-
-int
-pci_dma_supported(struct pci_dev *hwdev, dma_addr_t mask)
-{
-	return 0;
-}
-
-/* Generic DMA mapping functions: */
-
-void *
-dma_alloc_coherent(struct device *dev, size_t size,
-		   dma_addr_t *dma_handle, gfp_t gfp)
+static void *alpha_noop_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t gfp)
 {
 	void *ret;
 
@@ -171,11 +121,22 @@ dma_alloc_coherent(struct device *dev, s
 	return ret;
 }
 
-EXPORT_SYMBOL(dma_alloc_coherent);
+static void alpha_noop_free_coherent(struct device *dev, size_t size,
+				     void *cpu_addr, dma_addr_t dma_addr)
+{
+	free_pages((unsigned long)cpu_addr, get_order(size));
+}
+
+static dma_addr_t alpha_noop_map_page(struct device *dev, struct page *page,
+				      unsigned long offset, size_t size,
+				      enum dma_data_direction dir,
+				      struct dma_attrs *attrs)
+{
+	return page_to_pa(page) + offset;
+}
 
-int
-dma_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
-	   enum dma_data_direction direction)
+static int alpha_noop_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
+			     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	int i;
 	struct scatterlist *sg;
@@ -192,19 +153,37 @@ dma_map_sg(struct device *dev, struct sc
 	return nents;
 }
 
-EXPORT_SYMBOL(dma_map_sg);
+static int alpha_noop_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return 0;
+}
+
+static int alpha_noop_supported(struct device *dev, u64 mask)
+{
+	return mask < 0x00ffffffUL ? 0 : 1;
+}
 
-int
-dma_set_mask(struct device *dev, u64 mask)
+static int alpha_noop_set_mask(struct device *dev, u64 mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, mask))
 		return -EIO;
 
 	*dev->dma_mask = mask;
-
 	return 0;
 }
-EXPORT_SYMBOL(dma_set_mask);
+
+struct dma_map_ops alpha_noop_ops = {
+	.alloc_coherent		= alpha_noop_alloc_coherent,
+	.free_coherent		= alpha_noop_free_coherent,
+	.map_page		= alpha_noop_map_page,
+	.map_sg			= alpha_noop_map_sg,
+	.mapping_error		= alpha_noop_mapping_error,
+	.dma_supported		= alpha_noop_supported,
+	.set_dma_mask		= alpha_noop_set_mask,
+};
+
+struct dma_map_ops *dma_ops = &alpha_noop_ops;
+EXPORT_SYMBOL(dma_ops);
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
diff -puN arch/alpha/kernel/pci_iommu.c~dma-mapping-alpha-use-include-linux-pci-dma-compath arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~dma-mapping-alpha-use-include-linux-pci-dma-compath
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -216,10 +216,30 @@ iommu_arena_free(struct pci_iommu_arena 
 	for (i = 0; i < n; ++i)
 		p[i] = 0;
 }
-
-/* True if the machine supports DAC addressing, and DEV can
-   make use of it given MASK.  */
-static int pci_dac_dma_supported(struct pci_dev *hwdev, u64 mask);
+
+/*
+ * True if the machine supports DAC addressing, and DEV can
+ * make use of it given MASK.
+ */
+static int pci_dac_dma_supported(struct pci_dev *dev, u64 mask)
+{
+	dma64_addr_t dac_offset = alpha_mv.pci_dac_offset;
+	int ok = 1;
+
+	/* If this is not set, the machine doesn't support DAC at all.  */
+	if (dac_offset == 0)
+		ok = 0;
+
+	/* The device has to be able to address our DAC bit.  */
+	if ((dac_offset & dev->dma_mask) != dac_offset)
+		ok = 0;
+
+	/* If both conditions above are met, we are fine. */
+	DBGA("pci_dac_dma_supported %s from %p\n",
+	     ok ? "yes" : "no", __builtin_return_address(0));
+
+	return ok;
+}
 
 /* Map a single buffer of the indicated size for PCI DMA in streaming
    mode.  The 32-bit PCI bus mastering address to use is returned.
@@ -301,23 +321,36 @@ pci_map_single_1(struct pci_dev *pdev, v
 	return ret;
 }
 
-dma_addr_t
-pci_map_single(struct pci_dev *pdev, void *cpu_addr, size_t size, int dir)
+/* Helper for generic DMA-mapping functions. */
+static struct pci_dev *alpha_gendev_to_pci(struct device *dev)
 {
-	int dac_allowed; 
+	if (dev && dev->bus == &pci_bus_type)
+		return to_pci_dev(dev);
 
-	if (dir == PCI_DMA_NONE)
-		BUG();
+	/* Assume that non-PCI devices asking for DMA are either ISA or EISA,
+	   BUG() otherwise. */
+	BUG_ON(!isa_bridge);
 
-	dac_allowed = pdev ? pci_dac_dma_supported(pdev, pdev->dma_mask) : 0; 
-	return pci_map_single_1(pdev, cpu_addr, size, dac_allowed);
+	/* Assume non-busmaster ISA DMA when dma_mask is not set (the ISA
+	   bridge is bus master then). */
+	if (!dev || !dev->dma_mask || !*dev->dma_mask)
+		return isa_bridge;
+
+	/* For EISA bus masters, return isa_bridge (it might have smaller
+	   dma_mask due to wiring limitations). */
+	if (*dev->dma_mask >= isa_bridge->dma_mask)
+		return isa_bridge;
+
+	/* This assumes ISA bus master with dma_mask 0xffffff. */
+	return NULL;
 }
-EXPORT_SYMBOL(pci_map_single);
 
-dma_addr_t
-pci_map_page(struct pci_dev *pdev, struct page *page, unsigned long offset,
-	     size_t size, int dir)
+static dma_addr_t alpha_pci_map_page(struct device *dev, struct page *page,
+				     unsigned long offset, size_t size,
+				     enum dma_data_direction dir,
+				     struct dma_attrs *attrs)
 {
+	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
 	int dac_allowed;
 
 	if (dir == PCI_DMA_NONE)
@@ -327,7 +360,6 @@ pci_map_page(struct pci_dev *pdev, struc
 	return pci_map_single_1(pdev, (char *)page_address(page) + offset, 
 				size, dac_allowed);
 }
-EXPORT_SYMBOL(pci_map_page);
 
 /* Unmap a single streaming mode DMA translation.  The DMA_ADDR and
    SIZE must match what was provided for in a previous pci_map_single
@@ -335,16 +367,17 @@ EXPORT_SYMBOL(pci_map_page);
    the cpu to the buffer are guaranteed to see whatever the device
    wrote there.  */
 
-void
-pci_unmap_single(struct pci_dev *pdev, dma_addr_t dma_addr, size_t size,
-		 int direction)
+static void alpha_pci_unmap_page(struct device *dev, dma_addr_t dma_addr,
+				 size_t size, enum dma_data_direction dir,
+				 struct dma_attrs *attrs)
 {
 	unsigned long flags;
+	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
 	struct pci_controller *hose = pdev ? pdev->sysdata : pci_isa_hose;
 	struct pci_iommu_arena *arena;
 	long dma_ofs, npages;
 
-	if (direction == PCI_DMA_NONE)
+	if (dir == PCI_DMA_NONE)
 		BUG();
 
 	if (dma_addr >= __direct_map_base
@@ -393,25 +426,16 @@ pci_unmap_single(struct pci_dev *pdev, d
 	DBGA2("pci_unmap_single: sg [%llx,%zx] np %ld from %p\n",
 	      dma_addr, size, npages, __builtin_return_address(0));
 }
-EXPORT_SYMBOL(pci_unmap_single);
-
-void
-pci_unmap_page(struct pci_dev *pdev, dma_addr_t dma_addr,
-	       size_t size, int direction)
-{
-	pci_unmap_single(pdev, dma_addr, size, direction);
-}
-EXPORT_SYMBOL(pci_unmap_page);
 
 /* Allocate and map kernel buffer using consistent mode DMA for PCI
    device.  Returns non-NULL cpu-view pointer to the buffer if
    successful and sets *DMA_ADDRP to the pci side dma address as well,
    else DMA_ADDRP is undefined.  */
 
-void *
-__pci_alloc_consistent(struct pci_dev *pdev, size_t size,
-		       dma_addr_t *dma_addrp, gfp_t gfp)
+static void *alpha_pci_alloc_coherent(struct device *dev, size_t size,
+				      dma_addr_t *dma_addrp, gfp_t gfp)
 {
+	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
 	void *cpu_addr;
 	long order = get_order(size);
 
@@ -439,13 +463,12 @@ try_again:
 		gfp |= GFP_DMA;
 		goto try_again;
 	}
-		
+
 	DBGA2("pci_alloc_consistent: %zx -> [%p,%llx] from %p\n",
 	      size, cpu_addr, *dma_addrp, __builtin_return_address(0));
 
 	return cpu_addr;
 }
-EXPORT_SYMBOL(__pci_alloc_consistent);
 
 /* Free and unmap a consistent DMA buffer.  CPU_ADDR and DMA_ADDR must
    be values that were returned from pci_alloc_consistent.  SIZE must
@@ -453,17 +476,16 @@ EXPORT_SYMBOL(__pci_alloc_consistent);
    References to the memory and mappings associated with CPU_ADDR or
    DMA_ADDR past this call are illegal.  */
 
-void
-pci_free_consistent(struct pci_dev *pdev, size_t size, void *cpu_addr,
-		    dma_addr_t dma_addr)
+static void alpha_pci_free_coherent(struct device *dev, size_t size,
+				    void *cpu_addr, dma_addr_t dma_addr)
 {
+	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
 	pci_unmap_single(pdev, dma_addr, size, PCI_DMA_BIDIRECTIONAL);
 	free_pages((unsigned long)cpu_addr, get_order(size));
 
 	DBGA2("pci_free_consistent: [%llx,%zx] from %p\n",
 	      dma_addr, size, __builtin_return_address(0));
 }
-EXPORT_SYMBOL(pci_free_consistent);
 
 /* Classify the elements of the scatterlist.  Write dma_address
    of each element with:
@@ -626,23 +648,21 @@ sg_fill(struct device *dev, struct scatt
 	return 1;
 }
 
-int
-pci_map_sg(struct pci_dev *pdev, struct scatterlist *sg, int nents,
-	   int direction)
+static int alpha_pci_map_sg(struct device *dev, struct scatterlist *sg,
+			    int nents, enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
 {
+	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
 	struct scatterlist *start, *end, *out;
 	struct pci_controller *hose;
 	struct pci_iommu_arena *arena;
 	dma_addr_t max_dma;
 	int dac_allowed;
-	struct device *dev;
 
-	if (direction == PCI_DMA_NONE)
+	if (dir == PCI_DMA_NONE)
 		BUG();
 
-	dac_allowed = pdev ? pci_dac_dma_supported(pdev, pdev->dma_mask) : 0;
-
-	dev = pdev ? &pdev->dev : NULL;
+	dac_allowed = dev ? pci_dac_dma_supported(pdev, pdev->dma_mask) : 0;
 
 	/* Fast path single entry scatterlists.  */
 	if (nents == 1) {
@@ -699,19 +719,19 @@ pci_map_sg(struct pci_dev *pdev, struct 
 	/* Some allocation failed while mapping the scatterlist
 	   entries.  Unmap them now.  */
 	if (out > start)
-		pci_unmap_sg(pdev, start, out - start, direction);
+		pci_unmap_sg(pdev, start, out - start, dir);
 	return 0;
 }
-EXPORT_SYMBOL(pci_map_sg);
 
 /* Unmap a set of streaming mode DMA translations.  Again, cpu read
    rules concerning calls here are the same as for pci_unmap_single()
    above.  */
 
-void
-pci_unmap_sg(struct pci_dev *pdev, struct scatterlist *sg, int nents,
-	     int direction)
+static void alpha_pci_unmap_sg(struct device *dev, struct scatterlist *sg,
+			       int nents, enum dma_data_direction dir,
+			       struct dma_attrs *attrs)
 {
+	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
 	unsigned long flags;
 	struct pci_controller *hose;
 	struct pci_iommu_arena *arena;
@@ -719,7 +739,7 @@ pci_unmap_sg(struct pci_dev *pdev, struc
 	dma_addr_t max_dma;
 	dma_addr_t fbeg, fend;
 
-	if (direction == PCI_DMA_NONE)
+	if (dir == PCI_DMA_NONE)
 		BUG();
 
 	if (! alpha_mv.mv_pci_tbi)
@@ -783,15 +803,13 @@ pci_unmap_sg(struct pci_dev *pdev, struc
 
 	DBGA("pci_unmap_sg: %ld entries\n", nents - (end - sg));
 }
-EXPORT_SYMBOL(pci_unmap_sg);
-
 
 /* Return whether the given PCI device DMA address mask can be
    supported properly.  */
 
-int
-pci_dma_supported(struct pci_dev *pdev, u64 mask)
+static int alpha_pci_supported(struct device *dev, u64 mask)
 {
+	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
 	struct pci_controller *hose;
 	struct pci_iommu_arena *arena;
 
@@ -818,7 +836,6 @@ pci_dma_supported(struct pci_dev *pdev, 
 
 	return 0;
 }
-EXPORT_SYMBOL(pci_dma_supported);
 
 
 /*
@@ -918,66 +935,32 @@ iommu_unbind(struct pci_iommu_arena *are
 	return 0;
 }
 
-/* True if the machine supports DAC addressing, and DEV can
-   make use of it given MASK.  */
-
-static int
-pci_dac_dma_supported(struct pci_dev *dev, u64 mask)
-{
-	dma64_addr_t dac_offset = alpha_mv.pci_dac_offset;
-	int ok = 1;
-
-	/* If this is not set, the machine doesn't support DAC at all.  */
-	if (dac_offset == 0)
-		ok = 0;
-
-	/* The device has to be able to address our DAC bit.  */
-	if ((dac_offset & dev->dma_mask) != dac_offset)
-		ok = 0;
-
-	/* If both conditions above are met, we are fine. */
-	DBGA("pci_dac_dma_supported %s from %p\n",
-	     ok ? "yes" : "no", __builtin_return_address(0));
-
-	return ok;
-}
-
-/* Helper for generic DMA-mapping functions. */
-
-struct pci_dev *
-alpha_gendev_to_pci(struct device *dev)
+static int alpha_pci_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	if (dev && dev->bus == &pci_bus_type)
-		return to_pci_dev(dev);
-
-	/* Assume that non-PCI devices asking for DMA are either ISA or EISA,
-	   BUG() otherwise. */
-	BUG_ON(!isa_bridge);
-
-	/* Assume non-busmaster ISA DMA when dma_mask is not set (the ISA
-	   bridge is bus master then). */
-	if (!dev || !dev->dma_mask || !*dev->dma_mask)
-		return isa_bridge;
-
-	/* For EISA bus masters, return isa_bridge (it might have smaller
-	   dma_mask due to wiring limitations). */
-	if (*dev->dma_mask >= isa_bridge->dma_mask)
-		return isa_bridge;
-
-	/* This assumes ISA bus master with dma_mask 0xffffff. */
-	return NULL;
+	return dma_addr == 0;
 }
-EXPORT_SYMBOL(alpha_gendev_to_pci);
 
-int
-dma_set_mask(struct device *dev, u64 mask)
+static int alpha_pci_set_mask(struct device *dev, u64 mask)
 {
 	if (!dev->dma_mask ||
 	    !pci_dma_supported(alpha_gendev_to_pci(dev), mask))
 		return -EIO;
 
 	*dev->dma_mask = mask;
-
 	return 0;
 }
-EXPORT_SYMBOL(dma_set_mask);
+
+struct dma_map_ops alpha_pci_ops = {
+	.alloc_coherent		= alpha_pci_alloc_coherent,
+	.free_coherent		= alpha_pci_free_coherent,
+	.map_page		= alpha_pci_map_page,
+	.unmap_page		= alpha_pci_unmap_page,
+	.map_sg			= alpha_pci_map_sg,
+	.unmap_sg		= alpha_pci_unmap_sg,
+	.mapping_error		= alpha_pci_mapping_error,
+	.dma_supported		= alpha_pci_supported,
+	.set_dma_mask		= alpha_pci_set_mask,
+};
+
+struct dma_map_ops *dma_ops = &alpha_pci_ops;
+EXPORT_SYMBOL(dma_ops);
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

