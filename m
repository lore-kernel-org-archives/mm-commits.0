From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-only-check-swap-cache-pages-for-repeated-charging.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:18:17 -0700
Message-ID: <20120801201818.40E6920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:43672 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab2HAUSU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:18:20 -0400
Received: by mail-bk0-f74.google.com with SMTP id jc3so345285bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:18:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: only check swap cache pages for repeated charging
has been removed from the -mm tree.  Its filename was
     mm-memcg-only-check-swap-cache-pages-for-repeated-charging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: only check swap cache pages for repeated charging

Only anon and shmem pages in the swap cache are attempted to be charged
multiple times, from every swap pte fault or from shmem_unuse().  No other
pages require checking PageCgroupUsed().

Charging pages in the swap cache is also serialized by the page lock, and
since both the try_charge and commit_charge are called under the same page
lock section, the PageCgroupUsed() check might as well happen before the
counter charging, let alone reclaim.

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

 mm/memcontrol.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-only-check-swap-cache-pages-for-repeated-charging mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-only-check-swap-cache-pages-for-repeated-charging
+++ a/mm/memcontrol.c
@@ -2538,11 +2538,7 @@ static void __mem_cgroup_commit_charge(s
 	bool anon;
 
 	lock_page_cgroup(pc);
-	if (unlikely(PageCgroupUsed(pc))) {
-		unlock_page_cgroup(pc);
-		__mem_cgroup_cancel_charge(memcg, nr_pages);
-		return;
-	}
+	VM_BUG_ON(PageCgroupUsed(pc));
 	/*
 	 * we don't need page_cgroup_lock about tail pages, becase they are not
 	 * accessed by any other context at this point.
@@ -2807,8 +2803,19 @@ static int __mem_cgroup_try_charge_swapi
 					  struct mem_cgroup **memcgp)
 {
 	struct mem_cgroup *memcg;
+	struct page_cgroup *pc;
 	int ret;
 
+	pc = lookup_page_cgroup(page);
+	/*
+	 * Every swap fault against a single page tries to charge the
+	 * page, bail as early as possible.  shmem_unuse() encounters
+	 * already charged pages, too.  The USED bit is protected by
+	 * the page lock, which serializes swap cache removal, which
+	 * in turn serializes uncharging.
+	 */
+	if (PageCgroupUsed(pc))
+		return 0;
 	if (!do_swap_account)
 		goto charge_cur_mm;
 	/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-slab-remove-duplicate-check.patch

