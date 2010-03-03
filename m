From: akpm@linux-foundation.org
Subject: + memcg-fix-oom-kill-behavior-v3.patch added to -mm tree
Date: Wed, 03 Mar 2010 15:13:09 -0800
Message-ID: <201003032313.o23ND9Jd004476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754425Ab0CCXNY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Mar 2010 18:13:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com


The patch titled
     memcg: fix oom kill behavior
has been added to the -mm tree.  Its filename is
     memcg-fix-oom-kill-behavior-v3.patch

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
Subject: memcg: fix oom kill behavior
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In current page-fault code,

	handle_mm_fault()
		-> ...
		-> mem_cgroup_charge()
		-> map page or handle error.
	-> check return code.

If page fault's return code is VM_FAULT_OOM, page_fault_out_of_memory() is
called.  But if it's caused by memcg, OOM should have been already
invoked.

Then, I added a patch: a636b327f731143ccc544b966cfd8de6cb6d72c6.  That
patch records last_oom_jiffies for memcg's sub-hierarchy and prevents
page_fault_out_of_memory from being invoked in near future.

But Nishimura-san reported that check by jiffies is not enough when the
system is terribly heavy.

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

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Tested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 -
 mm/memcontrol.c            |  119 +++++++++++++++++++++++++++--------
 mm/oom_kill.c              |    8 --
 3 files changed, 92 insertions(+), 41 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-fix-oom-kill-behavior-v3 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-oom-kill-behavior-v3
+++ a/include/linux/memcontrol.h
@@ -124,7 +124,6 @@ static inline bool mem_cgroup_disabled(v
 	return false;
 }
 
-extern bool mem_cgroup_oom_called(struct task_struct *task);
 void mem_cgroup_update_file_mapped(struct page *page, int val);
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask, int nid,
@@ -258,11 +257,6 @@ static inline bool mem_cgroup_disabled(v
 	return true;
 }
 
