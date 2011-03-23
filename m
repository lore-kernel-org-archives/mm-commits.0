From: akpm@linux-foundation.org
Subject: [merged] mm-truncate-change-remove_from_page_cache.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:04 -0700
Message-ID: <201103232039.p2NKdfHo028428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933395Ab1CWU5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:57:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, andi@firstfloor.org, dan.magenheimer@oracle.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.u


The patch titled
     mm: truncate: change remove_from_page_cache
has been removed from the -mm tree.  Its filename was
     mm-truncate-change-remove_from_page_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: truncate: change remove_from_page_cache
From: Minchan Kim <minchan.kim@gmail.com>

This patch series changes remove_from_page_cache()'s page ref counting
rule.  Page cache ref count is decreased in delete_from_page_cache().  So
we don't need to decrease the page reference in callers.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/truncate.c~mm-truncate-change-remove_from_page_cache mm/truncate.c
--- a/mm/truncate.c~mm-truncate-change-remove_from_page_cache
+++ a/mm/truncate.c
@@ -106,9 +106,8 @@ truncate_complete_page(struct address_sp
 	cancel_dirty_page(page, PAGE_CACHE_SIZE);
 
 	clear_page_mlock(page);
-	remove_from_page_cache(page);
 	ClearPageMappedToDisk(page);
-	page_cache_release(page);	/* pagecache ref */
+	delete_from_page_cache(page);
 	return 0;
 }
 
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-change-page_cgroup_zoneinfo-signature-fix.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

