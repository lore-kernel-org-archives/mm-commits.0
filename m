From: akpm@linux-foundation.org
Subject: + mm-oom-fortify-task_will_free_mem.patch added to -mm tree
Date: Wed, 22 Jun 2016 14:46:02 -0700
Message-ID: <576b071a.a6EgQgysJgrUOKZR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbcFVVqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 17:46:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: fortify task_will_free_mem
has been added to the -mm tree.  Its filename is
     mm-oom-fortify-task_will_free_mem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-fortify-task_will_free_mem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-fortify-task_will_free_mem.patch

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
Subject: mm, oom: fortify task_will_free_mem

task_will_free_mem is rather weak.  It doesn't really tell whether the
task has chance to drop its mm.  98748bd72200 ("oom: consider
multi-threaded tasks in task_will_free_mem") made a first step into making
it more robust for multi-threaded applications so now we know that the
whole process is going down and probably drop the mm.

This patch builds on top for more complex scenarios where mm is shared
between different processes - CLONE_VM without CLONE_SIGHAND, or in kernel
use_mm().

Make sure that all processes sharing the mm are killed or exiting.  This
will allow us to replace try_oom_reaper by wake_oom_reaper because
task_will_free_mem implies the task is reapable now.  Therefore all paths
which bypass the oom killer are now reapable and so they shouldn't lock up
the oom killer.

Link: http://lkml.kernel.org/r/1466426628-15074-8-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |   26 --------
 mm/memcontrol.c     |    4 -
 mm/oom_kill.c       |  133 +++++++++++++++++++++++++-----------------
 3 files changed, 85 insertions(+), 78 deletions(-)

diff -puN include/linux/oom.h~mm-oom-fortify-task_will_free_mem include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-fortify-task_will_free_mem
+++ a/include/linux/oom.h
@@ -73,9 +73,9 @@ static inline bool oom_task_origin(const
 extern void mark_oom_victim(struct task_struct *tsk);
 
 #ifdef CONFIG_MMU
-extern void try_oom_reaper(struct task_struct *tsk);
+extern void wake_oom_reaper(struct task_struct *tsk);
 #else
-static inline void try_oom_reaper(struct task_struct *tsk)
+static inline void wake_oom_reaper(struct task_struct *tsk)
 {
 }
 #endif
@@ -107,27 +107,7 @@ extern void oom_killer_enable(void);
 
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
-static inline bool task_will_free_mem(struct task_struct *task)
-{
-	struct signal_struct *sig = task->signal;
-
-	/*
-	 * A coredumping process may sleep for an extended period in exit_mm(),
-	 * so the oom killer cannot assume that the process will promptly exit
-	 * and release memory.
-	 */
-	if (sig->flags & SIGNAL_GROUP_COREDUMP)
-		return false;
-
-	if (!(task->flags & PF_EXITING))
-		return false;
-
-	/* Make sure that the whole thread group is going down */
-	if (!thread_group_empty(task) && !(sig->flags & SIGNAL_GROUP_EXIT))
-		return false;
-
-	return true;
-}
+bool task_will_free_mem(struct task_struct *task);
 
 /* sysctls */
 extern int sysctl_oom_dump_tasks;
diff -puN mm/memcontrol.c~mm-oom-fortify-task_will_free_mem mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom-fortify-task_will_free_mem
+++ a/mm/memcontrol.c
@@ -1221,9 +1221,9 @@ static bool mem_cgroup_out_of_memory(str
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
+	if (task_will_free_mem(current)) {
 		mark_oom_victim(current);
-		try_oom_reaper(current);
+		wake_oom_reaper(current);
 		goto unlock;
 	}
 
diff -puN mm/oom_kill.c~mm-oom-fortify-task_will_free_mem mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-fortify-task_will_free_mem
+++ a/mm/oom_kill.c
@@ -596,7 +596,7 @@ static int oom_reaper(void *unused)
 	return 0;
 }
 
-static void wake_oom_reaper(struct task_struct *tsk)
+void wake_oom_reaper(struct task_struct *tsk)
 {
 	if (!oom_reaper_th)
 		return;
@@ -614,46 +614,6 @@ static void wake_oom_reaper(struct task_
 	wake_up(&oom_reaper_wait);
 }
 
-/* Check if we can reap the given task. This has to be called with stable
- * tsk->mm
- */
-void try_oom_reaper(struct task_struct *tsk)
-{
-	struct mm_struct *mm = tsk->mm;
-	struct task_struct *p;
-
-	if (!mm)
-		return;
-
-	/*
-	 * There might be other threads/processes which are either not
-	 * dying or even not killable.
-	 */
-	if (atomic_read(&mm->mm_users) > 1) {
-		rcu_read_lock();
-		for_each_process(p) {
-			if (!process_shares_mm(p, mm))
-				continue;
-			if (fatal_signal_pending(p))
-				continue;
-
-			/*
-			 * If the task is exiting make sure the whole thread group
-			 * is exiting and cannot acces mm anymore.
-			 */
-			if (signal_group_exit(p->signal))
-				continue;
-
-			/* Give up */
-			rcu_read_unlock();
-			return;
-		}
-		rcu_read_unlock();
-	}
-
-	wake_oom_reaper(tsk);
-}
-
 static int __init oom_init(void)
 {
 	oom_reaper_th = kthread_run(oom_reaper, NULL, "oom_reaper");
@@ -665,10 +625,6 @@ static int __init oom_init(void)
 	return 0;
 }
 subsys_initcall(oom_init)
-#else
-static void wake_oom_reaper(struct task_struct *tsk)
-{
-}
 #endif
 
 /**
@@ -745,6 +701,81 @@ void oom_killer_enable(void)
 	oom_killer_disabled = false;
 }
 
+static inline bool __task_will_free_mem(struct task_struct *task)
+{
+	struct signal_struct *sig = task->signal;
+
+	/*
+	 * A coredumping process may sleep for an extended period in exit_mm(),
+	 * so the oom killer cannot assume that the process will promptly exit
+	 * and release memory.
+	 */
+	if (sig->flags & SIGNAL_GROUP_COREDUMP)
+		return false;
+
+	if (sig->flags & SIGNAL_GROUP_EXIT)
+		return true;
+
+	if (thread_group_empty(task) && (task->flags & PF_EXITING))
+		return true;
+
+	return false;
+}
+
+/*
+ * Checks whether the given task is dying or exiting and likely to
+ * release its address space. This means that all threads and processes
+ * sharing the same mm have to be killed or exiting.
+ */
+bool task_will_free_mem(struct task_struct *task)
+{
+	struct mm_struct *mm;
+	struct task_struct *p;
+	bool ret;
+
+	if (!__task_will_free_mem(task))
+		return false;
+
+	/*
+	 * If the process has passed exit_mm we have to skip it because
+	 * we have lost a link to other tasks sharing this mm, we do not
+	 * have anything to reap and the task might then get stuck waiting
+	 * for parent as zombie and we do not want it to hold TIF_MEMDIE
+	 */
+	p = find_lock_task_mm(task);
+	if (!p)
+		return false;
+
+	mm = p->mm;
+	if (atomic_read(&mm->mm_users) <= 1) {
+		task_unlock(p);
+		return true;
+	}
+
+	/* pin the mm to not get freed and reused */
+	atomic_inc(&mm->mm_count);
+	task_unlock(p);
+
+	/*
+	 * This is really pessimistic but we do not have any reliable way
+	 * to check that external processes share with our mm
+	 */
+	rcu_read_lock();
+	for_each_process(p) {
+		if (!process_shares_mm(p, mm))
+			continue;
+		if (same_thread_group(task, p))
+			continue;
+		ret = __task_will_free_mem(p);
+		if (!ret)
+			break;
+	}
+	rcu_read_unlock();
+	mmdrop(mm);
+
+	return ret;
+}
+
 /*
  * Must be called while holding a reference to p, which will be released upon
  * returning.
@@ -766,15 +797,12 @@ void oom_kill_process(struct oom_control
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
-	task_lock(p);
-	if (p->mm && task_will_free_mem(p)) {
+	if (task_will_free_mem(p)) {
 		mark_oom_victim(p);
-		try_oom_reaper(p);
-		task_unlock(p);
+		wake_oom_reaper(p);
 		put_task_struct(p);
 		return;
 	}
-	task_unlock(p);
 
 	if (__ratelimit(&oom_rs))
 		dump_header(oc, p);
@@ -944,10 +972,9 @@ bool out_of_memory(struct oom_control *o
 	 * But don't select if current has already released its mm and cleared
 	 * TIF_MEMDIE flag at exit_mm(), otherwise an OOM livelock may occur.
 	 */
-	if (current->mm &&
-	    (fatal_signal_pending(current) || task_will_free_mem(current))) {
+	if (current->mm && task_will_free_mem(current)) {
 		mark_oom_victim(current);
-		try_oom_reaper(current);
+		wake_oom_reaper(current);
 		return true;
 	}
 
_

Patches currently in -mm which might be from mhocko@suse.com are

tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch
x86-get-rid-of-superfluous-__gfp_repeat.patch
x86-efi-get-rid-of-superfluous-__gfp_repeat.patch
arm64-get-rid-of-superfluous-__gfp_repeat.patch
arc-get-rid-of-superfluous-__gfp_repeat.patch
mips-get-rid-of-superfluous-__gfp_repeat.patch
nios2-get-rid-of-superfluous-__gfp_repeat.patch
parisc-get-rid-of-superfluous-__gfp_repeat.patch
score-get-rid-of-superfluous-__gfp_repeat.patch
powerpc-get-rid-of-superfluous-__gfp_repeat.patch
sparc-get-rid-of-superfluous-__gfp_repeat.patch
s390-get-rid-of-superfluous-__gfp_repeat.patch
sh-get-rid-of-superfluous-__gfp_repeat.patch
tile-get-rid-of-superfluous-__gfp_repeat.patch
unicore32-get-rid-of-superfluous-__gfp_repeat.patch
jbd2-get-rid-of-superfluous-__gfp_repeat.patch
arm-get-rid-of-superfluous-__gfp_repeat.patch
slab-make-gfp_slab_bug_mask-information-more-human-readable.patch
slab-do-not-panic-on-invalid-gfp_mask.patch
mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped.patch
mm-memcg-use-consistent-gfp-flags-during-readahead.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch
proc-oom-drop-bogus-task_lock-and-mm-check.patch
proc-oom-drop-bogus-sighand-lock.patch
proc-oom_adj-extract-oom_score_adj-setting-into-a-helper.patch
mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj.patch
mm-oom-skip-vforked-tasks-from-being-selected.patch
mm-oom-kill-all-tasks-sharing-the-mm.patch
mm-oom-fortify-task_will_free_mem.patch
mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch
mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice.patch
mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch

