From: akpm@linux-foundation.org
Subject: + oom-move-oom_adj-to-signal_struct.patch added to -mm tree
Date: Wed, 05 Aug 2009 16:40:42 -0700
Message-ID: <200908052340.n75NegVg008310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbZHEXl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 19:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, riel@redhat.com, rientjes@google.com


The patch titled
     oom: move oom_adj to signal_struct
has been added to the -mm tree.  Its filename is
     oom-move-oom_adj-to-signal_struct.patch

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
Subject: oom: move oom_adj to signal_struct
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The commit 2ff05b2b (oom: move oom_adj value) move oom_adj value to
mm_struct.  It is very good first step for sanitize OOM.

However Paul Menage reported the commit makes regression to his job
scheduler.  Current OOM logic can kill OOM_DISABLED process.

Why? His program has the code of similar to the following.

	...
	set_oom_adj(OOM_DISABLE); /* The job scheduler never killed by oom */
	...
	if (vfork() == 0) {
		set_oom_adj(0); /* Invoked child can be killed */
		execve("foo-bar-cmd")
	}
	....

vfork() parent and child are shared the same mm_struct.  then above
set_oom_adj(0) doesn't only change oom_adj for vfork() child, but also
change oom_adj for vfork() parent.  Then, vfork() parent (job scheduler)
lost OOM immune and it was killed.

Actually, fork-setting-exec idiom is very frequently used in userland
program.  We must not break this assumption.

Therefore, this patch move oom_adj again.  it will be moved signal_struct.
 it is truth per-process data place.

Plus, Restored writing to /proc/pid/oom_adj for a kernel thread return
success again.  changing return value might make confusing to
shell-script.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    9 +---
 fs/proc/base.c                     |   33 ++++++++------
 include/linux/mm_types.h           |    2 
 include/linux/sched.h              |    2 
 kernel/fork.c                      |    3 -
 mm/oom_kill.c                      |   60 +++++++++++++++++++--------
 6 files changed, 70 insertions(+), 39 deletions(-)

diff -puN Documentation/filesystems/proc.txt~oom-move-oom_adj-to-signal_struct Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~oom-move-oom_adj-to-signal_struct
+++ a/Documentation/filesystems/proc.txt
@@ -1181,12 +1181,11 @@ CHAPTER 3: PER-PROCESS PARAMETERS
 ------------------------------------------------------
 
 This file can be used to adjust the score used to select which processes should
-be killed in an out-of-memory situation.  The oom_adj value is a characteristic
-of the task's mm, so all threads that share an mm with pid will have the same
+be killed in an out-of-memory situation. All threads in the process will have the same
 oom_adj value.  A high value will increase the likelihood of this process being
 killed by the oom-killer.  Valid values are in the range -16 to +15 as
 explained below and a special value of -17, which disables oom-killing
-altogether for threads sharing pid's mm.
+altogether the process.
 
 The process to be killed in an out-of-memory situation is selected among all others
 based on its badness score. This value equals the original memory size of the process
@@ -1200,8 +1199,8 @@ the parent's score if they do not share 
 are the prime candidates to be killed. Having only one 'hungry' child will make
 parent less preferable than the child.
 
-/proc/<pid>/oom_adj cannot be changed for kthreads since they are immune from
-oom-killing already.
+/proc/<pid>/oom_adj can be changed for kthreads, but it's meaningless. They are immune from
+oom-killing.
 
 /proc/<pid>/oom_score shows process' current badness score.
 
diff -puN fs/proc/base.c~oom-move-oom_adj-to-signal_struct fs/proc/base.c
--- a/fs/proc/base.c~oom-move-oom_adj-to-signal_struct
+++ a/fs/proc/base.c
@@ -1001,16 +1001,17 @@ static ssize_t oom_adjust_read(struct fi
 	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
 	char buffer[PROC_NUMBUF];
 	size_t len;
-	int oom_adjust;
+	int oom_adjust = OOM_DISABLE;
+	unsigned long flags;
 
 	if (!task)
 		return -ESRCH;
-	task_lock(task);
-	if (task->mm)
-		oom_adjust = task->mm->oom_adj;
-	else
-		oom_adjust = OOM_DISABLE;
-	task_unlock(task);
+
+	if (lock_task_sighand(task, &flags)) {
+		oom_adjust = task->signal->oom_adj;
+		unlock_task_sighand(task, &flags);
+	}
+
 	put_task_struct(task);
 
 	len = snprintf(buffer, sizeof(buffer), "%i\n", oom_adjust);
@@ -1024,6 +1025,7 @@ static ssize_t oom_adjust_write(struct f
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF], *end;
 	int oom_adjust;
+	unsigned long flags;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
@@ -1039,19 +1041,20 @@ static ssize_t oom_adjust_write(struct f
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
-	task_lock(task);
-	if (!task->mm) {
-		task_unlock(task);
+
+	if (!lock_task_sighand(task, &flags)) {
 		put_task_struct(task);
-		return -EINVAL;
+		return -ESRCH;
 	}
-	if (oom_adjust < task->mm->oom_adj && !capable(CAP_SYS_RESOURCE)) {
-		task_unlock(task);
+
+	if (oom_adjust < task->signal->oom_adj && !capable(CAP_SYS_RESOURCE)) {
+		unlock_task_sighand(task, &flags);
 		put_task_struct(task);
 		return -EACCES;
 	}
-	task->mm->oom_adj = oom_adjust;
-	task_unlock(task);
+
+	task->signal->oom_adj = oom_adjust;
+	unlock_task_sighand(task, &flags);
 	put_task_struct(task);
 	if (end - buffer == 0)
 		return -EIO;
diff -puN include/linux/mm_types.h~oom-move-oom_adj-to-signal_struct include/linux/mm_types.h
--- a/include/linux/mm_types.h~oom-move-oom_adj-to-signal_struct
+++ a/include/linux/mm_types.h
@@ -240,8 +240,6 @@ struct mm_struct {
 
 	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
-	s8 oom_adj;	/* OOM kill score adjustment (bit shift) */
-
 	cpumask_t cpu_vm_mask;
 
 	/* Architecture-specific MM context */
diff -puN include/linux/sched.h~oom-move-oom_adj-to-signal_struct include/linux/sched.h
--- a/include/linux/sched.h~oom-move-oom_adj-to-signal_struct
+++ a/include/linux/sched.h
@@ -652,6 +652,8 @@ struct signal_struct {
 	unsigned audit_tty;
 	struct tty_audit_buf *tty_audit_buf;
 #endif
+
+	int oom_adj;	/* OOM kill score adjustment (bit shift) */
 };
 
 /* Context switch must be unlocked if interrupts are to be enabled */
diff -puN kernel/fork.c~oom-move-oom_adj-to-signal_struct kernel/fork.c
--- a/kernel/fork.c~oom-move-oom_adj-to-signal_struct
+++ a/kernel/fork.c
@@ -448,7 +448,6 @@ static struct mm_struct * mm_init(struct
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->flags = (current->mm) ?
 		(current->mm->flags & MMF_INIT_MASK) : default_dump_filter;
-	mm->oom_adj = (current->mm) ? current->mm->oom_adj : 0;
 	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
@@ -890,6 +889,8 @@ static int copy_signal(unsigned long clo
 
 	tty_audit_fork(sig);
 
+	sig->oom_adj = current->signal->oom_adj;
+
 	return 0;
 }
 
diff -puN mm/oom_kill.c~oom-move-oom_adj-to-signal_struct mm/oom_kill.c
--- a/mm/oom_kill.c~oom-move-oom_adj-to-signal_struct
+++ a/mm/oom_kill.c
@@ -34,6 +34,31 @@ int sysctl_oom_dump_tasks;
 static DEFINE_SPINLOCK(zone_scan_lock);
 /* #define DEBUG */
 
+int get_oom_adj(struct task_struct *tsk)
+{
+	unsigned long flags;
+	int oom_adj = OOM_DISABLE;
+
+	if (tsk->mm && lock_task_sighand(tsk, &flags)) {
+		oom_adj = tsk->signal->oom_adj;
+		unlock_task_sighand(tsk, &flags);
+	}
+
+	return oom_adj;
+}
+
+void set_oom_adj(struct task_struct *tsk, int oom_adj)
+{
+	unsigned long flags;
+
+	if (lock_task_sighand(tsk, &flags)) {
+		tsk->signal->oom_adj = oom_adj;
+		unlock_task_sighand(tsk, &flags);
+	}
+}
+
+
+
 /**
  * badness - calculate a numeric value for how bad this task has been
  * @p: task struct of which task we should calculate
@@ -60,17 +85,16 @@ unsigned long badness(struct task_struct
 	struct task_struct *child;
 	int oom_adj;
 
+	oom_adj = get_oom_adj(p);
+	if (oom_adj == OOM_DISABLE)
+		return 0;
+
 	task_lock(p);
 	mm = p->mm;
 	if (!mm) {
 		task_unlock(p);
 		return 0;
 	}
-	oom_adj = mm->oom_adj;
-	if (oom_adj == OOM_DISABLE) {
-		task_unlock(p);
-		return 0;
-	}
 
 	/*
 	 * The memory size of the process is the basis for the badness.
@@ -283,6 +307,8 @@ static struct task_struct *select_bad_pr
 static void dump_tasks(const struct mem_cgroup *mem)
 {
 	struct task_struct *g, *p;
+	unsigned long flags;
+	int oom_adj;
 
 	printk(KERN_INFO "[ pid ]   uid  tgid total_vm      rss cpu oom_adj "
 	       "name\n");
@@ -294,6 +320,12 @@ static void dump_tasks(const struct mem_
 		if (!thread_group_leader(p))
 			continue;
 
+		if (!lock_task_sighand(p, &flags))
+			continue;
+
+		oom_adj = p->signal->oom_adj;
+		unlock_task_sighand(p, &flags);
+
 		task_lock(p);
 		mm = p->mm;
 		if (!mm) {
@@ -307,7 +339,7 @@ static void dump_tasks(const struct mem_
 		}
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
 		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
-		       get_mm_rss(mm), (int)task_cpu(p), mm->oom_adj, p->comm);
+		       get_mm_rss(mm), (int)task_cpu(p), oom_adj, p->comm);
 		task_unlock(p);
 	} while_each_thread(g, p);
 }
@@ -345,16 +377,11 @@ static void __oom_kill_task(struct task_
 
 static int oom_kill_task(struct task_struct *p)
 {
-	struct mm_struct *mm;
 	struct task_struct *g, *q;
 
-	task_lock(p);
-	mm = p->mm;
-	if (!mm || mm->oom_adj == OOM_DISABLE) {
-		task_unlock(p);
+	if (get_oom_adj(p) == OOM_DISABLE)
 		return 1;
-	}
-	task_unlock(p);
+
 	__oom_kill_task(p, 1);
 
 	/*
@@ -363,7 +390,7 @@ static int oom_kill_task(struct task_str
 	 * to memory reserves though, otherwise we might deplete all memory.
 	 */
 	do_each_thread(g, q) {
-		if (q->mm == mm && !same_thread_group(q, p))
+		if (q->mm == p->mm && !same_thread_group(q, p))
 			force_sig(SIGKILL, q);
 	} while_each_thread(g, q);
 
@@ -377,11 +404,12 @@ static int oom_kill_process(struct task_
 	struct task_struct *c;
 
 	if (printk_ratelimit()) {
+		int oom_adj = get_oom_adj(current);
+
 		task_lock(current);
 		printk(KERN_WARNING "%s invoked oom-killer: "
 			"gfp_mask=0x%x, order=%d, oom_adj=%d\n",
-			current->comm, gfp_mask, order,
-			current->mm ? current->mm->oom_adj : OOM_DISABLE);
+			current->comm, gfp_mask, order, oom_adj);
 		cpuset_print_task_mems_allowed(current);
 		task_unlock(current);
 		dump_stack();
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-rename-pgmoved-variable-in-shrink_active_list.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
oom-move-oom_adj-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
oom-fix-oom_adjust_write-input-sanity-check-fix.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

