From: akpm@linux-foundation.org
Subject: + memcg-oom-wakeup-filter.patch added to -mm tree
Date: Mon, 15 Mar 2010 15:00:29 -0700
Message-ID: <201003152200.o2FM0UP2025089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936880Ab0COWBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 18:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com


The patch titled
     memcg: oom wakeup filter
has been added to the -mm tree.  Its filename is
     memcg-oom-wakeup-filter.patch

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
Subject: memcg: oom wakeup filter
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

memcg's oom waitqueue is a system-wide wait_queue (for handling
hierarchy.) So, it's better to add custom wake function and do filtering
in wake up path.

This patch adds a filtering feature for waking up oom-waiters.  Hierarchy
is properly handled.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   61 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 17 deletions(-)

diff -puN mm/memcontrol.c~memcg-oom-wakeup-filter mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-oom-wakeup-filter
+++ a/mm/memcontrol.c
@@ -1293,14 +1293,54 @@ static void mem_cgroup_oom_unlock(struct
 static DEFINE_MUTEX(memcg_oom_mutex);
 static DECLARE_WAIT_QUEUE_HEAD(memcg_oom_waitq);
 
+struct oom_wait_info {
+	struct mem_cgroup *mem;
+	wait_queue_t	wait;
+};
+
+static int memcg_oom_wake_function(wait_queue_t *wait,
+	unsigned mode, int sync, void *arg)
+{
+	struct mem_cgroup *wake_mem = (struct mem_cgroup *)arg;
+	struct oom_wait_info *oom_wait_info;
+
+	/* both of oom_wait_info->mem and wake_mem are stable under us */
+	oom_wait_info = container_of(wait, struct oom_wait_info, wait);
+
+	if (oom_wait_info->mem == wake_mem)
+		goto wakeup;
+	/* if no hierarchy, no match */
+	if (!oom_wait_info->mem->use_hierarchy || !wake_mem->use_hierarchy)
+		return 0;
+	/* check hierarchy */
+	if (!css_is_ancestor(&oom_wait_info->mem->css, &wake_mem->css) &&
+	    !css_is_ancestor(&wake_mem->css, &oom_wait_info->mem->css))
+		return 0;
+
+wakeup:
+	return autoremove_wake_function(wait, mode, sync, arg);
+}
+
+static void memcg_wakeup_oom(struct mem_cgroup *mem)
+{
+	/* for filtering, pass "mem" as argument. */
+	__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, mem);
+}
+
 /*
  * try to call OOM killer. returns false if we should exit memory-reclaim loop.
  */
 bool mem_cgroup_handle_oom(struct mem_cgroup *mem, gfp_t mask)
 {
-	DEFINE_WAIT(wait);
+	struct oom_wait_info owait;
 	bool locked;
 
+	owait.mem = mem;
+	owait.wait.flags = 0;
+	owait.wait.func = memcg_oom_wake_function;
+	owait.wait.private = current;
+	INIT_LIST_HEAD(&owait.wait.task_list);
+
 	/* At first, try to OOM lock hierarchy under mem.*/
 	mutex_lock(&memcg_oom_mutex);
 	locked = mem_cgroup_oom_lock(mem);
@@ -1310,31 +1350,18 @@ bool mem_cgroup_handle_oom(struct mem_cg
 	 * under OOM is always welcomed, use TASK_KILLABLE here.
 	 */
 	if (!locked)
-		prepare_to_wait(&memcg_oom_waitq, &wait, TASK_KILLABLE);
+		prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
 	mutex_unlock(&memcg_oom_mutex);
 
 	if (locked)
 		mem_cgroup_out_of_memory(mem, mask);
 	else {
 		schedule();
-		finish_wait(&memcg_oom_waitq, &wait);
+		finish_wait(&memcg_oom_waitq, &owait.wait);
 	}
 	mutex_lock(&memcg_oom_mutex);
 	mem_cgroup_oom_unlock(mem);
-	/*
-	 * Here, we use global waitq .....more fine grained waitq ?
-	 * Assume following hierarchy.
-	 * A/
-	 *   01
-	 *   02
-	 * assume OOM happens both in A and 01 at the same time. Tthey are
-	 * mutually exclusive by lock. (kill in 01 helps A.)
-	 * When we use per memcg waitq, we have to wake up waiters on A and 02
-	 * in addtion to waiters on 01. We use global waitq for avoiding mess.
-	 * It will not be a big problem.
-	 * (And a task may be moved to other groups while it's waiting for OOM.)
-	 */
-	wake_up_all(&memcg_oom_waitq);
+	memcg_wakeup_oom(mem);
 	mutex_unlock(&memcg_oom_mutex);
 
 	if (test_thread_flag(TIF_MEMDIE) || fatal_signal_pending(current))
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch
memory-hotplug-allow-setting-of-phys_device.patch
memory-hotplug-s390-set-phys_device.patch
memcg-disable-move-charge-in-no-mmu-case.patch
memcontrol-fix-potential-null-deref.patch
linux-next.patch
cgroups-net_cls-as-module.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
memcg-oom-wakeup-filter.patch
memcg-oom-notifier.patch
memcg-oom-notifier-fix.patch
memcg-oom-kill-disable-and-oom-status.patch

