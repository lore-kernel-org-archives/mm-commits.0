From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-pass-charge-order-to-oom-killer.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:53 -0700
Message-ID: <20120322201853.86019A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61078 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759215Ab2CVUSy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:54 -0400
Received: by mail-yx0-f202.google.com with SMTP id q2so401674yen.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, bsingharora@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: pass charge order to oom killer
has been removed from the -mm tree.  Its filename was
     mm-memcg-pass-charge-order-to-oom-killer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: pass charge order to oom killer

The oom killer typically displays the allocation order at the time of oom
as a part of its diangostic messages (for global, cpuset, and mempolicy
ooms).

The memory controller may also pass the charge order to the oom killer so
it can emit the same information.  This is useful in determining how large
the memory allocation is that triggered the oom killer.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 ++-
 mm/memcontrol.c            |    6 +++---
 mm/oom_kill.c              |    7 ++++---
 3 files changed, 9 insertions(+), 7 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-pass-charge-order-to-oom-killer include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-pass-charge-order-to-oom-killer
+++ a/include/linux/memcontrol.h
@@ -77,7 +77,8 @@ extern void mem_cgroup_uncharge_end(void
 extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_uncharge_cache_page(struct page *page);
 
-extern void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask);
+extern void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
+				     int order);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *memcg);
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
diff -puN mm/memcontrol.c~mm-memcg-pass-charge-order-to-oom-killer mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-pass-charge-order-to-oom-killer
+++ a/mm/memcontrol.c
@@ -1811,7 +1811,7 @@ static void memcg_oom_recover(struct mem
 /*
  * try to call OOM killer. returns false if we should exit memory-reclaim loop.
  */
-bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask)
+bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
 	struct oom_wait_info owait;
 	bool locked, need_to_kill;
@@ -1841,7 +1841,7 @@ bool mem_cgroup_handle_oom(struct mem_cg
 
 	if (need_to_kill) {
 		finish_wait(&memcg_oom_waitq, &owait.wait);
-		mem_cgroup_out_of_memory(memcg, mask);
+		mem_cgroup_out_of_memory(memcg, mask, order);
 	} else {
 		schedule();
 		finish_wait(&memcg_oom_waitq, &owait.wait);
@@ -2212,7 +2212,7 @@ static int mem_cgroup_do_charge(struct m
 	if (!oom_check)
 		return CHARGE_NOMEM;
 	/* check OOM */
-	if (!mem_cgroup_handle_oom(mem_over_limit, gfp_mask))
+	if (!mem_cgroup_handle_oom(mem_over_limit, gfp_mask, get_order(csize)))
 		return CHARGE_OOM_DIE;
 
 	return CHARGE_RETRY;
diff -puN mm/oom_kill.c~mm-memcg-pass-charge-order-to-oom-killer mm/oom_kill.c
--- a/mm/oom_kill.c~mm-memcg-pass-charge-order-to-oom-killer
+++ a/mm/oom_kill.c
@@ -554,7 +554,8 @@ static void check_panic_on_oom(enum oom_
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask)
+void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
+			      int order)
 {
 	unsigned long limit;
 	unsigned int points = 0;
@@ -570,12 +571,12 @@ void mem_cgroup_out_of_memory(struct mem
 		return;
 	}
 
-	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
+	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
 	limit = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT;
 	read_lock(&tasklist_lock);
 	p = select_bad_process(&points, limit, memcg, NULL, false);
 	if (p && PTR_ERR(p) != -1UL)
-		oom_kill_process(p, gfp_mask, 0, points, limit, memcg, NULL,
+		oom_kill_process(p, gfp_mask, order, points, limit, memcg, NULL,
 				 "Memory cgroup out of memory");
 	read_unlock(&tasklist_lock);
 }
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-introduce-umh_completesub_info.patch
usermodehelper-implement-umh_killable.patch
usermodehelper-kill-umh_wait-renumber-umh_-constants.patch
usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch
kmod-introduce-call_modprobe-helper.patch
kmod-make-__request_module-killable.patch

