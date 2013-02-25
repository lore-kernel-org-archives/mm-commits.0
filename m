From: akpm@linux-foundation.org
Subject: [merged] mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:52:37 -0800
Message-ID: <20130225205237.BE3FE5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:37709 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab3BYUwj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:52:39 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so348190yhz.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:52:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, aarcange@redhat.com, hughd@google.com, liwanp@linux.vnet.ibm.com, mingo@kernel.org, simon.jeons@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: take THP into account when migrating pages for NUMA balancing
has been removed from the -mm tree.  Its filename was
     mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1461,7 +1461,7 @@ int migrate_vmas(struct mm_struct *mm, c
  * pages. Currently it only checks the watermarks which crude
  */
 static bool migrate_balanced_pgdat(struct pglist_data *pgdat,
-				   int nr_migrate_pages)
+				   unsigned long nr_migrate_pages)
 {
 	int z;
 	for (z = pgdat->nr_zones - 1; z >= 0; z--) {
@@ -1559,8 +1559,10 @@ int numamigrate_isolate_page(pg_data_t *
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

origin.patch
linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memmap_init_zone-performance-improvement.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

