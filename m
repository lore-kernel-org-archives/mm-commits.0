From: akpm@linux-foundation.org
Subject: + blackfin-blackfin-utrace-patch.patch added to -mm tree
Date: Mon, 05 Mar 2007 19:55:34 -0800
Message-ID: <200703060355.l263tYYG011162@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49434 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933923AbXCFDzs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 22:55:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, roland@redhat.com


The patch titled
     Blackfin: blackfin utrace patch
has been added to the -mm tree.  Its filename is
     blackfin-blackfin-utrace-patch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin: blackfin utrace patch
From: "Wu, Bryan" <bryan.wu@analog.com>

As utrace is very promising in the -mm tree, a simple support is added to
blackfin architecture.  I send this patch out just for review and it is
only a start point, we will make it fully work in the future.

Now after applying this patch, the blackfin-arch can be compile in the
2.6.21-rc2-mm1 with utrace enabled and ptrace disabled.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/asm-offsets.c |    2 
 arch/blackfin/kernel/ptrace.c      |    8 ++
 include/asm-blackfin/thread_info.h |    2 
 include/asm-blackfin/tracehook.h   |   79 +++++++++++++++++++++++++++
 4 files changed, 91 insertions(+)

diff -puN arch/blackfin/kernel/asm-offsets.c~blackfin-blackfin-utrace-patch arch/blackfin/kernel/asm-offsets.c
--- a/arch/blackfin/kernel/asm-offsets.c~blackfin-blackfin-utrace-patch
+++ a/arch/blackfin/kernel/asm-offsets.c
@@ -45,7 +45,9 @@ int main(void)
 	/* offsets into the task struct */
 	DEFINE(TASK_STATE, offsetof(struct task_struct, state));
 	DEFINE(TASK_FLAGS, offsetof(struct task_struct, flags));
+#if 0
 	DEFINE(TASK_PTRACE, offsetof(struct task_struct, ptrace));
+#endif
 	DEFINE(TASK_BLOCKED, offsetof(struct task_struct, blocked));
 	DEFINE(TASK_THREAD, offsetof(struct task_struct, thread));
 	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, thread_info));
diff -puN arch/blackfin/kernel/ptrace.c~blackfin-blackfin-utrace-patch arch/blackfin/kernel/ptrace.c
--- a/arch/blackfin/kernel/ptrace.c~blackfin-blackfin-utrace-patch
+++ a/arch/blackfin/kernel/ptrace.c
@@ -34,12 +34,14 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
+#include <linux/tracehook.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/signal.h>
 
 #include <asm/uaccess.h>
+#include <asm/tracehook.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -173,6 +175,8 @@ static inline int is_user_addr_valid(str
 	return -EIO;
 }
 
+#ifdef CONFIG_PTRACE
+
 /*
  * Called by kernel/ptrace.c when detaching..
  *
@@ -386,12 +390,15 @@ long arch_ptrace(struct task_struct *chi
 	return ret;
 }
 
+#endif /* CONFIG_PTRACE */
+
 asmlinkage void syscall_trace(void)
 {
 
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return;
 
+#if 0
 	if (!(current->ptrace & PT_PTRACED))
 		return;
 
@@ -400,6 +407,7 @@ asmlinkage void syscall_trace(void)
 	 */
 	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
 				 ? 0x80 : 0));
+#endif
 
 	/*
 	 * this isn't the same as continuing with a signal, but it will do
diff -puN include/asm-blackfin/thread_info.h~blackfin-blackfin-utrace-patch include/asm-blackfin/thread_info.h
--- a/include/asm-blackfin/thread_info.h~blackfin-blackfin-utrace-patch
+++ a/include/asm-blackfin/thread_info.h
@@ -127,6 +127,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE              5
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 #define TIF_FREEZE              7       /* is freezing for suspend */
+#define TIF_SINGLESTEP		8       /* restore singlestep on return to user mode */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -136,6 +137,7 @@ static inline struct thread_info *curren
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_FREEZE             (1<<TIF_FREEZE)
+#define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 
diff -puN /dev/null include/asm-blackfin/tracehook.h
--- /dev/null
+++ a/include/asm-blackfin/tracehook.h
@@ -0,0 +1,79 @@
+/*
+ * Tracing hooks, Blackfin Architecture support
+ *
+ * Copyright (C) 2006, 2007 Analog Devices, Inc.  All rights reserved.
+ * Copyright (C) 2006, 2007 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * ADI Author: Bryan Wu
+ * Red Hat Author: Roland McGrath.
+ */
+
+#ifndef _ASM_TRACEHOOK_H
+#define _ASM_TRACEHOOK_H	1
+
+#include <linux/sched.h>
+#include <asm/ptrace.h>
+
+/*
+ * See linux/tracehook.h for the descriptions of what these need to do.
+ */
+
+#define ARCH_HAS_SINGLE_STEP	(1)
+
+static inline void tracehook_enable_single_step(struct task_struct *task)
+{
+	/* TODO */
+#if 0
+	struct pt_regs *regs = task->thread.regs;
+
+	if (regs != NULL) {
+	}
+#endif
+	set_tsk_thread_flag(task, TIF_SINGLESTEP);
+}
+
+static inline void tracehook_disable_single_step(struct task_struct *task)
+{
+	/* TODO */
+#if 0
+	struct pt_regs *regs = task->thread.regs;
+
+	if (regs != NULL) {
+	}
+#endif
+	clear_tsk_thread_flag(task, TIF_SINGLESTEP);
+}
+
+
+static inline int tracehook_single_step_enabled(struct task_struct *tsk)
+{
+	return test_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+}
+
+static inline void tracehook_enable_syscall_trace(struct task_struct *tsk)
+{
+	set_tsk_thread_flag(tsk, TIF_SYSCALL_TRACE);
+}
+
+static inline void tracehook_disable_syscall_trace(struct task_struct *tsk)
+{
+	clear_tsk_thread_flag(tsk, TIF_SYSCALL_TRACE);
+}
+
+static inline void tracehook_abort_syscall(struct pt_regs *regs)
+{
+	regs->orig_r0 = -1;
+}
+
+extern const struct utrace_regset_view utrace_bfin_native;
+static inline const struct utrace_regset_view *
+utrace_native_view(struct task_struct *tsk)
+{
+	return &utrace_bfin_native;
+}
+
+#endif
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-Documentation.patch
blackfin-arch.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-utrace-patch.patch
