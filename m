From: akpm@linux-foundation.org
Subject: + slab-allocators-define-common-size-limitations.patch added to -mm tree
Date: Tue, 15 May 2007 23:32:46 -0700
Message-ID: <200705160632.l4G6Wk0u027935@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49138 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757714AbXEPGeO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 02:34:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Slab allocators: define common size limitations
has been added to the -mm tree.  Its filename is
     slab-allocators-define-common-size-limitations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Slab allocators: define common size limitations
From: Christoph Lameter <clameter@sgi.com>

Currently we have a maze of configuration variables that determine the
maximum slab size.  Worst of all it seems to vary between SLAB and SLUB.

So define a common maximum size for kmalloc.  For conveniences sake we use
the maximum size ever supported which is 32 MB.  We limit the maximum size
to a lower limit if MAX_ORDER does not allow such large allocations.

For many architectures this patch will have the effect of adding large
kmalloc sizes.  x86_64 adds 5 new kmalloc sizes.  So a small amount of
memory will be needed for these caches (contemporary SLAB has dynamically
sizeable node and cpu structure so the waste is less than in the past)

Most architectures will then be able to allocate object with sizes up to
MAX_ORDER.  We have had repeated breakage (in fact whenever we doubled the
number of supported processors) on IA64 because one or the other struct
grew beyond what the slab allocators supported.  This will avoid future
issues and f.e.  avoid fixes for 2k and 4k cpu support.

CONFIG_LARGE_ALLOCS is no longer necessary so drop it.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/Kconfig         |    8 --------
 arch/frv/Kconfig              |    8 --------
 arch/m68knommu/Kconfig        |    8 --------
 arch/v850/Kconfig             |    8 --------
 include/linux/kmalloc_sizes.h |   20 +++++++++++++++-----
 include/linux/slab.h          |   15 +++++++++++++++
 include/linux/slub_def.h      |   19 ++-----------------
 mm/slab.c                     |   19 ++-----------------
 8 files changed, 34 insertions(+), 71 deletions(-)

diff -puN arch/blackfin/Kconfig~slab-allocators-define-common-size-limitations arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~slab-allocators-define-common-size-limitations
+++ a/arch/blackfin/Kconfig
@@ -560,14 +560,6 @@ endchoice
 
 source "mm/Kconfig"
 
-config LARGE_ALLOCS
-	bool "Allow allocating large blocks (> 1MB) of memory"
-	help
-	  Allow the slab memory allocator to keep chains for very large
-	  memory sizes - upto 32MB. You may need this if your system has
-	  a lot of RAM, and you need to able to allocate very large
-	  contiguous chunks. If unsure, say N.
-
 config BFIN_DMA_5XX
 	bool "Enable DMA Support"
 	depends on (BF533 || BF532 || BF531 || BF537 || BF536 || BF534 || BF561)
diff -puN arch/frv/Kconfig~slab-allocators-define-common-size-limitations arch/frv/Kconfig
--- a/arch/frv/Kconfig~slab-allocators-define-common-size-limitations
+++ a/arch/frv/Kconfig
@@ -102,14 +102,6 @@ config HIGHPTE
 	  with a lot of RAM, this can be wasteful of precious low memory.
 	  Setting this option will put user-space page tables in high memory.
 
-config LARGE_ALLOCS
-	bool "Allow allocating large blocks (> 1MB) of memory"
-	help
-	  Allow the slab memory allocator to keep chains for very large memory
-	  sizes - up to 32MB. You may need this if your system has a lot of
-	  RAM, and you need to able to allocate very large contiguous chunks.
-	  If unsure, say N.
-
 source "mm/Kconfig"
 
 choice
diff -puN arch/m68knommu/Kconfig~slab-allocators-define-common-size-limitations arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~slab-allocators-define-common-size-limitations
+++ a/arch/m68knommu/Kconfig
@@ -470,14 +470,6 @@ config AVNET
 	default y
 	depends on (AVNET5282)
 
-config LARGE_ALLOCS
-	bool "Allow allocating large blocks (> 1MB) of memory"
-	help
-	  Allow the slab memory allocator to keep chains for very large
-	  memory sizes - upto 32MB. You may need this if your system has
-	  a lot of RAM, and you need to able to allocate very large
-	  contiguous chunks. If unsure, say N.
-
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	default y
diff -puN arch/v850/Kconfig~slab-allocators-define-common-size-limitations arch/v850/Kconfig
--- a/arch/v850/Kconfig~slab-allocators-define-common-size-limitations
+++ a/arch/v850/Kconfig
@@ -240,14 +240,6 @@ menu "Processor type and features"
    config RESET_GUARD
    	  bool "Reset Guard"
 
-   config LARGE_ALLOCS
-	  bool "Allow allocating large blocks (> 1MB) of memory"
-	  help
-	     Allow the slab memory allocator to keep chains for very large
-	     memory sizes - upto 32MB. You may need this if your system has
-	     a lot of RAM, and you need to able to allocate very large
-	     contiguous chunks. If unsure, say N.
-
 source "mm/Kconfig"
 
 endmenu
diff -puN include/linux/kmalloc_sizes.h~slab-allocators-define-common-size-limitations include/linux/kmalloc_sizes.h
--- a/include/linux/kmalloc_sizes.h~slab-allocators-define-common-size-limitations
+++ a/include/linux/kmalloc_sizes.h
@@ -19,17 +19,27 @@
 	CACHE(32768)
 	CACHE(65536)
 	CACHE(131072)
-#if (NR_CPUS > 512) || (MAX_NUMNODES > 256) || !defined(CONFIG_MMU)
+#if KMALLOC_MAX_SIZE >= 262144
 	CACHE(262144)
 #endif
-#ifndef CONFIG_MMU
+#if KMALLOC_MAX_SIZE >= 524288
 	CACHE(524288)
+#endif
+#if KMALLOC_MAX_SIZE >= 1048576
 	CACHE(1048576)
-#ifdef CONFIG_LARGE_ALLOCS
+#endif
+#if KMALLOC_MAX_SIZE >= 2097152
 	CACHE(2097152)
+#endif
+#if KMALLOC_MAX_SIZE >= 4194304
 	CACHE(4194304)
+#endif
+#if KMALLOC_MAX_SIZE >= 8388608
 	CACHE(8388608)
+#endif
+#if KMALLOC_MAX_SIZE >= 16777216
 	CACHE(16777216)
+#endif
+#if KMALLOC_MAX_SIZE >= 33554432
 	CACHE(33554432)
-#endif /* CONFIG_LARGE_ALLOCS */
-#endif /* CONFIG_MMU */
+#endif
diff -puN include/linux/slab.h~slab-allocators-define-common-size-limitations include/linux/slab.h
--- a/include/linux/slab.h~slab-allocators-define-common-size-limitations
+++ a/include/linux/slab.h
@@ -74,6 +74,21 @@ static inline void *kmem_cache_alloc_nod
 #endif
 
 /*
+ * The largest kmalloc size supported by the slab allocators is
+ * 32 megabyte (2^25) or the maximum allocatable page order if that is
+ * less than 32 MB.
+ *
+ * WARNING: Its not easy to increase this value since the allocators have
+ * to do various tricks to work around compiler limitations in order to
+ * ensure proper constant folding.
+ */
+#define KMALLOC_SHIFT_HIGH	((MAX_ORDER + PAGE_SHIFT) <= 25 ? \
+				(MAX_ORDER + PAGE_SHIFT) : 25)
+
+#define KMALLOC_MAX_SIZE	(1UL << KMALLOC_SHIFT_HIGH)
+#define KMALLOC_MAX_ORDER	(KMALLOC_SHIFT_HIGH - PAGE_SHIFT)
+
+/*
  * Common kmalloc functions provided by all allocators
  */
 void *__kmalloc(size_t, gfp_t);
diff -puN include/linux/slub_def.h~slab-allocators-define-common-size-limitations include/linux/slub_def.h
--- a/include/linux/slub_def.h~slab-allocators-define-common-size-limitations
+++ a/include/linux/slub_def.h
@@ -58,17 +58,6 @@ struct kmem_cache {
  */
 #define KMALLOC_SHIFT_LOW 3
 
-#ifdef CONFIG_LARGE_ALLOCS
-#define KMALLOC_SHIFT_HIGH ((MAX_ORDER + PAGE_SHIFT) =< 25 ? \
-				(MAX_ORDER + PAGE_SHIFT - 1) : 25)
-#else
-#if !defined(CONFIG_MMU) || NR_CPUS > 512 || MAX_NUMNODES > 256
-#define KMALLOC_SHIFT_HIGH 20
-#else
-#define KMALLOC_SHIFT_HIGH 18
-#endif
-#endif
-
 /*
  * We keep the general caches in an array of slab caches that are used for
  * 2^x bytes of allocations.
@@ -79,7 +68,7 @@ extern struct kmem_cache kmalloc_caches[
  * Sorry that the following has to be that ugly but some versions of GCC
  * have trouble with constant propagation and loops.
  */
-static inline int kmalloc_index(int size)
+static inline int kmalloc_index(size_t size)
 {
 	/*
 	 * We should return 0 if size == 0 but we use the smallest object
@@ -87,7 +76,7 @@ static inline int kmalloc_index(int size
 	 */
 	WARN_ON_ONCE(size == 0);
 
-	if (size > (1 << KMALLOC_SHIFT_HIGH))
+	if (size > KMALLOC_MAX_SIZE)
 		return -1;
 
 	if (size > 64 && size <= 96)
@@ -110,17 +99,13 @@ static inline int kmalloc_index(int size
 	if (size <=  64 * 1024) return 16;
 	if (size <= 128 * 1024) return 17;
 	if (size <= 256 * 1024) return 18;
-#if KMALLOC_SHIFT_HIGH > 18
 	if (size <=  512 * 1024) return 19;
 	if (size <= 1024 * 1024) return 20;
-#endif
-#if KMALLOC_SHIFT_HIGH > 20
 	if (size <=  2 * 1024 * 1024) return 21;
 	if (size <=  4 * 1024 * 1024) return 22;
 	if (size <=  8 * 1024 * 1024) return 23;
 	if (size <= 16 * 1024 * 1024) return 24;
 	if (size <= 32 * 1024 * 1024) return 25;
-#endif
 	return -1;
 
 /*
diff -puN mm/slab.c~slab-allocators-define-common-size-limitations mm/slab.c
--- a/mm/slab.c~slab-allocators-define-common-size-limitations
+++ a/mm/slab.c
@@ -569,21 +569,6 @@ static void **dbg_userword(struct kmem_c
 #endif
 
 /*
- * Maximum size of an obj (in 2^order pages) and absolute limit for the gfp
- * order.
- */
-#if defined(CONFIG_LARGE_ALLOCS)
-#define	MAX_OBJ_ORDER	13	/* up to 32Mb */
-#define	MAX_GFP_ORDER	13	/* up to 32Mb */
-#elif defined(CONFIG_MMU)
-#define	MAX_OBJ_ORDER	5	/* 32 pages */
-#define	MAX_GFP_ORDER	5	/* 32 pages */
-#else
-#define	MAX_OBJ_ORDER	8	/* up to 1Mb */
-#define	MAX_GFP_ORDER	8	/* up to 1Mb */
-#endif
-
-/*
  * Do not go above this order unless 0 objects fit into the slab.
  */
 #define	BREAK_GFP_ORDER_HI	1
@@ -2002,7 +1987,7 @@ static size_t calculate_slab_order(struc
 	size_t left_over = 0;
 	int gfporder;
 
-	for (gfporder = 0; gfporder <= MAX_GFP_ORDER; gfporder++) {
+	for (gfporder = 0; gfporder <= KMALLOC_MAX_ORDER; gfporder++) {
 		unsigned int num;
 		size_t remainder;
 
@@ -2148,7 +2133,7 @@ kmem_cache_create (const char *name, siz
 	 * Sanity checks... these are all serious usage bugs.
 	 */
 	if (!name || in_interrupt() || (size < BYTES_PER_WORD) ||
-	    (size > (1 << MAX_OBJ_ORDER) * PAGE_SIZE) || dtor) {
+	    size > KMALLOC_MAX_SIZE || dtor) {
 		printk(KERN_ERR "%s: Early error in slab %s\n", __FUNCTION__,
 				name);
 		BUG();
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-it-is-legit-to-allocate-a-slab-of-the-maximum-permitted-size.patch
slub-dont-confuse-ctor-and-dtor.patch
fix-find_or_create_page-skips-cpuset-memory-spreading.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
slab-allocators-drop-support-for-destructors.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch
slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
slab-warn-on-zero-length-allocations.patch
i386-dont-check_pgt_cache-in-flush_tlb_mm.patch
slub-fix-handling-of-oversized-slabs.patch
fix-page-allocation-flags-in-grow_dev_page.patch
slub-slabinfo-fixes.patch
slub-do-our-own-flags-based-on-pg_active-and-pg_error.patch
slub-simplify-debug-code.patch
slab-allocators-define-common-size-limitations.patch
compat_core_sys_select-avoid-kmalloc0.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
