From: akpm@linux-foundation.org
Subject: + slub-slab-allocators-remove-slab_debug_initial-flag.patch added to -mm tree
Date: Mon, 07 May 2007 11:45:59 -0700
Message-ID: <200705071846.l47Ik0LF002122@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934479AbXEGSqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 14:46:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slab allocators: Remove SLAB_DEBUG_INITIAL flag
has been added to the -mm tree.  Its filename is
     slub-slab-allocators-remove-slab_debug_initial-flag.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab allocators: Remove SLAB_DEBUG_INITIAL flag
From: Christoph Lameter <clameter@sgi.com>

I have never seen a use of SLAB_DEBUG_INITIAL.  It is only supported by
SLAB.

I think its purpose was to have a callback after an object has been freed
to verify that the state is the constructor state again?  The callback is
performed before each freeing of an object.

I would think that it is much easier to check the object state manually
before the free.  That also places the check near the code object
manipulation of the object.

Also the SLAB_DEBUG_INITIAL callback is only performed if the kernel was
compiled with SLAB debugging on.  If there would be code in a constructor
handling SLAB_DEBUG_INITIAL then it would have to be conditional on
SLAB_DEBUG otherwise it would just be dead code.  But there is no such code
in the kernel.  I think SLUB_DEBUG_INITIAL is too problematic to make real
use of, difficult to understand and there are easier ways to accomplish the
same effect (i.e.  add debug code before kfree).

There is a related flag SLAB_CTOR_VERIFY that is frequently checked to be
clear in fs inode caches.  Remove the pointless checks (they would even be
pointless without removeal of SLAB_DEBUG_INITIAL) from the fs constructors.

This is the last slab flag that SLUB did not support.  Remove the check for
unimplemented flags from SLUB.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   10 ----------
 1 files changed, 10 deletions(-)

diff -puN mm/slub.c~slub-slab-allocators-remove-slab_debug_initial-flag mm/slub.c
--- a/mm/slub.c~slub-slab-allocators-remove-slab_debug_initial-flag
+++ a/mm/slub.c
@@ -97,9 +97,6 @@
  *
  * - Support PAGE_ALLOC_DEBUG. Should be easy to do.
  *
- * - SLAB_DEBUG_INITIAL is not supported but I have never seen a use of
- *   it.
- *
  * - Variable sizing of the per node arrays
  */
 
@@ -126,11 +123,6 @@
 #endif
 
 /*
- * Flags from the regular SLAB that SLUB does not support:
- */
-#define SLUB_UNIMPLEMENTED (SLAB_DEBUG_INITIAL)
-
-/*
  * Mininum number of partial slabs. These will be left on the partial
  * lists even if they are empty. kmem_cache_shrink may reclaim them.
  */
@@ -1748,8 +1740,6 @@ static int kmem_cache_open(struct kmem_c
 	s->flags = flags;
 	s->align = align;
 
-	BUG_ON(flags & SLUB_UNIMPLEMENTED);
-
 	/*
 	 * The page->offset field is only 16 bit wide. This is an offset
 	 * in units of words from the beginning of an object. If the slab
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
