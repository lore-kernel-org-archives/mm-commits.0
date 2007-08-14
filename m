From: akpm@linux-foundation.org
Subject: - x86-expand-proc-interrupts-to-include-missing-vectors-v2.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:41 -0700
Message-ID: <200708141914.l7EJEfCg016640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49421 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933785AbXHNTVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe.korty@ccur.com, ak@suse.de, hpa@zytor.com, mingo@elte.hu, thockin@hockin.org, mm-commits@vger.kernel.org


The patch titled
     x86: expand /proc/interrupts to include missing vectors, v2
has been removed from the -mm tree.  Its filename was
     x86-expand-proc-interrupts-to-include-missing-vectors-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: expand /proc/interrupts to include missing vectors, v2
From: Joe Korty <joe.korty@ccur.com>

Add missing IRQs and IRQ descriptions to /proc/interrupts.

/proc/interrupts is most useful when it displays every IRQ vector in use by
the system, not just those somebody thought would be interesting.

This patch inserts the following vector displays to the i386 and x86_64
platforms, as appropriate:

	rescheduling interrupts
	TLB flush interrupts
	function call interrupts
	thermal event interrupts
	threshold interrupts
	spurious interrupts

A threshold interrupt occurs when ECC memory correction is occuring at too
high a frequency.  Thresholds are used by the ECC hardware as occasional
ECC failures are part of normal operation, but long sequences of ECC
failures usually indicate a memory chip that is about to fail.

Thermal event interrupts occur when a temperature threshold has been
exceeded for some CPU chip.  IIRC, a thermal interrupt is also generated
when the temperature drops back to a normal level.

A spurious interrupt is an interrupt that was raised then lowered by the
device before it could be fully processed by the APIC.  Hence the apic sees
the interrupt but does not know what device it came from.  For this case
the APIC hardware will assume a vector of 0xff.

Rescheduling, call, and TLB flush interrupts are sent from one CPU to
another per the needs of the OS.  Typically, their statistics would be used
to discover if an interrupt flood of the given type has been occuring.

Signed-off-by: Joe Korty <joe.korty@ccur.com>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c              |    1 
 arch/i386/kernel/cpu/mcheck/p4.c     |    1 
 arch/i386/kernel/irq.c               |   35 +++++++++++++++++++++++--
 arch/i386/kernel/smp.c               |    3 ++
 arch/i386/mach-voyager/voyager_smp.c |    1 
 arch/i386/xen/smp.c                  |    1 
 arch/x86_64/kernel/apic.c            |    2 +
 arch/x86_64/kernel/irq.c             |   34 ++++++++++++++++++++++--
 arch/x86_64/kernel/mce_amd.c         |    1 
 arch/x86_64/kernel/mce_intel.c       |    1 
 arch/x86_64/kernel/smp.c             |    3 ++
 include/asm-i386/hardirq.h           |    5 +++
 include/asm-x86_64/pda.h             |    6 ++++
 13 files changed, 90 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/apic.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2 arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2
+++ a/arch/i386/kernel/apic.c
@@ -1280,6 +1280,7 @@ void smp_spurious_interrupt(struct pt_re
 	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
 	       "should never happen.\n", smp_processor_id());
 	irq_exit();
+	__get_cpu_var(irq_stat).irq_spur_counts++;
 }
 
 /*
diff -puN arch/i386/kernel/cpu/mcheck/p4.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2 arch/i386/kernel/cpu/mcheck/p4.c
--- a/arch/i386/kernel/cpu/mcheck/p4.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2
+++ a/arch/i386/kernel/cpu/mcheck/p4.c
@@ -62,6 +62,7 @@ fastcall void smp_thermal_interrupt(stru
 	irq_enter();
 	vendor_thermal_interrupt(regs);
 	irq_exit();
+	__get_cpu_var(irq_stat).irq_thermal_counts++;
 }
 
 /* P4/Xeon Thermal regulation detect and init */
diff -puN arch/i386/kernel/irq.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2 arch/i386/kernel/irq.c
--- a/arch/i386/kernel/irq.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2
+++ a/arch/i386/kernel/irq.c
@@ -284,14 +284,45 @@ skip:
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", nmi_count(j));
-		seq_putc(p, '\n');
+		seq_printf(p, "  Non-maskable interrupts\n");
 #ifdef CONFIG_X86_LOCAL_APIC
 		seq_printf(p, "LOC: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ",
 				per_cpu(irq_stat,j).apic_timer_irqs);
