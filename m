From: akpm@linux-foundation.org
Subject: + mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch added to -mm tree
Date: Mon, 22 Nov 2010 12:06:33 -0800
Message-ID: <201011222006.oAMK6Xej006901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757460Ab0KVUHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 15:07:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, apw@shadowen.org, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm: migration: cleanup migrate_pages API by matching types for offlining and sync
has been added to the -mm tree.  Its filename is
     mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch

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
Subject: mm: migration: cleanup migrate_pages API by matching types for offlining and sync
From: Mel Gorman <mel@csn.ul.ie>

With the introduction of the boolean sync parameter, the API looks a
little inconsistent as offlining is still an int.  Convert offlining to a
bool for the sake of being tidy.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    8 ++++----
 mm/compaction.c         |    2 +-
 mm/memory_hotplug.c     |    2 +-
 mm/mempolicy.c          |    6 ++++--
 mm/migrate.c            |    8 ++++----
 5 files changed, 14 insertions(+), 12 deletions(-)

diff -puN include/linux/migrate.h~mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync
+++ a/include/linux/migrate.h
@@ -13,10 +13,10 @@ extern void putback_lru_pages(struct lis
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *);
 extern int migrate_pages(struct list_head *l, new_page_t x,
-			unsigned long private, int offlining,
+			unsigned long private, bool offlining,
 			bool sync);
 extern int migrate_huge_pages(struct list_head *l, new_page_t x,
-			unsigned long private, int offlining,
+			unsigned long private, bool offlining,
 			bool sync);
 
 extern int fail_migrate_page(struct address_space *,
@@ -35,10 +35,10 @@ extern int migrate_huge_page_move_mappin
 
 static inline void putback_lru_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
-		unsigned long private, int offlining,
+		unsigned long private, bool offlining,
 		bool sync) { return -ENOSYS; }
 static inline int migrate_huge_pages(struct list_head *l, new_page_t x,
-		unsigned long private, int offlining,
+		unsigned long private, bool offlining,
 		bool sync) { return -ENOSYS; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
diff -puN mm/compaction.c~mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync mm/compaction.c
--- a/mm/compaction.c~mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync
+++ a/mm/compaction.c
@@ -457,7 +457,7 @@ static int compact_zone(struct zone *zon
 
 		nr_migrate = cc->nr_migratepages;
 		migrate_pages(&cc->migratepages, compaction_alloc,
-				(unsigned long)cc, 0,
+				(unsigned long)cc, false,
 				cc->sync);
 		update_nr_listpages(cc);
 		nr_remaining = cc->nr_migratepages;
diff -puN mm/memory_hotplug.c~mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync
+++ a/mm/memory_hotplug.c
@@ -715,7 +715,7 @@ do_migrate_range(unsigned long start_pfn
 		}
 		/* this function returns # of failed pages */
 		ret = migrate_pages(&source, hotremove_migrate_alloc, 0,
-								1, true);
+								true, true);
 		if (ret)
 			putback_lru_pages(&source);
 	}
diff -puN mm/mempolicy.c~mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync mm/mempolicy.c
--- a/mm/mempolicy.c~mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync
+++ a/mm/mempolicy.c
@@ -935,7 +935,8 @@ static int migrate_to_node(struct mm_str
 		return PTR_ERR(vma);
 
 	if (!list_empty(&pagelist)) {
-		err = migrate_pages(&pagelist, new_node_page, dest, 0, true);
+		err = migrate_pages(&pagelist, new_node_page, dest,
+								false, true);
 		if (err)
 			putback_lru_pages(&pagelist);
 	}
@@ -1155,7 +1156,8 @@ static long do_mbind(unsigned long start
 
 		if (!list_empty(&pagelist)) {
 			nr_failed = migrate_pages(&pagelist, new_vma_page,
-						(unsigned long)vma, 0, true);
+						(unsigned long)vma,
+						false, true);
 			if (nr_failed)
 				putback_lru_pages(&pagelist);
 		}
diff -puN mm/migrate.c~mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync mm/migrate.c
--- a/mm/migrate.c~mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync
+++ a/mm/migrate.c
@@ -612,7 +612,7 @@ static int move_to_new_page(struct page 
  * to the newly allocated page in newpage.
  */
 static int unmap_and_move(new_page_t get_new_page, unsigned long private,
-			struct page *page, int force, int offlining, bool sync)
+			struct page *page, int force, bool offlining, bool sync)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -808,7 +808,7 @@ move_newpage:
  */
 static int unmap_and_move_huge_page(new_page_t get_new_page,
 				unsigned long private, struct page *hpage,
-				int force, int offlining, bool sync)
+				int force, bool offlining, bool sync)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -890,7 +890,7 @@ out:
  * Return: Number of pages not migrated or error code.
  */
 int migrate_pages(struct list_head *from,
-		new_page_t get_new_page, unsigned long private, int offlining,
+		new_page_t get_new_page, unsigned long private, bool offlining,
 		bool sync)
 {
 	int retry = 1;
@@ -941,7 +941,7 @@ out:
 }
 
 int migrate_huge_pages(struct list_head *from,
-		new_page_t get_new_page, unsigned long private, int offlining,
+		new_page_t get_new_page, unsigned long private, bool offlining,
 		bool sync)
 {
 	int retry = 1;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
mm-remove-call-to-find_vma-in-pagewalk-for-non-hugetlbfs.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
add-debugging-aid-for-memory-initialisation-problems.patch

