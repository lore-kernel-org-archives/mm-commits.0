From: akpm@linux-foundation.org
Subject: [patch 085/117] oom, oom_reaper: try to reap tasks which skip
 regular OOM killer path
Date: Thu, 19 May 2016 17:13:12 -0700
Message-ID: <573e5698.5oihJXQVNZzDsSA8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbcETANN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:13:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, daniel.vetter@intel.com, mst@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, rmaksudova@parallels.com

From: Michal Hocko <mhocko@suse.com>
Subject: oom, oom_reaper: try to reap tasks which skip regular OOM killer path

If either the current task is already killed or PF_EXITING or a selected
task is PF_EXITING then the oom killer is suppressed and so is the oom
reaper.  This patch adds try_oom_reaper which checks the given task and
queues it for the oom reaper if that is safe to be done meaning that the
task doesn't share the mm with an alive process.

This might help to release the memory pressure while the task tries to
exit.

[akpm@linux-foundation.org: fix nommu build]
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Raushaniya Maksudova <rmaksudova@parallels.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    8 +++
 mm/memcontrol.c     |    1 
 mm/oom_kill.c       |   86 +++++++++++++++++++++++++++++++++---------
 3 files changed, 77 insertions(+), 18 deletions(-)

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
+void try_oom_reaper(struct task_struct *tsk)
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
@@ -653,24 +719,6 @@ void oom_killer_enable(void)
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
@@ -694,6 +742,7 @@ void oom_kill_process(struct oom_control
 	task_lock(p);
 	if (p->mm && task_will_free_mem(p)) {
 		mark_oom_victim(p);
+		try_oom_reaper(p);
 		task_unlock(p);
 		put_task_struct(p);
 		return;
@@ -873,6 +922,7 @@ bool out_of_memory(struct oom_control *o
 	if (current->mm &&
 	    (fatal_signal_pending(current) || task_will_free_mem(current))) {
 		mark_oom_victim(current);
+		try_oom_reaper(current);
 		return true;
 	}
 
diff -puN include/linux/oom.h~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path include/linux/oom.h
--- a/include/linux/oom.h~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path
+++ a/include/linux/oom.h
@@ -72,6 +72,14 @@ static inline bool oom_task_origin(const
 
 extern void mark_oom_victim(struct task_struct *tsk);
 
+#ifdef CONFIG_MMU
+extern void try_oom_reaper(struct task_struct *tsk);
+#else
+static inline void try_oom_reaper(struct task_struct *tsk)
+{
+}
+#endif
+
 extern unsigned long oom_badness(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
 		unsigned long totalpages);
diff -puN mm/memcontrol.c~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path mm/memcontrol.c
--- a/mm/memcontrol.c~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path
+++ a/mm/memcontrol.c
@@ -1275,6 +1275,7 @@ static bool mem_cgroup_out_of_memory(str
 	 */
 	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
 		mark_oom_victim(current);
+		try_oom_reaper(current);
 		goto unlock;
 	}
 
_
