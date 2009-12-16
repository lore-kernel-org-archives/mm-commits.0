From: akpm@linux-foundation.org
Subject: [merged] ptrace-x86-change-syscall_trace_leave-to-rely-on-tracehook-when-stepping.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:12 -0800
Message-ID: <200912162038.nBGKcCsp013407__7717.69598727605$1260995945$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964949AbZLPUit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ptrace: x86: change syscall_trace_leave() to rely on tracehook when stepping
has been removed from the -mm tree.  Its filename was
     ptrace-x86-change-syscall_trace_leave-to-rely-on-tracehook-when-stepping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: x86: change syscall_trace_leave() to rely on tracehook when stepping
From: Oleg Nesterov <oleg@redhat.com>

Suggested by Roland.

Unlike powepc, x86 always calls tracehook_report_syscall_exit(step) with
step = 0, and sends the trap by hand.

This results in unnecessary SIGTRAP when PTRACE_SINGLESTEP follows the
syscall-exit stop.

Change syscall_trace_leave() to pass the correct "step" argument to
tracehook and remove the send_sigtrap() logic.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~ptrace-x86-change-syscall_trace_leave-to-rely-on-tracehook-when-stepping arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-x86-change-syscall_trace_leave-to-rely-on-tracehook-when-stepping
+++ a/arch/x86/kernel/ptrace.c
@@ -1767,29 +1767,22 @@ asmregparm long syscall_trace_enter(stru
 
 asmregparm void syscall_trace_leave(struct pt_regs *regs)
 {
+	bool step;
+
 	if (unlikely(current->audit_context))
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_exit(regs, regs->ax);
 
-	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, 0);
-
 	/*
 	 * If TIF_SYSCALL_EMU is set, we only get here because of
 	 * TIF_SINGLESTEP (i.e. this is PTRACE_SYSEMU_SINGLESTEP).
 	 * We already reported this syscall instruction in
-	 * syscall_trace_enter(), so don't do any more now.
-	 */
-	if (unlikely(test_thread_flag(TIF_SYSCALL_EMU)))
-		return;
