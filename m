From: akpm@linux-foundation.org
Subject: [patch 011/101] mm, oom: tighten task_will_free_mem() locking
Date: Thu, 28 Jul 2016 15:45:04 -0700
Message-ID: <579a8af0.HgmMjoOSJlEWLTth%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbcG1WpF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:45:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@parallels.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: tighten task_will_free_mem() locking

"mm, oom: fortify task_will_free_mem" has dropped task_lock around
task_will_free_mem in oom_kill_process bacause it assumed that a
potential race when the selected task exits will not be a problem
as the oom_reaper will call exit_oom_victim.

Tetsuo was objecting that nommu doesn't have oom_reaper so the race
would be still possible.  The code would be racy and lockup prone
theoretically in other aspects without the oom reaper anyway so I didn't
considered this a big deal. But it seems that further changes I am
planning in this area will benefit from stable task->mm in this path as
well. So let's drop find_lock_task_mm from task_will_free_mem and call
it from under task_lock as we did previously. Just pull the task->mm !=
NULL check inside the function.

Link: http://lkml.kernel.org/r/1467201562-6709-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-fortify-task_will_free_mem-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-fortify-task_will_free_mem-fix
+++ a/mm/oom_kill.c
@@ -757,45 +757,35 @@ static inline bool __task_will_free_mem(
  * Checks whether the given task is dying or exiting and likely to
  * release its address space. This means that all threads and processes
  * sharing the same mm have to be killed or exiting.
+ * Caller has to make sure that task->mm is stable (hold task_lock or
+ * it operates on the current).
  */
 bool task_will_free_mem(struct task_struct *task)
 {
-	struct mm_struct *mm;
+	struct mm_struct *mm = task->mm;
 	struct task_struct *p;
 	bool ret;
 
-	if (!__task_will_free_mem(task))
-		return false;
-
 	/*
-	 * If the process has passed exit_mm we have to skip it because
-	 * we have lost a link to other tasks sharing this mm, we do not
-	 * have anything to reap and the task might then get stuck waiting
-	 * for parent as zombie and we do not want it to hold TIF_MEMDIE
+	 * Skip tasks without mm because it might have passed its exit_mm and
+	 * exit_oom_victim. oom_reaper could have rescued that but do not rely
+	 * on that for now. We can consider find_lock_task_mm in future.
 	 */
-	p = find_lock_task_mm(task);
-	if (!p)
+	if (!mm)
 		return false;
 
-	mm = p->mm;
+	if (!__task_will_free_mem(task))
+		return false;
 
 	/*
 	 * This task has already been drained by the oom reaper so there are
 	 * only small chances it will free some more
 	 */
-	if (test_bit(MMF_OOM_REAPED, &mm->flags)) {
-		task_unlock(p);
+	if (test_bit(MMF_OOM_REAPED, &mm->flags))
 		return false;
-	}
 
-	if (atomic_read(&mm->mm_users) <= 1) {
-		task_unlock(p);
+	if (atomic_read(&mm->mm_users) <= 1)
 		return true;
-	}
-
-	/* pin the mm to not get freed and reused */
-	atomic_inc(&mm->mm_count);
-	task_unlock(p);
 
 	/*
 	 * This is really pessimistic but we do not have any reliable way
@@ -812,7 +802,6 @@ bool task_will_free_mem(struct task_stru
 			break;
 	}
 	rcu_read_unlock();
-	mmdrop(mm);
 
 	return ret;
 }
@@ -838,12 +827,15 @@ void oom_kill_process(struct oom_control
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
+	task_lock(p);
 	if (task_will_free_mem(p)) {
 		mark_oom_victim(p);
 		wake_oom_reaper(p);
+		task_unlock(p);
 		put_task_struct(p);
 		return;
 	}
+	task_unlock(p);
 
 	if (__ratelimit(&oom_rs))
 		dump_header(oc, p);
@@ -1014,11 +1006,8 @@ bool out_of_memory(struct oom_control *o
 	 * If current has a pending SIGKILL or is exiting, then automatically
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
-	 *
-	 * But don't select if current has already released its mm and cleared
-	 * TIF_MEMDIE flag at exit_mm(), otherwise an OOM livelock may occur.
 	 */
-	if (current->mm && task_will_free_mem(current)) {
+	if (task_will_free_mem(current)) {
 		mark_oom_victim(current);
 		wake_oom_reaper(current);
 		return true;
_
