From: akpm@linux-foundation.org
Subject: [folded] memcg-coalesce-charging-via-percpu-storage-fix-2.patch removed from -mm tree
Date: Tue, 15 Dec 2009 16:35:14 -0800
Message-ID: <200912160035.nBG0ZEqB023685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761445AbZLPAf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 19:35:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: don't do INIT_WORK() repeatedly against the same work_struct
has been removed from the -mm tree.  Its filename was
     memcg-coalesce-charging-via-percpu-storage-fix-2.patch

This patch was dropped because it was folded into memcg-coalesce-charging-via-percpu-storage.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: don't do INIT_WORK() repeatedly against the same work_struct
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Don't do INIT_WORK() repeatedly against the same work_struct.  It can
actually lead to a BUG.

Just do it once in initialization.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-coalesce-charging-via-percpu-storage-fix-2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-coalesce-charging-via-percpu-storage-fix-2
+++ a/mm/memcontrol.c
@@ -1354,8 +1354,8 @@ static void drain_all_stock_async(void)
 	/* This function is for scheduling "drain" in asynchronous way.
 	 * The result of "drain" is not directly handled by callers. Then,
 	 * if someone is calling drain, we don't have to call drain more.
-	 * Anyway, work_pending() will catch if there is a race. We just do
-	 * loose check here.
+	 * Anyway, WORK_STRUCT_PENDING check in queue_work_on() will catch if
+	 * there is a race. We just do loose check here.
 	 */
 	if (atomic_read(&memcg_drain_count))
 		return;
@@ -1364,9 +1364,6 @@ static void drain_all_stock_async(void)
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
-		if (work_pending(&stock->work))
-			continue;
-		INIT_WORK(&stock->work, drain_local_stock);
 		schedule_work_on(cpu, &stock->work);
 	}
  	put_online_cpus();
@@ -3330,11 +3327,17 @@ mem_cgroup_create(struct cgroup_subsys *
 
 	/* root ? */
 	if (cont->parent == NULL) {
+		int cpu;
 		enable_swap_cgroup();
 		parent = NULL;
 		root_mem_cgroup = mem;
 		if (mem_cgroup_soft_limit_tree_init())
 			goto free_out;
+		for_each_possible_cpu(cpu) {
+			struct memcg_stock_pcp *stock =
+						&per_cpu(memcg_stock, cpu);
+			INIT_WORK(&stock->work, drain_local_stock);
+		}
 		hotcpu_notifier(memcg_stock_cpu_callback, 0);
 
 	} else {
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
memcg-fix-memorymemswusage_in_bytes-for-root-cgroup.patch
memcg-coalesce-uncharge-during-unmap-truncate.patch
memcg-coalesce-charging-via-percpu-storage.patch
memcg-coalesce-charging-via-percpu-storage-fix-2.patch
memcg-make-memcgs-file-mapped-consistent-with-global-vm.patch
memcg-add-mem_cgroup_cancel_charge.patch
memcg-cleanup-mem_cgroup_move_parent.patch
memcg-avoid-oom-killing-innocent-task-in-case-of-use_hierarchy.patch
memcg-remove-memcg_tasklist.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch

