From: akpm@linux-foundation.org
Subject: [merged] memcg-keep-only-one-charge-cancelling-function.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:55 -0700
Message-ID: <201103250724.p2P7On4N025961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933849Ab1CYHZB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: keep only one charge cancelling function
has been removed from the -mm tree.  Its filename was
     memcg-keep-only-one-charge-cancelling-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: keep only one charge cancelling function
From: Johannes Weiner <hannes@cmpxchg.org>

We have two charge cancelling functions: one takes a page count, the other
a page size.  The second one just divides the parameter by PAGE_SIZE and
then calls the first one.  This is trivial, no need for an extra function.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN mm/memcontrol.c~memcg-keep-only-one-charge-cancelling-function mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-keep-only-one-charge-cancelling-function
+++ a/mm/memcontrol.c
@@ -2031,21 +2031,17 @@ bypass:
  * gotten by try_charge().
  */
 static void __mem_cgroup_cancel_charge(struct mem_cgroup *mem,
-							unsigned long count)
+				       unsigned int nr_pages)
 {
 	if (!mem_cgroup_is_root(mem)) {
-		res_counter_uncharge(&mem->res, PAGE_SIZE * count);
+		unsigned long bytes = nr_pages * PAGE_SIZE;
+
+		res_counter_uncharge(&mem->res, bytes);
 		if (do_swap_account)
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE * count);
+			res_counter_uncharge(&mem->memsw, bytes);
 	}
 }
 
-static void mem_cgroup_cancel_charge(struct mem_cgroup *mem,
-				     int page_size)
-{
-	__mem_cgroup_cancel_charge(mem, page_size >> PAGE_SHIFT);
-}
-
 /*
  * A helper function to get mem_cgroup from ID. must be called under
  * rcu_read_lock(). The caller must check css_is_removed() or some if
@@ -2104,7 +2100,7 @@ static void __mem_cgroup_commit_charge(s
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
-		mem_cgroup_cancel_charge(mem, page_size);
+		__mem_cgroup_cancel_charge(mem, nr_pages);
 		return;
 	}
 	/*
@@ -2242,7 +2238,7 @@ static int mem_cgroup_move_account(struc
 	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -nr_pages);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
-		mem_cgroup_cancel_charge(from, charge_size);
+		__mem_cgroup_cancel_charge(from, nr_pages);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
@@ -2307,7 +2303,7 @@ static int mem_cgroup_move_parent(struct
 
 	ret = mem_cgroup_move_account(page, pc, child, parent, true, page_size);
 	if (ret)
-		mem_cgroup_cancel_charge(parent, page_size);
+		__mem_cgroup_cancel_charge(parent, page_size >> PAGE_SHIFT);
 
 	if (page_size > PAGE_SIZE)
 		compound_unlock_irqrestore(page, flags);
@@ -2538,7 +2534,7 @@ void mem_cgroup_cancel_charge_swapin(str
 		return;
 	if (!mem)
 		return;
-	mem_cgroup_cancel_charge(mem, PAGE_SIZE);
+	__mem_cgroup_cancel_charge(mem, 1);
 }
 
 static void
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

