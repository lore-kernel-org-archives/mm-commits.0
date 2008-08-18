From: akpm@linux-foundation.org
Subject: - x86-tracehook-asm-syscallh.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:44 -0700
Message-ID: <200808181940.m7IJeibL008482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757664AbYHRTvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: tracehook: asm/syscall.h
has been removed from the -mm tree.  Its filename was
     x86-tracehook-asm-syscallh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: tracehook: asm/syscall.h
From: Roland McGrath <roland@redhat.com>

Add asm/syscall.h for x86 with all the required entry points.  This will
allow arch-independent tracing code for system calls.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/ptrace.h  |    5 
 include/asm-x86/syscall.h |  210 ++++++++++++++++++++++++++++++++++++
 2 files changed, 215 insertions(+)

diff -puN include/asm-x86/ptrace.h~x86-tracehook-asm-syscallh include/asm-x86/ptrace.h
--- a/include/asm-x86/ptrace.h~x86-tracehook-asm-syscallh
+++ a/include/asm-x86/ptrace.h
@@ -213,6 +213,11 @@ static inline unsigned long frame_pointe
 	return regs->bp;
 }
 
+static inline unsigned long user_stack_pointer(struct pt_regs *regs)
+{
+	return regs->sp;
+}
+
 /*
  * These are defined as per linux/ptrace.h, which see.
  */
diff -puN /dev/null include/asm-x86/syscall.h
--- /dev/null
+++ a/include/asm-x86/syscall.h
@@ -0,0 +1,210 @@
+/*
+ * Access to user system call parameters and results
+ *
+ * Copyright (C) 2008 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * See asm-generic/syscall.h for descriptions of what we must do here.
+ */
+
+#ifndef _ASM_SYSCALL_H
+#define _ASM_SYSCALL_H	1
+
+#include <linux/sched.h>
+
+static inline long syscall_get_nr(struct task_struct *task,
+				  struct pt_regs *regs)
+{
+	/*
+	 * We always sign-extend a -1 value being set here,
+	 * so this is always either -1L or a syscall number.
+	 */
+	return regs->orig_ax;
+}
+
+static inline void syscall_rollback(struct task_struct *task,
+				    struct pt_regs *regs)
+{
+	regs->ax = regs->orig_ax;
+}
+
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	unsigned long error = regs->ax;
+#ifdef CONFIG_IA32_EMULATION
+	/*
+	 * TS_COMPAT is set for 32-bit syscall entries and then
+	 * remains set until we return to user mode.
+	 */
+	if (task_thread_info(task)->status & TS_COMPAT)
+		/*
+		 * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
+		 * and will match correctly in comparisons.
+		 */
+		error = (long) (int) error;
+#endif
+	return error >= -4095L ? error : 0;
+}
+
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->ax;
+}
+
+static inline void syscall_set_return_value(struct task_struct *task,
+					    struct pt_regs *regs,
+					    int error, long val)
+{
+	regs->ax = (long) error ?: val;
+}
+
+#ifdef CONFIG_X86_32
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long args[n])
+{
+	BUG_ON(i + n > 6);
+	memcpy(args, &regs->bx + i, n * sizeof(args[0]));
+}
+
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long args[n])
+{
+	BUG_ON(i + n > 6);
+	memcpy(&regs->bx + i, args, n * sizeof(args[0]));
+}
+
+#else	 /* CONFIG_X86_64 */
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+# ifdef CONFIG_IA32_EMULATION
+	if (task_thread_info(task)->status & TS_COMPAT)
+		switch (i + n) {
+		case 6:
+			if (!n--) break;
+			*args++ = regs->bp;
+		case 5:
+			if (!n--) break;
+			*args++ = regs->di;
+		case 4:
+			if (!n--) break;
+			*args++ = regs->si;
+		case 3:
+			if (!n--) break;
+			*args++ = regs->dx;
+		case 2:
+			if (!n--) break;
+			*args++ = regs->cx;
+		case 1:
+			if (!n--) break;
+			*args++ = regs->bx;
+		case 0:
+			if (!n--) break;
+		default:
+			BUG();
+			break;
+		}
+	else
+# endif
+		switch (i + n) {
+		case 6:
+			if (!n--) break;
+			*args++ = regs->r9;
+		case 5:
+			if (!n--) break;
+			*args++ = regs->r8;
+		case 4:
+			if (!n--) break;
+			*args++ = regs->r10;
+		case 3:
+			if (!n--) break;
+			*args++ = regs->dx;
+		case 2:
+			if (!n--) break;
+			*args++ = regs->si;
+		case 1:
+			if (!n--) break;
+			*args++ = regs->di;
+		case 0:
+			if (!n--) break;
+		default:
+			BUG();
+			break;
+		}
+}
+
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long *args)
+{
+# ifdef CONFIG_IA32_EMULATION
+	if (task_thread_info(task)->status & TS_COMPAT)
+		switch (i + n) {
+		case 6:
+			if (!n--) break;
+			regs->bp = *args++;
+		case 5:
+			if (!n--) break;
+			regs->di = *args++;
+		case 4:
+			if (!n--) break;
+			regs->si = *args++;
+		case 3:
+			if (!n--) break;
+			regs->dx = *args++;
+		case 2:
+			if (!n--) break;
+			regs->cx = *args++;
+		case 1:
+			if (!n--) break;
+			regs->bx = *args++;
+		case 0:
+			if (!n--) break;
+		default:
+			BUG();
+		}
+	else
+# endif
+		switch (i + n) {
+		case 6:
+			if (!n--) break;
+			regs->r9 = *args++;
+		case 5:
+			if (!n--) break;
+			regs->r8 = *args++;
+		case 4:
+			if (!n--) break;
+			regs->r10 = *args++;
+		case 3:
+			if (!n--) break;
+			regs->dx = *args++;
+		case 2:
+			if (!n--) break;
+			regs->si = *args++;
+		case 1:
+			if (!n--) break;
+			regs->di = *args++;
+		case 0:
+			if (!n--) break;
+		default:
+			BUG();
+		}
+}
+
+#endif	/* CONFIG_X86_32 */
+
+#endif	/* _ASM_SYSCALL_H */
_

Patches currently in -mm which might be from roland@redhat.com are

linux-next.patch
x86-tracehook-config_have_arch_tracehook.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch
wait_task_inactive-fix-the-config_smp-version.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

