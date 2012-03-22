From: akpm@linux-foundation.org
Subject: [merged] memcg-lru_size-instead-of-mem_cgroup_zstat.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:32 -0700
Message-ID: <20120322201932.81C8EA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:42272 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965115Ab2CVUTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:34 -0400
Received: by mail-lb0-f202.google.com with SMTP id gj3so134103lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: lru_size instead of MEM_CGROUP_ZSTAT
has been removed from the -mm tree.  Its filename was
     memcg-lru_size-instead-of-mem_cgroup_zstat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: lru_size instead of MEM_CGROUP_ZSTAT

I never understood why we need a MEM_CGROUP_ZSTAT(mz, idx) macro to
obscure the LRU counts.  For easier searching?  So call it lru_size rather
than bare count (lru_length sounds better, but would be wrong, since each
huge page raises lru_size hugely).

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-lru_size-instead-of-mem_cgroup_zstat mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-lru_size-instead-of-mem_cgroup_zstat
+++ a/mm/memcontrol.c
@@ -135,7 +135,7 @@ struct mem_cgroup_reclaim_iter {
  */
 struct mem_cgroup_per_zone {
 	struct lruvec		lruvec;
-	unsigned long		count[NR_LRU_LISTS];
+	unsigned long		lru_size[NR_LRU_LISTS];
 
 	struct mem_cgroup_reclaim_iter reclaim_iter[DEF_PRIORITY + 1];
 
@@ -147,8 +147,6 @@ struct mem_cgroup_per_zone {
 	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
 						/* use container_of	   */
 };
-/* Macro for accessing counter */
-#define MEM_CGROUP_ZSTAT(mz, idx)	((mz)->count[(idx)])
 
 struct mem_cgroup_per_node {
 	struct mem_cgroup_per_zone zoneinfo[MAX_NR_ZONES];
@@ -728,7 +726,7 @@ mem_cgroup_zone_nr_lru_pages(struct mem_
 
 	for_each_lru(l) {
 		if (BIT(l) & lru_mask)
-			ret += MEM_CGROUP_ZSTAT(mz, l);
+			ret += mz->lru_size[l];
 	}
 	return ret;
 }
@@ -1077,7 +1075,7 @@ struct lruvec *mem_cgroup_lru_add_list(s
 
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* compound_order() is stabilized through lru_lock */
-	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
+	mz->lru_size[lru] += 1 << compound_order(page);
 	return &mz->lruvec;
 }
 
@@ -1105,8 +1103,8 @@ void mem_cgroup_lru_del_list(struct page
 	VM_BUG_ON(!memcg);
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
-	VM_BUG_ON(MEM_CGROUP_ZSTAT(mz, lru) < (1 << compound_order(page)));
-	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
+	VM_BUG_ON(mz->lru_size[lru] < (1 << compound_order(page)));
+	mz->lru_size[lru] -= 1 << compound_order(page);
 }
 
 void mem_cgroup_lru_del(struct page *page)
@@ -3629,7 +3627,7 @@ static int mem_cgroup_force_empty_list(s
 	mz = mem_cgroup_zoneinfo(memcg, node, zid);
 	list = &mz->lruvec.lists[lru];
 
-	loop = MEM_CGROUP_ZSTAT(mz, lru);
+	loop = mz->lru_size[lru];
 	/* give some margin against EBUSY etc...*/
 	loop += 256;
 	busy = NULL;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
prio_tree-debugging-patch.patch

