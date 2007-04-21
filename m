From: akpm@linux-foundation.org
Subject: + slab-allocators-remove-slab_ctor_atomic.patch added to -mm tree
Date: Fri, 20 Apr 2007 23:15:30 -0700
Message-ID: <200704210615.l3L6FUoe032736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097AbXDUGPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 02:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slab allocators: Remove SLAB_CTOR_ATOMIC
has been added to the -mm tree.  Its filename is
     slab-allocators-remove-slab_ctor_atomic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab allocators: Remove SLAB_CTOR_ATOMIC
From: Christoph Lameter <clameter@sgi.com>

SLAB_CTOR atomic is never used which is no surprise since I cannot imagine
that one would want to do something serious in a constructor or destructor.
 In particular given that the slab allocators run with interrupts disabled.
 Actions in constructors and destructors are by their nature very limited
and usually do not go beyond initializing variables and list operations.

(The i386 pgd ctor and dtors do take a spinlock in constructor and
destructor.....  I think that is the furthest we go at this point.)

There is no flag passed to the destructor so removing SLAB_CTOR_ATOMIC also
establishes a certain symmetry.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    1 -
 mm/slab.c            |   17 ++---------------
 mm/slub.c            |   10 ++--------
 3 files changed, 4 insertions(+), 24 deletions(-)

diff -puN include/linux/slab.h~slab-allocators-remove-slab_ctor_atomic include/linux/slab.h
--- a/include/linux/slab.h~slab-allocators-remove-slab_ctor_atomic
+++ a/include/linux/slab.h
@@ -34,7 +34,6 @@ typedef struct kmem_cache kmem_cache_t _
 
 /* Flags passed to a constructor functions */
 #define SLAB_CTOR_CONSTRUCTOR	0x001UL		/* If not set, then deconstructor */
-#define SLAB_CTOR_ATOMIC	0x002UL		/* Tell constructor it can't sleep */
 
 /*
  * struct kmem_cache related prototypes
diff -puN mm/slab.c~slab-allocators-remove-slab_ctor_atomic mm/slab.c
--- a/mm/slab.c~slab-allocators-remove-slab_ctor_atomic
+++ a/mm/slab.c
@@ -2752,13 +2752,6 @@ static int cache_grow(struct kmem_cache 
 
 	ctor_flags = SLAB_CTOR_CONSTRUCTOR;
 	local_flags = (flags & GFP_LEVEL_MASK);
-	if (!(local_flags & __GFP_WAIT))
-		/*
-		 * Not allowed to sleep.  Need to tell a constructor about
-		 * this - it might need to know...
-		 */
-		ctor_flags |= SLAB_CTOR_ATOMIC;
-
 	/* Take the l3 list lock to change the colour_next on this node */
 	check_irq_off();
 	l3 = cachep->nodelists[nodeid];
@@ -3092,14 +3085,8 @@ static void *cache_alloc_debugcheck_afte
 	}
 #endif
 	objp += obj_offset(cachep);
-	if (cachep->ctor && cachep->flags & SLAB_POISON) {
-		unsigned long ctor_flags = SLAB_CTOR_CONSTRUCTOR;
-
-		if (!(flags & __GFP_WAIT))
-			ctor_flags |= SLAB_CTOR_ATOMIC;
-
-		cachep->ctor(objp, cachep, ctor_flags);
-	}
+	if (cachep->ctor && cachep->flags & SLAB_POISON)
+		cachep->ctor(objp, cachep, SLAB_CTOR_CONSTRUCTOR);
 #if ARCH_SLAB_MINALIGN
 	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
 		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
diff -puN mm/slub.c~slab-allocators-remove-slab_ctor_atomic mm/slub.c
--- a/mm/slub.c~slab-allocators-remove-slab_ctor_atomic
+++ a/mm/slub.c
@@ -786,14 +786,8 @@ static void setup_object(struct kmem_cac
 		init_tracking(s, object);
 	}
 
-	if (unlikely(s->ctor)) {
-		int mode = SLAB_CTOR_CONSTRUCTOR;
-
-		if (!(s->flags & __GFP_WAIT))
-			mode |= SLAB_CTOR_ATOMIC;
-
-		s->ctor(object, s, mode);
-	}
+	if (unlikely(s->ctor))
+		s->ctor(object, s, SLAB_CTOR_CONSTRUCTOR);
 }
 
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
_

Patches currently in -mm which might be from clameter@sgi.com are

fix-oom-killing-processes-wrongly-thought-mpol_bind.patch
page-migration-fix-nr_file_pages-accounting.patch
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
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-multiple-alignment-specifications.patch
slab-allocators-remove-slab_ctor_atomic.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
