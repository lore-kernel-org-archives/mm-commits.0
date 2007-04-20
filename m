From: akpm@linux-foundation.org
Subject: + slab-allocators-remove-obsolete-slab_must_hwcache_align.patch added to -mm tree
Date: Thu, 19 Apr 2007 23:09:44 -0700
Message-ID: <200704200609.l3K69ido008328@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422996AbXDTGJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 02:09:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     slab allocators: Remove obsolete SLAB_MUST_HWCACHE_ALIGN
has been added to the -mm tree.  Its filename is
     slab-allocators-remove-obsolete-slab_must_hwcache_align.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 mm/slub.c                     |    5 ++---
 7 files changed, 9 insertions(+), 14 deletions(-)

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
diff -puN mm/slub.c~slab-allocators-remove-obsolete-slab_must_hwcache_align mm/slub.c
--- a/mm/slub.c~slab-allocators-remove-obsolete-slab_must_hwcache_align
+++ a/mm/slub.c
@@ -1500,7 +1500,7 @@ static int calculate_order(int size)
 static unsigned long calculate_alignment(unsigned long flags,
 		unsigned long align)
 {
-	if (flags & (SLAB_MUST_HWCACHE_ALIGN | SLAB_HWCACHE_ALIGN))
+	if (flags & SLAB_HWCACHE_ALIGN)
 		return max_t(unsigned long, align, L1_CACHE_BYTES);
 
 	if (align < ARCH_SLAB_MINALIGN)
@@ -3089,8 +3089,7 @@ SLAB_ATTR(reclaim_account);
 
 static ssize_t hwcache_align_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags &
-		(SLAB_HWCACHE_ALIGN|SLAB_MUST_HWCACHE_ALIGN)));
+	return sprintf(buf, "%d\n", !!(s->flags & SLAB_HWCACHE_ALIGN));
 }
 SLAB_ATTR_RO(hwcache_align);
 
_

Patches currently in -mm which might be from clameter@sgi.com are

fix-oom-killing-processes-wrongly-thought-mpol_bind.patch
slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability-fix.patch
extend-print_symbol-capability-fix-fix.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-core-minor-fixes.patch
slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
slub-core-fix-another-numa-bootstrap-issue.patch
slub-core-fix-object-counting.patch
slub-core-drop-version-number.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-we-do-not-need-ifdef-config_smp-around-bit-spinlocks.patch
slub-core-printk-facility-level-cleanup.patch
slub-core-kmem_cache_close-is-static-and-should-not-be-exported.patch
slub-core-add-explanation-for-defrag_ratio-=-100.patch
slub-core-add-explanation-for-locking.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-the-64k-limits.patch
slub-core-explain-sizing-of-slabs-in-detail.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-add-checks-for-interrupts-disabled.patch
slub-core-use-__print_symbol-instead-of-kallsyms_lookup.patch
slub-core-missing-inlines-and-statics.patch
slub-fix-cpu-slab-flushing-behavior-so-that-counters-match.patch
slub-extract-finish_bootstrap-function-for-clean-sysfs-boot.patch
slub-core-fix-kmem_cache_destroy.patch
slub-core-fix-validation.patch
slub-core-add-after-object-padding.patch
slub-core-resiliency-fixups.patch
slub-core-resiliency-fixups-fix.patch
slub-core-resiliency-test.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-enable-tracking-of-full-slabs-add-checks-for-interrupts-disabled.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-validation-of-slabs-metadata-and-guard-zones-fix-pageerror-checks-during-validation.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
