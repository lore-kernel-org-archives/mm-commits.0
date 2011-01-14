From: akpm@linux-foundation.org
Subject: [merged] mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:59 -0800
Message-ID: <201101142247.p0EMln7I005040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab1ANWsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, apw@shadowen.org, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: migration: cleanup migrate_pages API by matching types for offlining and sync
has been removed from the -mm tree.  Its filename was
     mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -456,7 +456,7 @@ static int compact_zone(struct zone *zon
 
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
@@ -734,7 +734,7 @@ do_migrate_range(unsigned long start_pfn
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
@@ -614,7 +614,7 @@ static int move_to_new_page(struct page 
  * to the newly allocated page in newpage.
  */
 static int unmap_and_move(new_page_t get_new_page, unsigned long private,
-			struct page *page, int force, int offlining, bool sync)
+			struct page *page, int force, bool offlining, bool sync)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -827,7 +827,7 @@ move_newpage:
  */
 static int unmap_and_move_huge_page(new_page_t get_new_page,
 				unsigned long private, struct page *hpage,
-				int force, int offlining, bool sync)
+				int force, bool offlining, bool sync)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -909,7 +909,7 @@ out:
  * Return: Number of pages not migrated or error code.
  */
 int migrate_pages(struct list_head *from,
-		new_page_t get_new_page, unsigned long private, int offlining,
+		new_page_t get_new_page, unsigned long private, bool offlining,
 		bool sync)
 {
 	int retry = 1;
@@ -960,7 +960,7 @@ out:
 }
 
 int migrate_huge_pages(struct list_head *from,
-		new_page_t get_new_page, unsigned long private, int offlining,
+		new_page_t get_new_page, unsigned long private, bool offlining,
 		bool sync)
 {
 	int retry = 1;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
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
thp-add-pagetranscompound.patch
add-debugging-aid-for-memory-initialisation-problems.patch

