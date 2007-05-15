From: akpm@linux-foundation.org
Subject: - i386-fix-voyager-build.patch removed from -mm tree
Date: Tue, 15 May 2007 11:07:27 -0700
Message-ID: <200705151807.l4FI7Qcc014165@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755873AbXEOSIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 14:08:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, James.Bottomley@HansenPartnership.com, ak@suse.de, ebiederm@xmission.com, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     i386: fix voyager build
has been removed from the -mm tree.  Its filename was
     i386-fix-voyager-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: fix voyager build
From: Jeremy Fitzhardinge <jeremy@goop.org>

This adds an smp_ops for voyager, and hooks things up appropriately.  This is
the first baby-step to making subarch runtime switchable.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-voyager/voyager_smp.c |  106 +++++++++----------------
 1 file changed, 41 insertions(+), 65 deletions(-)

diff -puN arch/i386/mach-voyager/voyager_smp.c~i386-fix-voyager-build arch/i386/mach-voyager/voyager_smp.c
--- a/arch/i386/mach-voyager/voyager_smp.c~i386-fix-voyager-build
+++ a/arch/i386/mach-voyager/voyager_smp.c
@@ -27,7 +27,6 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/arch_hooks.h>
-#include <asm/pda.h>
 
 /* TLB state -- visible externally, indexed physically */
 DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate) ____cacheline_aligned = { &init_mm, 0 };
@@ -422,7 +421,7 @@ find_smp_config(void)
 	     VOYAGER_SUS_IN_CONTROL_PORT);
 
 	current_thread_info()->cpu = boot_cpu_id;
-	write_pda(cpu_number, boot_cpu_id);
+	x86_write_percpu(cpu_number, boot_cpu_id);
 }
 
 /*
@@ -435,7 +434,7 @@ smp_store_cpu_info(int id)
 
 	*c = boot_cpu_data;
 
-	identify_cpu(c);
+	identify_secondary_cpu(c);
 }
 
 /* set up the trampoline and return the physical address of the code */
@@ -459,7 +458,7 @@ start_secondary(void *unused)
 	/* external functions not defined in the headers */
 	extern void calibrate_delay(void);
 
-	secondary_cpu_init();
+	cpu_init();
 
 	/* OK, we're in the routine */
 	ack_CPI(VIC_CPU_BOOT_CPI);
@@ -572,7 +571,9 @@ do_boot_cpu(__u8 cpu)
 	/* init_tasks (in sched.c) is indexed logically */
 	stack_start.esp = (void *) idle->thread.esp;
 
-	init_gdt(cpu, idle);
+	init_gdt(cpu);
+ 	per_cpu(current_task, cpu) = idle;
+	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	irq_ctx_init(cpu);
 
 	/* Note: Don't modify initial ss override */
@@ -859,8 +860,8 @@ smp_invalidate_interrupt(void)
 
 /* This routine is called with a physical cpu mask */
 static void
-flush_tlb_others (unsigned long cpumask, struct mm_struct *mm,
-						unsigned long va)
+voyager_flush_tlb_others (unsigned long cpumask, struct mm_struct *mm,
+			  unsigned long va)
 {
 	int stuck = 50000;
 
@@ -912,7 +913,7 @@ flush_tlb_current_task(void)
 	cpu_mask = cpus_addr(mm->cpu_vm_mask)[0] & ~(1 << smp_processor_id());
 	local_flush_tlb();
 	if (cpu_mask)
-		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
+		voyager_flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
 
 	preempt_enable();
 }
@@ -934,7 +935,7 @@ flush_tlb_mm (struct mm_struct * mm)
 			leave_mm(smp_processor_id());
 	}
 	if (cpu_mask)
-		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
+		voyager_flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
 
 	preempt_enable();
 }
@@ -955,7 +956,7 @@ void flush_tlb_page(struct vm_area_struc
 	}
 
 	if (cpu_mask)
-		flush_tlb_others(cpu_mask, mm, va);
+		voyager_flush_tlb_others(cpu_mask, mm, va);
 
 	preempt_enable();
 }
@@ -1044,10 +1045,12 @@ smp_call_function_interrupt(void)
 }
 
 static int
-__smp_call_function_mask (void (*func) (void *info), void *info, int retry,
-			  int wait, __u32 mask)
+voyager_smp_call_function_mask (cpumask_t cpumask,
+				void (*func) (void *info), void *info,
+				int wait)
 {
 	struct call_data_struct data;
+	u32 mask = cpus_addr(cpumask)[0];
 
 	mask &= ~(1<<smp_processor_id());
 
@@ -1083,47 +1086,6 @@ __smp_call_function_mask (void (*func) (
 	return 0;
 }
 
-/* Call this function on all CPUs using the function_interrupt above
-    <func> The function to run. This must be fast and non-blocking.
-    <info> An arbitrary pointer to pass to the function.
-    <retry> If true, keep retrying until ready.
-    <wait> If true, wait until function has completed on other CPUs.
-    [RETURNS] 0 on success, else a negative status code. Does not return until
-    remote CPUs are nearly ready to execute <<func>> or are or have executed.
-*/
-int
-smp_call_function(void (*func) (void *info), void *info, int retry,
-		   int wait)
-{
-	__u32 mask = cpus_addr(cpu_online_map)[0];
-
-	return __smp_call_function_mask(func, info, retry, wait, mask);
-}
-EXPORT_SYMBOL(smp_call_function);
-
-/*
- * smp_call_function_single - Run a function on another CPU
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: Currently unused.
- * @wait: If true, wait until function has completed on other CPUs.
- *
- * Retrurns 0 on success, else a negative status code.
- *
- * Does not return until the remote CPU is nearly ready to execute <func>
- * or is or has executed.
- */
-
-int
-smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			 int nonatomic, int wait)
-{
-	__u32 mask = 1 << cpu;
-
-	return __smp_call_function_mask(func, info, nonatomic, wait, mask);
-}
-EXPORT_SYMBOL(smp_call_function_single);
-
 /* Sorry about the name.  In an APIC based system, the APICs
  * themselves are programmed to send a timer interrupt.  This is used
  * by linux to reschedule the processor.  Voyager doesn't have this,
@@ -1237,8 +1199,8 @@ smp_alloc_memory(void)
 }
 
 /* send a reschedule CPI to one CPU by physical CPU number*/
-void
-smp_send_reschedule(int cpu)
+static void
+voyager_smp_send_reschedule(int cpu)
 {
 	send_one_CPI(cpu, VIC_RESCHEDULE_CPI);
 }
@@ -1267,8 +1229,8 @@ safe_smp_processor_id(void)
 }
 
 /* broadcast a halt to all other CPUs */
-void
-smp_send_stop(void)
+static void
+voyager_smp_send_stop(void)
 {
 	smp_call_function(smp_stop_cpu_function, NULL, 1, 1);
 }
@@ -1930,23 +1892,26 @@ smp_voyager_power_off(void *dummy)
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
@@ -1962,8 +1927,8 @@ __cpu_up(unsigned int cpu)
 	return 0;
 }
 
-void __init 
-smp_cpus_done(unsigned int max_cpus)
+static void __init
+voyager_smp_cpus_done(unsigned int max_cpus)
 {
 	zap_low_mappings();
 }
@@ -1972,5 +1937,16 @@ void __init
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

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
x86-use-elfnoteh-to-generate-vsyscall-notes.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
add-kstrndup.patch
add-kstrndup-fix.patch
add-argv_split.patch
add-argv_split-fix.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
add-common-orderly_poweroff-fix.patch
tidy-up-usermode-helper-waiting-a-bit.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
lguest-the-guest-code.patch
