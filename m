From: akpm@linux-foundation.org
Subject: + memcg-clean-up-try_charge-main-loop-v2.patch added to -mm tree
Date: Fri, 04 Jun 2010 15:31:27 -0700
Message-ID: <201006042231.o54MVSBv022109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530Ab0FDWbm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 18:31:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: clean up try_charge main loop
has been added to the -mm tree.  Its filename is
     memcg-clean-up-try_charge-main-loop-v2.patch

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
Subject: memcg: clean up try_charge main loop
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

mem_cgroup_try_charge() has a big loop in it and seems to be hard to read.
 Most of routines are for slow path.  This patch moves codes out from the
loop and make it clear what's done.

Summary:
 - refactoring a function to detect a memcg is under acccount move or not.
 - refactoring a function to wait for the end of moving task acct.
 - refactoring a main loop('s slow path) as a function and make it clear
   why we retry or quit by return code.
 - add fatal_signal_pending() check for bypassing charge loops.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  248 +++++++++++++++++++++++++++-------------------
 1 file changed, 148 insertions(+), 100 deletions(-)

diff -puN mm/memcontrol.c~memcg-clean-up-try_charge-main-loop-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-try_charge-main-loop-v2
+++ a/mm/memcontrol.c
@@ -1072,6 +1072,49 @@ static unsigned int get_swappiness(struc
 	return swappiness;
 }
 
+/* A routine for testing mem is not under move_account */
+
+static bool mem_cgroup_under_move(struct mem_cgroup *mem)
+{
+	struct mem_cgroup *from = mc.from;
+	struct mem_cgroup *to = mc.to;
+	bool ret = false;
+
+	if (from == mem || to == mem)
+		return true;
+
+	if (!from || !to || !mem->use_hierarchy)
+		return false;
+
+	rcu_read_lock();
+	if (css_tryget(&from->css)) {
+		ret = css_is_ancestor(&from->css, &mem->css);
+		css_put(&from->css);
+	}
+	if (!ret && css_tryget(&to->css)) {
+		ret = css_is_ancestor(&to->css,	&mem->css);
+		css_put(&to->css);
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static bool mem_cgroup_wait_acct_move(struct mem_cgroup *mem)
+{
+	if (mc.moving_task && current != mc.moving_task) {
+		if (mem_cgroup_under_move(mem)) {
+			DEFINE_WAIT(wait);
+			prepare_to_wait(&mc.waitq, &wait, TASK_INTERRUPTIBLE);
+			/* moving charge context might have finished. */
+			if (mc.moving_task)
+				schedule();
+			finish_wait(&mc.waitq, &wait);
+			return true;
+		}
+	}
+	return false;
+}
+
 static int mem_cgroup_count_children_cb(struct mem_cgroup *mem, void *data)
 {
 	int *val = data;
@@ -1582,16 +1625,83 @@ static int __cpuinit memcg_stock_cpu_cal
 	return NOTIFY_OK;
 }
 
+
+/* See __mem_cgroup_try_charge() for details */
+enum {
+	CHARGE_OK,		/* success */
+	CHARGE_RETRY,		/* need to retry but retry is not bad */
+	CHARGE_NOMEM,		/* we can't do more. return -ENOMEM */
+	CHARGE_WOULDBLOCK,	/* GFP_WAIT wasn't set and no enough res. */
+	CHARGE_OOM_DIE,		/* the current is killed because of OOM */
+};
+
+static int __mem_cgroup_do_charge(struct mem_cgroup *mem, gfp_t gfp_mask,
+				int csize, bool oom_check)
+{
+	struct mem_cgroup *mem_over_limit;
+	struct res_counter *fail_res;
+	unsigned long flags = 0;
+	int ret;
+
+	ret = res_counter_charge(&mem->res, csize, &fail_res);
+
+	if (likely(!ret)) {
+		if (!do_swap_account)
+			return CHARGE_OK;
+		ret = res_counter_charge(&mem->memsw, csize, &fail_res);
+		if (likely(!ret))
+			return CHARGE_OK;
+
+		mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
+		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
+	} else
+		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
+
+	if (csize > PAGE_SIZE) /* change csize and retry */
+		return CHARGE_RETRY;
+
+	if (!(gfp_mask & __GFP_WAIT))
+		return CHARGE_WOULDBLOCK;
+
+	ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, NULL,
+					gfp_mask, flags);
+	/*
+	 * try_to_free_mem_cgroup_pages() might not give us a full
+	 * picture of reclaim. Some pages are reclaimed and might be
+	 * moved to swap cache or just unmapped from the cgroup.
+	 * Check the limit again to see if the reclaim reduced the
+	 * current usage of the cgroup before giving up
+	 */
+	if (ret || mem_cgroup_check_under_limit(mem_over_limit))
+		return CHARGE_RETRY;
+
+	/*
+	 * At task move, charge accounts can be doubly counted. So, it's
+	 * better to wait until the end of task_move if something is going on.
+	 */
+	if (mem_cgroup_wait_acct_move(mem_over_limit))
+		return CHARGE_RETRY;
+
+	/* If we don't need to call oom-killer at el, return immediately */
+	if (!oom_check)
+		return CHARGE_NOMEM;
+	/* check OOM */
+	if (!mem_cgroup_handle_oom(mem_over_limit, gfp_mask))
+		return CHARGE_OOM_DIE;
+
+	return CHARGE_RETRY;
+}
+
 /*
  * Unlike exported interface, "oom" parameter is added. if oom==true,
  * oom-killer can be invoked.
  */
 static int __mem_cgroup_try_charge(struct mm_struct *mm,
-			gfp_t gfp_mask, struct mem_cgroup **memcg, bool oom)
+		gfp_t gfp_mask, struct mem_cgroup **memcg, bool oom)
 {
-	struct mem_cgroup *mem, *mem_over_limit;
-	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
-	struct res_counter *fail_res;
+	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	struct mem_cgroup *mem = NULL;
+	int ret;
 	int csize = CHARGE_SIZE;
 
 	/*
@@ -1609,120 +1719,56 @@ static int __mem_cgroup_try_charge(struc
 	 * thread group leader migrates. It's possible that mm is not
 	 * set, if so charge the init_mm (happens for pagecache usage).
 	 */
-	mem = *memcg;
-	if (likely(!mem)) {
+	if (*memcg) {
+		mem = *memcg;
+		css_get(&mem->css);
+	} else {
 		mem = try_get_mem_cgroup_from_mm(mm);
+		if (unlikely(!mem))
+			return 0;
 		*memcg = mem;
-	} else {
-		css_get(&mem->css);
 	}
-	if (unlikely(!mem))
-		return 0;
 
 	VM_BUG_ON(css_is_removed(&mem->css));
 	if (mem_cgroup_is_root(mem))
 		goto done;
 
-	while (1) {
-		int ret = 0;
-		unsigned long flags = 0;
+	do {
+		bool oom_check;
 
 		if (consume_stock(mem))
-			goto done;
-
-		ret = res_counter_charge(&mem->res, csize, &fail_res);
-		if (likely(!ret)) {
-			if (!do_swap_account)
-				break;
-			ret = res_counter_charge(&mem->memsw, csize, &fail_res);
-			if (likely(!ret))
-				break;
-			/* mem+swap counter fails */
-			res_counter_uncharge(&mem->res, csize);
-			flags |= MEM_CGROUP_RECLAIM_NOSWAP;
-			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
-									memsw);
-		} else
-			/* mem counter fails */
-			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
-									res);
+			goto done; /* don't need to fill stock */
+		/* If killed, bypass charge */
+		if (fatal_signal_pending(current))
+			goto bypass;
 
-		/* reduce request size and retry */
-		if (csize > PAGE_SIZE) {
-			csize = PAGE_SIZE;
-			continue;
+		oom_check = false;
+		if (oom && !nr_oom_retries) {
+			oom_check = true;
+			nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
 		}
-		if (!(gfp_mask & __GFP_WAIT))
-			goto nomem;
-
-		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, NULL,
-						gfp_mask, flags);
-		if (ret)
-			continue;
 
-		/*
-		 * try_to_free_mem_cgroup_pages() might not give us a full
-		 * picture of reclaim. Some pages are reclaimed and might be
-		 * moved to swap cache or just unmapped from the cgroup.
-		 * Check the limit again to see if the reclaim reduced the
-		 * current usage of the cgroup before giving up
-		 *
-		 */
-		if (mem_cgroup_check_under_limit(mem_over_limit))
-			continue;
+		ret = __mem_cgroup_do_charge(mem, gfp_mask, csize, oom_check);
 
-		/* try to avoid oom while someone is moving charge */
-		if (mc.moving_task && current != mc.moving_task) {
-			struct mem_cgroup *from, *to;
-			bool do_continue = false;
-			/*
-			 * There is a small race that "from" or "to" can be
-			 * freed by rmdir, so we use css_tryget().
-			 */
-			from = mc.from;
-			to = mc.to;
-			if (from && css_tryget(&from->css)) {
-				if (mem_over_limit->use_hierarchy)
-					do_continue = css_is_ancestor(
-							&from->css,
-							&mem_over_limit->css);
-				else
-					do_continue = (from == mem_over_limit);
-				css_put(&from->css);
-			}
-			if (!do_continue && to && css_tryget(&to->css)) {
-				if (mem_over_limit->use_hierarchy)
-					do_continue = css_is_ancestor(
-							&to->css,
-							&mem_over_limit->css);
-				else
-					do_continue = (to == mem_over_limit);
-				css_put(&to->css);
-			}
-			if (do_continue) {
-				DEFINE_WAIT(wait);
-				prepare_to_wait(&mc.waitq, &wait,
-							TASK_INTERRUPTIBLE);
-				/* moving charge context might have finished. */
-				if (mc.moving_task)
-					schedule();
-				finish_wait(&mc.waitq, &wait);
-				continue;
-			}
-		}
-
-		if (!nr_retries--) {
+		switch (ret) {
+		case CHARGE_OK:
+			break;
+		case CHARGE_RETRY: /* not in OOM situation but retry */
+			csize = PAGE_SIZE;
+			break;
+		case CHARGE_WOULDBLOCK: /* !__GFP_WAIT */
+			goto nomem;
+		case CHARGE_NOMEM: /* OOM routine works */
 			if (!oom)
 				goto nomem;
-			if (mem_cgroup_handle_oom(mem_over_limit, gfp_mask)) {
-				nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
-				continue;
-			}
-			/* When we reach here, current task is dying .*/
-			css_put(&mem->css);
+			/* If oom, we never return -ENOMEM */
+			nr_oom_retries--;
+			break;
+		case CHARGE_OOM_DIE: /* Killed by OOM Killer */
 			goto bypass;
 		}
-	}
+	} while (ret != CHARGE_OK);
+
 	if (csize > PAGE_SIZE)
 		refill_stock(mem, csize - PAGE_SIZE);
 done:
@@ -1731,6 +1777,8 @@ nomem:
 	css_put(&mem->css);
 	return -ENOMEM;
 bypass:
+	if (mem)
+		css_put(&mem->css);
 	*memcg = NULL;
 	return 0;
 }
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

cgroup-alloc_css_id-increments-hierarchy-depth.patch
vmscan-fix-do_try_to_free_pages-return-value-when-priority==0-reclaim-failure.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
memcg-remove-experimental-from-swap-account-config.patch
memcg-clean-up-try_charge-main-loop-v2.patch
memcg-clean-up-waiting-move-acct-v2.patch

