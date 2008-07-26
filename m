From: akpm@linux-foundation.org
Subject: - tracehook-asm-syscallh.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:07 -0700
Message-ID: <200807262117.m6QLH7eR019907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757963AbYGZVR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: asm/syscall.h
has been removed from the -mm tree.  Its filename was
     tracehook-asm-syscallh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: asm/syscall.h
From: Roland McGrath <roland@redhat.com>

This adds asm-generic/syscall.h, which documents what a real
asm-ARCH/syscall.h file should define.  This is not used yet, but will
provide all the machine-dependent details of examining a user system call
about to begin, in progress, or just ended.

Each arch should add an asm-ARCH/syscall.h that defines all the entry
points documented in asm-generic/syscall.h, as short inlines if possible. 
This lets us write new tracing code that understands user system call
registers, without any new arch-specific work.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/syscall.h |  141 ++++++++++++++++++++++++++++++++
 include/linux/tracehook.h     |    3 
 2 files changed, 143 insertions(+), 1 deletion(-)

diff -puN /dev/null include/asm-generic/syscall.h
--- /dev/null
+++ a/include/asm-generic/syscall.h
@@ -0,0 +1,141 @@
+/*
+ * Access to user system call parameters and results
+ *
+ * Copyright (C) 2008 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * This file is a stub providing documentation for what functions
+ * asm-ARCH/syscall.h files need to define.  Most arch definitions
+ * will be simple inlines.
+ *
+ * All of these functions expect to be called with no locks,
+ * and only when the caller is sure that the task of interest
+ * cannot return to user mode while we are looking at it.
+ */
+
+#ifndef _ASM_SYSCALL_H
+#define _ASM_SYSCALL_H	1
+
+struct task_struct;
+struct pt_regs;
+
+/**
+ * syscall_get_nr - find what system call a task is executing
+ * @task:	task of interest, must be blocked
+ * @regs:	task_pt_regs() of @task
+ *
+ * If @task is executing a system call or is at system call
+ * tracing about to attempt one, returns the system call number.
+ * If @task is not executing a system call, i.e. it's blocked
+ * inside the kernel for a fault or signal, returns -1.
+ *
+ * It's only valid to call this when @task is known to be blocked.
+ */
+long syscall_get_nr(struct task_struct *task, struct pt_regs *regs);
+
+/**
+ * syscall_rollback - roll back registers after an aborted system call
+ * @task:	task of interest, must be in system call exit tracing
+ * @regs:	task_pt_regs() of @task
+ *
+ * It's only valid to call this when @task is stopped for system
+ * call exit tracing (due to TIF_SYSCALL_TRACE or TIF_SYSCALL_AUDIT),
+ * after tracehook_report_syscall_entry() returned nonzero to prevent
+ * the system call from taking place.
+ *
+ * This rolls back the register state in @regs so it's as if the
+ * system call instruction was a no-op.  The registers containing
+ * the system call number and arguments are as they were before the
+ * system call instruction.  This may not be the same as what the
+ * register state looked like at system call entry tracing.
+ */
+void syscall_rollback(struct task_struct *task, struct pt_regs *regs);
+
+/**
+ * syscall_get_error - check result of traced system call
+ * @task:	task of interest, must be blocked
+ * @regs:	task_pt_regs() of @task
+ *
+ * Returns 0 if the system call succeeded, or -ERRORCODE if it failed.
+ *
+ * It's only valid to call this when @task is stopped for tracing on exit
+ * from a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
+ */
+long syscall_get_error(struct task_struct *task, struct pt_regs *regs);
+
+/**
+ * syscall_get_return_value - get the return value of a traced system call
+ * @task:	task of interest, must be blocked
+ * @regs:	task_pt_regs() of @task
+ *
+ * Returns the return value of the successful system call.
+ * This value is meaningless if syscall_get_error() returned nonzero.
+ *
+ * It's only valid to call this when @task is stopped for tracing on exit
+ * from a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
+ */
+long syscall_get_return_value(struct task_struct *task, struct pt_regs *regs);
+
+/**
+ * syscall_set_return_value - change the return value of a traced system call
+ * @task:	task of interest, must be blocked
+ * @regs:	task_pt_regs() of @task
+ * @error:	negative error code, or zero to indicate success
+ * @val:	user return value if @error is zero
+ *
+ * This changes the results of the system call that user mode will see.
+ * If @error is zero, the user sees a successful system call with a
+ * return value of @val.  If @error is nonzero, it's a negated errno
+ * code; the user sees a failed system call with this errno code.
+ *
+ * It's only valid to call this when @task is stopped for tracing on exit
+ * from a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
+ */
+void syscall_set_return_value(struct task_struct *task, struct pt_regs *regs,
+			      int error, long val);
+
+/**
+ * syscall_get_arguments - extract system call parameter values
+ * @task:	task of interest, must be blocked
+ * @regs:	task_pt_regs() of @task
+ * @i:		argument index [0,5]
+ * @n:		number of arguments; n+i must be [1,6].
+ * @args:	array filled with argument values
+ *
+ * Fetches @n arguments to the system call starting with the @i'th argument
+ * (from 0 through 5).  Argument @i is stored in @args[0], and so on.
+ * An arch inline version is probably optimal when @i and @n are constants.
+ *
+ * It's only valid to call this when @task is stopped for tracing on
+ * entry to a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
+ * It's invalid to call this with @i + @n > 6; we only support system calls
+ * taking up to 6 arguments.
+ */
+void syscall_get_arguments(struct task_struct *task, struct pt_regs *regs,
+			   unsigned int i, unsigned int n, unsigned long *args);
+
+/**
+ * syscall_set_arguments - change system call parameter value
+ * @task:	task of interest, must be in system call entry tracing
+ * @regs:	task_pt_regs() of @task
+ * @i:		argument index [0,5]
+ * @n:		number of arguments; n+i must be [1,6].
+ * @args:	array of argument values to store
+ *
+ * Changes @n arguments to the system call starting with the @i'th argument.
+ * @n'th argument to @val.  Argument @i gets value @args[0], and so on.
+ * An arch inline version is probably optimal when @i and @n are constants.
+ *
+ * It's only valid to call this when @task is stopped for tracing on
+ * entry to a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
+ * It's invalid to call this with @i + @n > 6; we only support system calls
+ * taking up to 6 arguments.
+ */
+void syscall_set_arguments(struct task_struct *task, struct pt_regs *regs,
+			   unsigned int i, unsigned int n,
+			   const unsigned long *args);
+
+#endif	/* _ASM_SYSCALL_H */
diff -puN include/linux/tracehook.h~tracehook-asm-syscallh include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-asm-syscallh
+++ a/include/linux/tracehook.h
@@ -103,7 +103,8 @@ static inline void ptrace_report_syscall
  * the system call.  That must prevent normal entry so no system call is
  * made.  If @task ever returns to user mode after this, its register state
  * is unspecified, but should be something harmless like an %ENOSYS error
- * return.
+ * return.  It should preserve enough information so that syscall_rollback()
+ * can work (see asm-generic/syscall.h).
  *
  * Called without locks, just after entering kernel mode.
  */
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

