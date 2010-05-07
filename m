From: akpm@linux-foundation.org
Subject: [merged] memcg-rcu-lock-fix-v3.patch removed from -mm tree
Date: Fri, 07 May 2010 12:11:54 -0400
Message-ID: <201005071913.o47JDOd8006612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757707Ab0EGTNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 May 2010 15:13:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: rcu locking fix
has been removed from the -mm tree.  Its filename was
     memcg-rcu-lock-fix-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: rcu locking fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

css_id() should be called under rcu_read_lock().  Following is a report
from Li Zefan.

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
kernel/cgroup.c:4438 invoked rcu_dereference_check() without protection!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 1
1 lock held by kswapd0/31:
 #0:  (swap_lock){+.+.-.}, at: [<c05058bb>] swap_info_get+0x4b/0xd0

stack backtrace:
Pid: 31, comm: kswapd0 Not tainted 2.6.34-rc5-tip+ #13
Call Trace:
 [<c083c5d6>] ? printk+0x1d/0x1f
 [<c0480744>] lockdep_rcu_dereference+0x94/0xb0
 [<c049d6ed>] css_id+0x5d/0x60
 [<c05165a5>] mem_cgroup_uncharge_swapcache+0x45/0xa0
 [<c0505e4f>] swapcache_free+0x3f/0x60
 [<c04e79e2>] __remove_mapping+0xb2/0xf0
 [<c04e7cbb>] shrink_page_list+0x26b/0x490
 [<c047f85d>] ? put_lock_stats+0xd/0x30
 [<c083fd67>] ? _raw_spin_unlock_irq+0x27/0x50
 [<c0482566>] ? trace_hardirqs_on_caller+0xb6/0x220
 [<c04e8158>] shrink_inactive_list+0x278/0x620
 [<c04729e1>] ? sched_clock_cpu+0x121/0x180
 [<c047e9b8>] ? trace_hardirqs_off_caller+0x18/0x130
 [<c047eadb>] ? trace_hardirqs_off+0xb/0x10
 [<c0843438>] ? sub_preempt_count+0x8/0x90
 [<c047f85d>] ? put_lock_stats+0xd/0x30
 [<c04e8704>] shrink_zone+0x204/0x3c0
 [<c083fcac>] ? _raw_spin_unlock+0x2c/0x50
 [<c04e951e>] kswapd+0x61e/0x7c0
 [<c04e6ed0>] ? isolate_pages_global+0x0/0x1f0
 [<c046bae0>] ? autoremove_wake_function+0x0/0x50
 [<c04e8f00>] ? kswapd+0x0/0x7c0
 [<c046b5e4>] kthread+0x74/0x80
 [<c046b570>] ? kthread+0x0/0x80
 [<c04035ba>] kernel_thread_helper+0x6/0x10

And css_is_ancestor() should be called under rcu_read_lock().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-rcu-lock-fix-v3 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rcu-lock-fix-v3
+++ a/mm/memcontrol.c
@@ -838,10 +838,12 @@ int task_in_mem_cgroup(struct task_struc
 	 * enabled in "curr" and "curr" is a child of "mem" in *cgroup*
 	 * hierarchy(even if use_hierarchy is disabled in "mem").
 	 */
+	rcu_read_lock();
 	if (mem->use_hierarchy)
 		ret = css_is_ancestor(&curr->css, &mem->css);
 	else
 		ret = (curr == mem);
+	rcu_read_unlock();
 	css_put(&curr->css);
 	return ret;
 }
@@ -1365,9 +1367,13 @@ static int memcg_oom_wake_function(wait_
 	 * Both of oom_wait_info->mem and wake_mem are stable under us.
 	 * Then we can use css_is_ancestor without taking care of RCU.
 	 */
+	rcu_read_lock();
 	if (!css_is_ancestor(&oom_wait_info->mem->css, &wake_mem->css) &&
-	    !css_is_ancestor(&wake_mem->css, &oom_wait_info->mem->css))
+	    !css_is_ancestor(&wake_mem->css, &oom_wait_info->mem->css)) {
+		rcu_read_unlock();
 		return 0;
+	}
+	rcu_read_unlock();
 
 wakeup:
 	return autoremove_wake_function(wait, mode, sync, arg);
@@ -2406,7 +2412,9 @@ mem_cgroup_uncharge_swapcache(struct pag
 
 	/* record memcg information */
 	if (do_swap_account && swapout && memcg) {
+		rcu_read_lock();
 		swap_cgroup_record(ent, css_id(&memcg->css));
+		rcu_read_unlock();
 		mem_cgroup_get(memcg);
 	}
 	if (swapout && memcg)
@@ -2463,8 +2471,10 @@ static int mem_cgroup_move_swap_account(
 {
 	unsigned short old_id, new_id;
 
+	rcu_read_lock();
 	old_id = css_id(&from->css);
 	new_id = css_id(&to->css);
+	rcu_read_unlock();
 
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
 		mem_cgroup_swap_statistics(from, false);
@@ -4308,7 +4318,11 @@ static int is_target_pte_for_mc(struct v
 	}
 	/* Threre is a swap entry and a page doesn't exist or isn't charged */
 	if (ent.val && !ret) {
-		if (css_id(&mc.from->css) == lookup_swap_cgroup(ent)) {
+		unsigned short id;
+		rcu_read_lock();
+		id = css_id(&mc.from->css);
+		rcu_read_unlock();
+		if (id == lookup_swap_cgroup(ent)) {
 			ret = MC_TARGET_SWAP;
 			if (target)
 				target->ent = ent;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-remove-return-value-of-putback_lru_pages.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-reintroduce-and-deprecate-oom_kill_allocating_task.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
oom-avoid-divide-by-zero.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mmmigration-take-a-reference-to-the-anon_vma-before-migrating.patch
mmmigration-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mmmigration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mmmigration-allow-the-migration-of-pageswapcache-pages.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mm-export-fragmentation-index-via-debugfs.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mmcompaction-memory-compaction-core.patch
mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction.patch
mmcompaction-add-proc-trigger-for-memory-compaction.patch
mmcompaction-add-sys-trigger-for-per-node-memory-compaction.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mmcompaction-defer-compaction-using-an-exponential-backoff-when-compaction-fails.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-clean-up-move-charge.patch
memcg-move-charge-of-file-pages.patch
memcg-move-charge-of-file-pages-fix.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
memcg-make-oom-killer-a-no-op-when-no-killable-task-can-be-found.patch
mm-remove-unnecessary-use-of-atomic.patch
mm-memcontrol-uninitialised-return-value.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch

