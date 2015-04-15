From: akpm@linux-foundation.org
Subject: [merged] mm-numa-remove-migrate_ratelimited.patch removed from
 -mm tree
Date: Wed, 15 Apr 2015 12:30:39 -0700
Message-ID: <552ebc5f.Qoa3M7ZORVvM+HE7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbbDOTZW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:25:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: remove migrate_ratelimited
has been removed from the -mm tree.  Its filename was
     mm-numa-remove-migrate_ratelimited.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: remove migrate_ratelimited

This code is dead since commit 9e645ab6d089 ("sched/numa: Continue PTE
scanning even if migrate rate limited") so remove it.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    5 -----
 mm/migrate.c            |   20 --------------------
 2 files changed, 25 deletions(-)

diff -puN include/linux/migrate.h~mm-numa-remove-migrate_ratelimited include/linux/migrate.h
--- a/include/linux/migrate.h~mm-numa-remove-migrate_ratelimited
+++ a/include/linux/migrate.h
@@ -69,7 +69,6 @@ static inline int migrate_huge_page_move
 extern bool pmd_trans_migrating(pmd_t pmd);
 extern int migrate_misplaced_page(struct page *page,
 				  struct vm_area_struct *vma, int node);
-extern bool migrate_ratelimited(int node);
 #else
 static inline bool pmd_trans_migrating(pmd_t pmd)
 {
@@ -80,10 +79,6 @@ static inline int migrate_misplaced_page
 {
 	return -EAGAIN; /* can't migrate now */
 }
-static inline bool migrate_ratelimited(int node)
-{
-	return false;
-}
 #endif /* CONFIG_NUMA_BALANCING */
 
 #if defined(CONFIG_NUMA_BALANCING) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
diff -puN mm/migrate.c~mm-numa-remove-migrate_ratelimited mm/migrate.c
--- a/mm/migrate.c~mm-numa-remove-migrate_ratelimited
+++ a/mm/migrate.c
@@ -1565,30 +1565,10 @@ static struct page *alloc_misplaced_dst_
  * page migration rate limiting control.
  * Do not migrate more than @pages_to_migrate in a @migrate_interval_millisecs
  * window of time. Default here says do not migrate more than 1280M per second.
- * If a node is rate-limited then PTE NUMA updates are also rate-limited. However
- * as it is faults that reset the window, pte updates will happen unconditionally
- * if there has not been a fault since @pteupdate_interval_millisecs after the
- * throttle window closed.
  */
 static unsigned int migrate_interval_millisecs __read_mostly = 100;
-static unsigned int pteupdate_interval_millisecs __read_mostly = 1000;
 static unsigned int ratelimit_pages __read_mostly = 128 << (20 - PAGE_SHIFT);
 
-/* Returns true if NUMA migration is currently rate limited */
-bool migrate_ratelimited(int node)
-{
-	pg_data_t *pgdat = NODE_DATA(node);
-
-	if (time_after(jiffies, pgdat->numabalancing_migrate_next_window +
-				msecs_to_jiffies(pteupdate_interval_millisecs)))
-		return false;
-
-	if (pgdat->numabalancing_migrate_nr_pages < ratelimit_pages)
-		return false;
-
-	return true;
-}
-
 /* Returns true if the node is migrate rate-limited after the update */
 static bool numamigrate_update_ratelimit(pg_data_t *pgdat,
 					unsigned long nr_pages)
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
cxgb4-drop-__gfp_nofail-allocation.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-sanitize-page-mapping-for-tail-pages-v2.patch
allow-compaction-of-unevictable-pages.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-change-deactivate_page-with-deactivate_file_page.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
mm-dont-call-__page_cache_release-for-hugetlb.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
mmv41-new-pfn_mkwrite-same-as-page_mkwrite-for-vm_pfnmap.patch
dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection.patch
dax-unify-ext2-4_dax_file_operations.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
kernelh-implement-div_round_closest_ull.patch
cpuidle-menu-use-div_round_closest_ull.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

