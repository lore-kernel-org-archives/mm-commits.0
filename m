From: akpm@linux-foundation.org
Subject: + dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign.patch added to -mm tree
Date: Thu, 08 Jul 2010 12:53:29 -0700
Message-ID: <201007081953.o68JrUpl025247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757138Ab0GHTyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 15:54:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-arch@vger.kernel.org


The patch titled
     dma-mapping: rename ARCH_KMALLOC_MINALIGN to ARCH_DMA_MINALIGN
has been added to the -mm tree.  Its filename is
     dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign.patch

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
Subject: dma-mapping: rename ARCH_KMALLOC_MINALIGN to ARCH_DMA_MINALIGN
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Now each architecture has the own dma_get_cache_alignment implementation.

dma_get_cache_alignment returns the minimum DMA alignment.  Architectures
define it as ARCH_KMALLOC_MINALIGN (it's used to make sure that malloc'ed
buffer is DMA-safe; the buffer doesn't share a cache with the others).  So
we can unify dma_get_cache_alignment implementations.


This patch:

dma_get_cache_alignment() needs to know if an architecture defines
ARCH_KMALLOC_MINALIGN or not (needs to know if architecture has DMA
alignment restriction).  However, slab.h define ARCH_KMALLOC_MINALIGN if
architectures doesn't define it.

Let's rename ARCH_KMALLOC_MINALIGN to ARCH_DMA_MINALIGN. 
ARCH_KMALLOC_MINALIGN is used only in the internals of slab/slob/slub
(except for crypto).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/cache.h                 |    2 +-
 arch/avr32/include/asm/cache.h               |    2 +-
 arch/blackfin/include/asm/cache.h            |    2 +-
 arch/frv/include/asm/mem-layout.h            |    2 +-
 arch/m68k/include/asm/cache.h                |    2 +-
 arch/microblaze/include/asm/page.h           |    2 +-
 arch/mips/include/asm/mach-generic/kmalloc.h |    2 +-
 arch/mips/include/asm/mach-ip27/kmalloc.h    |    2 +-
 arch/mips/include/asm/mach-ip32/kmalloc.h    |    4 ++--
 arch/mips/include/asm/mach-tx49xx/kmalloc.h  |    2 +-
 arch/mn10300/include/asm/cache.h             |    2 +-
 arch/powerpc/include/asm/page_32.h           |    2 +-
 arch/sh/include/asm/page.h                   |    2 +-
 arch/xtensa/include/asm/cache.h              |    2 +-
 include/linux/slab_def.h                     |    4 +++-
 include/linux/slob_def.h                     |    4 +++-
 include/linux/slub_def.h                     |    8 +++++---
 17 files changed, 26 insertions(+), 20 deletions(-)

diff -puN arch/arm/include/asm/cache.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/arm/include/asm/cache.h
--- a/arch/arm/include/asm/cache.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/arm/include/asm/cache.h
@@ -14,7 +14,7 @@
  * cache before the transfer is done, causing old data to be seen by
  * the CPU.
  */
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 /*
  * With EABI on ARMv5 and above we must have 64-bit aligned slab pointers.
diff -puN arch/avr32/include/asm/cache.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/avr32/include/asm/cache.h
--- a/arch/avr32/include/asm/cache.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/avr32/include/asm/cache.h
@@ -11,7 +11,7 @@
  * cache before the transfer is done, causing old data to be seen by
  * the CPU.
  */
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 #ifndef __ASSEMBLER__
 struct cache_info {
diff -puN arch/blackfin/include/asm/cache.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/blackfin/include/asm/cache.h
--- a/arch/blackfin/include/asm/cache.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/blackfin/include/asm/cache.h
@@ -15,7 +15,7 @@
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 #define SMP_CACHE_BYTES	L1_CACHE_BYTES
 
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 #ifdef CONFIG_SMP
 #define __cacheline_aligned
diff -puN arch/frv/include/asm/mem-layout.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/frv/include/asm/mem-layout.h
--- a/arch/frv/include/asm/mem-layout.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/frv/include/asm/mem-layout.h
@@ -35,7 +35,7 @@
  * the slab must be aligned such that load- and store-double instructions don't
  * fault if used
  */
-#define	ARCH_KMALLOC_MINALIGN		L1_CACHE_BYTES
+#define	ARCH_DMA_MINALIGN		L1_CACHE_BYTES
 #define	ARCH_SLAB_MINALIGN		L1_CACHE_BYTES
 
 /*****************************************************************************/
diff -puN arch/m68k/include/asm/cache.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/m68k/include/asm/cache.h
--- a/arch/m68k/include/asm/cache.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/m68k/include/asm/cache.h
@@ -8,6 +8,6 @@
 #define        L1_CACHE_SHIFT  4
 #define        L1_CACHE_BYTES  (1<< L1_CACHE_SHIFT)
 
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 #endif
diff -puN arch/microblaze/include/asm/page.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/microblaze/include/asm/page.h
--- a/arch/microblaze/include/asm/page.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/microblaze/include/asm/page.h
@@ -40,7 +40,7 @@
 #ifndef __ASSEMBLY__
 
 /* MS be sure that SLAB allocates aligned objects */
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 #define ARCH_SLAB_MINALIGN	L1_CACHE_BYTES
 
diff -puN arch/mips/include/asm/mach-generic/kmalloc.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/mips/include/asm/mach-generic/kmalloc.h
--- a/arch/mips/include/asm/mach-generic/kmalloc.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/mips/include/asm/mach-generic/kmalloc.h
@@ -7,7 +7,7 @@
  * Total overkill for most systems but need as a safe default.
  * Set this one if any device in the system might do non-coherent DMA.
  */
-#define ARCH_KMALLOC_MINALIGN	128
+#define ARCH_DMA_MINALIGN	128
 #endif
 
 #endif /* __ASM_MACH_GENERIC_KMALLOC_H */
diff -puN arch/mips/include/asm/mach-ip27/kmalloc.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/mips/include/asm/mach-ip27/kmalloc.h
--- a/arch/mips/include/asm/mach-ip27/kmalloc.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/mips/include/asm/mach-ip27/kmalloc.h
@@ -2,7 +2,7 @@
 #define __ASM_MACH_IP27_KMALLOC_H
 
 /*
- * All happy, no need to define ARCH_KMALLOC_MINALIGN
+ * All happy, no need to define ARCH_DMA_MINALIGN
  */
 
 #endif /* __ASM_MACH_IP27_KMALLOC_H */
diff -puN arch/mips/include/asm/mach-ip32/kmalloc.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/mips/include/asm/mach-ip32/kmalloc.h
--- a/arch/mips/include/asm/mach-ip32/kmalloc.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/mips/include/asm/mach-ip32/kmalloc.h
@@ -3,9 +3,9 @@
 
 
 #if defined(CONFIG_CPU_R5000) || defined(CONFIG_CPU_RM7000)
-#define ARCH_KMALLOC_MINALIGN	32
+#define ARCH_DMA_MINALIGN	32
 #else
-#define ARCH_KMALLOC_MINALIGN	128
+#define ARCH_DMA_MINALIGN	128
 #endif
 
 #endif /* __ASM_MACH_IP32_KMALLOC_H */
diff -puN arch/mips/include/asm/mach-tx49xx/kmalloc.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/mips/include/asm/mach-tx49xx/kmalloc.h
--- a/arch/mips/include/asm/mach-tx49xx/kmalloc.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/mips/include/asm/mach-tx49xx/kmalloc.h
@@ -2,7 +2,7 @@
 #define __ASM_MACH_TX49XX_KMALLOC_H
 
 /*
- * All happy, no need to define ARCH_KMALLOC_MINALIGN
+ * All happy, no need to define ARCH_DMA_MINALIGN
  */
 
 #endif /* __ASM_MACH_TX49XX_KMALLOC_H */
diff -puN arch/mn10300/include/asm/cache.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/mn10300/include/asm/cache.h
--- a/arch/mn10300/include/asm/cache.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/mn10300/include/asm/cache.h
@@ -21,7 +21,7 @@
 #define L1_CACHE_DISPARITY	L1_CACHE_NENTRIES * L1_CACHE_BYTES
 #endif
 
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 /* data cache purge registers
  * - read from the register to unconditionally purge that cache line
diff -puN arch/powerpc/include/asm/page_32.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/powerpc/include/asm/page_32.h
--- a/arch/powerpc/include/asm/page_32.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/powerpc/include/asm/page_32.h
@@ -10,7 +10,7 @@
 #define VM_DATA_DEFAULT_FLAGS	VM_DATA_DEFAULT_FLAGS32
 
 #ifdef CONFIG_NOT_COHERENT_CACHE
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 #endif
 
 #ifdef CONFIG_PTE_64BIT
diff -puN arch/sh/include/asm/page.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/sh/include/asm/page.h
--- a/arch/sh/include/asm/page.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/sh/include/asm/page.h
@@ -180,7 +180,7 @@ typedef struct page *pgtable_t;
  * Some drivers need to perform DMA into kmalloc'ed buffers
  * and so we have to increase the kmalloc minalign for this.
  */
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 #ifdef CONFIG_SUPERH64
 /*
diff -puN arch/xtensa/include/asm/cache.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign arch/xtensa/include/asm/cache.h
--- a/arch/xtensa/include/asm/cache.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/arch/xtensa/include/asm/cache.h
@@ -29,6 +29,6 @@
 # define CACHE_WAY_SIZE ICACHE_WAY_SIZE
 #endif
 
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 #endif	/* _XTENSA_CACHE_H */
diff -puN include/linux/slab_def.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign include/linux/slab_def.h
--- a/include/linux/slab_def.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/include/linux/slab_def.h
@@ -17,7 +17,6 @@
 
 #include <trace/events/kmem.h>
 
-#ifndef ARCH_KMALLOC_MINALIGN
 /*
  * Enforce a minimum alignment for the kmalloc caches.
  * Usually, the kmalloc caches are cache_line_size() aligned, except when
@@ -27,6 +26,9 @@
  * ARCH_KMALLOC_MINALIGN allows that.
  * Note that increasing this value may disable some debug features.
  */
+#ifdef ARCH_DMA_MINALIGN
+#define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
+#else
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
 #endif
 
diff -puN include/linux/slob_def.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign include/linux/slob_def.h
--- a/include/linux/slob_def.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/include/linux/slob_def.h
@@ -1,7 +1,9 @@
 #ifndef __LINUX_SLOB_DEF_H
 #define __LINUX_SLOB_DEF_H
 
-#ifndef ARCH_KMALLOC_MINALIGN
+#ifdef ARCH_DMA_MINALIGN
+#define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
+#else
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
 #endif
 
diff -puN include/linux/slub_def.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign include/linux/slub_def.h
--- a/include/linux/slub_def.h~dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign
+++ a/include/linux/slub_def.h
@@ -106,15 +106,17 @@ struct kmem_cache {
 /*
  * Kmalloc subsystem.
  */
-#if defined(ARCH_KMALLOC_MINALIGN) && ARCH_KMALLOC_MINALIGN > 8
-#define KMALLOC_MIN_SIZE ARCH_KMALLOC_MINALIGN
+#if defined(ARCH_DMA_MINALIGN) && ARCH_DMA_MINALIGN > 8
+#define KMALLOC_MIN_SIZE ARCH_DMA_MINALIGN
 #else
 #define KMALLOC_MIN_SIZE 8
 #endif
 
 #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
 
-#ifndef ARCH_KMALLOC_MINALIGN
+#ifdef ARCH_DMA_MINALIGN
+#define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
+#else
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
 #endif
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign.patch
dma-mapping-unify-dma_get_cache_alignment-implementations.patch
dma-mapping-parisc-set-arch_dma_minalign.patch

