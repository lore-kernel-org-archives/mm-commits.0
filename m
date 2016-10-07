From: akpm@linux-foundation.org
Subject: [patch 044/127] oom, suspend: fix oom_killer_disable vs. pm
 suspend properly
Date: Fri, 07 Oct 2016 16:59:00 -0700
Message-ID: <57f836c4.shI8F6ZF2EArg9YR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39858 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754858AbcJHAFu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:05:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@parallels.com

From: Michal Hocko <mhocko@suse.com>
Subject: oom, suspend: fix oom_killer_disable vs. pm suspend properly

74070542099c ("oom, suspend: fix oom_reaper vs.  oom_killer_disable race")
has workaround an existing race between oom_killer_disable and oom_reaper
by adding another round of try_to_freeze_tasks after the oom killer was
disabled.  This was the easiest thing to do for a late 4.7 fix.  Let's fix
it properly now.

After "oom: keep mm of the killed task available" we no longer have to
call exit_oom_victim from the oom reaper because we have stable mm
available and hide the oom_reaped mm by MMF_OOM_SKIP flag.  So let's
remove exit_oom_victim and the race described in the above commit doesn't
exist anymore if.

Unfortunately this alone is not sufficient for the oom_killer_disable
usecase because now we do not have any reliable way to reach
exit_oom_victim (the victim might get stuck on a way to exit for an
unbounded amount of time).  OOM killer can cope with that by checking mm
flags and move on to another victim but we cannot do the same for
oom_killer_disable as we would lose the guarantee of no further
interference of the victim with the rest of the system.  What we can do
instead is to cap the maximum time the oom_killer_disable waits for
victims.  The only current user of this function (pm suspend) already has
a concept of timeout for back off so we can reuse the same value there.

Let's drop set_freezable for the oom_reaper kthread because it is no
longer needed as the reaper doesn't wake or thaw any processes.

Link: http://lkml.kernel.org/r/1472119394-11342-7-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h    |    2 -
 kernel/power/process.c |   17 ++--------------
 mm/oom_kill.c          |   40 +++++++++++++++++++--------------------
 3 files changed, 24 insertions(+), 35 deletions(-)

diff -puN include/linux/oom.h~oom-suspend-fix-oom_killer_disable-vs-pm-suspend-properly include/linux/oom.h
--- a/include/linux/oom.h~oom-suspend-fix-oom_killer_disable-vs-pm-suspend-properly
+++ a/include/linux/oom.h
@@ -74,7 +74,7 @@ extern void exit_oom_victim(struct task_
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
 
-extern bool oom_killer_disable(void);
+extern bool oom_killer_disable(signed long timeout);
 extern void oom_killer_enable(void);
 
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
diff -puN kernel/power/process.c~oom-suspend-fix-oom_killer_disable-vs-pm-suspend-properly kernel/power/process.c
--- a/kernel/power/process.c~oom-suspend-fix-oom_killer_disable-vs-pm-suspend-properly
+++ a/kernel/power/process.c
@@ -144,23 +144,12 @@ int freeze_processes(void)
 	/*
 	 * Now that the whole userspace is frozen we need to disbale
 	 * the OOM killer to disallow any further interference with
-	 * killable tasks.
+	 * killable tasks. There is no guarantee oom victims will
+	 * ever reach a point they go away we have to wait with a timeout.
 	 */
-	if (!error && !oom_killer_disable())
+	if (!error && !oom_killer_disable(msecs_to_jiffies(freeze_timeout_msecs)))
 		error = -EBUSY;
 
-	/*
-	 * There is a hard to fix race between oom_reaper kernel thread
-	 * and oom_killer_disable. oom_reaper calls exit_oom_victim
-	 * before the victim reaches exit_mm so try to freeze all the tasks
-	 * again and catch such a left over task.
-	 */
-	if (!error) {
-		pr_info("Double checking all user space processes after OOM killer disable... ");
-		error = try_to_freeze_tasks(true);
-		pr_cont("\n");
-	}
-
 	if (error)
 		thaw_processes();
 	return error;
diff -puN mm/oom_kill.c~oom-suspend-fix-oom_killer_disable-vs-pm-suspend-properly mm/oom_kill.c
--- a/mm/oom_kill.c~oom-suspend-fix-oom_killer_disable-vs-pm-suspend-properly
+++ a/mm/oom_kill.c
@@ -559,14 +559,7 @@ static void oom_reap_task(struct task_st
 	debug_show_all_locks();
 
 done:
-	/*
-	 * Clear TIF_MEMDIE because the task shouldn't be sitting on a
-	 * reasonably reclaimable memory anymore or it is not a good candidate
-	 * for the oom victim right now because it cannot release its memory
-	 * itself nor by the oom reaper.
-	 */
 	tsk->oom_reaper_list = NULL;
-	exit_oom_victim(tsk);
 
 	/*
 	 * Hide this mm from OOM killer because it has been either reaped or
@@ -580,8 +573,6 @@ done:
 
 static int oom_reaper(void *unused)
 {
-	set_freezable();
-
 	while (true) {
 		struct task_struct *tsk = NULL;
 
@@ -681,10 +672,20 @@ void exit_oom_victim(struct task_struct
 }
 
 /**
+ * oom_killer_enable - enable OOM killer
+ */
+void oom_killer_enable(void)
+{
+	oom_killer_disabled = false;
+}
+
+/**
  * oom_killer_disable - disable OOM killer
+ * @timeout: maximum timeout to wait for oom victims in jiffies
  *
  * Forces all page allocations to fail rather than trigger OOM killer.
- * Will block and wait until all OOM victims are killed.
+ * Will block and wait until all OOM victims are killed or the given
+ * timeout expires.
  *
  * The function cannot be called when there are runnable user tasks because
  * the userspace would see unexpected allocation failures as a result. Any
@@ -693,8 +694,10 @@ void exit_oom_victim(struct task_struct
  * Returns true if successful and false if the OOM killer cannot be
  * disabled.
  */
-bool oom_killer_disable(void)
+bool oom_killer_disable(signed long timeout)
 {
+	signed long ret;
+
 	/*
 	 * Make sure to not race with an ongoing OOM killer. Check that the
 	 * current is not killed (possibly due to sharing the victim's memory).
@@ -704,19 +707,16 @@ bool oom_killer_disable(void)
 	oom_killer_disabled = true;
 	mutex_unlock(&oom_lock);
 
-	wait_event(oom_victims_wait, !atomic_read(&oom_victims));
+	ret = wait_event_interruptible_timeout(oom_victims_wait,
+			!atomic_read(&oom_victims), timeout);
+	if (ret <= 0) {
+		oom_killer_enable();
+		return false;
+	}
 
 	return true;
 }
 
-/**
- * oom_killer_enable - enable OOM killer
- */
-void oom_killer_enable(void)
-{
-	oom_killer_disabled = false;
-}
