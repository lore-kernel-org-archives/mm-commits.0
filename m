From: akpm@linux-foundation.org
Subject: + dma-mapping-cosolidate-dma_mapping_error.patch added to -mm
 tree
Date: Mon, 17 Aug 2015 14:25:36 -0700
Message-ID: <55d25150.APekbcR/xB2LVlwR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbbHQVZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 17:25:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, arnd@arndb.de, benh@kernel.crashing.org, catalin.marinas@arm.com, cmetcalf@ezchip.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, jonas@southpole.se, linux@arm.linux.org.uk, mingo@elte.hu, monstr@monstr.eu, ralf@linux-mips.org, tglx@linutronix.de, will.deacon@arm.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: cosolidate dma_mapping_error
has been added to the -mm tree.  Its filename is
     dma-mapping-cosolidate-dma_mapping_error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-cosolidate-dma_mapping_error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-cosolidate-dma_mapping_error.patch

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
Subject: dma-mapping: cosolidate dma_mapping_error

Currently there are three valid implementations of dma_mapping_error:

 (1) call ->mapping_error
 (2) check for a hardcoded error code
 (3) always return 0

This patch provides a common implementation that calls ->mapping_error
if present, then checks for DMA_ERROR_CODE if defined or otherwise
returns 0.

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
 arch/arm/include/asm/dma-mapping.h        |    9 ---------
 arch/arm64/include/asm/dma-mapping.h      |    7 -------
 arch/h8300/include/asm/dma-mapping.h      |    5 -----
 arch/hexagon/include/asm/dma-mapping.h    |   11 +----------
 arch/ia64/include/asm/dma-mapping.h       |    7 -------
 arch/microblaze/include/asm/dma-mapping.h |   11 -----------
 arch/mips/include/asm/dma-mapping.h       |    8 --------
 arch/openrisc/include/asm/dma-mapping.h   |    5 -----
 arch/powerpc/include/asm/dma-mapping.h    |   17 ++---------------
 arch/s390/include/asm/dma-mapping.h       |   10 ----------
 arch/sh/include/asm/dma-mapping.h         |   13 ++-----------
 arch/sparc/include/asm/dma-mapping.h      |    6 ------
 arch/tile/include/asm/dma-mapping.h       |    7 -------
 arch/unicore32/include/asm/dma-mapping.h  |   10 ----------
 arch/x86/include/asm/dma-mapping.h        |   11 -----------
 include/asm-generic/dma-mapping-common.h  |   14 ++++++++++++++
 17 files changed, 19 insertions(+), 137 deletions(-)

diff -puN arch/alpha/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/alpha/include/asm/dma-mapping.h
--- a/arch/alpha/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/alpha/include/asm/dma-mapping.h
@@ -12,11 +12,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return get_dma_ops(dev)->mapping_error(dev, dma_addr);
-}
-
 static inline int dma_supported(struct device *dev, u64 mask)
 {
 	return get_dma_ops(dev)->dma_supported(dev, mask);
diff -puN arch/arm/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/arm/include/asm/dma-mapping.h
--- a/arch/arm/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/arm/include/asm/dma-mapping.h
@@ -172,15 +172,6 @@ static inline bool dma_capable(struct de
 
 static inline void dma_mark_clean(void *addr, size_t size) { }
 
-/*
- * DMA errors are defined by all-bits-set in the DMA address.
- */
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	debug_dma_mapping_error(dev, dma_addr);
-	return dma_addr == DMA_ERROR_CODE;
-}
-
 extern int dma_supported(struct device *dev, u64 mask);
 
 extern int arm_dma_set_mask(struct device *dev, u64 dma_mask);
diff -puN arch/arm64/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/arm64/include/asm/dma-mapping.h
--- a/arch/arm64/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/arm64/include/asm/dma-mapping.h
@@ -84,13 +84,6 @@ static inline phys_addr_t dma_to_phys(st
 	return (phys_addr_t)dev_addr;
 }
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dev_addr)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	debug_dma_mapping_error(dev, dev_addr);
-	return ops->mapping_error(dev, dev_addr);
-}
-
 static inline int dma_supported(struct device *dev, u64 mask)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
