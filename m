From: akpm@linux-foundation.org
Subject: + memcg-lru_size-instead-of-mem_cgroup_zstat.patch added to -mm tree
Date: Tue, 17 Jan 2012 14:32:21 -0800
Message-ID: <20120117223222.9FE105C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:50367 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2AQWcZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 17:32:25 -0500
Received: by eekb15 with SMTP id b15so100765eek.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 14:32:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: lru_size instead of MEM_CGROUP_ZSTAT
has been added to the -mm tree.  Its filename is
     memcg-lru_size-instead-of-mem_cgroup_zstat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -708,7 +706,7 @@ mem_cgroup_zone_nr_lru_pages(struct mem_
 
 	for_each_lru(l) {
 		if (BIT(l) & lru_mask)
-			ret += MEM_CGROUP_ZSTAT(mz, l);
+			ret += mz->lru_size[l];
 	}
 	return ret;
 }
@@ -1043,7 +1041,7 @@ struct lruvec *mem_cgroup_lru_add_list(s
 	memcg = pc->mem_cgroup;
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* compound_order() is stabilized through lru_lock */
-	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
+	mz->lru_size[lru] += 1 << compound_order(page);
 	return &mz->lruvec;
 }
 
@@ -1071,8 +1069,8 @@ void mem_cgroup_lru_del_list(struct page
 	VM_BUG_ON(!memcg);
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
-	VM_BUG_ON(MEM_CGROUP_ZSTAT(mz, lru) < (1 << compound_order(page)));
-	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
+	VM_BUG_ON(mz->lru_size[lru] < (1 << compound_order(page)));
+	mz->lru_size[lru] -= 1 << compound_order(page);
 }
 
 void mem_cgroup_lru_del(struct page *page)
@@ -3610,7 +3608,7 @@ static int mem_cgroup_force_empty_list(s
 	mz = mem_cgroup_zoneinfo(memcg, node, zid);
 	list = &mz->lruvec.lists[lru];
 
-	loop = MEM_CGROUP_ZSTAT(mz, lru);
+	loop = mz->lru_size[lru];
 	/* give some margin against EBUSY etc...*/
 	loop += 256;
 	busy = NULL;
_
Subject: Subject: memcg: lru_size instead of MEM_CGROUP_ZSTAT

Patches currently in -mm which might be from hughd@google.com are

origin.patch
proc-clear_refs-do-not-clear-reserved-pages.patch
mm-memcg-update-the-correct-soft-limit-tree-during-migration.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
prio_tree-debugging-patch.patch