-		seq_putc(p, '\n');
+		seq_printf(p, "  Local interrupts\n");
 #endif
+#ifdef CONFIG_SMP
+		seq_printf(p, "RES: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				per_cpu(irq_stat,j).irq_resched_counts);
+		seq_printf(p, "  Rescheduling interrupts\n");
+#endif
+#ifdef CONFIG_SMP
+		seq_printf(p, "CAL: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				per_cpu(irq_stat,j).irq_call_counts);
+		seq_printf(p, "  function call interrupts\n");
+#endif
+#ifdef CONFIG_SMP
+		seq_printf(p, "TLB: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				per_cpu(irq_stat,j).irq_tlb_counts);
+		seq_printf(p, "  TLB shootdowns\n");
+#endif
+		seq_printf(p, "TRM: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				per_cpu(irq_stat,j).irq_thermal_counts);
+		seq_printf(p, "  Thermal event interrupts\n");
+		seq_printf(p, "SPU: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				per_cpu(irq_stat,j).irq_spur_counts);
+		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
 		seq_printf(p, "MIS: %10u\n", atomic_read(&irq_mis_count));
diff -puN arch/i386/kernel/smp.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2 arch/i386/kernel/smp.c
--- a/arch/i386/kernel/smp.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2
+++ a/arch/i386/kernel/smp.c
@@ -342,6 +342,7 @@ fastcall void smp_invalidate_interrupt(s
 	smp_mb__after_clear_bit();
 out:
 	put_cpu_no_resched();
+	__get_cpu_var(irq_stat).irq_tlb_counts++;
 }
 
 void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
@@ -640,6 +641,7 @@ static void native_smp_send_stop(void)
 fastcall void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
+	__get_cpu_var(irq_stat).irq_resched_counts++;
 }
 
 fastcall void smp_call_function_interrupt(struct pt_regs *regs)
@@ -666,6 +668,7 @@ fastcall void smp_call_function_interrup
 		mb();
 		atomic_inc(&call_data->finished);
 	}
+	__get_cpu_var(irq_stat).irq_call_counts++;
 }
 
 static int convert_apicid_to_cpu(int apic_id)
diff -puN arch/i386/mach-voyager/voyager_smp.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2 arch/i386/mach-voyager/voyager_smp.c
--- a/arch/i386/mach-voyager/voyager_smp.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2
+++ a/arch/i386/mach-voyager/voyager_smp.c
@@ -1042,6 +1042,7 @@ smp_call_function_interrupt(void)
 		mb();
 		clear_bit(cpu, &call_data->finished);
 	}
+	__get_cpu_var(irq_stat).irq_call_counts++;
 }
 
 static int
diff -puN arch/i386/xen/smp.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2 arch/i386/xen/smp.c
--- a/arch/i386/xen/smp.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2
+++ a/arch/i386/xen/smp.c
@@ -352,6 +352,7 @@ static irqreturn_t xen_call_function_int
 		mb();		/* commit everything before setting finished */
 		atomic_inc(&call_data->finished);
 	}
+	__get_cpu_var(irq_stat).irq_call_counts++;
 
 	return IRQ_HANDLED;
 }
diff -puN arch/x86_64/kernel/apic.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2 arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2
+++ a/arch/x86_64/kernel/apic.c
@@ -1139,6 +1139,7 @@ __cpuinit int apic_is_clustered_box(void
 asmlinkage void smp_spurious_interrupt(void)
 {
 	unsigned int v;
+
 	exit_idle();
 	irq_enter();
 	/*
@@ -1151,6 +1152,7 @@ asmlinkage void smp_spurious_interrupt(v
 		ack_APIC_irq();
 
 	irq_exit();
+	add_pda(irq_spur_counts, 1);
 }
 
 /*
diff -puN arch/x86_64/kernel/irq.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2 arch/x86_64/kernel/irq.c
--- a/arch/x86_64/kernel/irq.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2
+++ a/arch/x86_64/kernel/irq.c
@@ -88,11 +88,41 @@ skip:
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->__nmi_count);
-		seq_putc(p, '\n');
+		seq_printf(p, "  Non-maskable interrupts\n");
 		seq_printf(p, "LOC: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->apic_timer_irqs);
-		seq_putc(p, '\n');
+		seq_printf(p, "  Local interrupts\n");
+#ifdef CONFIG_SMP
+		seq_printf(p, "RES: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_resched_counts);
+		seq_printf(p, "  Rescheduling interrupts\n");
+#endif
+#ifdef CONFIG_SMP
+		seq_printf(p, "CAL: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_call_counts);
+		seq_printf(p, "  function call interrupts\n");
+#endif
+#ifdef CONFIG_SMP
+		seq_printf(p, "TLB: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_tlb_counts);
+		seq_printf(p, "  TLB shootdowns\n");
+#endif
+		seq_printf(p, "TRM: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_thermal_counts);
+		seq_printf(p, "  Thermal event interrupts\n");
+		seq_printf(p, "THR: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_threshold_counts);
+		seq_printf(p, "  Threshold APIC interrupts\n");
+		seq_printf(p, "SPU: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_spur_counts);
+		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 	}
 	return 0;
diff -puN arch/x86_64/kernel/mce_amd.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2 arch/x86_64/kernel/mce_amd.c
--- a/arch/x86_64/kernel/mce_amd.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2
+++ a/arch/x86_64/kernel/mce_amd.c
@@ -238,6 +238,7 @@ asmlinkage void mce_threshold_interrupt(
 	}
 out:
 	irq_exit();
+	add_pda(irq_threshold_counts, 1);
 }
 
 /*
diff -puN arch/x86_64/kernel/mce_intel.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2 arch/x86_64/kernel/mce_intel.c
--- a/arch/x86_64/kernel/mce_intel.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2
+++ a/arch/x86_64/kernel/mce_intel.c
@@ -27,6 +27,7 @@ asmlinkage void smp_thermal_interrupt(vo
 		mce_log_therm_throt_event(smp_processor_id(), msr_val);
 
 	irq_exit();
+	add_pda(irq_thermal_counts, 1);
 }
 
 static void __cpuinit intel_init_thermal(struct cpuinfo_x86 *c)
diff -puN arch/x86_64/kernel/smp.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2 arch/x86_64/kernel/smp.c
--- a/arch/x86_64/kernel/smp.c~x86-expand-proc-interrupts-to-include-missing-vectors-v2
+++ a/arch/x86_64/kernel/smp.c
@@ -163,6 +163,7 @@ asmlinkage void smp_invalidate_interrupt
 out:
 	ack_APIC_irq();
 	cpu_clear(cpu, f->flush_cpumask);
+	add_pda(irq_tlb_counts, 1);
 }
 
 static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
@@ -493,6 +494,7 @@ void smp_send_stop(void)
 asmlinkage void smp_reschedule_interrupt(void)
 {
 	ack_APIC_irq();
+	add_pda(irq_resched_counts, 1);
 }
 
 asmlinkage void smp_call_function_interrupt(void)
@@ -519,5 +521,6 @@ asmlinkage void smp_call_function_interr
 		mb();
 		atomic_inc(&call_data->finished);
 	}
+	add_pda(irq_call_counts, 1);
 }
 
diff -puN include/asm-i386/hardirq.h~x86-expand-proc-interrupts-to-include-missing-vectors-v2 include/asm-i386/hardirq.h
--- a/include/asm-i386/hardirq.h~x86-expand-proc-interrupts-to-include-missing-vectors-v2
+++ a/include/asm-i386/hardirq.h
@@ -9,6 +9,11 @@ typedef struct {
 	unsigned long idle_timestamp;
 	unsigned int __nmi_count;	/* arch dependent */
 	unsigned int apic_timer_irqs;	/* arch dependent */
+	unsigned int irq_resched_counts;
+	unsigned int irq_call_counts;
+	unsigned int irq_tlb_counts;
+	unsigned int irq_thermal_counts;
+	unsigned int irq_spur_counts;
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
diff -puN include/asm-x86_64/pda.h~x86-expand-proc-interrupts-to-include-missing-vectors-v2 include/asm-x86_64/pda.h
--- a/include/asm-x86_64/pda.h~x86-expand-proc-interrupts-to-include-missing-vectors-v2
+++ a/include/asm-x86_64/pda.h
@@ -29,6 +29,12 @@ struct x8664_pda {
 	short isidle;
 	struct mm_struct *active_mm;
 	unsigned apic_timer_irqs;
+	unsigned irq_resched_counts;
+	unsigned irq_call_counts;
+	unsigned irq_tlb_counts;
+	unsigned irq_thermal_counts;
+	unsigned irq_threshold_counts;
+	unsigned irq_spur_counts;
 } ____cacheline_aligned_in_smp;
 
 extern struct x8664_pda *_cpu_pda[];
_

Patches currently in -mm which might be from joe.korty@ccur.com are
