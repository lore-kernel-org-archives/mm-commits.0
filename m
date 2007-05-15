From: akpm@linux-foundation.org
Subject: - voyager-fix-build-broken-by-shift-to-smp_ops.patch removed from -mm tree
Date: Mon, 14 May 2007 22:39:06 -0700
Message-ID: <200705150539.l4F5d5gh002426@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756438AbXEOFjM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 01:39:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@xensource.com, James.Bottomley@HansenPartnership.com, ak@suse.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     voyager: fix build broken by shift to smp_ops
has been removed from the -mm tree.  Its filename was
     voyager-fix-build-broken-by-shift-to-smp_ops.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: voyager: fix build broken by shift to smp_ops
From: Jeremy Fitzhardinge <jeremy@xensource.com>

This adds an smp_ops for voyager, and hooks things up appropriately.
This is the first baby-step to making subarch runtime switchable.

Rediffed to work in the absence of the smp consolidation patch

Following conversations with Andi, we've agreed that the best way to fix
the currently broken voyager port is to do a local fix converting it to
SMP operations, and then fix the invalid conversions in generic x86 by
re abstracting the operations so they (and several other functions) can
be shared between x86.

With this, voyager builds and boots on 2.6.22-rc1.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-voyager/voyager_smp.c |   99 +++++++++++++++++--------
 1 files changed, 69 insertions(+), 30 deletions(-)

diff -puN arch/i386/mach-voyager/voyager_smp.c~voyager-fix-build-broken-by-shift-to-smp_ops arch/i386/mach-voyager/voyager_smp.c
--- a/arch/i386/mach-voyager/voyager_smp.c~voyager-fix-build-broken-by-shift-to-smp_ops
+++ a/arch/i386/mach-voyager/voyager_smp.c
@@ -27,7 +27,6 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/arch_hooks.h>
-#include <asm/pda.h>
 
 /* TLB state -- visible externally, indexed physically */
 DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate) ____cacheline_aligned = { &init_mm, 0 };
@@ -40,6 +39,9 @@ static unsigned long cpu_irq_affinity[NR
 struct cpuinfo_x86 cpu_data[NR_CPUS] __cacheline_aligned;
 EXPORT_SYMBOL(cpu_data);
 
+DEFINE_PER_CPU(unsigned long, this_cpu_off);
+EXPORT_PER_CPU_SYMBOL(this_cpu_off);
+
 /* physical ID of the CPU used to boot the system */
 unsigned char boot_cpu_id;
 
@@ -202,6 +204,28 @@ ack_CPI(__u8 cpi)
 
 /* local variables */
 
+/* FIXME: this is a local copy of this function cut and paste from
+ * ../kernel/smpboot.c ... these need to be consolidated properly.
+ *
+ * Initialize the CPU's GDT.  This is either the boot CPU doing itself
+ * (still using the master per-cpu area), or a CPU doing it for a
+ * secondary which will soon come up. */
+static __devinit void init_gdt(int cpu)
+{
+	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
+
+	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
+			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
+			__per_cpu_offset[cpu], 0xFFFFF,
+			0x80 | DESCTYPE_S | 0x2, 0x8);
+
+	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
+	per_cpu(cpu_number, cpu) = cpu;
+}
+/* Defined in head.S */
+extern struct Xgt_desc_struct early_gdt_descr;
+/* end of FIXME */
+
 /* The VIC IRQ descriptors -- these look almost identical to the
  * 8259 IRQs except that masks and things must be kept per processor
  */
@@ -422,7 +446,7 @@ find_smp_config(void)
 	     VOYAGER_SUS_IN_CONTROL_PORT);
 
 	current_thread_info()->cpu = boot_cpu_id;
-	write_pda(cpu_number, boot_cpu_id);
+	x86_write_percpu(cpu_number, boot_cpu_id);
 }
 
 /*
@@ -435,7 +459,7 @@ smp_store_cpu_info(int id)
 
 	*c = boot_cpu_data;
 
-	identify_cpu(c);
+	identify_secondary_cpu(c);
 }
 
 /* set up the trampoline and return the physical address of the code */
@@ -459,7 +483,7 @@ start_secondary(void *unused)
 	/* external functions not defined in the headers */
 	extern void calibrate_delay(void);
 
-	secondary_cpu_init();
+	cpu_init();
 
 	/* OK, we're in the routine */
 	ack_CPI(VIC_CPU_BOOT_CPI);
@@ -572,7 +596,9 @@ do_boot_cpu(__u8 cpu)
 	/* init_tasks (in sched.c) is indexed logically */
 	stack_start.esp = (void *) idle->thread.esp;
 
-	init_gdt(cpu, idle);
+	init_gdt(cpu);
+ 	per_cpu(current_task, cpu) = idle;
+	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	irq_ctx_init(cpu);
 
 	/* Note: Don't modify initial ss override */
@@ -859,8 +885,8 @@ smp_invalidate_interrupt(void)
 
 /* This routine is called with a physical cpu mask */
 static void
-flush_tlb_others (unsigned long cpumask, struct mm_struct *mm,
-						unsigned long va)
+voyager_flush_tlb_others (unsigned long cpumask, struct mm_struct *mm,
+			  unsigned long va)
 {
 	int stuck = 50000;
 
@@ -912,7 +938,7 @@ flush_tlb_current_task(void)
 	cpu_mask = cpus_addr(mm->cpu_vm_mask)[0] & ~(1 << smp_processor_id());
 	local_flush_tlb();
 	if (cpu_mask)
-		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
+		voyager_flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
 
 	preempt_enable();
 }
@@ -934,7 +960,7 @@ flush_tlb_mm (struct mm_struct * mm)
 			leave_mm(smp_processor_id());
 	}
 	if (cpu_mask)
-		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
+		voyager_flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
 
 	preempt_enable();
 }
@@ -955,7 +981,7 @@ void flush_tlb_page(struct vm_area_struc
 	}
 
 	if (cpu_mask)
-		flush_tlb_others(cpu_mask, mm, va);
+		voyager_flush_tlb_others(cpu_mask, mm, va);
 
 	preempt_enable();
 }
@@ -1044,11 +1070,12 @@ smp_call_function_interrupt(void)
 }
 
 static int
-__smp_call_function_mask (void (*func) (void *info), void *info, int retry,
-			  int wait, __u32 mask)
+voyager_smp_call_function_mask (cpumask_t cpumask, void (*func) (void *info),
+				void *info, int wait)
 {
 	struct call_data_struct data;
 
+	u32 mask = cpus_addr(cpumask)[0];
 	mask &= ~(1<<smp_processor_id());
 
 	if (!mask)
@@ -1095,9 +1122,7 @@ int
 smp_call_function(void (*func) (void *info), void *info, int retry,
 		   int wait)
 {
-	__u32 mask = cpus_addr(cpu_online_map)[0];
-
-	return __smp_call_function_mask(func, info, retry, wait, mask);
+	return smp_call_function_mask(cpu_online_map, func, info, wait);
 }
 EXPORT_SYMBOL(smp_call_function);
 
@@ -1118,9 +1143,9 @@ int
 smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			 int nonatomic, int wait)
 {
-	__u32 mask = 1 << cpu;
+	cpumask_t mask = cpumask_of_cpu(cpu);
 
-	return __smp_call_function_mask(func, info, nonatomic, wait, mask);
+	return smp_call_function_mask(mask, func, info, wait);
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
@@ -1138,7 +1163,7 @@ EXPORT_SYMBOL(smp_call_function_single);
  * no local APIC, so I can't do this
  *
  * This function is currently a placeholder and is unused in the code */
-fastcall void 
+fastcall void
 smp_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
@@ -1237,8 +1262,8 @@ smp_alloc_memory(void)
 }
 
 /* send a reschedule CPI to one CPU by physical CPU number*/
-void
-smp_send_reschedule(int cpu)
+static void
+voyager_smp_send_reschedule(int cpu)
 {
 	send_one_CPI(cpu, VIC_RESCHEDULE_CPI);
 }
@@ -1267,8 +1292,8 @@ safe_smp_processor_id(void)
 }
 
 /* broadcast a halt to all other CPUs */
-void
-smp_send_stop(void)
+static void
+voyager_smp_send_stop(void)
 {
 	smp_call_function(smp_stop_cpu_function, NULL, 1, 1);
 }
@@ -1930,23 +1955,26 @@ smp_voyager_power_off(void *dummy)
 		smp_stop_cpu_function(NULL);
 }
 
-void __init
-smp_prepare_cpus(unsigned int max_cpus)
+static void __init
+voyager_smp_prepare_cpus(unsigned int max_cpus)
 {
 	/* FIXME: ignore max_cpus for now */
 	smp_boot_cpus();
 }
 
-void __devinit smp_prepare_boot_cpu(void)
+static void __devinit voyager_smp_prepare_boot_cpu(void)
 {
+	init_gdt(smp_processor_id());
+	switch_to_new_gdt();
+
 	cpu_set(smp_processor_id(), cpu_online_map);
 	cpu_set(smp_processor_id(), cpu_callout_map);
 	cpu_set(smp_processor_id(), cpu_possible_map);
 	cpu_set(smp_processor_id(), cpu_present_map);
 }
 
-int __devinit
-__cpu_up(unsigned int cpu)
+static int __devinit
+voyager_cpu_up(unsigned int cpu)
 {
 	/* This only works at boot for x86.  See "rewrite" above. */
 	if (cpu_isset(cpu, smp_commenced_mask))
@@ -1962,8 +1990,8 @@ __cpu_up(unsigned int cpu)
 	return 0;
 }
 
-void __init 
-smp_cpus_done(unsigned int max_cpus)
+static void __init
+voyager_smp_cpus_done(unsigned int max_cpus)
 {
 	zap_low_mappings();
 }
@@ -1972,5 +2000,16 @@ void __init
 smp_setup_processor_id(void)
 {
 	current_thread_info()->cpu = hard_smp_processor_id();
-	write_pda(cpu_number, hard_smp_processor_id());
+	x86_write_percpu(cpu_number, hard_smp_processor_id());
 }
+
+struct smp_ops smp_ops = {
+	.smp_prepare_boot_cpu = voyager_smp_prepare_boot_cpu,
+	.smp_prepare_cpus = voyager_smp_prepare_cpus,
+	.cpu_up = voyager_cpu_up,
+	.smp_cpus_done = voyager_smp_cpus_done,
+
+	.smp_send_stop = voyager_smp_send_stop,
+	.smp_send_reschedule = voyager_smp_send_reschedule,
+	.smp_call_function_mask = voyager_smp_call_function_mask,
+};
_

Patches currently in -mm which might be from jeremy@xensource.com are

i386-move-common-parts-of-smp-into-their-own-file.patch
i386-fix-voyager-build.patch
voyager-fix-build-broken-by-shift-to-smp_ops.patch
x86-use-elfnoteh-to-generate-vsyscall-notes.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
add-kstrndup.patch
add-kstrndup-fix.patch
add-argv_split.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
tidy-up-usermode-helper-waiting-a-bit.patch
