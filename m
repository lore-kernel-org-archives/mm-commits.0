From: akpm@linux-foundation.org
Subject: [patch 57/96] powerpc/64s: implement arch-specific
 hardlockup watchdog
Date: Wed, 12 Jul 2017 14:35:52 -0700
Message-ID: <20170712213552.8pxQcRxle%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54472 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752710AbdGLVgB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:36:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, babu.moger@oracle.com, benh@kernel.crashing.org, dzickus@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com, paulus@samba.org, torvalds@linux-foundation.org

From: Nicholas Piggin <npiggin@gmail.com>
Subject: powerpc/64s: implement arch-specific hardlockup watchdog

Implement an arch-speicfic watchdog rather than use the perf-based
hardlockup detector.

The new watchdog takes the soft-NMI directly, rather than going through
perf.  Perf interrupts are to be made maskable in future, so that would
prevent the perf detector from working in those regions.

Additionally, implement a SMP based detector where all CPUs watch one
another by pinging a shared cpumask.  This is because powerpc Book3S does
not have a true periodic local NMI, but some platforms do implement a true
NMI IPI.

If a CPU is stuck with interrupts hard disabled, the soft-NMI watchdog
does not work, but the SMP watchdog will.  Even on platforms without a
true NMI IPI to get a good trace from the stuck CPU, other CPUs will
notice the lockup sufficiently to report it and panic.

[npiggin@gmail.com: honor watchdog disable at boot/hotplug]
  Link: http://lkml.kernel.org/r/20170621001346.5bb337c9@roar.ozlabs.ibm.com
[npiggin@gmail.com: fix false positive warning at CPU unplug]
  Link: http://lkml.kernel.org/r/20170630080740.20766-1-npiggin@gmail.com
[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20170616065715.18390-6-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Don Zickus <dzickus@redhat.com>
Tested-by: Babu Moger <babu.moger@oracle.com>	[sparc]
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                 |    7 
 arch/powerpc/include/asm/nmi.h       |   11 
 arch/powerpc/include/asm/smp.h       |    2 
 arch/powerpc/kernel/Makefile         |    1 
 arch/powerpc/kernel/exceptions-64s.S |   30 +
 arch/powerpc/kernel/kvm.c            |    7 
 arch/powerpc/kernel/setup_64.c       |   19 -
 arch/powerpc/kernel/smp.c            |   20 +
 arch/powerpc/kernel/watchdog.c       |  386 +++++++++++++++++++++++++
 9 files changed, 458 insertions(+), 25 deletions(-)

diff -puN arch/powerpc/Kconfig~powerpc-64s-implement-arch-specific-hardlockup-watchdog arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-64s-implement-arch-specific-hardlockup-watchdog
+++ a/arch/powerpc/Kconfig
@@ -82,7 +82,7 @@ config NR_IRQS
 
 config NMI_IPI
 	bool
-	depends on SMP && (DEBUGGER || KEXEC_CORE)
+	depends on SMP && (DEBUGGER || KEXEC_CORE || HARDLOCKUP_DETECTOR)
 	default y
 
 config STACKTRACE_SUPPORT
@@ -192,12 +192,13 @@ config PPC
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_MOD_ARCH_SPECIFIC
-	select HAVE_NMI				if PERF_EVENTS
+	select HAVE_NMI				if PERF_EVENTS || (PPC64 && PPC_BOOK3S)
+	select HAVE_HARDLOCKUP_DETECTOR_ARCH	if (PPC64 && PPC_BOOK3S)
 	select HAVE_OPROFILE
 	select HAVE_OPTPROBES			if PPC64
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI		if PPC64
-	select HAVE_HARDLOCKUP_DETECTOR_PERF	if HAVE_PERF_EVENTS_NMI
+	select HAVE_HARDLOCKUP_DETECTOR_PERF	if HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_RCU_TABLE_FREE		if SMP
diff -puN arch/powerpc/include/asm/nmi.h~powerpc-64s-implement-arch-specific-hardlockup-watchdog arch/powerpc/include/asm/nmi.h
--- a/arch/powerpc/include/asm/nmi.h~powerpc-64s-implement-arch-specific-hardlockup-watchdog
+++ a/arch/powerpc/include/asm/nmi.h
@@ -1,4 +1,15 @@
 #ifndef _ASM_NMI_H
 #define _ASM_NMI_H
 
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+extern void arch_touch_nmi_watchdog(void);
+
+extern void arch_trigger_cpumask_backtrace(const cpumask_t *mask,
+					   bool exclude_self);
+#define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
+
+#else
+static inline void arch_touch_nmi_watchdog(void) {}
+#endif
+
 #endif /* _ASM_NMI_H */
diff -puN arch/powerpc/include/asm/smp.h~powerpc-64s-implement-arch-specific-hardlockup-watchdog arch/powerpc/include/asm/smp.h
--- a/arch/powerpc/include/asm/smp.h~powerpc-64s-implement-arch-specific-hardlockup-watchdog
+++ a/arch/powerpc/include/asm/smp.h
@@ -55,6 +55,8 @@ struct smp_ops_t {
 	int   (*cpu_bootable)(unsigned int nr);
 };
 
+extern void smp_flush_nmi_ipi(u64 delay_us);
+extern int smp_send_nmi_ipi(int cpu, void (*fn)(struct pt_regs *), u64 delay_us);
 extern void smp_send_debugger_break(void);
 extern void start_secondary_resume(void);
 extern void smp_generic_give_timebase(void);
diff -puN arch/powerpc/kernel/Makefile~powerpc-64s-implement-arch-specific-hardlockup-watchdog arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~powerpc-64s-implement-arch-specific-hardlockup-watchdog
+++ a/arch/powerpc/kernel/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_PPC64)		+= setup_64.o sys_p
 				   signal_64.o ptrace32.o \
 				   paca.o nvram_64.o firmware.o
 obj-$(CONFIG_VDSO32)		+= vdso32/
+obj-$(CONFIG_HARDLOCKUP_DETECTOR)	+= watchdog.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= hw_breakpoint.o
 obj-$(CONFIG_PPC_BOOK3S_64)	+= cpu_setup_ppc970.o cpu_setup_pa6t.o
 obj-$(CONFIG_PPC_BOOK3S_64)	+= cpu_setup_power.o
diff -puN arch/powerpc/kernel/exceptions-64s.S~powerpc-64s-implement-arch-specific-hardlockup-watchdog arch/powerpc/kernel/exceptions-64s.S
--- a/arch/powerpc/kernel/exceptions-64s.S~powerpc-64s-implement-arch-specific-hardlockup-watchdog
+++ a/arch/powerpc/kernel/exceptions-64s.S
@@ -1314,6 +1314,31 @@ EXC_REAL_NONE(0x1800, 0x100)
 EXC_VIRT_NONE(0x5800, 0x100)
 #endif
 
+#if defined(CONFIG_HARDLOCKUP_DETECTOR) && defined(CONFIG_HAVE_HARDLOCKUP_DETECTOR_ARCH)
+
+#define MASKED_DEC_HANDLER_LABEL 3f
+
+#define MASKED_DEC_HANDLER(_H)				\
+3: /* soft-nmi */					\
+	std	r12,PACA_EXGEN+EX_R12(r13);		\
+	GET_SCRATCH0(r10);				\
+	std	r10,PACA_EXGEN+EX_R13(r13);		\
+	EXCEPTION_PROLOG_PSERIES_1(soft_nmi_common, _H)
+
+EXC_COMMON_BEGIN(soft_nmi_common)
+	mr	r10,r1
+	ld	r1,PACAEMERGSP(r13)
+	ld	r1,PACA_NMI_EMERG_SP(r13)
+	subi	r1,r1,INT_FRAME_SIZE
+	EXCEPTION_COMMON_NORET_STACK(PACA_EXGEN, 0x900,
+			system_reset, soft_nmi_interrupt,
+			ADD_NVGPRS;ADD_RECONCILE)
+	b	ret_from_except
+
+#else
+#define MASKED_DEC_HANDLER_LABEL 2f /* normal return */
+#define MASKED_DEC_HANDLER(_H)
+#endif
 
 /*
  * An interrupt came in while soft-disabled. We set paca->irq_happened, then:
@@ -1336,7 +1361,7 @@ masked_##_H##interrupt:					\
 	lis	r10,0x7fff;				\
 	ori	r10,r10,0xffff;				\
 	mtspr	SPRN_DEC,r10;				\
-	b	2f;					\
+	b	MASKED_DEC_HANDLER_LABEL;		\
 1:	cmpwi	r10,PACA_IRQ_DBELL;			\
 	beq	2f;					\
 	cmpwi	r10,PACA_IRQ_HMI;			\
@@ -1351,7 +1376,8 @@ masked_##_H##interrupt:					\
 	ld	r11,PACA_EXGEN+EX_R11(r13);		\
 	GET_SCRATCH0(r13);				\
 	##_H##rfid;					\
-	b	.
+	b	.;					\
+	MASKED_DEC_HANDLER(_H)
 
 /*
  * Real mode exceptions actually use this too, but alternate
diff -puN arch/powerpc/kernel/kvm.c~powerpc-64s-implement-arch-specific-hardlockup-watchdog arch/powerpc/kernel/kvm.c
--- a/arch/powerpc/kernel/kvm.c~powerpc-64s-implement-arch-specific-hardlockup-watchdog
+++ a/arch/powerpc/kernel/kvm.c
@@ -25,6 +25,7 @@
 #include <linux/kvm_para.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/nmi.h> /* hardlockup_detector_disable() */
 
 #include <asm/reg.h>
 #include <asm/sections.h>
@@ -718,6 +719,12 @@ static __init void kvm_free_tmp(void)
 
 static int __init kvm_guest_init(void)
 {
+	/*
+	 * The hardlockup detector is likely to get false positives in
+	 * KVM guests, so disable it by default.
+	 */
+	hardlockup_detector_disable();
+
 	if (!kvm_para_available())
 		goto free_tmp;
 
diff -puN arch/powerpc/kernel/setup_64.c~powerpc-64s-implement-arch-specific-hardlockup-watchdog arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~powerpc-64s-implement-arch-specific-hardlockup-watchdog
+++ a/arch/powerpc/kernel/setup_64.c
@@ -751,22 +751,3 @@ unsigned long memory_block_size_bytes(vo
 struct ppc_pci_io ppc_pci_io;
 EXPORT_SYMBOL(ppc_pci_io);
 #endif
-
-#ifdef CONFIG_HARDLOCKUP_DETECTOR_PERF
-u64 hw_nmi_get_sample_period(int watchdog_thresh)
-{
-	return ppc_proc_freq * watchdog_thresh;
-}
-
-/*
- * The hardlockup detector breaks PMU event based branches and is likely
- * to get false positives in KVM guests, so disable it by default.
- */
-static int __init disable_hardlockup_detector(void)
-{
-	hardlockup_detector_disable();
-
-	return 0;
-}
-early_initcall(disable_hardlockup_detector);
-#endif
diff -puN arch/powerpc/kernel/smp.c~powerpc-64s-implement-arch-specific-hardlockup-watchdog arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c~powerpc-64s-implement-arch-specific-hardlockup-watchdog
+++ a/arch/powerpc/kernel/smp.c
@@ -435,13 +435,31 @@ static void do_smp_send_nmi_ipi(int cpu)
 	}
 }
 
+void smp_flush_nmi_ipi(u64 delay_us)
+{
+	unsigned long flags;
+
+	nmi_ipi_lock_start(&flags);
+	while (nmi_ipi_busy_count) {
+		nmi_ipi_unlock_end(&flags);
+		udelay(1);
+		if (delay_us) {
+			delay_us--;
+			if (!delay_us)
+				return;
+		}
+		nmi_ipi_lock_start(&flags);
+	}
+	nmi_ipi_unlock_end(&flags);
+}
+
 /*
  * - cpu is the target CPU (must not be this CPU), or NMI_IPI_ALL_OTHERS.
  * - fn is the target callback function.
  * - delay_us > 0 is the delay before giving up waiting for targets to
  *   enter the handler, == 0 specifies indefinite delay.
  */
-static int smp_send_nmi_ipi(int cpu, void (*fn)(struct pt_regs *), u64 delay_us)
+int smp_send_nmi_ipi(int cpu, void (*fn)(struct pt_regs *), u64 delay_us)
 {
 	unsigned long flags;
 	int me = raw_smp_processor_id();
diff -puN /dev/null arch/powerpc/kernel/watchdog.c
--- /dev/null
+++ a/arch/powerpc/kernel/watchdog.c
@@ -0,0 +1,386 @@
+/*
+ * Watchdog support on powerpc systems.
+ *
+ * Copyright 2017, IBM Corporation.
+ *
+ * This uses code from arch/sparc/kernel/nmi.c and kernel/watchdog.c
+ */
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/init.h>
+#include <linux/percpu.h>
+#include <linux/cpu.h>
+#include <linux/nmi.h>
+#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/kprobes.h>
+#include <linux/hardirq.h>
+#include <linux/reboot.h>
+#include <linux/slab.h>
+#include <linux/kdebug.h>
+#include <linux/sched/debug.h>
+#include <linux/delay.h>
+#include <linux/smp.h>
+
+#include <asm/paca.h>
+
+/*
+ * The watchdog has a simple timer that runs on each CPU, once per timer
+ * period. This is the heartbeat.
+ *
+ * Then there are checks to see if the heartbeat has not triggered on a CPU
+ * for the panic timeout period. Currently the watchdog only supports an
+ * SMP check, so the heartbeat only turns on when we have 2 or more CPUs.
+ *
+ * This is not an NMI watchdog, but Linux uses that name for a generic
+ * watchdog in some cases, so NMI gets used in some places.
+ */
+
+static cpumask_t wd_cpus_enabled __read_mostly;
+
+static u64 wd_panic_timeout_tb __read_mostly; /* timebase ticks until panic */
+static u64 wd_smp_panic_timeout_tb __read_mostly; /* panic other CPUs */
+
+static u64 wd_timer_period_ms __read_mostly;  /* interval between heartbeat */
+
+static DEFINE_PER_CPU(struct timer_list, wd_timer);
+static DEFINE_PER_CPU(u64, wd_timer_tb);
+
+/*
+ * These are for the SMP checker. CPUs clear their pending bit in their
+ * heartbeat. If the bitmask becomes empty, the time is noted and the
+ * bitmask is refilled.
+ *
+ * All CPUs clear their bit in the pending mask every timer period.
+ * Once all have cleared, the time is noted and the bits are reset.
+ * If the time since all clear was greater than the panic timeout,
+ * we can panic with the list of stuck CPUs.
+ *
+ * This will work best with NMI IPIs for crash code so the stuck CPUs
+ * can be pulled out to get their backtraces.
+ */
+static unsigned long __wd_smp_lock;
+static cpumask_t wd_smp_cpus_pending;
+static cpumask_t wd_smp_cpus_stuck;
+static u64 wd_smp_last_reset_tb;
+
+static inline void wd_smp_lock(unsigned long *flags)
+{
+	/*
+	 * Avoid locking layers if possible.
+	 * This may be called from low level interrupt handlers at some
+	 * point in future.
+	 */
+	local_irq_save(*flags);
+	while (unlikely(test_and_set_bit_lock(0, &__wd_smp_lock)))
+		cpu_relax();
+}
+
+static inline void wd_smp_unlock(unsigned long *flags)
+{
+	clear_bit_unlock(0, &__wd_smp_lock);
+	local_irq_restore(*flags);
+}
+
+static void wd_lockup_ipi(struct pt_regs *regs)
+{
+	pr_emerg("Watchdog CPU:%d Hard LOCKUP\n", raw_smp_processor_id());
+	print_modules();
+	print_irqtrace_events(current);
+	if (regs)
+		show_regs(regs);
+	else
+		dump_stack();
+
+	if (hardlockup_panic)
+		nmi_panic(regs, "Hard LOCKUP");
+}
+
+static void set_cpu_stuck(int cpu, u64 tb)
+{
+	cpumask_set_cpu(cpu, &wd_smp_cpus_stuck);
+	cpumask_clear_cpu(cpu, &wd_smp_cpus_pending);
+	if (cpumask_empty(&wd_smp_cpus_pending)) {
+		wd_smp_last_reset_tb = tb;
+		cpumask_andnot(&wd_smp_cpus_pending,
+				&wd_cpus_enabled,
+				&wd_smp_cpus_stuck);
+	}
+}
+
+static void watchdog_smp_panic(int cpu, u64 tb)
+{
+	unsigned long flags;
+	int c;
+
+	wd_smp_lock(&flags);
+	/* Double check some things under lock */
+	if ((s64)(tb - wd_smp_last_reset_tb) < (s64)wd_smp_panic_timeout_tb)
+		goto out;
+	if (cpumask_test_cpu(cpu, &wd_smp_cpus_pending))
+		goto out;
+	if (cpumask_weight(&wd_smp_cpus_pending) == 0)
+		goto out;
+
+	pr_emerg("Watchdog CPU:%d detected Hard LOCKUP other CPUS:%*pbl\n",
+			cpu, cpumask_pr_args(&wd_smp_cpus_pending));
+
+	/*
+	 * Try to trigger the stuck CPUs.
+	 */
+	for_each_cpu(c, &wd_smp_cpus_pending) {
+		if (c == cpu)
+			continue;
+		smp_send_nmi_ipi(c, wd_lockup_ipi, 1000000);
+	}
+	smp_flush_nmi_ipi(1000000);
+
+	/* Take the stuck CPU out of the watch group */
+	for_each_cpu(c, &wd_smp_cpus_pending)
+		set_cpu_stuck(c, tb);
+
+out:
+	wd_smp_unlock(&flags);
+
+	printk_safe_flush();
+	/*
+	 * printk_safe_flush() seems to require another print
+	 * before anything actually goes out to console.
+	 */
+	if (sysctl_hardlockup_all_cpu_backtrace)
+		trigger_allbutself_cpu_backtrace();
+
+	if (hardlockup_panic)
+		nmi_panic(NULL, "Hard LOCKUP");
+}
+
+static void wd_smp_clear_cpu_pending(int cpu, u64 tb)
+{
+	if (!cpumask_test_cpu(cpu, &wd_smp_cpus_pending)) {
+		if (unlikely(cpumask_test_cpu(cpu, &wd_smp_cpus_stuck))) {
+			unsigned long flags;
+
+			pr_emerg("Watchdog CPU:%d became unstuck\n", cpu);
+			wd_smp_lock(&flags);
+			cpumask_clear_cpu(cpu, &wd_smp_cpus_stuck);
+			wd_smp_unlock(&flags);
+		}
+		return;
+	}
+	cpumask_clear_cpu(cpu, &wd_smp_cpus_pending);
+	if (cpumask_empty(&wd_smp_cpus_pending)) {
+		unsigned long flags;
+
+		wd_smp_lock(&flags);
+		if (cpumask_empty(&wd_smp_cpus_pending)) {
+			wd_smp_last_reset_tb = tb;
+			cpumask_andnot(&wd_smp_cpus_pending,
+					&wd_cpus_enabled,
+					&wd_smp_cpus_stuck);
+		}
+		wd_smp_unlock(&flags);
+	}
+}
+
+static void watchdog_timer_interrupt(int cpu)
+{
+	u64 tb = get_tb();
+
+	per_cpu(wd_timer_tb, cpu) = tb;
+
+	wd_smp_clear_cpu_pending(cpu, tb);
+
+	if ((s64)(tb - wd_smp_last_reset_tb) >= (s64)wd_smp_panic_timeout_tb)
+		watchdog_smp_panic(cpu, tb);
+}
+
+void soft_nmi_interrupt(struct pt_regs *regs)
+{
+	unsigned long flags;
+	int cpu = raw_smp_processor_id();
+	u64 tb;
+
+	if (!cpumask_test_cpu(cpu, &wd_cpus_enabled))
+		return;
+
+	nmi_enter();
+	tb = get_tb();
+	if (tb - per_cpu(wd_timer_tb, cpu) >= wd_panic_timeout_tb) {
+		per_cpu(wd_timer_tb, cpu) = tb;
+
+		wd_smp_lock(&flags);
+		if (cpumask_test_cpu(cpu, &wd_smp_cpus_stuck)) {
+			wd_smp_unlock(&flags);
+			goto out;
+		}
+		set_cpu_stuck(cpu, tb);
+
+		pr_emerg("Watchdog CPU:%d Hard LOCKUP\n", cpu);
+		print_modules();
+		print_irqtrace_events(current);
+		if (regs)
+			show_regs(regs);
+		else
+			dump_stack();
+
+		wd_smp_unlock(&flags);
+
+		if (sysctl_hardlockup_all_cpu_backtrace)
+			trigger_allbutself_cpu_backtrace();
+
+		if (hardlockup_panic)
+			nmi_panic(regs, "Hard LOCKUP");
+	}
+	if (wd_panic_timeout_tb < 0x7fffffff)
+		mtspr(SPRN_DEC, wd_panic_timeout_tb);
+
+out:
+	nmi_exit();
+}
+
+static void wd_timer_reset(unsigned int cpu, struct timer_list *t)
+{
+	t->expires = jiffies + msecs_to_jiffies(wd_timer_period_ms);
+	if (wd_timer_period_ms > 1000)
+		t->expires = __round_jiffies_up(t->expires, cpu);
+	add_timer_on(t, cpu);
+}
+
+static void wd_timer_fn(unsigned long data)
+{
+	struct timer_list *t = this_cpu_ptr(&wd_timer);
+	int cpu = smp_processor_id();
+
+	watchdog_timer_interrupt(cpu);
+
+	wd_timer_reset(cpu, t);
+}
+
+void arch_touch_nmi_watchdog(void)
+{
+	int cpu = smp_processor_id();
+
+	watchdog_timer_interrupt(cpu);
+}
+EXPORT_SYMBOL(arch_touch_nmi_watchdog);
+
+static void start_watchdog_timer_on(unsigned int cpu)
+{
+	struct timer_list *t = per_cpu_ptr(&wd_timer, cpu);
+
+	per_cpu(wd_timer_tb, cpu) = get_tb();
+
+	setup_pinned_timer(t, wd_timer_fn, 0);
+	wd_timer_reset(cpu, t);
+}
+
+static void stop_watchdog_timer_on(unsigned int cpu)
+{
+	struct timer_list *t = per_cpu_ptr(&wd_timer, cpu);
+
+	del_timer_sync(t);
+}
+
+static int start_wd_on_cpu(unsigned int cpu)
+{
+	if (cpumask_test_cpu(cpu, &wd_cpus_enabled)) {
+		WARN_ON(1);
+		return 0;
+	}
+
+	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
+		return 0;
+
+	if (watchdog_suspended)
+		return 0;
+
+	if (!cpumask_test_cpu(cpu, &watchdog_cpumask))
+		return 0;
+
+	cpumask_set_cpu(cpu, &wd_cpus_enabled);
+	if (cpumask_weight(&wd_cpus_enabled) == 1) {
+		cpumask_set_cpu(cpu, &wd_smp_cpus_pending);
+		wd_smp_last_reset_tb = get_tb();
+	}
+	smp_wmb();
+	start_watchdog_timer_on(cpu);
+
+	return 0;
+}
+
+static int stop_wd_on_cpu(unsigned int cpu)
+{
+	if (!cpumask_test_cpu(cpu, &wd_cpus_enabled))
+		return 0; /* Can happen in CPU unplug case */
+
+	stop_watchdog_timer_on(cpu);
+
+	cpumask_clear_cpu(cpu, &wd_cpus_enabled);
+	wd_smp_clear_cpu_pending(cpu, get_tb());
+
+	return 0;
+}
+
+static void watchdog_calc_timeouts(void)
+{
+	wd_panic_timeout_tb = watchdog_thresh * ppc_tb_freq;
+
+	/* Have the SMP detector trigger a bit later */
+	wd_smp_panic_timeout_tb = wd_panic_timeout_tb * 3 / 2;
+
+	/* 2/5 is the factor that the perf based detector uses */
+	wd_timer_period_ms = watchdog_thresh * 1000 * 2 / 5;
+}
+
+void watchdog_nmi_reconfigure(void)
+{
+	int cpu;
+
+	watchdog_calc_timeouts();
+
+	for_each_cpu(cpu, &wd_cpus_enabled)
+		stop_wd_on_cpu(cpu);
+
+	for_each_cpu_and(cpu, cpu_online_mask, &watchdog_cpumask)
+		start_wd_on_cpu(cpu);
+}
+
+/*
+ * This runs after lockup_detector_init() which sets up watchdog_cpumask.
+ */
+static int __init powerpc_watchdog_init(void)
+{
+	int err;
+
+	watchdog_calc_timeouts();
+
+	err = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "powerpc/watchdog:online",
+				start_wd_on_cpu, stop_wd_on_cpu);
+	if (err < 0)
+		pr_warn("Watchdog could not be initialized");
+
+	return 0;
+}
+arch_initcall(powerpc_watchdog_init);
+
+static void handle_backtrace_ipi(struct pt_regs *regs)
+{
+	nmi_cpu_backtrace(regs);
+}
+
+static void raise_backtrace_ipi(cpumask_t *mask)
+{
+	unsigned int cpu;
+
+	for_each_cpu(cpu, mask) {
+		if (cpu == smp_processor_id())
+			handle_backtrace_ipi(NULL);
+		else
+			smp_send_nmi_ipi(cpu, handle_backtrace_ipi, 1000000);
+	}
+}
+
+void arch_trigger_cpumask_backtrace(const cpumask_t *mask, bool exclude_self)
+{
+	nmi_trigger_cpumask_backtrace(mask, exclude_self, raise_backtrace_ipi);
+}
_
