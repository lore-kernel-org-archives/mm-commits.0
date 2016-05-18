From: akpm@linux-foundation.org
Subject: + mmoom-speed-up-select_bad_process-loop.patch added to -mm tree
Date: Wed, 18 May 2016 14:09:58 -0700
Message-ID: <573cda26.bgNtxTF2Qia0MhSE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcERVJ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2016 17:09:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom: speed up select_bad_process() loop
has been added to the -mm tree.  Its filename is
     mmoom-speed-up-select_bad_process-loop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom-speed-up-select_bad_process-loop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom-speed-up-select_bad_process-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: http://lkml.kernel.org/r/201605182230.IDC73435.MVSOHLFOQFOJtF@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 +
 mm/oom_kill.c         |   14 ++++++--------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff -puN include/linux/sched.h~mmoom-speed-up-select_bad_process-loop include/linux/sched.h
--- a/include/linux/sched.h~mmoom-speed-up-select_bad_process-loop
+++ a/include/linux/sched.h
@@ -771,6 +771,7 @@ struct signal_struct {
 	 */
 	unsigned long long sum_sched_runtime;
 
+	atomic_t oom_victims; /* # of TIF_MEDIE threads in this thread group */
 	/*
 	 * We don't bother to synchronize most readers of this at all,
 	 * because there is no reader checking a limit that actually needs
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
@@ -673,6 +669,7 @@ void mark_oom_victim(struct task_struct
 	/* OOM killer might race with memcg OOM */
 	if (test_and_set_tsk_thread_flag(tsk, TIF_MEMDIE))
 		return;
+	atomic_inc(&tsk->signal->oom_victims);
 	/*
 	 * Make sure that the task is woken up from uninterruptible sleep
 	 * if it is frozen because OOM killer wouldn't be able to free
@@ -690,6 +687,7 @@ void exit_oom_victim(struct task_struct
 {
 	if (!test_and_clear_tsk_thread_flag(tsk, TIF_MEMDIE))
 		return;
+	atomic_dec(&tsk->signal->oom_victims);
 
 	if (!atomic_dec_return(&oom_victims))
 		wake_up_all(&oom_victims_wait);
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

mmoom-speed-up-select_bad_process-loop.patch
mmwriteback-dont-use-memory-reserves-for-wb_start_writeback.patch
signal-make-oom_flags-a-bool.patch

