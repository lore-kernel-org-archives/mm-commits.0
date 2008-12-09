From: akpm@linux-foundation.org
Subject: + memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:10:18 -0800
Message-ID: <200812090010.mB90AIm3002110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497AbYLIAKZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:10:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: avoid deadlock caused by race between oom and cpuset_attach
has been added to the -mm tree.  Its filename is
     memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch

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
Subject: memcg: avoid deadlock caused by race between oom and cpuset_attach
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

mpol_rebind_mm(), which can be called from cpuset_attach(), does
down_write(mm->mmap_sem).  This means down_write(mm->mmap_sem) can be
called under cgroup_mutex.

OTOH, page fault path does down_read(mm->mmap_sem) and calls
mem_cgroup_try_charge_xxx(), which may eventually calls
mem_cgroup_out_of_memory().  And mem_cgroup_out_of_memory() calls
cgroup_lock().  This means cgroup_lock() can be called under
down_read(mm->mmap_sem).

If those two paths race, deadlock can happen.

This patch avoid this deadlock by:
  - remove cgroup_lock() from mem_cgroup_out_of_memory().
  - define new mutex (memcg_tasklist) and serialize mem_cgroup_move_task()
    (->attach handler of memory cgroup) and mem_cgroup_out_of_memory.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++++
 mm/oom_kill.c   |    2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach
+++ a/mm/memcontrol.c
@@ -51,6 +51,7 @@ static int really_do_swap_account __init
 #define do_swap_account		(0)
 #endif
 
+static DEFINE_MUTEX(memcg_tasklist);	/* can be hold under cgroup_mutex */
 
 /*
  * Statistics for memory cgroup.
@@ -797,7 +798,9 @@ static int __mem_cgroup_try_charge(struc
 
 		if (!nr_retries--) {
 			if (oom) {
+				mutex_lock(&memcg_tasklist);
 				mem_cgroup_out_of_memory(mem_over_limit, gfp_mask);
+				mutex_unlock(&memcg_tasklist);
 				mem_over_limit->last_oom_jiffies = jiffies;
 			}
 			goto nomem;
@@ -2173,10 +2176,12 @@ static void mem_cgroup_move_task(struct 
 				struct cgroup *old_cont,
 				struct task_struct *p)
 {
+	mutex_lock(&memcg_tasklist);
 	/*
 	 * FIXME: It's better to move charges of this process from old
 	 * memcg to new memcg. But it's just on TODO-List now.
 	 */
+	mutex_unlock(&memcg_tasklist);
 }
 
 struct cgroup_subsys mem_cgroup_subsys = {
diff -puN mm/oom_kill.c~memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach
+++ a/mm/oom_kill.c
@@ -429,7 +429,6 @@ void mem_cgroup_out_of_memory(struct mem
 	unsigned long points = 0;
 	struct task_struct *p;
 
-	cgroup_lock();
 	read_lock(&tasklist_lock);
 retry:
 	p = select_bad_process(&points, mem);
@@ -444,7 +443,6 @@ retry:
 		goto retry;
 out:
 	read_unlock(&tasklist_lock);
-	cgroup_unlock();
 }
 #endif
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

cgroups-make-cgroup-config-a-submenu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
memcg-fix-reclaim-result-checks.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-dont-trigger-oom-at-page-migration.patch
memcg-remove-mem_cgroup_try_charge.patch
memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch
memcg-change-try_to_free_pages-to-hierarchical_reclaim.patch

