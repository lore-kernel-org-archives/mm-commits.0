From: akpm@linux-foundation.org
Subject: [patch 043/127] mm, oom: get rid of signal_struct::oom_victims
Date: Fri, 07 Oct 2016 16:58:57 -0700
Message-ID: <57f836c1.Si6ReJHeLwBpmYxf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39856 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755330AbcJHAFu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:05:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@parallels.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: get rid of signal_struct::oom_victims

After "oom: keep mm of the killed task available" we can safely detect an
oom victim by checking task->signal->oom_mm so we do not need the
signal_struct counter anymore so let's get rid of it.

This alone wouldn't be sufficient for nommu archs because exit_oom_victim
doesn't hide the process from the oom killer anymore.  We can, however,
mark the mm with a MMF flag in __mmput.  We can reuse MMF_OOM_REAPED and
rename it to a more generic MMF_OOM_SKIP.

Link: http://lkml.kernel.org/r/1472119394-11342-6-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h   |    5 +++++
 include/linux/sched.h |    3 +--
 kernel/fork.c         |    1 +
 mm/oom_kill.c         |   17 +++++++----------
 4 files changed, 14 insertions(+), 12 deletions(-)

diff -puN include/linux/oom.h~mm-oom-get-rid-of-signal_struct-oom_victims include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-get-rid-of-signal_struct-oom_victims
+++ a/include/linux/oom.h
@@ -58,6 +58,11 @@ static inline bool oom_task_origin(const
 	return p->signal->oom_flag_origin;
 }
 
+static inline bool tsk_is_oom_victim(struct task_struct * tsk)
+{
+	return tsk->signal->oom_mm;
+}
+
 extern unsigned long oom_badness(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
 		unsigned long totalpages);
diff -puN include/linux/sched.h~mm-oom-get-rid-of-signal_struct-oom_victims include/linux/sched.h
--- a/include/linux/sched.h~mm-oom-get-rid-of-signal_struct-oom_victims
+++ a/include/linux/sched.h
@@ -524,7 +524,7 @@ static inline int get_dumpable(struct mm
 
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
-#define MMF_OOM_REAPED		21	/* mm has been already reaped */
+#define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
@@ -672,7 +672,6 @@ struct signal_struct {
 	atomic_t		sigcnt;
 	atomic_t		live;
 	int			nr_threads;
-	atomic_t oom_victims; /* # of TIF_MEDIE threads in this thread group */
 	struct list_head	thread_head;
 
 	wait_queue_head_t	wait_chldexit;	/* for wait4() */
diff -puN kernel/fork.c~mm-oom-get-rid-of-signal_struct-oom_victims kernel/fork.c
--- a/kernel/fork.c~mm-oom-get-rid-of-signal_struct-oom_victims
+++ a/kernel/fork.c
@@ -862,6 +862,7 @@ static inline void __mmput(struct mm_str
 	}
 	if (mm->binfmt)
 		module_put(mm->binfmt->module);
+	set_bit(MMF_OOM_SKIP, &mm->flags);
 	mmdrop(mm);
 }
 
diff -puN mm/oom_kill.c~mm-oom-get-rid-of-signal_struct-oom_victims mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-get-rid-of-signal_struct-oom_victims
+++ a/mm/oom_kill.c
@@ -186,7 +186,7 @@ unsigned long oom_badness(struct task_st
 	 */
 	adj = (long)p->signal->oom_score_adj;
 	if (adj == OOM_SCORE_ADJ_MIN ||
-			test_bit(MMF_OOM_REAPED, &p->mm->flags) ||
+			test_bit(MMF_OOM_SKIP, &p->mm->flags) ||
 			in_vfork(p)) {
 		task_unlock(p);
 		return 0;
@@ -296,11 +296,11 @@ static int oom_evaluate_task(struct task
 	/*
 	 * This task already has access to memory reserves and is being killed.
 	 * Don't allow any other task to have access to the reserves unless
-	 * the task has MMF_OOM_REAPED because chances that it would release
+	 * the task has MMF_OOM_SKIP because chances that it would release
 	 * any memory is quite low.
 	 */
-	if (!is_sysrq_oom(oc) && atomic_read(&task->signal->oom_victims)) {
-		if (test_bit(MMF_OOM_REAPED, &task->signal->oom_mm->flags))
+	if (!is_sysrq_oom(oc) && tsk_is_oom_victim(task)) {
+		if (test_bit(MMF_OOM_SKIP, &task->signal->oom_mm->flags))
 			goto next;
 		goto abort;
 	}
@@ -572,7 +572,7 @@ done:
 	 * Hide this mm from OOM killer because it has been either reaped or
 	 * somebody can't call up_write(mmap_sem).
 	 */
-	set_bit(MMF_OOM_REAPED, &mm->flags);
+	set_bit(MMF_OOM_SKIP, &mm->flags);
 
 	/* Drop a reference taken by wake_oom_reaper */
 	put_task_struct(tsk);
@@ -654,8 +654,6 @@ static void mark_oom_victim(struct task_
 	if (test_and_set_tsk_thread_flag(tsk, TIF_MEMDIE))
 		return;
 
-	atomic_inc(&tsk->signal->oom_victims);
-
 	/* oom_mm is bound to the signal struct life time. */
 	if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm))
 		atomic_inc(&tsk->signal->oom_mm->mm_count);
@@ -677,7 +675,6 @@ void exit_oom_victim(struct task_struct
 {
 	if (!test_and_clear_tsk_thread_flag(tsk, TIF_MEMDIE))
 		return;
-	atomic_dec(&tsk->signal->oom_victims);
 
 	if (!atomic_dec_return(&oom_victims))
 		wake_up_all(&oom_victims_wait);
@@ -769,7 +766,7 @@ static bool task_will_free_mem(struct ta
 	 * This task has already been drained by the oom reaper so there are
 	 * only small chances it will free some more
 	 */
-	if (test_bit(MMF_OOM_REAPED, &mm->flags))
+	if (test_bit(MMF_OOM_SKIP, &mm->flags))
 		return false;
 
 	if (atomic_read(&mm->mm_users) <= 1)
@@ -906,7 +903,7 @@ static void oom_kill_process(struct oom_
 			 * killer to guarantee OOM forward progress.
 			 */
 			can_oom_reap = false;
-			set_bit(MMF_OOM_REAPED, &mm->flags);
+			set_bit(MMF_OOM_SKIP, &mm->flags);
 			pr_info("oom killer %d (%s) has mm pinned by %d (%s)\n",
 					task_pid_nr(victim), victim->comm,
 					task_pid_nr(p), p->comm);
_
