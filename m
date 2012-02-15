From: akpm@linux-foundation.org
Subject: + avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:33:30 -0800
Message-ID: <20120215003330.F195CA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:47253 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381Ab2BOAdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 19:33:32 -0500
Received: by mail-ey0-f202.google.com with SMTP id f13so15061eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:33:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, matt.fleming@intel.com


The patch titled
     Subject: avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn
has been added to the -mm tree.  Its filename is
     avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch

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
Subject: Subject: avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-use-umh_wait_proc-consistently.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
alpha-use-set_current_blocked-and-block_sigmask.patch
arm-use-set_current_blocked-and-block_sigmask.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
c6x-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
hexagon-use-set_current_blocked-and-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
mips-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
openrisc-dont-reimplement-force_sigsegv.patch
openrisc-no-need-to-reset-handler-if-sa_oneshot.patch
openrisc-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
openrisc-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
powerpc-use-set_current_blocked-and-block_sigmask.patch
use-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
sh-no-need-to-reset-handler-if-sa_oneshot.patch
sh-use-set_current_blocked-and-block_sigmask.patch
sparc-use-block_sigmask.patch
tile-use-set_current_blocked-and-block_sigmask.patch
um-dont-restore-current-blocked-on-error.patch
um-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
xtensa-dont-reimplement-force_sigsegv.patch
xtensa-no-need-to-reset-handler-if-sa_oneshot.patch
xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
xtensa-use-set_current_blocked-and-block_sigmask.patch

