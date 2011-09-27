From: akpm@google.com
Subject: [wrecked] tracex86-add-x86-irq-vector-entry-exit-tracepoints.patch removed from -mm tree
Date: Tue, 27 Sep 2011 12:06:29 -0700
Message-ID: <201109271906.p8RJ6TRg000364@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:42898 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1I0TGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2011 15:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vnagarnaik@google.com, a.p.zijlstra@chello.nl, dhsharp@google.com, fweisbec@gmail.com, mingo@redhat.com, mrubin@google.com, rostedt@goodmis.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: trace,x86: add x86 irq vector entry/exit tracepoints
has been removed from the -mm tree.  Its filename was
     tracex86-add-x86-irq-vector-entry-exit-tracepoints.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: trace,x86: add x86 irq vector entry/exit tracepoints

The current interrupt traces from irq_handler_entry and irq_handler_exit
provide when an interrupt is handled.  They provide good data about when
the system has switched to kernel space and how it affects the currently
running processes.

There are some IRQ vectors which trigger the system into kernel space,
which are not handled in generic IRQ handlers.  Tracing such events gives
us the information about IRQ interaction with other system events.

The trace also tells where the system is spending its time.  We want to
know which cores are handling interrupts and how they are affecting other
processes in the system.  Also, the trace provides information about when
the cores are idle and which interrupts are changing that state.

The following patch adds the event definition and trace instrumentation
for interrupt vectors.  For x86, a lookup table is provided to print out
readable IRQ vector names.  The template can be used to provide interrupt
vector lookup tables on other architectures.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/irq_vectors.h       |   50 ++++++++++++++++++
 arch/x86/kernel/apic/apic.c              |    7 ++
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    3 +
 arch/x86/kernel/cpu/mcheck/threshold.c   |    3 +
 arch/x86/kernel/irq.c                    |    6 +-
 arch/x86/kernel/irq_work.c               |    3 +
 arch/x86/kernel/smp.c                    |    7 ++
 arch/x86/kernel/traps.c                  |    3 +
 arch/x86/mm/tlb.c                        |    3 +
 include/trace/events/irq_vectors.h       |   56 +++++++++++++++++++++
 10 files changed, 140 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/irq_vectors.h~tracex86-add-x86-irq-vector-entry-exit-tracepoints arch/x86/include/asm/irq_vectors.h
--- a/arch/x86/include/asm/irq_vectors.h~tracex86-add-x86-irq-vector-entry-exit-tracepoints
+++ a/arch/x86/include/asm/irq_vectors.h
@@ -177,4 +177,54 @@ static inline int invalid_vm86_irq(int i
 # define NR_IRQS			NR_IRQS_LEGACY
 #endif
 
+#define irq_vector_name(sirq) { sirq, #sirq }
+#define invalidate_tlb_vector_name(i) { INVALIDATE_TLB_VECTOR_END-31+i, \
+					"INVALIDATE_TLB_VECTOR" }
+
+#define irq_vector_name_table						\
+			irq_vector_name(NMI_VECTOR),			\
+			irq_vector_name(LOCAL_TIMER_VECTOR),		\
+			irq_vector_name(ERROR_APIC_VECTOR),		\
+			irq_vector_name(RESCHEDULE_VECTOR),		\
+			irq_vector_name(CALL_FUNCTION_VECTOR),		\
+			irq_vector_name(CALL_FUNCTION_SINGLE_VECTOR),	\
+			irq_vector_name(THERMAL_APIC_VECTOR),		\
+			irq_vector_name(THRESHOLD_APIC_VECTOR),		\
+			irq_vector_name(REBOOT_VECTOR),			\
+			irq_vector_name(SPURIOUS_APIC_VECTOR),		\
+			irq_vector_name(IRQ_WORK_VECTOR),		\
+			irq_vector_name(X86_PLATFORM_IPI_VECTOR),	\
+			invalidate_tlb_vector_name(0),			\
+			invalidate_tlb_vector_name(1),			\
+			invalidate_tlb_vector_name(2),			\
+			invalidate_tlb_vector_name(3),			\
+			invalidate_tlb_vector_name(4),			\
+			invalidate_tlb_vector_name(5),			\
+			invalidate_tlb_vector_name(6),			\
+			invalidate_tlb_vector_name(7),			\
+			invalidate_tlb_vector_name(8),			\
+			invalidate_tlb_vector_name(9),			\
+			invalidate_tlb_vector_name(10),			\
+			invalidate_tlb_vector_name(11),			\
+			invalidate_tlb_vector_name(12),			\
+			invalidate_tlb_vector_name(13),			\
+			invalidate_tlb_vector_name(14),			\
+			invalidate_tlb_vector_name(15),			\
+			invalidate_tlb_vector_name(16),			\
+			invalidate_tlb_vector_name(17),			\
+			invalidate_tlb_vector_name(18),			\
+			invalidate_tlb_vector_name(19),			\
+			invalidate_tlb_vector_name(20),			\
+			invalidate_tlb_vector_name(21),			\
+			invalidate_tlb_vector_name(22),			\
+			invalidate_tlb_vector_name(23),			\
+			invalidate_tlb_vector_name(24),			\
+			invalidate_tlb_vector_name(25),			\
+			invalidate_tlb_vector_name(26),			\
+			invalidate_tlb_vector_name(27),			\
+			invalidate_tlb_vector_name(28),			\
+			invalidate_tlb_vector_name(29),			\
+			invalidate_tlb_vector_name(30),			\
+			invalidate_tlb_vector_name(31)
+
 #endif /* _ASM_X86_IRQ_VECTORS_H */
diff -puN arch/x86/kernel/apic/apic.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints arch/x86/kernel/apic/apic.c
--- a/arch/x86/kernel/apic/apic.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints
+++ a/arch/x86/kernel/apic/apic.c
@@ -34,6 +34,7 @@
 #include <linux/dmi.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <trace/events/irq_vectors.h>
 
 #include <asm/perf_event.h>
 #include <asm/x86_init.h>
@@ -859,7 +860,9 @@ void __irq_entry smp_apic_timer_interrup
 	 */
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(LOCAL_TIMER_VECTOR);
 	local_apic_timer_interrupt();
+	trace_irq_vector_exit(LOCAL_TIMER_VECTOR);
 	irq_exit();
 
 	set_irq_regs(old_regs);
@@ -1793,6 +1796,7 @@ void smp_spurious_interrupt(struct pt_re
 
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(SPURIOUS_APIC_VECTOR);
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
 	 * if it is a vectored one.  Just in case...
@@ -1807,6 +1811,7 @@ void smp_spurious_interrupt(struct pt_re
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	pr_info("spurious APIC interrupt on CPU#%d, "
 		"should never happen.\n", smp_processor_id());
+	trace_irq_vector_exit(SPURIOUS_APIC_VECTOR);
 	irq_exit();
 }
 
@@ -1830,6 +1835,7 @@ void smp_error_interrupt(struct pt_regs 
 
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(ERROR_APIC_VECTOR);
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v0 = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
@@ -1850,6 +1856,7 @@ void smp_error_interrupt(struct pt_regs 
 
 	apic_printk(APIC_DEBUG, KERN_CONT "\n");
 
+	trace_irq_vector_exit(ERROR_APIC_VECTOR);
 	irq_exit();
 }
 
diff -puN arch/x86/kernel/cpu/mcheck/therm_throt.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints arch/x86/kernel/cpu/mcheck/therm_throt.c
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints
+++ a/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -24,6 +24,7 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <trace/events/irq_vectors.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -399,8 +400,10 @@ asmlinkage void smp_thermal_interrupt(st
 {
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(THERMAL_APIC_VECTOR);
 	inc_irq_stat(irq_thermal_count);
 	smp_thermal_vector();
+	trace_irq_vector_exit(THERMAL_APIC_VECTOR);
 	irq_exit();
 	/* Ack only at the end to avoid potential reentry */
 	ack_APIC_irq();
diff -puN arch/x86/kernel/cpu/mcheck/threshold.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints arch/x86/kernel/cpu/mcheck/threshold.c
--- a/arch/x86/kernel/cpu/mcheck/threshold.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints
+++ a/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -3,6 +3,7 @@
  */
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <trace/events/irq_vectors.h>
 
 #include <asm/irq_vectors.h>
 #include <asm/apic.h>
@@ -21,8 +22,10 @@ asmlinkage void smp_threshold_interrupt(
 {
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(THRESHOLD_APIC_VECTOR);
 	inc_irq_stat(irq_threshold_count);
 	mce_threshold_vector();
+	trace_irq_vector_exit(THRESHOLD_APIC_VECTOR);
 	irq_exit();
 	/* Ack only at the end to avoid potential reentry */
 	ack_APIC_irq();
diff -puN arch/x86/kernel/irq.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints arch/x86/kernel/irq.c
--- a/arch/x86/kernel/irq.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints
+++ a/arch/x86/kernel/irq.c
@@ -18,6 +18,9 @@
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/irq_vectors.h>
+
 atomic_t irq_err_count;
 
 /* Function pointer for generic interrupt vector handling */
@@ -212,12 +215,13 @@ void smp_x86_platform_ipi(struct pt_regs
 	exit_idle();
 
 	irq_enter();
-
+	trace_irq_vector_entry(X86_PLATFORM_IPI_VECTOR);
 	inc_irq_stat(x86_platform_ipis);
 
 	if (x86_platform_ipi_callback)
 		x86_platform_ipi_callback();
 
+	trace_irq_vector_exit(X86_PLATFORM_IPI_VECTOR);
 	irq_exit();
 
 	set_irq_regs(old_regs);
diff -puN arch/x86/kernel/irq_work.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints arch/x86/kernel/irq_work.c
--- a/arch/x86/kernel/irq_work.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints
+++ a/arch/x86/kernel/irq_work.c
@@ -8,13 +8,16 @@
 #include <linux/irq_work.h>
 #include <linux/hardirq.h>
 #include <asm/apic.h>
+#include <trace/events/irq_vectors.h>
 
 void smp_irq_work_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
 	ack_APIC_irq();
+	trace_irq_vector_entry(IRQ_WORK_VECTOR);
 	inc_irq_stat(apic_irq_work_irqs);
 	irq_work_run();
+	trace_irq_vector_exit(IRQ_WORK_VECTOR);
 	irq_exit();
 }
 
diff -puN arch/x86/kernel/smp.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints arch/x86/kernel/smp.c
--- a/arch/x86/kernel/smp.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints
+++ a/arch/x86/kernel/smp.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/gfp.h>
+#include <trace/events/irq_vectors.h>
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
@@ -200,8 +201,10 @@ static void native_stop_other_cpus(int w
 void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
+	trace_irq_vector_entry(RESCHEDULE_VECTOR);
 	inc_irq_stat(irq_resched_count);
 	scheduler_ipi();
+	trace_irq_vector_exit(RESCHEDULE_VECTOR);
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
@@ -211,8 +214,10 @@ void smp_call_function_interrupt(struct 
 {
 	ack_APIC_irq();
 	irq_enter();
+	trace_irq_vector_entry(CALL_FUNCTION_VECTOR);
 	generic_smp_call_function_interrupt();
 	inc_irq_stat(irq_call_count);
+	trace_irq_vector_exit(CALL_FUNCTION_VECTOR);
 	irq_exit();
 }
 
@@ -220,8 +225,10 @@ void smp_call_function_single_interrupt(
 {
 	ack_APIC_irq();
 	irq_enter();
+	trace_irq_vector_entry(CALL_FUNCTION_SINGLE_VECTOR);
 	generic_smp_call_function_single_interrupt();
 	inc_irq_stat(irq_call_count);
+	trace_irq_vector_exit(CALL_FUNCTION_SINGLE_VECTOR);
 	irq_exit();
 }
 
diff -puN arch/x86/kernel/traps.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints arch/x86/kernel/traps.c
--- a/arch/x86/kernel/traps.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints
+++ a/arch/x86/kernel/traps.c
@@ -31,6 +31,7 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <trace/events/irq_vectors.h>
 
 #ifdef CONFIG_EISA
 #include <linux/ioport.h>
@@ -434,12 +435,14 @@ dotraplinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
+	trace_irq_vector_entry(NMI_VECTOR);
 
 	inc_irq_stat(__nmi_count);
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
 
+	trace_irq_vector_exit(NMI_VECTOR);
 	nmi_exit();
 }
 
diff -puN arch/x86/mm/tlb.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~tracex86-add-x86-irq-vector-entry-exit-tracepoints
+++ a/arch/x86/mm/tlb.c
@@ -5,6 +5,7 @@
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <trace/events/irq_vectors.h>
 #include <linux/cpu.h>
 
 #include <asm/tlbflush.h>
@@ -141,6 +142,7 @@ void smp_invalidate_interrupt(struct pt_
 	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
 	f = &flush_state[sender];
 
+	trace_irq_vector_entry(INVALIDATE_TLB_VECTOR_START + sender);
 	if (!cpumask_test_cpu(cpu, to_cpumask(f->flush_cpumask)))
 		goto out;
 		/*
@@ -167,6 +169,7 @@ out:
 	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
 	smp_mb__after_clear_bit();
 	inc_irq_stat(irq_tlb_count);
+	trace_irq_vector_exit(INVALIDATE_TLB_VECTOR_START + sender);
 }
 
 static void flush_tlb_others_ipi(const struct cpumask *cpumask,
diff -puN /dev/null include/trace/events/irq_vectors.h
--- /dev/null
+++ a/include/trace/events/irq_vectors.h
@@ -0,0 +1,56 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM irq_vectors
+
+#if !defined(_TRACE_IRQ_VECTORS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IRQ_VECTORS_H
+
+#include <linux/tracepoint.h>
+#include <asm/irq.h>
+
+#ifndef irq_vector_name_table
+#define irq_vector_name_table { -1, NULL }
+#endif
+
+DECLARE_EVENT_CLASS(irq_vector,
+
+	TP_PROTO(int irq),
+
+	TP_ARGS(irq),
+
+	TP_STRUCT__entry(
+		__field(	int,	irq	)
+	),
+
+	TP_fast_assign(
+		__entry->irq = irq;
+	),
+
+	TP_printk("irq=%d name=%s", __entry->irq,
+		__print_symbolic(__entry->irq, irq_vector_name_table))
+);
+
+/*
+ * irq_vector_entry - called before enterring a interrupt vector handler
+ */
+DEFINE_EVENT(irq_vector, irq_vector_entry,
+
+	TP_PROTO(int irq),
+
+	TP_ARGS(irq)
+);
+
+/*
+ * irq_vector_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DEFINE_EVENT(irq_vector, irq_vector_exit,
+
+	TP_PROTO(int irq),
+
+	TP_ARGS(irq)
+);
+
+#endif /*  _TRACE_IRQ_VECTORS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
_

Patches currently in -mm which might be from vnagarnaik@google.com are


