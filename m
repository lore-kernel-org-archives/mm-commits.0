From: akpm@linux-foundation.org
Subject: [merged] memcg-condense-page_cgroup-to-page-lookup-points.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:47 -0700
Message-ID: <201103250724.p2P7Of2c025881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933849Ab1CYHYv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: condense page_cgroup-to-page lookup points
has been removed from the -mm tree.  Its filename was
     memcg-condense-page_cgroup-to-page-lookup-points.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: condense page_cgroup-to-page lookup points
From: Johannes Weiner <hannes@cmpxchg.org>

The per-cgroup LRU lists string up 'struct page_cgroup's.  To get from
those structures to the page they represent, a lookup is required. 
Currently, the lookup is done through a direct pointer in struct
page_cgroup, so a lot of functions down the callchain do this lookup by
themselves instead of receiving the page pointer from their callers.

The next patch removes this pointer, however, and the lookup is no longer
that straight-forward.  In preparation for that, this patch only leaves
the non-optional lookups when coming directly from the LRU list and passes
the page down the stack.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff -puN mm/memcontrol.c~memcg-condense-page_cgroup-to-page-lookup-points mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-condense-page_cgroup-to-page-lookup-points
+++ a/mm/memcontrol.c
@@ -1077,9 +1077,11 @@ unsigned long mem_cgroup_isolate_pages(u
 		if (scan >= nr_to_scan)
 			break;
 
-		page = pc->page;
 		if (unlikely(!PageCgroupUsed(pc)))
 			continue;
+
+		page = pc->page;
+
 		if (unlikely(!PageLRU(page)))
 			continue;
 
@@ -2108,6 +2110,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 }
 
 static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
+				       struct page *page,
 				       struct page_cgroup *pc,
 				       enum charge_type ctype,
 				       int page_size)
@@ -2154,7 +2157,7 @@ static void __mem_cgroup_commit_charge(s
 	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
 	 * if they exceeds softlimit.
 	 */
-	memcg_check_events(mem, pc->page);
+	memcg_check_events(mem, page);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -2201,6 +2204,7 @@ void mem_cgroup_split_huge_fixup(struct 
 
 /**
  * mem_cgroup_move_account - move account of the page
+ * @page: the page
  * @pc:	page_cgroup of the page.
  * @from: mem_cgroup which the page is moved from.
  * @to:	mem_cgroup which the page is moved to. @from != @to.
@@ -2216,7 +2220,7 @@ void mem_cgroup_split_huge_fixup(struct 
  * true, this function does "uncharge" from old cgroup, but it doesn't if
  * @uncharge is false, so a caller should do "uncharge".
  */
-static int mem_cgroup_move_account(struct page_cgroup *pc,
+static int mem_cgroup_move_account(struct page *page, struct page_cgroup *pc,
 				   struct mem_cgroup *from, struct mem_cgroup *to,
 				   bool uncharge, int charge_size)
 {
@@ -2225,7 +2229,7 @@ static int mem_cgroup_move_account(struc
 	int ret;
 
 	VM_BUG_ON(from == to);
-	VM_BUG_ON(PageLRU(pc->page));
+	VM_BUG_ON(PageLRU(page));
 	/*
 	 * The page is isolated from LRU. So, collapse function
 	 * will not handle this page. But page splitting can happen.
@@ -2233,7 +2237,7 @@ static int mem_cgroup_move_account(struc
 	 * hold it.
 	 */
 	ret = -EBUSY;
-	if (charge_size > PAGE_SIZE && !PageTransHuge(pc->page))
+	if (charge_size > PAGE_SIZE && !PageTransHuge(page))
 		goto out;
 
 	lock_page_cgroup(pc);
@@ -2273,8 +2277,8 @@ unlock:
 	/*
 	 * check events
 	 */
-	memcg_check_events(to, pc->page);
-	memcg_check_events(from, pc->page);
+	memcg_check_events(to, page);
+	memcg_check_events(from, page);
 out:
 	return ret;
 }
@@ -2283,11 +2287,11 @@ out:
  * move charges to its parent.
  */
 
-static int mem_cgroup_move_parent(struct page_cgroup *pc,
+static int mem_cgroup_move_parent(struct page *page,
+				  struct page_cgroup *pc,
 				  struct mem_cgroup *child,
 				  gfp_t gfp_mask)
 {
-	struct page *page = pc->page;
 	struct cgroup *cg = child->css.cgroup;
 	struct cgroup *pcg = cg->parent;
 	struct mem_cgroup *parent;
@@ -2317,7 +2321,7 @@ static int mem_cgroup_move_parent(struct
 	if (page_size > PAGE_SIZE)
 		flags = compound_lock_irqsave(page);
 
-	ret = mem_cgroup_move_account(pc, child, parent, true, page_size);
+	ret = mem_cgroup_move_account(page, pc, child, parent, true, page_size);
 	if (ret)
 		mem_cgroup_cancel_charge(parent, page_size);
 
@@ -2363,7 +2367,7 @@ static int mem_cgroup_charge_common(stru
 	if (ret || !mem)
 		return ret;
 
-	__mem_cgroup_commit_charge(mem, pc, ctype, page_size);
+	__mem_cgroup_commit_charge(mem, page, pc, ctype, page_size);
 	return 0;
 }
 
@@ -2501,7 +2505,7 @@ __mem_cgroup_commit_charge_swapin(struct
 	cgroup_exclude_rmdir(&ptr->css);
 	pc = lookup_page_cgroup(page);
 	mem_cgroup_lru_del_before_commit_swapcache(page);
-	__mem_cgroup_commit_charge(ptr, pc, ctype, PAGE_SIZE);
+	__mem_cgroup_commit_charge(ptr, page, pc, ctype, PAGE_SIZE);
 	mem_cgroup_lru_add_after_commit_swapcache(page);
 	/*
 	 * Now swap is on-memory. This means this page may be
@@ -2956,7 +2960,7 @@ int mem_cgroup_prepare_migration(struct 
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
 		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-	__mem_cgroup_commit_charge(mem, pc, ctype, PAGE_SIZE);
+	__mem_cgroup_commit_charge(mem, page, pc, ctype, PAGE_SIZE);
 	return ret;
 }
 
@@ -3323,6 +3327,8 @@ static int mem_cgroup_force_empty_list(s
 	loop += 256;
 	busy = NULL;
 	while (loop--) {
+		struct page *page;
+
 		ret = 0;
 		spin_lock_irqsave(&zone->lru_lock, flags);
 		if (list_empty(list)) {
@@ -3338,7 +3344,9 @@ static int mem_cgroup_force_empty_list(s
 		}
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
-		ret = mem_cgroup_move_parent(pc, mem, GFP_KERNEL);
+		page = pc->page;
+
+		ret = mem_cgroup_move_parent(page, pc, mem, GFP_KERNEL);
 		if (ret == -ENOMEM)
 			break;
 
@@ -4956,7 +4964,7 @@ retry:
 			if (isolate_lru_page(page))
 				goto put;
 			pc = lookup_page_cgroup(page);
-			if (!mem_cgroup_move_account(pc,
+			if (!mem_cgroup_move_account(page, pc,
 					mc.from, mc.to, false, PAGE_SIZE)) {
 				mc.precharge--;
 				/* we uncharge from mc.from later. */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

