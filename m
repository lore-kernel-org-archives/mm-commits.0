From: akpm@linux-foundation.org
Subject: + coredump_wait-dont-call-complete_vfork_done.patch added to -mm tree
Date: Thu, 16 Feb 2012 16:40:23 -0800
Message-ID: <20120217004023.F4113A023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:37695 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab2BQAkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2012 19:40:25 -0500
Received: by qadb12 with SMTP id b12so405924qad.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2012 16:40:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, tj@kernel.org


The patch titled
     Subject: coredump_wait: don't call complete_vfork_done()
has been added to the -mm tree.  Its filename is
     coredump_wait-dont-call-complete_vfork_done.patch

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
Subject: coredump_wait: don't call complete_vfork_done()

Now that CLONE_VFORK is killable, coredump_wait() no longer needs
complete_vfork_done().  zap_threads() should find and kill all tasks with
the same ->mm, this includes our parent if ->vfork_done is set.

mm_release() becomes the only caller, unexport complete_vfork_done().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |   14 ++------------
 include/linux/sched.h |    1 -
 kernel/fork.c         |    2 +-
 3 files changed, 3 insertions(+), 14 deletions(-)

diff -puN fs/exec.c~coredump_wait-dont-call-complete_vfork_done fs/exec.c
--- a/fs/exec.c~coredump_wait-dont-call-complete_vfork_done
+++ a/fs/exec.c
@@ -1926,19 +1926,9 @@ static int coredump_wait(int exit_code, 
 		core_waiters = zap_threads(tsk, mm, core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
-	if (unlikely(core_waiters < 0))
-		goto fail;
-
-	/*
-	 * Make sure nobody is waiting for us to release the VM,
-	 * otherwise we can deadlock when we wait on each other
-	 */
-	if (tsk->vfork_done)
-		complete_vfork_done(tsk);
-
-	if (core_waiters)
+	if (core_waiters > 0)
 		wait_for_completion(&core_state->startup);
-fail:
+
 	return core_waiters;
 }
 
diff -puN include/linux/sched.h~coredump_wait-dont-call-complete_vfork_done include/linux/sched.h
--- a/include/linux/sched.h~coredump_wait-dont-call-complete_vfork_done
+++ a/include/linux/sched.h
@@ -2315,7 +2315,6 @@ extern int do_execve(const char *,
 		     const char __user * const __user *,
 		     const char __user * const __user *, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
-extern void complete_vfork_done(struct task_struct *tsk);
 struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
diff -puN kernel/fork.c~coredump_wait-dont-call-complete_vfork_done kernel/fork.c
--- a/kernel/fork.c~coredump_wait-dont-call-complete_vfork_done
+++ a/kernel/fork.c
@@ -688,7 +688,7 @@ struct mm_struct *mm_access(struct task_
 	return mm;
 }
 
-void complete_vfork_done(struct task_struct *tsk)
+static void complete_vfork_done(struct task_struct *tsk)
 {
 	struct completion *vfork;
 
_
Subject: Subject: coredump_wait: don't call complete_vfork_done()

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
arm-use-set_current_blocked-and-block_sigmask.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
powerpc-use-set_current_blocked-and-block_sigmask.patch
hexagon-use-set_current_blocked-and-block_sigmask.patch
tile-use-set_current_blocked-and-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
mips-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
s390-use-block_sigmask.patch
xtensa-dont-reimplement-force_sigsegv.patch
xtensa-no-need-to-reset-handler-if-sa_oneshot.patch
xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
xtensa-use-set_current_blocked-and-block_sigmask.patch
sparc-use-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
sh-no-need-to-reset-handler-if-sa_oneshot.patch
sh-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
alpha-use-set_current_blocked-and-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
c6x-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
um-dont-restore-current-blocked-on-error.patch
um-use-set_current_blocked-and-block_sigmask.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
ptrace-the-killed-tracee-should-not-enter-the-syscall.patch
ptrace-dont-send-sigtrap-on-exec-if-seized.patch
ptrace-dont-modify-flags-on-ptrace_setoptions-failure.patch
ptrace-simplify-ptrace_foo-constants-and-ptrace_setoptions-code.patch
ptrace-make-ptrace_seize-set-ptrace-options-specified-in-data-parameter.patch
ptrace-renumber-ptrace_event_stop-so-that-future-new-options-and-events-can-match.patch
ptrace-remove-ptrace_seize_devel-bit.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-use-umh_wait_proc-consistently.patch
usermodehelper-introduce-umh_completesub_info.patch
usermodehelper-implement-umh_killable.patch
usermodehelper-kill-umh_wait-renumber-umh_-constants.patch
usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch
kmod-introduce-call_modprobe-helper.patch
kmod-make-__request_module-killable.patch
vfork-introduce-complete_vfork_done.patch
vfork-make-it-killable.patch
coredump_wait-dont-call-complete_vfork_done.patch
vfork-kill-pf_starting.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch

