From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:06:46 -0700
Message-ID: <201004221906.o3MJ6kd2002144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403Ab0DVTHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:07:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: compaction: tighten up the allowed values for compact_memory and initialisation
has been removed from the -mm tree.  Its filename was
     mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: tighten up the allowed values for compact_memory and initialisation
From: Mel Gorman <mel@csn.ul.ie>

Update the documentation on compact_memory to only define 1 as an allowed
value in case it needs to be expanded later.  It also changes how a
compact_control structure is initialised to avoid potential trouble in the
future.

This is a fix to the patch "Add /proc trigger for memory compaction".

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    9 ++++-----
 mm/compaction.c             |    9 +++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-compaction-add-proc-trigger-for-memory-compaction-fix Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-compaction-add-proc-trigger-for-memory-compaction-fix
+++ a/Documentation/sysctl/vm.txt
@@ -67,11 +67,10 @@ information on block I/O debugging is in
 
 compact_memory
 
-Available only when CONFIG_COMPACTION is set. When an arbitrary value
-is written to the file, all zones are compacted such that free memory
-is available in contiguous blocks where possible. This can be important
-for example in the allocation of huge pages although processes will also
-directly compact memory as required.
+Available only when CONFIG_COMPACTION is set. When 1 is written to the file,
+all zones are compacted such that free memory is available in contiguous
+blocks where possible. This can be important for example in the allocation of
+huge pages although processes will also directly compact memory as required.
 
 ==============================================================
 
diff -puN mm/compaction.c~mm-compaction-add-proc-trigger-for-memory-compaction-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-proc-trigger-for-memory-compaction-fix
+++ a/mm/compaction.c
@@ -404,15 +404,16 @@ static int compact_node(int nid)
 	lru_add_drain_all();
 
 	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
-		struct compact_control cc;
+		struct compact_control cc = {
+			.nr_freepages = 0,
+			.nr_migratepages = 0,
+			.zone = zone,
+		};
 
 		zone = &pgdat->node_zones[zoneid];
 		if (!populated_zone(zone))
 			continue;
 
-		cc.nr_freepages = 0;
-		cc.nr_migratepages = 0;
-		cc.zone = zone;
 		INIT_LIST_HEAD(&cc.freepages);
 		INIT_LIST_HEAD(&cc.migratepages);
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
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

