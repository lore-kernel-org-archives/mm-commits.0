From: akpm@linux-foundation.org
Subject: + exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:06:39 -0700
Message-ID: <20130321220639.7BEBF5A429F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:63439 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3CUWGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:06:40 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so308688ghb.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:06:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, davej@redhat.com, lizefan@huawei.com, tj@kernel.org


The patch titled
     Subject: exec: do not abuse ->cred_guard_mutex in threadgroup_lock()
has been added to the -mm tree.  Its filename is
     exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exec: do not abuse ->cred_guard_mutex in threadgroup_lock()

threadgroup_lock() takes signal->cred_guard_mutex to ensure that
thread_group_leader() is stable.  This doesn't look nice, the scope of
this lock in do_execve() is huge.

And as Dave pointed out this can lead to deadlock, we have the
following dependencies:

	do_execve:		cred_guard_mutex -> i_mutex
	cgroup_mount:		i_mutex -> cgroup_mutex
	attach_task_by_pid:	cgroup_mutex -> cred_guard_mutex

Change de_thread() to take threadgroup_change_begin() around the
switch-the-leader code and change threadgroup_lock() to avoid
->cred_guard_mutex.

Note that de_thread() can't sleep with ->group_rwsem held, this can
obviously deadlock with the exiting leader if the writer is active, so it
does threadgroup_change_end() before schedule().

Reported-by: Dave Jones <davej@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |    3 +++
 include/linux/sched.h |   18 ++++--------------
 2 files changed, 7 insertions(+), 14 deletions(-)

diff -puN fs/exec.c~exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock fs/exec.c
--- a/fs/exec.c~exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock
+++ a/fs/exec.c
@@ -898,11 +898,13 @@ static int de_thread(struct task_struct
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
+			threadgroup_change_begin(tsk);
 			write_lock_irq(&tasklist_lock);
 			if (likely(leader->exit_state))
 				break;
 			__set_current_state(TASK_KILLABLE);
 			write_unlock_irq(&tasklist_lock);
+			threadgroup_change_end(tsk);
 			schedule();
 			if (unlikely(__fatal_signal_pending(tsk)))
 				goto killed;
@@ -960,6 +962,7 @@ static int de_thread(struct task_struct
 		if (unlikely(leader->ptrace))
 			__wake_up_parent(leader, leader->parent);
 		write_unlock_irq(&tasklist_lock);
+		threadgroup_change_end(tsk);
 
 		release_task(leader);
 	}
diff -puN include/linux/sched.h~exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock include/linux/sched.h
--- a/include/linux/sched.h~exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock
+++ a/include/linux/sched.h
@@ -2242,27 +2242,18 @@ static inline void threadgroup_change_en
  *
  * Lock the threadgroup @tsk belongs to.  No new task is allowed to enter
  * and member tasks aren't allowed to exit (as indicated by PF_EXITING) or
- * perform exec.  This is useful for cases where the threadgroup needs to
- * stay stable across blockable operations.
+ * change ->group_leader/pid.  This is useful for cases where the threadgroup
+ * needs to stay stable across blockable operations.
  *
  * fork and exit paths explicitly call threadgroup_change_{begin|end}() for
  * synchronization.  While held, no new task will be added to threadgroup
  * and no existing live task will have its PF_EXITING set.
  *
- * During exec, a task goes and puts its thread group through unusual
- * changes.  After de-threading, exclusive access is assumed to resources
- * which are usually shared by tasks in the same group - e.g. sighand may
- * be replaced with a new one.  Also, the exec'ing task takes over group
- * leader role including its pid.  Exclude these changes while locked by
- * grabbing cred_guard_mutex which is used to synchronize exec path.
+ * de_thread() does threadgroup_change_{begin|end}() when a non-leader
+ * sub-thread becomes a new leader.
  */
 static inline void threadgroup_lock(struct task_struct *tsk)
 {
-	/*
-	 * exec uses exit for de-threading nesting group_rwsem inside
-	 * cred_guard_mutex. Grab cred_guard_mutex first.
-	 */
-	mutex_lock(&tsk->signal->cred_guard_mutex);
 	down_write(&tsk->signal->group_rwsem);
 }
 
@@ -2275,7 +2266,6 @@ static inline void threadgroup_lock(stru
 static inline void threadgroup_unlock(struct task_struct *tsk)
 {
 	up_write(&tsk->signal->group_rwsem);
-	mutex_unlock(&tsk->signal->cred_guard_mutex);
 }
 #else
 static inline void threadgroup_change_begin(struct task_struct *tsk) {}
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
poweroff-change-orderly_poweroff-to-use-schedule_work.patch
thinkpad-acpi-kill-hotkey_thread_mutex.patch
kthread-introduce-to_live_kthread.patch
kthread-kill-task_get_live_kthread.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
argv_split-teach-it-to-handle-mutable-strings.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix-2.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch
epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch
set_task_comm-kill-the-pointless-memset-wmb.patch
exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock.patch

