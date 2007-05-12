From: akpm@linux-foundation.org
Subject: - uml-irq-stacks.patch removed from -mm tree
Date: Fri, 11 May 2007 22:33:30 -0700
Message-ID: <200705120533.l4C5XUSE002108@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754790AbXELFdf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:33:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: iRQ stacks
has been removed from the -mm tree.  Its filename was
     uml-irq-stacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: iRQ stacks
From: Jeff Dike <jdike@addtoit.com>

Add a separate IRQ stack.  This differs from i386 in having the entire
interrupt run on a separate stack rather than starting on the normal kernel
stack and switching over once some preparation has been done.  The underlying
mechanism, is of course, sigaltstack.

Another difference is that interrupts that happen in userspace are handled on
the normal kernel stack.  These cause a wait wakeup instead of a signal
delivery so there is no point in trying to switch stacks for these.  There's
no other stuff on the stack, so there is no extra stack consumption.

This quirk makes it possible to have the entire interrupt run on a separate
stack - process preemption (and calls to schedule()) happens on a normal
kernel stack.  If we enable CONFIG_PREEMPT, this will need to be rethought.

The IRQ stack for CPU 0 is declared in the same way as the initial kernel
stack.  IRQ stacks for other CPUs will be allocated dynamically.

An extra field was added to the thread_info structure.  When the active
thread_info is copied to the IRQ stack, the real_thread field points back to
the original stack.  This makes it easy to tell where to copy the thread_info
struct back to when the interrupt is finished.  It also serves as a marker of
a nested interrupt.  It is NULL for the first interrupt on the stack, and
non-NULL for any nested interrupts.

Care is taken to behave correctly if a second interrupt comes in when the
thread_info structure is being set up or taken down.  I could just disable
interrupts here, but I don't feel like giving up any of the performance gained
by not flipping signals on and off.

If an interrupt comes in during these critical periods, the handler can't run
because it has no idea what shape the stack is in.  So, it sets a bit for its
signal in a global mask and returns.  The outer handler will deal with this
signal itself.

Atomicity is had with xchg.  A nested interrupt that needs to bail out will
xchg its signal mask into pending_mask and repeat in case yet another
interrupt hit at the same time, until the mask stabilizes.

The outermost interrupt will set up the thread_info and xchg a zero into
pending_mask when it is done.  At this point, nested interrupts will look at
->real_thread and see that no setup needs to be done.  They can just continue
normally.

Similar care needs to be taken when exiting the outer handler.  If another
interrupt comes in while it is copying the thread_info, it will drop a bit
into pending_mask.  The outer handler will check this and if it is non-zero,
will loop, set up the stack again, and handle the interrupt.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/kern_util.h          |    3 
 arch/um/kernel/dyn.lds.S             |    2 
 arch/um/kernel/init_task.c           |   16 ++-
 arch/um/kernel/irq.c                 |  111 +++++++++++++++++++++++++
 arch/um/kernel/skas/process.c        |    4 
 arch/um/kernel/uml.lds.S             |    2 
 arch/um/os-Linux/signal.c            |   40 +++++++++
 arch/um/os-Linux/sys-i386/signal.c   |    8 -
 arch/um/os-Linux/sys-x86_64/signal.c |    6 -
 include/asm-um/thread_info.h         |    2 
 10 files changed, 180 insertions(+), 14 deletions(-)

diff -puN arch/um/include/kern_util.h~uml-irq-stacks arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-irq-stacks
+++ a/arch/um/include/kern_util.h
@@ -117,4 +117,7 @@ extern void sigio_handler(int sig, union
 
 extern void copy_sc(union uml_pt_regs *regs, void *from);
 
+unsigned long to_irq_stack(int sig, unsigned long *mask_out);
+unsigned long from_irq_stack(int nested);
+
 #endif
diff -puN arch/um/kernel/dyn.lds.S~uml-irq-stacks arch/um/kernel/dyn.lds.S
--- a/arch/um/kernel/dyn.lds.S~uml-irq-stacks
+++ a/arch/um/kernel/dyn.lds.S
@@ -97,6 +97,8 @@ SECTIONS
   .data           : {
     . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
     *(.data.init_task)
+    . = ALIGN(KERNEL_STACK_SIZE);
+    *(.data.init_irqstack)
     *(.data .data.* .gnu.linkonce.d.*)
     SORT(CONSTRUCTORS)
   }
diff -puN arch/um/kernel/init_task.c~uml-irq-stacks arch/um/kernel/init_task.c
--- a/arch/um/kernel/init_task.c~uml-irq-stacks
+++ a/arch/um/kernel/init_task.c
@@ -1,5 +1,5 @@
-/* 
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,intel.linux}.com)
  * Licensed under the GPL
  */
 
@@ -33,14 +33,18 @@ EXPORT_SYMBOL(init_task);
 /*
  * Initial thread structure.
  *
- * We need to make sure that this is 16384-byte aligned due to the
+ * We need to make sure that this is aligned due to the
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
 
-union thread_union init_thread_union 
-__attribute__((__section__(".data.init_task"))) = 
-{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union
+	__attribute__((__section__(".data.init_task"))) =
+		{ INIT_THREAD_INFO(init_task) };
+
+union thread_union cpu0_irqstack
+	__attribute__((__section__(".data.init_irqstack"))) =
+		{ INIT_THREAD_INFO(init_task) };
 
 void unprotect_stack(unsigned long stack)
 {
diff -puN arch/um/kernel/irq.c~uml-irq-stacks arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-irq-stacks
+++ a/arch/um/kernel/irq.c
@@ -32,6 +32,7 @@
 #include "sigio.h"
 #include "um_malloc.h"
 #include "misc_constants.h"
+#include "as-layout.h"
 
 /*
  * Generic, controller-independent functions:
@@ -468,3 +469,113 @@ int init_aio_irq(int irq, char *name, ir
  out:
 	return err;
 }
+
+/*
+ * IRQ stack entry and exit:
+ *
+ * Unlike i386, UML doesn't receive IRQs on the normal kernel stack
+ * and switch over to the IRQ stack after some preparation.  We use
+ * sigaltstack to receive signals on a separate stack from the start.
+ * These two functions make sure the rest of the kernel won't be too
+ * upset by being on a different stack.  The IRQ stack has a
+ * thread_info structure at the bottom so that current et al continue
+ * to work.
+ *
+ * to_irq_stack copies the current task's thread_info to the IRQ stack
+ * thread_info and sets the tasks's stack to point to the IRQ stack.
+ *
+ * from_irq_stack copies the thread_info struct back (flags may have
+ * been modified) and resets the task's stack pointer.
+ *
+ * Tricky bits -
+ *
+ * What happens when two signals race each other?  UML doesn't block
+ * signals with sigprocmask, SA_DEFER, or sa_mask, so a second signal
+ * could arrive while a previous one is still setting up the
+ * thread_info.
+ *
+ * There are three cases -
+ *     The first interrupt on the stack - sets up the thread_info and
+ * handles the interrupt
+ *     A nested interrupt interrupting the copying of the thread_info -
+ * can't handle the interrupt, as the stack is in an unknown state
+ *     A nested interrupt not interrupting the copying of the
+ * thread_info - doesn't do any setup, just handles the interrupt
+ *
+ * The first job is to figure out whether we interrupted stack setup.
+ * This is done by xchging the signal mask with thread_info->pending.
+ * If the value that comes back is zero, then there is no setup in
+ * progress, and the interrupt can be handled.  If the value is
+ * non-zero, then there is stack setup in progress.  In order to have
+ * the interrupt handled, we leave our signal in the mask, and it will
+ * be handled by the upper handler after it has set up the stack.
+ *
+ * Next is to figure out whether we are the outer handler or a nested
+ * one.  As part of setting up the stack, thread_info->real_thread is
+ * set to non-NULL (and is reset to NULL on exit).  This is the
+ * nesting indicator.  If it is non-NULL, then the stack is already
+ * set up and the handler can run.
+ */
+
+static unsigned long pending_mask;
+
+unsigned long to_irq_stack(int sig, unsigned long *mask_out)
+{
+	struct thread_info *ti;
+	unsigned long mask, old;
+	int nested;
+
+	mask = xchg(&pending_mask, 1 << sig);
+	if(mask != 0){
+		/* If any interrupts come in at this point, we want to
+		 * make sure that their bits aren't lost by our
+		 * putting our bit in.  So, this loop accumulates bits
+		 * until xchg returns the same value that we put in.
+		 * When that happens, there were no new interrupts,
+		 * and pending_mask contains a bit for each interrupt
+		 * that came in.
+		 */
+		old = 1 << sig;
+		do {
+			old |= mask;
+			mask = xchg(&pending_mask, old);
+		} while(mask != old);
+		return 1;
+	}
+
+	ti = current_thread_info();
+	nested = (ti->real_thread != NULL);
+	if(!nested){
+		struct task_struct *task;
+		struct thread_info *tti;
+
+		task = cpu_tasks[ti->cpu].task;
+		tti = task_thread_info(task);
+		*ti = *tti;
+		ti->real_thread = tti;
+		task->stack = ti;
+	}
+
+	mask = xchg(&pending_mask, 0);
+	*mask_out |= mask | nested;
+	return 0;
+}
+
+unsigned long from_irq_stack(int nested)
+{
+	struct thread_info *ti, *to;
+	unsigned long mask;
+
+	ti = current_thread_info();
+
+	pending_mask = 1;
+
+	to = ti->real_thread;
+	current->stack = to;
+	ti->real_thread = NULL;
+	*to = *ti;
+
+	mask = xchg(&pending_mask, 0);
+	return mask & ~1;
+}
+
diff -puN arch/um/kernel/skas/process.c~uml-irq-stacks arch/um/kernel/skas/process.c
--- a/arch/um/kernel/skas/process.c~uml-irq-stacks
+++ a/arch/um/kernel/skas/process.c
@@ -163,8 +163,12 @@ static int start_kernel_proc(void *unuse
 
 extern int userspace_pid[];
 
+extern char cpu0_irqstack[];
+
 int start_uml_skas(void)
 {
+	stack_protections((unsigned long) &cpu0_irqstack);
+	set_sigstack(cpu0_irqstack, THREAD_SIZE);
 	if(proc_mm)
 		userspace_pid[0] = start_userspace(0);
 
diff -puN arch/um/kernel/uml.lds.S~uml-irq-stacks arch/um/kernel/uml.lds.S
--- a/arch/um/kernel/uml.lds.S~uml-irq-stacks
+++ a/arch/um/kernel/uml.lds.S
@@ -59,6 +59,8 @@ SECTIONS
   {
     . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
     *(.data.init_task)
+    . = ALIGN(KERNEL_STACK_SIZE);
+    *(.data.init_irqstack)
     *(.data)
     *(.gnu.linkonce.d*)
     CONSTRUCTORS
diff -puN arch/um/os-Linux/signal.c~uml-irq-stacks arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-irq-stacks
+++ a/arch/um/os-Linux/signal.c
@@ -117,6 +117,46 @@ void remove_sigstack(void)
 
 void (*handlers[_NSIG])(int sig, struct sigcontext *sc);
 
+void handle_signal(int sig, struct sigcontext *sc)
+{
+	unsigned long pending = 0;
+
+	do {
+		int nested, bail;
+
+		/*
+		 * pending comes back with one bit set for each
+		 * interrupt that arrived while setting up the stack,
+		 * plus a bit for this interrupt, plus the zero bit is
+		 * set if this is a nested interrupt.
+		 * If bail is true, then we interrupted another
+		 * handler setting up the stack.  In this case, we
+		 * have to return, and the upper handler will deal
+		 * with this interrupt.
+		 */
+		bail = to_irq_stack(sig, &pending);
+		if(bail)
+			return;
+
+		nested = pending & 1;
+		pending &= ~1;
+
+		while((sig = ffs(pending)) != 0){
+			sig--;
+			pending &= ~(1 << sig);
+			(*handlers[sig])(sig, sc);
+		}
+
+		/* Again, pending comes back with a mask of signals
+		 * that arrived while tearing down the stack.  If this
+		 * is non-zero, we just go back, set up the stack
+		 * again, and handle the new interrupts.
+		 */
+		if(!nested)
+			pending = from_irq_stack(nested);
+	} while(pending);
+}
+
 extern void hard_handler(int sig);
 
 void set_handler(int sig, void (*handler)(int), int flags, ...)
diff -puN arch/um/os-Linux/sys-i386/signal.c~uml-irq-stacks arch/um/os-Linux/sys-i386/signal.c
--- a/arch/um/os-Linux/sys-i386/signal.c~uml-irq-stacks
+++ a/arch/um/os-Linux/sys-i386/signal.c
@@ -1,15 +1,13 @@
 /*
- * Copyright (C) 2006 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2006 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include <signal.h>
 
-extern void (*handlers[])(int sig, struct sigcontext *sc);
+extern void handle_signal(int sig, struct sigcontext *sc);
 
 void hard_handler(int sig)
 {
-	struct sigcontext *sc = (struct sigcontext *) (&sig + 1);
-
-	(*handlers[sig])(sig, sc);
+	handle_signal(sig, (struct sigcontext *) (&sig + 1));
 }
diff -puN arch/um/os-Linux/sys-x86_64/signal.c~uml-irq-stacks arch/um/os-Linux/sys-x86_64/signal.c
--- a/arch/um/os-Linux/sys-x86_64/signal.c~uml-irq-stacks
+++ a/arch/um/os-Linux/sys-x86_64/signal.c
@@ -1,16 +1,16 @@
 /*
- * Copyright (C) 2006 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2006 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include <signal.h>
 
-extern void (*handlers[])(int sig, struct sigcontext *sc);
+extern void handle_signal(int sig, struct sigcontext *sc);
 
 void hard_handler(int sig)
 {
 	struct ucontext *uc;
 	asm("movq %%rdx, %0" : "=r" (uc));
 
-	(*handlers[sig])(sig, (struct sigcontext *) &uc->uc_mcontext);
+	handle_signal(sig, (struct sigcontext *) &uc->uc_mcontext);
 }
diff -puN include/asm-um/thread_info.h~uml-irq-stacks include/asm-um/thread_info.h
--- a/include/asm-um/thread_info.h~uml-irq-stacks
+++ a/include/asm-um/thread_info.h
@@ -22,6 +22,7 @@ struct thread_info {
 					 	   0-0xBFFFFFFF for user
 						   0-0xFFFFFFFF for kernel */
 	struct restart_block    restart_block;
+	struct thread_info	*real_thread;    /* Points to non-IRQ stack */
 };
 
 #define INIT_THREAD_INFO(tsk)			\
@@ -35,6 +36,7 @@ struct thread_info {
 	.restart_block =  {			\
 		.fn =  do_no_restart_syscall,	\
 	},					\
+	.real_thread = NULL,			\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
