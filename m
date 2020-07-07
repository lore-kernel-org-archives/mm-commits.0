From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vmstat-add-events-for-thp-migration-without-split.patch added to -mm
 tree
Date: Tue, 07 Jul 2020 13:13:34 -0700
Message-ID: <20200707201334.ASEEF0lQo%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbgGGUNg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 16:13:36 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, daniel.m.jordan@oracle.com, hughd@google.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, willy@infradead.org, ziy@nvidia.com


The patch titled
     Subject: mm/vmstat: add events for THP migration without split
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-events-for-thp-migration-without-split.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-add-events-for-thp-migration-without-split.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-add-events-for-thp-migration-without-split.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/vmstat: add events for THP migration without split

Add following new vmstat events which will help in validating THP
migration without split.  Statistics reported through these new VM events
will help in performance debugging.

1. THP_MIGRATION_SUCCESS
2. THP_MIGRATION_FAILURE
3. THP_MIGRATION_SPLIT

In addition, these new events also update normal page migration statistics
appropriately via PGMIGRATE_SUCCESS and PGMIGRATE_FAILURE.  While here,
this updates current trace event 'mm_migrate_pages' to accommodate now
available THP statistics.

Link: http://lkml.kernel.org/r/1594080415-27924-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_migration.rst |   19 ++++++++++
 include/linux/vm_event_item.h       |    3 +
 include/trace/events/migrate.h      |   17 +++++++--
 mm/migrate.c                        |   49 +++++++++++++++++++++++---
 mm/vmstat.c                         |    3 +
 5 files changed, 84 insertions(+), 7 deletions(-)

--- a/Documentation/vm/page_migration.rst~mm-vmstat-add-events-for-thp-migration-without-split
+++ a/Documentation/vm/page_migration.rst
@@ -253,5 +253,24 @@ which are function pointers of struct ad
      PG_isolated is alias with PG_reclaim flag so driver shouldn't use the flag
      for own purpose.
 
+Quantifying Migration
+=====================
+Following events can be used to quantify page migration.
+
+1. PGMIGRATE_SUCCESS       /* Normal page migration success */
+2. PGMIGRATE_FAIL          /* Normal page migration failure */
+3. THP_MIGRATION_SUCCESS   /* Transparent huge page migration success */
+4. THP_MIGRATION_FAILURE   /* Transparent huge page migration failure */
+5. THP_MIGRATION_SPLIT     /* Transparent huge page got split, retried */
+
+THP_MIGRATION_SUCCESS is when THP is migrated successfully without getting
+split into it's subpages. THP_MIGRATION_FAILURE is when THP could neither
+be migrated nor be split. THP_MIGRATION_SPLIT is when THP could not
+just be migrated as is but instead get split into it's subpages and later
+retried as normal pages. THP events would also update normal page migration
+statistics PGMIGRATE_SUCCESS and PGMIGRATE_FAILURE. These events will help
+in quantifying and analyzing various THP migration events including both
+success and failure cases.
+
 Christoph Lameter, May 8, 2006.
 Minchan Kim, Mar 28, 2016.
--- a/include/linux/vm_event_item.h~mm-vmstat-add-events-for-thp-migration-without-split
+++ a/include/linux/vm_event_item.h
@@ -95,6 +95,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_ZERO_PAGE_ALLOC_FAILED,
 		THP_SWPOUT,
 		THP_SWPOUT_FALLBACK,
+		THP_MIGRATION_SUCCESS,
+		THP_MIGRATION_FAILURE,
+		THP_MIGRATION_SPLIT,
 #endif
 #ifdef CONFIG_MEMORY_BALLOON
 		BALLOON_INFLATE,
--- a/include/trace/events/migrate.h~mm-vmstat-add-events-for-thp-migration-without-split
+++ a/include/trace/events/migrate.h
@@ -46,13 +46,18 @@ MIGRATE_REASON
 TRACE_EVENT(mm_migrate_pages,
 
 	TP_PROTO(unsigned long succeeded, unsigned long failed,
-		 enum migrate_mode mode, int reason),
+		 unsigned long thp_succeeded, unsigned long thp_failed,
+		 unsigned long thp_split, enum migrate_mode mode, int reason),
 
-	TP_ARGS(succeeded, failed, mode, reason),
+	TP_ARGS(succeeded, failed, thp_succeeded, thp_failed,
+		thp_split, mode, reason),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,		succeeded)
 		__field(	unsigned long,		failed)
+		__field(	unsigned long,		thp_succeeded)
+		__field(	unsigned long,		thp_failed)
+		__field(	unsigned long,		thp_split)
 		__field(	enum migrate_mode,	mode)
 		__field(	int,			reason)
 	),
@@ -60,13 +65,19 @@ TRACE_EVENT(mm_migrate_pages,
 	TP_fast_assign(
 		__entry->succeeded	= succeeded;
 		__entry->failed		= failed;
+		__entry->thp_succeeded	= thp_succeeded;
+		__entry->thp_failed	= thp_failed;
+		__entry->thp_split	= thp_split;
 		__entry->mode		= mode;
 		__entry->reason		= reason;
 	),
 
-	TP_printk("nr_succeeded=%lu nr_failed=%lu mode=%s reason=%s",
+	TP_printk("nr_succeeded=%lu nr_failed=%lu nr_thp_succeeded=%lu nr_thp_failed=%lu nr_thp_split=%lu mode=%s reason=%s",
 		__entry->succeeded,
 		__entry->failed,
+		__entry->thp_succeeded,
+		__entry->thp_failed,
+		__entry->thp_split,
 		__print_symbolic(__entry->mode, MIGRATE_MODE),
 		__print_symbolic(__entry->reason, MIGRATE_REASON))
 );
--- a/mm/migrate.c~mm-vmstat-add-events-for-thp-migration-without-split
+++ a/mm/migrate.c
@@ -1429,22 +1429,35 @@ int migrate_pages(struct list_head *from
 		enum migrate_mode mode, int reason)
 {
 	int retry = 1;
+	int thp_retry = 1;
 	int nr_failed = 0;
 	int nr_succeeded = 0;
+	int nr_thp_succeeded = 0;
+	int nr_thp_failed = 0;
+	int nr_thp_split = 0;
 	int pass = 0;
+	bool is_thp = false;
 	struct page *page;
 	struct page *page2;
 	int swapwrite = current->flags & PF_SWAPWRITE;
-	int rc;
+	int rc, thp_nr_pages;
 
 	if (!swapwrite)
 		current->flags |= PF_SWAPWRITE;
 
-	for(pass = 0; pass < 10 && retry; pass++) {
+	for (pass = 0; pass < 10 && (retry || thp_retry); pass++) {
 		retry = 0;
+		thp_retry = 0;
 
 		list_for_each_entry_safe(page, page2, from, lru) {
 retry:
+			/*
+			 * THP statistics is based on the source huge page.
+			 * Capture required information that might get lost
+			 * during migration.
+			 */
+			is_thp = PageTransHuge(page);
+			thp_nr_pages = hpage_nr_pages(page);
 			cond_resched();
 
 			if (PageHuge(page))
@@ -1475,15 +1488,30 @@ retry:
 					unlock_page(page);
 					if (!rc) {
 						list_safe_reset_next(page, page2, lru);
+						nr_thp_split++;
 						goto retry;
 					}
 				}
+				if (is_thp) {
+					nr_thp_failed++;
+					nr_failed += thp_nr_pages;
+					goto out;
+				}
 				nr_failed++;
 				goto out;
 			case -EAGAIN:
+				if (is_thp) {
+					thp_retry++;
+					break;
+				}
 				retry++;
 				break;
 			case MIGRATEPAGE_SUCCESS:
+				if (is_thp) {
+					nr_thp_succeeded++;
+					nr_succeeded += thp_nr_pages;
+					break;
+				}
 				nr_succeeded++;
 				break;
 			default:
@@ -1493,19 +1521,32 @@ retry:
 				 * removed from migration page list and not
 				 * retried in the next outer loop.
 				 */
+				if (is_thp) {
+					nr_thp_failed++;
+					nr_failed += thp_nr_pages;
+					break;
+				}
 				nr_failed++;
 				break;
 			}
 		}
 	}
-	nr_failed += retry;
+	nr_failed += retry + thp_retry;
+	nr_thp_failed += thp_retry;
 	rc = nr_failed;
 out:
 	if (nr_succeeded)
 		count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
 	if (nr_failed)
 		count_vm_events(PGMIGRATE_FAIL, nr_failed);
-	trace_mm_migrate_pages(nr_succeeded, nr_failed, mode, reason);
+	if (nr_thp_succeeded)
+		count_vm_events(THP_MIGRATION_SUCCESS, nr_thp_succeeded);
+	if (nr_thp_failed)
+		count_vm_events(THP_MIGRATION_FAILURE, nr_thp_failed);
+	if (nr_thp_split)
+		count_vm_events(THP_MIGRATION_SPLIT, nr_thp_split);
+	trace_mm_migrate_pages(nr_succeeded, nr_failed, nr_thp_succeeded,
+			       nr_thp_failed, nr_thp_split, mode, reason);
 
 	if (!swapwrite)
 		current->flags &= ~PF_SWAPWRITE;
--- a/mm/vmstat.c~mm-vmstat-add-events-for-thp-migration-without-split
+++ a/mm/vmstat.c
@@ -1320,6 +1320,9 @@ const char * const vmstat_text[] = {
 	"thp_zero_page_alloc_failed",
 	"thp_swpout",
 	"thp_swpout_fallback",
+	"thp_migration_success",
+	"thp_migration_failure",
+	"thp_migration_split",
 #endif
 #ifdef CONFIG_MEMORY_BALLOON
 	"balloon_inflate",
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-add-tests-validating-arch-helpers-for-core-mm-features.patch
mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers.patch
mm-debug_vm_pgtable-add-debug-prints-for-individual-tests.patch
documentation-mm-add-descriptions-for-arch-page-table-helpers.patch
mm-vmstat-add-events-for-thp-migration-without-split.patch
