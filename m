From: akpm@linux-foundation.org
Subject: + x86-tracehook-asm-syscallh.patch added to -mm tree
Date: Sat, 26 Jul 2008 00:09:11 -0700
Message-ID: <200807260709.m6Q79B9A021415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbYGZHKY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 03:10:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: tracehook: asm/syscall.h
has been added to the -mm tree.  Its filename is
     x86-tracehook-asm-syscallh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch

