From: akpm@linux-foundation.org
Subject: + memcg-avoid-css_get.patch added to -mm tree
Date: Thu, 08 Jul 2010 12:50:57 -0700
Message-ID: <201007081950.o68JovvV025080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757138Ab0GHTvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 15:51:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: avoid css_get()
has been added to the -mm tree.  Its filename is
     memcg-avoid-css_get.patch

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
Subject: memcg: avoid css_get()
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, memory cgroup increments css(cgroup subsys state)'s reference count
per a charged page.  And the reference count is kept until the page is
uncharged.  But this has 2 bad effect.

 1. Because css_get/put calls atomic_inc()/dec, heavy call of them
    on large smp will not scale well.
 2. Because css's refcnt cannot be in a state as "ready-to-release",
    cgroup's notify_on_release handler can't work with memcg.
 3. css's refcnt is atomic_t, it means smaller than 32bit. Maybe too small.

This has been a problem since the 1st merge of memcg.

This is a trial to remove css's refcnt per a page. Even if we remove
refcnt, pre_destroy() does enough synchronization as
  - check res->usage == 0.
  - check no pages on LRU.

This patch removes css's refcnt per page.  Even after this patch, at the
1st look, it seems css_get() is still called in try_charge().

But the logic is.

  - If a memcg of mm->owner is cached one, consume_stock() will work.
    At success, return immediately.
  - If consume_stock returns false, css_get() is called and go to
    slow path which may be blocked. At the end of slow path,
    css_put() is called and restart from the start if necessary.

So, in the fast path, we don't call css_get() and can avoid access to
shared counter. This patch can make the most possible case fast.

Here is a result of multi-threaded page fault benchmark.

[Before]
    25.32%  multi-fault-all  [kernel.kallsyms]      [k] clear_page_c
     9.30%  multi-fault-all  [kernel.kallsyms]      [k] _raw_spin_lock_irqsave
     8.02%  multi-fault-all  [kernel.kallsyms]      [k] try_get_mem_cgroup_from_mm <=====(*)
     7.83%  multi-fault-all  [kernel.kallsyms]      [k] down_read_trylock
     5.38%  multi-fault-all  [kernel.kallsyms]      [k] __css_put
     5.29%  multi-fault-all  [kernel.kallsyms]      [k] __alloc_pages_nodemask
     4.92%  multi-fault-all  [kernel.kallsyms]      [k] _raw_spin_lock_irq
     4.24%  multi-fault-all  [kernel.kallsyms]      [k] up_read
     3.53%  multi-fault-all  [kernel.kallsyms]      [k] css_put
     2.11%  multi-fault-all  [kernel.kallsyms]      [k] handle_mm_fault
     1.76%  multi-fault-all  [kernel.kallsyms]      [k] __rmqueue
     1.64%  multi-fault-all  [kernel.kallsyms]      [k] __mem_cgroup_commit_charge

[After]
    28.41%  multi-fault-all  [kernel.kallsyms]      [k] clear_page_c
    10.08%  multi-fault-all  [kernel.kallsyms]      [k] _raw_spin_lock_irq
     9.58%  multi-fault-all  [kernel.kallsyms]      [k] down_read_trylock
     9.38%  multi-fault-all  [kernel.kallsyms]      [k] _raw_spin_lock_irqsave
     5.86%  multi-fault-all  [kernel.kallsyms]      [k] __alloc_pages_nodemask
     5.65%  multi-fault-all  [kernel.kallsyms]      [k] up_read
     2.82%  multi-fault-all  [kernel.kallsyms]      [k] handle_mm_fault
     2.64%  multi-fault-all  [kernel.kallsyms]      [k] mem_cgroup_add_lru_list
     2.48%  multi-fault-all  [kernel.kallsyms]      [k] __mem_cgroup_commit_charge

Then, 8.02% of try_get_mem_cgroup_from_mm() disappears because this patch
removes css_tryget() in it. (But yes, this is an extreme case.)

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  119 +++++++++++++++++++++++++++++-----------------
 1 file changed, 76 insertions(+), 43 deletions(-)

diff -puN mm/memcontrol.c~memcg-avoid-css_get mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-css_get
+++ a/mm/memcontrol.c
@@ -1690,28 +1690,66 @@ static int __mem_cgroup_try_charge(struc
 	 * thread group leader migrates. It's possible that mm is not
 	 * set, if so charge the init_mm (happens for pagecache usage).
 	 */
-	if (*memcg) {
+	if (!*memcg && !mm)
+		goto bypass;
+again:
+	if (*memcg) { /* css should be a valid one */
 		mem = *memcg;
+		VM_BUG_ON(css_is_removed(&mem->css));
+		if (mem_cgroup_is_root(mem))
+			goto done;
+		if (consume_stock(mem))
+			goto done;
 		css_get(&mem->css);
 	} else {
-		mem = try_get_mem_cgroup_from_mm(mm);
-		if (unlikely(!mem))
-			return 0;
-		*memcg = mem;
-	}
+		struct task_struct *p;
 
-	VM_BUG_ON(css_is_removed(&mem->css));
-	if (mem_cgroup_is_root(mem))
-		goto done;
+		rcu_read_lock();
+		p = rcu_dereference(mm->owner);
+		VM_BUG_ON(!p);
+		/*
+		 * because we don't have task_lock(), "p" can exit while
+		 * we're here. In that case, "mem" can point to root
+		 * cgroup but never be NULL. (and task_struct itself is freed
+		 * by RCU, cgroup itself is RCU safe.) Then, we have small
+		 * risk here to get wrong cgroup. But such kind of mis-account
+		 * by race always happens because we don't have cgroup_mutex().
+		 * It's overkill and we allow that small race, here.
+		 */
+		mem = mem_cgroup_from_task(p);
+		VM_BUG_ON(!mem);
+		if (mem_cgroup_is_root(mem)) {
+			rcu_read_unlock();
+			goto done;
+		}
+		if (consume_stock(mem)) {
+			/*
+			 * It seems dagerous to access memcg without css_get().
+			 * But considering how consume_stok works, it's not
+			 * necessary. If consume_stock success, some charges
+			 * from this memcg are cached on this cpu. So, we
+			 * don't need to call css_get()/css_tryget() before
+			 * calling consume_stock().
+			 */
+			rcu_read_unlock();
+			goto done;
+		}
+		/* after here, we may be blocked. we need to get refcnt */
+		if (!css_tryget(&mem->css)) {
+			rcu_read_unlock();
+			goto again;
+		}
+		rcu_read_unlock();
+	}
 
 	do {
 		bool oom_check;
 
-		if (consume_stock(mem))
-			goto done; /* don't need to fill stock */
 		/* If killed, bypass charge */
-		if (fatal_signal_pending(current))
+		if (fatal_signal_pending(current)) {
+			css_put(&mem->css);
 			goto bypass;
+		}
 
 		oom_check = false;
 		if (oom && !nr_oom_retries) {
@@ -1726,30 +1764,36 @@ static int __mem_cgroup_try_charge(struc
 			break;
 		case CHARGE_RETRY: /* not in OOM situation but retry */
 			csize = PAGE_SIZE;
-			break;
+			css_put(&mem->css);
+			mem = NULL;
+			goto again;
 		case CHARGE_WOULDBLOCK: /* !__GFP_WAIT */
+			css_put(&mem->css);
 			goto nomem;
 		case CHARGE_NOMEM: /* OOM routine works */
-			if (!oom)
+			if (!oom) {
+				css_put(&mem->css);
 				goto nomem;
+			}
 			/* If oom, we never return -ENOMEM */
 			nr_oom_retries--;
 			break;
 		case CHARGE_OOM_DIE: /* Killed by OOM Killer */
+			css_put(&mem->css);
 			goto bypass;
 		}
 	} while (ret != CHARGE_OK);
 
 	if (csize > PAGE_SIZE)
 		refill_stock(mem, csize - PAGE_SIZE);
+	css_put(&mem->css);
 done:
+	*memcg = mem;
 	return 0;
 nomem:
-	css_put(&mem->css);
+	*memcg = NULL;
 	return -ENOMEM;
 bypass:
-	if (mem)
-		css_put(&mem->css);
 	*memcg = NULL;
 	return 0;
 }
@@ -1766,11 +1810,7 @@ static void __mem_cgroup_cancel_charge(s
 		res_counter_uncharge(&mem->res, PAGE_SIZE * count);
 		if (do_swap_account)
 			res_counter_uncharge(&mem->memsw, PAGE_SIZE * count);
-		VM_BUG_ON(test_bit(CSS_ROOT, &mem->css.flags));
-		WARN_ON_ONCE(count > INT_MAX);
-		__css_put(&mem->css, (int)count);
 	}
-	/* we don't need css_put for root */
 }
 
 static void mem_cgroup_cancel_charge(struct mem_cgroup *mem)
@@ -2131,7 +2171,6 @@ int mem_cgroup_try_charge_swapin(struct 
 		goto charge_cur_mm;
 	*ptr = mem;
 	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true);
-	/* drop extra refcnt from tryget */
 	css_put(&mem->css);
 	return ret;
 charge_cur_mm:
