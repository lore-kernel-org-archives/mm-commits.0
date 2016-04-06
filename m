From: akpm@linux-foundation.org
Subject: +
 oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
 added to -mm tree
Date: Wed, 06 Apr 2016 11:58:49 -0700
Message-ID: <57055c69.z5mKPdyfmOraX+VZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbcDFS6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Apr 2016 14:58:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, daniel.vetter@intel.com, mst@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, rmaksudova@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom, oom_reaper: try to reap tasks which skip regular OOM killer path
has been added to the -mm tree.  Its filename is
     oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: oom, oom_reaper: try to reap tasks which skip regular OOM killer path

If either the current task is already killed or PF_EXITING or a selected
task is PF_EXITING then the oom killer is suppressed and so is the oom
reaper.  This patch adds try_oom_reaper which checks the given task and
queues it for the oom reaper if that is safe to be done meaning that the
task doesn't share the mm with an alive process.

This might help to release the memory pressure while the task tries to
exit.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Raushaniya Maksudova <rmaksudova@parallels.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   90 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 72 insertions(+), 18 deletions(-)

diff -puN mm/oom_kill.c~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path mm/oom_kill.c
--- a/mm/oom_kill.c~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path
+++ a/mm/oom_kill.c
@@ -412,6 +412,25 @@ bool oom_killer_disabled __read_mostly;
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
 
+/*
+ * task->mm can be NULL if the task is the exited group leader.  So to
+ * determine whether the task is using a particular mm, we examine all the
+ * task's threads: if one of those is using this mm then this task was also
+ * using it.
+ */
+static bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
+{
+	struct task_struct *t;
+
+	for_each_thread(p, t) {
+		struct mm_struct *t_mm = READ_ONCE(t->mm);
+		if (t_mm)
+			return t_mm == mm;
+	}
+	return false;
+}
+
+
 #ifdef CONFIG_MMU
 /*
  * OOM Reaper kernel thread which tries to reap the memory used by the OOM
@@ -563,6 +582,53 @@ static void wake_oom_reaper(struct task_
 	wake_up(&oom_reaper_wait);
 }
 
+/* Check if we can reap the given task. This has to be called with stable
+ * tsk->mm
+ */
+static void try_oom_reaper(struct task_struct *tsk)
+{
+	struct mm_struct *mm = tsk->mm;
+	struct task_struct *p;
+
+	if (!mm)
+		return;
+
+	/*
+	 * There might be other threads/processes which are either not
+	 * dying or even not killable.
+	 */
+	if (atomic_read(&mm->mm_users) > 1) {
+		rcu_read_lock();
+		for_each_process(p) {
+			bool exiting;
+
+			if (!process_shares_mm(p, mm))
+				continue;
+			if (same_thread_group(p, tsk))
+				continue;
+			if (fatal_signal_pending(p))
+				continue;
+
+			/*
+			 * If the task is exiting make sure the whole thread group
+			 * is exiting and cannot acces mm anymore.
+			 */
+			spin_lock_irq(&p->sighand->siglock);
+			exiting = signal_group_exit(p->signal);
+			spin_unlock_irq(&p->sighand->siglock);
+			if (exiting)
+				continue;
+
+			/* Give up */
+			rcu_read_unlock();
+			return;
+		}
+		rcu_read_unlock();
+	}
+
+	wake_oom_reaper(tsk);
+}
+
 static int __init oom_init(void)
 {
 	oom_reaper_th = kthread_run(oom_reaper, NULL, "oom_reaper");
@@ -575,6 +641,10 @@ static int __init oom_init(void)
 }
 subsys_initcall(oom_init)
 #else
+static void try_oom_reaper(struct task_struct *tsk)
+{
+}
+
 static void wake_oom_reaper(struct task_struct *tsk)
 {
 }
@@ -653,24 +723,6 @@ void oom_killer_enable(void)
 }
 
 /*
- * task->mm can be NULL if the task is the exited group leader.  So to
- * determine whether the task is using a particular mm, we examine all the
- * task's threads: if one of those is using this mm then this task was also
- * using it.
- */
-static bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
-{
-	struct task_struct *t;
-
-	for_each_thread(p, t) {
-		struct mm_struct *t_mm = READ_ONCE(t->mm);
-		if (t_mm)
-			return t_mm == mm;
-	}
-	return false;
-}
-
-/*
  * Must be called while holding a reference to p, which will be released upon
  * returning.
  */
@@ -694,6 +746,7 @@ void oom_kill_process(struct oom_control
 	task_lock(p);
 	if (p->mm && task_will_free_mem(p)) {
 		mark_oom_victim(p);
+		try_oom_reaper(p);
 		task_unlock(p);
 		put_task_struct(p);
 		return;
@@ -873,6 +926,7 @@ bool out_of_memory(struct oom_control *o
 	if (current->mm &&
 	    (fatal_signal_pending(current) || task_will_free_mem(current))) {
 		mark_oom_victim(current);
+		try_oom_reaper(current);
 		return true;
 	}
 
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-oom-move-gfp_nofs-check-to-out_of_memory.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-compaction-change-compact_-constants-into-enum.patch
mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
mm-compaction-update-compaction_result-ordering.patch
mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch
mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch

