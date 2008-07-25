From: akpm@linux-foundation.org
Subject: - dma-mapping-x86-per-device-dma_mapping_ops-support.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:39:43 -0700
Message-ID: <200807252339.m6PNdhnp005473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752609AbYGYXlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, andi@firstfloor.org, avi@qumranet.com, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: x86: per-device dma_mapping_ops support
has been removed from the -mm tree.  Its filename was
     dma-mapping-x86-per-device-dma_mapping_ops-support.patch

This patch was dropped because it was folded into dma-mapping-add-the-device-argument-to-dma_mapping_error.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: x86: per-device dma_mapping_ops support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This adds per-device dma_mapping_ops support for CONFIG_X86_64.

A pointer to dma_mapping_ops to struct dev_archdata is added. If the
pointer is non NULL, DMA operations in asm/dma-mapping.h use it. If
it's NULL, the system-wide dma_ops pointer is used as before.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-calgary_64.c |    2 
 arch/x86/kernel/pci-dma.c        |    2 
 arch/x86/kernel/pci-gart_64.c    |    2 
 arch/x86/kernel/pci-nommu.c      |   14 ----
 arch/x86/kernel/pci-swiotlb_64.c |    2 
 include/asm-x86/device.h         |    3 
 include/asm-x86/dma-mapping.h    |   95 ++++++++++++++++++++---------
 7 files changed, 74 insertions(+), 46 deletions(-)

diff -puN arch/x86/kernel/pci-calgary_64.c~dma-mapping-x86-per-device-dma_mapping_ops-support arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~dma-mapping-x86-per-device-dma_mapping_ops-support
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -541,7 +541,7 @@ error:
 	return ret;
 }
 
-static const struct dma_mapping_ops calgary_dma_ops = {
+static struct dma_mapping_ops calgary_dma_ops = {
 	.alloc_coherent = calgary_alloc_coherent,
 	.map_single = calgary_map_single,
 	.unmap_single = calgary_unmap_single,
diff -puN arch/x86/kernel/pci-dma.c~dma-mapping-x86-per-device-dma_mapping_ops-support arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~dma-mapping-x86-per-device-dma_mapping_ops-support
+++ a/arch/x86/kernel/pci-dma.c
@@ -11,7 +11,7 @@
 
 static int forbid_dac __read_mostly;
 
-const struct dma_mapping_ops *dma_ops;
+struct dma_mapping_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int iommu_sac_force __read_mostly;
diff -puN arch/x86/kernel/pci-gart_64.c~dma-mapping-x86-per-device-dma_mapping_ops-support arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c~dma-mapping-x86-per-device-dma_mapping_ops-support
+++ a/arch/x86/kernel/pci-gart_64.c
@@ -692,7 +692,7 @@ static __init int init_k8_gatt(struct ag
 
 extern int agp_amd64_init(void);
 
-static const struct dma_mapping_ops gart_dma_ops = {
+static struct dma_mapping_ops gart_dma_ops = {
 	.map_single			= gart_map_single,
 	.map_simple			= gart_map_simple,
 	.unmap_single			= gart_unmap_single,
diff -puN arch/x86/kernel/pci-nommu.c~dma-mapping-x86-per-device-dma_mapping_ops-support arch/x86/kernel/pci-nommu.c
--- a/arch/x86/kernel/pci-nommu.c~dma-mapping-x86-per-device-dma_mapping_ops-support
+++ a/arch/x86/kernel/pci-nommu.c
@@ -72,21 +72,9 @@ static int nommu_map_sg(struct device *h
 	return nents;
 }
 
-/* Make sure we keep the same behaviour */
-static int nommu_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
-{
-#ifdef CONFIG_X86_32
-	return 0;
-#else
-	return (dma_addr == bad_dma_address);
-#endif
-}
-
-
-const struct dma_mapping_ops nommu_dma_ops = {
+struct dma_mapping_ops nommu_dma_ops = {
 	.map_single = nommu_map_single,
 	.map_sg = nommu_map_sg,
-	.mapping_error = nommu_mapping_error,
 	.is_phys = 1,
 };
 
diff -puN arch/x86/kernel/pci-swiotlb_64.c~dma-mapping-x86-per-device-dma_mapping_ops-support arch/x86/kernel/pci-swiotlb_64.c
--- a/arch/x86/kernel/pci-swiotlb_64.c~dma-mapping-x86-per-device-dma_mapping_ops-support
+++ a/arch/x86/kernel/pci-swiotlb_64.c
@@ -18,7 +18,7 @@ swiotlb_map_single_phys(struct device *h
 	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
 }
 
-const struct dma_mapping_ops swiotlb_dma_ops = {
+struct dma_mapping_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
diff -puN include/asm-x86/device.h~dma-mapping-x86-per-device-dma_mapping_ops-support include/asm-x86/device.h
--- a/include/asm-x86/device.h~dma-mapping-x86-per-device-dma_mapping_ops-support
+++ a/include/asm-x86/device.h
@@ -5,6 +5,9 @@ struct dev_archdata {
 #ifdef CONFIG_ACPI
 	void	*acpi_handle;
 #endif
+#ifdef CONFIG_X86_64
+struct dma_mapping_ops *dma_ops;
+#endif
 #ifdef CONFIG_DMAR
 	void *iommu; /* hook for IOMMU specific extension */
 #endif
diff -puN include/asm-x86/dma-mapping.h~dma-mapping-x86-per-device-dma_mapping_ops-support include/asm-x86/dma-mapping.h
--- a/include/asm-x86/dma-mapping.h~dma-mapping-x86-per-device-dma_mapping_ops-support
+++ a/include/asm-x86/dma-mapping.h
@@ -57,14 +57,33 @@ struct dma_mapping_ops {
 	int		is_phys;
 };
 
-extern const struct dma_mapping_ops *dma_ops;
+extern struct dma_mapping_ops *dma_ops;
 
+static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
+{
+#ifdef CONFIG_X86_32
+	return dma_ops;
+#else
+	if (unlikely(!dev) || !dev->archdata.dma_ops)
+		return dma_ops;
+	else
+		return dev->archdata.dma_ops;
+#endif
+}
+
+/* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	if (dma_ops->mapping_error)
-		return dma_ops->mapping_error(dev, dma_addr);
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
+#ifdef CONFIG_X86_32
+	return 0;
+#else
+	if (ops->mapping_error)
+		return ops->mapping_error(dev, dma_addr);
 
 	return (dma_addr == bad_dma_address);
+#endif
 }
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
@@ -84,44 +103,53 @@ static inline dma_addr_t
 dma_map_single(struct device *hwdev, void *ptr, size_t size,
 	       int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	return dma_ops->map_single(hwdev, virt_to_phys(ptr), size, direction);
+	return ops->map_single(hwdev, virt_to_phys(ptr), size, direction);
 }
 
 static inline void
 dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
 		 int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->unmap_single)
-		dma_ops->unmap_single(dev, addr, size, direction);
+	if (ops->unmap_single)
+		ops->unmap_single(dev, addr, size, direction);
 }
 
 static inline int
 dma_map_sg(struct device *hwdev, struct scatterlist *sg,
 	   int nents, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	return dma_ops->map_sg(hwdev, sg, nents, direction);
+	return ops->map_sg(hwdev, sg, nents, direction);
 }
 
 static inline void
 dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
 	     int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->unmap_sg)
-		dma_ops->unmap_sg(hwdev, sg, nents, direction);
+	if (ops->unmap_sg)
+		ops->unmap_sg(hwdev, sg, nents, direction);
 }
 
 static inline void
 dma_sync_single_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
 			size_t size, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_for_cpu)
-		dma_ops->sync_single_for_cpu(hwdev, dma_handle, size,
-					     direction);
+	if (ops->sync_single_for_cpu)
+		ops->sync_single_for_cpu(hwdev, dma_handle, size, direction);
 	flush_write_buffers();
 }
 
@@ -129,10 +157,11 @@ static inline void
 dma_sync_single_for_device(struct device *hwdev, dma_addr_t dma_handle,
 			   size_t size, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_for_device)
-		dma_ops->sync_single_for_device(hwdev, dma_handle, size,
-						direction);
+	if (ops->sync_single_for_device)
+		ops->sync_single_for_device(hwdev, dma_handle, size, direction);
 	flush_write_buffers();
 }
 
@@ -140,11 +169,12 @@ static inline void
 dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
 			      unsigned long offset, size_t size, int direction)
 {
-	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_range_for_cpu)
-		dma_ops->sync_single_range_for_cpu(hwdev, dma_handle, offset,
-						   size, direction);
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
+	BUG_ON(!valid_dma_direction(direction));
+	if (ops->sync_single_range_for_cpu)
+		ops->sync_single_range_for_cpu(hwdev, dma_handle, offset,
+					       size, direction);
 	flush_write_buffers();
 }
 
@@ -153,11 +183,12 @@ dma_sync_single_range_for_device(struct 
 				 unsigned long offset, size_t size,
 				 int direction)
 {
-	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_range_for_device)
-		dma_ops->sync_single_range_for_device(hwdev, dma_handle,
-						      offset, size, direction);
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
+	BUG_ON(!valid_dma_direction(direction));
+	if (ops->sync_single_range_for_device)
+		ops->sync_single_range_for_device(hwdev, dma_handle,
+						  offset, size, direction);
 	flush_write_buffers();
 }
 
@@ -165,9 +196,11 @@ static inline void
 dma_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
 		    int nelems, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_sg_for_cpu)
-		dma_ops->sync_sg_for_cpu(hwdev, sg, nelems, direction);
+	if (ops->sync_sg_for_cpu)
+		ops->sync_sg_for_cpu(hwdev, sg, nelems, direction);
 	flush_write_buffers();
 }
 
@@ -175,9 +208,11 @@ static inline void
 dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 		       int nelems, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_sg_for_device)
-		dma_ops->sync_sg_for_device(hwdev, sg, nelems, direction);
+	if (ops->sync_sg_for_device)
+		ops->sync_sg_for_device(hwdev, sg, nelems, direction);
 
 	flush_write_buffers();
 }
@@ -186,9 +221,11 @@ static inline dma_addr_t dma_map_page(st
 				      size_t offset, size_t size,
 				      int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	return dma_ops->map_single(dev, page_to_phys(page)+offset,
-				   size, direction);
+	return ops->map_single(dev, page_to_phys(page) + offset,
+			       size, direction);
 }
 
 static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
block-blk-mapc-use-the-new-object_is_on_stack-helper.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sdhci-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-infiniband.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-more-sparc.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-ibmvscsi.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch

