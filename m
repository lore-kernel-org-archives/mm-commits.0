From: akpm@linux-foundation.org
Subject: + slub-core-remove-per-cpu-flusher.patch added to -mm tree
Date: Sun, 29 Apr 2007 02:29:01 -0700
Message-ID: <200704290929.l3T9T18H012881@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755081AbXD2J3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Apr 2007 05:29:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Remove per cpu flusher
has been added to the -mm tree.  Its filename is
     slub-core-remove-per-cpu-flusher.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Remove per cpu flusher
From: Christoph Lameter <clameter@sgi.com>

Tests show that we only have a very small number of slabs on the system with
the slab merge features.  Its around 60 - 80 slabs with only about 40 to 50 of
them having objects at all.  If every one of these 50 slab keeps an active per
cpu slab then each processor uses about 50*16k = 800k of memory for the per
cpu slabs.  This includes objects already allocated in those slabs.  For a
system with 128 processors this is going to be 100M.  Of those only 25M are
going to be saved through the per cpu flusher.  Pretty minor effect compared
to the gigabyte that is used on these systems by SLAB for its queueing
structures of free objects alone.

I think we can readily affort to keep these per cpu slabs around for good.  If
one wants to recover the cpu slabs regularly then one can set up a cron job
that runs

slabinfo -s

every minute or so.  Slab shrinking will flush per cpu slabs back to the
partial lists and make it possible for other cpus to use them.  Slab shrinking
is more effective and capable of reclaiming 50M of the 100M in the percpu
slabs.

Removing the per cpu flusher has the advantage that the system will be
completely silent if no slab activity occurs.  No timers need to be used for
SLUB at all which is good for the realtime folks and for those who want to
conserve power.

Also the size of the kmem_cache structure shrinks significantly and most of
the data elements now fit into one cache line.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    7 --
 mm/slub.c                |  110 ++++---------------------------------
 2 files changed, 14 insertions(+), 103 deletions(-)

diff -puN include/linux/slub_def.h~slub-core-remove-per-cpu-flusher include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-core-remove-per-cpu-flusher
+++ a/include/linux/slub_def.h
@@ -27,8 +27,6 @@ struct kmem_cache {
 	int size;		/* The size of an object including meta data */
 	int objsize;		/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
-	atomic_t cpu_slabs;	/* != 0 -> flusher scheduled. */
-	int defrag_ratio;
 	unsigned int order;
 
 	/*
@@ -48,11 +46,8 @@ struct kmem_cache {
 	struct list_head list;	/* List of slab caches */
 	struct kobject kobj;	/* For sysfs */
 
-#ifdef CONFIG_SMP
-	struct delayed_work flush;
-	struct mutex flushing;
-#endif
 #ifdef CONFIG_NUMA
+	int defrag_ratio;
 	struct kmem_cache_node *node[MAX_NUMNODES];
 #endif
 	struct page *cpu_slab[NR_CPUS];
diff -puN mm/slub.c~slub-core-remove-per-cpu-flusher mm/slub.c
--- a/mm/slub.c~slub-core-remove-per-cpu-flusher
+++ a/mm/slub.c
@@ -38,17 +38,18 @@
  *   removed from the lists nor make the number of partial slabs be modified.
  *   (Note that the total number of slabs is an atomic value that may be
  *   modified without taking the list lock).
+ *
  *   The list_lock is a centralized lock and thus we avoid taking it as
  *   much as possible. As long as SLUB does not have to handle partial
- *   slabs operations can continue without any centralized lock. F.e.
+ *   slabs, operations can continue without any centralized lock. F.e.
  *   allocating a long series of objects that fill up slabs does not require
  *   the list lock.
  *
  *   The lock order is sometimes inverted when we are trying to get a slab
  *   off a list. We take the list_lock and then look for a page on the list
- *   to use. While we do that objects in the slabs may be freed so we can
+ *   to use. While we do that objects in the slabs may be freed. We can
  *   only operate on the slab if we have also taken the slab_lock. So we use
- *   a slab_trylock() on the page. If trylock was successful then no frees
+ *   a slab_trylock() on the slab. If trylock was successful then no frees
  *   can occur anymore and we can use the slab for allocations etc. If the
  *   slab_trylock() does not succeed then frees are in progress in the slab and
  *   we must stay away from it for a while since we may cause a bouncing
@@ -65,14 +66,11 @@
  * SLUB assigns one slab for allocation to each processor.
  * Allocations only occur from these slabs called cpu slabs.
  *
- * If a cpu slab exists then a workqueue thread checks every 30
- * seconds if the cpu slab is still in use. The cpu slab is pushed back
- * to the list if inactive [only needed for SMP].
- *
  * Slabs with free elements are kept on a partial list.
  * There is no list for full slabs. If an object in a full slab is
  * freed then the slab will show up again on the partial lists.
- * Otherwise there is no need to track full slabs (but we keep a counter).
+ * Otherwise there is no need to track full slabs unless we have to
+ * track full slabs for debugging purposes.
  *
  * Slabs are freed when they become empty. Teardown and setup is
  * minimal so we rely on the page allocators per cpu caches for
@@ -82,15 +80,11 @@
  *
  * PageActive 		The slab is used as a cpu cache. Allocations
  * 			may be performed from the slab. The slab is not
- * 			on a partial list.
- *
- * PageReferenced	The per cpu slab was used recently. This is used
- * 			to push back per cpu slabs if they are unused
- * 			for a longer time period.
+ * 			on any slab list and cannot be moved onto one.
  *
  * PageError		Slab requires special handling due to debug
- * 			options set or a single page slab. This moves
- * 			slab handling out of the fast path.
+ * 			options set. This moves	slab handling out of
+ * 			the fast path.
  */
 
 /*
@@ -1113,7 +1107,6 @@ static void deactivate_slab(struct kmem_
 {
 	s->cpu_slab[cpu] = NULL;
 	ClearPageActive(page);
-	ClearPageReferenced(page);
 
 	putback_slab(s, page);
 }
@@ -1144,61 +1137,18 @@ static void flush_cpu_slab(void *d)
 	__flush_cpu_slab(s, cpu);
 }
 
-#ifdef CONFIG_SMP
-/*
- * Called from IPI to check and flush cpu slabs.
- */
-static void check_flush_cpu_slab(void *private)
-{
-	struct kmem_cache *s = private;
-	int cpu = smp_processor_id();
-	struct page *page = s->cpu_slab[cpu];
-
-	if (page) {
-		if (!TestClearPageReferenced(page))
-			return;
-		flush_slab(s, page, cpu);
-	}
-	atomic_dec(&s->cpu_slabs);
-}
-
-/*
- * Called from eventd
- */
-static void flusher(struct work_struct *w)
-{
-	struct kmem_cache *s = container_of(w, struct kmem_cache, flush.work);
-
-	if (!mutex_trylock(&s->flushing))
-		return;
-
-	atomic_set(&s->cpu_slabs, num_online_cpus());
-	on_each_cpu(check_flush_cpu_slab, s, 1, 1);
-	if (atomic_read(&s->cpu_slabs))
-		schedule_delayed_work(&s->flush, 30 * HZ);
-	mutex_unlock(&s->flushing);
-}
-
 static void flush_all(struct kmem_cache *s)
 {
-	if (atomic_read(&s->cpu_slabs)) {
-		mutex_lock(&s->flushing);
-		cancel_delayed_work(&s->flush);
-		atomic_set(&s->cpu_slabs, 0);
-		on_each_cpu(flush_cpu_slab, s, 1, 1);
-		mutex_unlock(&s->flushing);
-	}
-}
+#ifdef CONFIG_SMP
+	on_each_cpu(flush_cpu_slab, s, 1, 1);
 #else
-static void flush_all(struct kmem_cache *s)
-{
 	unsigned long flags;
 
 	local_irq_save(flags);
 	flush_cpu_slab(s);
 	local_irq_restore(flags);
-}
 #endif
+}
 
 /*
  * slab_alloc is optimized to only modify two cachelines on the fast path
@@ -1240,7 +1190,6 @@ redo:
 have_object:
 	page->inuse++;
 	page->freelist = object[page->offset];
-	SetPageReferenced(page);
 	slab_unlock(page);
 	local_irq_restore(flags);
 	return object;
@@ -1254,13 +1203,6 @@ new_slab:
 have_slab:
 		s->cpu_slab[cpu] = page;
 		SetPageActive(page);
-
-#ifdef CONFIG_SMP
-		if (!atomic_read(&s->cpu_slabs)) {
-			atomic_inc(&s->cpu_slabs);
-			schedule_delayed_work(&s->flush, 30 * HZ);
-		}
-#endif
 		goto redo;
 	}
 
@@ -1750,13 +1692,6 @@ static int __init finish_bootstrap(void)
 
 		err = sysfs_slab_add(s);
 		BUG_ON(err);
-		/*
-		 * Start the periodic checks for inactive cpu slabs.
-		 * flush_all() will zero s->cpu_slabs which will cause
-		 * any allocation of a new cpu slab to schedule an event
-		 * via keventd to watch for inactive cpu slabs.
-		 */
-		flush_all(s);
 	}
 	return 0;
 }
@@ -1811,24 +1746,6 @@ static int kmem_cache_open(struct kmem_c
 	s->defrag_ratio = 100;
 #endif
 
-#ifdef CONFIG_SMP
-	mutex_init(&s->flushing);
-	if (slab_state >= SYSFS)
-		atomic_set(&s->cpu_slabs, 0);
-	else
-		/*
-		 * Keventd may not be up yet. Pretend that we have active
-		 * per_cpu slabs so that there will be no attempt to
-		 * schedule a flusher in slab_alloc.
-		 *
-		 * We fix the situation up later when sysfs is brought up
-		 * by flushing all slabs (which puts the slab caches that
-		 * are mostly/only used in a nice quiet state).
-		 */
-		atomic_set(&s->cpu_slabs, 1);
-
-	INIT_DELAYED_WORK(&s->flush, flusher);
-#endif
 	if (init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
 		return 1;
 error:
@@ -2055,8 +1972,7 @@ static struct kmem_cache *create_kmalloc
 	return s;
 
 panic:
-	panic("Creation of kmalloc slab %s size=%d failed.\n",
-			name, size);
+	panic("Creation of kmalloc slab %s size=%d failed.\n", name, size);
 }
 
 static struct kmem_cache *get_slab(size_t size, gfp_t flags)
_

Patches currently in -mm which might be from clameter@sgi.com are

extend-print_symbol-capability.patch
slab-introduce-krealloc.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix-2.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-core-conform-more-to-slabs-slab_hwcache_align-behavior.patch
slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation.patch
slub-core-sysfs-support-fix-unique-id-generation.patch
slub-core-printk-cleanup-object_err.patch
slub-core-printk-cleanup-add-slab_err.patch
slub-core-printk-cleanup-fix-up-printks-in-the-resiliency-check.patch
slub-core-fix-slab-validation-error-in-bootstrap-cache.patch
slub-core-remove-per-cpu-flusher.patch
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
slub-validation-of-slabs-metadata-and-guard-zones-remove-duplicate-vm_bug_on.patch
slub-validation-of-slabs-metadata-and-guard-zones-printk-cleanup-slab-validation-printks.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink-fixes-to-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-remove-object-activities-out-of-checking-functions-printk-cleanup-diagnostic-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
slub-major-slabinfo-update.patch
slub-slabinfo-remove-hackname.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-slabinfo-more-statistic-fixes-and-handling-fixes.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion-fix.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_debug_initial-flag-locks-fix.patch
slab-allocators-remove-multiple-alignment-specifications.patch
slab-allocators-remove-slab_ctor_atomic.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slub-i386-support.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
readahead-state-based-method-aging-accounting.patch
vmstat-use-our-own-timer-events.patch
