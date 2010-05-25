From: akpm@linux-foundation.org
Subject: + ptrace-ptrace_getfdpic-fix-the-unsafe-usage-of-child-mm.patch added to -mm tree
Date: Tue, 25 May 2010 16:10:57 -0700
Message-ID: <201005252310.o4PNAvR5020733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758830Ab0EYXLY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 19:11:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, gerg@snapgear.com, lethal@linux-sh.org, roland@redhat.com, vapier.adi@gmail.com


The patch titled
     ptrace: PTRACE_GETFDPIC: fix the unsafe usage of child->mm
has been added to the -mm tree.  Its filename is
     ptrace-ptrace_getfdpic-fix-the-unsafe-usage-of-child-mm.patch

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
Subject: ptrace: PTRACE_GETFDPIC: fix the unsafe usage of child->mm
From: Oleg Nesterov <oleg@redhat.com>

Now that Mike Frysinger unified the FDPIC ptrace code, we can fix the
unsafe usage of child->mm in ptrace_request(PTRACE_GETFDPIC).

We have the reference to task_struct, and ptrace_check_attach() verified
the tracee is stopped.  But nothing can protect from SIGKILL after that,
we must not assume child->mm != NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Greg Ungerer <gerg@snapgear.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN kernel/ptrace.c~ptrace-ptrace_getfdpic-fix-the-unsafe-usage-of-child-mm kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-ptrace_getfdpic-fix-the-unsafe-usage-of-child-mm
+++ a/kernel/ptrace.c
@@ -596,18 +596,24 @@ int ptrace_request(struct task_struct *c
 
 #ifdef CONFIG_BINFMT_ELF_FDPIC
 	case PTRACE_GETFDPIC: {
+		struct mm_struct *mm = get_task_mm(child);
 		unsigned long tmp = 0;
 
+		ret = -ESRCH;
+		if (!mm)
+			break;
+
 		switch (addr) {
 		case PTRACE_GETFDPIC_EXEC:
-			tmp = child->mm->context.exec_fdpic_loadmap;
+			tmp = mm->context.exec_fdpic_loadmap;
 			break;
 		case PTRACE_GETFDPIC_INTERP:
-			tmp = child->mm->context.interp_fdpic_loadmap;
+			tmp = mm->context.interp_fdpic_loadmap;
 			break;
 		default:
 			break;
 		}
+		mmput(mm);
 
 		ret = put_user(tmp, (unsigned long __user *) data);
 		break;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
fix-stop_machine-reimplement-using-cpu_stop.patch
ptrace-unify-fdpic-implementations.patch
ptrace-ptrace_getfdpic-fix-the-unsafe-usage-of-child-mm.patch
signals-check_kill_permission-dont-check-creds-if-same_thread_group.patch
kmod-add-init-function-to-usermodehelper.patch
exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
call_usermodehelper-no-need-to-unblock-signals.patch
wait_for_helper-sigchld-from-user-space-can-lead-to-use-after-free.patch
call_usermodehelper-simplify-fix-umh_no_wait-case.patch
call_usermodehelper-umh_wait_exec-ignores-kernel_thread-failure.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
exit-exit_notify-can-trust-signal-notify_count-0.patch
exit-change-zap_other_threads-to-count-sub-threads.patch
exit-avoid-sig-count-in-de_thread-__exit_signal-synchronization.patch
exit-avoid-sig-count-in-__exit_signal-to-detect-the-group-dead-case.patch
posix-cpu-timers-avoid-task-signal-=-null-checks.patch
ia64-ptrace_attach_sync_user_rbs-avoid-task-signal-=-null-checks.patch
fork-exit-move-tty_kref_put-outside-of-__cleanup_signal.patch
signals-make-task_struct-signal-immutable-refcountable.patch
signals-clear-signal-tty-when-the-last-thread-exits.patch
signals-clear-signal-tty-when-the-last-thread-exits-fix.patch
signals-kill-the-awful-task_rq_unlock_wait-hack.patch
exit-__exit_signal-use-thread_group_leader-consistently.patch
kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers.patch
exit-move-taskstats_tgid_free-from-__exit_signal-to-free_signal_struct.patch
check_unshare_flags-kill-the-bogus-clone_sighand-sig-count-check.patch
proc-get_nr_threads-doesnt-need-siglock-any-longer.patch
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
proc-turn-signal_struct-count-into-int-nr_threads.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
proc-cleanup-remove-unused-assignments.patch
init_task-should-initialize-thread_group-list.patch
pids-init_struct_pidtasks-should-never-see-the-swapper-process.patch
pids-fix-fork_idle-to-setup-pids-correctly.patch
init_sighand-use-sig_dfl-instead-of-null.patch

