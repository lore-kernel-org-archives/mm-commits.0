From: akpm@linux-foundation.org
Subject: + oom-make-oom_score-to-per-process-value.patch added to -mm tree
Date: Wed, 05 Aug 2009 16:40:44 -0700
Message-ID: <200908052340.n75NeiGV008319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbZHEXl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 19:41:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, riel@redhat.com, rientjes@google.com


The patch titled
     oom: make oom_score to per-process value
has been added to the -mm tree.  Its filename is
     oom-make-oom_score-to-per-process-value.patch

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
Subject: oom: make oom_score to per-process value
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

oom-killer kill a process, not task.  Then oom_score should be calculated
as per-process too.  it makes consistency more and makes speed up
select_bad_process().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    4 +--
 fs/proc/base.c                     |    2 -
 mm/oom_kill.c                      |   36 +++++++++++++++++++++------
 3 files changed, 32 insertions(+), 10 deletions(-)

diff -puN Documentation/filesystems/proc.txt~oom-make-oom_score-to-per-process-value Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~oom-make-oom_score-to-per-process-value
+++ a/Documentation/filesystems/proc.txt
@@ -1208,13 +1208,13 @@ The following heuristics are then applie
  * if the task was reniced, its score doubles
  * superuser or direct hardware access tasks (CAP_SYS_ADMIN, CAP_SYS_RESOURCE
  	or CAP_SYS_RAWIO) have their score divided by 4
- * if oom condition happened in one cpuset and checked task does not belong
+ * if oom condition happened in one cpuset and checked process does not belong
  	to it, its score is divided by 8
  * the resulting score is multiplied by two to the power of oom_adj, i.e.
 	points <<= oom_adj when it is positive and
 	points >>= -(oom_adj) otherwise
 
-The task with the highest badness score is then selected and its children
+The process with the highest badness score is then selected and its children
 are killed, process itself will be killed in an OOM situation when it does
 not have children or some of them disabled oom like described above.
 
diff -puN fs/proc/base.c~oom-make-oom_score-to-per-process-value fs/proc/base.c
--- a/fs/proc/base.c~oom-make-oom_score-to-per-process-value
+++ a/fs/proc/base.c
@@ -449,7 +449,7 @@ static int proc_oom_score(struct task_st
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	read_lock(&tasklist_lock);
-	points = badness(task, uptime.tv_sec);
+	points = badness(task->group_leader, uptime.tv_sec);
 	read_unlock(&tasklist_lock);
 	return sprintf(buffer, "%lu\n", points);
 }
diff -puN mm/oom_kill.c~oom-make-oom_score-to-per-process-value mm/oom_kill.c
--- a/mm/oom_kill.c~oom-make-oom_score-to-per-process-value
+++ a/mm/oom_kill.c
@@ -58,6 +58,19 @@ void set_oom_adj(struct task_struct *tsk
 }
 
 
+static int has_intersects_mems_allowed(struct task_struct *tsk)
+{
+	struct task_struct *t;
+
+	t = tsk;
+	do {
+		if (cpuset_mems_allowed_intersects(current, t))
+			return 1;
+		t = next_thread(t);
+	} while (t != tsk);
+
+	return 0;
+}
 
 /**
  * badness - calculate a numeric value for how bad this task has been
@@ -77,18 +90,26 @@ void set_oom_adj(struct task_struct *tsk
  *    algorithm has been meticulously tuned to meet the principle
  *    of least surprise ... (be careful when you change it)
  */
-
 unsigned long badness(struct task_struct *p, unsigned long uptime)
 {
 	unsigned long points, cpu_time, run_time;
 	struct mm_struct *mm;
 	struct task_struct *child;
 	int oom_adj;
+	struct task_cputime task_time;
+	unsigned long flags;
+	unsigned long utime;
+	unsigned long stime;
 
 	oom_adj = get_oom_adj(p);
 	if (oom_adj == OOM_DISABLE)
 		return 0;
 
+	if (!lock_task_sighand(p, &flags))
+		return 0;
+	thread_group_cputime(p, &task_time);
+	unlock_task_sighand(p, &flags);
+
 	task_lock(p);
 	mm = p->mm;
 	if (!mm) {
@@ -132,8 +153,9 @@ unsigned long badness(struct task_struct
          * of seconds. There is no particular reason for this other than
          * that it turned out to work very well in practice.
 	 */
-	cpu_time = (cputime_to_jiffies(p->utime) + cputime_to_jiffies(p->stime))
-		>> (SHIFT_HZ + 3);
+	utime = cputime_to_jiffies(task_time.utime);
+	stime = cputime_to_jiffies(task_time.stime);
+	cpu_time = (utime + stime) >> (SHIFT_HZ + 3);
 
 	if (uptime >= p->start_time.tv_sec)
 		run_time = (uptime - p->start_time.tv_sec) >> 10;
@@ -174,7 +196,7 @@ unsigned long badness(struct task_struct
 	 * because p may have allocated or otherwise mapped memory on
 	 * this node before. However it will be less likely.
 	 */
-	if (!cpuset_mems_allowed_intersects(current, p))
+	if (!has_intersects_mems_allowed(p))
 		points /= 8;
 
 	/*
@@ -230,13 +252,13 @@ static inline enum oom_constraint constr
 static struct task_struct *select_bad_process(unsigned long *ppoints,
 						struct mem_cgroup *mem)
 {
-	struct task_struct *g, *p;
+	struct task_struct *p;
 	struct task_struct *chosen = NULL;
 	struct timespec uptime;
 	*ppoints = 0;
 
 	do_posix_clock_monotonic_gettime(&uptime);
-	do_each_thread(g, p) {
+	for_each_process(p) {
 		unsigned long points;
 
 		/*
@@ -286,7 +308,7 @@ static struct task_struct *select_bad_pr
 			chosen = p;
 			*ppoints = points;
 		}
-	} while_each_thread(g, p);
+	}
 
 	return chosen;
 }
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

