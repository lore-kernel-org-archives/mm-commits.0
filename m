From: akpm@linux-foundation.org
Subject: [merged] memcg-update-threshold-and-softlimit-at-commit-v2.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:59:23 -0400
Message-ID: <201003150659.o2F6xusj016578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935633Ab0COHAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:00:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kirill@shutemov.name, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: update threshold and softlimit at commit
has been removed from the -mm tree.  Its filename was
     memcg-update-threshold-and-softlimit-at-commit-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: update threshold and softlimit at commit
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Presently, move_task does "batched" precharge.  Because res_counter or
css's refcnt are not-scalable jobs for memcg, try_charge_()..  tend to be
done in batched manner if allowed.

Now, softlimit and threshold check their event counter in try_charge, but
the charge is not a per-page event.  And event counter is not updated at
charge().  Moreover, precharge doesn't pass "page" to try_charge() and
softlimit tree will be never updated until uncharge() causes an event."

So the best place to check the event counter is commit_charge().  This is
per-page event by its nature.  This patch move checks to there.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff -puN mm/memcontrol.c~memcg-update-threshold-and-softlimit-at-commit-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-update-threshold-and-softlimit-at-commit-v2
+++ a/mm/memcontrol.c
@@ -1424,8 +1424,7 @@ static int __cpuinit memcg_stock_cpu_cal
  * oom-killer can be invoked.
  */
 static int __mem_cgroup_try_charge(struct mm_struct *mm,
-			gfp_t gfp_mask, struct mem_cgroup **memcg,
-			bool oom, struct page *page)
+			gfp_t gfp_mask, struct mem_cgroup **memcg, bool oom)
 {
 	struct mem_cgroup *mem, *mem_over_limit;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
@@ -1463,7 +1462,7 @@ static int __mem_cgroup_try_charge(struc
 		unsigned long flags = 0;
 
 		if (consume_stock(mem))
-			goto charged;
+			goto done;
 
 		ret = res_counter_charge(&mem->res, csize, &fail_res);
 		if (likely(!ret)) {
@@ -1558,16 +1557,7 @@ static int __mem_cgroup_try_charge(struc
 	}
 	if (csize > PAGE_SIZE)
 		refill_stock(mem, csize - PAGE_SIZE);
-charged:
-	/*
-	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
-	 * if they exceeds softlimit.
-	 */
-	if (page && mem_cgroup_soft_limit_check(mem))
-		mem_cgroup_update_tree(mem, page);
 done:
-	if (mem_cgroup_threshold_check(mem))
-		mem_cgroup_threshold(mem);
 	return 0;
 nomem:
 	css_put(&mem->css);
@@ -1691,6 +1681,16 @@ static void __mem_cgroup_commit_charge(s
 	mem_cgroup_charge_statistics(mem, pc, true);
 
 	unlock_page_cgroup(pc);
+	/*
+	 * "charge_statistics" updated event counter. Then, check it.
+	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
+	 * if they exceeds softlimit.
+	 */
+	if (mem_cgroup_soft_limit_check(mem))
+		mem_cgroup_update_tree(mem, pc->page);
+	if (mem_cgroup_threshold_check(mem))
+		mem_cgroup_threshold(mem);
+
 }
 
 /**
@@ -1788,7 +1788,7 @@ static int mem_cgroup_move_parent(struct
 		goto put;
 
 	parent = mem_cgroup_from_cont(pcg);
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, page);
+	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false);
 	if (ret || !parent)
 		goto put_back;
 
@@ -1824,7 +1824,7 @@ static int mem_cgroup_charge_common(stru
 	prefetchw(pc);
 
 	mem = memcg;
-	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true, page);
+	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true);
 	if (ret || !mem)
 		return ret;
 
@@ -1944,14 +1944,14 @@ int mem_cgroup_try_charge_swapin(struct 
 	if (!mem)
 		goto charge_cur_mm;
 	*ptr = mem;
-	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true, page);
+	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true);
 	/* drop extra refcnt from tryget */
 	css_put(&mem->css);
 	return ret;
 charge_cur_mm:
 	if (unlikely(!mm))
 		mm = &init_mm;
-	return __mem_cgroup_try_charge(mm, mask, ptr, true, page);
+	return __mem_cgroup_try_charge(mm, mask, ptr, true);
 }
 
 static void
@@ -2340,8 +2340,7 @@ int mem_cgroup_prepare_migration(struct 
 	unlock_page_cgroup(pc);
 
 	if (mem) {
-		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false,
-						page);
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
 		css_put(&mem->css);
 	}
 	*ptr = mem;
@@ -3872,8 +3871,7 @@ one_by_one:
 			batch_count = PRECHARGE_COUNT_AT_ONCE;
 			cond_resched();
 		}
-		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem,
-								false, NULL);
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
 		if (ret || !mem)
 			/* mem_cgroup_clear_mc() will do uncharge later */
 			return -ENOMEM;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch
memory-hotplug-allow-setting-of-phys_device.patch
memory-hotplug-s390-set-phys_device.patch
linux-next.patch
cgroups-net_cls-as-module.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch

