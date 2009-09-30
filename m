From: akpm@linux-foundation.org
Subject: + memcg-some-modification-to-softlimit-under-hierarchical-memory-reclaim.patch added to -mm tree
Date: Tue, 29 Sep 2009 17:20:41 -0700
Message-ID: <200909300020.n8U0Kf5O031437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753564AbZI3AU7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 20:20:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: some modification to softlimit under hierarchical memory reclaim.
has been added to the -mm tree.  Its filename is
     memcg-some-modification-to-softlimit-under-hierarchical-memory-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: some modification to softlimit under hierarchical memory reclaim.
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch clean up/fixes for memcg's uncharge soft limit path.

Problems:
  Now, res_counter_charge()/uncharge() handles softlimit information at
  charge/uncharge and softlimit-check is done when event counter per memcg
  goes over limit. Now, event counter per memcg is updated only when
  memory usage is over soft limit. Here, considering hierarchical memcg
  management, ancesotors should be taken care of.

  Now, ancerstors(hierarchy) are handled in charge() but not in uncharge().
  This is not good.

  Prolems:
  1. memcg's event counter incremented only when softlimit hits. That's bad.
     It makes event counter hard to be reused for other purpose.

  2. At uncharge, only the lowest level rescounter is handled. This is bug.
     Because ancesotor's event counter is not incremented, children should
     take care of them.

  3. res_counter_uncharge()'s 3rd argument is NULL in most case.
     ops under res_counter->lock should be small. No "if" sentense is better.

Fixes:
  * Removed soft_limit_xx poitner and checks in charge and uncharge.
    Do-check-only-when-necessary scheme works enough well without them.

  * make event-counter of memcg incremented at every charge/uncharge.
    (per-cpu area will be accessed soon anyway)

  * All ancestors are checked at soft-limit-check. This is necessary because
    ancesotor's event counter may never be modified. Then, they should be
    checked at the same time.

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    6 -
 kernel/res_counter.c        |   18 -----
 mm/memcontrol.c             |  115 +++++++++++++++-------------------
 3 files changed, 55 insertions(+), 84 deletions(-)

diff -puN include/linux/res_counter.h~memcg-some-modification-to-softlimit-under-hierarchical-memory-reclaim include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcg-some-modification-to-softlimit-under-hierarchical-memory-reclaim
+++ a/include/linux/res_counter.h
@@ -114,8 +114,7 @@ void res_counter_init(struct res_counter
 int __must_check res_counter_charge_locked(struct res_counter *counter,
 		unsigned long val);
 int __must_check res_counter_charge(struct res_counter *counter,
-		unsigned long val, struct res_counter **limit_fail_at,
-		struct res_counter **soft_limit_at);
+		unsigned long val, struct res_counter **limit_fail_at);
 
 /*
  * uncharge - tell that some portion of the resource is released
@@ -128,8 +127,7 @@ int __must_check res_counter_charge(stru
  */
 
 void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
-void res_counter_uncharge(struct res_counter *counter, unsigned long val,
-				bool *was_soft_limit_excess);
+void res_counter_uncharge(struct res_counter *counter, unsigned long val);
 
 static inline bool res_counter_limit_check_locked(struct res_counter *cnt)
 {
diff -puN kernel/res_counter.c~memcg-some-modification-to-softlimit-under-hierarchical-memory-reclaim kernel/res_counter.c
--- a/kernel/res_counter.c~memcg-some-modification-to-softlimit-under-hierarchical-memory-reclaim
+++ a/kernel/res_counter.c
@@ -37,27 +37,17 @@ int res_counter_charge_locked(struct res
 }
 
 int res_counter_charge(struct res_counter *counter, unsigned long val,
-			struct res_counter **limit_fail_at,
-			struct res_counter **soft_limit_fail_at)
+			struct res_counter **limit_fail_at)
 {
 	int ret;
 	unsigned long flags;
 	struct res_counter *c, *u;
 
 	*limit_fail_at = NULL;
-	if (soft_limit_fail_at)
-		*soft_limit_fail_at = NULL;
 	local_irq_save(flags);
 	for (c = counter; c != NULL; c = c->parent) {
 		spin_lock(&c->lock);
 		ret = res_counter_charge_locked(c, val);
-		/*
-		 * With soft limits, we return the highest ancestor
-		 * that exceeds its soft limit
-		 */
-		if (soft_limit_fail_at &&
-			!res_counter_soft_limit_check_locked(c))
-			*soft_limit_fail_at = c;
 		spin_unlock(&c->lock);
 		if (ret < 0) {
 			*limit_fail_at = c;
@@ -85,8 +75,7 @@ void res_counter_uncharge_locked(struct 
 	counter->usage -= val;
 }
 
-void res_counter_uncharge(struct res_counter *counter, unsigned long val,
-				bool *was_soft_limit_excess)
+void res_counter_uncharge(struct res_counter *counter, unsigned long val)
 {
 	unsigned long flags;
 	struct res_counter *c;
@@ -94,9 +83,6 @@ void res_counter_uncharge(struct res_cou
 	local_irq_save(flags);
 	for (c = counter; c != NULL; c = c->parent) {
 		spin_lock(&c->lock);
-		if (was_soft_limit_excess)
-			*was_soft_limit_excess =
-				!res_counter_soft_limit_check_locked(c);
 		res_counter_uncharge_locked(c, val);
 		spin_unlock(&c->lock);
 	}
diff -puN mm/memcontrol.c~memcg-some-modification-to-softlimit-under-hierarchical-memory-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-some-modification-to-softlimit-under-hierarchical-memory-reclaim
+++ a/mm/memcontrol.c
@@ -353,16 +353,6 @@ __mem_cgroup_remove_exceeded(struct mem_
 }
 
 static void
-mem_cgroup_insert_exceeded(struct mem_cgroup *mem,
-				struct mem_cgroup_per_zone *mz,
-				struct mem_cgroup_tree_per_zone *mctz)
-{
-	spin_lock(&mctz->lock);
-	__mem_cgroup_insert_exceeded(mem, mz, mctz);
-	spin_unlock(&mctz->lock);
-}
-
-static void
 mem_cgroup_remove_exceeded(struct mem_cgroup *mem,
 				struct mem_cgroup_per_zone *mz,
 				struct mem_cgroup_tree_per_zone *mctz)
@@ -392,34 +382,40 @@ static bool mem_cgroup_soft_limit_check(
 
 static void mem_cgroup_update_tree(struct mem_cgroup *mem, struct page *page)
 {
-	unsigned long long prev_usage_in_excess, new_usage_in_excess;
-	bool updated_tree = false;
+	unsigned long long new_usage_in_excess;
 	struct mem_cgroup_per_zone *mz;
 	struct mem_cgroup_tree_per_zone *mctz;
-
-	mz = mem_cgroup_zoneinfo(mem, page_to_nid(page), page_zonenum(page));
+	int nid = page_to_nid(page);
+	int zid = page_zonenum(page);
 	mctz = soft_limit_tree_from_page(page);
 
 	/*
-	 * We do updates in lazy mode, mem's are removed
-	 * lazily from the per-zone, per-node rb tree
+	 * Necessary to update all ancestors when hierarchy is used.
+	 * because their event counter is not touched.
 	 */
-	prev_usage_in_excess = mz->usage_in_excess;
-
-	new_usage_in_excess = res_counter_soft_limit_excess(&mem->res);
-	if (prev_usage_in_excess) {
-		mem_cgroup_remove_exceeded(mem, mz, mctz);
-		updated_tree = true;
-	}
-	if (!new_usage_in_excess)
-		goto done;
-	mem_cgroup_insert_exceeded(mem, mz, mctz);
-
-done:
-	if (updated_tree) {
-		spin_lock(&mctz->lock);
-		mz->usage_in_excess = new_usage_in_excess;
-		spin_unlock(&mctz->lock);
+	for (; mem; mem = parent_mem_cgroup(mem)) {
+		mz = mem_cgroup_zoneinfo(mem, nid, zid);
+		new_usage_in_excess =
+			res_counter_soft_limit_excess(&mem->res);
+		/*
+		 * We have to update the tree if mz is on RB-tree or
+		 * mem is over its softlimit.
+		 */
+		if (new_usage_in_excess || mz->on_tree) {
+			spin_lock(&mctz->lock);
+			/* if on-tree, remove it */
+			if (mz->on_tree)
+				__mem_cgroup_remove_exceeded(mem, mz, mctz);
+			/*
+			 * if over soft limit, insert again. mz->usage_in_excess
+			 * will be updated properly.
+			 */
+			if (new_usage_in_excess)
+				__mem_cgroup_insert_exceeded(mem, mz, mctz);
+			else
+				mz->usage_in_excess = 0;
+			spin_unlock(&mctz->lock);
+		}
 	}
 }
 
@@ -1271,9 +1267,9 @@ static int __mem_cgroup_try_charge(struc
 			gfp_t gfp_mask, struct mem_cgroup **memcg,
 			bool oom, struct page *page)
 {
-	struct mem_cgroup *mem, *mem_over_limit, *mem_over_soft_limit;
+	struct mem_cgroup *mem, *mem_over_limit;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
-	struct res_counter *fail_res, *soft_fail_res = NULL;
+	struct res_counter *fail_res;
 
 	if (unlikely(test_thread_flag(TIF_MEMDIE))) {
 		/* Don't account this! */
@@ -1305,17 +1301,16 @@ static int __mem_cgroup_try_charge(struc
 
 		if (mem_cgroup_is_root(mem))
 			goto done;
-		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res,
-						&soft_fail_res);
+		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res);
 		if (likely(!ret)) {
 			if (!do_swap_account)
 				break;
 			ret = res_counter_charge(&mem->memsw, PAGE_SIZE,
-							&fail_res, NULL);
+							&fail_res);
 			if (likely(!ret))
 				break;
 			/* mem+swap counter fails */
-			res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
+			res_counter_uncharge(&mem->res, PAGE_SIZE);
 			flags |= MEM_CGROUP_RECLAIM_NOSWAP;
 			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
 									memsw);
@@ -1354,16 +1349,11 @@ static int __mem_cgroup_try_charge(struc
 		}
 	}
 	/*
-	 * Insert just the ancestor, we should trickle down to the correct
-	 * cgroup for reclaim, since the other nodes will be below their
-	 * soft limit
-	 */
-	if (soft_fail_res) {
-		mem_over_soft_limit =
-			mem_cgroup_from_res_counter(soft_fail_res, res);
-		if (mem_cgroup_soft_limit_check(mem_over_soft_limit))
-			mem_cgroup_update_tree(mem_over_soft_limit, page);
-	}
+	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
+	 * if they exceeds softlimit.
+	 */
+	if (mem_cgroup_soft_limit_check(mem))
+		mem_cgroup_update_tree(mem, page);
 done:
 	return 0;
 nomem:
@@ -1438,10 +1428,9 @@ static void __mem_cgroup_commit_charge(s
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
 		if (!mem_cgroup_is_root(mem)) {
-			res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
+			res_counter_uncharge(&mem->res, PAGE_SIZE);
 			if (do_swap_account)
-				res_counter_uncharge(&mem->memsw, PAGE_SIZE,
-							NULL);
+				res_counter_uncharge(&mem->memsw, PAGE_SIZE);
 		}
 		css_put(&mem->css);
 		return;
@@ -1520,7 +1509,7 @@ static int mem_cgroup_move_account(struc
 		goto out;
 
 	if (!mem_cgroup_is_root(from))
-		res_counter_uncharge(&from->res, PAGE_SIZE, NULL);
+		res_counter_uncharge(&from->res, PAGE_SIZE);
 	mem_cgroup_charge_statistics(from, pc, false);
 
 	page = pc->page;
@@ -1540,7 +1529,7 @@ static int mem_cgroup_move_account(struc
 	}
 
 	if (do_swap_account && !mem_cgroup_is_root(from))
-		res_counter_uncharge(&from->memsw, PAGE_SIZE, NULL);
+		res_counter_uncharge(&from->memsw, PAGE_SIZE);
 	css_put(&from->css);
 
 	css_get(&to->css);
@@ -1611,9 +1600,9 @@ uncharge:
 	css_put(&parent->css);
 	/* uncharge if move fails */
 	if (!mem_cgroup_is_root(parent)) {
-		res_counter_uncharge(&parent->res, PAGE_SIZE, NULL);
+		res_counter_uncharge(&parent->res, PAGE_SIZE);
 		if (do_swap_account)
-			res_counter_uncharge(&parent->memsw, PAGE_SIZE, NULL);
+			res_counter_uncharge(&parent->memsw, PAGE_SIZE);
 	}
 	return ret;
 }
@@ -1804,8 +1793,7 @@ __mem_cgroup_commit_charge_swapin(struct
 			 * calling css_tryget
 			 */
 			if (!mem_cgroup_is_root(memcg))
-				res_counter_uncharge(&memcg->memsw, PAGE_SIZE,
-							NULL);
+				res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 			mem_cgroup_swap_statistics(memcg, false);
 			mem_cgroup_put(memcg);
 		}
@@ -1832,9 +1820,9 @@ void mem_cgroup_cancel_charge_swapin(str
 	if (!mem)
 		return;
 	if (!mem_cgroup_is_root(mem)) {
-		res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
+		res_counter_uncharge(&mem->res, PAGE_SIZE);
 		if (do_swap_account)
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
 	}
 	css_put(&mem->css);
 }
@@ -1849,7 +1837,6 @@ __mem_cgroup_uncharge_common(struct page
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
 	struct mem_cgroup_per_zone *mz;
-	bool soft_limit_excess = false;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1889,10 +1876,10 @@ __mem_cgroup_uncharge_common(struct page
 	}
 
 	if (!mem_cgroup_is_root(mem)) {
-		res_counter_uncharge(&mem->res, PAGE_SIZE, &soft_limit_excess);
+		res_counter_uncharge(&mem->res, PAGE_SIZE);
 		if (do_swap_account &&
 				(ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
 	}
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
 		mem_cgroup_swap_statistics(mem, true);
@@ -1909,7 +1896,7 @@ __mem_cgroup_uncharge_common(struct page
 	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
 
-	if (soft_limit_excess && mem_cgroup_soft_limit_check(mem))
+	if (mem_cgroup_soft_limit_check(mem))
 		mem_cgroup_update_tree(mem, page);
 	/* at swapout, this memcg will be accessed to record to swap */
 	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
@@ -1987,7 +1974,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
 		 * This memcg can be obsolete one. We avoid calling css_tryget
 		 */
 		if (!mem_cgroup_is_root(memcg))
-			res_counter_uncharge(&memcg->memsw, PAGE_SIZE, NULL);
+			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 		mem_cgroup_swap_statistics(memcg, false);
 		mem_cgroup_put(memcg);
 	}
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-fix-refcnt-goes-to-minus.patch
cgroup-catch-bad-css-refcnt-at-css_put.patch
memcg-some-modification-to-softlimit-under-hierarchical-memory-reclaim.patch
memcg-reduce-check-for-softlimit-excess.patch

