From: akpm@linux-foundation.org
Subject: + dma-mapping-unify-dma_get_cache_alignment-implementations.patch added to -mm tree
Date: Thu, 08 Jul 2010 12:53:32 -0700
Message-ID: <201007081953.o68JrX8w025250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757138Ab0GHTyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 15:54:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-arch@vger.kernel.org


The patch titled
     dma-mapping: unify dma_get_cache_alignment implementations
has been added to the -mm tree.  Its filename is
     dma-mapping-unify-dma_get_cache_alignment-implementations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: unify dma_get_cache_alignment implementations
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma_get_cache_alignment returns the minimum DMA alignment.  Architectures
defines it as ARCH_DMA_MINALIGN (formally ARCH_KMALLOC_MINALIGN).  So we
can unify dma_get_cache_alignment implementations.

Note that some architectures implement dma_get_cache_alignment wrongly. 
dma_get_cache_alignment() should return the minimum DMA alignment.  So
fully-coherent architectures should return 1.  This patch also fixes this
issue.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/dma-mapping.h      |    1 -
 arch/arm/include/asm/dma-mapping.h        |    5 -----
 arch/avr32/include/asm/dma-mapping.h      |    5 -----
 arch/blackfin/include/asm/dma-mapping.h   |    1 -
 arch/cris/include/asm/dma-mapping.h       |    6 ------
 arch/frv/include/asm/dma-mapping.h        |    6 ------
 arch/ia64/include/asm/dma-mapping.h       |    2 --
 arch/ia64/kernel/setup.c                  |    6 ------
 arch/m68k/include/asm/dma-mapping.h       |    5 -----
 arch/microblaze/include/asm/dma-mapping.h |    5 -----
 arch/mips/include/asm/dma-mapping.h       |    7 -------
 arch/mn10300/include/asm/dma-mapping.h    |    6 ------
 arch/parisc/include/asm/dma-mapping.h     |    6 ------
 arch/powerpc/include/asm/dma-mapping.h    |   15 ---------------
 arch/sh/include/asm/dma-mapping.h         |    9 ---------
 arch/sparc/include/asm/dma-mapping.h      |    9 ---------
 arch/tile/include/asm/dma-mapping.h       |    7 -------
 arch/x86/include/asm/dma-mapping.h        |    7 -------
 arch/xtensa/include/asm/dma-mapping.h     |    6 ------
 include/linux/dma-mapping.h               |    8 ++++++++
 20 files changed, 8 insertions(+), 114 deletions(-)

