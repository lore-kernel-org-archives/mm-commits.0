From: akpm@linux-foundation.org
Subject: - task_current_syscall.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:11 -0700
Message-ID: <200807262117.m6QLHBDD019913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758002AbYGZVSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     task_current_syscall
has been removed from the -mm tree.  Its filename was
     task_current_syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: task_current_syscall
From: Roland McGrath <roland@redhat.com>

This adds the new function task_current_syscall() on machines where the
asm/syscall.h interface is supported (CONFIG_HAVE_ARCH_TRACEHOOK).  It's
exported for modules to use in the future.  This function safely samples
the state of a blocked thread to collect what system call it is blocked
in, and the six system call argument registers.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    4 ++
 lib/Makefile           |    2 +
 lib/syscall.c          |   75 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)

diff -puN include/linux/ptrace.h~task_current_syscall include/linux/ptrace.h
--- a/include/linux/ptrace.h~task_current_syscall
+++ a/include/linux/ptrace.h
@@ -314,6 +314,10 @@ static inline void user_enable_block_ste
 #define arch_ptrace_stop(code, info)		do { } while (0)
 #endif
 
+extern int task_current_syscall(struct task_struct *target, long *callno,
+				unsigned long args[6], unsigned int maxargs,
+				unsigned long *sp, unsigned long *pc);
+
 #endif
 
 #endif
diff -puN lib/Makefile~task_current_syscall lib/Makefile
--- a/lib/Makefile~task_current_syscall
+++ a/lib/Makefile
@@ -78,6 +78,8 @@ lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 obj-$(CONFIG_HAVE_LMB) += lmb.o
 
+obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff -puN /dev/null lib/syscall.c
--- /dev/null
+++ a/lib/syscall.c
@@ -0,0 +1,75 @@
+#include <linux/ptrace.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <asm/syscall.h>
+
+static int collect_syscall(struct task_struct *target, long *callno,
+			   unsigned long args[6], unsigned int maxargs,
+			   unsigned long *sp, unsigned long *pc)
+{
+	struct pt_regs *regs = task_pt_regs(target);
+	if (unlikely(!regs))
+		return -EAGAIN;
+
+	*sp = user_stack_pointer(regs);
+	*pc = instruction_pointer(regs);
+
+	*callno = syscall_get_nr(target, regs);
+	if (*callno != -1L && maxargs > 0)
+		syscall_get_arguments(target, regs, 0, maxargs, args);
+
+	return 0;
+}
+
+/**
+ * task_current_syscall - Discover what a blocked task is doing.
+ * @target:		thread to examine
+ * @callno:		filled with system call number or -1
+ * @args:		filled with @maxargs system call arguments
+ * @maxargs:		number of elements in @args to fill
+ * @sp:			filled with user stack pointer
+ * @pc:			filled with user PC
+ *
+ * If @target is blocked in a system call, returns zero with *@callno
+ * set to the the call's number and @args filled in with its arguments.
+ * Registers not used for system call arguments may not be available and
+ * it is not kosher to use &struct user_regset calls while the system
+ * call is still in progress.  Note we may get this result if @target
+ * has finished its system call but not yet returned to user mode, such
+ * as when it's stopped for signal handling or syscall exit tracing.
+ *
+ * If @target is blocked in the kernel during a fault or exception,
+ * returns zero with *@callno set to -1 and does not fill in @args.
+ * If so, it's now safe to examine @target using &struct user_regset
+ * get() calls as long as we're sure @target won't return to user mode.
+ *
+ * Returns -%EAGAIN if @target does not remain blocked.
+ *
+ * Returns -%EINVAL if @maxargs is too large (maximum is six).
+ */
+int task_current_syscall(struct task_struct *target, long *callno,
+			 unsigned long args[6], unsigned int maxargs,
+			 unsigned long *sp, unsigned long *pc)
+{
+	long state;
+	unsigned long ncsw;
+
+	if (unlikely(maxargs > 6))
+		return -EINVAL;
+
+	if (target == current)
+		return collect_syscall(target, callno, args, maxargs, sp, pc);
+
+	state = target->state;
+	if (unlikely(!state))
+		return -EAGAIN;
+
+	ncsw = wait_task_inactive(target, state);
+	if (unlikely(!ncsw) ||
+	    unlikely(collect_syscall(target, callno, args, maxargs, sp, pc)) ||
+	    unlikely(wait_task_inactive(target, state) != ncsw))
+		return -EAGAIN;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(task_current_syscall);
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