diff -puN arch/h8300/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/h8300/include/asm/dma-mapping.h
--- a/arch/h8300/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/h8300/include/asm/dma-mapping.h
@@ -20,9 +20,4 @@ static inline int dma_set_mask(struct de
 	return 0;
 }
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
 #endif
diff -puN arch/hexagon/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/hexagon/include/asm/dma-mapping.h
--- a/arch/hexagon/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/hexagon/include/asm/dma-mapping.h
@@ -31,6 +31,7 @@
 
 struct device;
 extern int bad_dma_address;
+#define DMA_ERROR_CODE bad_dma_address
 
 extern struct dma_map_ops *dma_ops;
 
@@ -57,14 +58,4 @@ static inline bool dma_capable(struct de
 	return addr + size - 1 <= *dev->dma_mask;
 }
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-
-	if (dma_ops->mapping_error)
-		return dma_ops->mapping_error(dev, dma_addr);
-
-	return (dma_addr == bad_dma_address);
-}
-
 #endif
diff -puN arch/ia64/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/ia64/include/asm/dma-mapping.h
--- a/arch/ia64/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/ia64/include/asm/dma-mapping.h
@@ -27,13 +27,6 @@ extern void machvec_dma_sync_sg(struct d
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t daddr)
-{
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	debug_dma_mapping_error(dev, daddr);
-	return ops->mapping_error(dev, daddr);
-}
-
 static inline int dma_supported(struct device *dev, u64 mask)
 {
 	struct dma_map_ops *ops = platform_dma_get_ops(dev);
diff -puN arch/microblaze/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/microblaze/include/asm/dma-mapping.h
--- a/arch/microblaze/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/microblaze/include/asm/dma-mapping.h
@@ -87,17 +87,6 @@ static inline void __dma_sync(unsigned l
 	}
 }
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	debug_dma_mapping_error(dev, dma_addr);
-	if (ops->mapping_error)
-		return ops->mapping_error(dev, dma_addr);
-
-	return (dma_addr == DMA_ERROR_CODE);
-}
-
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		enum dma_data_direction direction)
 {
diff -puN arch/mips/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/mips/include/asm/dma-mapping.h
--- a/arch/mips/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/mips/include/asm/dma-mapping.h
@@ -37,14 +37,6 @@ static inline int dma_supported(struct d
 	return ops->dma_supported(dev, mask);
 }
 
-static inline int dma_mapping_error(struct device *dev, u64 mask)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	debug_dma_mapping_error(dev, mask);
-	return ops->mapping_error(dev, mask);
-}
-
 static inline int
 dma_set_mask(struct device *dev, u64 mask)
 {
diff -puN arch/openrisc/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/openrisc/include/asm/dma-mapping.h
--- a/arch/openrisc/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/openrisc/include/asm/dma-mapping.h
@@ -43,11 +43,6 @@ static inline int dma_supported(struct d
 	return dma_mask == DMA_BIT_MASK(32);
 }
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
 static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
diff -puN arch/powerpc/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/powerpc/include/asm/dma-mapping.h
--- a/arch/powerpc/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/powerpc/include/asm/dma-mapping.h
@@ -18,7 +18,9 @@
 #include <asm/io.h>
 #include <asm/swiotlb.h>
 
+#ifdef CONFIG_PPC64
 #define DMA_ERROR_CODE		(~(dma_addr_t)0x0)
+#endif
 
 /* Some dma direct funcs must be visible for use in other dma_ops */
 extern void *__dma_direct_alloc_coherent(struct device *dev, size_t size,
@@ -137,21 +139,6 @@ extern int dma_set_mask(struct device *d
 extern int __dma_set_mask(struct device *dev, u64 dma_mask);
 extern u64 __dma_get_required_mask(struct device *dev);
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-
-	debug_dma_mapping_error(dev, dma_addr);
-	if (dma_ops->mapping_error)
-		return dma_ops->mapping_error(dev, dma_addr);
-
-#ifdef CONFIG_PPC64
-	return (dma_addr == DMA_ERROR_CODE);
-#else
-	return 0;
-#endif
-}
-
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
 #ifdef CONFIG_SWIOTLB
diff -puN arch/s390/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/s390/include/asm/dma-mapping.h
--- a/arch/s390/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/s390/include/asm/dma-mapping.h
@@ -43,14 +43,4 @@ static inline bool dma_capable(struct de
 	return addr + size - 1 <= *dev->dma_mask;
 }
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-
-	debug_dma_mapping_error(dev, dma_addr);
-	if (dma_ops->mapping_error)
-		return dma_ops->mapping_error(dev, dma_addr);
-	return dma_addr == DMA_ERROR_CODE;
-}
-
 #endif /* _ASM_S390_DMA_MAPPING_H */
diff -puN arch/sh/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/sh/include/asm/dma-mapping.h
--- a/arch/sh/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/sh/include/asm/dma-mapping.h
@@ -9,6 +9,8 @@ static inline struct dma_map_ops *get_dm
 	return dma_ops;
 }
 
+#define DMA_ERROR_CODE 0
+
 #include <asm-generic/dma-mapping-common.h>
 
 static inline int dma_supported(struct device *dev, u64 mask)
@@ -38,17 +40,6 @@ static inline int dma_set_mask(struct de
 void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		    enum dma_data_direction dir);
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	debug_dma_mapping_error(dev, dma_addr);
-	if (ops->mapping_error)
-		return ops->mapping_error(dev, dma_addr);
-
-	return dma_addr == 0;
-}
-
 /* arch/sh/mm/consistent.c */
 extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_addr, gfp_t flag,
diff -puN arch/sparc/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/sparc/include/asm/dma-mapping.h
--- a/arch/sparc/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/sparc/include/asm/dma-mapping.h
@@ -38,12 +38,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	debug_dma_mapping_error(dev, dma_addr);
-	return (dma_addr == DMA_ERROR_CODE);
-}
-
 static inline int dma_set_mask(struct device *dev, u64 mask)
 {
 #ifdef CONFIG_PCI
diff -puN arch/tile/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/tile/include/asm/dma-mapping.h
--- a/arch/tile/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/tile/include/asm/dma-mapping.h
@@ -75,13 +75,6 @@ static inline bool dma_capable(struct de
 }
 
 static inline int
-dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	debug_dma_mapping_error(dev, dma_addr);
-	return get_dma_ops(dev)->mapping_error(dev, dma_addr);
-}
-
-static inline int
 dma_supported(struct device *dev, u64 mask)
 {
 	return get_dma_ops(dev)->dma_supported(dev, mask);
diff -puN arch/unicore32/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/unicore32/include/asm/dma-mapping.h
--- a/arch/unicore32/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/unicore32/include/asm/dma-mapping.h
@@ -38,16 +38,6 @@ static inline int dma_supported(struct d
 	return dma_ops->dma_supported(dev, mask);
 }
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-
-	if (dma_ops->mapping_error)
-		return dma_ops->mapping_error(dev, dma_addr);
-
-	return 0;
-}
-
 #include <asm-generic/dma-mapping-common.h>
 
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
diff -puN arch/x86/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -45,17 +45,6 @@ bool arch_dma_alloc_attrs(struct device
 
 #include <asm-generic/dma-mapping-common.h>
 
-/* Make sure we keep the same behaviour */
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	debug_dma_mapping_error(dev, dma_addr);
-	if (ops->mapping_error)
-		return ops->mapping_error(dev, dma_addr);
-
-	return (dma_addr == DMA_ERROR_CODE);
-}
-
 extern int dma_supported(struct device *hwdev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 mask);
 
diff -puN include/asm-generic/dma-mapping-common.h~dma-mapping-cosolidate-dma_mapping_error include/asm-generic/dma-mapping-common.h
--- a/include/asm-generic/dma-mapping-common.h~dma-mapping-cosolidate-dma_mapping_error
+++ a/include/asm-generic/dma-mapping-common.h
@@ -313,4 +313,18 @@ static inline void dma_free_noncoherent(
 	dma_free_attrs(dev, size, cpu_addr, dma_handle, &attrs);
 }
 
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	debug_dma_mapping_error(dev, dma_addr);
+
+	if (get_dma_ops(dev)->mapping_error)
+		return get_dma_ops(dev)->mapping_error(dev, dma_addr);
+
+#ifdef DMA_ERROR_CODE
+	return dma_addr == DMA_ERROR_CODE;
+#else
+	return 0;
+#endif
+}
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

