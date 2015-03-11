From: akpm@linux-foundation.org
Subject: + mm-numa-remove-migrate_ratelimited.patch added to -mm tree
Date: Wed, 11 Mar 2015 16:04:38 -0700
Message-ID: <5500ca06.ZqamyH7tmhYoUFjX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbbCKXEj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 19:04:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: remove migrate_ratelimited
has been added to the -mm tree.  Its filename is
     mm-numa-remove-migrate_ratelimited.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-remove-migrate_ratelimited.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-remove-migrate_ratelimited.patch

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
@@ -1554,30 +1554,10 @@ static struct page *alloc_misplaced_dst_
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

mm-thp-return-the-correct-value-for-change_huge_pmd.patch
mm-numa-do-not-clear-ptes-or-pmds-for-numa-hinting-faults.patch
cxgb4-drop-__gfp_nofail-allocation.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-numa-remove-migrate_ratelimited.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

