From: akpm@linux-foundation.org
Subject: [merged] signals-clone_parent-shouldnt-allow-to-set-exit_signal.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:01 -0700
Message-ID: <20120322201701.B66D6A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:53101 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab2CVURG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:06 -0400
Received: by wgbdt11 with SMTP id dt11so80821wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: signals: CLONE_PARENT shouldn't allow to set ->exit_signal
has been removed from the -mm tree.  Its filename was
     signals-clone_parent-shouldnt-allow-to-set-exit_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signals: CLONE_PARENT shouldn't allow to set ->exit_signal

The child must not control its ->exit_signal, it is the parent who decides
which signal the child should use for notification.

This means that CLONE_PARENT should not use "clone_flags & CSIGNAL", the
forking task is the sibling of the new process and their parent doesn't
control exit_signal in this case.

This patch uses ->exit_signal of the forking process, but perhaps we
should simply use SIGCHLD.

We read group_leader->exit_signal lockless, this can race with the
ORIGINAL_SIGNAL -> SIGCHLD transition, but this is fine.

Potentially this change allows to kill self_exec_id/parent_exec_id.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/fork.c~signals-clone_parent-shouldnt-allow-to-set-exit_signal kernel/fork.c
--- a/kernel/fork.c~signals-clone_parent-shouldnt-allow-to-set-exit_signal
+++ a/kernel/fork.c
@@ -1364,7 +1364,13 @@ static struct task_struct *copy_process(
 	clear_all_latency_tracing(p);
 
 	/* ok, now we should be set up.. */
-	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
+	if (clone_flags & CLONE_THREAD)
+		p->exit_signal = -1;
+	else if (clone_flags & CLONE_PARENT)
+		p->exit_signal = current->group_leader->exit_signal;
+	else
+		p->exit_signal = (clone_flags & CSIGNAL);
+
 	p->pdeath_signal = 0;
 	p->exit_state = 0;
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
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
powerpc-eeh-remove-eeh_event_handler-daemonize.patch
ptrace-the-killed-tracee-should-not-enter-the-syscall.patch
ptrace-dont-send-sigtrap-on-exec-if-seized.patch
ptrace-dont-modify-flags-on-ptrace_setoptions-failure.patch
ptrace-simplify-ptrace_foo-constants-and-ptrace_setoptions-code.patch
ptrace-make-ptrace_seize-set-ptrace-options-specified-in-data-parameter.patch
ptrace-renumber-ptrace_event_stop-so-that-future-new-options-and-events-can-match.patch
ptrace-remove-ptrace_seize_devel-bit.patch
hexagon-use-set_current_blocked-and-block_sigmask.patch
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
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch

