From: akpm@osdl.org
Subject: - add-i386-idle-notifier-take-3.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:30 -0800
Message-ID: <200701102303.l0AN3UQV010829@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34059 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965237AbXAJXJ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:09:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eranian@hpl.hp.com, mm-commits@vger.kernel.org


The patch titled
     i386: add idle notifier
has been removed from the -mm tree.  Its filename was
     add-i386-idle-notifier-take-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: add idle notifier
From: Stephane Eranian <eranian@hpl.hp.com>

Add a notifier mechanism to the low level idle loop.  You can register a
callback function which gets invoked on entry and exit from the low level idle
loop.  The low level idle loop is defined as the polling loop, low-power call,
or the mwait instruction.  Interrupts processed by the idle thread are not
considered part of the low level loop.

The notifier can be used to measure precisely how much is spent in useless
execution (or low power mode).  The perfmon subsystem uses it to turn on/off
monitoring.

Signed-off-by: stephane eranian <eranian@hpl.hp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/apic.c          |    4 ++
 arch/i386/kernel/cpu/mcheck/p4.c |    2 +
 arch/i386/kernel/irq.c           |    3 +
 arch/i386/kernel/process.c       |   54 ++++++++++++++++++++++++++++-
 arch/i386/kernel/smp.c           |    2 +
 include/asm-i386/idle.h          |   14 +++++++
 include/asm-i386/processor.h     |    8 ++++
 7 files changed, 86 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/apic.c~add-i386-idle-notifier-take-3 arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~add-i386-idle-notifier-take-3
+++ a/arch/i386/kernel/apic.c
@@ -36,6 +36,7 @@
 #include <asm/hpet.h>
 #include <asm/i8253.h>
 #include <asm/nmi.h>
+#include <asm/idle.h>
 
 #include <mach_apic.h>
 #include <mach_apicdef.h>
@@ -1255,6 +1256,7 @@ fastcall void smp_apic_timer_interrupt(s
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
+	exit_idle();
 	irq_enter();
 	smp_local_timer_interrupt();
 	irq_exit();
@@ -1305,6 +1307,7 @@ fastcall void smp_spurious_interrupt(str
 {
 	unsigned long v;
 
+	exit_idle();
 	irq_enter();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
@@ -1329,6 +1332,7 @@ fastcall void smp_error_interrupt(struct
 {
 	unsigned long v, v1;
 
+	exit_idle();
 	irq_enter();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v = apic_read(APIC_ESR);
diff -puN arch/i386/kernel/cpu/mcheck/p4.c~add-i386-idle-notifier-take-3 arch/i386/kernel/cpu/mcheck/p4.c
--- a/arch/i386/kernel/cpu/mcheck/p4.c~add-i386-idle-notifier-take-3
+++ a/arch/i386/kernel/cpu/mcheck/p4.c
@@ -12,6 +12,7 @@
 #include <asm/system.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
+#include <asm/idle.h>
 
 #include <asm/therm_throt.h>
 
@@ -59,6 +60,7 @@ static void (*vendor_thermal_interrupt)(
 
 fastcall void smp_thermal_interrupt(struct pt_regs *regs)
 {
+	exit_idle();
 	irq_enter();
 	vendor_thermal_interrupt(regs);
 	irq_exit();
diff -puN arch/i386/kernel/irq.c~add-i386-idle-notifier-take-3 arch/i386/kernel/irq.c
--- a/arch/i386/kernel/irq.c~add-i386-idle-notifier-take-3
+++ a/arch/i386/kernel/irq.c
@@ -19,6 +19,8 @@
 #include <linux/cpu.h>
 #include <linux/delay.h>
 
+#include <asm/idle.h>
+
 DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
 EXPORT_PER_CPU_SYMBOL(irq_stat);
 
@@ -61,6 +63,7 @@ fastcall unsigned int do_IRQ(struct pt_r
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp;
 #endif
+	exit_idle();
 
 	if (unlikely((unsigned)irq >= NR_IRQS)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
diff -puN arch/i386/kernel/process.c~add-i386-idle-notifier-take-3 arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~add-i386-idle-notifier-take-3
+++ a/arch/i386/kernel/process.c
@@ -48,6 +48,7 @@
 #include <asm/i387.h>
 #include <asm/desc.h>
 #include <asm/vm86.h>
+#include <asm/idle.h>
 #ifdef CONFIG_MATH_EMULATION
 #include <asm/math_emu.h>
 #endif
@@ -80,6 +81,43 @@ void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
 static DEFINE_PER_CPU(unsigned int, cpu_idle_state);
 
+static ATOMIC_NOTIFIER_HEAD(idle_notifier);
+
+void idle_notifier_register(struct notifier_block *n)
+{
+	atomic_notifier_chain_register(&idle_notifier, n);
+}
+EXPORT_SYMBOL_GPL(idle_notifier_register);
+
+void idle_notifier_unregister(struct notifier_block *n)
+{
+	atomic_notifier_chain_unregister(&idle_notifier, n);
+}
+EXPORT_SYMBOL(idle_notifier_unregister);
+
+static DEFINE_PER_CPU(volatile unsigned long, idle_state);
+
+void enter_idle(void)
+{
+	__get_cpu_var(idle_state) = 1;
+	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
+}
+
+static void __exit_idle(void)
+{
+	/* needs to be atomic w.r.t. interrupts, not against other CPUs */
+	if (__test_and_clear_bit(0, &__get_cpu_var(idle_state)) == 0)
+		return;
+	atomic_notifier_call_chain(&idle_notifier, IDLE_END, NULL);
+}
+
+void exit_idle(void)
+{
+	if (current->pid)
+		return;
+	__exit_idle();
+}
+
 void disable_hlt(void)
 {
 	hlt_counter++;
@@ -130,6 +168,7 @@ EXPORT_SYMBOL(default_idle);
  */
 static void poll_idle (void)
 {
+	local_irq_enable();
 	cpu_relax();
 }
 
@@ -189,7 +228,16 @@ void cpu_idle(void)
 				play_dead();
 
 			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
+
+			/*
+			 * Idle routines should keep interrupts disabled
+			 * from here on, until they go to idle.
+			 * Otherwise, idle callbacks can misfire.
+			 */
+			local_irq_disable();
+			enter_idle();
 			idle();
+			__exit_idle();
 		}
 		preempt_enable_no_resched();
 		schedule();
@@ -243,7 +291,11 @@ void mwait_idle_with_hints(unsigned long
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
-			__mwait(eax, ecx);
+			__sti_mwait(eax, ecx);
+		else
+			local_irq_enable();
+	} else {
+		local_irq_enable();
 	}
 }
 
diff -puN arch/i386/kernel/smp.c~add-i386-idle-notifier-take-3 arch/i386/kernel/smp.c
--- a/arch/i386/kernel/smp.c~add-i386-idle-notifier-take-3
+++ a/arch/i386/kernel/smp.c
@@ -23,6 +23,7 @@
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
+#include <asm/idle.h>
 #include <mach_apic.h>
 
 /*
@@ -624,6 +625,7 @@ fastcall void smp_call_function_interrup
 	/*
 	 * At this point the info structure may be out of scope unless wait==1
 	 */
+	exit_idle();
 	irq_enter();
 	(*func)(info);
 	irq_exit();
diff -puN /dev/null include/asm-i386/idle.h
--- /dev/null
+++ a/include/asm-i386/idle.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_I386_IDLE_H
+#define _ASM_I386_IDLE_H 1
+
+#define IDLE_START 1
+#define IDLE_END 2
+
+struct notifier_block;
+void idle_notifier_register(struct notifier_block *n);
+void idle_notifier_unregister(struct notifier_block *n);
+
+void exit_idle(void);
+void enter_idle(void);
+
+#endif
diff -puN include/asm-i386/processor.h~add-i386-idle-notifier-take-3 include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~add-i386-idle-notifier-take-3
+++ a/include/asm-i386/processor.h
@@ -257,6 +257,14 @@ static inline void __mwait(unsigned long
 		: :"a" (eax), "c" (ecx));
 }
 
+static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
+{
+	/* "mwait %eax,%ecx;" */
+	asm volatile(
+		"sti; .byte 0x0f,0x01,0xc9;"
+		: :"a" (eax), "c" (ecx));
+}
+
 extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
 
 /* from system description table in BIOS.  Mostly for MCA use, but
_

Patches currently in -mm which might be from eranian@hpl.hp.com are

add-i386-idle-notifier-take-3-fix.patch
