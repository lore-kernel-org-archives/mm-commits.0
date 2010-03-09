From: akpm@linux-foundation.org
Subject: [merged] coredump-set-group_exit_code-for-other-clone_vm-tasks-too.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:01 -0800
Message-ID: <201003091910.o29JA1TG031567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756084Ab0CITXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:23:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, f.heckenbach@fh-soft.de, nhorman@tuxdriver.com, roland@redhat.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     coredump: set ->group_exit_code for other CLONE_VM tasks too
has been removed from the -mm tree.  Its filename was
     coredump-set-group_exit_code-for-other-clone_vm-tasks-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: set ->group_exit_code for other CLONE_VM tasks too
From: Oleg Nesterov <oleg@redhat.com>

User visible change.

do_coredump() kills all threads which share the same ->mm but only the
coredumping process gets the proper exit_code.  Other tasks which share
the same ->mm die "silently" and return status == 0 to parent.

This is historical behaviour, not actually a bug.  But I think Frank
Heckenbach rightly dislikes the current behaviour.  Simple test-case:

	#include <stdio.h>
	#include <unistd.h>
	#include <signal.h>
	#include <sys/wait.h>

	int main(void)
	{
		int stat;

		if (!fork()) {
			if (!vfork())
				kill(getpid(), SIGQUIT);
		}

		wait(&stat);
		printf("stat=%x\n", stat);
		return 0;
	}

Before this patch it prints "stat=0" despite the fact the child was killed
by SIGQUIT.  After this patch the output is "stat=3" which obviously makes
more sense.

Even with this patch, only the task which originates the coredumping gets
"|= 0x80" if the core was actually dumped, but at least the coredumping
signal is visible to do_wait/etc.

Reported-by: Frank Heckenbach <f.heckenbach@fh-soft.de>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/exec.c~coredump-set-group_exit_code-for-other-clone_vm-tasks-too fs/exec.c
--- a/fs/exec.c~coredump-set-group_exit_code-for-other-clone_vm-tasks-too
+++ a/fs/exec.c
@@ -1561,12 +1561,13 @@ out:
 	return ispipe;
 }
 
-static int zap_process(struct task_struct *start)
+static int zap_process(struct task_struct *start, int exit_code)
 {
 	struct task_struct *t;
 	int nr = 0;
 
 	start->signal->flags = SIGNAL_GROUP_EXIT;
+	start->signal->group_exit_code = exit_code;
 	start->signal->group_stop_count = 0;
 
 	t = start;
@@ -1591,8 +1592,7 @@ static inline int zap_threads(struct tas
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (!signal_group_exit(tsk->signal)) {
 		mm->core_state = core_state;
-		tsk->signal->group_exit_code = exit_code;
-		nr = zap_process(tsk);
+		nr = zap_process(tsk, exit_code);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
 	if (unlikely(nr < 0))
@@ -1641,7 +1641,7 @@ static inline int zap_threads(struct tas
 			if (p->mm) {
 				if (unlikely(p->mm == mm)) {
 					lock_task_sighand(p, &flags);
-					nr += zap_process(p);
+					nr += zap_process(p, exit_code);
 					unlock_task_sighand(p, &flags);
 				}
 				break;
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
ptrace-use-ptrace_request-in-the-remaining-architectures.patch
ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh.patch
alpha-use-generic-ptrace_resume-code.patch
arm-use-generic-ptrace_resume-code.patch
avr32-use-generic-ptrace_resume-code.patch
h8300-use-generic-ptrace_resume-code.patch
m68knommu-use-generic-ptrace_resume-code.patch
microblaze-use-generic-ptrace_resume-code.patch
mips-use-generic-ptrace_resume-code.patch
um-use-generic-ptrace_resume-code.patch
xtensa-use-generic-ptrace_resume-code.patch
cris-arch-v10-use-generic-ptrace_resume-code.patch
cris-arch-v32-use-generic-ptrace_resume-code.patch
m32r-use-generic-ptrace_resume-code.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
utrace-core-utrace-fix-utrace_maybe_reap-vs-find_matching_engine-race.patch
copy_signal-cleanup-use-zalloc-and-remove-initializations.patch
copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct.patch
copy_signal-cleanup-clean-thread_group_cputime_init.patch
copy_signal-cleanup-clean-tty_audit_fork.patch
kmod-add-init-function-to-usermodehelper.patch
kmod-add-init-function-to-usermodehelper-fix.patch
kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limitcleanup.patch
sysctl-extern-cleanup-signal.patch
pid_ns-zap_pid_ns_processes-use-send_sig_noinfo-instead-of-force_sig.patch