-static inline bool mem_cgroup_oom_called(struct task_struct *task)
-{
-	return false;
-}
-
 static inline int
 mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg)
 {
diff -puN mm/memcontrol.c~memcg-fix-oom-kill-behavior-v3 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-oom-kill-behavior-v3
+++ a/mm/memcontrol.c
@@ -203,7 +203,7 @@ struct mem_cgroup {
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
 	bool use_hierarchy;
-	unsigned long	last_oom_jiffies;
+	atomic_t	oom_lock;
 	atomic_t	refcnt;
 
 	unsigned int	swappiness;
@@ -1246,32 +1246,87 @@ static int mem_cgroup_hierarchical_recla
 	return total;
 }
 
-bool mem_cgroup_oom_called(struct task_struct *task)
+static int mem_cgroup_oom_lock_cb(struct mem_cgroup *mem, void *data)
 {
-	bool ret = false;
-	struct mem_cgroup *mem;
-	struct mm_struct *mm;
+	int *val = (int *)data;
+	int x;
 
-	rcu_read_lock();
-	mm = task->mm;
-	if (!mm)
-		mm = &init_mm;
-	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
-	if (mem && time_before(jiffies, mem->last_oom_jiffies + HZ/10))
-		ret = true;
-	rcu_read_unlock();
-	return ret;
+	x = atomic_inc_return(&mem->oom_lock);
+	*val = max(x, *val);
+	return 0;
 }
+/*
+ * Check OOM-Killer is already running under our hierarchy.
+ * If someone is running, return false.
+ */
+static bool mem_cgroup_oom_lock(struct mem_cgroup *mem)
+{
+	int lock_count = 0;
+
+	mem_cgroup_walk_tree(mem, &lock_count, mem_cgroup_oom_lock_cb);
 
-static int record_last_oom_cb(struct mem_cgroup *mem, void *data)
+	if (lock_count == 1)
+		return true;
+	return false;
+}
+
+static int mem_cgroup_oom_unlock_cb(struct mem_cgroup *mem, void *data)
 {
-	mem->last_oom_jiffies = jiffies;
+	atomic_dec(&mem->oom_lock);
 	return 0;
 }
 
-static void record_last_oom(struct mem_cgroup *mem)
+static void mem_cgroup_oom_unlock(struct mem_cgroup *mem)
 {
-	mem_cgroup_walk_tree(mem, NULL, record_last_oom_cb);
+	mem_cgroup_walk_tree(mem, NULL,	mem_cgroup_oom_unlock_cb);
+}
+
+static DEFINE_MUTEX(memcg_oom_mutex);
+static DECLARE_WAIT_QUEUE_HEAD(memcg_oom_waitq);
+
+/*
+ * try to call OOM killer. returns false if we should exit memory-reclaim loop.
+ */
+bool mem_cgroup_handle_oom(struct mem_cgroup *mem, gfp_t mask)
+{
+	DEFINE_WAIT(wait);
+	bool locked;
+
+	/* At first, try to OOM lock hierarchy under mem.*/
+	mutex_lock(&memcg_oom_mutex);
+	locked = mem_cgroup_oom_lock(mem);
+	if (!locked)
+		prepare_to_wait(&memcg_oom_waitq, &wait, TASK_INTERRUPTIBLE);
+	mutex_unlock(&memcg_oom_mutex);
+
+	if (locked)
+		mem_cgroup_out_of_memory(mem, mask);
+	else {
+		schedule();
+		finish_wait(&memcg_oom_waitq, &wait);
+	}
+	mutex_lock(&memcg_oom_mutex);
+	mem_cgroup_oom_unlock(mem);
+	/*
+ 	 * Here, we use global waitq .....more fine grained waitq ?
+ 	 * Assume following hierarchy.
+ 	 * A/
+ 	 *   01
+ 	 *   02
+ 	 * assume OOM happens both in A and 01 at the same time. Tthey are
+ 	 * mutually exclusive by lock. (kill in 01 helps A.)
+ 	 * When we use per memcg waitq, we have to wake up waiters on A and 02
+ 	 * in addtion to waiters on 01. We use global waitq for avoiding mess.
+ 	 * It will not be a big problem.
+ 	 */
+	wake_up_all(&memcg_oom_waitq);
+	mutex_unlock(&memcg_oom_mutex);
+
+	if (test_thread_flag(TIF_MEMDIE) || fatal_signal_pending(current))
+		return false;
+	/* Give chance to dying process */
+	schedule_timeout(1);
+	return true;
 }
 
 /*
@@ -1443,11 +1498,14 @@ static int __mem_cgroup_try_charge(struc
 	struct res_counter *fail_res;
 	int csize = CHARGE_SIZE;
 
-	if (unlikely(test_thread_flag(TIF_MEMDIE))) {
-		/* Don't account this! */
-		*memcg = NULL;
-		return 0;
-	}
+	/*
+	 * Unlike gloval-vm's OOM-kill, we're not in memory shortage
+	 * in system level. So, allow to go ahead dying process in addition to
+	 * MEMDIE process.
+	 */
+	if (unlikely(test_thread_flag(TIF_MEMDIE)
+		     || fatal_signal_pending(current)))
+		goto bypass;
 
 	/*
 	 * We always charge the cgroup the mm_struct belongs to.
@@ -1560,11 +1618,15 @@ static int __mem_cgroup_try_charge(struc
 		}
 
 		if (!nr_retries--) {
-			if (oom) {
-				mem_cgroup_out_of_memory(mem_over_limit, gfp_mask);
-				record_last_oom(mem_over_limit);
+			if (!oom)
+				goto nomem;
+			if (mem_cgroup_handle_oom(mem_over_limit, gfp_mask)) {
+				nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+				continue;
 			}
-			goto nomem;
+			/* When we reach here, current task is dying .*/
+			css_put(&mem->css);
+			goto bypass;
 		}
 	}
 	if (csize > PAGE_SIZE)
@@ -1574,6 +1636,9 @@ done:
 nomem:
 	css_put(&mem->css);
 	return -ENOMEM;
+bypass:
+	*memcg = NULL;
+	return 0;
 }
 
 /*
diff -puN mm/oom_kill.c~memcg-fix-oom-kill-behavior-v3 mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-fix-oom-kill-behavior-v3
+++ a/mm/oom_kill.c
@@ -603,13 +603,6 @@ void pagefault_out_of_memory(void)
 		/* Got some memory back in the last second. */
 		return;
 
-	/*
-	 * If this is from memcg, oom-killer is already invoked.
-	 * and not worth to go system-wide-oom.
-	 */
-	if (mem_cgroup_oom_called(current))
-		goto rest_and_return;
-
 	if (sysctl_panic_on_oom)
 		panic("out of memory from page fault. panic_on_oom is selected.\n");
 
@@ -621,7 +614,6 @@ void pagefault_out_of_memory(void)
 	 * Give "p" a good chance of killing itself before we
 	 * retry to allocate memory.
 	 */
-rest_and_return:
 	if (!test_thread_flag(TIF_MEMDIE))
 		schedule_timeout_uninterruptible(1);
 }
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
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch

