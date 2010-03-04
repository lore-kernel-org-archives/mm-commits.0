From: akpm@linux-foundation.org
Subject: + memcg-fix-oom-kill-behavior-v4.patch added to -mm tree
Date: Thu, 04 Mar 2010 13:58:10 -0800
Message-ID: <201003042158.o24LwAd6032321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755132Ab0CDV6s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 16:58:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix oom kill behavior v4
has been added to the -mm tree.  Its filename is
     memcg-fix-oom-kill-behavior-v4.patch

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
Subject: memcg: fix oom kill behavior v4
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In current page-fault code,

	handle_mm_fault()
		-> ...
		-> mem_cgroup_charge()
		-> map page or handle error.
	-> check return code.

If page fault's return code is VM_FAULT_OOM, page_fault_out_of_memory()
is called. But if it's caused by memcg, OOM should have been already
invoked.
Then, I added a patch: a636b327f731143ccc544b966cfd8de6cb6d72c6

That patch records last_oom_jiffies for memcg's sub-hierarchy and
prevents page_fault_out_of_memory from being invoked in near future.

But Nishimura-san reported that check by jiffies is not enough
when the system is terribly heavy.

This patch changes memcg's oom logic as.
 * If memcg causes OOM-kill, continue to retry.
 * remove jiffies check which is used now.
 * add memcg-oom-lock which works like perzone oom lock.
 * If current is killed(as a process), bypass charge.

Something more sophisticated can be added but this pactch does
fundamental things.
TODO:
 - add oom notifier
 - add permemcg disable-oom-kill flag and freezer at oom.
 - more chances for wake up oom waiter (when changing memory limit etc..)

Changelog 20100304
 - fixed mem_cgroup_oom_unlock()
 - added comments
 - changed wait status from TASK_INTERRUPTIBLE to TASK_KILLABLE
Changelog 20100303
 - added comments
Changelog 20100302
 - fixed mutex and prepare_to_wait order.
 - fixed per-memcg oom lock.

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Tested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-oom-kill-behavior-v4 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-oom-kill-behavior-v4
+++ a/mm/memcontrol.c
@@ -1250,7 +1250,11 @@ static int mem_cgroup_oom_lock_cb(struct
 {
 	int *val = (int *)data;
 	int x;
-
+	/*
+	 * Logically, we can stop scanning immediately when we find
+	 * a memcg is already locked. But condidering unlock ops and
+	 * creation/removal of memcg, scan-all is simple operation.
+	 */
 	x = atomic_inc_return(&mem->oom_lock);
 	*val = max(x, *val);
 	return 0;
@@ -1272,7 +1276,12 @@ static bool mem_cgroup_oom_lock(struct m
 
 static int mem_cgroup_oom_unlock_cb(struct mem_cgroup *mem, void *data)
 {
-	atomic_dec(&mem->oom_lock);
+	/*
+	 * When a new child is created while the hierarchy is under oom,
+	 * mem_cgroup_oom_lock() may not be called. We have to use
+	 * atomic_add_unless() here.
+	 */
+	atomic_add_unless(&mem->oom_lock, -1, 0);
 	return 0;
 }
 
@@ -1295,8 +1304,13 @@ bool mem_cgroup_handle_oom(struct mem_cg
 	/* At first, try to OOM lock hierarchy under mem.*/
 	mutex_lock(&memcg_oom_mutex);
 	locked = mem_cgroup_oom_lock(mem);
+	/*
+	 * Even if signal_pending(), we can't quit charge() loop without
+	 * accounting. So, UNINTERRUPTIBLE is appropriate. But SIGKILL
+	 * under OOM is always welcomed, use TASK_KILLABLE here.
+	 */
 	if (!locked)
-		prepare_to_wait(&memcg_oom_waitq, &wait, TASK_INTERRUPTIBLE);
+		prepare_to_wait(&memcg_oom_waitq, &wait, TASK_KILLABLE);
 	mutex_unlock(&memcg_oom_mutex);
 
 	if (locked)
@@ -1308,17 +1322,18 @@ bool mem_cgroup_handle_oom(struct mem_cg
 	mutex_lock(&memcg_oom_mutex);
 	mem_cgroup_oom_unlock(mem);
 	/*
- 	 * Here, we use global waitq .....more fine grained waitq ?
- 	 * Assume following hierarchy.
- 	 * A/
- 	 *   01
- 	 *   02
- 	 * assume OOM happens both in A and 01 at the same time. Tthey are
- 	 * mutually exclusive by lock. (kill in 01 helps A.)
- 	 * When we use per memcg waitq, we have to wake up waiters on A and 02
- 	 * in addtion to waiters on 01. We use global waitq for avoiding mess.
- 	 * It will not be a big problem.
- 	 */
+	 * Here, we use global waitq .....more fine grained waitq ?
+	 * Assume following hierarchy.
+	 * A/
+	 *   01
+	 *   02
+	 * assume OOM happens both in A and 01 at the same time. Tthey are
+	 * mutually exclusive by lock. (kill in 01 helps A.)
+	 * When we use per memcg waitq, we have to wake up waiters on A and 02
+	 * in addtion to waiters on 01. We use global waitq for avoiding mess.
+	 * It will not be a big problem.
+	 * (And a task may be moved to other groups while it's waiting for OOM.)
+	 */
 	wake_up_all(&memcg_oom_waitq);
 	mutex_unlock(&memcg_oom_mutex);
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-clean-up-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-get_scan_ratio-cleanup.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
mm-add-comment-about-deprecation-of-__gfp_nofail.patch
nodemaskh-remove-macro-any_online_node.patch
devmem-dont-allow-seek-to-last-page.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes-fix.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
memcg-handle-panic_on_oom=always-case-v2.patch
cgroups-fix-race-between-userspace-and-kernelspace.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix.patch
memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch
memcg-fix-oom-kill-behavior-v3.patch
memcg-fix-oom-kill-behavior-v4.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch

