From: akpm@linux-foundation.org
Subject: + dma-mapping-consolidate-dma_set_mask.patch added to -mm tree
Date: Mon, 17 Aug 2015 14:25:43 -0700
Message-ID: <55d25157.0R/C4Lt47O3BzLQ7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbbHQVZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 17:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, arnd@arndb.de, benh@kernel.crashing.org, catalin.marinas@arm.com, cmetcalf@ezchip.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, jonas@southpole.se, linux@arm.linux.org.uk, mingo@elte.hu, monstr@monstr.eu, ralf@linux-mips.org, tglx@linutronix.de, will.deacon@arm.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: consolidate dma_set_mask
has been added to the -mm tree.  Its filename is
     dma-mapping-consolidate-dma_set_mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-consolidate-dma_set_mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-consolidate-dma_set_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: dma-mapping: consolidate dma_set_mask

Almost everyone implements dma_set_mask the same way, although some time
that's hidden in ->set_dma_mask methods.

This patch consolidates those into a common implementation that either
calls ->set_dma_mask if present or otherwise uses the default
implementation.  Some architectures used to only call ->set_dma_mask
after the initial checks, and those instance have been fixed to do the
full work.  h8300 implemented dma_set_mask bogusly as a no-ops and has
been fixed.

Unfortunately some architectures overload unrelated semantics like changing
the dma_ops into it so we still need to allow for an architecture override
for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/dma-mapping.h      |    5 -----
 arch/alpha/kernel/pci-noop.c              |   10 ----------
 arch/alpha/kernel/pci_iommu.c             |   11 -----------
 arch/arm/include/asm/dma-mapping.h        |    5 -----
 arch/arm64/include/asm/dma-mapping.h      |    9 ---------
 arch/h8300/include/asm/dma-mapping.h      |    5 -----
 arch/hexagon/include/asm/dma-mapping.h    |    1 -
 arch/hexagon/kernel/dma.c                 |   11 -----------
 arch/ia64/include/asm/dma-mapping.h       |    9 ---------
 arch/microblaze/include/asm/dma-mapping.h |   14 --------------
 arch/mips/include/asm/dma-mapping.h       |   16 ----------------
 arch/mips/loongson64/common/dma-swiotlb.c |    3 +++
 arch/openrisc/include/asm/dma-mapping.h   |    9 ---------
 arch/powerpc/include/asm/dma-mapping.h    |    4 +++-
 arch/s390/include/asm/dma-mapping.h       |    2 --
 arch/s390/pci/pci_dma.c                   |   10 ----------
 arch/sh/include/asm/dma-mapping.h         |   14 --------------
 arch/sparc/include/asm/dma-mapping.h      |    4 +++-
 arch/tile/include/asm/dma-mapping.h       |    6 ++++--
 arch/unicore32/include/asm/dma-mapping.h  |   10 ----------
 arch/x86/include/asm/dma-mapping.h        |    2 --
 arch/x86/kernel/pci-dma.c                 |   11 -----------
 include/asm-generic/dma-mapping-common.h  |   15 +++++++++++++++
 23 files changed, 28 insertions(+), 158 deletions(-)

diff -puN arch/alpha/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/alpha/include/asm/dma-mapping.h
--- a/arch/alpha/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/alpha/include/asm/dma-mapping.h
@@ -12,11 +12,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_set_mask(struct device *dev, u64 mask)
-{
-	return get_dma_ops(dev)->set_dma_mask(dev, mask);
-}
-
 #define dma_cache_sync(dev, va, size, dir)		  ((void)0)
 
 #endif	/* _ALPHA_DMA_MAPPING_H */
diff -puN arch/alpha/kernel/pci-noop.c~dma-mapping-consolidate-dma_set_mask arch/alpha/kernel/pci-noop.c
--- a/arch/alpha/kernel/pci-noop.c~dma-mapping-consolidate-dma_set_mask
+++ a/arch/alpha/kernel/pci-noop.c
@@ -166,15 +166,6 @@ static int alpha_noop_supported(struct d
 	return mask < 0x00ffffffUL ? 0 : 1;
 }
 
-static int alpha_noop_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-	return 0;
-}
-
 struct dma_map_ops alpha_noop_ops = {
 	.alloc			= alpha_noop_alloc_coherent,
 	.free			= alpha_noop_free_coherent,
@@ -182,7 +173,6 @@ struct dma_map_ops alpha_noop_ops = {
 	.map_sg			= alpha_noop_map_sg,
 	.mapping_error		= alpha_noop_mapping_error,
 	.dma_supported		= alpha_noop_supported,
-	.set_dma_mask		= alpha_noop_set_mask,
 };
 
 struct dma_map_ops *dma_ops = &alpha_noop_ops;
diff -puN arch/alpha/kernel/pci_iommu.c~dma-mapping-consolidate-dma_set_mask arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~dma-mapping-consolidate-dma_set_mask
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -939,16 +939,6 @@ static int alpha_pci_mapping_error(struc
 	return dma_addr == 0;
 }
 
-static int alpha_pci_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask ||
-	    !pci_dma_supported(alpha_gendev_to_pci(dev), mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-	return 0;
-}
-
 struct dma_map_ops alpha_pci_ops = {
 	.alloc			= alpha_pci_alloc_coherent,
 	.free			= alpha_pci_free_coherent,
@@ -958,7 +948,6 @@ struct dma_map_ops alpha_pci_ops = {
 	.unmap_sg		= alpha_pci_unmap_sg,
 	.mapping_error		= alpha_pci_mapping_error,
 	.dma_supported		= alpha_pci_supported,
-	.set_dma_mask		= alpha_pci_set_mask,
 };
 
 struct dma_map_ops *dma_ops = &alpha_pci_ops;
diff -puN arch/arm/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/arm/include/asm/dma-mapping.h
--- a/arch/arm/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/arm/include/asm/dma-mapping.h
@@ -48,11 +48,6 @@ extern int dma_supported(struct device *
  */
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_set_mask(struct device *dev, u64 mask)
-{
-	return get_dma_ops(dev)->set_dma_mask(dev, mask);
-}
-
 #ifdef __arch_page_to_dma
 #error Please update to __arch_pfn_to_dma
 #endif
diff -puN arch/arm64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/arm64/include/asm/dma-mapping.h
--- a/arch/arm64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/arm64/include/asm/dma-mapping.h
@@ -84,15 +84,6 @@ static inline phys_addr_t dma_to_phys(st
 	return (phys_addr_t)dev_addr;
 }
 
-static inline int dma_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-	*dev->dma_mask = mask;
-
-	return 0;
-}
-
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
 	if (!dev->dma_mask)
diff -puN arch/h8300/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/h8300/include/asm/dma-mapping.h
--- a/arch/h8300/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/h8300/include/asm/dma-mapping.h
@@ -10,9 +10,4 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_set_mask(struct device *dev, u64 mask)
-{
-	return 0;
-}
-
 #endif
diff -puN arch/hexagon/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/hexagon/include/asm/dma-mapping.h
--- a/arch/hexagon/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/hexagon/include/asm/dma-mapping.h
@@ -45,7 +45,6 @@ static inline struct dma_map_ops *get_dm
 
 #define HAVE_ARCH_DMA_SUPPORTED 1
 extern int dma_supported(struct device *dev, u64 mask);
-extern int dma_set_mask(struct device *dev, u64 mask);
 extern int dma_is_consistent(struct device *dev, dma_addr_t dma_handle);
 extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 			   enum dma_data_direction direction);
diff -puN arch/hexagon/kernel/dma.c~dma-mapping-consolidate-dma_set_mask arch/hexagon/kernel/dma.c
--- a/arch/hexagon/kernel/dma.c~dma-mapping-consolidate-dma_set_mask
+++ a/arch/hexagon/kernel/dma.c
@@ -44,17 +44,6 @@ int dma_supported(struct device *dev, u6
 }
 EXPORT_SYMBOL(dma_supported);
 
-int dma_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
-EXPORT_SYMBOL(dma_set_mask);
-
 static struct gen_pool *coherent_pool;
 
 
diff -puN arch/ia64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/ia64/include/asm/dma-mapping.h
--- a/arch/ia64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/ia64/include/asm/dma-mapping.h
@@ -27,15 +27,6 @@ extern void machvec_dma_sync_sg(struct d
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int
-dma_set_mask (struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-	*dev->dma_mask = mask;
-	return 0;
-}
-
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
 	if (!dev->dma_mask)
diff -puN arch/microblaze/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/microblaze/include/asm/dma-mapping.h
--- a/arch/microblaze/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/microblaze/include/asm/dma-mapping.h
@@ -46,20 +46,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_set_mask(struct device *dev, u64 dma_mask)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	if (unlikely(ops == NULL))
-		return -EIO;
-	if (ops->set_dma_mask)
-		return ops->set_dma_mask(dev, dma_mask);
-	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
-		return -EIO;
-	*dev->dma_mask = dma_mask;
-	return 0;
-}
-
 static inline void __dma_sync(unsigned long paddr,
 			      size_t size, enum dma_data_direction direction)
 {
diff -puN arch/mips/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/mips/include/asm/dma-mapping.h
--- a/arch/mips/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/mips/include/asm/dma-mapping.h
@@ -31,22 +31,6 @@ static inline void dma_mark_clean(void *
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int
-dma_set_mask(struct device *dev, u64 mask)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	if(!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	if (ops->set_dma_mask)
-		return ops->set_dma_mask(dev, mask);
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
-
 extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction);
 
diff -puN arch/mips/loongson64/common/dma-swiotlb.c~dma-mapping-consolidate-dma_set_mask arch/mips/loongson64/common/dma-swiotlb.c
--- a/arch/mips/loongson64/common/dma-swiotlb.c~dma-mapping-consolidate-dma_set_mask
+++ a/arch/mips/loongson64/common/dma-swiotlb.c
@@ -85,6 +85,9 @@ static void loongson_dma_sync_sg_for_dev
 
 static int loongson_dma_set_mask(struct device *dev, u64 mask)
 {
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+
 	if (mask > DMA_BIT_MASK(loongson_sysconf.dma_mask_bits)) {
 		*dev->dma_mask = DMA_BIT_MASK(loongson_sysconf.dma_mask_bits);
 		return -EIO;
diff -puN arch/openrisc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/openrisc/include/asm/dma-mapping.h
--- a/arch/openrisc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/openrisc/include/asm/dma-mapping.h
@@ -44,13 +44,4 @@ static inline int dma_supported(struct d
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_set_mask(struct device *dev, u64 dma_mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
-		return -EIO;
-
-	*dev->dma_mask = dma_mask;
-
-	return 0;
-}
 #endif	/* __ASM_OPENRISC_DMA_MAPPING_H */
diff -puN arch/powerpc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/powerpc/include/asm/dma-mapping.h
--- a/arch/powerpc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/powerpc/include/asm/dma-mapping.h
@@ -122,9 +122,11 @@ static inline void set_dma_offset(struct
 /* this will be removed soon */
 #define flush_write_buffers()
 
+#define HAVE_ARCH_DMA_SET_MASK 1
+extern int dma_set_mask(struct device *dev, u64 dma_mask);
+
 #include <asm-generic/dma-mapping-common.h>
 
-extern int dma_set_mask(struct device *dev, u64 dma_mask);
 extern int __dma_set_mask(struct device *dev, u64 dma_mask);
 extern u64 __dma_get_required_mask(struct device *dev);
 
diff -puN arch/s390/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/s390/include/asm/dma-mapping.h
--- a/arch/s390/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/s390/include/asm/dma-mapping.h
@@ -18,8 +18,6 @@ static inline struct dma_map_ops *get_dm
 	return &s390_dma_ops;
 }
 
-extern int dma_set_mask(struct device *dev, u64 mask);
-
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 				  enum dma_data_direction direction)
 {
diff -puN arch/s390/pci/pci_dma.c~dma-mapping-consolidate-dma_set_mask arch/s390/pci/pci_dma.c
--- a/arch/s390/pci/pci_dma.c~dma-mapping-consolidate-dma_set_mask
+++ a/arch/s390/pci/pci_dma.c
@@ -262,16 +262,6 @@ out:
 	spin_unlock_irqrestore(&zdev->iommu_bitmap_lock, flags);
 }
 
-int dma_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(dma_set_mask);
-
 static dma_addr_t s390_dma_map_pages(struct device *dev, struct page *page,
 				     unsigned long offset, size_t size,
 				     enum dma_data_direction direction,
diff -puN arch/sh/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/sh/include/asm/dma-mapping.h
--- a/arch/sh/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/sh/include/asm/dma-mapping.h
@@ -13,20 +13,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_set_mask(struct device *dev, u64 mask)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-	if (ops->set_dma_mask)
-		return ops->set_dma_mask(dev, mask);
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
-
 void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		    enum dma_data_direction dir);
 
diff -puN arch/sparc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/sparc/include/asm/dma-mapping.h
--- a/arch/sparc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/sparc/include/asm/dma-mapping.h
@@ -37,7 +37,7 @@ static inline struct dma_map_ops *get_dm
 	return dma_ops;
 }
 
-#include <asm-generic/dma-mapping-common.h>
+#define HAVE_ARCH_DMA_SET_MASK 1
 
 static inline int dma_set_mask(struct device *dev, u64 mask)
 {
@@ -52,4 +52,6 @@ static inline int dma_set_mask(struct de
 	return -EINVAL;
 }
 
+#include <asm-generic/dma-mapping-common.h>
+
 #endif
diff -puN arch/tile/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/tile/include/asm/dma-mapping.h
--- a/arch/tile/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/tile/include/asm/dma-mapping.h
@@ -59,8 +59,6 @@ static inline phys_addr_t dma_to_phys(st
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
 
-#include <asm-generic/dma-mapping-common.h>
-
 static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
 {
 	dev->archdata.dma_ops = ops;
@@ -74,6 +72,10 @@ static inline bool dma_capable(struct de
 	return addr + size - 1 <= *dev->dma_mask;
 }
 
+#define HAVE_ARCH_DMA_SET_MASK 1
+
+#include <asm-generic/dma-mapping-common.h>
+
 static inline int
 dma_set_mask(struct device *dev, u64 mask)
 {
diff -puN arch/unicore32/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/unicore32/include/asm/dma-mapping.h
--- a/arch/unicore32/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/unicore32/include/asm/dma-mapping.h
@@ -50,16 +50,6 @@ static inline phys_addr_t dma_to_phys(st
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
 
-static inline int dma_set_mask(struct device *dev, u64 dma_mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
-		return -EIO;
-
-	*dev->dma_mask = dma_mask;
-
-	return 0;
-}
-
 static inline void dma_cache_sync(struct device *dev, void *vaddr,
 		size_t size, enum dma_data_direction direction)
 {
diff -puN arch/x86/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -48,8 +48,6 @@ extern int dma_supported(struct device *
 
 #include <asm-generic/dma-mapping-common.h>
 
-extern int dma_set_mask(struct device *dev, u64 mask);
-
 extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_addr, gfp_t flag,
 					struct dma_attrs *attrs);
diff -puN arch/x86/kernel/pci-dma.c~dma-mapping-consolidate-dma_set_mask arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~dma-mapping-consolidate-dma_set_mask
+++ a/arch/x86/kernel/pci-dma.c
@@ -58,17 +58,6 @@ EXPORT_SYMBOL(x86_dma_fallback_dev);
 /* Number of entries preallocated for DMA-API debugging */
 #define PREALLOC_DMA_DEBUG_ENTRIES       65536
 
-int dma_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
-EXPORT_SYMBOL(dma_set_mask);
-
 void __init pci_iommu_alloc(void)
 {
 	struct iommu_table_entry *p;
diff -puN include/asm-generic/dma-mapping-common.h~dma-mapping-consolidate-dma_set_mask include/asm-generic/dma-mapping-common.h
--- a/include/asm-generic/dma-mapping-common.h~dma-mapping-consolidate-dma_set_mask
+++ a/include/asm-generic/dma-mapping-common.h
@@ -340,4 +340,19 @@ static inline int dma_supported(struct d
 }
 #endif
 
+#ifndef HAVE_ARCH_DMA_SET_MASK
+static inline int dma_set_mask(struct device *dev, u64 mask)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (ops->set_dma_mask)
+		return ops->set_dma_mask(dev, mask);
+
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+	*dev->dma_mask = mask;
+	return 0;
+}
+#endif
+
 #endif
_

Patches currently in -mm which might be from hch@lst.de are

add-myself-to-get_maintainerignore.patch
mm-swap-zswap-maybe_preload-refactoring.patch
linux-next.patch
dma-mapping-consolidate-dma_allocfree_attrscoherent.patch
dma-mapping-consolidate-dma_allocfree_noncoherent.patch
dma-mapping-cosolidate-dma_mapping_error.patch
dma-mapping-consolidate-dma_supported.patch
dma-mapping-consolidate-dma_set_mask.patch

