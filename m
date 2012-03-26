From: akpm@linux-foundation.org
Subject: [merged] ptrace-the-killed-tracee-should-not-enter-the-syscall.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:59 -0700
Message-ID: <20120326193159.8A64FA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:64249 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab2CZTcB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:01 -0400
Received: by wibhj13 with SMTP id hj13so233297wib.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, fweisbec@gmail.com, indan@nul.nu, jan.kratochvil@redhat.com, palves@redhat.com, rostedt@goodmis.org, scarybeasts@gmail.com, tj@kernel.org, vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: the killed tracee should not enter the syscall
has been removed from the -mm tree.  Its filename was
     ptrace-the-killed-tracee-should-not-enter-the-syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace: the killed tracee should not enter the syscall

Another old/known problem.  If the tracee is killed after it reports
syscall_entry, it starts the syscall and debugger can't control this. 
This confuses the users and this creates the security problems for ptrace
jailers.

Change tracehook_report_syscall_entry() to return non-zero if killed, this
instructs syscall_trace_enter() to abort the syscall.

Reported-by: Chris Evans <scarybeasts@gmail.com>
Tested-by: Indan Zupancic <indan@nul.nu>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pedro Alves <palves@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/tracehook.h~ptrace-the-killed-tracee-should-not-enter-the-syscall include/linux/tracehook.h
--- a/include/linux/tracehook.h~ptrace-the-killed-tracee-should-not-enter-the-syscall
+++ a/include/linux/tracehook.h
@@ -54,12 +54,12 @@ struct linux_binprm;
 /*
  * ptrace report for syscall entry and exit looks identical.
  */
-static inline void ptrace_report_syscall(struct pt_regs *regs)
+static inline int ptrace_report_syscall(struct pt_regs *regs)
 {
 	int ptrace = current->ptrace;
 
 	if (!(ptrace & PT_PTRACED))
-		return;
+		return 0;
 
 	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
 
@@ -72,6 +72,8 @@ static inline void ptrace_report_syscall
 		send_sig(current->exit_code, current, 1);
 		current->exit_code = 0;
 	}
+
+	return fatal_signal_pending(current);
 }
 
 /**
@@ -96,8 +98,7 @@ static inline void ptrace_report_syscall
 static inline __must_check int tracehook_report_syscall_entry(
 	struct pt_regs *regs)
 {
-	ptrace_report_syscall(regs);
-	return 0;
+	return ptrace_report_syscall(regs);
 }
 
 /**
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
mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing.patch
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
powerpc-eeh-remove-eeh_event_handler-daemonize.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch

