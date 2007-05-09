From: akpm@linux-foundation.org
Subject: - simplify-the-stacktrace-code.patch removed from -mm tree
Date: Tue, 08 May 2007 19:43:55 -0700
Message-ID: <200705090243.l492htRB008526@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970101AbXEICoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:44:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, ak@suse.de, akinobu.mita@gmail.com, davem@davemloft.net, lethal@linux-sh.org, mingo@elte.hu, ralf@linux-mips.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     simplify the stacktrace code
has been removed from the -mm tree.  Its filename was
     simplify-the-stacktrace-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: simplify the stacktrace code
From: Christoph Hellwig <hch@lst.de>

Simplify the stacktrace code:

 - remove the unused task argument to save_stack_trace, it's always
   current
 - remove the all_contexts flag, it's alwasy 0

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andi Kleen <ak@suse.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/stacktrace.c    |   22 ++++++----------------
 arch/s390/kernel/stacktrace.c    |   18 +++++++-----------
 arch/sh/kernel/stacktrace.c      |    9 +--------
 arch/sparc64/kernel/stacktrace.c |   20 +++++++-------------
 arch/x86_64/kernel/stacktrace.c  |    8 +++-----
 include/linux/stacktrace.h       |    6 ++----
 kernel/lockdep.c                 |    3 +--
 lib/fault-inject.c               |    3 +--
 8 files changed, 28 insertions(+), 61 deletions(-)

diff -puN arch/mips/kernel/stacktrace.c~simplify-the-stacktrace-code arch/mips/kernel/stacktrace.c
--- a/arch/mips/kernel/stacktrace.c~simplify-the-stacktrace-code
+++ a/arch/mips/kernel/stacktrace.c
@@ -31,8 +31,7 @@ static void save_raw_context_stack(struc
 	}
 }
 
-static void save_context_stack(struct stack_trace *trace,
-	struct task_struct *task, struct pt_regs *regs)
+static void save_context_stack(struct stack_trace *trace, struct pt_regs *regs)
 {
 	unsigned long sp = regs->regs[29];
 #ifdef CONFIG_KALLSYMS
@@ -41,7 +40,7 @@ static void save_context_stack(struct st
 
 	if (raw_show_trace || !__kernel_text_address(pc)) {
 		unsigned long stack_page =
-			(unsigned long)task_stack_page(task);
+			(unsigned long)task_stack_page(current);
 		if (stack_page && sp >= stack_page &&
 		    sp <= stack_page + THREAD_SIZE - 32)
 			save_raw_context_stack(trace, sp);
@@ -54,7 +53,7 @@ static void save_context_stack(struct st
 			trace->entries[trace->nr_entries++] = pc;
 		if (trace->nr_entries >= trace->max_entries)
 			break;
-		pc = unwind_stack(task, &sp, pc, &ra);
+		pc = unwind_stack(current, &sp, pc, &ra);
 	} while (pc);
 #else
 	save_raw_context_stack(trace, sp);
@@ -64,22 +63,13 @@ static void save_context_stack(struct st
 /*
  * Save stack-backtrace addresses into a stack_trace buffer.
  */
-void save_stack_trace(struct stack_trace *trace, struct task_struct *task)
+void save_stack_trace(struct stack_trace *trace)
 {
 	struct pt_regs dummyregs;
 	struct pt_regs *regs = &dummyregs;
 
 	WARN_ON(trace->nr_entries || !trace->max_entries);
 
-	if (task && task != current) {
-		regs->regs[29] = task->thread.reg29;
-		regs->regs[31] = 0;
-		regs->cp0_epc = task->thread.reg31;
-	} else {
-		if (!task)
-			task = current;
-		prepare_frametrace(regs);
-	}
-
-	save_context_stack(trace, task, regs);
+	prepare_frametrace(regs);
+	save_context_stack(trace, regs);
 }
diff -puN arch/s390/kernel/stacktrace.c~simplify-the-stacktrace-code arch/s390/kernel/stacktrace.c
--- a/arch/s390/kernel/stacktrace.c~simplify-the-stacktrace-code
+++ a/arch/s390/kernel/stacktrace.c
@@ -59,7 +59,7 @@ static unsigned long save_context_stack(
 	}
 }
 
-void save_stack_trace(struct stack_trace *trace, struct task_struct *task)
+void save_stack_trace(struct stack_trace *trace)
 {
 	register unsigned long sp asm ("15");
 	unsigned long orig_sp, new_sp;
@@ -69,20 +69,16 @@ void save_stack_trace(struct stack_trace
 	new_sp = save_context_stack(trace, &trace->skip, orig_sp,
 				S390_lowcore.panic_stack - PAGE_SIZE,
 				S390_lowcore.panic_stack);
-	if ((new_sp != orig_sp) && !trace->all_contexts)
+	if (new_sp != orig_sp)
 		return;
 	new_sp = save_context_stack(trace, &trace->skip, new_sp,
 				S390_lowcore.async_stack - ASYNC_SIZE,
 				S390_lowcore.async_stack);
-	if ((new_sp != orig_sp) && !trace->all_contexts)
+	if (new_sp != orig_sp)
 		return;
-	if (task)
-		save_context_stack(trace, &trace->skip, new_sp,
-				   (unsigned long) task_stack_page(task),
-				   (unsigned long) task_stack_page(task) + THREAD_SIZE);
-	else
-		save_context_stack(trace, &trace->skip, new_sp,
-				   S390_lowcore.thread_info,
-				   S390_lowcore.thread_info + THREAD_SIZE);
+
+	save_context_stack(trace, &trace->skip, new_sp,
+			   S390_lowcore.thread_info,
+			   S390_lowcore.thread_info + THREAD_SIZE);
 	return;
 }
diff -puN arch/sh/kernel/stacktrace.c~simplify-the-stacktrace-code arch/sh/kernel/stacktrace.c
--- a/arch/sh/kernel/stacktrace.c~simplify-the-stacktrace-code
+++ a/arch/sh/kernel/stacktrace.c
@@ -19,14 +19,7 @@
  */
 void save_stack_trace(struct stack_trace *trace, struct task_struct *task)
 {
-	unsigned long *sp;
-
-	if (!task)
-		task = current;
-	if (task == current)
-		sp = (unsigned long *)current_stack_pointer;
-	else
-		sp = (unsigned long *)task->thread.sp;
+	unsigned long *sp = (unsigned long *)current_stack_pointer;
 
 	while (!kstack_end(sp)) {
 		unsigned long addr = *sp++;
diff -puN arch/sparc64/kernel/stacktrace.c~simplify-the-stacktrace-code arch/sparc64/kernel/stacktrace.c
--- a/arch/sparc64/kernel/stacktrace.c~simplify-the-stacktrace-code
+++ a/arch/sparc64/kernel/stacktrace.c
@@ -3,22 +3,16 @@
 #include <linux/thread_info.h>
 #include <asm/ptrace.h>
 
-void save_stack_trace(struct stack_trace *trace, struct task_struct *task)
+void save_stack_trace(struct stack_trace *trace)
 {
 	unsigned long ksp, fp, thread_base;
-	struct thread_info *tp;
+	struct thread_info *tp = task_thread_info(current);
 
-	if (!task)
-		task = current;
-	tp = task_thread_info(task);
-	if (task == current) {
-		flushw_all();
-		__asm__ __volatile__(
-			"mov	%%fp, %0"
-			: "=r" (ksp)
-		);
-	} else
-		ksp = tp->ksp;
+	flushw_all();
+	__asm__ __volatile__(
+		"mov	%%fp, %0"
+		: "=r" (ksp)
+	);
 
 	fp = ksp + STACK_BIAS;
 	thread_base = (unsigned long) tp;
diff -puN arch/x86_64/kernel/stacktrace.c~simplify-the-stacktrace-code arch/x86_64/kernel/stacktrace.c
--- a/arch/x86_64/kernel/stacktrace.c~simplify-the-stacktrace-code
+++ a/arch/x86_64/kernel/stacktrace.c
@@ -21,8 +21,7 @@ save_stack_warning_symbol(void *data, ch
 
 static int save_stack_stack(void *data, char *name)
 {
-	struct stack_trace *trace = (struct stack_trace *)data;
-	return trace->all_contexts ? 0 : -1;
+	return -1;
 }
 
 static void save_stack_address(void *data, unsigned long addr)
@@ -46,11 +45,10 @@ static struct stacktrace_ops save_stack_
 /*
  * Save stack-backtrace addresses into a stack_trace buffer.
  */
-void save_stack_trace(struct stack_trace *trace, struct task_struct *task)
+void save_stack_trace(struct stack_trace *trace)
 {
-	dump_trace(task, NULL, NULL, &save_stack_ops, trace);
+	dump_trace(current, NULL, NULL, &save_stack_ops, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 EXPORT_SYMBOL(save_stack_trace);
-
diff -puN include/linux/stacktrace.h~simplify-the-stacktrace-code include/linux/stacktrace.h
--- a/include/linux/stacktrace.h~simplify-the-stacktrace-code
+++ a/include/linux/stacktrace.h
@@ -6,15 +6,13 @@ struct stack_trace {
 	unsigned int nr_entries, max_entries;
 	unsigned long *entries;
 	int skip;	/* input argument: How many entries to skip */
-	int all_contexts; /* input argument: if true do than one stack */
 };
 
-extern void save_stack_trace(struct stack_trace *trace,
-			     struct task_struct *task);
+extern void save_stack_trace(struct stack_trace *trace);
 
 extern void print_stack_trace(struct stack_trace *trace, int spaces);
 #else
-# define save_stack_trace(trace, task)			do { } while (0)
+# define save_stack_trace(trace)			do { } while (0)
 # define print_stack_trace(trace)			do { } while (0)
 #endif
 
diff -puN kernel/lockdep.c~simplify-the-stacktrace-code kernel/lockdep.c
--- a/kernel/lockdep.c~simplify-the-stacktrace-code
+++ a/kernel/lockdep.c
@@ -257,9 +257,8 @@ static int save_trace(struct stack_trace
 	trace->entries = stack_trace + nr_stack_trace_entries;
 
 	trace->skip = 3;
-	trace->all_contexts = 0;
 
-	save_stack_trace(trace, NULL);
+	save_stack_trace(trace);
 
 	trace->max_entries = trace->nr_entries;
 
diff -puN lib/fault-inject.c~simplify-the-stacktrace-code lib/fault-inject.c
--- a/lib/fault-inject.c~simplify-the-stacktrace-code
+++ a/lib/fault-inject.c
@@ -72,9 +72,8 @@ static bool fail_stacktrace(struct fault
 	trace.entries = entries;
 	trace.max_entries = depth;
 	trace.skip = 1;
-	trace.all_contexts = 0;
 
-	save_stack_trace(&trace, NULL);
+	save_stack_trace(&trace);
 	for (n = 0; n < trace.nr_entries; n++) {
 		if (attr->reject_start <= entries[n] &&
 			       entries[n] < attr->reject_end)
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
git-scsi-misc.patch
knfsd-trivial-makefile-cleanup.patch
aio-is-unlikely.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
