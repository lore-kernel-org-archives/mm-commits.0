From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-oom-kill-behavior-v3.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:16 -0400
Message-ID: <201003150700.o2F70oVh016661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935755Ab0COHBL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix oom kill behavior
has been removed from the -mm tree.  Its filename was
     memcg-fix-oom-kill-behavior-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 -
 mm/memcontrol.c            |  134 +++++++++++++++++++++++++++--------
 mm/oom_kill.c              |    8 --
 3 files changed, 107 insertions(+), 41 deletions(-)

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
@@ -1246,32 +1246,102 @@ static int mem_cgroup_hierarchical_recla
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
+	/*
+	 * Logically, we can stop scanning immediately when we find
+	 * a memcg is already locked. But condidering unlock ops and
+	 * creation/removal of memcg, scan-all is simple operation.
+	 */
+	x = atomic_inc_return(&mem->oom_lock);
+	*val = max(x, *val);
+	return 0;
+}
+/*
+ * Check OOM-Killer is already running under our hierarchy.
+ * If someone is running, return false.
+ */
+static bool mem_cgroup_oom_lock(struct mem_cgroup *mem)
+{
+	int lock_count = 0;
 
-	rcu_read_lock();
-	mm = task->mm;
-	if (!mm)
-		mm = &init_mm;
-	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
-	if (mem && time_before(jiffies, mem->last_oom_jiffies + HZ/10))
-		ret = true;
-	rcu_read_unlock();
-	return ret;
+	mem_cgroup_walk_tree(mem, &lock_count, mem_cgroup_oom_lock_cb);
+
+	if (lock_count == 1)
+		return true;
+	return false;
 }
 
-static int record_last_oom_cb(struct mem_cgroup *mem, void *data)
+static int mem_cgroup_oom_unlock_cb(struct mem_cgroup *mem, void *data)
 {
-	mem->last_oom_jiffies = jiffies;
+	/*
+	 * When a new child is created while the hierarchy is under oom,
+	 * mem_cgroup_oom_lock() may not be called. We have to use
+	 * atomic_add_unless() here.
+	 */
+	atomic_add_unless(&mem->oom_lock, -1, 0);
 	return 0;
 }
 
-static void record_last_oom(struct mem_cgroup *mem)
+static void mem_cgroup_oom_unlock(struct mem_cgroup *mem)
+{
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
 {
-	mem_cgroup_walk_tree(mem, NULL, record_last_oom_cb);
+	DEFINE_WAIT(wait);
+	bool locked;
+
+	/* At first, try to OOM lock hierarchy under mem.*/
+	mutex_lock(&memcg_oom_mutex);
+	locked = mem_cgroup_oom_lock(mem);
+	/*
+	 * Even if signal_pending(), we can't quit charge() loop without
+	 * accounting. So, UNINTERRUPTIBLE is appropriate. But SIGKILL
+	 * under OOM is always welcomed, use TASK_KILLABLE here.
+	 */
+	if (!locked)
+		prepare_to_wait(&memcg_oom_waitq, &wait, TASK_KILLABLE);
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
@@ -1443,11 +1513,14 @@ static int __mem_cgroup_try_charge(struc
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
@@ -1560,11 +1633,15 @@ static int __mem_cgroup_try_charge(struc
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
@@ -1574,6 +1651,9 @@ done:
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
