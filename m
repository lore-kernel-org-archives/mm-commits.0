From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:05:56 -0700
Message-ID: <201004221905.o3MJ5vIe002072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706Ab0DVTHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:07:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: migration: take a reference to the anon_vma before migrating
has been removed from the -mm tree.  Its filename was
     mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: migration: take a reference to the anon_vma before migrating
From: Mel Gorman <mel@csn.ul.ie>

This patchset is a memory compaction mechanism that reduces external
fragmentation memory by moving GFP_MOVABLE pages to a fewer number of
pageblocks.  The term "compaction" was chosen as there are is a number of
mechanisms that are not mutually exclusive that can be used to defragment
memory.  For example, lumpy reclaim is a form of defragmentation as was
slub "defragmentation" (really a form of targeted reclaim).  Hence, this
is called "compaction" to distinguish it from other forms of
defragmentation.

In this implementation, a full compaction run involves two scanners
operating within a zone - a migration and a free scanner.  The migration
scanner starts at the beginning of a zone and finds all movable pages
within one pageblock_nr_pages-sized area and isolates them on a
migratepages list.  The free scanner begins at the end of the zone and
searches on a per-area basis for enough free pages to migrate all the
pages on the migratepages list.  As each area is respectively migrated or
exhausted of free pages, the scanners are advanced one area.  A compaction
run completes within a zone when the two scanners meet.

This method is a bit primitive but is easy to understand and greater
sophistication would require maintenance of counters on a per-pageblock
basis.  This would have a big impact on allocator fast-paths to improve
compaction which is a poor trade-off.

It also does not try relocate virtually contiguous pages to be physically
contiguous.  However, assuming transparent hugepages were in use, a
hypothetical khugepaged might reuse compaction code to isolate free pages,
split them and relocate userspace pages for promotion.

Memory compaction can be triggered in one of three ways.  It may be
triggered explicitly by writing any value to /proc/sys/vm/compact_memory
and compacting all of memory.  It can be triggered on a per-node basis by
writing any value to /sys/devices/system/node/nodeN/compact where N is the
node ID to be compacted.  When a process fails to allocate a high-order
page, it may compact memory in an attempt to satisfy the allocation
instead of entering direct reclaim.  Explicit compaction does not finish
until the two scanners meet and direct compaction ends if a suitable page
becomes available that would meet watermarks.

The series is in 14 patches.  The first three are not "core" to the series
but are important pre-requisites.

Patch 1 reference counts anon_vma for rmap_walk_anon(). Without this
	patch, it's possible to use anon_vma after free if the caller is
	not holding a VMA or mmap_sem for the pages in question. While
	there should be no existing user that causes this problem,
	it's a requirement for memory compaction to be stable. The patch
	is at the start of the series for bisection reasons.
Patch 2 skips over anon pages during migration that are no longer mapped
	because there still appeared to be a small window between when
	a page was isolated and migration started during which anon_vma
	could disappear.
Patch 3 merges the KSM and migrate counts. It could be merged with patch 1
	but would be slightly harder to review.
Patch 4 allows CONFIG_MIGRATION to be set without CONFIG_NUMA
Patch 5 exports a "unusable free space index" via /proc/pagetypeinfo. It's
	a measure of external fragmentation that takes the size of the
	allocation request into account. It can also be calculated from
	userspace so can be dropped if requested
Patch 6 exports a "fragmentation index" which only has meaning when an
	allocation request fails. It determines if an allocation failure
	would be due to a lack of memory or external fragmentation.
Patch 7 moves the definition for LRU isolation modes for use by compaction
Patch 8 is the compaction mechanism although it's unreachable at this point
Patch 9 adds a means of compacting all of memory with a proc trgger
Patch 10 adds a means of compacting a specific node with a sysfs trigger
Patch 11 adds "direct compaction" before "direct reclaim" if it is
	determined there is a good chance of success.
Patch 12 adds a sysctl that allows tuning of the threshold at which the
	kernel will compact or direct reclaim
Patch 13 temporarily disables compaction if an allocation failure occurs
	after compaction.
Patch 14 allows the migration of PageSwapCache pages. This patch was not
	as straight-forward as rmap_walk and migration needed extra
	smarts to avoid problems under heavy memory pressure. It's possible
	that memory hot-remove could be affected.

Testing of compaction was in three stages.  For the test, debugging,
preempt, the sleep watchdog and lockdep were all enabled but nothing nasty
popped out.  min_free_kbytes was tuned as recommended by hugeadm to help
fragmentation avoidance and high-order allocations.  It was tested on X86,
X86-64 and PPC64.

Ths first test represents one of the easiest cases that can be faced for
lumpy reclaim or memory compaction.

1. Machine freshly booted and configured for hugepage usage with
	a) hugeadm --create-global-mounts
	b) hugeadm --pool-pages-max DEFAULT:8G
	c) hugeadm --set-recommended-min_free_kbytes
	d) hugeadm --set-recommended-shmmax

        The min_free_kbytes here is important.  Anti-fragmentation
        works best when pageblocks don't mix.  hugeadm knows how to
        calculate a value that will significantly reduce the worst of
        external-fragmentation-related events as reported by the
        mm_page_alloc_extfrag tracepoint.

2. Load up memory
	a) Start updatedb
	b) Create in parallel a X files of pagesize*128 in size. Wait
	   until files are created. By parallel, I mean that 4096 instances
	   of dd were launched, one after the other using &. The crude
	   objective being to mix filesystem metadata allocations with
	   the buffer cache.
	c) Delete every second file so that pageblocks are likely to
	   have holes
	d) kill updatedb if it's still running

	At this point, the system is quiet, memory is full but it's full with
	clean filesystem metadata and clean buffer cache that is unmapped.
	This is readily migrated or discarded so you'd expect lumpy reclaim
	to have no significant advantage over compaction but this is at
	the POC stage.

3. In increments, attempt to allocate 5% of memory as hugepages.
	   Measure how long it took, how successful it was, how many
	   direct reclaims took place and how how many compactions. Note
	   the compaction figures might not fully add up as compactions
	   can take place for orders other than the hugepage size

X86				vanilla		compaction
Final page count                    915                916 (attempted 1002)
pages reclaimed                   88872               2942

X86-64				vanilla		compaction
Final page count:                   901                902 (attempted 1002)
Total pages reclaimed:           137573              50655

PPC64				vanilla		compaction
Final page count:                    89                 92 (attempted 110)
Total pages reclaimed:            84727               9345

There was not a dramatic improvement in success rates but it wouldn't be
expected in this case either.  What was important is that far fewer pages
were reclaimed in all cases reducing the amount of IO required to satisfy
a huge page allocation.

The second tests were all performance related - kernbench, netperf, iozone
and sysbench.  None showed anything too remarkable.

The last test was a high-order allocation stress test.  Many kernel
compiles are started to fill memory with a pressured mix of unmovable and
movable allocations.  During this, an attempt is made to allocate 90% of
memory as huge pages - one at a time with small delays between attempts to
avoid flooding the IO queue.

                                             vanilla   compaction
Percentage of request allocated X86               96           99
Percentage of request allocated X86-64            96           98
Percentage of request allocated PPC64             51           79

Success rates are a little higher, particularly on PPC64 with the larger
huge pages.  What is most interesting is the latency when allocating huge
pages.

X86:    http://www.csn.ul.ie/~mel/postings/compaction-20100402/highalloc-interlatency-arnold-compaction-stress-v7r12-mean.ps
X86_64: http://www.csn.ul.ie/~mel/postings/compaction-20100402/highalloc-interlatency-hydra-compaction-stress-v7r12-mean.ps
PPC64: http://www.csn.ul.ie/~mel/postings/compaction-20100402/highalloc-interlatency-powyah-compaction-stress-v7r12-mean.ps

X86 latency is reduced the least but it is depending heavily on the
HIGHMEM zone to allocate many of its huge pages which is a relatively
straight-forward job.  X86-64 and PPC64 both show reductions in average
time taken to allocate huge pages.  It is not reduced to zero because the
system is under enough memory pressure that reclaim is still required for
some of the allocations.

What is also enlightening in the same directory is the "stddev" files. 
Each of them show that the variance between allocation times is heavily
reduced.

rmap_walk_anon() does not use page_lock_anon_vma() for looking up and
locking an anon_vma and it does not appear to have sufficient locking to
ensure the anon_vma does not disappear from under it.

This patch copies an approach used by KSM to take a reference on the
anon_vma while pages are being migrated.  This should prevent rmap_walk()
running into nasty surprises later because anon_vma has been freed.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   23 +++++++++++++++++++++++
 mm/migrate.c         |   12 ++++++++++++
 mm/rmap.c            |   10 +++++-----
 3 files changed, 40 insertions(+), 5 deletions(-)

diff -puN include/linux/rmap.h~mm-migration-take-a-reference-to-the-anon_vma-before-migrating include/linux/rmap.h
--- a/include/linux/rmap.h~mm-migration-take-a-reference-to-the-anon_vma-before-migrating
+++ a/include/linux/rmap.h
@@ -29,6 +29,9 @@ struct anon_vma {
 #ifdef CONFIG_KSM
 	atomic_t ksm_refcount;
 #endif
+#ifdef CONFIG_MIGRATION
+	atomic_t migrate_refcount;
+#endif
 	/*
 	 * NOTE: the LSB of the head.next is set by
 	 * mm_take_all_locks() _after_ taking the above lock. So the
@@ -81,6 +84,26 @@ static inline int ksm_refcount(struct an
 	return 0;
 }
 #endif /* CONFIG_KSM */
+#ifdef CONFIG_MIGRATION
+static inline void migrate_refcount_init(struct anon_vma *anon_vma)
+{
+	atomic_set(&anon_vma->migrate_refcount, 0);
+}
+
+static inline int migrate_refcount(struct anon_vma *anon_vma)
+{
+	return atomic_read(&anon_vma->migrate_refcount);
+}
+#else
+static inline void migrate_refcount_init(struct anon_vma *anon_vma)
+{
+}
+
+static inline int migrate_refcount(struct anon_vma *anon_vma)
+{
+	return 0;
+}
+#endif /* CONFIG_MIGRATE */
 
 static inline struct anon_vma *page_anon_vma(struct page *page)
 {
diff -puN mm/migrate.c~mm-migration-take-a-reference-to-the-anon_vma-before-migrating mm/migrate.c
--- a/mm/migrate.c~mm-migration-take-a-reference-to-the-anon_vma-before-migrating
+++ a/mm/migrate.c
@@ -543,6 +543,7 @@ static int unmap_and_move(new_page_t get
 	int rcu_locked = 0;
 	int charge = 0;
 	struct mem_cgroup *mem = NULL;
+	struct anon_vma *anon_vma = NULL;
 
 	if (!newpage)
 		return -ENOMEM;
@@ -599,6 +600,8 @@ static int unmap_and_move(new_page_t get
 	if (PageAnon(page)) {
 		rcu_read_lock();
 		rcu_locked = 1;
+		anon_vma = page_anon_vma(page);
+		atomic_inc(&anon_vma->migrate_refcount);
 	}
 
 	/*
@@ -638,6 +641,15 @@ skip_unmap:
 	if (rc)
 		remove_migration_ptes(page, page);
 rcu_unlock:
+
+	/* Drop an anon_vma reference if we took one */
+	if (anon_vma && atomic_dec_and_lock(&anon_vma->migrate_refcount, &anon_vma->lock)) {
+		int empty = list_empty(&anon_vma->head);
+		spin_unlock(&anon_vma->lock);
+		if (empty)
+			anon_vma_free(anon_vma);
+	}
+
 	if (rcu_locked)
 		rcu_read_unlock();
 uncharge:
diff -puN mm/rmap.c~mm-migration-take-a-reference-to-the-anon_vma-before-migrating mm/rmap.c
--- a/mm/rmap.c~mm-migration-take-a-reference-to-the-anon_vma-before-migrating
+++ a/mm/rmap.c
@@ -249,7 +249,8 @@ static void anon_vma_unlink(struct anon_
 	list_del(&anon_vma_chain->same_anon_vma);
 
 	/* We must garbage collect the anon_vma if it's empty */
-	empty = list_empty(&anon_vma->head) && !ksm_refcount(anon_vma);
+	empty = list_empty(&anon_vma->head) && !ksm_refcount(anon_vma) &&
+					!migrate_refcount(anon_vma);
 	spin_unlock(&anon_vma->lock);
 
 	if (empty)
@@ -274,6 +275,7 @@ static void anon_vma_ctor(void *data)
 
 	spin_lock_init(&anon_vma->lock);
 	ksm_refcount_init(anon_vma);
+	migrate_refcount_init(anon_vma);
 	INIT_LIST_HEAD(&anon_vma->head);
 }
 
@@ -1339,10 +1341,8 @@ static int rmap_walk_anon(struct page *p
 	/*
 	 * Note: remove_migration_ptes() cannot use page_lock_anon_vma()
 	 * because that depends on page_mapped(); but not all its usages
-	 * are holding mmap_sem, which also gave the necessary guarantee
-	 * (that this anon_vma's slab has not already been destroyed).
-	 * This needs to be reviewed later: avoiding page_lock_anon_vma()
-	 * is risky, and currently limits the usefulness of rmap_walk().
+	 * are holding mmap_sem. Users without mmap_sem are required to
+	 * take a reference count to prevent the anon_vma disappearing
 	 */
 	anon_vma = page_anon_vma(page);
 	if (!anon_vma)
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-unusable-free-space-index-via-proc-unusable_index-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index-fix-fix-2.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index-fix.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-memory-compaction-core-fix.patch
mm-compaction-memory-compaction-core-fix-page-buddy-can-go-away-before-reading-page_order-while-isolating-pages-for-migration.patch
mm-compaction-memory-compaction-core-map-free-pages-in-the-address-space-after-they-get-split-for-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix-fix.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled-checkpatch-fixes.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree.patch
mm-introduce-free_pages_prepare.patch
mm-introduce-free_pages_prepare-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
add-debugging-aid-for-memory-initialisation-problems.patch

