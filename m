From: akpm@linux-foundation.org
Subject: + vfork-introduce-complete_vfork_done.patch added to -mm tree
Date: Thu, 16 Feb 2012 16:40:16 -0800
Message-ID: <20120217004018.A4239A023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:37765 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab2BQAkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2012 19:40:21 -0500
Received: by ghrr17 with SMTP id r17so368955ghr.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2012 16:40:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, tj@kernel.org


The patch titled
     Subject: vfork: introduce complete_vfork_done()
has been added to the -mm tree.  Its filename is
     vfork-introduce-complete_vfork_done.patch

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
Subject: vfork: introduce complete_vfork_done()

No functional changes.

Move the clear-and-complete-vfork_done code into the new trivial helper,
complete_vfork_done().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |    8 ++------
 include/linux/sched.h |    1 +
 kernel/fork.c         |   17 ++++++++++-------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff -puN fs/exec.c~vfork-introduce-complete_vfork_done fs/exec.c
--- a/fs/exec.c~vfork-introduce-complete_vfork_done
+++ a/fs/exec.c
@@ -1915,7 +1915,6 @@ static int coredump_wait(int exit_code, 
 {
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
-	struct completion *vfork_done;
 	int core_waiters = -EBUSY;
 
 	init_completion(&core_state->startup);
@@ -1934,11 +1933,8 @@ static int coredump_wait(int exit_code, 
 	 * Make sure nobody is waiting for us to release the VM,
 	 * otherwise we can deadlock when we wait on each other
 	 */
-	vfork_done = tsk->vfork_done;
-	if (vfork_done) {
-		tsk->vfork_done = NULL;
-		complete(vfork_done);
-	}
+	if (tsk->vfork_done)
+		complete_vfork_done(tsk);
 
 	if (core_waiters)
 		wait_for_completion(&core_state->startup);
diff -puN include/linux/sched.h~vfork-introduce-complete_vfork_done include/linux/sched.h
--- a/include/linux/sched.h~vfork-introduce-complete_vfork_done
+++ a/include/linux/sched.h
@@ -2315,6 +2315,7 @@ extern int do_execve(const char *,
 		     const char __user * const __user *,
 		     const char __user * const __user *, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
+extern void complete_vfork_done(struct task_struct *tsk);
 struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
diff -puN kernel/fork.c~vfork-introduce-complete_vfork_done kernel/fork.c
--- a/kernel/fork.c~vfork-introduce-complete_vfork_done
+++ a/kernel/fork.c
@@ -688,6 +688,14 @@ struct mm_struct *mm_access(struct task_
 	return mm;
 }
 
+void complete_vfork_done(struct task_struct *tsk)
+{
+	struct completion *vfork_done = tsk->vfork_done;
+
+	tsk->vfork_done = NULL;
+	complete(vfork_done);
+}
+
 /* Please note the differences between mmput and mm_release.
  * mmput is called whenever we stop holding onto a mm_struct,
  * error success whatever.
@@ -703,8 +711,6 @@ struct mm_struct *mm_access(struct task_
  */
 void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
-	struct completion *vfork_done = tsk->vfork_done;
-
 	/* Get rid of any futexes when releasing the mm */
 #ifdef CONFIG_FUTEX
 	if (unlikely(tsk->robust_list)) {
@@ -726,11 +732,8 @@ void mm_release(struct task_struct *tsk,
 	/* Get rid of any cached register state */
 	deactivate_mm(tsk, mm);
 
-	/* notify parent sleeping on vfork() */
-	if (vfork_done) {
-		tsk->vfork_done = NULL;
-		complete(vfork_done);
-	}
+	if (tsk->vfork_done)
+		complete_vfork_done(tsk);
 
 	/*
 	 * If we're exiting normally, clear a user-space tid field if
_
Subject: Subject: vfork: introduce complete_vfork_done()

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