@@ -2301,10 +2340,6 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	if (!mem_cgroup_is_root(mem))
-		__do_uncharge(mem, ctype);
-	if (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
-		mem_cgroup_swap_statistics(mem, true);
 	mem_cgroup_charge_statistics(mem, pc, false);
 
 	ClearPageCgroupUsed(pc);
@@ -2316,11 +2351,17 @@ __mem_cgroup_uncharge_common(struct page
 	 */
 
 	unlock_page_cgroup(pc);
-
+	/*
+	 * even after unlock, we have mem->res.usage here and this memcg
+	 * will never be freed.
+	 */
 	memcg_check_events(mem, page);
-	/* at swapout, this memcg will be accessed to record to swap */
-	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
-		css_put(&mem->css);
+	if (do_swap_account && ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT) {
+		mem_cgroup_swap_statistics(mem, true);
+		mem_cgroup_get(mem);
+	}
+	if (!mem_cgroup_is_root(mem))
+		__do_uncharge(mem, ctype);
 
 	return mem;
 
@@ -2407,13 +2448,12 @@ mem_cgroup_uncharge_swapcache(struct pag
 
 	memcg = __mem_cgroup_uncharge_common(page, ctype);
 
-	/* record memcg information */
-	if (do_swap_account && swapout && memcg) {
+	/*
+	 * record memcg information,  if swapout && memcg != NULL,
+	 * mem_cgroup_get() was called in uncharge().
+	 */
+	if (do_swap_account && swapout && memcg)
 		swap_cgroup_record(ent, css_id(&memcg->css));
-		mem_cgroup_get(memcg);
-	}
-	if (swapout && memcg)
-		css_put(&memcg->css);
 }
 #endif
 
@@ -2491,7 +2531,6 @@ static int mem_cgroup_move_swap_account(
 			 */
 			if (!mem_cgroup_is_root(to))
 				res_counter_uncharge(&to->res, PAGE_SIZE);
-			css_put(&to->css);
 		}
 		return 0;
 	}
@@ -4190,9 +4229,6 @@ static int mem_cgroup_do_precharge(unsig
 			goto one_by_one;
 		}
 		mc.precharge += count;
-		VM_BUG_ON(test_bit(CSS_ROOT, &mem->css.flags));
-		WARN_ON_ONCE(count > INT_MAX);
-		__css_get(&mem->css, (int)count);
 		return ret;
 	}
 one_by_one:
@@ -4428,7 +4464,6 @@ static void mem_cgroup_clear_mc(void)
 	}
 	/* we must fixup refcnts and charges */
 	if (mc.moved_swap) {
-		WARN_ON_ONCE(mc.moved_swap > INT_MAX);
 		/* uncharge swap account from the old cgroup */
 		if (!mem_cgroup_is_root(mc.from))
 			res_counter_uncharge(&mc.from->memsw,
@@ -4442,8 +4477,6 @@ static void mem_cgroup_clear_mc(void)
 			 */
 			res_counter_uncharge(&mc.to->res,
 						PAGE_SIZE * mc.moved_swap);
-			VM_BUG_ON(test_bit(CSS_ROOT, &mc.to->css.flags));
-			__css_put(&mc.to->css, mc.moved_swap);
 		}
 		/* we've already done mem_cgroup_get(mc.to) */
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-enable-oom-tasklist-dump-by-default.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-extract-panic-helper-function.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-move-sysctl-declarations-to-oomh.patch
oom-remove-unnecessary-code-and-cleanup.patch
mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch
oom-remove-constraint-argument-from-select_bad_process-and-__out_of_memory.patch
oom-fold-__out_of_memory-into-out_of_memory.patch
mm-use-for_each_online_cpu-in-vmstat.patch
mempolicy-reduce-stack-size-of-migrate_pages.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
oom-dont-try-to-kill-oom_unkillable-child.patch
oom-oom_kill_process-doesnt-select-kthread-child.patch
oom-make-oom_unkillable_task-helper-function.patch
oom-oom_kill_process-needs-to-check-that-p-is-unkillable.patch
oom-proc-pid-oom_score-treat-kernel-thread-honestly.patch
oom-kill-duplicate-oom_disable-check.patch
oom-move-oom_disable-check-from-oom_kill_task-to-out_of_memory.patch
oom-cleanup-has_intersects_mems_allowed.patch
oom-remove-child-mm-check-from-oom_kill_process.patch
oom-give-the-dying-task-a-higher-priority.patch
oom-multi-threaded-process-coredump-dont-make-deadlock.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
memcg-remove-experimental-from-swap-account-config.patch
memcg-clean-up-try_charge-main-loop-v2.patch
memcg-clean-up-waiting-move-acct-v2.patch
memcg-clean-up-waiting-move-acct-v2-fix.patch
memcg-remove-redundant-codes.patch
memcg-remove-mem-from-arg-of-charge_common.patch
memcg-use-find_lock_task_mm-in-memory-cgroups-oom.patch
memcg-avoid-css_get.patch

