From: akpm@linux-foundation.org
Subject: - fix-race-between-attach_task-and-cpuset_exit.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:44 -0700
Message-ID: <200705090247.l492liTd009009@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031922AbXEICsA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:48:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vatsa@in.ibm.com, balbir@in.ibm.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Fix race between attach_task and cpuset_exit
has been removed from the -mm tree.  Its filename was
     fix-race-between-attach_task-and-cpuset_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix race between attach_task and cpuset_exit
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>

Currently cpuset_exit() changes the exiting task's ->cpuset pointer w/o
taking task_lock().  This can lead to ugly races between attach_task and
cpuset_exit.  Details of the races are described at
http://lkml.org/lkml/2007/3/24/132.

Patch below closes those races.

Signed-off-by: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/cpuset.c~fix-race-between-attach_task-and-cpuset_exit kernel/cpuset.c
--- a/kernel/cpuset.c~fix-race-between-attach_task-and-cpuset_exit
+++ a/kernel/cpuset.c
@@ -2200,10 +2200,6 @@ void cpuset_fork(struct task_struct *chi
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
@@ -2242,8 +2238,10 @@ void cpuset_exit(struct task_struct *tsk
 {
 	struct cpuset *cs;
 
+	task_lock(current);
 	cs = tsk->cpuset;
 	tsk->cpuset = &top_cpuset;	/* the_top_cpuset_hack - see above */
+	task_unlock(current);
 
 	if (notify_on_release(cs)) {
 		char *pathbuf = NULL;
_

Patches currently in -mm which might be from vatsa@in.ibm.com are

origin.patch
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
make-cancel_rearming_delayed_work-reliable.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
