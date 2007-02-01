From: akpm@osdl.org
Subject: + ia64-enable-singlestep-on-system-call.patch added to -mm tree
Date: Thu, 01 Feb 2007 14:34:56 -0800
Message-ID: <200702012234.l11MYupc024927@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44910 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823AbXBAWfD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:35:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bibo.mao@intel.com, tony.luck@intel.com


The patch titled
     ia64: enable singlestep on system call
has been added to the -mm tree.  Its filename is
     ia64-enable-singlestep-on-system-call.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: enable singlestep on system call
From: "bibo,mao" <bibo.mao@intel.com>

http://www.gelato.org/community/view_linear.php?id=1_1036&from=authors&value=Ian%20Wienand#1_1039,
if single step on break instruction, the break fault has higher priority
than the single-step trap.  When the break fault handler is entered, it
advances the IP by 1 instruction so break instruction single-stepping is
skipped, actually it is next instruction which is single stepped.

This patch modifies this, it adds TIF_SINGLESTEP bit for thread flags, and
generate a fake sigtrap when single stepping break instruction.  Test case
in attachment can verify this.  Any comments is welcome.

Signed-off-by: bibo, mao <bibo.mao@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/kernel/ptrace.c      |   12 ++++++------
 include/asm-ia64/thread_info.h |    4 +++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN arch/ia64/kernel/ptrace.c~ia64-enable-singlestep-on-system-call arch/ia64/kernel/ptrace.c
--- a/arch/ia64/kernel/ptrace.c~ia64-enable-singlestep-on-system-call
+++ a/arch/ia64/kernel/ptrace.c
@@ -1405,6 +1405,7 @@ ptrace_disable (struct task_struct *chil
 	struct ia64_psr *child_psr = ia64_psr(task_pt_regs(child));
 
 	/* make sure the single step/taken-branch trap bits are not set: */
+	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 	child_psr->ss = 0;
 	child_psr->tb = 0;
 }
@@ -1525,6 +1526,7 @@ sys_ptrace (long request, pid_t pid, uns
 		 * Make sure the single step/taken-branch trap bits
 		 * are not set:
 		 */
+		clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 		ia64_psr(pt)->ss = 0;
 		ia64_psr(pt)->tb = 0;
 
@@ -1556,6 +1558,7 @@ sys_ptrace (long request, pid_t pid, uns
 			goto out_tsk;
 
 		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+		set_tsk_thread_flag(child, TIF_SINGLESTEP);
 		if (request == PTRACE_SINGLESTEP) {
 			ia64_psr(pt)->ss = 1;
 		} else {
@@ -1595,13 +1598,9 @@ sys_ptrace (long request, pid_t pid, uns
 }
 
 
-void
+static void
 syscall_trace (void)
 {
-	if (!test_thread_flag(TIF_SYSCALL_TRACE))
-		return;
-	if (!(current->ptrace & PT_PTRACED))
-		return;
 	/*
 	 * The 0x80 provides a way for the tracing parent to
 	 * distinguish between a syscall stop and SIGTRAP delivery.
@@ -1664,7 +1663,8 @@ syscall_trace_leave (long arg0, long arg
 		audit_syscall_exit(success, result);
 	}
 
-	if (test_thread_flag(TIF_SYSCALL_TRACE)
+	if ((test_thread_flag(TIF_SYSCALL_TRACE)
+	    || test_thread_flag(TIF_SINGLESTEP))
 	    && (current->ptrace & PT_PTRACED))
 		syscall_trace();
 }
diff -puN include/asm-ia64/thread_info.h~ia64-enable-singlestep-on-system-call include/asm-ia64/thread_info.h
--- a/include/asm-ia64/thread_info.h~ia64-enable-singlestep-on-system-call
+++ a/include/asm-ia64/thread_info.h
@@ -84,6 +84,7 @@ struct thread_info {
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_SYSCALL_TRACE	3	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	4	/* syscall auditing active */
+#define TIF_SINGLESTEP		5	/* restore singlestep on return to user mode */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
@@ -92,7 +93,8 @@ struct thread_info {
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
-#define _TIF_SYSCALL_TRACEAUDIT	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
+#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
+#define _TIF_SYSCALL_TRACEAUDIT	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
_

Patches currently in -mm which might be from bibo.mao@intel.com are

ia64-enable-singlestep-on-system-call.patch
