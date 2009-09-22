From: akpm@linux-foundation.org
Subject: [merged] oom-move-oom_adj-value-from-task_struct-to-signal_struct.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:42:20 -0700
Message-ID: <200909222042.n8MKgKBi009349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839AbZIVUmf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, oleg@redhat.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom: move oom_adj value from task_struct to signal_struct
has been removed from the -mm tree.  Its filename was
     oom-move-oom_adj-value-from-task_struct-to-signal_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: move oom_adj value from task_struct to signal_struct
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, OOM logic callflow is here.

    __out_of_memory()
        select_bad_process()            for each task
            badness()                   calculate badness of one task
                oom_kill_process()      search child
                    oom_kill_task()     kill target task and mm shared tasks with it

example, process-A have two thread, thread-A and thread-B and it have very
fat memory and each thread have following oom_adj and oom_score.

     thread-A: oom_adj = OOM_DISABLE, oom_score = 0
     thread-B: oom_adj = 0,           oom_score = very-high

Then, select_bad_process() select thread-B, but oom_kill_task() refuse
kill the task because thread-A have OOM_DISABLE.  Thus __out_of_memory()
call select_bad_process() again.  but select_bad_process() select the same
task.  It mean kernel fall in livelock.

The fact is, select_bad_process() must select killable task.  otherwise
OOM logic go into livelock.

And root cause is, oom_adj shouldn't be per-thread value.  it should be
per-process value because OOM-killer kill a process, not thread.  Thus
This patch moves oomkilladj (now more appropriately named oom_adj) from
struct task_struct to struct signal_struct.  it naturally prevent
select_bad_process() choose wrong task.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c        |   24 ++++++++++++++++++++----
 include/linux/sched.h |    3 ++-
 kernel/fork.c         |    2 ++
 mm/oom_kill.c         |   34 +++++++++++++++-------------------
 4 files changed, 39 insertions(+), 24 deletions(-)

diff -puN fs/proc/base.c~oom-move-oom_adj-value-from-task_struct-to-signal_struct fs/proc/base.c
--- a/fs/proc/base.c~oom-move-oom_adj-value-from-task_struct-to-signal_struct
+++ a/fs/proc/base.c
@@ -999,11 +999,17 @@ static ssize_t oom_adjust_read(struct fi
 	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
 	char buffer[PROC_NUMBUF];
 	size_t len;
-	int oom_adjust;
+	int oom_adjust = OOM_DISABLE;
+	unsigned long flags;
 
 	if (!task)
 		return -ESRCH;
-	oom_adjust = task->oomkilladj;
+
+	if (lock_task_sighand(task, &flags)) {
+		oom_adjust = task->signal->oom_adj;
+		unlock_task_sighand(task, &flags);
+	}
+
 	put_task_struct(task);
 
 	len = snprintf(buffer, sizeof(buffer), "%i\n", oom_adjust);
@@ -1017,6 +1023,7 @@ static ssize_t oom_adjust_write(struct f
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF], *end;
 	int oom_adjust;
+	unsigned long flags;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
@@ -1032,11 +1039,20 @@ static ssize_t oom_adjust_write(struct f
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
-	if (oom_adjust < task->oomkilladj && !capable(CAP_SYS_RESOURCE)) {
+	if (!lock_task_sighand(task, &flags)) {
+		put_task_struct(task);
+		return -ESRCH;
+	}
+
+	if (oom_adjust < task->signal->oom_adj && !capable(CAP_SYS_RESOURCE)) {
+		unlock_task_sighand(task, &flags);
 		put_task_struct(task);
 		return -EACCES;
 	}
-	task->oomkilladj = oom_adjust;
+
+	task->signal->oom_adj = oom_adjust;
+
+	unlock_task_sighand(task, &flags);
 	put_task_struct(task);
 	if (end - buffer == 0)
 		return -EIO;
diff -puN include/linux/sched.h~oom-move-oom_adj-value-from-task_struct-to-signal_struct include/linux/sched.h
--- a/include/linux/sched.h~oom-move-oom_adj-value-from-task_struct-to-signal_struct
+++ a/include/linux/sched.h
@@ -639,6 +639,8 @@ struct signal_struct {
 	unsigned audit_tty;
 	struct tty_audit_buf *tty_audit_buf;
 #endif
+
+	int oom_adj;	/* OOM kill score adjustment (bit shift) */
 };
 
 /* Context switch must be unlocked if interrupts are to be enabled */
@@ -1221,7 +1223,6 @@ struct task_struct {
 	 * a short time
 	 */
 	unsigned char fpu_counter;
-	s8 oomkilladj; /* OOM kill score adjustment (bit shift). */
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
diff -puN kernel/fork.c~oom-move-oom_adj-value-from-task_struct-to-signal_struct kernel/fork.c
--- a/kernel/fork.c~oom-move-oom_adj-value-from-task_struct-to-signal_struct
+++ a/kernel/fork.c
@@ -880,6 +880,8 @@ static int copy_signal(unsigned long clo
 
 	tty_audit_fork(sig);
 
+	sig->oom_adj = current->signal->oom_adj;
+
 	return 0;
 }
 
diff -puN mm/oom_kill.c~oom-move-oom_adj-value-from-task_struct-to-signal_struct mm/oom_kill.c
--- a/mm/oom_kill.c~oom-move-oom_adj-value-from-task_struct-to-signal_struct
+++ a/mm/oom_kill.c
@@ -58,6 +58,10 @@ unsigned long badness(struct task_struct
 	unsigned long points, cpu_time, run_time;
 	struct mm_struct *mm;
 	struct task_struct *child;
+	int oom_adj = p->signal->oom_adj;
+
+	if (oom_adj == OOM_DISABLE)
+		return 0;
 
 	task_lock(p);
 	mm = p->mm;
@@ -148,15 +152,15 @@ unsigned long badness(struct task_struct
 		points /= 8;
 
 	/*
-	 * Adjust the score by oomkilladj.
+	 * Adjust the score by oom_adj.
 	 */
-	if (p->oomkilladj) {
-		if (p->oomkilladj > 0) {
+	if (oom_adj) {
+		if (oom_adj > 0) {
 			if (!points)
 				points = 1;
-			points <<= p->oomkilladj;
+			points <<= oom_adj;
 		} else
-			points >>= -(p->oomkilladj);
+			points >>= -(oom_adj);
 	}
 
 #ifdef DEBUG
@@ -251,7 +255,7 @@ static struct task_struct *select_bad_pr
 			*ppoints = ULONG_MAX;
 		}
 
-		if (p->oomkilladj == OOM_DISABLE)
+		if (p->signal->oom_adj == OOM_DISABLE)
 			continue;
 
 		points = badness(p, uptime.tv_sec);
@@ -304,7 +308,7 @@ static void dump_tasks(const struct mem_
 		}
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
 		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
-		       get_mm_rss(mm), (int)task_cpu(p), p->oomkilladj,
+		       get_mm_rss(mm), (int)task_cpu(p), p->signal->oom_adj,
 		       p->comm);
 		task_unlock(p);
 	} while_each_thread(g, p);
@@ -359,18 +363,9 @@ static int oom_kill_task(struct task_str
 	 * change to NULL at any time since we do not hold task_lock(p).
 	 * However, this is of no concern to us.
 	 */
-
-	if (mm == NULL)
+	if (!mm || p->signal->oom_adj == OOM_DISABLE)
 		return 1;
 
-	/*
-	 * Don't kill the process if any threads are set to OOM_DISABLE
-	 */
-	do_each_thread(g, q) {
-		if (q->mm == mm && q->oomkilladj == OOM_DISABLE)
-			return 1;
-	} while_each_thread(g, q);
-
 	__oom_kill_task(p, 1);
 
 	/*
@@ -394,8 +389,9 @@ static int oom_kill_process(struct task_
 
 	if (printk_ratelimit()) {
 		printk(KERN_WARNING "%s invoked oom-killer: "
-			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
-			current->comm, gfp_mask, order, current->oomkilladj);
+			"gfp_mask=0x%x, order=%d, oom_adj=%d\n",
+			current->comm, gfp_mask, order,
+			current->signal->oom_adj);
 		task_lock(current);
 		cpuset_print_task_mems_allowed(current);
 		task_unlock(current);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
readahead-add-blk_run_backing_dev.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
getrusage-fill-ru_maxrss-value.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

