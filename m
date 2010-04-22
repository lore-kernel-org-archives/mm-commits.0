From: akpm@linux-foundation.org
Subject: + mmmigration-do-not-try-to-migrate-unmapped-anonymous-pages.patch added to -mm tree
Date: Thu, 22 Apr 2010 12:33:33 -0700
Message-ID: <201004221933.o3MJXX5W003654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756967Ab0DVTdu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:33:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: migration: do not try to migrate unmapped anonymous pages
has been added to the -mm tree.  Its filename is
     mmmigration-do-not-try-to-migrate-unmapped-anonymous-pages.patch

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
Subject: mm: migration: do not try to migrate unmapped anonymous pages
From: Mel Gorman <mel@csn.ul.ie>

rmap_walk_anon() was triggering errors in memory compaction that look like
use-after-free errors.  The problem is that between the page being
isolated from the LRU and rcu_read_lock() being taken, the mapcount of the
page dropped to 0 and the anon_vma gets freed.  This can happen during
memory compaction if pages being migrated belong to a process that exits
before migration completes.  Hence, the use-after-free race looks like

 1. Page isolated for migration
 2. Process exits
 3. page_mapcount(page) drops to zero so anon_vma was no longer reliable
 4. unmap_and_move() takes the rcu_lock but the anon_vma is already garbage
 4. call try_to_unmap, looks up tha anon_vma and "locks" it but the lock
    is garbage.

This patch checks the mapcount after the rcu lock is taken.  If the
mapcount is zero, the anon_vma is assumed to be freed and no further
action is taken.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/migrate.c~mmmigration-do-not-try-to-migrate-unmapped-anonymous-pages mm/migrate.c
--- a/mm/migrate.c~mmmigration-do-not-try-to-migrate-unmapped-anonymous-pages
+++ a/mm/migrate.c
@@ -600,6 +600,17 @@ static int unmap_and_move(new_page_t get
 	if (PageAnon(page)) {
 		rcu_read_lock();
 		rcu_locked = 1;
+
+		/*
+		 * If the page has no mappings any more, just bail. An
+		 * unmapped anon page is likely to be freed soon but worse,
+		 * it's possible its anon_vma disappeared between when
+		 * the page was isolated and when we reached here while
+		 * the RCU lock was not held
+		 */
+		if (!page_mapped(page))
+			goto rcu_unlock;
+
 		anon_vma = page_anon_vma(page);
 		atomic_inc(&anon_vma->external_refcount);
 	}
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mmmigration-take-a-reference-to-the-anon_vma-before-migrating.patch
mmmigration-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mmmigration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mmmigration-allow-the-migration-of-pageswapcache-pages.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mm-export-fragmentation-index-via-debugfs.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mmcompaction-memory-compaction-core.patch
mmcompaction-add-proc-trigger-for-memory-compaction.patch
mmcompaction-add-sys-trigger-for-per-node-memory-compaction.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mmcompaction-defer-compaction-using-an-exponential-backoff-when-compaction-fails.patch
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

