From: akpm@linux-foundation.org
Subject: + mm-export-unusable-free-space-index-via-proc-unusable_index.patch added to -mm tree
Date: Tue, 06 Apr 2010 17:07:02 -0700
Message-ID: <201004070007.o37073GV016384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932283Ab0DGAHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 20:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: export unusable free space index via /proc/unusable_index
has been added to the -mm tree.  Its filename is
     mm-export-unusable-free-space-index-via-proc-unusable_index.patch

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
Subject: mm: export unusable free space index via /proc/unusable_index
From: Mel Gorman <mel@csn.ul.ie>

Unusable free space index is a measure of external fragmentation that
takes the allocation size into account.  For the most part, the huge page
size will be the size of interest but not necessarily so it is exported on
a per-order and per-zone basis via /proc/unusable_index.

The index is a value between 0 and 1.  It can be expressed as a percentage
by multiplying by 100 as documented in Documentation/filesystems/proc.txt.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   13 ++
 mm/vmstat.c                        |  120 +++++++++++++++++++++++++++
 2 files changed, 132 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~mm-export-unusable-free-space-index-via-proc-unusable_index Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-export-unusable-free-space-index-via-proc-unusable_index
+++ a/Documentation/filesystems/proc.txt
@@ -453,6 +453,7 @@ Table 1-5: Kernel info in /proc
  sys         See chapter 2                                     
  sysvipc     Info of SysVIPC Resources (msg, sem, shm)		(2.4)
  tty	     Info of tty drivers
+ unusable_index Additional page allocator information (see text)(2.5)
  uptime      System uptime                                     
  version     Kernel version                                    
  video	     bttv info of video resources			(2.4)
@@ -610,7 +611,7 @@ ZONE_DMA, 4 chunks of 2^1*PAGE_SIZE in Z
 available in ZONE_NORMAL, etc... 
 
 More information relevant to external fragmentation can be found in
-pagetypeinfo.
+pagetypeinfo and unusable_index
 
 > cat /proc/pagetypeinfo
 Page block order: 9
@@ -651,6 +652,16 @@ unless memory has been mlock()'d. Some o
 also be allocatable although a lot of filesystem metadata may have to be
 reclaimed to achieve this.
 
+> cat /proc/unusable_index
+Node 0, zone      DMA 0.000 0.000 0.000 0.001 0.005 0.013 0.021 0.037 0.037 0.101 0.230
+Node 0, zone   Normal 0.000 0.000 0.000 0.001 0.002 0.002 0.005 0.015 0.028 0.028 0.054
+
+The unusable free space index measures how much of the available free
+memory cannot be used to satisfy an allocation of a given size and is a
+value between 0 and 1. The higher the value, the more of free memory is
+unusable and by implication, the worse the external fragmentation is. This
+can be expressed as a percentage by multiplying by 100.
+
 ..............................................................................
 
 meminfo:
diff -puN mm/vmstat.c~mm-export-unusable-free-space-index-via-proc-unusable_index mm/vmstat.c
--- a/mm/vmstat.c~mm-export-unusable-free-space-index-via-proc-unusable_index
+++ a/mm/vmstat.c
@@ -454,6 +454,106 @@ static int frag_show(struct seq_file *m,
 	return 0;
 }
 
+
+struct contig_page_info {
+	unsigned long free_pages;
+	unsigned long free_blocks_total;
+	unsigned long free_blocks_suitable;
+};
+
+/*
+ * Calculate the number of free pages in a zone, how many contiguous
+ * pages are free and how many are large enough to satisfy an allocation of
+ * the target size. Note that this function makes no attempt to estimate
+ * how many suitable free blocks there *might* be if MOVABLE pages were
+ * migrated. Calculating that is possible, but expensive and can be
+ * figured out from userspace
+ */
+static void fill_contig_page_info(struct zone *zone,
+				unsigned int suitable_order,
+				struct contig_page_info *info)
+{
+	unsigned int order;
+
+	info->free_pages = 0;
+	info->free_blocks_total = 0;
+	info->free_blocks_suitable = 0;
+
+	for (order = 0; order < MAX_ORDER; order++) {
+		unsigned long blocks;
+
+		/* Count number of free blocks */
+		blocks = zone->free_area[order].nr_free;
+		info->free_blocks_total += blocks;
+
+		/* Count free base pages */
+		info->free_pages += blocks << order;
+
+		/* Count the suitable free blocks */
+		if (order >= suitable_order)
+			info->free_blocks_suitable += blocks <<
+						(order - suitable_order);
+	}
+}
+
+/*
+ * Return an index indicating how much of the available free memory is
+ * unusable for an allocation of the requested size.
+ */
+static int unusable_free_index(unsigned int order,
+				struct contig_page_info *info)
+{
+	/* No free memory is interpreted as all free memory is unusable */
+	if (info->free_pages == 0)
+		return 1000;
+
+	/*
+	 * Index should be a value between 0 and 1. Return a value to 3
+	 * decimal places.
+	 *
+	 * 0 => no fragmentation
+	 * 1 => high fragmentation
+	 */
+	return div_u64((info->free_pages - (info->free_blocks_suitable << order)) * 1000ULL, info->free_pages);
+
+}
+
+static void unusable_show_print(struct seq_file *m,
+					pg_data_t *pgdat, struct zone *zone)
+{
+	unsigned int order;
+	int index;
+	struct contig_page_info info;
+
+	seq_printf(m, "Node %d, zone %8s ",
+				pgdat->node_id,
+				zone->name);
+	for (order = 0; order < MAX_ORDER; ++order) {
+		fill_contig_page_info(zone, order, &info);
+		index = unusable_free_index(order, &info);
+		seq_printf(m, "%d.%03d ", index / 1000, index % 1000);
+	}
+
+	seq_putc(m, '\n');
+}
+
+/*
+ * Display unusable free space index
+ * XXX: Could be a lot more efficient, but it's not a critical path
+ */
+static int unusable_show(struct seq_file *m, void *arg)
+{
+	pg_data_t *pgdat = (pg_data_t *)arg;
+
+	/* check memoryless node */
+	if (!node_state(pgdat->node_id, N_HIGH_MEMORY))
+		return 0;
+
+	walk_zones_in_node(m, pgdat, unusable_show_print);
+
+	return 0;
+}
+
 static void pagetypeinfo_showfree_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone)
 {
@@ -604,6 +704,25 @@ static const struct file_operations page
 	.release	= seq_release,
 };
 
+static const struct seq_operations unusable_op = {
+	.start	= frag_start,
+	.next	= frag_next,
+	.stop	= frag_stop,
+	.show	= unusable_show,
+};
+
+static int unusable_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &unusable_op);
+}
+
+static const struct file_operations unusable_file_ops = {
+	.open		= unusable_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 #ifdef CONFIG_ZONE_DMA
 #define TEXT_FOR_DMA(xx) xx "_dma",
 #else
@@ -948,6 +1067,7 @@ static int __init setup_vmstat(void)
 #ifdef CONFIG_PROC_FS
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
 	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
+	proc_create("unusable_index", S_IRUGO, NULL, &unusable_file_ops);
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

