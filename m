From: akpm@linux-foundation.org
Subject: - support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch removed from -mm tree
Date: Mon, 07 May 2007 15:29:04 -0700
Message-ID: <200705072229.l47MT4XS007029@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966572AbXEGW33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 18:29:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub: support concurrent local and remote frees and allocs on a slab
has been removed from the -mm tree.  Its filename was
     support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: slub: support concurrent local and remote frees and allocs on a slab
From: Christoph Lameter <clameter@sgi.com>

About 5-10% performance gain on netperf.

What we do is use the last free field in the page struct (the private field
that was freed up through the compound page flag rework) to setup a
separate per cpu freelist.  From that one we can allocate without taking
the slab lock because we checkout the complete list of free objects when we
first touch the slab and then mark the slab as completely allocated.  If we
have a cpu_freelist then we can also free to that list if we run on that
processor without taking the slab lock.

This allows even concurrent allocations and frees on the same slab using
two mutually exclusive freelists.  Allocs and frees from the processor
owning the per cpu slab will bypass the slab lock using the cpu_freelist. 
Remove frees will use the slab lock to synchronize and use the freelist for
marking items as free.  So local allocs and frees may run concurrently with
remote frees without synchronization.

If the allocator is running out of its per cpu freelist then it will
consult the per slab freelist (which requires the slab lock) and reload the
cpu_freelist if there are objects that were remotely freed.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    5 ++
 mm/slub.c                |   67 ++++++++++++++++++++++++++++++-------
 2 files changed, 59 insertions(+), 13 deletions(-)

diff -puN include/linux/mm_types.h~support-concurrent-local-and-remote-frees-and-allocs-on-a-slab include/linux/mm_types.h
--- a/include/linux/mm_types.h~support-concurrent-local-and-remote-frees-and-allocs-on-a-slab
+++ a/include/linux/mm_types.h
@@ -50,9 +50,12 @@ struct page {
 	    spinlock_t ptl;
 #endif
 	    struct {			/* SLUB uses */
-		struct page *first_page;	/* Compound pages */
+	    	void **cpu_freelist;		/* Per cpu freelist */
 		struct kmem_cache *slab;	/* Pointer to slab */
 	    };
+	    struct {
+		struct page *first_page;	/* Compound pages */
+	    };
 	};
 	union {
 		pgoff_t index;		/* Our offset within mapping. */
diff -puN mm/slub.c~support-concurrent-local-and-remote-frees-and-allocs-on-a-slab mm/slub.c
--- a/mm/slub.c~support-concurrent-local-and-remote-frees-and-allocs-on-a-slab
+++ a/mm/slub.c
@@ -81,10 +81,13 @@
  * PageActive 		The slab is used as a cpu cache. Allocations
  * 			may be performed from the slab. The slab is not
  * 			on any slab list and cannot be moved onto one.
+ * 			The cpu slab may have a cpu_freelist in order
+ * 			to optimize allocations and frees on a particular
+ * 			cpu.
  *
  * PageError		Slab requires special handling due to debug
  * 			options set. This moves	slab handling out of
- * 			the fast path.
+ * 			the fast path and disables cpu_freelists.
  */
 
 /*
@@ -850,6 +853,7 @@ static struct page *new_slab(struct kmem
 	set_freepointer(s, last, NULL);
 
 	page->freelist = start;
+	page->cpu_freelist = NULL;
 	page->inuse = 0;
 out:
 	if (flags & __GFP_WAIT)
@@ -1114,6 +1118,23 @@ static void putback_slab(struct kmem_cac
  */
 static void deactivate_slab(struct kmem_cache *s, struct page *page, int cpu)
 {
+	/*
+	 * Merge cpu freelist into freelist. Typically we get here
+	 * because both freelists are empty. So this is unlikely
+	 * to occur.
+	 */
+	while (unlikely(page->cpu_freelist)) {
+		void **object;
+
+		/* Retrieve object from cpu_freelist */
+		object = page->cpu_freelist;
+		page->cpu_freelist = page->cpu_freelist[page->offset];
+
+		/* And put onto the regular freelist */
+		object[page->offset] = page->freelist;
+		page->freelist = object;
+		page->inuse--;
+	}
 	s->cpu_slab[cpu] = NULL;
 	ClearPageActive(page);
 
@@ -1183,22 +1204,33 @@ static void *slab_alloc(struct kmem_cach
 	local_irq_save(flags);
 	cpu = smp_processor_id();
 	page = s->cpu_slab[cpu];
-	if (!page)
+	if (unlikely(!page))
 		goto new_slab;
 
-	slab_lock(page);
-	if (unlikely(node != -1 && page_to_nid(page) != node))
+	if (unlikely(node != -1 && page_to_nid(page) != node)) {
+		slab_lock(page);
 		goto another_slab;
+	}
+
+	if (likely(page->cpu_freelist)) {
+		object = page->cpu_freelist;
+		page->cpu_freelist = object[page->offset];
+		local_irq_restore(flags);
+		return object;
+	}
+
+	slab_lock(page);
 redo:
-	object = page->freelist;
-	if (unlikely(!object))
+	if (!page->freelist)
 		goto another_slab;
-	if (unlikely(PageError(page)))
+	if (PageError(page))
 		goto debug;
 
-have_object:
-	page->inuse++;
-	page->freelist = object[page->offset];
+	/* Reload the cpu freelist while allocating the next object */
+	object = page->freelist;
+	page->cpu_freelist = object[page->offset];
+	page->freelist = NULL;
+	page->inuse = s->objects;
 	slab_unlock(page);
 	local_irq_restore(flags);
 	return object;
@@ -1208,7 +1240,7 @@ another_slab:
 
 new_slab:
 	page = get_partial(s, gfpflags, node);
-	if (likely(page)) {
+	if (page) {
 have_slab:
 		s->cpu_slab[cpu] = page;
 		SetPageActive(page);
@@ -1244,6 +1276,7 @@ have_slab:
 	local_irq_restore(flags);
 	return NULL;
 debug:
+	object = page->freelist;
 	if (!alloc_object_checks(s, page, object))
 		goto another_slab;
 	if (s->flags & SLAB_STORE_USER)
@@ -1254,8 +1287,12 @@ debug:
 			page->freelist);
 		dump_stack();
 	}
+	page->freelist = object[page->offset];
+	page->inuse++;
 	init_object(s, object, 1);
-	goto have_object;
+	slab_unlock(page);
+	local_irq_restore(flags);
+	return object;
 }
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
@@ -1286,6 +1323,12 @@ static void slab_free(struct kmem_cache 
 	unsigned long flags;
 
 	local_irq_save(flags);
+	if (page == s->cpu_slab[smp_processor_id()] && !PageError(page)) {
+		object[page->offset] = page->cpu_freelist;
+		page->cpu_freelist = object;
+		local_irq_restore(flags);
+		return;
+	}
 	slab_lock(page);
 
 	if (unlikely(PageError(page)))
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
support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
powerpc-disable-slub-for-configurations-in-which-slab-page-structs-are-modified.patch
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
