From: akpm@linux-foundation.org
Subject: + hung_task-fix-the-broken-rcu_lock_break-logic.patch added to -mm tree
Date: Fri, 17 Feb 2012 11:42:08 -0800
Message-ID: <20120217194210.7BA45A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:60570 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2BQTmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2012 14:42:13 -0500
Received: by vbbfp1 with SMTP id fp1so488895vbb.1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2012 11:42:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, fweisbec@gmail.com, msb@google.com, paulmck@linux.vnet.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp


The patch titled
     Subject: hung_task: fix the broken rcu_lock_break() logic
has been added to the -mm tree.  Its filename is
     hung_task-fix-the-broken-rcu_lock_break-logic.patch

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
Subject: hung_task: fix the broken rcu_lock_break() logic

check_hung_uninterruptible_tasks()->rcu_lock_break() introduced by
"softlockup: check all tasks in hung_task" commit ce9dbe24 looks
absolutely wrong.

	- rcu_lock_break() does put_task_struct(). If the task has exited
	  it is not safe to even read its ->state, nothing protects this
	  task_struct.

	- The TASK_DEAD checks are wrong too. Contrary to the comment, we
	  can't use it to check if the task was unhashed. It can be unhashed
	  without TASK_DEAD, or it can be valid with TASK_DEAD.

	  For example, an autoreaping task can do release_task(current)
	  long before it sets TASK_DEAD in do_exit().

	  Or, a zombie task can have ->state == TASK_DEAD but release_task()
	  was not called, and in this case we must not break the loop.

Change this code to check pid_alive() instead, and do this before we drop
the reference to the task_struct.

Note: while_each_thread() under rcu_read_lock() is not really safe, it can
livelock.  This will be fixed later, but fortunately in this case the
"max_count" logic saves us anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Mandeep Singh Baines <msb@google.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN kernel/hung_task.c~hung_task-fix-the-broken-rcu_lock_break-logic kernel/hung_task.c
--- a/kernel/hung_task.c~hung_task-fix-the-broken-rcu_lock_break-logic
+++ a/kernel/hung_task.c
@@ -119,15 +119,20 @@ static void check_hung_task(struct task_
  * For preemptible RCU it is sufficient to call rcu_read_unlock in order
  * to exit the grace period. For classic RCU, a reschedule is required.
  */
-static void rcu_lock_break(struct task_struct *g, struct task_struct *t)
+static bool rcu_lock_break(struct task_struct *g, struct task_struct *t)
 {
+	bool can_cont;
+
 	get_task_struct(g);
 	get_task_struct(t);
 	rcu_read_unlock();
 	cond_resched();
 	rcu_read_lock();
+	can_cont = pid_alive(g) && pid_alive(t);
 	put_task_struct(t);
 	put_task_struct(g);
+
+	return can_cont;
 }
 
 /*
@@ -154,9 +159,7 @@ static void check_hung_uninterruptible_t
 			goto unlock;
 		if (!--batch_count) {
 			batch_count = HUNG_TASK_BATCHING;
-			rcu_lock_break(g, t);
-			/* Exit if t or g was unhashed during refresh. */
-			if (t->state == TASK_DEAD || g->state == TASK_DEAD)
+			if (!rcu_lock_break(g, t))
 				goto unlock;
 		}
 		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
_
Subject: Subject: hung_task: fix the broken rcu_lock_break() logic

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
vfork-introduce-complete_vfork_done.patch
vfork-make-it-killable.patch
coredump_wait-dont-call-complete_vfork_done.patch
vfork-kill-pf_starting.patch
hung_task-fix-the-broken-rcu_lock_break-logic.patch
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
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch

