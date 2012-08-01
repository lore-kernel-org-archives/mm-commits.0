From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-only-check-anon-swapin-page-charges-for-swap-cache.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:18:22 -0700
Message-ID: <20120801201823.3EBF620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45834 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab2HAUS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:18:26 -0400
Received: by eekd4 with SMTP id d4so347915eek.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:18:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: only check anon swapin page charges for swap cache
has been removed from the -mm tree.  Its filename was
     mm-memcg-only-check-anon-swapin-page-charges-for-swap-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: only check anon swapin page charges for swap cache

shmem knows for sure that the page is in swap cache when attempting to
charge a page, because the cache charge entry function has a check for it.
Only anon pages may be removed from swap cache already when trying to
charge their swapin.

Adjust the comment, though: '4969c11 mm: fix swapin race condition' added
a stable PageSwapCache check under the page lock in the do_swap_page()
before calling the memory controller, so it's unuse_pte()'s pte_same()
that may fail.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wanpeng Li <liwp.linux@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-only-check-anon-swapin-page-charges-for-swap-cache mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-only-check-anon-swapin-page-charges-for-swap-cache
+++ a/mm/memcontrol.c
@@ -2818,14 +2818,6 @@ static int __mem_cgroup_try_charge_swapi
 		return 0;
 	if (!do_swap_account)
 		goto charge_cur_mm;
-	/*
-	 * A racing thread's fault, or swapoff, may have already updated
-	 * the pte, and even removed page from swap cache: in those cases
-	 * do_swap_page()'s pte_same() test will fail; but there's also a
-	 * KSM case which does need to charge the page.
-	 */
-	if (!PageSwapCache(page))
-		goto charge_cur_mm;
 	memcg = try_get_mem_cgroup_from_page(page);
 	if (!memcg)
 		goto charge_cur_mm;
@@ -2848,6 +2840,20 @@ int mem_cgroup_try_charge_swapin(struct 
 	*memcgp = NULL;
 	if (mem_cgroup_disabled())
 		return 0;
+	/*
+	 * A racing thread's fault, or swapoff, may have already
+	 * updated the pte, and even removed page from swap cache: in
+	 * those cases unuse_pte()'s pte_same() test will fail; but
+	 * there's also a KSM case which does need to charge the page.
+	 */
+	if (!PageSwapCache(page)) {
+		int ret;
+
+		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, memcgp, true);
+		if (ret == -EINTR)
+			ret = 0;
+		return ret;
+	}
 	return __mem_cgroup_try_charge_swapin(mm, page, gfp_mask, memcgp);
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-slab-remove-duplicate-check.patch

