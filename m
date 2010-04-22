From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-export-fragmentation-index-via-proc-extfrag_index-fix.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:06:25 -0700
Message-ID: <201004221906.o3MJ6PTn002111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754738Ab0DVTOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: compaction: move extfrag_index to debugfs
has been removed from the -mm tree.  Its filename was
     mm-export-fragmentation-index-via-proc-extfrag_index-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: move extfrag_index to debugfs
From: Mel Gorman <mel@csn.ul.ie>

extfrag_index can be worked out from userspace but for debugging and
tuning compaction, it'd be best for all users to have the same
information.  This patch moves extfrag_index to debugfs where it is both
easier to configure out and remove at some future date.

This is a fix to the patch "Export fragmentation index via
/proc/extfrag_index".  When merged, it'll collide with the patch "Direct
compact when a high-order allocation fails" but the resolution is
relatively straight forward - preserve the fragmentation_index functions
and delete the proc-related functions as they are now at the bottom of the
file under ifdef CONFIG_DEBUG_FS.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   12 --
 mm/vmstat.c                        |  110 +++++++++++++--------------
 2 files changed, 56 insertions(+), 66 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-export-fragmentation-index-via-proc-extfrag_index-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-export-fragmentation-index-via-proc-extfrag_index-fix
+++ a/Documentation/filesystems/proc.txt
@@ -422,7 +422,6 @@ Table 1-5: Kernel info in /proc
  filesystems Supported filesystems                             
  driver	     Various drivers grouped here, currently rtc (2.4)
  execdomains Execdomains, related to security			(2.4)
- extfrag_index Additional page allocator information (see text) (2.5)
  fb	     Frame Buffer devices				(2.4)
  fs	     File system parameters, currently nfs/exports	(2.4)
  ide         Directory containing info about the IDE subsystem 
@@ -652,17 +651,6 @@ unless memory has been mlock()'d. Some o
 also be allocatable although a lot of filesystem metadata may have to be
 reclaimed to achieve this.
 
-> cat /proc/extfrag_index
-Node 0, zone      DMA -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.00
-Node 0, zone   Normal -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 0.954
-
-The external fragmentation index, is only meaningful if an allocation
-would fail and indicates what the failure is due to. A value of -1 such as
-in many of the examples above states that the allocation would succeed.
-If it would fail, the value is between 0 and 1. A value tending towards
-0 implies the allocation failed due to a lack of memory. A value tending
-towards 1 implies it failed due to external fragmentation.
-
 ..............................................................................
 
 meminfo:
diff -puN mm/vmstat.c~mm-export-fragmentation-index-via-proc-extfrag_index-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-export-fragmentation-index-via-proc-extfrag_index-fix
+++ a/mm/vmstat.c
@@ -523,40 +523,6 @@ int fragmentation_index(unsigned int ord
 	return 1000 - div_u64( (1000+(div_u64(info->free_pages * 1000ULL, requested))), info->free_blocks_total);
 }
 
-
-static void extfrag_show_print(struct seq_file *m,
-					pg_data_t *pgdat, struct zone *zone)
-{
-	unsigned int order;
-	int index;
-
-	/* Alloc on stack as interrupts are disabled for zone walk */
-	struct contig_page_info info;
-
-	seq_printf(m, "Node %d, zone %8s ",
-				pgdat->node_id,
-				zone->name);
-	for (order = 0; order < MAX_ORDER; ++order) {
-		fill_contig_page_info(zone, order, &info);
-		index = fragmentation_index(order, &info);
-		seq_printf(m, "%d.%03d ", index / 1000, index % 1000);
-	}
-
-	seq_putc(m, '\n');
-}
-
-/*
- * Display fragmentation index for orders that allocations would fail for
- */
-static int extfrag_show(struct seq_file *m, void *arg)
-{
-	pg_data_t *pgdat = (pg_data_t *)arg;
-
-	walk_zones_in_node(m, pgdat, extfrag_show_print);
-
-	return 0;
-}
-
 static void pagetypeinfo_showfree_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone)
 {
@@ -707,25 +673,6 @@ static const struct file_operations page
 	.release	= seq_release,
 };
 
-static const struct seq_operations extfrag_op = {
-	.start	= frag_start,
-	.next	= frag_next,
-	.stop	= frag_stop,
-	.show	= extfrag_show,
-};
-
-static int extfrag_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &extfrag_op);
-}
-
-static const struct file_operations extfrag_file_ops = {
-	.open		= extfrag_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 #ifdef CONFIG_ZONE_DMA
 #define TEXT_FOR_DMA(xx) xx "_dma",
 #else
@@ -1070,7 +1017,6 @@ static int __init setup_vmstat(void)
 #ifdef CONFIG_PROC_FS
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
 	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
-	proc_create("extfrag_index", S_IRUGO, NULL, &extfrag_file_ops);
 	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
 	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);
 #endif
@@ -1166,6 +1112,58 @@ static const struct file_operations unus
 	.release	= seq_release,
 };
 
+static void extfrag_show_print(struct seq_file *m,
+					pg_data_t *pgdat, struct zone *zone)
+{
+	unsigned int order;
+	int index;
+
+	/* Alloc on stack as interrupts are disabled for zone walk */
+	struct contig_page_info info;
+
+	seq_printf(m, "Node %d, zone %8s ",
+				pgdat->node_id,
+				zone->name);
+	for (order = 0; order < MAX_ORDER; ++order) {
+		fill_contig_page_info(zone, order, &info);
+		index = fragmentation_index(order, &info);
+		seq_printf(m, "%d.%03d ", index / 1000, index % 1000);
+	}
+
+	seq_putc(m, '\n');
+}
+
+/*
+ * Display fragmentation index for orders that allocations would fail for
+ */
+static int extfrag_show(struct seq_file *m, void *arg)
+{
+	pg_data_t *pgdat = (pg_data_t *)arg;
+
+	walk_zones_in_node(m, pgdat, extfrag_show_print);
+
+	return 0;
+}
+
+static const struct seq_operations extfrag_op = {
+	.start	= frag_start,
+	.next	= frag_next,
+	.stop	= frag_stop,
+	.show	= extfrag_show,
+};
+
+static int extfrag_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &extfrag_op);
+}
+
+static const struct file_operations extfrag_file_ops = {
+	.open		= extfrag_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int __init extfrag_debug_init(void)
 {
 	extfrag_debug_root = debugfs_create_dir("extfrag", NULL);
@@ -1176,6 +1174,10 @@ static int __init extfrag_debug_init(voi
 			extfrag_debug_root, NULL, &unusable_file_ops))
 		return -ENOMEM;
 
+	if (!debugfs_create_file("extfrag_index", 0444,
+			extfrag_debug_root, NULL, &extfrag_file_ops))
+		return -ENOMEM;
+
 	return 0;
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

