From: akpm@linux-foundation.org
Subject: + mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch added to -mm tree
Date: Tue, 06 Apr 2010 17:07:24 -0700
Message-ID: <201004070007.o3707OBC016414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932315Ab0DGAI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 20:08:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: compaction: add a tunable that decides when memory should be compacted and when it should be reclaimed
has been added to the -mm tree.  Its filename is
     mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch

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

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   16 +++++++++++++++-
 include/linux/compaction.h  |    3 +++
 kernel/sysctl.c             |   15 +++++++++++++++
 mm/compaction.c             |   12 +++++++++++-
 4 files changed, 44 insertions(+), 2 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed
+++ a/Documentation/sysctl/vm.txt
@@ -27,6 +27,7 @@ Currently, these files are in /proc/sys/
 - dirty_ratio
 - dirty_writeback_centisecs
 - drop_caches
+- extfrag_threshold
 - hugepages_treat_as_movable
 - hugetlb_shm_group
 - laptop_mode
@@ -132,7 +133,6 @@ out to disk.  This tunable expresses the
 Setting this to zero disables periodic writeback altogether.
 
 ==============================================================
-
 drop_caches
 
 Writing to this will cause the kernel to drop clean caches, dentries and
@@ -150,6 +150,20 @@ user should run `sync' first.
 
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
diff -puN include/linux/compaction.h~mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed
+++ a/include/linux/compaction.h
@@ -11,6 +11,9 @@
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
+extern int sysctl_extfrag_threshold;
+extern int sysctl_extfrag_handler(struct ctl_table *table, int write,
+			void __user *buffer, size_t *length, loff_t *ppos);
 
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
diff -puN kernel/sysctl.c~mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed kernel/sysctl.c
--- a/kernel/sysctl.c~mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed
+++ a/kernel/sysctl.c
@@ -262,6 +262,11 @@ static int min_sched_shares_ratelimit = 
 static int max_sched_shares_ratelimit = NSEC_PER_SEC; /* 1 second */
 #endif
 
+#ifdef CONFIG_COMPACTION
+static int min_extfrag_threshold = 0;
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
diff -puN mm/compaction.c~mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed
+++ a/mm/compaction.c
@@ -418,6 +418,8 @@ static unsigned long compact_zone_order(
 	return compact_zone(zone, &cc);
 }
 
+int sysctl_extfrag_threshold = 500;
+
 /**
  * try_to_compact_pages - Direct compact to satisfy a high-order allocation
  * @zonelist: The zonelist used for the current allocation
@@ -476,7 +478,7 @@ unsigned long try_to_compact_pages(struc
 		 * Only compact if a failure would be due to fragmentation.
 		 */
 		fragindex = fragmentation_index(zone, order);
-		if (fragindex >= 0 && fragindex <= 500)
+		if (fragindex >= 0 && fragindex <= sysctl_extfrag_threshold)
 			continue;
 
 		if (fragindex == -1 && zone_watermark_ok(zone, order, watermark, 0, 0)) {
@@ -556,6 +558,14 @@ int sysctl_compaction_handler(struct ctl
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

