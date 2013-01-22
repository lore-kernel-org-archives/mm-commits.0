From: akpm@linux-foundation.org
Subject: + mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch added to -mm tree
Date: Tue, 22 Jan 2013 14:47:39 -0800
Message-ID: <20130122224739.67F7B5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:60283 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3AVWrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 17:47:40 -0500
Received: by mail-yh0-f73.google.com with SMTP id 26so230137yhr.0
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 14:47:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, a.p.zijlstra@chello.nl, aarcange@redhat.com, hughd@google.com, liwanp@linux.vnet.ibm.com, mingo@kernel.org, simon.jeons@gmail.com


The patch titled
     Subject: mm: numa: take THP into account when migrating pages for NUMA balancing
has been added to the -mm tree.  Its filename is
     mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: take THP into account when migrating pages for NUMA balancing

Wanpeng Li pointed out that numamigrate_isolate_page() assumes that only
one base page is being migrated when in fact it can also be checking THP. 
The consequences are that a migration will be attempted when a target node
is nearly full and fail later.  It's unlikely to be user-visible but it
should be fixed.  While we are there, migrate_balanced_pgdat() should
treat nr_migrate_pages as an unsigned long as it is treated as a
watermark.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Suggested-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Simon Jeons <simon.jeons@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing mm/migrate.c
--- a/mm/migrate.c~mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing
+++ a/mm/migrate.c
@@ -1459,7 +1459,7 @@ int migrate_vmas(struct mm_struct *mm, c
  * pages. Currently it only checks the watermarks which crude
  */
 static bool migrate_balanced_pgdat(struct pglist_data *pgdat,
-				   int nr_migrate_pages)
+				   unsigned long nr_migrate_pages)
 {
 	int z;
 	for (z = pgdat->nr_zones - 1; z >= 0; z--) {
@@ -1557,8 +1557,10 @@ int numamigrate_isolate_page(pg_data_t *
 {
 	int ret = 0;
 
+	VM_BUG_ON(compound_order(page) && !PageTransHuge(page));
+
 	/* Avoid migrating to a node that is nearly full */
-	if (migrate_balanced_pgdat(pgdat, 1)) {
+	if (migrate_balanced_pgdat(pgdat, 1UL << compound_order(page))) {
 		int page_lru;
 
 		if (isolate_lru_page(page)) {
_

Patches currently in -mm which might be from mgorman@suse.de are

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
mm-dont-wait-on-congested-zones-in-balance_pgdat.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
mm-numa-fix-minor-typo-in-numa_next_scan.patch
mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch
mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch
mm-move-page-flags-layout-to-separate-header.patch
mm-fold-page-_last_nid-into-page-flags-where-possible.patch
mm-numa-cleanup-flow-of-transhuge-page-migration.patch
mm-memmap_init_zone-performance-improvement.patch

