From: akpm@linux-foundation.org
Subject: + signals-inline-__fatal_signal_pending.patch added to -mm tree
Date: Tue, 18 Aug 2009 16:08:50 -0700
Message-ID: <200908182308.n7IN8owH029551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbZHRXJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Aug 2009 19:09:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@redhat.com


The patch titled
     signals: inline __fatal_signal_pending
has been added to the -mm tree.  Its filename is
     signals-inline-__fatal_signal_pending.patch

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
Subject: signals: inline __fatal_signal_pending
From: Roland McGrath <roland@redhat.com>

__fatal_signal_pending inlines to one instruction on x86, probably two
instructions on other machines.  It takes two longer x86 instructions just
to call it and test its return value, not to mention the function itself.

On my random x86_64 config, this saved 70 bytes of text (59 of those being
__fatal_signal_pending itself).

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    5 ++++-
 kernel/signal.c       |    6 ------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN include/linux/sched.h~signals-inline-__fatal_signal_pending include/linux/sched.h
--- a/include/linux/sched.h~signals-inline-__fatal_signal_pending
+++ a/include/linux/sched.h
@@ -2294,7 +2294,10 @@ static inline int signal_pending(struct 
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
 
-extern int __fatal_signal_pending(struct task_struct *p);
+static inline int __fatal_signal_pending(struct task_struct *p)
+{
+	return unlikely(sigismember(&p->pending.signal, SIGKILL));
+}
 
 static inline int fatal_signal_pending(struct task_struct *p)
 {
diff -puN kernel/signal.c~signals-inline-__fatal_signal_pending kernel/signal.c
--- a/kernel/signal.c~signals-inline-__fatal_signal_pending
+++ a/kernel/signal.c
@@ -1050,12 +1050,6 @@ void zap_other_threads(struct task_struc
 	}
 }
 
-int __fatal_signal_pending(struct task_struct *tsk)
-{
-	return sigismember(&tsk->pending.signal, SIGKILL);
-}
-EXPORT_SYMBOL(__fatal_signal_pending);
-
 struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long *flags)
 {
 	struct sighand_struct *sighand;
_

Patches currently in -mm which might be from roland@redhat.com are

linux-next.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch
do_wait-fix-sys_waitid-specific-behaviour.patch
wait_noreap_copyout-check-for-wo_info-=-null.patch
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
fcntl-add-f_etown_ex.patch
signals-inline-__fatal_signal_pending.patch
signals-tracehook_notify_jctl-change.patch
signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
signals-introduce-tracehook_finish_jctl-helper.patch
utrace-core.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
elf-clean-up-fill_note_info.patch
elf-clean-up-fill_note_info-fix.patch
fork-disable-clone_parent-for-init.patch
pidns-deny-clone_parentclone_newpid-combination.patch
task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

