From: akpm@linux-foundation.org
Subject: + pid_ns-zap_pid_ns_processes-use-send_sig_noinfo-instead-of-force_sig.patch added to -mm tree
Date: Thu, 04 Mar 2010 13:14:22 -0800
Message-ID: <201003042114.o24LEMn4030173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756273Ab0CDVOl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 16:14:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com, serue@us.ibm.com, torvalds@linux-foundation.org


The patch titled
     pid_ns: zap_pid_ns_processes: use SEND_SIG_NOINFO instead of force_sig()
has been added to the -mm tree.  Its filename is
     pid_ns-zap_pid_ns_processes-use-send_sig_noinfo-instead-of-force_sig.patch

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
Subject: pid_ns: zap_pid_ns_processes: use SEND_SIG_NOINFO instead of force_sig()
From: Oleg Nesterov <oleg@redhat.com>

zap_pid_ns_processes() uses force_sig(SIGKILL) to ensure SIGKILL will be
delivered to sub-namespace inits as well.  This is correct, but we are
going to change force_sig_info() semantics.  See
http://bugzilla.kernel.org/show_bug.cgi?id=15395#c31

We can use send_sig_info(SEND_SIG_NOINFO) instead, since
614c517d7c00af1b26ded20646b329397d6f51a1 ("signals: SEND_SIG_NOINFO should
be considered as SI_FROMUSER()") SEND_SIG_NOINFO means "from user" and
therefore send_signal() will get the correct from_ancestor_ns = T flag.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/pid_namespace.c~pid_ns-zap_pid_ns_processes-use-send_sig_noinfo-instead-of-force_sig kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pid_ns-zap_pid_ns_processes-use-send_sig_noinfo-instead-of-force_sig
+++ a/kernel/pid_namespace.c
@@ -161,13 +161,12 @@ void zap_pid_ns_processes(struct pid_nam
 		rcu_read_lock();
 
 		/*
-		 * Use force_sig() since it clears SIGNAL_UNKILLABLE ensuring
-		 * any nested-container's init processes don't ignore the
-		 * signal
+		 * Any nested-container's init processes won't ignore the
+		 * SEND_SIG_NOINFO signal, see send_signal()->si_fromuser().
 		 */
 		task = pid_task(find_vpid(nr), PIDTYPE_PID);
 		if (task)
-			force_sig(SIGKILL, task);
+			send_sig_info(SIGKILL, SEND_SIG_NOINFO, task);
 
 		rcu_read_unlock();
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
kernel-pidc-update-comment-on-find_task_by_pid_ns.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
coredump-set-group_exit_code-for-other-clone_vm-tasks-too.patch
coredump-suppress-uid-comparison-test-if-core-output-files-are-pipes.patch
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

