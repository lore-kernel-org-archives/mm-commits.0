From: akpm@linux-foundation.org
Subject: + uml-fix-irqstack-crash.patch added to -mm tree
Date: Tue, 18 Sep 2007 17:07:46 -0700
Message-ID: <200709190007.l8J07qob030586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbXISAHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Sep 2007 20:07:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: fix irqstack crash
has been added to the -mm tree.  Its filename is
     uml-fix-irqstack-crash.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix irqstack crash
From: Jeff Dike <jdike@addtoit.com>

This patch fixes a crash caused by an interrupt coming in when an IRQ stack
is being torn down.  When this happens, handle_signal will loop, setting up
the IRQ stack again because the tearing down had finished, and handling
whatever signals had come in.

However, to_irq_stack returns a mask of pending signals to be handled, plus
bit zero is set if the IRQ stack was already active, and thus shouldn't be
torn down.  This causes a problem because when handle_signal goes around
the loop, sig will be zero, and to_irq_stack will duly set bit zero in the
returned mask, faking handle_signal into believing that it shouldn't tear
down the IRQ stack and return thread_info pointers back to their original
values.

This will eventually cause a crash, as the IRQ stack thread_info will
continue pointing to the original task_struct and an interrupt will look
into it after it has been freed.

The fix is to stop passing a signal number into to_irq_stack.  Rather, the
pending signals mask is initialized beforehand with the bit for sig already
set.  References to sig in to_irq_stack can be replaced with references to
the mask.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/kern_util.h |    2 +-
 arch/um/kernel/irq.c        |    7 ++++---
 arch/um/os-Linux/signal.c   |    4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff -puN arch/um/include/kern_util.h~uml-fix-irqstack-crash arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-fix-irqstack-crash
+++ a/arch/um/include/kern_util.h
@@ -117,7 +117,7 @@ extern void sigio_handler(int sig, union
 
 extern void copy_sc(union uml_pt_regs *regs, void *from);
 
-unsigned long to_irq_stack(int sig, unsigned long *mask_out);
+extern unsigned long to_irq_stack(unsigned long *mask_out);
 unsigned long from_irq_stack(int nested);
 
 #endif
diff -puN arch/um/kernel/irq.c~uml-fix-irqstack-crash arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-fix-irqstack-crash
+++ a/arch/um/kernel/irq.c
@@ -518,13 +518,13 @@ int init_aio_irq(int irq, char *name, ir
 
 static unsigned long pending_mask;
 
-unsigned long to_irq_stack(int sig, unsigned long *mask_out)
+unsigned long to_irq_stack(unsigned long *mask_out)
 {
 	struct thread_info *ti;
 	unsigned long mask, old;
 	int nested;
 
-	mask = xchg(&pending_mask, 1 << sig);
+	mask = xchg(&pending_mask, *mask_out);
 	if(mask != 0){
 		/* If any interrupts come in at this point, we want to
 		 * make sure that their bits aren't lost by our
@@ -534,7 +534,7 @@ unsigned long to_irq_stack(int sig, unsi
 		 * and pending_mask contains a bit for each interrupt
 		 * that came in.
 		 */
-		old = 1 << sig;
+		old = *mask_out;
 		do {
 			old |= mask;
 			mask = xchg(&pending_mask, old);
@@ -550,6 +550,7 @@ unsigned long to_irq_stack(int sig, unsi
 
 		task = cpu_tasks[ti->cpu].task;
 		tti = task_thread_info(task);
+
 		*ti = *tti;
 		ti->real_thread = tti;
 		task->stack = ti;
diff -puN arch/um/os-Linux/signal.c~uml-fix-irqstack-crash arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-fix-irqstack-crash
+++ a/arch/um/os-Linux/signal.c
@@ -119,7 +119,7 @@ void (*handlers[_NSIG])(int sig, struct 
 
 void handle_signal(int sig, struct sigcontext *sc)
 {
-	unsigned long pending = 0;
+	unsigned long pending = 1 << sig;
 
 	do {
 		int nested, bail;
@@ -134,7 +134,7 @@ void handle_signal(int sig, struct sigco
 		 * have to return, and the upper handler will deal
 		 * with this interrupt.
 		 */
-		bail = to_irq_stack(sig, &pending);
+		bail = to_irq_stack(&pending);
 		if(bail)
 			return;
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-use-correct-type-in-blkgetsize-ioctl.patch
uml-fix-irqstack-crash.patch
uml-fix-irqstack-crash-fix.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
uml-remove-unused-file.patch
uml-more-idiomatic-parameter-parsing.patch
bitops-introduce-lock-ops.patch
