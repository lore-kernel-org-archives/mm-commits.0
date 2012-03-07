From: akpm@linux-foundation.org
Subject: + mm-memcg-pass-charge-order-to-oom-killer.patch added to -mm tree
Date: Wed, 07 Mar 2012 14:11:09 -0800
Message-ID: <20120307221109.DB34BA00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48725 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030667Ab2CGWLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Mar 2012 17:11:12 -0500
Received: by faaa19 with SMTP id a19so250016faa.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Mar 2012 14:11:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, bsingharora@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: mm, memcg: pass charge order to oom killer
has been added to the -mm tree.  Its filename is
     mm-memcg-pass-charge-order-to-oom-killer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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
@@ -1791,7 +1791,7 @@ static void memcg_oom_recover(struct mem
 /*
  * try to call OOM killer. returns false if we should exit memory-reclaim loop.
  */
-bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask)
+bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
 	struct oom_wait_info owait;
 	bool locked, need_to_kill;
@@ -1821,7 +1821,7 @@ bool mem_cgroup_handle_oom(struct mem_cg
 
 	if (need_to_kill) {
 		finish_wait(&memcg_oom_waitq, &owait.wait);
-		mem_cgroup_out_of_memory(memcg, mask);
+		mem_cgroup_out_of_memory(memcg, mask, order);
 	} else {
 		schedule();
 		finish_wait(&memcg_oom_waitq, &owait.wait);
@@ -2192,7 +2192,7 @@ static int mem_cgroup_do_charge(struct m
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
Subject: Subject: mm, memcg: pass charge order to oom killer

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
slab-introduce-kmalloc_array.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
mm-oom-introduce-independent-oom-killer-ratelimit-state.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
mm-oom-force-oom-kill-on-sysrqf.patch
mm-memcg-pass-charge-order-to-oom-killer.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch
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

