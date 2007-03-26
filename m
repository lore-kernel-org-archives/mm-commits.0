From: akpm@linux-foundation.org
Subject: + fix-race-between-attach_task-and-cpuset_exit.patch added to -mm tree
Date: Mon, 26 Mar 2007 13:29:51 -0700
Message-ID: <200703262029.l2QKTp8i029562@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50064 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbXCZUaG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 16:30:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vatsa@in.ibm.com, balbir@in.ibm.com, menage@google.com, pj@sgi.com


The patch titled
     Fix race between attach_task and cpuset_exit
has been added to the -mm tree.  Its filename is
     fix-race-between-attach_task-and-cpuset_exit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix race between attach_task and cpuset_exit
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>

Currently cpuset_exit() changes the exiting task's ->cpuset pointer w/o
taking task_lock().  This can lead to ugly races between attach_task and
cpuset_exit.  Details of the races are described at
http://lkml.org/lkml/2007/3/24/132.

Patch below closes those races.  It is against 2.6.21-rc4 and has undergone
a simple compile/boot test on a x86_64 box.

Signed-off-by: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff -puN kernel/cpuset.c~fix-race-between-attach_task-and-cpuset_exit kernel/cpuset.c
--- a/kernel/cpuset.c~fix-race-between-attach_task-and-cpuset_exit
+++ a/kernel/cpuset.c
@@ -1120,6 +1120,7 @@ static int attach_task(struct cpuset *cs
 	pid_t pid;
 	struct task_struct *tsk;
 	struct cpuset *oldcs;
+	struct cpuset *oldcs_to_be_released = NULL;
 	cpumask_t cpus;
 	nodemask_t from, to;
 	struct mm_struct *mm;
@@ -1175,6 +1176,8 @@ static int attach_task(struct cpuset *cs
 	}
 	atomic_inc(&cs->count);
 	rcu_assign_pointer(tsk->cpuset, cs);
+	if (atomic_dec_and_test(&oldcs->count))
+		oldcs_to_be_released = oldcs;
 	task_unlock(tsk);
 
 	guarantee_online_cpus(cs, &cpus);
@@ -1195,8 +1198,8 @@ static int attach_task(struct cpuset *cs
 
 	put_task_struct(tsk);
 	synchronize_rcu();
-	if (atomic_dec_and_test(&oldcs->count))
-		check_for_release(oldcs, ppathbuf);
+	if (oldcs_to_be_released)
+		check_for_release(oldcs_to_be_released, ppathbuf);
 	return 0;
 }
 
@@ -2120,10 +2123,6 @@ void cpuset_fork(struct task_struct *chi
  * it is holding that mutex while calling check_for_release(),
  * which calls kmalloc(), so can't be called holding callback_mutex().
  *
- * We don't need to task_lock() this reference to tsk->cpuset,
- * because tsk is already marked PF_EXITING, so attach_task() won't
- * mess with it, or task is a failed fork, never visible to attach_task.
- *
  * the_top_cpuset_hack:
  *
  *    Set the exiting tasks cpuset to the root cpuset (top_cpuset).
@@ -2161,20 +2160,23 @@ void cpuset_fork(struct task_struct *chi
 void cpuset_exit(struct task_struct *tsk)
 {
 	struct cpuset *cs;
+	struct cpuset *oldcs_to_be_released = NULL;
 
+	task_lock(tsk);
 	cs = tsk->cpuset;
 	tsk->cpuset = &top_cpuset;	/* the_top_cpuset_hack - see above */
+	if (atomic_dec_and_test(&cs->count))
+		oldcs_to_be_released = cs;
+	task_unlock(tsk);
 
 	if (notify_on_release(cs)) {
 		char *pathbuf = NULL;
 
 		mutex_lock(&manage_mutex);
-		if (atomic_dec_and_test(&cs->count))
-			check_for_release(cs, &pathbuf);
+		if (oldcs_to_be_released)
+			check_for_release(oldcs_to_be_released, &pathbuf);
 		mutex_unlock(&manage_mutex);
 		cpuset_release_agent(pathbuf);
-	} else {
-		atomic_dec(&cs->count);
 	}
 }
 
_

Patches currently in -mm which might be from vatsa@in.ibm.com are

fix-race-between-attach_task-and-cpuset_exit.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
