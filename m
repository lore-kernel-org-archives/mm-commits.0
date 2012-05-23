From: akpm@linux-foundation.org
Subject: [alternative-merged] avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch removed from -mm tree
Date: Wed, 23 May 2012 12:47:00 -0700
Message-ID: <20120523194700.DCAEEA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:57301 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2EWTrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:47:03 -0400
Received: by wibhn6 with SMTP id hn6so310883wib.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:47:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, matt.fleming@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn
has been removed from the -mm tree.  Its filename was
     avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn

It is wrong to change ->blocked directly, see e6fa16ab.  Change
handle_signal() and sys_rt_sigreturn() to use the right helper,
set_current_blocked().

Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Acked-by: Havard Skinnemoen <hskinnemoen@gmail.com>
Reviewed-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/signal.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN arch/avr32/kernel/signal.c~avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn arch/avr32/kernel/signal.c
--- a/arch/avr32/kernel/signal.c~avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn
+++ a/arch/avr32/kernel/signal.c
@@ -87,10 +87,7 @@ asmlinkage int sys_rt_sigreturn(struct p
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
@@ -226,6 +223,7 @@ static inline void
 handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 	      sigset_t *oldset, struct pt_regs *regs, int syscall)
 {
+	sigset_t blocked;
 	int ret;
 
 	/*
@@ -246,13 +244,10 @@ handle_signal(unsigned long sig, struct 
 	/*
 	 * Block the signal if we were successful.
 	 */
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked, &current->blocked,
-		  &ka->sa.sa_mask);
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+		sigaddset(&blocked, sig);
+	set_current_blocked(&blocked);
 }
 
 /*
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
avr32-use-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
frv-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
task_work_add-generic-process-context-callbacks.patch
genirq-reimplement-exit_irq_thread-hook-via-task_work_add.patch
hexagon-do_notify_resume-needs-tracehook_notify_resume.patch
keys-change-keyctl_session_to_parent-to-use-task_work_add.patch
keys-kill-the-dummy-key_replace_session_keyring.patch
keys-kill-task_struct-replacement_session_keyring.patch
kmod-unexport-call_usermodehelper_freeinfo.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch
cred-remove-task_is_dead-from-__task_cred-validation.patch
stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
cpu-introduce-clear_tasks_mm_cpumask-helper.patch
arm-use-clear_tasks_mm_cpumask.patch
powerpc-use-clear_tasks_mm_cpumask.patch
sh-use-clear_tasks_mm_cpumask.patch
blackfin-a-couple-of-task-mm-handling-fixes.patch
blackfin-fix-possible-deadlock-in-decode_address.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch
pidns-use-task_active_pid_ns-in-do_notify_parent.patch
pidns-make-killed-children-autoreap.patch
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2.patch
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix.patch
aio-vfs-cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