diff -puN arch/alpha/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/alpha/include/asm/dma-mapping.h
--- a/arch/alpha/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/alpha/include/asm/dma-mapping.h
@@ -44,6 +44,5 @@ static inline int dma_set_mask(struct de
 #define dma_is_consistent(d, h)			(1)
 
 #define dma_cache_sync(dev, va, size, dir)		  ((void)0)
-#define dma_get_cache_alignment()			  L1_CACHE_BYTES
 
 #endif	/* _ALPHA_DMA_MAPPING_H */
diff -puN arch/arm/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/arm/include/asm/dma-mapping.h
--- a/arch/arm/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/arm/include/asm/dma-mapping.h
@@ -144,11 +144,6 @@ static inline int dma_set_mask(struct de
 	return 0;
 }
 
-static inline int dma_get_cache_alignment(void)
-{
-	return 32;
-}
-
 static inline int dma_is_consistent(struct device *dev, dma_addr_t handle)
 {
 	return !!arch_is_coherent();
diff -puN arch/avr32/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/avr32/include/asm/dma-mapping.h
--- a/arch/avr32/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/avr32/include/asm/dma-mapping.h
@@ -341,9 +341,4 @@ static inline int dma_is_consistent(stru
 	return 1;
 }
 
-static inline int dma_get_cache_alignment(void)
-{
-	return boot_cpu_data.dcache.linesz;
-}
-
 #endif /* __ASM_AVR32_DMA_MAPPING_H */
diff -puN arch/blackfin/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/blackfin/include/asm/dma-mapping.h
--- a/arch/blackfin/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/blackfin/include/asm/dma-mapping.h
@@ -21,7 +21,6 @@ void dma_free_coherent(struct device *de
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #define dma_supported(d, m)         (1)
-#define dma_get_cache_alignment()   (32)
 #define dma_is_consistent(d, h)     (1)
 
 static inline int
diff -puN arch/cris/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/cris/include/asm/dma-mapping.h
--- a/arch/cris/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/cris/include/asm/dma-mapping.h
@@ -152,12 +152,6 @@ dma_set_mask(struct device *dev, u64 mas
 	return 0;
 }
 
-static inline int
-dma_get_cache_alignment(void)
-{
-	return (1 << INTERNODE_CACHE_SHIFT);
-}
-
 #define dma_is_consistent(d, h)	(1)
 
 static inline void
diff -puN arch/frv/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/frv/include/asm/dma-mapping.h
--- a/arch/frv/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/frv/include/asm/dma-mapping.h
@@ -125,12 +125,6 @@ int dma_set_mask(struct device *dev, u64
 	return 0;
 }
 
-static inline
-int dma_get_cache_alignment(void)
-{
-	return 1 << L1_CACHE_SHIFT;
-}
-
 #define dma_is_consistent(d, h)	(1)
 
 static inline
diff -puN arch/ia64/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/ia64/include/asm/dma-mapping.h
--- a/arch/ia64/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/ia64/include/asm/dma-mapping.h
@@ -86,8 +86,6 @@ static inline phys_addr_t dma_to_phys(st
 	return daddr;
 }
 
-extern int dma_get_cache_alignment(void);
-
 static inline void
 dma_cache_sync (struct device *dev, void *vaddr, size_t size,
 	enum dma_data_direction dir)
diff -puN arch/ia64/kernel/setup.c~dma-mapping-unify-dma_get_cache_alignment-implementations arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/ia64/kernel/setup.c
@@ -98,12 +98,6 @@ static struct resource bss_resource = {
 
 unsigned long ia64_max_cacheline_size;
 
-int dma_get_cache_alignment(void)
-{
-        return ia64_max_cacheline_size;
-}
-EXPORT_SYMBOL(dma_get_cache_alignment);
-
 unsigned long ia64_iobase;	/* virtual address for I/O accesses */
 EXPORT_SYMBOL(ia64_iobase);
 struct io_space io_space[MAX_IO_SPACES];
diff -puN arch/m68k/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/m68k/include/asm/dma-mapping.h
--- a/arch/m68k/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/m68k/include/asm/dma-mapping.h
@@ -16,11 +16,6 @@ static inline int dma_set_mask(struct de
 	return 0;
 }
 
-static inline int dma_get_cache_alignment(void)
-{
-	return 1 << L1_CACHE_SHIFT;
-}
-
 static inline int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
diff -puN arch/microblaze/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/microblaze/include/asm/dma-mapping.h
--- a/arch/microblaze/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/microblaze/include/asm/dma-mapping.h
@@ -138,11 +138,6 @@ static inline void dma_free_coherent(str
 	ops->free_coherent(dev, size, cpu_addr, dma_handle);
 }
 
-static inline int dma_get_cache_alignment(void)
-{
-	return L1_CACHE_BYTES;
-}
-
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		enum dma_data_direction direction)
 {
diff -puN arch/mips/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/mips/include/asm/dma-mapping.h
--- a/arch/mips/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/mips/include/asm/dma-mapping.h
@@ -62,13 +62,6 @@ dma_set_mask(struct device *dev, u64 mas
 	return 0;
 }
 
-static inline int
-dma_get_cache_alignment(void)
-{
-	/* XXX Largest on any MIPS */
-	return 128;
-}
-
 extern int dma_is_consistent(struct device *dev, dma_addr_t dma_addr);
 
 extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
diff -puN arch/mn10300/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/mn10300/include/asm/dma-mapping.h
--- a/arch/mn10300/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/mn10300/include/asm/dma-mapping.h
@@ -161,12 +161,6 @@ int dma_set_mask(struct device *dev, u64
 	return 0;
 }
 
-static inline
-int dma_get_cache_alignment(void)
-{
-	return 1 << L1_CACHE_SHIFT;
-}
-
 #define dma_is_consistent(d)	(1)
 
 static inline
diff -puN arch/parisc/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/parisc/include/asm/dma-mapping.h
--- a/arch/parisc/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/parisc/include/asm/dma-mapping.h
@@ -185,12 +185,6 @@ dma_set_mask(struct device *dev, u64 mas
 }
 
 static inline int
-dma_get_cache_alignment(void)
-{
-	return dcache_stride;
-}
-
-static inline int
 dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
 {
 	return (hppa_dma_ops->dma_sync_single_for_cpu == NULL);
diff -puN arch/powerpc/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/powerpc/include/asm/dma-mapping.h
--- a/arch/powerpc/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/powerpc/include/asm/dma-mapping.h
@@ -215,21 +215,6 @@ static inline phys_addr_t dma_to_phys(st
 #define dma_is_consistent(d, h)	(1)
 #endif
 
-static inline int dma_get_cache_alignment(void)
-{
-#ifdef CONFIG_PPC64
-	/* no easy way to get cache size on all processors, so return
-	 * the maximum possible, to be safe */
-	return (1 << INTERNODE_CACHE_SHIFT);
-#else
-	/*
-	 * Each processor family will define its own L1_CACHE_SHIFT,
-	 * L1_CACHE_BYTES wraps to this, so this is always safe.
-	 */
-	return L1_CACHE_BYTES;
-#endif
-}
-
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		enum dma_data_direction direction)
 {
diff -puN arch/sh/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/sh/include/asm/dma-mapping.h
--- a/arch/sh/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/sh/include/asm/dma-mapping.h
@@ -48,15 +48,6 @@ void dma_cache_sync(struct device *dev, 
 #define dma_is_consistent(d, h) (0)
 #endif
 
-static inline int dma_get_cache_alignment(void)
-{
-	/*
-	 * Each processor family will define its own L1_CACHE_SHIFT,
-	 * L1_CACHE_BYTES wraps to this, so this is always safe.
-	 */
-	return L1_CACHE_BYTES;
-}
-
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
diff -puN arch/sparc/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/sparc/include/asm/dma-mapping.h
--- a/arch/sparc/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/sparc/include/asm/dma-mapping.h
@@ -52,15 +52,6 @@ static inline int dma_mapping_error(stru
 	return (dma_addr == DMA_ERROR_CODE);
 }
 
-static inline int dma_get_cache_alignment(void)
-{
-	/*
-	 * no easy way to get cache size on all processors, so return
-	 * the maximum possible, to be safe
-	 */
-	return (1 << INTERNODE_CACHE_SHIFT);
-}
-
 static inline int dma_set_mask(struct device *dev, u64 mask)
 {
 #ifdef CONFIG_PCI
diff -puN arch/tile/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/tile/include/asm/dma-mapping.h
--- a/arch/tile/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/tile/include/asm/dma-mapping.h
@@ -90,13 +90,6 @@ dma_set_mask(struct device *dev, u64 mas
 	return 0;
 }
 
-static inline int
-dma_get_cache_alignment(void)
-{
-	return L2_CACHE_BYTES;
-}
-
 #define dma_is_consistent(d, h)	(1)
 
-
 #endif /* _ASM_TILE_DMA_MAPPING_H */
diff -puN arch/x86/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -87,13 +87,6 @@ dma_cache_sync(struct device *dev, void 
 	flush_write_buffers();
 }
 
-static inline int dma_get_cache_alignment(void)
-{
-	/* no easy way to get cache size on all x86, so return the
-	 * maximum possible, to be safe */
-	return boot_cpu_data.x86_clflush_size;
-}
-
 static inline unsigned long dma_alloc_coherent_mask(struct device *dev,
 						    gfp_t gfp)
 {
diff -puN arch/xtensa/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations arch/xtensa/include/asm/dma-mapping.h
--- a/arch/xtensa/include/asm/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/arch/xtensa/include/asm/dma-mapping.h
@@ -161,12 +161,6 @@ dma_set_mask(struct device *dev, u64 mas
 	return 0;
 }
 
-static inline int
-dma_get_cache_alignment(void)
-{
-	return L1_CACHE_BYTES;
-}
-
 #define dma_is_consistent(d, h)	(1)
 
 static inline void
diff -puN include/linux/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-unify-dma_get_cache_alignment-implementations
+++ a/include/linux/dma-mapping.h
@@ -142,6 +142,14 @@ static inline int dma_set_seg_boundary(s
 		return -EIO;
 }
 
+static inline int dma_get_cache_alignment(void)
+{
+#ifdef ARCH_DMA_MINALIGN
+	return ARCH_DMA_MINALIGN;
+#endif
+	return 1;
+}
+
 /* flags for the coherent memory api */
 #define	DMA_MEMORY_MAP			0x01
 #define DMA_MEMORY_IO			0x02
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign.patch
dma-mapping-unify-dma_get_cache_alignment-implementations.patch
dma-mapping-parisc-set-arch_dma_minalign.patch

