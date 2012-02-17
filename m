From: akpm@linux-foundation.org
Subject: + vfork-make-it-killable.patch added to -mm tree
Date: Thu, 16 Feb 2012 16:40:21 -0800
Message-ID: <20120217004022.0B06AA023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:55210 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab2BQAkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2012 19:40:24 -0500
Received: by eekb15 with SMTP id b15so102899eek.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2012 16:40:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, tj@kernel.org


The patch titled
     Subject: vfork: make it killable
has been added to the -mm tree.  Its filename is
     vfork-make-it-killable.patch

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
Subject: vfork: make it killable

Make vfork() killable.

Change do_fork(CLONE_VFORK) to do wait_for_completion_killable().  If it
fails we do not return to the user-mode and never touch the memory shared
with our child.

However, in this case we should clear child->vfork_done before return, we
use task_lock() in do_fork()->wait_for_vfork_done() and
complete_vfork_done() to serialize with each other.

Note: now that we use task_lock() we don't really need completion, we
could turn task->vfork_done into "task_struct *wake_up_me" but this needs
some complications.

NOTE: this and the next patches do not affect in-kernel users of
CLONE_VFORK, kernel threads run with all signals ignored including
SIGKILL/SIGSTOP.

However this is obviously the user-visible change.  Not only a fatal
signal can kill the vforking parent, a sub-thread can do execve or
exit_group() and kill the thread sleeping in vfork().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 kernel/fork.c         |   40 ++++++++++++++++++++++++++++++++--------
 2 files changed, 33 insertions(+), 9 deletions(-)

diff -puN include/linux/sched.h~vfork-make-it-killable include/linux/sched.h
--- a/include/linux/sched.h~vfork-make-it-killable
+++ a/include/linux/sched.h
@@ -2396,7 +2396,7 @@ static inline int thread_group_empty(str
  * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
  * subscriptions and synchronises with wait4().  Also used in procfs.  Also
  * pins the final release of task.io_context.  Also protects ->cpuset and
- * ->cgroup.subsys[].
+ * ->cgroup.subsys[]. And ->vfork_done.
  *
  * Nests both inside and outside of read_lock(&tasklist_lock).
  * It must not be nested with write_lock_irq(&tasklist_lock),
diff -puN kernel/fork.c~vfork-make-it-killable kernel/fork.c
--- a/kernel/fork.c~vfork-make-it-killable
+++ a/kernel/fork.c
@@ -690,10 +690,34 @@ struct mm_struct *mm_access(struct task_
 
 void complete_vfork_done(struct task_struct *tsk)
 {
-	struct completion *vfork_done = tsk->vfork_done;
+	struct completion *vfork;
 
-	tsk->vfork_done = NULL;
-	complete(vfork_done);
+	task_lock(tsk);
+	vfork = tsk->vfork_done;
+	if (likely(vfork)) {
+		tsk->vfork_done = NULL;
+		complete(vfork);
+	}
+	task_unlock(tsk);
+}
+
+static int wait_for_vfork_done(struct task_struct *child,
+				struct completion *vfork)
+{
+	int killed;
+
+	freezer_do_not_count();
+	killed = wait_for_completion_killable(vfork);
+	freezer_count();
+
+	if (killed) {
+		task_lock(child);
+		child->vfork_done = NULL;
+		task_unlock(child);
+	}
+
+	put_task_struct(child);
+	return killed;
 }
 
 /* Please note the differences between mmput and mm_release.
@@ -739,7 +763,8 @@ void mm_release(struct task_struct *tsk,
 	 * If we're exiting normally, clear a user-space tid field if
 	 * requested.  We leave this alone when dying by signal, to leave
 	 * the value intact in a core dump, and to save the unnecessary
-	 * trouble otherwise.  Userland only wants this done for a sys_exit.
+	 * trouble, say, a killed vfork parent shouldn't touch this mm.
+	 * Userland only wants this done for a sys_exit.
 	 */
 	if (tsk->clear_child_tid) {
 		if (!(tsk->flags & PF_SIGNALED) &&
@@ -1583,6 +1608,7 @@ long do_fork(unsigned long clone_flags,
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
 			init_completion(&vfork);
+			get_task_struct(p);
 		}
 
 		/*
@@ -1600,10 +1626,8 @@ long do_fork(unsigned long clone_flags,
 			ptrace_event(trace, nr);
 
 		if (clone_flags & CLONE_VFORK) {
-			freezer_do_not_count();
-			wait_for_completion(&vfork);
-			freezer_count();
-			ptrace_event(PTRACE_EVENT_VFORK_DONE, nr);
+			if (!wait_for_vfork_done(p, &vfork))
+				ptrace_event(PTRACE_EVENT_VFORK_DONE, nr);
 		}
 	} else {
 		nr = PTR_ERR(p);
_
Subject: Subject: vfork: make it killable

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

