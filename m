From: akpm@linux-foundation.org
Subject: - immediate-value-i386-optimization.patch removed from -mm tree
Date: Fri, 06 Jul 2007 17:28:47 -0700
Message-ID: <200707070032.l670WwXZ029879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39676 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753233AbXGGAdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 20:33:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Immediate Value: i386 Optimization
has been removed from the -mm tree.  Its filename was
     immediate-value-i386-optimization.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Immediate Value: i386 Optimization
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

i386 optimization of the immediate values which uses a movl with code patching
to set/unset the value used to populate the register used for the branch test.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/Makefile    |    1 
 arch/i386/kernel/immediate.c |  171 +++++++++++++++++++++++++++++++++
 arch/i386/kernel/traps.c     |    8 -
 include/asm-i386/immediate.h |   72 +++++++++++++
 4 files changed, 247 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/Makefile~immediate-value-i386-optimization arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~immediate-value-i386-optimization
+++ a/arch/i386/kernel/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_MODULES)		+= module.o
 obj-y				+= sysenter.o vsyscall.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_stub.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault.o
 obj-$(CONFIG_SERIAL_8250)	+= legacy_serial.o
 obj-$(CONFIG_VM86)		+= vm86.o
diff -puN /dev/null arch/i386/kernel/immediate.c
--- /dev/null
+++ a/arch/i386/kernel/immediate.c
@@ -0,0 +1,171 @@
+/*
+ * Immediate Value - i386 architecture specific code.
+ *
+ * Rationale
+ *
+ * Required because of :
+ * - Erratum 49 fix for Intel PIII.
+ * - Still present on newer processors : Intel Core 2 Duo Processor for Intel
+ *   Centrino Duo Processor Technology Specification Update, AH33.
+ *   Unsynchronized Cross-Modifying Code Operations Can Cause Unexpected
+ *   Instruction Execution Results.
+ *
+ * Permits immediate value modification by XMC with correct serialization.
+ *
+ * Reentrant for NMI and trap handler instrumentation. Permits XMC to a
+ * location that has preemption enabled because it involves no temporary or
+ * reused data structure.
+ *
+ * Quoting Richard J Moore, source of the information motivating this
+ * implementation which differs from the one proposed by Intel which is not
+ * suitable for kernel context (does not support NMI and would require disabling
+ * interrupts on every CPU for a long period) :
+ *
+ * "There is another issue to consider when looking into using probes other
+ * then int3:
+ *
+ * Intel erratum 54 - Unsynchronized Cross-modifying code - refers to the
+ * practice of modifying code on one processor where another has prefetched
+ * the unmodified version of the code. Intel states that unpredictable general
+ * protection faults may result if a synchronizing instruction (iret, int,
+ * int3, cpuid, etc ) is not executed on the second processor before it
+ * executes the pre-fetched out-of-date copy of the instruction.
+ *
+ * When we became aware of this I had a long discussion with Intel's
+ * microarchitecture guys. It turns out that the reason for this erratum
+ * (which incidentally Intel does not intend to fix) is because the trace
+ * cache - the stream of micorops resulting from instruction interpretation -
+ * cannot guaranteed to be valid. Reading between the lines I assume this
+ * issue arises because of optimization done in the trace cache, where it is
+ * no longer possible to identify the original instruction boundaries. If the
+ * CPU discoverers that the trace cache has been invalidated because of
+ * unsynchronized cross-modification then instruction execution will be
+ * aborted with a GPF. Further discussion with Intel revealed that replacing
+ * the first opcode byte with an int3 would not be subject to this erratum.
+ *
+ * So, is cmpxchg reliable? One has to guarantee more than mere atomicity."
+ *
+ * Overall design
+ *
+ * The algorithm proposed by Intel applies not so well in kernel context: it
+ * would imply disabling interrupts and looping on every CPUs while modifying
+ * the code and would not support instrumentation of code called from interrupt
+ * sources that cannot be disabled.
+ *
+ * Therefore, we use a different algorithm to respect Intel's erratum (see the
+ * quoted discussion above). We make sure that no CPU sees an out-of-date copy
+ * of a pre-fetched instruction by 1 - using a breakpoint, which skips the
+ * instruction that is going to be modified, 2 - issuing an IPI to every CPU to
+ * execute a sync_core(), to make sure that even when the breakpoint is removed,
+ * no cpu could possibly still have the out-of-date copy of the instruction,
+ * modify the now unused 2nd byte of the instruction, and then put back the
+ * original 1st byte of the instruction.
+ *
+ * It has exactly the same intent as the algorithm proposed by Intel, but
+ * it has less side-effects, scales better and supports NMI, SMI and MCE.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/notifier.h>
+#include <linux/preempt.h>
+#include <linux/smp.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+#include <linux/immediate.h>
+#include <linux/kdebug.h>
+#include <linux/rcupdate.h>
+
+#include <asm/cacheflush.h>
+
+#define BREAKPOINT_INSTRUCTION  0xcc
+#define BREAKPOINT_INS_LEN 1
+
+static long target_eip;
+
+static void immediate_synchronize_core(void *info)
+{
+	sync_core();	/* use cpuid to stop speculative execution */
+}
+
+/*
+ * The eip value points right after the breakpoint instruction, in the second
+ * byte of the movl. Incrementing it of 4 bytes makes the code resume right
+ * after the movl instruction, effectively skipping this instruction.
+ *
+ * We simply skip the 4 bytes load immediate here, leaving the register in an
+ * undefined state. We don't care about the content (0 or !0), because we are
+ * changing the value 0->1 or 1->0. This small window of undefined value
+ * doesn't matter.
+ */
+static int immediate_notifier(struct notifier_block *nb,
+	unsigned long val, void *data)
+{
+	enum die_val die_val = (enum die_val) val;
+	struct die_args *args = data;
+
+	if (!args->regs || user_mode_vm(args->regs))
+		return NOTIFY_DONE;
+
+	if (die_val == DIE_INT3	&& args->regs->eip == target_eip) {
+		args->regs->eip += 4; /* Skip the rest of the load immediate */
+		return NOTIFY_STOP;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block immediate_notify = {
+	.notifier_call = immediate_notifier,
+	.priority = 0x7fffffff,	/* we need to be notified first */
+};
+
+/*
+ * The address is not aligned. We can only change 1 byte of the value
+ * atomically.
+ * Must be called with immediate_mutex held.
+ */
+int immediate_optimized_set_enable(void *address, char enable)
+{
+	char saved_byte;
+	int ret;
+	char *dest = address;
+
+	if (!(enable ^ dest[1])) /* Must be a state change 0<->1 to execute */
+		return 0;
+
+	/* We plan to write only on the 1st 2 bytes of the movl */
+	kernel_text_lock((unsigned long)address, 2);
+	target_eip = (long)address + BREAKPOINT_INS_LEN;
+	/* register_die_notifier has memory barriers */
+	register_die_notifier(&immediate_notify);
+	saved_byte = *dest;
+	*dest = BREAKPOINT_INSTRUCTION;
+	wmb();
+	/*
+	 * Execute serializing instruction on each CPU.
+	 * Acts as a memory barrier.
+	 */
+	ret = on_each_cpu(immediate_synchronize_core, NULL, 1, 1);
+	BUG_ON(ret != 0);
+
+	dest[1] = enable;
+	wmb();
+	*dest = saved_byte;
+	kernel_text_unlock((unsigned long)address, 2);
+		/*
+		 * Wait for all int3 handlers to end
+		 * (interrupts are disabled in int3).
+		 * This CPU is clearly not in a int3 handler,
+		 * because int3 handler is not preemptible and
+		 * there cannot be any more int3 handler called
+		 * for this site, because we placed the original
+		 * instruction back.
+		 * synchronize_sched has memory barriers.
+		 */
+	synchronize_sched();
+	unregister_die_notifier(&immediate_notify);
+	/* unregister_die_notifier has memory barriers */
+	target_eip = 0;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(immediate_optimized_set_enable);
diff -puN arch/i386/kernel/traps.c~immediate-value-i386-optimization arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~immediate-value-i386-optimization
+++ a/arch/i386/kernel/traps.c
@@ -624,7 +624,7 @@ fastcall void do_##name(struct pt_regs *
 }
 
 DO_VM86_ERROR_INFO( 0, SIGFPE,  "divide error", divide_error, FPE_INTDIV, regs->eip)
-#ifndef CONFIG_KPROBES
+#if !defined(CONFIG_KPROBES) && !defined(CONFIG_IMMEDIATE)
 DO_VM86_ERROR( 3, SIGTRAP, "int3", int3)
 #endif
 DO_VM86_ERROR( 4, SIGSEGV, "overflow", overflow)
@@ -843,14 +843,14 @@ fastcall __kprobes void do_nmi(struct pt
 	nmi_exit();
 }
 
-#ifdef CONFIG_KPROBES
+#if defined(CONFIG_KPROBES) || defined(CONFIG_IMMEDIATE)
 fastcall void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
 		return;
-	/* This is an interrupt gate, because kprobes wants interrupts
-	disabled.  Normal trap handlers don't. */
+	/* This is an interrupt gate, because kprobes and immediate valueswants
+	 * interrupts disabled. Normal trap handlers don't. */
 	restore_interrupts(regs);
 	do_trap(3, SIGTRAP, "int3", 1, regs, error_code, NULL);
 }
diff -puN include/asm-i386/immediate.h~immediate-value-i386-optimization include/asm-i386/immediate.h
--- a/include/asm-i386/immediate.h~immediate-value-i386-optimization
+++ a/include/asm-i386/immediate.h
@@ -1 +1,71 @@
-#include <asm-generic/immediate.h>
+#ifndef _ASM_I386_IMMEDIATE_H
+#define _ASM_I386_IMMEDIATE_H
+
+/*
+ * Immediate values. i386 architecture optimizations.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#define IF_DEFAULT (IF_OPTIMIZED | IF_LOCKDEP)
+
+/*
+ * Optimized version of the immediate. Passing the flags as a pointer to
+ * the inline assembly to trick it into putting the flags value as third
+ * parameter in the structure.
+ */
+#define immediate_optimized(flags, var)					\
+	({								\
+		int condition;						\
+		asm (	".section __immediate, \"a\", @progbits;\n\t"	\
+					".long %1, 0f, %2;\n\t"		\
+					".previous;\n\t"		\
+					"0:\n\t"			\
+					"movl %3,%0;\n\t"		\
+				: "=r" (condition)			\
+				: "m" (var),				\
+				  "m" (*(char*)flags),			\
+				  "i" (0));				\
+		condition;						\
+	})
+
+/*
+ * immediate macro selecting the generic or optimized version of immediate,
+ * depending on the flags specified. It is a macro because we need to pass the
+ * name to immediate_optimized() and immediate_generic() so they can declare a
+ * static variable with it.
+ */
+#define _immediate(flags, var)						\
+({									\
+	(((flags) & IF_LOCKDEP) && ((flags) & IF_OPTIMIZED)) ?		\
+		immediate_optimized(flags, var) :			\
+		immediate_generic(flags, var);				\
+})
+
+/* immediate with default behavior */
+#define immediate(var)	_immediate(IF_DEFAULT, var)
+
+/*
+ * Architecture dependant immediate information, used internally for immediate
+ * activation.
+ */
+
+/*
+ * Offset of the immediate value from the start of the movl instruction, in
+ * bytes. We point to the first lower byte of the 4 bytes immediate value. Only
+ * changing one byte makes sure we do an atomic memory write, independently of
+ * the alignment of the 4 bytes in the load immediate instruction.
+ */
+#define IMMEDIATE_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 1
+#define IMMEDIATE_OPTIMIZED_ENABLE_TYPE unsigned char
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define IMMEDIATE_OPTIMIZED_ENABLE(a)					\
+	(*(IMMEDIATE_OPTIMIZED_ENABLE_TYPE*)				\
+		((char*)(a)+IMMEDIATE_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET))
+
+extern int immediate_optimized_set_enable(void *address, char enable);
+
+#endif /* _ASM_I386_IMMEDIATE_H */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
scheduler-profiling-use-immediate-values-fix.patch
cxgb3-vs-immediate-stuff.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
