From: akpm@linux-foundation.org
Subject: + ptrace-tracehook_report_clone-fix-false-positives.patch added to -mm tree
Date: Mon, 01 Jun 2009 22:27:56 -0700
Message-ID: <200906020527.n525RuWu015628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475AbZFBF2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 01:28:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, hch@infradead.org, mingo@elte.hu, roland@redhat.com


The patch titled
     ptrace: tracehook_report_clone: fix false positives
has been added to the -mm tree.  Its filename is
     ptrace-tracehook_report_clone-fix-false-positives.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: tracehook_report_clone: fix false positives
From: Oleg Nesterov <oleg@redhat.com>

The "trace || CLONE_PTRACE" check in tracehook_report_clone() is not right,

- If the untraced task does clone(CLONE_PTRACE) the new child is not traced,
  we must not queue SIGSTOP.

- If we forked the traced task, but the tracer exits and untraces both the
  forking task and the new child (after copy_process() drops tasklist_lock),
  we should not queue SIGSTOP too.

Change the code to check task_ptrace() != 0 instead. This is still racy, but
the race is harmless.

We can race with another tracer attaching to this child, or the tracer can
exit and detach in parallel. But giwen that we didn't do wake_up_new_task()
yet, the child must have the pending SIGSTOP anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   11 +++++------
 kernel/fork.c             |    2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN include/linux/tracehook.h~ptrace-tracehook_report_clone-fix-false-positives include/linux/tracehook.h
--- a/include/linux/tracehook.h~ptrace-tracehook_report_clone-fix-false-positives
+++ a/include/linux/tracehook.h
@@ -259,14 +259,12 @@ static inline void tracehook_finish_clon
 
 /**
  * tracehook_report_clone - in parent, new child is about to start running
- * @trace:		return value from tracehook_prepare_clone()
  * @regs:		parent's user register state
  * @clone_flags:	flags from parent's system call
  * @pid:		new child's PID in the parent's namespace
  * @child:		new child task
  *
- * Called after a child is set up, but before it has been started
- * running.  @trace is the value returned by tracehook_prepare_clone().
+ * Called after a child is set up, but before it has been started running.
  * This is not a good place to block, because the child has not started
  * yet.  Suspend the child here if desired, and then block in
  * tracehook_report_clone_complete().  This must prevent the child from
@@ -276,13 +274,14 @@ static inline void tracehook_finish_clon
  *
  * Called with no locks held, but the child cannot run until this returns.
  */
-static inline void tracehook_report_clone(int trace, struct pt_regs *regs,
+static inline void tracehook_report_clone(struct pt_regs *regs,
 					  unsigned long clone_flags,
 					  pid_t pid, struct task_struct *child)
 {
-	if (unlikely(trace) || unlikely(clone_flags & CLONE_PTRACE)) {
+	if (unlikely(task_ptrace(child))) {
 		/*
-		 * The child starts up with an immediate SIGSTOP.
+		 * It doesn't matter who attached/attaching to this
+		 * task, the pending SIGSTOP is right in any case.
 		 */
 		sigaddset(&child->pending.signal, SIGSTOP);
 		set_tsk_thread_flag(child, TIF_SIGPENDING);
diff -puN kernel/fork.c~ptrace-tracehook_report_clone-fix-false-positives kernel/fork.c
--- a/kernel/fork.c~ptrace-tracehook_report_clone-fix-false-positives
+++ a/kernel/fork.c
@@ -1409,7 +1409,7 @@ long do_fork(unsigned long clone_flags,
 		}
 
 		audit_finish_fork(p);
-		tracehook_report_clone(trace, regs, clone_flags, nr, p);
+		tracehook_report_clone(regs, clone_flags, nr, p);
 
 		/*
 		 * We set PF_STARTING at creation in case tracing wants to
_

Patches currently in -mm which might be from oleg@redhat.com are

ptrace-tracehook_report_clone-fix-false-positives.patch
linux-next.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
ptrace-do-not-use-task_lock-for-attach.patch
ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch
ptrace-wait_task_zombie-s-parent-real_parent.patch
ptrace-do_notify_parent_cldstop-fix-the-wrong-nsproxy-usage.patch
ptrace-dont-take-tasklist-to-get-set-last_siginfo.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
shift-ptrace-implies-wuntraced-from-ptrace_do_wait-to-wait_task_stopped.patch
introduce-struct-wait_opts-to-simplify-do_wait-pathes.patch
do_wait-simplify-retval-tsk_result-notask_error-mess.patch
do_wait-kill-the-old-bug_on-use-while_each_thread.patch
do_wait-fix-the-theoretical-race-with-stop-trace-cont.patch
mm-exitc-reorder-wait_opts-to-remove-padding-on-64-bit-builds.patch
wait_task_-cleanups-split-wait_noreap_copyout.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
pids-clean-up-find_task_by_pid-variants.patch

