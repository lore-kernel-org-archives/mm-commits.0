From: akpm@linux-foundation.org
Subject: + slub-slab-allocators-remove-slab_ctor_atomic.patch added to -mm tree
Date: Mon, 07 May 2007 11:46:03 -0700
Message-ID: <200705071846.l47Ik3Iw002125@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934439AbXEGSqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 14:46:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slab allocators: Remove SLAB_CTOR_ATOMIC
has been added to the -mm tree.  Its filename is
     slub-slab-allocators-remove-slab_ctor_atomic.patch

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

 mm/slub.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff -puN mm/slub.c~slub-slab-allocators-remove-slab_ctor_atomic mm/slub.c
--- a/mm/slub.c~slub-slab-allocators-remove-slab_ctor_atomic
+++ a/mm/slub.c
@@ -802,14 +802,8 @@ static void setup_object(struct kmem_cac
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

origin.patch
slab-introduce-krealloc.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
make-page-private-usable-in-compound-pages-v1.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
quicklists-for-page-table-pages.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-multiple-alignment-specifications.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_ctor_atomic.patch
slab-allocators-remove-useless-__gfp_no_grow-flag.patch
page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible.patch
slub-core.patch
slub-change-default-alignments.patch
slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes.patch
powerpc-disable-slub-for-configurations-in-which-slab-page-structs-are-modified.patch
slub-make-page-private-usable-in-compound-pages-v1.patch
slub-add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-add-slabinfo-tool.patch
slub-slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
slub-slab-allocators-remove-slab_debug_initial-flag.patch
slub-slab-allocators-remove-slab_ctor_atomic.patch
slub-slab-allocators-remove-useless-__gfp_no_grow-flag.patch
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
