From: akpm@linux-foundation.org
Subject: - tracehook-syscall.patch removed from -mm tree
Date: Sat, 26 Jul 2008 15:04:21 -0700
Message-ID: <200807262204.m6QM4L9K021678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755333AbYGZWFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 18:05:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: syscall
has been removed from the -mm tree.  Its filename was
     tracehook-syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: syscall
From: Roland McGrath <roland@redhat.com>

This adds standard tracehook.h inlines for arch code to call when
TIF_SYSCALL_TRACE has been set.  This replaces having each arch implement
the ptrace guts for its syscall tracing support.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   70 ++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff -puN include/linux/tracehook.h~tracehook-syscall include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-syscall
+++ a/include/linux/tracehook.h
@@ -66,6 +66,76 @@ static inline int tracehook_expect_break
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
 
+/*
+ * ptrace report for syscall entry and exit looks identical.
+ */
+static inline void ptrace_report_syscall(struct pt_regs *regs)
+{
+	int ptrace = task_ptrace(current);
+
+	if (!(ptrace & PT_PTRACED))
+		return;
+
+	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
+
+	/*
+	 * this isn't the same as continuing with a signal, but it will do
+	 * for normal use.  strace only continues with a signal if the
+	 * stopping signal is not SIGTRAP.  -brl
+	 */
+	if (current->exit_code) {
+		send_sig(current->exit_code, current, 1);
+		current->exit_code = 0;
+	}
+}
+
+/**
+ * tracehook_report_syscall_entry - task is about to attempt a system call
+ * @regs:		user register state of current task
+ *
+ * This will be called if %TIF_SYSCALL_TRACE has been set, when the
+ * current task has just entered the kernel for a system call.
+ * Full user register state is available here.  Changing the values
+ * in @regs can affect the system call number and arguments to be tried.
+ * It is safe to block here, preventing the system call from beginning.
+ *
+ * Returns zero normally, or nonzero if the calling arch code should abort
+ * the system call.  That must prevent normal entry so no system call is
+ * made.  If @task ever returns to user mode after this, its register state
+ * is unspecified, but should be something harmless like an %ENOSYS error
+ * return.
+ *
+ * Called without locks, just after entering kernel mode.
+ */
+static inline __must_check int tracehook_report_syscall_entry(
+	struct pt_regs *regs)
+{
+	ptrace_report_syscall(regs);
+	return 0;
+}
+
+/**
+ * tracehook_report_syscall_exit - task has just finished a system call
+ * @regs:		user register state of current task
+ * @step:		nonzero if simulating single-step or block-step
+ *
+ * This will be called if %TIF_SYSCALL_TRACE has been set, when the
+ * current task has just finished an attempted system call.  Full
+ * user register state is available here.  It is safe to block here,
+ * preventing signals from being processed.
+ *
+ * If @step is nonzero, this report is also in lieu of the normal
+ * trap that would follow the system call instruction because
+ * user_enable_block_step() or user_enable_single_step() was used.
+ * In this case, %TIF_SYSCALL_TRACE might not be set.
+ *
+ * Called without locks, just before checking for pending signals.
+ */
+static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
+{
+	ptrace_report_syscall(regs);
+}
+
 /**
  * tracehook_unsafe_exec - check for exec declared unsafe due to tracing
  * @task:		current task doing exec
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
tracehook-syscall.patch
tracehook-config_have_arch_tracehook.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch

