From: akpm@linux-foundation.org
Subject: [patch 041/127] oom: keep mm of the killed task available
Date: Fri, 07 Oct 2016 16:58:51 -0700
Message-ID: <57f836bb.c9Aqb2SgHMbTJ3tG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753618AbcJHAFu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:05:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@parallels.com

From: Michal Hocko <mhocko@suse.com>
Subject: oom: keep mm of the killed task available

oom_reap_task has to call exit_oom_victim in order to make sure that the
oom vicim will not block the oom killer for ever.  This is, however,
opening new problems (e.g oom_killer_disable exclusion - see 74070542099c
("oom, suspend: fix oom_reaper vs.  oom_killer_disable race")). 
exit_oom_victim should be only called from the victim's context ideally.

One way to achieve this would be to rely on per mm_struct flags. We
already have MMF_OOM_REAPED to hide a task from the oom killer since
"mm, oom: hide mm which is shared with kthread or global init". The
problem is that the exit path:
do_exit
  exit_mm
    tsk->mm = NULL;
    mmput
      __mmput
    exit_oom_victim

doesn't guarantee that exit_oom_victim will get called in a bounded amount
of time.  At least exit_aio depends on IO which might get blocked due to
lack of memory and who knows what else is lurking there.

This patch takes a different approach.  We remember tsk->mm into the
signal_struct and bind it to the signal struct life time for all oom
victims.  __oom_reap_task_mm as well as oom_scan_process_thread do not
have to rely on find_lock_task_mm anymore and they will have a reliable
reference to the mm struct.  As a result all the oom specific
communication inside the OOM killer can be done via tsk->signal->oom_mm.

Increasing the signal_struct for something as unlikely as the oom killer
is far from ideal but this approach will make the code much more
reasonable and long term we even might want to move task->mm into the
signal_struct anyway.  In the next step we might want to make the oom
killer exclusion and access to memory reserves completely independent
which would be also nice.

Link: http://lkml.kernel.org/r/1472119394-11342-4-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +
 kernel/fork.c         |    2 +
 mm/oom_kill.c         |   51 ++++++++++++++--------------------------
 3 files changed, 23 insertions(+), 32 deletions(-)

diff -puN include/linux/sched.h~oom-keep-mm-of-the-killed-task-available include/linux/sched.h
--- a/include/linux/sched.h~oom-keep-mm-of-the-killed-task-available
+++ a/include/linux/sched.h
@@ -805,6 +805,8 @@ struct signal_struct {
 	short oom_score_adj;		/* OOM kill score adjustment */
 	short oom_score_adj_min;	/* OOM kill score adjustment min value.
 					 * Only settable by CAP_SYS_RESOURCE. */
+	struct mm_struct *oom_mm;	/* recorded mm when the thread group got
+					 * killed by the oom killer */
 
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
diff -puN kernel/fork.c~oom-keep-mm-of-the-killed-task-available kernel/fork.c
--- a/kernel/fork.c~oom-keep-mm-of-the-killed-task-available
+++ a/kernel/fork.c
@@ -359,6 +359,8 @@ static inline void free_signal_struct(st
 {
 	taskstats_tgid_free(sig);
 	sched_autogroup_exit(sig);
+	if (sig->oom_mm)
+		mmdrop(sig->oom_mm);
 	kmem_cache_free(signal_cachep, sig);
 }
 
diff -puN mm/oom_kill.c~oom-keep-mm-of-the-killed-task-available mm/oom_kill.c
--- a/mm/oom_kill.c~oom-keep-mm-of-the-killed-task-available
+++ a/mm/oom_kill.c
@@ -300,14 +300,7 @@ static int oom_evaluate_task(struct task
 	 * any memory is quite low.
 	 */
 	if (!is_sysrq_oom(oc) && atomic_read(&task->signal->oom_victims)) {
-		struct task_struct *p = find_lock_task_mm(task);
-		bool reaped = false;
-
-		if (p) {
-			reaped = test_bit(MMF_OOM_REAPED, &p->mm->flags);
-			task_unlock(p);
-		}
-		if (reaped)
+		if (test_bit(MMF_OOM_REAPED, &task->signal->oom_mm->flags))
 			goto next;
 		goto abort;
 	}
@@ -537,11 +530,6 @@ static bool __oom_reap_task_mm(struct ta
 	up_read(&mm->mmap_sem);
 
 	/*
-	 * This task can be safely ignored because we cannot do much more
-	 * to release its memory.
-	 */
-	set_bit(MMF_OOM_REAPED, &mm->flags);
-	/*
 	 * Drop our reference but make sure the mmput slow path is called from a
 	 * different context because we shouldn't risk we get stuck there and
 	 * put the oom_reaper out of the way.
@@ -556,20 +544,7 @@ unlock_oom:
 static void oom_reap_task(struct task_struct *tsk)
 {
 	int attempts = 0;
-	struct mm_struct *mm = NULL;
-	struct task_struct *p = find_lock_task_mm(tsk);
-
-	/*
-	 * Make sure we find the associated mm_struct even when the particular
-	 * thread has already terminated and cleared its mm.
-	 * We might have race with exit path so consider our work done if there
-	 * is no mm.
-	 */
-	if (!p)
-		goto done;
-	mm = p->mm;
-	atomic_inc(&mm->mm_count);
-	task_unlock(p);
+	struct mm_struct *mm = tsk->signal->oom_mm;
 
 	/* Retry the down_read_trylock(mmap_sem) a few times */
 	while (attempts++ < MAX_OOM_REAP_RETRIES && !__oom_reap_task_mm(tsk, mm))
@@ -578,8 +553,6 @@ static void oom_reap_task(struct task_st
 	if (attempts <= MAX_OOM_REAP_RETRIES)
 		goto done;
 
-	/* Ignore this mm because somebody can't call up_write(mmap_sem). */
-	set_bit(MMF_OOM_REAPED, &mm->flags);
 
 	pr_info("oom_reaper: unable to reap pid:%d (%s)\n",
 		task_pid_nr(tsk), tsk->comm);
@@ -595,11 +568,14 @@ done:
 	tsk->oom_reaper_list = NULL;
 	exit_oom_victim(tsk);
 
+	/*
+	 * Hide this mm from OOM killer because it has been either reaped or
+	 * somebody can't call up_write(mmap_sem).
+	 */
+	set_bit(MMF_OOM_REAPED, &mm->flags);
+
 	/* Drop a reference taken by wake_oom_reaper */
 	put_task_struct(tsk);
-	/* Drop a reference taken above. */
-	if (mm)
-		mmdrop(mm);
 }
 
 static int oom_reaper(void *unused)
@@ -665,14 +641,25 @@ static inline void wake_oom_reaper(struc
  *
  * Has to be called with oom_lock held and never after
  * oom has been disabled already.
+ *
+ * tsk->mm has to be non NULL and caller has to guarantee it is stable (either
+ * under task_lock or operate on the current).
  */
 static void mark_oom_victim(struct task_struct *tsk)
 {
+	struct mm_struct *mm = tsk->mm;
+
 	WARN_ON(oom_killer_disabled);
 	/* OOM killer might race with memcg OOM */
 	if (test_and_set_tsk_thread_flag(tsk, TIF_MEMDIE))
 		return;
+
 	atomic_inc(&tsk->signal->oom_victims);
+
+	/* oom_mm is bound to the signal struct life time. */
+	if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm))
+		atomic_inc(&tsk->signal->oom_mm->mm_count);
+
 	/*
 	 * Make sure that the task is woken up from uninterruptible sleep
 	 * if it is frozen because OOM killer wouldn't be able to free
_
