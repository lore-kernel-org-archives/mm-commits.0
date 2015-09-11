From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-consolidate-dma_allocfree_noncoherent.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:14:01 -0700
Message-ID: <55f319e9.Kv0DGTxCXwbt6MhF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbbIKSOD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:14:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, andy.shevchenko@gmail.com, arnd@arndb.de, benh@kernel.crashing.org, catalin.marinas@arm.com, cmetcalf@ezchip.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, jcmvbkbc@gmail.com, jonas@southpole.se, linux@arm.linux.org.uk, mingo@elte.hu, monstr@monstr.eu, ralf@linux-mips.org, tglx@linutronix.de, will.deacon@arm.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: consolidate dma_{alloc,free}_noncoherent
has been removed from the -mm tree.  Its filename was
     dma-mapping-consolidate-dma_allocfree_noncoherent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: dma-mapping: consolidate dma_{alloc,free}_noncoherent

Most architectures do not support non-coherent allocations and either
define dma_{alloc,free}_noncoherent to their coherent versions or stub
them out.

Openrisc uses dma_{alloc,free}_attrs to implement them, and only Mips
implements them directly.

This patch moves the Openrisc version to common code, and handles the
DMA_ATTR_NON_CONSISTENT case in the mips dma_map_ops instance.

Note that actual non-coherent allocations require a dma_cache_sync
implementation, so if non-coherent allocations didn't work on
an architecture before this patch they still won't work after it.

[jcmvbkbc@gmail.com: fix xtensa]
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
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/dma-mapping.h      |    3 --
 arch/arm/include/asm/dma-mapping.h        |   21 +++++---------------
 arch/arm64/include/asm/dma-mapping.h      |   14 -------------
 arch/h8300/include/asm/dma-mapping.h      |    3 --
 arch/hexagon/include/asm/dma-mapping.h    |    3 --
 arch/ia64/include/asm/dma-mapping.h       |    3 --
 arch/microblaze/include/asm/dma-mapping.h |    3 --
 arch/mips/include/asm/dma-mapping.h       |    6 -----
 arch/mips/mm/dma-default.c                |   20 ++++++++++++++-----
 arch/openrisc/include/asm/dma-mapping.h   |   20 -------------------
 arch/powerpc/include/asm/dma-mapping.h    |    3 --
 arch/s390/include/asm/dma-mapping.h       |    3 --
 arch/sh/include/asm/dma-mapping.h         |    3 --
 arch/sparc/include/asm/dma-mapping.h      |    3 --
 arch/tile/include/asm/dma-mapping.h       |    3 --
 arch/unicore32/include/asm/dma-mapping.h  |    3 --
 arch/x86/include/asm/dma-mapping.h        |    3 --
 arch/xtensa/include/asm/dma-mapping.h     |    3 --
 include/asm-generic/dma-mapping-common.h  |   18 +++++++++++++++++
 19 files changed, 39 insertions(+), 99 deletions(-)

diff -puN arch/alpha/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/alpha/include/asm/dma-mapping.h
--- a/arch/alpha/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/alpha/include/asm/dma-mapping.h
@@ -27,9 +27,6 @@ static inline int dma_set_mask(struct de
 	return get_dma_ops(dev)->set_dma_mask(dev, mask);
 }
 
-#define dma_alloc_noncoherent(d, s, h, f)	dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h)	dma_free_coherent(d, s, v, h)
-
 #define dma_cache_sync(dev, va, size, dir)		  ((void)0)
 
 #endif	/* _ALPHA_DMA_MAPPING_H */
diff -puN arch/arm/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/arm/include/asm/dma-mapping.h
--- a/arch/arm/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/arm/include/asm/dma-mapping.h
@@ -38,6 +38,12 @@ static inline void set_dma_ops(struct de
 	dev->archdata.dma_ops = ops;
 }
 
+/*
+ * Note that while the generic code provides dummy dma_{alloc,free}_noncoherent
+ * implementations, we don't provide a dma_cache_sync function so drivers using
+ * this API are highlighted with build warnings.
+ */
+
 #include <asm-generic/dma-mapping-common.h>
 
 static inline int dma_set_mask(struct device *dev, u64 mask)
@@ -175,21 +181,6 @@ static inline int dma_mapping_error(stru
 	return dma_addr == DMA_ERROR_CODE;
 }
 
-/*
- * Dummy noncoherent implementation.  We don't provide a dma_cache_sync
- * function so drivers using this API are highlighted with build warnings.
- */
-static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
-		dma_addr_t *handle, gfp_t gfp)
-{
-	return NULL;
-}
-
-static inline void dma_free_noncoherent(struct device *dev, size_t size,
-		void *cpu_addr, dma_addr_t handle)
-{
-}
-
 extern int dma_supported(struct device *dev, u64 mask);
 
 extern int arm_dma_set_mask(struct device *dev, u64 dma_mask);
diff -puN arch/arm64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/arm64/include/asm/dma-mapping.h
--- a/arch/arm64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/arm64/include/asm/dma-mapping.h
@@ -118,19 +118,5 @@ static inline void dma_mark_clean(void *
 {
 }
 
-/*
- * There is no dma_cache_sync() implementation, so just return NULL here.
- */
-static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
-					  dma_addr_t *handle, gfp_t flags)
-{
-	return NULL;
-}
-
-static inline void dma_free_noncoherent(struct device *dev, size_t size,
-					void *cpu_addr, dma_addr_t handle)
-{
-}
-
 #endif	/* __KERNEL__ */
 #endif	/* __ASM_DMA_MAPPING_H */
diff -puN arch/h8300/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/h8300/include/asm/dma-mapping.h
--- a/arch/h8300/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/h8300/include/asm/dma-mapping.h
@@ -20,9 +20,6 @@ static inline int dma_set_mask(struct de
 	return 0;
 }
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
diff -puN arch/hexagon/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/hexagon/include/asm/dma-mapping.h
--- a/arch/hexagon/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/hexagon/include/asm/dma-mapping.h
@@ -34,9 +34,6 @@ extern int bad_dma_address;
 
 extern struct dma_map_ops *dma_ops;
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	if (unlikely(dev == NULL))
diff -puN arch/ia64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/ia64/include/asm/dma-mapping.h
--- a/arch/ia64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/ia64/include/asm/dma-mapping.h
@@ -23,9 +23,6 @@ extern void machvec_dma_sync_single(stru
 extern void machvec_dma_sync_sg(struct device *, struct scatterlist *, int,
 				enum dma_data_direction);
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
 #define get_dma_ops(dev) platform_dma_get_ops(dev)
 
 #include <asm-generic/dma-mapping-common.h>
diff -puN arch/microblaze/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/microblaze/include/asm/dma-mapping.h
--- a/arch/microblaze/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/microblaze/include/asm/dma-mapping.h
@@ -98,9 +98,6 @@ static inline int dma_mapping_error(stru
 	return (dma_addr == DMA_ERROR_CODE);
 }
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		enum dma_data_direction direction)
 {
diff -puN arch/mips/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/mips/include/asm/dma-mapping.h
--- a/arch/mips/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/mips/include/asm/dma-mapping.h
@@ -64,10 +64,4 @@ dma_set_mask(struct device *dev, u64 mas
 extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction);
 
-void *dma_alloc_noncoherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t flag);
-
-void dma_free_noncoherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle);
-
 #endif /* _ASM_DMA_MAPPING_H */
diff -puN arch/mips/mm/dma-default.c~dma-mapping-consolidate-dma_allocfree_noncoherent arch/mips/mm/dma-default.c
--- a/arch/mips/mm/dma-default.c~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/mips/mm/dma-default.c
@@ -112,7 +112,7 @@ static gfp_t massage_gfp_flags(const str
 	return gfp | dma_flag;
 }
 
-void *dma_alloc_noncoherent(struct device *dev, size_t size,
+static void *mips_dma_alloc_noncoherent(struct device *dev, size_t size,
 	dma_addr_t * dma_handle, gfp_t gfp)
 {
 	void *ret;
@@ -128,7 +128,6 @@ void *dma_alloc_noncoherent(struct devic
 
 	return ret;
 }
-EXPORT_SYMBOL(dma_alloc_noncoherent);
 
 static void *mips_dma_alloc_coherent(struct device *dev, size_t size,
 	dma_addr_t * dma_handle, gfp_t gfp, struct dma_attrs *attrs)
@@ -137,6 +136,13 @@ static void *mips_dma_alloc_coherent(str
 	struct page *page = NULL;
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
+	/*
+	 * XXX: seems like the coherent and non-coherent implementations could
+	 * be consolidated.
+	 */
+	if (dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs))
+		return mips_dma_alloc_noncoherent(dev, size, dma_handle, gfp);
+
 	gfp = massage_gfp_flags(dev, gfp);
 
 	if (IS_ENABLED(CONFIG_DMA_CMA) && !(gfp & GFP_ATOMIC))
@@ -161,13 +167,12 @@ static void *mips_dma_alloc_coherent(str
 }
 
 
-void dma_free_noncoherent(struct device *dev, size_t size, void *vaddr,
-	dma_addr_t dma_handle)
+static void mips_dma_free_noncoherent(struct device *dev, size_t size,
+		void *vaddr, dma_addr_t dma_handle)
 {
 	plat_unmap_dma_mem(dev, dma_handle, size, DMA_BIDIRECTIONAL);
 	free_pages((unsigned long) vaddr, get_order(size));
 }
-EXPORT_SYMBOL(dma_free_noncoherent);
 
 static void mips_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 	dma_addr_t dma_handle, struct dma_attrs *attrs)
@@ -176,6 +181,11 @@ static void mips_dma_free_coherent(struc
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	struct page *page = NULL;
 
+	if (dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs)) {
+		mips_dma_free_noncoherent(dev, size, vaddr, dma_handle);
+		return;
+	}
+
 	plat_unmap_dma_mem(dev, dma_handle, size, DMA_BIDIRECTIONAL);
 
 	if (!plat_device_is_coherent(dev) && !hw_coherentio)
diff -puN arch/openrisc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/openrisc/include/asm/dma-mapping.h
--- a/arch/openrisc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/openrisc/include/asm/dma-mapping.h
@@ -37,26 +37,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
-					  dma_addr_t *dma_handle, gfp_t gfp)
-{
-	struct dma_attrs attrs;
-
-	dma_set_attr(DMA_ATTR_NON_CONSISTENT, &attrs);
-
-	return dma_alloc_attrs(dev, size, dma_handle, gfp, &attrs);
-}
-
-static inline void dma_free_noncoherent(struct device *dev, size_t size,
-					 void *cpu_addr, dma_addr_t dma_handle)
-{
-	struct dma_attrs attrs;
-
-	dma_set_attr(DMA_ATTR_NON_CONSISTENT, &attrs);
-
-	dma_free_attrs(dev, size, cpu_addr, dma_handle, &attrs);
-}
-
 static inline int dma_supported(struct device *dev, u64 dma_mask)
 {
 	/* Support 32 bit DMA mask exclusively */
diff -puN arch/powerpc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/powerpc/include/asm/dma-mapping.h
--- a/arch/powerpc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/powerpc/include/asm/dma-mapping.h
@@ -177,9 +177,6 @@ static inline phys_addr_t dma_to_phys(st
 	return daddr - get_dma_offset(dev);
 }
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
 #define ARCH_HAS_DMA_MMAP_COHERENT
 
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
diff -puN arch/s390/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/s390/include/asm/dma-mapping.h
--- a/arch/s390/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/s390/include/asm/dma-mapping.h
@@ -25,9 +25,6 @@ static inline void dma_cache_sync(struct
 {
 }
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
 #include <asm-generic/dma-mapping-common.h>
 
 static inline int dma_supported(struct device *dev, u64 mask)
diff -puN arch/sh/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/sh/include/asm/dma-mapping.h
--- a/arch/sh/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/sh/include/asm/dma-mapping.h
@@ -38,9 +38,6 @@ static inline int dma_set_mask(struct de
 void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		    enum dma_data_direction dir);
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
diff -puN arch/sparc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/sparc/include/asm/dma-mapping.h
--- a/arch/sparc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/sparc/include/asm/dma-mapping.h
@@ -9,9 +9,6 @@
 
 int dma_supported(struct device *dev, u64 mask);
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 				  enum dma_data_direction dir)
 {
diff -puN arch/tile/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/tile/include/asm/dma-mapping.h
--- a/arch/tile/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/tile/include/asm/dma-mapping.h
@@ -116,9 +116,6 @@ dma_set_mask(struct device *dev, u64 mas
 	return 0;
 }
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
-#define dma_free_noncoherent(d, s, v, h) dma_free_attrs(d, s, v, h, NULL)
-
 /*
  * dma_alloc_noncoherent() is #defined to return coherent memory,
  * so there's no need to do any flushing here.
diff -puN arch/unicore32/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/unicore32/include/asm/dma-mapping.h
--- a/arch/unicore32/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/unicore32/include/asm/dma-mapping.h
@@ -80,9 +80,6 @@ static inline int dma_set_mask(struct de
 	return 0;
 }
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
 static inline void dma_cache_sync(struct device *dev, void *vaddr,
 		size_t size, enum dma_data_direction direction)
 {
diff -puN arch/x86/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -56,9 +56,6 @@ static inline int dma_mapping_error(stru
 	return (dma_addr == DMA_ERROR_CODE);
 }
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
 extern int dma_supported(struct device *hwdev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 mask);
 
diff -puN arch/xtensa/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent arch/xtensa/include/asm/dma-mapping.h
--- a/arch/xtensa/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/arch/xtensa/include/asm/dma-mapping.h
@@ -32,9 +32,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
-#define dma_free_noncoherent(d, s, v, h) dma_free_attrs(d, s, v, h, NULL)
-
 static inline int
 dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
diff -puN include/asm-generic/dma-mapping-common.h~dma-mapping-consolidate-dma_allocfree_noncoherent include/asm-generic/dma-mapping-common.h
--- a/include/asm-generic/dma-mapping-common.h~dma-mapping-consolidate-dma_allocfree_noncoherent
+++ a/include/asm-generic/dma-mapping-common.h
@@ -295,4 +295,22 @@ static inline void dma_free_coherent(str
 	return dma_free_attrs(dev, size, cpu_addr, dma_handle, NULL);
 }
 
+static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, gfp_t gfp)
+{
+	DEFINE_DMA_ATTRS(attrs);
+
+	dma_set_attr(DMA_ATTR_NON_CONSISTENT, &attrs);
+	return dma_alloc_attrs(dev, size, dma_handle, gfp, &attrs);
+}
+
+static inline void dma_free_noncoherent(struct device *dev, size_t size,
+		void *cpu_addr, dma_addr_t dma_handle)
+{
+	DEFINE_DMA_ATTRS(attrs);
+
+	dma_set_attr(DMA_ATTR_NON_CONSISTENT, &attrs);
+	dma_free_attrs(dev, size, cpu_addr, dma_handle, &attrs);
+}
+
 #endif
_

Patches currently in -mm which might be from hch@lst.de are


