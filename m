From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-compaction-add-proc-trigger-for-memory-compaction.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:06:44 -0700
Message-ID: <201004221906.o3MJ6iRD002141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755371Ab0DVTH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:07:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: compaction: add /proc trigger for memory compaction
has been removed from the -mm tree.  Its filename was
     mm-compaction-add-proc-trigger-for-memory-compaction.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: add /proc trigger for memory compaction
From: Mel Gorman <mel@csn.ul.ie>

This patch adds a proc file /proc/sys/vm/compact_memory.  When an
arbitrary value is written to the file, all zones are compacted.  The
expected user of such a trigger is a job scheduler that prepares the
system before the target application runs.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   11 ++++++
 include/linux/compaction.h  |    6 +++
 kernel/sysctl.c             |   10 +++++
 mm/compaction.c             |   62 +++++++++++++++++++++++++++++++++-
 4 files changed, 88 insertions(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mm-compaction-add-proc-trigger-for-memory-compaction Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-compaction-add-proc-trigger-for-memory-compaction
+++ a/Documentation/sysctl/vm.txt
@@ -19,6 +19,7 @@ files can be found in mm/swap.c.
 Currently, these files are in /proc/sys/vm:
 
 - block_dump
+- compact_memory
 - dirty_background_bytes
 - dirty_background_ratio
 - dirty_bytes
@@ -64,6 +65,16 @@ information on block I/O debugging is in
 
 ==============================================================
 
+compact_memory
+
+Available only when CONFIG_COMPACTION is set. When an arbitrary value
+is written to the file, all zones are compacted such that free memory
+is available in contiguous blocks where possible. This can be important
+for example in the allocation of huge pages although processes will also
+directly compact memory as required.
+
+==============================================================
+
 dirty_background_bytes
 
 Contains the amount of dirty memory at which the pdflush background writeback
diff -puN include/linux/compaction.h~mm-compaction-add-proc-trigger-for-memory-compaction include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-add-proc-trigger-for-memory-compaction
+++ a/include/linux/compaction.h
@@ -6,4 +6,10 @@
 #define COMPACT_PARTIAL		1
 #define COMPACT_COMPLETE	2
 
+#ifdef CONFIG_COMPACTION
+extern int sysctl_compact_memory;
+extern int sysctl_compaction_handler(struct ctl_table *table, int write,
+			void __user *buffer, size_t *length, loff_t *ppos);
+#endif /* CONFIG_COMPACTION */
+
 #endif /* _LINUX_COMPACTION_H */
diff -puN kernel/sysctl.c~mm-compaction-add-proc-trigger-for-memory-compaction kernel/sysctl.c
--- a/kernel/sysctl.c~mm-compaction-add-proc-trigger-for-memory-compaction
+++ a/kernel/sysctl.c
@@ -37,6 +37,7 @@
 #include <linux/highuid.h>
 #include <linux/writeback.h>
 #include <linux/ratelimit.h>
+#include <linux/compaction.h>
 #include <linux/hugetlb.h>
 #include <linux/initrd.h>
 #include <linux/key.h>
@@ -1121,6 +1122,15 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= drop_caches_sysctl_handler,
 	},
+#ifdef CONFIG_COMPACTION
+	{
+		.procname	= "compact_memory",
+		.data		= &sysctl_compact_memory,
+		.maxlen		= sizeof(int),
+		.mode		= 0200,
+		.proc_handler	= sysctl_compaction_handler,
+	},
+#endif /* CONFIG_COMPACTION */
 	{
 		.procname	= "min_free_kbytes",
 		.data		= &min_free_kbytes,
diff -puN mm/compaction.c~mm-compaction-add-proc-trigger-for-memory-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-proc-trigger-for-memory-compaction
+++ a/mm/compaction.c
@@ -12,6 +12,7 @@
 #include <linux/compaction.h>
 #include <linux/mm_inline.h>
 #include <linux/backing-dev.h>
+#include <linux/sysctl.h>
 #include "internal.h"
 
 /*
@@ -322,7 +323,7 @@ static void update_nr_listpages(struct c
 	cc->nr_freepages = nr_freepages;
 }
 
-static inline int compact_finished(struct zone *zone,
+static int compact_finished(struct zone *zone,
 						struct compact_control *cc)
 {
 	if (fatal_signal_pending(current))
@@ -377,3 +378,62 @@ static int compact_zone(struct zone *zon
 	return ret;
 }
 
+/* Compact all zones within a node */
+static int compact_node(int nid)
+{
+	int zoneid;
+	pg_data_t *pgdat;
+	struct zone *zone;
+
+	if (nid < 0 || nid >= nr_node_ids || !node_online(nid))
+		return -EINVAL;
+	pgdat = NODE_DATA(nid);
+
+	/* Flush pending updates to the LRU lists */
+	lru_add_drain_all();
+
+	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
+		struct compact_control cc;
+
+		zone = &pgdat->node_zones[zoneid];
+		if (!populated_zone(zone))
+			continue;
+
+		cc.nr_freepages = 0;
+		cc.nr_migratepages = 0;
+		cc.zone = zone;
+		INIT_LIST_HEAD(&cc.freepages);
+		INIT_LIST_HEAD(&cc.migratepages);
+
+		compact_zone(zone, &cc);
+
+		VM_BUG_ON(!list_empty(&cc.freepages));
+		VM_BUG_ON(!list_empty(&cc.migratepages));
+	}
+
+	return 0;
+}
+
+/* Compact all nodes in the system */
+static int compact_nodes(void)
+{
+	int nid;
+
+	for_each_online_node(nid)
+		compact_node(nid);
+
+	return COMPACT_COMPLETE;
+}
+
+/* The written value is actually unused, all memory is compacted */
+int sysctl_compact_memory;
+
+/* This is the entry point for compacting all nodes via /proc/sys/vm */
+int sysctl_compaction_handler(struct ctl_table *table, int write,
+			void __user *buffer, size_t *length, loff_t *ppos)
+{
+	if (write)
+		return compact_nodes();
+
+	return 0;
+}
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
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

