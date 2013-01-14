From: akpm@linux-foundation.org
Subject: [merged] mm-migrate-check-page_count-of-thp-before-migrating.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:38:15 -0800
Message-ID: <20130114203816.339AE20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:62268 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab3ANUiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:38:19 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so289618fav.0
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:38:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, hughd@google.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: check page_count of THP before migrating
has been removed from the -mm tree.  Its filename was
     mm-migrate-check-page_count-of-thp-before-migrating.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: migrate: check page_count of THP before migrating

Hugh Dickins pointed out that migrate_misplaced_transhuge_page() does not
check page_count before migrating like base page migration and khugepage. 
He could not see why this was safe and he is right.

The potential impact of the bug is avoided due to the limitations of NUMA
balancing.  The page_mapcount() check ensures that only a single address
space is using this page and as THPs are typically private it should not
be possible for another address space to fault it in parallel.  If the
address space has one associated task then it's difficult to have both a
GUP pin and be referencing the page at the same time.  If there are
multiple tasks then a buggy scenario requires that another thread be
accessing the page while the direct IO is in flight.  This is dodgy
behaviour as there is a possibility of corruption with or without THP
migration.  It would be

While we happen to be safe for the most part it is shoddy to depend on
such "safety" so this patch checks the page count similar to anonymous
pages.  Note that this does not mean that the page_mapcount() check can go
away.  If we were to remove the page_mapcount() check the the THP would
have to be unmapped from all referencing PTEs, replaced with migration
PTEs and restored properly afterwards.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-check-page_count-of-thp-before-migrating mm/migrate.c
--- a/mm/migrate.c~mm-migrate-check-page_count-of-thp-before-migrating
+++ a/mm/migrate.c
@@ -1679,9 +1679,21 @@ int migrate_misplaced_transhuge_page(str
 	page_xchg_last_nid(new_page, page_last_nid(page));
 
 	isolated = numamigrate_isolate_page(pgdat, page);
-	if (!isolated) {
+
+	/*
+	 * Failing to isolate or a GUP pin prevents migration. The expected
+	 * page count is 2. 1 for anonymous pages without a mapping and 1
+	 * for the callers pin. If the page was isolated, the page will
+	 * need to be put back on the LRU.
+	 */
+	if (!isolated || page_count(page) != 2) {
 		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
 		put_page(new_page);
+		if (isolated) {
+			putback_lru_page(page);
+			isolated = 0;
+			goto out;
+		}
 		goto out_keep_locked;
 	}
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mmksm-use-new-hashtable-implementation.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-memmap_init_zone-performance-improvement.patch

