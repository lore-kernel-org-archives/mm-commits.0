From: akpm@linux-foundation.org
Subject: - x86-expand-proc-interrupts-to-include-missing-vectors.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:46 -0700
Message-ID: <200708141914.l7EJEkmg016648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932214AbXHNTUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe.korty@ccur.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86: expand /proc/interrupts to include missing vectors: v4
has been removed from the -mm tree.  Its filename was
     x86-expand-proc-interrupts-to-include-missing-vectors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: expand /proc/interrupts to include missing vectors: v4
From: Joe Korty <joe.korty@ccur.com>

    s/irq_spur_counts/irq_spurious_counts/g (Andrew Morton)
    tweaked documentation (Andi Kleen)
    moved increments before irq_exit as appropriate (Andi Kleen)
    whitespace cleanup (Andi Kleen)

Signed-off-by: Joe Korty <joe.korty@ccur.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt   |   13 ++++++++-----
 arch/i386/kernel/apic.c              |    2 +-
 arch/i386/kernel/cpu/mcheck/p4.c     |    2 +-
 arch/i386/kernel/irq.c               |    2 +-
 arch/i386/kernel/smp.c               |    2 +-
 arch/i386/mach-voyager/voyager_smp.c |    2 +-
 arch/i386/xen/smp.c                  |    2 +-
 arch/x86_64/kernel/apic.c            |    3 +--
 arch/x86_64/kernel/irq.c             |    2 +-
 arch/x86_64/kernel/mce_amd.c         |    2 +-
 arch/x86_64/kernel/mce_intel.c       |    2 +-
 arch/x86_64/kernel/smp.c             |    2 +-
 include/asm-i386/hardirq.h           |    2 +-
 include/asm-x86_64/pda.h             |    2 +-
 14 files changed, 21 insertions(+), 19 deletions(-)

diff -puN Documentation/filesystems/proc.txt~x86-expand-proc-interrupts-to-include-missing-vectors Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/Documentation/filesystems/proc.txt
@@ -351,11 +351,14 @@ In 2.6.2* /proc/interrupts was expanded 
 /proc/interrupts to display every IRQ vector in use by the system, not
 just those considered 'most important'.  The new vectors are:
 
-  THR -- a threshold interrupt occurs when ECC memory correction is
-  occuring at too high a frequency.  Threshold interrupt machinery is
-  often put into the ECC logic, as occasional ECC memory failures are
-  part of normal memory operation, but sequences of ECC failures over
-  some short interval usually indicate a memory chip that is about to fail.
+  THR -- a threshold interrupt occurs when ECC memory correction is occuring
+  at too high a frequency.  Threshold interrupt machinery is often put
+  into the ECC logic, as occasional ECC memory corrections are part of
+  normal operation (due to random alpha particles), but sequences of
+  ECC corrections or outright failures over some short interval usually
+  indicate a memory chip that is about to fail.  Note that not every
+  platform has ECC threshold logic, and those that do generally require
+  it to be explicitly turned on.
 
   TRM -- a thermal event interrupt occurs when a temperature threshold
   has been exceeded for some CPU chip.  This interrupt may also be generated
diff -puN arch/i386/kernel/apic.c~x86-expand-proc-interrupts-to-include-missing-vectors arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/arch/i386/kernel/apic.c
@@ -1279,8 +1279,8 @@ void smp_spurious_interrupt(struct pt_re
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
 	       "should never happen.\n", smp_processor_id());
+	__get_cpu_var(irq_stat).irq_spurious_counts++;
 	irq_exit();
-	__get_cpu_var(irq_stat).irq_spur_counts++;
 }
 
 /*
diff -puN arch/i386/kernel/cpu/mcheck/p4.c~x86-expand-proc-interrupts-to-include-missing-vectors arch/i386/kernel/cpu/mcheck/p4.c
--- a/arch/i386/kernel/cpu/mcheck/p4.c~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/arch/i386/kernel/cpu/mcheck/p4.c
@@ -61,8 +61,8 @@ fastcall void smp_thermal_interrupt(stru
 {
 	irq_enter();
 	vendor_thermal_interrupt(regs);
-	irq_exit();
 	__get_cpu_var(irq_stat).irq_thermal_counts++;
+	irq_exit();
 }
 
 /* P4/Xeon Thermal regulation detect and init */
diff -puN arch/i386/kernel/irq.c~x86-expand-proc-interrupts-to-include-missing-vectors arch/i386/kernel/irq.c
--- a/arch/i386/kernel/irq.c~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/arch/i386/kernel/irq.c
@@ -317,7 +317,7 @@ skip:
 		seq_printf(p, "SPU: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ",
-				per_cpu(irq_stat,j).irq_spur_counts);
+				per_cpu(irq_stat,j).irq_spurious_counts);
 		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
diff -puN arch/i386/kernel/smp.c~x86-expand-proc-interrupts-to-include-missing-vectors arch/i386/kernel/smp.c
--- a/arch/i386/kernel/smp.c~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/arch/i386/kernel/smp.c
@@ -662,13 +662,13 @@ fastcall void smp_call_function_interrup
 	 */
 	irq_enter();
 	(*func)(info);
+	__get_cpu_var(irq_stat).irq_call_counts++;
 	irq_exit();
 
 	if (wait) {
 		mb();
 		atomic_inc(&call_data->finished);
 	}
-	__get_cpu_var(irq_stat).irq_call_counts++;
 }
 
 static int convert_apicid_to_cpu(int apic_id)
diff -puN arch/i386/mach-voyager/voyager_smp.c~x86-expand-proc-interrupts-to-include-missing-vectors arch/i386/mach-voyager/voyager_smp.c
--- a/arch/i386/mach-voyager/voyager_smp.c~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/arch/i386/mach-voyager/voyager_smp.c
@@ -1037,12 +1037,12 @@ smp_call_function_interrupt(void)
 	 */
 	irq_enter();
 	(*func)(info);
+	__get_cpu_var(irq_stat).irq_call_counts++;
 	irq_exit();
 	if (wait) {
 		mb();
 		clear_bit(cpu, &call_data->finished);
 	}
-	__get_cpu_var(irq_stat).irq_call_counts++;
 }
 
 static int
diff -puN arch/i386/xen/smp.c~x86-expand-proc-interrupts-to-include-missing-vectors arch/i386/xen/smp.c
--- a/arch/i386/xen/smp.c~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/arch/i386/xen/smp.c
@@ -346,13 +346,13 @@ static irqreturn_t xen_call_function_int
 	 */
 	irq_enter();
 	(*func)(info);
+	__get_cpu_var(irq_stat).irq_call_counts++;
 	irq_exit();
 
 	if (wait) {
 		mb();		/* commit everything before setting finished */
 		atomic_inc(&call_data->finished);
 	}
-	__get_cpu_var(irq_stat).irq_call_counts++;
 
 	return IRQ_HANDLED;
 }
diff -puN arch/x86_64/kernel/apic.c~x86-expand-proc-interrupts-to-include-missing-vectors arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/arch/x86_64/kernel/apic.c
@@ -1139,7 +1139,6 @@ __cpuinit int apic_is_clustered_box(void
 asmlinkage void smp_spurious_interrupt(void)
 {
 	unsigned int v;
-
 	exit_idle();
 	irq_enter();
 	/*
@@ -1151,8 +1150,8 @@ asmlinkage void smp_spurious_interrupt(v
 	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
 		ack_APIC_irq();
 
+	add_pda(irq_spurious_counts, 1);
 	irq_exit();
-	add_pda(irq_spur_counts, 1);
 }
 
 /*
diff -puN arch/x86_64/kernel/irq.c~x86-expand-proc-interrupts-to-include-missing-vectors arch/x86_64/kernel/irq.c
--- a/arch/x86_64/kernel/irq.c~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/arch/x86_64/kernel/irq.c
@@ -117,7 +117,7 @@ skip:
 		seq_printf(p, "  Threshold APIC interrupts\n");
 		seq_printf(p, "SPU: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_spur_counts);
+			seq_printf(p, "%10u ", cpu_pda(j)->irq_spurious_counts);
 		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 	}
diff -puN arch/x86_64/kernel/mce_amd.c~x86-expand-proc-interrupts-to-include-missing-vectors arch/x86_64/kernel/mce_amd.c
--- a/arch/x86_64/kernel/mce_amd.c~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/arch/x86_64/kernel/mce_amd.c
@@ -237,8 +237,8 @@ asmlinkage void mce_threshold_interrupt(
 		}
 	}
 out:
-	irq_exit();
 	add_pda(irq_threshold_counts, 1);
+	irq_exit();
 }
 
 /*
diff -puN arch/x86_64/kernel/mce_intel.c~x86-expand-proc-interrupts-to-include-missing-vectors arch/x86_64/kernel/mce_intel.c
--- a/arch/x86_64/kernel/mce_intel.c~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/arch/x86_64/kernel/mce_intel.c
@@ -26,8 +26,8 @@ asmlinkage void smp_thermal_interrupt(vo
 	if (therm_throt_process(msr_val & 1))
 		mce_log_therm_throt_event(smp_processor_id(), msr_val);
 
-	irq_exit();
 	add_pda(irq_thermal_counts, 1);
+	irq_exit();
 }
 
 static void __cpuinit intel_init_thermal(struct cpuinfo_x86 *c)
diff -puN arch/x86_64/kernel/smp.c~x86-expand-proc-interrupts-to-include-missing-vectors arch/x86_64/kernel/smp.c
--- a/arch/x86_64/kernel/smp.c~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/arch/x86_64/kernel/smp.c
@@ -516,11 +516,11 @@ asmlinkage void smp_call_function_interr
 	exit_idle();
 	irq_enter();
 	(*func)(info);
+	add_pda(irq_call_counts, 1);
 	irq_exit();
 	if (wait) {
 		mb();
 		atomic_inc(&call_data->finished);
 	}
-	add_pda(irq_call_counts, 1);
 }
 
diff -puN include/asm-i386/hardirq.h~x86-expand-proc-interrupts-to-include-missing-vectors include/asm-i386/hardirq.h
--- a/include/asm-i386/hardirq.h~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/include/asm-i386/hardirq.h
@@ -13,7 +13,7 @@ typedef struct {
 	unsigned int irq_call_counts;
 	unsigned int irq_tlb_counts;
 	unsigned int irq_thermal_counts;
-	unsigned int irq_spur_counts;
+	unsigned int irq_spurious_counts;
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
diff -puN include/asm-x86_64/pda.h~x86-expand-proc-interrupts-to-include-missing-vectors include/asm-x86_64/pda.h
--- a/include/asm-x86_64/pda.h~x86-expand-proc-interrupts-to-include-missing-vectors
+++ a/include/asm-x86_64/pda.h
@@ -34,7 +34,7 @@ struct x8664_pda {
 	unsigned irq_tlb_counts;
 	unsigned irq_thermal_counts;
 	unsigned irq_threshold_counts;
-	unsigned irq_spur_counts;
+	unsigned irq_spurious_counts;
 } ____cacheline_aligned_in_smp;
 
 extern struct x8664_pda *_cpu_pda[];
_

Patches currently in -mm which might be from joe.korty@ccur.com are
