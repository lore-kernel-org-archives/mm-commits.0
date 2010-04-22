From: akpm@linux-foundation.org
Subject: + mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch added to -mm tree
Date: Thu, 22 Apr 2010 12:34:00 -0700
Message-ID: <201004221934.o3MJY0FH003689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756945Ab0DVTeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, randy.dunlap@oracle.com, riel@redhat.com


The patch titled
     mm: compaction: add a tunable that decides when memory should be compacted and when it should be reclaimed
has been added to the -mm tree.  Its filename is
     mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch

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
Subject: mm: compaction: add a tunable that decides when memory should be compacted and when it should be reclaimed
From: Mel Gorman <mel@csn.ul.ie>

The kernel applies some heuristics when deciding if memory should be
compacted or reclaimed to satisfy a high-order allocation.  One of these
is based on the fragmentation.  If the index is below 500, memory will not
be compacted.  This choice is arbitrary and not based on data.  To help
optimise the system and set a sensible default for this value, this patch
adds a sysctl extfrag_threshold.  The kernel will only compact memory if
the fragmentation index is above the extfrag_threshold.

[randy.dunlap@oracle.com: Fix build errors when proc fs is not configured]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   15 +++++++++++++++
 include/linux/compaction.h  |    3 +++
 kernel/sysctl.c             |   15 +++++++++++++++
 mm/compaction.c             |   12 +++++++++++-
 4 files changed, 44 insertions(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed
+++ a/Documentation/sysctl/vm.txt
@@ -27,6 +27,7 @@ Currently, these files are in /proc/sys/
 - dirty_ratio
 - dirty_writeback_centisecs
 - drop_caches
+- extfrag_threshold
 - hugepages_treat_as_movable
 - hugetlb_shm_group
 - laptop_mode
@@ -149,6 +150,20 @@ user should run `sync' first.
 
 ==============================================================
 
+extfrag_threshold
+
+This parameter affects whether the kernel will compact memory or direct
+reclaim to satisfy a high-order allocation. /proc/extfrag_index shows what
+the fragmentation index for each order is in each zone in the system. Values
+tending towards 0 imply allocations would fail due to lack of memory,
+values towards 1000 imply failures are due to fragmentation and -1 implies
+that the allocation will succeed as long as watermarks are met.
+
+The kernel will not compact memory in a zone if the
+fragmentation index is <= extfrag_threshold. The default value is 500.
+
+==============================================================
+
 hugepages_treat_as_movable
 
 This parameter is only useful when kernelcore= is specified at boot time to
diff -puN include/linux/compaction.h~mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed include/linux/compaction.h
--- a/include/linux/compaction.h~mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed
+++ a/include/linux/compaction.h
@@ -15,6 +15,9 @@
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
+extern int sysctl_extfrag_threshold;
+extern int sysctl_extfrag_handler(struct ctl_table *table, int write,
+			void __user *buffer, size_t *length, loff_t *ppos);
 
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
diff -puN kernel/sysctl.c~mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed kernel/sysctl.c
--- a/kernel/sysctl.c~mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed
+++ a/kernel/sysctl.c
@@ -262,6 +262,11 @@ static int min_sched_shares_ratelimit = 
 static int max_sched_shares_ratelimit = NSEC_PER_SEC; /* 1 second */
 #endif
 
+#ifdef CONFIG_COMPACTION
+static int min_extfrag_threshold;
+static int max_extfrag_threshold = 1000;
+#endif
+
 static struct ctl_table kern_table[] = {
 	{
 		.procname	= "sched_child_runs_first",
@@ -1130,6 +1135,16 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0200,
 		.proc_handler	= sysctl_compaction_handler,
 	},
+	{
+		.procname	= "extfrag_threshold",
+		.data		= &sysctl_extfrag_threshold,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_extfrag_handler,
+		.extra1		= &min_extfrag_threshold,
+		.extra2		= &max_extfrag_threshold,
+	},
+
 #endif /* CONFIG_COMPACTION */
 	{
 		.procname	= "min_free_kbytes",
diff -puN mm/compaction.c~mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed mm/compaction.c
--- a/mm/compaction.c~mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed
+++ a/mm/compaction.c
@@ -433,6 +433,8 @@ static unsigned long compact_zone_order(
 	return compact_zone(zone, &cc);
 }
 
+int sysctl_extfrag_threshold = 500;
+
 /**
  * try_to_compact_pages - Direct compact to satisfy a high-order allocation
  * @zonelist: The zonelist used for the current allocation
@@ -491,7 +493,7 @@ unsigned long try_to_compact_pages(struc
 		 * Only compact if a failure would be due to fragmentation.
 		 */
 		fragindex = fragmentation_index(zone, order);
-		if (fragindex >= 0 && fragindex <= 500)
+		if (fragindex >= 0 && fragindex <= sysctl_extfrag_threshold)
 			continue;
 
 		if (fragindex == -1 && zone_watermark_ok(zone, order, watermark, 0, 0)) {
@@ -572,6 +574,14 @@ int sysctl_compaction_handler(struct ctl
 	return 0;
 }
 
+int sysctl_extfrag_handler(struct ctl_table *table, int write,
+			void __user *buffer, size_t *length, loff_t *ppos)
+{
+	proc_dointvec_minmax(table, write, buffer, length, ppos);
+
+	return 0;
+}
+
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
 ssize_t sysfs_compact_node(struct sys_device *dev,
 			struct sysdev_attribute *attr,
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

