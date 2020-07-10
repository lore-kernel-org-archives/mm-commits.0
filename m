From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vmstat-add-events-for-thp-migration-without-split-fix-2.patch added to
 -mm tree
Date: Thu, 09 Jul 2020 17:27:09 -0700
Message-ID: <20200710002709.j0TcbIj7X%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbgGJA1L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 20:27:11 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, daniel.m.jordan@oracle.com, hughd@google.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, rdunlap@infradead.org, willy@infradead.org, ziy@nvidia.com


The patch titled
     Subject: mm-vmstat-add-events-for-thp-migration-without-split-fix-2
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-events-for-thp-migration-without-split-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-add-events-for-thp-migration-without-split-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-add-events-for-thp-migration-without-split-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm-vmstat-add-events-for-thp-migration-without-split-fix-2

- Changed THP_MIGRATION_FAILURE as THP_MIGRATION_FAIL per John
- Dropped all conditional 'if' blocks in migrate_pages() per Andrew and John
- Updated migration events documentation per John
- Updated thp_nr_pages variable as nr_subpages for an expected merge conflict
- Moved all new THP vmstat events into CONFIG_MIGRATION
- Updated Cc list with Documentation/ and tracing related addresses

Link: http://lkml.kernel.org/r/C5E3C65C-8253-4638-9D3C-71A61858BB8B@nvidia.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_migration.rst |   40 +++++++++++++++-----------
 include/linux/vm_event_item.h       |    6 +--
 mm/migrate.c                        |   25 ++++++----------
 mm/vmstat.c                         |    6 +--
 4 files changed, 40 insertions(+), 37 deletions(-)

--- a/Documentation/vm/page_migration.rst~mm-vmstat-add-events-for-thp-migration-without-split-fix-2
+++ a/Documentation/vm/page_migration.rst
@@ -253,24 +253,32 @@ which are function pointers of struct ad
      PG_isolated is alias with PG_reclaim flag so driver shouldn't use the flag
      for own purpose.
 
-Quantifying Migration
+Monitoring Migration
 =====================
-Following events can be used to quantify page migration.
 
-1. PGMIGRATE_SUCCESS       /* Normal page migration success */
-2. PGMIGRATE_FAIL          /* Normal page migration failure */
-3. THP_MIGRATION_SUCCESS   /* Transparent huge page migration success */
-4. THP_MIGRATION_FAILURE   /* Transparent huge page migration failure */
-5. THP_MIGRATION_SPLIT     /* Transparent huge page got split, retried */
-
-THP_MIGRATION_SUCCESS is when THP is migrated successfully without getting
-split into it's subpages. THP_MIGRATION_FAILURE is when THP could neither
-be migrated nor be split. THP_MIGRATION_SPLIT is when THP could not
-just be migrated as is but instead get split into it's subpages and later
-retried as normal pages. THP events would also update normal page migration
-statistics PGMIGRATE_SUCCESS and PGMIGRATE_FAILURE. These events will help
-in quantifying and analyzing various THP migration events including both
-success and failure cases.
+The following events (counters) can be used to monitor page migration.
+
+1. PGMIGRATE_SUCCESS: Normal page migration success. Each count means that a
+   page was migrated. If the page was a non-THP page, then this counter is
+   increased by one. If the page was a THP, then this counter is increased by
+   the number of THP subpages. For example, migration of a single 2MB THP that
+   has 4KB-size base pages (subpages) will cause this counter to increase by
+   512.
+
+2. PGMIGRATE_FAIL: Normal page migration failure. Same counting rules as for
+   _SUCCESS, above: this will be increased by the number of subpages, if it was
+   a THP.
+
+3. THP_MIGRATION_SUCCESS: A THP was migrated without being split.
+
+4. THP_MIGRATION_FAIL: A THP could not be migrated nor it could be split.
+
+5. THP_MIGRATION_SPLIT: A THP was migrated, but not as such: first, the THP had
+   to be split. After splitting, a migration retry was used for it's sub-pages.
+
+THP_MIGRATION_* events also update the appropriate PGMIGRATE_SUCCESS or
+PGMIGRATE_FAIL events. For example, a THP migration failure will cause both
+THP_MIGRATION_FAIL and PGMIGRATE_FAIL to increase.
 
 Christoph Lameter, May 8, 2006.
 Minchan Kim, Mar 28, 2016.
--- a/include/linux/vm_event_item.h~mm-vmstat-add-events-for-thp-migration-without-split-fix-2
+++ a/include/linux/vm_event_item.h
@@ -56,6 +56,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #endif
 #ifdef CONFIG_MIGRATION
 		PGMIGRATE_SUCCESS, PGMIGRATE_FAIL,
+		THP_MIGRATION_SUCCESS,
+		THP_MIGRATION_FAIL,
+		THP_MIGRATION_SPLIT,
 #endif
 #ifdef CONFIG_COMPACTION
 		COMPACTMIGRATE_SCANNED, COMPACTFREE_SCANNED,
@@ -95,9 +98,6 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_ZERO_PAGE_ALLOC_FAILED,
 		THP_SWPOUT,
 		THP_SWPOUT_FALLBACK,
-		THP_MIGRATION_SUCCESS,
-		THP_MIGRATION_FAILURE,
-		THP_MIGRATION_SPLIT,
 #endif
 #ifdef CONFIG_MEMORY_BALLOON
 		BALLOON_INFLATE,
--- a/mm/migrate.c~mm-vmstat-add-events-for-thp-migration-without-split-fix-2
+++ a/mm/migrate.c
@@ -1429,7 +1429,7 @@ int migrate_pages(struct list_head *from
 	struct page *page;
 	struct page *page2;
 	int swapwrite = current->flags & PF_SWAPWRITE;
-	int rc, thp_n_pages;
+	int rc, nr_subpages;
 
 	if (!swapwrite)
 		current->flags |= PF_SWAPWRITE;
@@ -1446,7 +1446,7 @@ retry:
 			 * during migration.
 			 */
 			is_thp = PageTransHuge(page);
-			thp_n_pages = thp_nr_pages(page);
+			nr_subpages = thp_nr_pages(page);
 			cond_resched();
 
 			if (PageHuge(page))
@@ -1483,7 +1483,7 @@ retry:
 				}
 				if (is_thp) {
 					nr_thp_failed++;
-					nr_failed += thp_n_pages;
+					nr_failed += nr_subpages;
 					goto out;
 				}
 				nr_failed++;
@@ -1498,7 +1498,7 @@ retry:
 			case MIGRATEPAGE_SUCCESS:
 				if (is_thp) {
 					nr_thp_succeeded++;
-					nr_succeeded += thp_n_pages;
+					nr_succeeded += nr_subpages;
 					break;
 				}
 				nr_succeeded++;
@@ -1512,7 +1512,7 @@ retry:
 				 */
 				if (is_thp) {
 					nr_thp_failed++;
-					nr_failed += thp_n_pages;
+					nr_failed += nr_subpages;
 					break;
 				}
 				nr_failed++;
@@ -1524,16 +1524,11 @@ retry:
 	nr_thp_failed += thp_retry;
 	rc = nr_failed;
 out:
-	if (nr_succeeded)
-		count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
-	if (nr_failed)
-		count_vm_events(PGMIGRATE_FAIL, nr_failed);
-	if (nr_thp_succeeded)
-		count_vm_events(THP_MIGRATION_SUCCESS, nr_thp_succeeded);
-	if (nr_thp_failed)
-		count_vm_events(THP_MIGRATION_FAILURE, nr_thp_failed);
-	if (nr_thp_split)
-		count_vm_events(THP_MIGRATION_SPLIT, nr_thp_split);
+	count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
+	count_vm_events(PGMIGRATE_FAIL, nr_failed);
+	count_vm_events(THP_MIGRATION_SUCCESS, nr_thp_succeeded);
+	count_vm_events(THP_MIGRATION_FAIL, nr_thp_failed);
+	count_vm_events(THP_MIGRATION_SPLIT, nr_thp_split);
 	trace_mm_migrate_pages(nr_succeeded, nr_failed, nr_thp_succeeded,
 			       nr_thp_failed, nr_thp_split, mode, reason);
 
--- a/mm/vmstat.c~mm-vmstat-add-events-for-thp-migration-without-split-fix-2
+++ a/mm/vmstat.c
@@ -1274,6 +1274,9 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_MIGRATION
 	"pgmigrate_success",
 	"pgmigrate_fail",
+	"thp_migration_success",
+	"thp_migration_fail",
+	"thp_migration_split",
 #endif
 #ifdef CONFIG_COMPACTION
 	"compact_migrate_scanned",
@@ -1320,9 +1323,6 @@ const char * const vmstat_text[] = {
 	"thp_zero_page_alloc_failed",
 	"thp_swpout",
 	"thp_swpout_fallback",
-	"thp_migration_success",
-	"thp_migration_failure",
-	"thp_migration_split",
 #endif
 #ifdef CONFIG_MEMORY_BALLOON
 	"balloon_inflate",
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-vmstat-add-events-for-thp-migration-without-split-fix-2.patch
