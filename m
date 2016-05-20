From: akpm@linux-foundation.org
Subject: [patch 021/162] mm,oom: speed up select_bad_process() loop
Date: Fri, 20 May 2016 16:57:27 -0700
Message-ID: <573fa467.XCS1HqZA6S2FNg9d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbcETX52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:57:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, penguin-kernel@I-love.SAKURA.ne.jp, mhocko@suse.com, oleg@redhat.com, rientjes@google.com

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm,oom: speed up select_bad_process() loop

Since commit 3a5dda7a17cf3706 ("oom: prevent unnecessary oom kills or
kernel panics"), select_bad_process() is using for_each_process_thread().

Since oom_unkillable_task() scans all threads in the caller's thread group
and oom_task_origin() scans signal_struct of the caller's thread group, we
don't need to call oom_unkillable_task() and oom_task_origin() on each
thread.  Also, since !mm test will be done later at oom_badness(), we
don't need to do !mm test on each thread.  Therefore, we only need to do
TIF_MEMDIE test on each thread.

Although the original code was correct it was quite inefficient because
each thread group was scanned num_threads times which can be a lot
especially with processes with many threads.  Even though the OOM is
extremely cold path it is always good to be as effective as possible when
we are inside rcu_read_lock() - aka unpreemptible context.

If we track number of TIF_MEMDIE threads inside signal_struct, we don't
need to do TIF_MEMDIE test on each thread.  This will allow
select_bad_process() to use for_each_process().

This patch adds a counter to signal_struct for tracking how many
TIF_MEMDIE threads are in a given thread group, and check it at
oom_scan_process_thread() so that select_bad_process() can use
for_each_process() rather than for_each_process_thread().

[mhocko@suse.com: do not blow the signal_struct size]
  Link: http://lkml.kernel.org/r/20160520075035.GF19172@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/201605182230.IDC73435.MVSOHLFOQFOJtF@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 +
 mm/oom_kill.c         |   17 ++++++-----------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff -puN include/linux/sched.h~mmoom-speed-up-select_bad_process-loop include/linux/sched.h
--- a/include/linux/sched.h~mmoom-speed-up-select_bad_process-loop
+++ a/include/linux/sched.h
@@ -669,6 +669,7 @@ struct signal_struct {
 	atomic_t		sigcnt;
 	atomic_t		live;
 	int			nr_threads;
+	atomic_t oom_victims; /* # of TIF_MEDIE threads in this thread group */
 	struct list_head	thread_head;
 
 	wait_queue_head_t	wait_chldexit;	/* for wait4() */
diff -puN mm/oom_kill.c~mmoom-speed-up-select_bad_process-loop mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-speed-up-select_bad_process-loop
+++ a/mm/oom_kill.c
@@ -283,12 +283,8 @@ enum oom_scan_t oom_scan_process_thread(
 	 * This task already has access to memory reserves and is being killed.
 	 * Don't allow any other task to have access to the reserves.
 	 */
-	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
-		if (!is_sysrq_oom(oc))
-			return OOM_SCAN_ABORT;
-	}
-	if (!task->mm)
-		return OOM_SCAN_CONTINUE;
+	if (!is_sysrq_oom(oc) && atomic_read(&task->signal->oom_victims))
+		return OOM_SCAN_ABORT;
 
 	/*
 	 * If task is allocating a lot of memory and has been marked to be
@@ -307,12 +303,12 @@ enum oom_scan_t oom_scan_process_thread(
 static struct task_struct *select_bad_process(struct oom_control *oc,
 		unsigned int *ppoints, unsigned long totalpages)
 {
-	struct task_struct *g, *p;
+	struct task_struct *p;
 	struct task_struct *chosen = NULL;
 	unsigned long chosen_points = 0;
 
 	rcu_read_lock();
-	for_each_process_thread(g, p) {
+	for_each_process(p) {
 		unsigned int points;
 
 		switch (oom_scan_process_thread(oc, p, totalpages)) {
@@ -331,9 +327,6 @@ static struct task_struct *select_bad_pr
 		points = oom_badness(p, NULL, oc->nodemask, totalpages);
 		if (!points || points < chosen_points)
 			continue;
-		/* Prefer thread group leaders for display purposes */
-		if (points == chosen_points && thread_group_leader(chosen))
-			continue;
 
 		chosen = p;
 		chosen_points = points;
@@ -673,6 +666,7 @@ void mark_oom_victim(struct task_struct
 	/* OOM killer might race with memcg OOM */
 	if (test_and_set_tsk_thread_flag(tsk, TIF_MEMDIE))
 		return;
+	atomic_inc(&tsk->signal->oom_victims);
 	/*
 	 * Make sure that the task is woken up from uninterruptible sleep
 	 * if it is frozen because OOM killer wouldn't be able to free
@@ -690,6 +684,7 @@ void exit_oom_victim(struct task_struct
 {
 	if (!test_and_clear_tsk_thread_flag(tsk, TIF_MEMDIE))
 		return;
+	atomic_dec(&tsk->signal->oom_victims);
 
 	if (!atomic_dec_return(&oom_victims))
 		wake_up_all(&oom_victims_wait);
_
