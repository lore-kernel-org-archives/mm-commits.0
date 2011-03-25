From: akpm@linux-foundation.org
Subject: [merged] memcg-change-page_cgroup_zoneinfo-signature.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:43 -0700
Message-ID: <201103250724.p2P7ObsX025875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933818Ab1CYHYv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: change page_cgroup_zoneinfo signature
has been removed from the -mm tree.  Its filename was
     memcg-change-page_cgroup_zoneinfo-signature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: change page_cgroup_zoneinfo signature
From: Johannes Weiner <hannes@cmpxchg.org>

Instead of passing a whole struct page_cgroup to this function, let it
take only what it really needs from it: the struct mem_cgroup and the
page.

This has the advantage that reading pc->mem_cgroup is now done at the same
place where the ordering rules for this pointer are enforced and
explained.

It is also in preparation for removing the pc->page backpointer.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   10 ----------
 mm/memcontrol.c             |   19 +++++++++----------
 2 files changed, 9 insertions(+), 20 deletions(-)

diff -puN include/linux/page_cgroup.h~memcg-change-page_cgroup_zoneinfo-signature include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-change-page_cgroup_zoneinfo-signature
+++ a/include/linux/page_cgroup.h
@@ -85,16 +85,6 @@ SETPCGFLAG(Migration, MIGRATION)
 CLEARPCGFLAG(Migration, MIGRATION)
 TESTPCGFLAG(Migration, MIGRATION)
 
-static inline int page_cgroup_nid(struct page_cgroup *pc)
-{
-	return page_to_nid(pc->page);
-}
-
-static inline enum zone_type page_cgroup_zid(struct page_cgroup *pc)
-{
-	return page_zonenum(pc->page);
-}
-
 static inline void lock_page_cgroup(struct page_cgroup *pc)
 {
 	/*
diff -puN mm/memcontrol.c~memcg-change-page_cgroup_zoneinfo-signature mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-change-page_cgroup_zoneinfo-signature
+++ a/mm/memcontrol.c
@@ -364,11 +364,10 @@ struct cgroup_subsys_state *mem_cgroup_c
 }
 
 static struct mem_cgroup_per_zone *
-page_cgroup_zoneinfo(struct page_cgroup *pc)
+page_cgroup_zoneinfo(struct mem_cgroup *mem, struct page *page)
 {
-	struct mem_cgroup *mem = pc->mem_cgroup;
-	int nid = page_cgroup_nid(pc);
-	int zid = page_cgroup_zid(pc);
+	int nid = page_to_nid(page);
+	int zid = page_zonenum(page);
 
 	return mem_cgroup_zoneinfo(mem, nid, zid);
 }
@@ -800,7 +799,7 @@ void mem_cgroup_del_lru_list(struct page
 	 * We don't check PCG_USED bit. It's cleared when the "page" is finally
 	 * removed from global LRU.
 	 */
-	mz = page_cgroup_zoneinfo(pc);
+	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
 	if (mem_cgroup_is_root(pc->mem_cgroup))
@@ -836,7 +835,7 @@ void mem_cgroup_rotate_reclaimable_page(
 	smp_rmb();
 	if (mem_cgroup_is_root(pc->mem_cgroup))
 		return;
-	mz = page_cgroup_zoneinfo(pc);
+	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	list_move_tail(&pc->lru, &mz->lists[lru]);
 }
 
@@ -856,7 +855,7 @@ void mem_cgroup_rotate_lru_list(struct p
 	smp_rmb();
 	if (mem_cgroup_is_root(pc->mem_cgroup))
 		return;
-	mz = page_cgroup_zoneinfo(pc);
+	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	list_move(&pc->lru, &mz->lists[lru]);
 }
 
@@ -873,7 +872,7 @@ void mem_cgroup_add_lru_list(struct page
 		return;
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
-	mz = page_cgroup_zoneinfo(pc);
+	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
 	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
 	SetPageCgroupAcctLRU(pc);
@@ -1043,7 +1042,7 @@ mem_cgroup_get_reclaim_stat_from_page(st
 		return NULL;
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
-	mz = page_cgroup_zoneinfo(pc);
+	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	if (!mz)
 		return NULL;
 
@@ -2192,7 +2191,7 @@ void mem_cgroup_split_huge_fixup(struct 
 		 * We hold lru_lock, then, reduce counter directly.
 		 */
 		lru = page_lru(head);
-		mz = page_cgroup_zoneinfo(head_pc);
+		mz = page_cgroup_zoneinfo(head_pc->mem_cgroup, head);
 		MEM_CGROUP_ZSTAT(mz, lru) -= 1;
 	}
 	tail_pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
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

