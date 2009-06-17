From: akpm@linux-foundation.org
Subject: [merged] oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:56 -0700
Message-ID: <200906171835.n5HIZuog001923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756371AbZFQSw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mel@csn.ul.ie, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     oom: move oom_adj value from task_struct to mm_struct
has been removed from the -mm tree.  Its filename was
     oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: move oom_adj value from task_struct to mm_struct
From: David Rientjes <rientjes@google.com>

The per-task oom_adj value is a characteristic of its mm more than the
task itself since it's not possible to oom kill any thread that shares the
mm.  If a task were to be killed while attached to an mm that could not be
freed because another thread were set to OOM_DISABLE, it would have
needlessly been terminated since there is no potential for future memory
freeing.

This patch moves oomkilladj (now more appropriately named oom_adj) from
struct task_struct to struct mm_struct.  This requires task_lock() on a
task to check its oom_adj value to protect against exec, but it's already
necessary to take the lock when dereferencing the mm to find the total VM
size for the badness heuristic.

This fixes a livelock if the oom killer chooses a task and another thread
sharing the same memory has an oom_adj value of OOM_DISABLE.  This occurs
because oom_kill_task() repeatedly returns 1 and refuses to kill the
chosen task while select_bad_process() will repeatedly choose the same
task during the next retry.

Taking task_lock() in select_bad_process() to check for OOM_DISABLE and in
oom_kill_task() to check for threads sharing the same memory will be
removed in the next patch in this series where it will no longer be
necessary.

Writing to /proc/pid/oom_adj for a kthread will now return -EINVAL since
these threads are immune from oom killing already.  They simply report an
oom_adj value of OOM_DISABLE.

Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   15 +++++++----
 fs/proc/base.c                     |   19 ++++++++++++---
 include/linux/mm_types.h           |    2 +
 include/linux/sched.h              |    1 
 mm/oom_kill.c                      |   34 +++++++++++++++++----------
 5 files changed, 50 insertions(+), 21 deletions(-)

diff -puN Documentation/filesystems/proc.txt~oom-move-oom_adj-value-from-task_struct-to-mm_struct Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~oom-move-oom_adj-value-from-task_struct-to-mm_struct
+++ a/Documentation/filesystems/proc.txt
@@ -1003,11 +1003,13 @@ CHAPTER 3: PER-PROCESS PARAMETERS
 3.1 /proc/<pid>/oom_adj - Adjust the oom-killer score
 ------------------------------------------------------
 
-This file can be used to adjust the score used to select which processes
-should be killed in an  out-of-memory  situation.  Giving it a high score will
-increase the likelihood of this process being killed by the oom-killer.  Valid
-values are in the range -16 to +15, plus the special value -17, which disables
-oom-killing altogether for this process.
+This file can be used to adjust the score used to select which processes should
+be killed in an out-of-memory situation.  The oom_adj value is a characteristic
+of the task's mm, so all threads that share an mm with pid will have the same
+oom_adj value.  A high value will increase the likelihood of this process being
+killed by the oom-killer.  Valid values are in the range -16 to +15 as
+explained below and a special value of -17, which disables oom-killing
+altogether for threads sharing pid's mm.
 
 The process to be killed in an out-of-memory situation is selected among all others
 based on its badness score. This value equals the original memory size of the process
@@ -1021,6 +1023,9 @@ the parent's score if they do not share 
 are the prime candidates to be killed. Having only one 'hungry' child will make
 parent less preferable than the child.
 
+/proc/<pid>/oom_adj cannot be changed for kthreads since they are immune from
+oom-killing already.
+
 /proc/<pid>/oom_score shows process' current badness score.
 
 The following heuristics are then applied:
diff -puN fs/proc/base.c~oom-move-oom_adj-value-from-task_struct-to-mm_struct fs/proc/base.c
--- a/fs/proc/base.c~oom-move-oom_adj-value-from-task_struct-to-mm_struct
+++ a/fs/proc/base.c
@@ -1006,7 +1006,12 @@ static ssize_t oom_adjust_read(struct fi
 
 	if (!task)
 		return -ESRCH;
-	oom_adjust = task->oomkilladj;
+	task_lock(task);
+	if (task->mm)
+		oom_adjust = task->mm->oom_adj;
+	else
+		oom_adjust = OOM_DISABLE;
+	task_unlock(task);
 	put_task_struct(task);
 
 	len = snprintf(buffer, sizeof(buffer), "%i\n", oom_adjust);
@@ -1035,11 +1040,19 @@ static ssize_t oom_adjust_write(struct f
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
-	if (oom_adjust < task->oomkilladj && !capable(CAP_SYS_RESOURCE)) {
+	task_lock(task);
+	if (!task->mm) {
+		task_unlock(task);
+		put_task_struct(task);
+		return -EINVAL;
+	}
+	if (oom_adjust < task->mm->oom_adj && !capable(CAP_SYS_RESOURCE)) {
+		task_unlock(task);
 		put_task_struct(task);
 		return -EACCES;
 	}
-	task->oomkilladj = oom_adjust;
+	task->mm->oom_adj = oom_adjust;
+	task_unlock(task);
 	put_task_struct(task);
 	if (end - buffer == 0)
 		return -EIO;
diff -puN include/linux/mm_types.h~oom-move-oom_adj-value-from-task_struct-to-mm_struct include/linux/mm_types.h
--- a/include/linux/mm_types.h~oom-move-oom_adj-value-from-task_struct-to-mm_struct
+++ a/include/linux/mm_types.h
@@ -232,6 +232,8 @@ struct mm_struct {
 
 	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
+	s8 oom_adj;	/* OOM kill score adjustment (bit shift) */
+
 	cpumask_t cpu_vm_mask;
 
 	/* Architecture-specific MM context */
diff -puN include/linux/sched.h~oom-move-oom_adj-value-from-task_struct-to-mm_struct include/linux/sched.h
--- a/include/linux/sched.h~oom-move-oom_adj-value-from-task_struct-to-mm_struct
+++ a/include/linux/sched.h
@@ -1178,7 +1178,6 @@ struct task_struct {
 	 * a short time
 	 */
 	unsigned char fpu_counter;
-	s8 oomkilladj; /* OOM kill score adjustment (bit shift). */
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
diff -puN mm/oom_kill.c~oom-move-oom_adj-value-from-task_struct-to-mm_struct mm/oom_kill.c
--- a/mm/oom_kill.c~oom-move-oom_adj-value-from-task_struct-to-mm_struct
+++ a/mm/oom_kill.c
@@ -58,6 +58,7 @@ unsigned long badness(struct task_struct
 	unsigned long points, cpu_time, run_time;
 	struct mm_struct *mm;
 	struct task_struct *child;
+	int oom_adj;
 
 	task_lock(p);
 	mm = p->mm;
@@ -65,6 +66,7 @@ unsigned long badness(struct task_struct
 		task_unlock(p);
 		return 0;
 	}
+	oom_adj = mm->oom_adj;
 
 	/*
 	 * The memory size of the process is the basis for the badness.
@@ -148,15 +150,15 @@ unsigned long badness(struct task_struct
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
@@ -251,8 +253,12 @@ static struct task_struct *select_bad_pr
 			*ppoints = ULONG_MAX;
 		}
 
-		if (p->oomkilladj == OOM_DISABLE)
+		task_lock(p);
+		if (p->mm && p->mm->oom_adj == OOM_DISABLE) {
+			task_unlock(p);
 			continue;
+		}
+		task_unlock(p);
 
 		points = badness(p, uptime.tv_sec);
 		if (points > *ppoints || !chosen) {
@@ -304,8 +310,7 @@ static void dump_tasks(const struct mem_
 		}
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
 		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
-		       get_mm_rss(mm), (int)task_cpu(p), p->oomkilladj,
-		       p->comm);
+		       get_mm_rss(mm), (int)task_cpu(p), mm->oom_adj, p->comm);
 		task_unlock(p);
 	} while_each_thread(g, p);
 }
@@ -367,8 +372,12 @@ static int oom_kill_task(struct task_str
 	 * Don't kill the process if any threads are set to OOM_DISABLE
 	 */
 	do_each_thread(g, q) {
-		if (q->mm == mm && q->oomkilladj == OOM_DISABLE)
+		task_lock(q);
+		if (q->mm == mm && q->mm && q->mm->oom_adj == OOM_DISABLE) {
+			task_unlock(q);
 			return 1;
+		}
+		task_unlock(q);
 	} while_each_thread(g, q);
 
 	__oom_kill_task(p, 1);
@@ -393,10 +402,11 @@ static int oom_kill_process(struct task_
 	struct task_struct *c;
 
 	if (printk_ratelimit()) {
-		printk(KERN_WARNING "%s invoked oom-killer: "
-			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
-			current->comm, gfp_mask, order, current->oomkilladj);
 		task_lock(current);
+		printk(KERN_WARNING "%s invoked oom-killer: "
+			"gfp_mask=0x%x, order=%d, oom_adj=%d\n",
+			current->comm, gfp_mask, order,
+			current->mm ? current->mm->oom_adj : OOM_DISABLE);
 		cpuset_print_task_mems_allowed(current);
 		task_unlock(current);
 		dump_stack();
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

