From: akpm@linux-foundation.org
Subject: + mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction.patch added to -mm tree
Date: Thu, 06 May 2010 13:22:17 -0700
Message-ID: <201005062022.o46KMHxI011557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756035Ab0EFUXg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 16:23:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, agl@us.ibm.com, avi@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, rientjes@google.com


The patch titled
     mm: compaction: do not schedule work on other CPUs for compaction
has been added to the -mm tree.  Its filename is
     mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction.patch

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
Subject: mm: compaction: do not schedule work on other CPUs for compaction
From: Mel Gorman <mel@csn.ul.ie>

Migration normally requires a call to migrate_prep() as a preparation
step.  This schedules work on all CPUs for pagevecs to be drained.  This
makes sense for move_pages and memory hot-remove but is unnecessary for
memory compaction.

To avoid queueing work on multiple CPUs, this patch introduces
migrate_prep_local() which drains just local pagevecs.

This patch can be either merged with
mmcompaction-memory-compaction-core.patch or placed immediately after it
to clarify why migrate_prep_local() was introduced.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 ++
 mm/compaction.c         |    2 +-
 mm/migrate.c            |   11 ++++++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff -puN include/linux/migrate.h~mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction include/linux/migrate.h
--- a/include/linux/migrate.h~mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction
+++ a/include/linux/migrate.h
@@ -19,6 +19,7 @@ extern int fail_migrate_page(struct addr
 			struct page *, struct page *);
 
 extern int migrate_prep(void);
+extern int migrate_prep_local(void);
 extern int migrate_vmas(struct mm_struct *mm,
 		const nodemask_t *from, const nodemask_t *to,
 		unsigned long flags);
@@ -30,6 +31,7 @@ static inline int migrate_pages(struct l
 		unsigned long private, int offlining) { return -ENOSYS; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
+static inline int migrate_prep_local(void) { return -ENOSYS; }
 
 static inline int migrate_vmas(struct mm_struct *mm,
 		const nodemask_t *from, const nodemask_t *to,
diff -puN mm/compaction.c~mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction mm/compaction.c
--- a/mm/compaction.c~mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction
+++ a/mm/compaction.c
@@ -358,7 +358,7 @@ static int compact_zone(struct zone *zon
 	cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
 	cc->free_pfn &= ~(pageblock_nr_pages-1);
 
-	migrate_prep();
+	migrate_prep_local();
 
 	while ((ret = compact_finished(zone, cc)) == COMPACT_CONTINUE) {
 		unsigned long nr_migrate, nr_remaining;
diff -puN mm/migrate.c~mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction mm/migrate.c
--- a/mm/migrate.c~mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction
+++ a/mm/migrate.c
@@ -40,7 +40,8 @@
 
 /*
  * migrate_prep() needs to be called before we start compiling a list of pages
- * to be migrated using isolate_lru_page().
+ * to be migrated using isolate_lru_page(). If scheduling work on other CPUs is
+ * undesirable, use migrate_prep_local()
  */
 int migrate_prep(void)
 {
@@ -55,6 +56,14 @@ int migrate_prep(void)
 	return 0;
 }
 
+/* Do the necessary work of migrate_prep but not if it involves other CPUs */
+int migrate_prep_local(void)
+{
+	lru_add_drain();
+
+	return 0;
+}
+
 /*
  * Add isolated pages on the list back to the LRU under page lock
  * to avoid leaking evictable pages back onto unevictable list.
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
rmap-remove-anon_vma-check-in-page_address_in_vma.patch
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
mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction.patch
mmcompaction-add-proc-trigger-for-memory-compaction.patch
mmcompaction-add-sys-trigger-for-per-node-memory-compaction.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails-fix.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mmcompaction-defer-compaction-using-an-exponential-backoff-when-compaction-fails.patch
mm-introduce-free_pages_prepare.patch
mm-introduce-free_pages_prepare-fix.patch
vmscan-fix-unmapping-behaviour-for-reclaim_swap.patch
vmscan-remove-may_unmap-scan-control.patch
vmscan-remove-all_unreclaimable-scan-control.patch
vmscan-remove-isolate_pages-callback-scan-control.patch
vmscan-remove-may_swap-scan-control.patch
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

