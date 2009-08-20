From: akpm@linux-foundation.org
Subject: [merged] mm-revert-oom-move-oom_adj-value.patch removed from -mm tree
Date: Thu, 20 Aug 2009 13:12:44 -0700
Message-ID: <200908202012.n7KKCick015471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755301AbZHTUOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 16:14:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, menage@google.com, npiggin@suse.de, oleg@redhat.com, riel@redhat.com, rientjes@google.com, torvalds@linu


The patch titled
     mm: revert "oom: move oom_adj value"
has been removed from the -mm tree.  Its filename was
     mm-revert-oom-move-oom_adj-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: revert "oom: move oom_adj value"
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The commit 2ff05b2b (oom: move oom_adj value) moveed the oom_adj value to
the mm_struct.  It was a very good first step for sanitize OOM.

However Paul Menage reported the commit makes regression to his job
scheduler.  Current OOM logic can kill OOM_DISABLED process.

Why? His program has the code of similar to the following.

	...
	set_oom_adj(OOM_DISABLE); /* The job scheduler never killed by oom */
	...
	if (vfork() == 0) {
		set_oom_adj(0); /* Invoked child can be killed */
		execve("foo-bar-cmd");
	}
	....

vfork() parent and child are shared the same mm_struct.  then above
set_oom_adj(0) doesn't only change oom_adj for vfork() child, it's also
change oom_adj for vfork() parent.  Then, vfork() parent (job scheduler)
lost OOM immune and it was killed.

Actually, fork-setting-exec idiom is very frequently used in userland program.
We must not break this assumption.

Then, this patch revert commit 2ff05b2b and related commit.

Reverted commit list
---------------------
- commit 2ff05b2b4e (oom: move oom_adj value from task_struct to mm_struct)
- commit 4d8b9135c3 (oom: avoid unnecessary mm locking and scanning for OOM_DISABLE)
- commit 8123681022 (oom: only oom kill exiting tasks with attached memory)
- commit 933b787b57 (mm: copy over oom_adj value at fork time)

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   15 ++----
 fs/proc/base.c                     |   19 +-------
 include/linux/mm_types.h           |    2 
 include/linux/sched.h              |    1 
 kernel/fork.c                      |    1 
 mm/oom_kill.c                      |   64 ++++++++++++++++-----------
 6 files changed, 48 insertions(+), 54 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-revert-oom-move-oom_adj-value Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-revert-oom-move-oom_adj-value
+++ a/Documentation/filesystems/proc.txt
@@ -1167,13 +1167,11 @@ CHAPTER 3: PER-PROCESS PARAMETERS
 3.1 /proc/<pid>/oom_adj - Adjust the oom-killer score
 ------------------------------------------------------
 
-This file can be used to adjust the score used to select which processes should
-be killed in an out-of-memory situation.  The oom_adj value is a characteristic
-of the task's mm, so all threads that share an mm with pid will have the same
-oom_adj value.  A high value will increase the likelihood of this process being
-killed by the oom-killer.  Valid values are in the range -16 to +15 as
-explained below and a special value of -17, which disables oom-killing
-altogether for threads sharing pid's mm.
+This file can be used to adjust the score used to select which processes
+should be killed in an  out-of-memory  situation.  Giving it a high score will
+increase the likelihood of this process being killed by the oom-killer.  Valid
+values are in the range -16 to +15, plus the special value -17, which disables
+oom-killing altogether for this process.
 
 The process to be killed in an out-of-memory situation is selected among all others
 based on its badness score. This value equals the original memory size of the process
@@ -1187,9 +1185,6 @@ the parent's score if they do not share 
 are the prime candidates to be killed. Having only one 'hungry' child will make
 parent less preferable than the child.
 
-/proc/<pid>/oom_adj cannot be changed for kthreads since they are immune from
-oom-killing already.
-
 /proc/<pid>/oom_score shows process' current badness score.
 
 The following heuristics are then applied:
diff -puN fs/proc/base.c~mm-revert-oom-move-oom_adj-value fs/proc/base.c
--- a/fs/proc/base.c~mm-revert-oom-move-oom_adj-value
+++ a/fs/proc/base.c
@@ -1003,12 +1003,7 @@ static ssize_t oom_adjust_read(struct fi
 
 	if (!task)
 		return -ESRCH;
-	task_lock(task);
-	if (task->mm)
-		oom_adjust = task->mm->oom_adj;
-	else
-		oom_adjust = OOM_DISABLE;
-	task_unlock(task);
+	oom_adjust = task->oomkilladj;
 	put_task_struct(task);
 
 	len = snprintf(buffer, sizeof(buffer), "%i\n", oom_adjust);
@@ -1037,19 +1032,11 @@ static ssize_t oom_adjust_write(struct f
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
-	task_lock(task);
-	if (!task->mm) {
-		task_unlock(task);
-		put_task_struct(task);
-		return -EINVAL;
-	}
-	if (oom_adjust < task->mm->oom_adj && !capable(CAP_SYS_RESOURCE)) {
-		task_unlock(task);
+	if (oom_adjust < task->oomkilladj && !capable(CAP_SYS_RESOURCE)) {
 		put_task_struct(task);
 		return -EACCES;
 	}
-	task->mm->oom_adj = oom_adjust;
-	task_unlock(task);
+	task->oomkilladj = oom_adjust;
 	put_task_struct(task);
 	if (end - buffer == 0)
 		return -EIO;
diff -puN include/linux/mm_types.h~mm-revert-oom-move-oom_adj-value include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-revert-oom-move-oom_adj-value
+++ a/include/linux/mm_types.h
@@ -240,8 +240,6 @@ struct mm_struct {
 
 	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
-	s8 oom_adj;	/* OOM kill score adjustment (bit shift) */
-
 	cpumask_t cpu_vm_mask;
 
 	/* Architecture-specific MM context */
diff -puN include/linux/sched.h~mm-revert-oom-move-oom_adj-value include/linux/sched.h
--- a/include/linux/sched.h~mm-revert-oom-move-oom_adj-value
+++ a/include/linux/sched.h
@@ -1198,6 +1198,7 @@ struct task_struct {
 	 * a short time
 	 */
 	unsigned char fpu_counter;
+	s8 oomkilladj; /* OOM kill score adjustment (bit shift). */
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
diff -puN kernel/fork.c~mm-revert-oom-move-oom_adj-value kernel/fork.c
--- a/kernel/fork.c~mm-revert-oom-move-oom_adj-value
+++ a/kernel/fork.c
@@ -426,7 +426,6 @@ static struct mm_struct * mm_init(struct
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
-	mm->oom_adj = (current->mm) ? current->mm->oom_adj : 0;
 	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
diff -puN mm/oom_kill.c~mm-revert-oom-move-oom_adj-value mm/oom_kill.c
--- a/mm/oom_kill.c~mm-revert-oom-move-oom_adj-value
+++ a/mm/oom_kill.c
@@ -58,7 +58,6 @@ unsigned long badness(struct task_struct
 	unsigned long points, cpu_time, run_time;
 	struct mm_struct *mm;
 	struct task_struct *child;
-	int oom_adj;
 
 	task_lock(p);
 	mm = p->mm;
@@ -66,11 +65,6 @@ unsigned long badness(struct task_struct
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
@@ -154,15 +148,15 @@ unsigned long badness(struct task_struct
 		points /= 8;
 
 	/*
-	 * Adjust the score by oom_adj.
+	 * Adjust the score by oomkilladj.
 	 */
-	if (oom_adj) {
-		if (oom_adj > 0) {
+	if (p->oomkilladj) {
+		if (p->oomkilladj > 0) {
 			if (!points)
 				points = 1;
-			points <<= oom_adj;
+			points <<= p->oomkilladj;
 		} else
-			points >>= -(oom_adj);
+			points >>= -(p->oomkilladj);
 	}
 
 #ifdef DEBUG
@@ -257,8 +251,11 @@ static struct task_struct *select_bad_pr
 			*ppoints = ULONG_MAX;
 		}
 
+		if (p->oomkilladj == OOM_DISABLE)
+			continue;
+
 		points = badness(p, uptime.tv_sec);
-		if (points > *ppoints) {
+		if (points > *ppoints || !chosen) {
 			chosen = p;
 			*ppoints = points;
 		}
@@ -307,7 +304,8 @@ static void dump_tasks(const struct mem_
 		}
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
 		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
-		       get_mm_rss(mm), (int)task_cpu(p), mm->oom_adj, p->comm);
+		       get_mm_rss(mm), (int)task_cpu(p), p->oomkilladj,
+		       p->comm);
 		task_unlock(p);
 	} while_each_thread(g, p);
 }
@@ -325,8 +323,11 @@ static void __oom_kill_task(struct task_
 		return;
 	}
 
-	if (!p->mm)
+	if (!p->mm) {
+		WARN_ON(1);
+		printk(KERN_WARNING "tried to kill an mm-less task!\n");
 		return;
+	}
 
 	if (verbose)
 		printk(KERN_ERR "Killed process %d (%s)\n",
@@ -348,13 +349,28 @@ static int oom_kill_task(struct task_str
 	struct mm_struct *mm;
 	struct task_struct *g, *q;
 
-	task_lock(p);
 	mm = p->mm;
-	if (!mm || mm->oom_adj == OOM_DISABLE) {
-		task_unlock(p);
+
+	/* WARNING: mm may not be dereferenced since we did not obtain its
+	 * value from get_task_mm(p).  This is OK since all we need to do is
+	 * compare mm to q->mm below.
+	 *
+	 * Furthermore, even if mm contains a non-NULL value, p->mm may
+	 * change to NULL at any time since we do not hold task_lock(p).
+	 * However, this is of no concern to us.
+	 */
+
+	if (mm == NULL)
 		return 1;
-	}
-	task_unlock(p);
+
+	/*
+	 * Don't kill the process if any threads are set to OOM_DISABLE
+	 */
+	do_each_thread(g, q) {
+		if (q->mm == mm && q->oomkilladj == OOM_DISABLE)
+			return 1;
+	} while_each_thread(g, q);
+
 	__oom_kill_task(p, 1);
 
 	/*
@@ -377,11 +393,10 @@ static int oom_kill_process(struct task_
 	struct task_struct *c;
 
 	if (printk_ratelimit()) {
-		task_lock(current);
 		printk(KERN_WARNING "%s invoked oom-killer: "
-			"gfp_mask=0x%x, order=%d, oom_adj=%d\n",
-			current->comm, gfp_mask, order,
-			current->mm ? current->mm->oom_adj : OOM_DISABLE);
+			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
+			current->comm, gfp_mask, order, current->oomkilladj);
+		task_lock(current);
 		cpuset_print_task_mems_allowed(current);
 		task_unlock(current);
 		dump_stack();
@@ -394,9 +409,8 @@ static int oom_kill_process(struct task_
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
-	 * if its mm is still attached.
 	 */
-	if (p->mm && (p->flags & PF_EXITING)) {
+	if (p->flags & PF_EXITING) {
 		__oom_kill_task(p, 0);
 		return 0;
 	}
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-fix-for-infinite-churning-of-mlocked-pages.patch
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
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
mm-drop-unneeded-double-negations.patch
mm-introduce-page_lru_base_type.patch
mm-return-boolean-from-page_is_file_cache.patch
mm-return-boolean-from-page_has_private.patch
mm-document-is_page_cache_freeable.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

