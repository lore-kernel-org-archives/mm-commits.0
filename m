From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-split-swapin-charge-function-into-private-and-public-part.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:18:14 -0700
Message-ID: <20120801201815.028EF100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab2HAUSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:18:16 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:18:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: split swapin charge function into private and public part
has been removed from the -mm tree.  Its filename was
     mm-memcg-split-swapin-charge-function-into-private-and-public-part.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: split swapin charge function into private and public part

When shmem is charged upon swapin, it does not need to check twice whether
the memory controller is enabled.

Also, shmem pages do not have to be checked for everything that regular
anon pages have to be checked for, so let shmem use the internal version
directly and allow future patches to move around checks that are only
required when swapping in anon pages.

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

 mm/memcontrol.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-split-swapin-charge-function-into-private-and-public-part mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-split-swapin-charge-function-into-private-and-public-part
+++ a/mm/memcontrol.c
@@ -2801,18 +2801,14 @@ int mem_cgroup_newpage_charge(struct pag
  * struct page_cgroup is acquired. This refcnt will be consumed by
  * "commit()" or removed by "cancel()"
  */
-int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
-				 struct page *page,
-				 gfp_t mask, struct mem_cgroup **memcgp)
+static int __mem_cgroup_try_charge_swapin(struct mm_struct *mm,
+					  struct page *page,
+					  gfp_t mask,
+					  struct mem_cgroup **memcgp)
 {
 	struct mem_cgroup *memcg;
 	int ret;
 
-	*memcgp = NULL;
-
-	if (mem_cgroup_disabled())
-		return 0;
-
 	if (!do_swap_account)
 		goto charge_cur_mm;
 	/*
@@ -2839,6 +2835,15 @@ charge_cur_mm:
 	return ret;
 }
 
+int mem_cgroup_try_charge_swapin(struct mm_struct *mm, struct page *page,
+				 gfp_t gfp_mask, struct mem_cgroup **memcgp)
+{
+	*memcgp = NULL;
+	if (mem_cgroup_disabled())
+		return 0;
+	return __mem_cgroup_try_charge_swapin(mm, page, gfp_mask, memcgp);
+}
+
 void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
@@ -2900,7 +2905,8 @@ int mem_cgroup_cache_charge(struct page 
 	if (!PageSwapCache(page))
 		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
 	else { /* page is swapcache/shmem */
-		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &memcg);
+		ret = __mem_cgroup_try_charge_swapin(mm, page,
+						     gfp_mask, &memcg);
 		if (!ret)
 			__mem_cgroup_commit_charge_swapin(page, memcg, type);
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-slab-remove-duplicate-check.patch

