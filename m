From: akpm@linux-foundation.org
Subject: [merged] ptrace-dont-send-sigtrap-on-exec-if-seized.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:01 -0700
Message-ID: <20120326193201.90C1BA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:54542 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2CZTcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:05 -0400
Received: by mail-we0-f202.google.com with SMTP id x9so290191wej.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, fweisbec@gmail.com, indan@nul.nu, jan.kratochvil@redhat.com, palves@redhat.com, rostedt@goodmis.org, scarybeasts@gmail.com, tj@kernel.org, vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: don't send SIGTRAP on exec if SEIZED
has been removed from the -mm tree.  Its filename was
     ptrace-dont-send-sigtrap-on-exec-if-seized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace: don't send SIGTRAP on exec if SEIZED

ptrace_event(PTRACE_EVENT_EXEC) sends SIGTRAP if PT_TRACE_EXEC is not set.
 This is because this SIGTRAP predates PTRACE_O_TRACEEXEC option, we do
not need/want this with PT_SEIZED which can set the options during attach.

Suggested-by: Pedro Alves <palves@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Evans <scarybeasts@gmail.com>
Cc: Indan Zupancic <indan@nul.nu>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pedro Alves <palves@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/ptrace.h~ptrace-dont-send-sigtrap-on-exec-if-seized include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-dont-send-sigtrap-on-exec-if-seized
+++ a/include/linux/ptrace.h
@@ -199,9 +199,10 @@ static inline void ptrace_event(int even
 	if (unlikely(ptrace_event_enabled(current, event))) {
 		current->ptrace_message = message;
 		ptrace_notify((event << 8) | SIGTRAP);
-	} else if (event == PTRACE_EVENT_EXEC && unlikely(current->ptrace)) {
+	} else if (event == PTRACE_EVENT_EXEC) {
 		/* legacy EXEC report via SIGTRAP */
-		send_sig(SIGTRAP, current, 0);
+		if ((current->ptrace & (PT_PTRACED|PT_SEIZED)) == PT_PTRACED)
+			send_sig(SIGTRAP, current, 0);
 	}
 }
 
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

