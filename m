From: akpm@linux-foundation.org
Subject: + cpusets-update-tasks-page-slab-spread-flags-in-time.patch added to -mm tree
Date: Thu, 09 Apr 2009 21:28:03 -0700
Message-ID: <200904100428.n3A4S3Hh018977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbZDJEdz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 00:33:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, menage@google.com, mingo@elte.hu, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, rientjes@google.com, y-goto@jp.fujitsu.com


The patch titled
     cpusets: update tasks' page/slab spread flags in time
has been added to the -mm tree.  Its filename is
     cpusets-update-tasks-page-slab-spread-flags-in-time.patch

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
Subject: cpusets: update tasks' page/slab spread flags in time
From: Miao Xie <miaox@cn.fujitsu.com>

Fix the bug that the kernel didn't spread page cache/slab object evenly
over all the allowed nodes when spread flags were set by updating tasks'
page/slab spread flags in time.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Paul Menage <menage@google.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   59 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

diff -puN kernel/cpuset.c~cpusets-update-tasks-page-slab-spread-flags-in-time kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-update-tasks-page-slab-spread-flags-in-time
+++ a/kernel/cpuset.c
@@ -406,7 +406,6 @@ void cpuset_update_task_memory_state(voi
 		cs = task_cs(tsk); /* Maybe changed when task not locked */
 		guarantee_online_mems(cs, &tsk->mems_allowed);
 		tsk->cpuset_mems_generation = cs->mems_generation;
-		cpuset_update_task_spread_flag(cs, tsk);
 		task_unlock(tsk);
 		mutex_unlock(&callback_mutex);
 		mpol_rebind_task(tsk, &tsk->mems_allowed);
@@ -1204,6 +1203,46 @@ static int update_relax_domain_level(str
 }
 
 /*
+ * cpuset_change_flag - make a task's spread flags the same as its cpuset's
+ * @tsk: task to be updated
+ * @scan: struct cgroup_scanner containing the cgroup of the task
+ *
+ * Called by cgroup_scan_tasks() for each task in a cgroup.
+ *
+ * We don't need to re-check for the cgroup/cpuset membership, since we're
+ * holding cgroup_lock() at this point.
+ */
+static void cpuset_change_flag(struct task_struct *tsk,
+				struct cgroup_scanner *scan)
+{
+	cpuset_update_task_spread_flag(cgroup_cs(scan->cg), tsk);
+}
+
+/*
+ * update_tasks_flags - update the spread flags of tasks in the cpuset.
+ * @cs: the cpuset in which each task's spread flags needs to be changed
+ * @heap: if NULL, defer allocating heap memory to cgroup_scan_tasks()
+ *
+ * Called with cgroup_mutex held
+ *
+ * The cgroup_scan_tasks() function will scan all the tasks in a cgroup,
+ * calling callback functions for each.
+ *
+ * No return value. It's guaranteed that cgroup_scan_tasks() always returns 0
+ * if @heap != NULL.
+ */
+static void update_tasks_flags(struct cpuset *cs, struct ptr_heap *heap)
+{
+	struct cgroup_scanner scan;
+
+	scan.cg = cs->css.cgroup;
+	scan.test_task = NULL;
+	scan.process_task = cpuset_change_flag;
+	scan.heap = heap;
+	cgroup_scan_tasks(&scan);
+}
+
+/*
  * update_flag - read a 0 or a 1 in a file and update associated flag
  * bit:		the bit to update (see cpuset_flagbits_t)
  * cs:		the cpuset to update
@@ -1216,8 +1255,10 @@ static int update_flag(cpuset_flagbits_t
 		       int turning_on)
 {
 	struct cpuset *trialcs;
-	int err;
 	int balance_flag_changed;
+	int spread_flag_changed;
+	struct ptr_heap heap;
+	int err;
 
 	trialcs = alloc_trial_cpuset(cs);
 	if (!trialcs)
@@ -1232,9 +1273,16 @@ static int update_flag(cpuset_flagbits_t
 	if (err < 0)
 		goto out;
 
+	err = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
+	if (err < 0)
+		goto out;
+
 	balance_flag_changed = (is_sched_load_balance(cs) !=
 				is_sched_load_balance(trialcs));
 
+	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
+			|| (is_spread_page(cs) != is_spread_page(trialcs)));
+
 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs->flags;
 	mutex_unlock(&callback_mutex);
@@ -1242,6 +1290,9 @@ static int update_flag(cpuset_flagbits_t
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
 		async_rebuild_sched_domains();
 
+	if (spread_flag_changed)
+		update_tasks_flags(cs, &heap);
+	heap_free(&heap);
 out:
 	free_trial_cpuset(trialcs);
 	return err;
@@ -1392,6 +1443,8 @@ static void cpuset_attach(struct cgroup_
 	if (err)
 		return;
 
+	cpuset_update_task_spread_flag(cs, tsk);
+
 	from = oldcs->mems_allowed;
 	to = cs->mems_allowed;
 	mm = get_task_mm(tsk);
@@ -1453,11 +1506,9 @@ static int cpuset_write_u64(struct cgrou
 		break;
 	case FILE_SPREAD_PAGE:
 		retval = update_flag(CS_SPREAD_PAGE, cs, val);
-		cs->mems_generation = cpuset_mems_generation++;
 		break;
 	case FILE_SPREAD_SLAB:
 		retval = update_flag(CS_SPREAD_SLAB, cs, val);
-		cs->mems_generation = cpuset_mems_generation++;
 		break;
 	default:
 		retval = -EINVAL;
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch

