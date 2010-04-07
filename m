From: akpm@linux-foundation.org
Subject: + mm-export-fragmentation-index-via-proc-extfrag_index.patch added to -mm tree
Date: Tue, 06 Apr 2010 17:07:06 -0700
Message-ID: <201004070007.o37076At016387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932299Ab0DGAHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 20:07:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: export fragmentation index via /proc/extfrag_index
has been added to the -mm tree.  Its filename is
     mm-export-fragmentation-index-via-proc-extfrag_index.patch

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
Subject: mm: export fragmentation index via /proc/extfrag_index
From: Mel Gorman <mel@csn.ul.ie>

Fragmentation index is a value that makes sense when an allocation of a
given size would fail.  The index indicates whether an allocation failure
is due to a lack of memory (values towards 0) or due to external
fragmentation (value towards 1).  For the most part, the huge page size
will be the size of interest but not necessarily so it is exported on a
per-order and per-zone basis via /proc/extfrag_index

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   14 ++++
 mm/vmstat.c                        |   82 +++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~mm-export-fragmentation-index-via-proc-extfrag_index Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-export-fragmentation-index-via-proc-extfrag_index
+++ a/Documentation/filesystems/proc.txt
@@ -422,6 +422,7 @@ Table 1-5: Kernel info in /proc
  filesystems Supported filesystems                             
  driver	     Various drivers grouped here, currently rtc (2.4)
  execdomains Execdomains, related to security			(2.4)
+ extfrag_index Additional page allocator information (see text) (2.5)
  fb	     Frame Buffer devices				(2.4)
  fs	     File system parameters, currently nfs/exports	(2.4)
  ide         Directory containing info about the IDE subsystem 
@@ -611,7 +612,7 @@ ZONE_DMA, 4 chunks of 2^1*PAGE_SIZE in Z
 available in ZONE_NORMAL, etc... 
 
 More information relevant to external fragmentation can be found in
-pagetypeinfo and unusable_index
+pagetypeinfo, unusable_index and extfrag_index.
 
 > cat /proc/pagetypeinfo
 Page block order: 9
@@ -662,6 +663,17 @@ value between 0 and 1. The higher the va
 unusable and by implication, the worse the external fragmentation is. This
 can be expressed as a percentage by multiplying by 100.
 
+> cat /proc/extfrag_index
+Node 0, zone      DMA -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.00
+Node 0, zone   Normal -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 -1.000 0.954
+
+The external fragmentation index, is only meaningful if an allocation
+would fail and indicates what the failure is due to. A value of -1 such as
+in many of the examples above states that the allocation would succeed.
+If it would fail, the value is between 0 and 1. A value tending towards
+0 implies the allocation failed due to a lack of memory. A value tending
+towards 1 implies it failed due to external fragmentation.
+
 ..............................................................................
 
 meminfo:
diff -puN mm/vmstat.c~mm-export-fragmentation-index-via-proc-extfrag_index mm/vmstat.c
--- a/mm/vmstat.c~mm-export-fragmentation-index-via-proc-extfrag_index
+++ a/mm/vmstat.c
@@ -16,6 +16,7 @@
 #include <linux/cpu.h>
 #include <linux/vmstat.h>
 #include <linux/sched.h>
+#include <linux/math64.h>
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
@@ -554,6 +555,67 @@ static int unusable_show(struct seq_file
 	return 0;
 }
 
+/*
+ * A fragmentation index only makes sense if an allocation of a requested
+ * size would fail. If that is true, the fragmentation index indicates
+ * whether external fragmentation or a lack of memory was the problem.
+ * The value can be used to determine if page reclaim or compaction
+ * should be used
+ */
+int fragmentation_index(unsigned int order, struct contig_page_info *info)
+{
+	unsigned long requested = 1UL << order;
+
+	if (!info->free_blocks_total)
+		return 0;
+
+	/* Fragmentation index only makes sense when a request would fail */
+	if (info->free_blocks_suitable)
+		return -1000;
+
+	/*
+	 * Index is between 0 and 1 so return within 3 decimal places
+	 *
+	 * 0 => allocation would fail due to lack of memory
+	 * 1 => allocation would fail due to fragmentation
+	 */
+	return 1000 - div_u64( (1000+(div_u64(info->free_pages * 1000ULL, requested))), info->free_blocks_total);
+}
+
+
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
 static void pagetypeinfo_showfree_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone)
 {
@@ -723,6 +785,25 @@ static const struct file_operations unus
 	.release	= seq_release,
 };
 
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
 #ifdef CONFIG_ZONE_DMA
 #define TEXT_FOR_DMA(xx) xx "_dma",
 #else
@@ -1068,6 +1149,7 @@ static int __init setup_vmstat(void)
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
 	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
 	proc_create("unusable_index", S_IRUGO, NULL, &unusable_file_ops);
+	proc_create("extfrag_index", S_IRUGO, NULL, &extfrag_file_ops);
 	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
 	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);
 #endif
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

