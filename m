From: akpm@linux-foundation.org
Subject: [merged] oom-remove-oom_disable_count.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:08:20 -0700
Message-ID: <201111012108.pA1L8KnP022419@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28602 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1KAVIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:08:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: remove oom_disable_count
has been removed from the -mm tree.  Its filename was
     oom-remove-oom_disable_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: oom: remove oom_disable_count

This removes mm->oom_disable_count entirely since it's unnecessary and
currently buggy.  The counter was intended to be per-process but it's
currently decremented in the exit path for each thread that exits, causing
it to underflow.

The count was originally intended to prevent oom killing threads that
share memory with threads that cannot be killed since it doesn't lead to
future memory freeing.  The counter could be fixed to represent all
threads sharing the same mm, but it's better to remove the count since:

 - it is possible that the OOM_DISABLE thread sharing memory with the
   victim is waiting on that thread to exit and will actually cause
   future memory freeing, and

 - there is no guarantee that a thread is disabled from oom killing just
   because another thread sharing its mm is oom disabled.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ying Han <yinghan@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |    4 ----
 fs/proc/base.c           |   13 -------------
 include/linux/mm_types.h |    3 ---
 kernel/exit.c            |    2 --
 kernel/fork.c            |   10 +---------
 mm/oom_kill.c            |   23 +++++------------------
 6 files changed, 6 insertions(+), 49 deletions(-)

diff -puN fs/exec.c~oom-remove-oom_disable_count fs/exec.c
--- a/fs/exec.c~oom-remove-oom_disable_count
+++ a/fs/exec.c
@@ -841,10 +841,6 @@ static int exec_mmap(struct mm_struct *m
 	tsk->mm = mm;
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
-	if (old_mm && tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
-		atomic_dec(&old_mm->oom_disable_count);
-		atomic_inc(&tsk->mm->oom_disable_count);
-	}
 	task_unlock(tsk);
 	arch_pick_mmap_layout(mm);
 	if (old_mm) {
diff -puN fs/proc/base.c~oom-remove-oom_disable_count fs/proc/base.c
--- a/fs/proc/base.c~oom-remove-oom_disable_count
+++ a/fs/proc/base.c
@@ -1107,13 +1107,6 @@ static ssize_t oom_adjust_write(struct f
 		goto err_sighand;
 	}
 
-	if (oom_adjust != task->signal->oom_adj) {
-		if (oom_adjust == OOM_DISABLE)
-			atomic_inc(&task->mm->oom_disable_count);
-		if (task->signal->oom_adj == OOM_DISABLE)
-			atomic_dec(&task->mm->oom_disable_count);
-	}
-
 	/*
 	 * Warn that /proc/pid/oom_adj is deprecated, see
 	 * Documentation/feature-removal-schedule.txt.
@@ -1215,12 +1208,6 @@ static ssize_t oom_score_adj_write(struc
 		goto err_sighand;
 	}
 
-	if (oom_score_adj != task->signal->oom_score_adj) {
-		if (oom_score_adj == OOM_SCORE_ADJ_MIN)
-			atomic_inc(&task->mm->oom_disable_count);
-		if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
-			atomic_dec(&task->mm->oom_disable_count);
-	}
 	task->signal->oom_score_adj = oom_score_adj;
 	if (has_capability_noaudit(current, CAP_SYS_RESOURCE))
 		task->signal->oom_score_adj_min = oom_score_adj;
diff -puN include/linux/mm_types.h~oom-remove-oom_disable_count include/linux/mm_types.h
--- a/include/linux/mm_types.h~oom-remove-oom_disable_count
+++ a/include/linux/mm_types.h
@@ -336,9 +336,6 @@ struct mm_struct {
 	unsigned int token_priority;
 	unsigned int last_interval;
 
-	/* How many tasks sharing this mm are OOM_DISABLE */
-	atomic_t oom_disable_count;
-
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	struct core_state *core_state; /* coredumping support */
diff -puN kernel/exit.c~oom-remove-oom_disable_count kernel/exit.c
--- a/kernel/exit.c~oom-remove-oom_disable_count
+++ a/kernel/exit.c
@@ -681,8 +681,6 @@ static void exit_mm(struct task_struct *
 	enter_lazy_tlb(mm, current);
 	/* We don't want this task to be frozen prematurely */
 	clear_freeze_flag(tsk);
-	if (tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
-		atomic_dec(&mm->oom_disable_count);
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
 	mmput(mm);
diff -puN kernel/fork.c~oom-remove-oom_disable_count kernel/fork.c
--- a/kernel/fork.c~oom-remove-oom_disable_count
+++ a/kernel/fork.c
@@ -501,7 +501,6 @@ static struct mm_struct *mm_init(struct 
 	mm->cached_hole_size = ~0UL;
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
-	atomic_set(&mm->oom_disable_count, 0);
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
@@ -816,8 +815,6 @@ good_mm:
 	/* Initializing for Swap token stuff */
 	mm->token_priority = 0;
 	mm->last_interval = 0;
-	if (tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
-		atomic_inc(&mm->oom_disable_count);
 
 	tsk->mm = mm;
 	tsk->active_mm = mm;
@@ -1391,13 +1388,8 @@ bad_fork_cleanup_io:
 bad_fork_cleanup_namespaces:
 	exit_task_namespaces(p);
 bad_fork_cleanup_mm:
-	if (p->mm) {
-		task_lock(p);
-		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
-			atomic_dec(&p->mm->oom_disable_count);
-		task_unlock(p);
+	if (p->mm)
 		mmput(p->mm);
-	}
 bad_fork_cleanup_signal:
 	if (!(clone_flags & CLONE_THREAD))
 		free_signal_struct(p->signal);
diff -puN mm/oom_kill.c~oom-remove-oom_disable_count mm/oom_kill.c
--- a/mm/oom_kill.c~oom-remove-oom_disable_count
+++ a/mm/oom_kill.c
@@ -54,13 +54,7 @@ int test_set_oom_score_adj(int new_val)
 
 	spin_lock_irq(&sighand->siglock);
 	old_val = current->signal->oom_score_adj;
-	if (new_val != old_val) {
-		if (new_val == OOM_SCORE_ADJ_MIN)
-			atomic_inc(&current->mm->oom_disable_count);
-		else if (old_val == OOM_SCORE_ADJ_MIN)
-			atomic_dec(&current->mm->oom_disable_count);
-		current->signal->oom_score_adj = new_val;
-	}
+	current->signal->oom_score_adj = new_val;
 	spin_unlock_irq(&sighand->siglock);
 
 	return old_val;
@@ -173,16 +167,6 @@ unsigned int oom_badness(struct task_str
 		return 0;
 
 	/*
-	 * Shortcut check for a thread sharing p->mm that is OOM_SCORE_ADJ_MIN
-	 * so the entire heuristic doesn't need to be executed for something
-	 * that cannot be killed.
-	 */
-	if (atomic_read(&p->mm->oom_disable_count)) {
-		task_unlock(p);
-		return 0;
-	}
-
-	/*
 	 * The memory controller may have a limit of 0 bytes, so avoid a divide
 	 * by zero, if necessary.
 	 */
@@ -451,6 +435,9 @@ static int oom_kill_task(struct task_str
 	for_each_process(q)
 		if (q->mm == mm && !same_thread_group(q, p) &&
 		    !(q->flags & PF_KTHREAD)) {
+			if (q->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
+				continue;
+
 			task_lock(q);	/* Protect ->comm from prctl() */
 			pr_err("Kill process %d (%s) sharing same memory\n",
 				task_pid_nr(q), q->comm);
@@ -727,7 +714,7 @@ void out_of_memory(struct zonelist *zone
 	read_lock(&tasklist_lock);
 	if (sysctl_oom_kill_allocating_task &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
-	    current->mm && !atomic_read(&current->mm->oom_disable_count)) {
+	    current->mm) {
 		/*
 		 * oom_kill_process() needs tasklist_lock held.  If it returns
 		 * non-zero, current could not be killed so we must fallback to
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch
cpusets-avoid-looping-when-storing-to-mems_allowed-if-one-node-remains-set.patch

