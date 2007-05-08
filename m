From: akpm@linux-foundation.org
Subject: - slab-allocators-remove-obsolete-slab_must_hwcache_align.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:25 -0700
Message-ID: <200705080003.l4803Pso008949@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967459AbXEHAKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:10:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slab allocators: Remove obsolete SLAB_MUST_HWCACHE_ALIGN
has been removed from the -mm tree.  Its filename was
     slab-allocators-remove-obsolete-slab_must_hwcache_align.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab allocators: Remove obsolete SLAB_MUST_HWCACHE_ALIGN
From: Christoph Lameter <clameter@sgi.com>

This patch was recently posted to lkml and acked by Pekka.

The flag SLAB_MUST_HWCACHE_ALIGN is

1. Never checked by SLAB at all.

2. A duplicate of SLAB_HWCACHE_ALIGN for SLUB

3. Fulfills the role of SLAB_HWCACHE_ALIGN for SLOB.

The only remaining use is in sparc64 and ppc64 and their use there
reflects some earlier role that the slab flag once may have had. If
its specified then SLAB_HWCACHE_ALIGN is also specified.

The flag is confusing, inconsistent and has no purpose.

Remove it.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |    3 +--
 arch/powerpc/mm/init_64.c     |    3 +--
 arch/sparc64/mm/tsb.c         |    3 +--
 include/linux/slab.h          |    1 -
 mm/slab.c                     |    4 ++--
 mm/slob.c                     |    4 ++--
 6 files changed, 7 insertions(+), 11 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~slab-allocators-remove-obsolete-slab_must_hwcache_align arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~slab-allocators-remove-obsolete-slab_must_hwcache_align
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -1057,8 +1057,7 @@ static int __init hugetlbpage_init(void)
 	huge_pgtable_cache = kmem_cache_create("hugepte_cache",
 					       HUGEPTE_TABLE_SIZE,
 					       HUGEPTE_TABLE_SIZE,
-					       SLAB_HWCACHE_ALIGN |
-					       SLAB_MUST_HWCACHE_ALIGN,
+					       SLAB_HWCACHE_ALIGN,
 					       zero_ctor, NULL);
 	if (! huge_pgtable_cache)
 		panic("hugetlbpage_init(): could not create hugepte cache\n");
diff -puN arch/powerpc/mm/init_64.c~slab-allocators-remove-obsolete-slab_must_hwcache_align arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~slab-allocators-remove-obsolete-slab_must_hwcache_align
+++ a/arch/powerpc/mm/init_64.c
@@ -183,8 +183,7 @@ void pgtable_cache_init(void)
 		    "for size: %08x...\n", name, i, size);
 		pgtable_cache[i] = kmem_cache_create(name,
 						     size, size,
-						     SLAB_HWCACHE_ALIGN |
-						     SLAB_MUST_HWCACHE_ALIGN,
+						     SLAB_HWCACHE_ALIGN,
 						     zero_ctor,
 						     NULL);
 		if (! pgtable_cache[i])
diff -puN arch/sparc64/mm/tsb.c~slab-allocators-remove-obsolete-slab_must_hwcache_align arch/sparc64/mm/tsb.c
--- a/arch/sparc64/mm/tsb.c~slab-allocators-remove-obsolete-slab_must_hwcache_align
+++ a/arch/sparc64/mm/tsb.c
@@ -262,8 +262,7 @@ void __init pgtable_cache_init(void)
 
 		tsb_caches[i] = kmem_cache_create(name,
 						  size, size,
-						  SLAB_HWCACHE_ALIGN |
-						  SLAB_MUST_HWCACHE_ALIGN,
+						  SLAB_HWCACHE_ALIGN,
 						  NULL, NULL);
 		if (!tsb_caches[i]) {
 			prom_printf("Could not create %s cache\n", name);
diff -puN include/linux/slab.h~slab-allocators-remove-obsolete-slab_must_hwcache_align include/linux/slab.h
--- a/include/linux/slab.h~slab-allocators-remove-obsolete-slab_must_hwcache_align
+++ a/include/linux/slab.h
@@ -26,7 +26,6 @@ typedef struct kmem_cache kmem_cache_t _
 #define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
 #define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
 #define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
-#define SLAB_MUST_HWCACHE_ALIGN	0x00008000UL	/* Force alignment even if debuggin is active */
 #define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL	/* Objects are reclaimable */
 #define SLAB_PANIC		0x00040000UL	/* Panic if kmem_cache_create() fails */
diff -puN mm/slab.c~slab-allocators-remove-obsolete-slab_must_hwcache_align mm/slab.c
--- a/mm/slab.c~slab-allocators-remove-obsolete-slab_must_hwcache_align
+++ a/mm/slab.c
@@ -175,12 +175,12 @@
 # define CREATE_MASK	(SLAB_DEBUG_INITIAL | SLAB_RED_ZONE | \
 			 SLAB_POISON | SLAB_HWCACHE_ALIGN | \
 			 SLAB_CACHE_DMA | \
-			 SLAB_MUST_HWCACHE_ALIGN | SLAB_STORE_USER | \
+			 SLAB_STORE_USER | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD)
 #else
 # define CREATE_MASK	(SLAB_HWCACHE_ALIGN | \
-			 SLAB_CACHE_DMA | SLAB_MUST_HWCACHE_ALIGN | \
+			 SLAB_CACHE_DMA | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD)
 #endif
diff -puN mm/slob.c~slab-allocators-remove-obsolete-slab_must_hwcache_align mm/slob.c
--- a/mm/slob.c~slab-allocators-remove-obsolete-slab_must_hwcache_align
+++ a/mm/slob.c
@@ -21,7 +21,7 @@
  *
  * SLAB is emulated on top of SLOB by simply calling constructors and
  * destructors for every SLAB allocation. Objects are returned with
- * the 8-byte alignment unless the SLAB_MUST_HWCACHE_ALIGN flag is
+ * the 8-byte alignment unless the SLAB_HWCACHE_ALIGN flag is
  * set, in which case the low-level allocator will fragment blocks to
  * create the proper alignment. Again, objects of page-size or greater
  * are allocated by calling __get_free_pages. As SLAB objects know
@@ -295,7 +295,7 @@ struct kmem_cache *kmem_cache_create(con
 		c->ctor = ctor;
 		c->dtor = dtor;
 		/* ignore alignment unless it's forced */
-		c->align = (flags & SLAB_MUST_HWCACHE_ALIGN) ? SLOB_ALIGN : 0;
+		c->align = (flags & SLAB_HWCACHE_ALIGN) ? SLOB_ALIGN : 0;
 		if (c->align < align)
 			c->align = align;
 	} else if (flags & SLAB_PANIC)
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
