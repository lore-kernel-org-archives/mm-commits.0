From: akpm@linux-foundation.org
Subject: [merged] m32r-convert-cpumask-api.patch removed from -mm tree
Date: Fri, 27 May 2011 12:56:51 -0700
Message-ID: <201105271954.p4RJsupU017383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab1E0Tzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: convert cpumask api
has been removed from the -mm tree.  Its filename was
     m32r-convert-cpumask-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r: convert cpumask api
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

We plan to remove cpus_xx() old cpumask APIs later.  Also, we plan to
change mm_cpu_mask() implementation, allocate only nr_cpu_ids, thus
*mm_cpu_mask() is dangerous operation.

Then, this patch convert them.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/smp.h |    4 +-
 arch/m32r/kernel/smp.c      |   51 ++++++++++++++++------------------
 arch/m32r/kernel/smpboot.c  |   48 ++++++++++++++++----------------
 3 files changed, 51 insertions(+), 52 deletions(-)

diff -puN arch/m32r/include/asm/smp.h~m32r-convert-cpumask-api arch/m32r/include/asm/smp.h
--- a/arch/m32r/include/asm/smp.h~m32r-convert-cpumask-api
+++ a/arch/m32r/include/asm/smp.h
@@ -81,11 +81,11 @@ static __inline__ int cpu_number_map(int
 
 static __inline__ unsigned int num_booting_cpus(void)
 {
-	return cpus_weight(cpu_callout_map);
+	return cpumask_weight(&cpu_callout_map);
 }
 
 extern void smp_send_timer(void);
-extern unsigned long send_IPI_mask_phys(cpumask_t, int, int);
+extern unsigned long send_IPI_mask_phys(const cpumask_t*, int, int);
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
diff -puN arch/m32r/kernel/smp.c~m32r-convert-cpumask-api arch/m32r/kernel/smp.c
--- a/arch/m32r/kernel/smp.c~m32r-convert-cpumask-api
+++ a/arch/m32r/kernel/smp.c
@@ -87,7 +87,6 @@ void smp_local_timer_interrupt(void);
 
 static void send_IPI_allbutself(int, int);
 static void send_IPI_mask(const struct cpumask *, int, int);
-unsigned long send_IPI_mask_phys(cpumask_t, int, int);
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 /* Rescheduling request Routines                                             */
@@ -162,10 +161,10 @@ void smp_flush_cache_all(void)
 	unsigned long *mask;
 
 	preempt_disable();
-	cpumask = cpu_online_map;
-	cpu_clear(smp_processor_id(), cpumask);
+	cpumask_copy(&cpumask, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), &cpumask);
 	spin_lock(&flushcache_lock);
-	mask=cpus_addr(cpumask);
+	mask=cpumask_bits(&cpumask);
 	atomic_set_mask(*mask, (atomic_t *)&flushcache_cpumask);
 	send_IPI_mask(&cpumask, INVALIDATE_CACHE_IPI, 0);
 	_flush_cache_copyback_all();
@@ -263,8 +262,8 @@ void smp_flush_tlb_mm(struct mm_struct *
 	preempt_disable();
 	cpu_id = smp_processor_id();
 	mmc = &mm->context[cpu_id];
-	cpu_mask = *mm_cpumask(mm);
-	cpu_clear(cpu_id, cpu_mask);
+	cpumask_copy(&cpu_mask, mm_cpumask(mm));
+	cpumask_clear_cpu(cpu_id, &cpu_mask);
 
 	if (*mmc != NO_CONTEXT) {
 		local_irq_save(flags);
@@ -275,7 +274,7 @@ void smp_flush_tlb_mm(struct mm_struct *
 			cpumask_clear_cpu(cpu_id, mm_cpumask(mm));
 		local_irq_restore(flags);
 	}
-	if (!cpus_empty(cpu_mask))
+	if (!cpumask_empty(&cpu_mask))
 		flush_tlb_others(cpu_mask, mm, NULL, FLUSH_ALL);
 
 	preempt_enable();
@@ -333,8 +332,8 @@ void smp_flush_tlb_page(struct vm_area_s
 	preempt_disable();
 	cpu_id = smp_processor_id();
 	mmc = &mm->context[cpu_id];
-	cpu_mask = *mm_cpumask(mm);
-	cpu_clear(cpu_id, cpu_mask);
+	cpumask_copy(&cpu_mask, mm_cpumask(mm));
+	cpumask_clear_cpu(cpu_id, &cpu_mask);
 
 #ifdef DEBUG_SMP
 	if (!mm)
@@ -348,7 +347,7 @@ void smp_flush_tlb_page(struct vm_area_s
 		__flush_tlb_page(va);
 		local_irq_restore(flags);
 	}
-	if (!cpus_empty(cpu_mask))
+	if (!cpumask_empty(&cpu_mask))
 		flush_tlb_others(cpu_mask, mm, vma, va);
 
 	preempt_enable();
@@ -395,14 +394,14 @@ static void flush_tlb_others(cpumask_t c
 	 * - current CPU must not be in mask
 	 * - mask must exist :)
 	 */
-	BUG_ON(cpus_empty(cpumask));
+	BUG_ON(cpumask_empty(&cpumask));
 
-	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
+	BUG_ON(cpumask_test_cpu(smp_processor_id(), &cpumask));
 	BUG_ON(!mm);
 
 	/* If a CPU which we ran on has gone down, OK. */
-	cpus_and(cpumask, cpumask, cpu_online_map);
-	if (cpus_empty(cpumask))
+	cpumask_and(&cpumask, &cpumask, cpu_online_mask);
+	if (cpumask_empty(&cpumask))
 		return;
 
 	/*
@@ -416,7 +415,7 @@ static void flush_tlb_others(cpumask_t c
 	flush_mm = mm;
 	flush_vma = vma;
 	flush_va = va;
-	mask=cpus_addr(cpumask);
+	mask=cpumask_bits(&cpumask);
 	atomic_set_mask(*mask, (atomic_t *)&flush_cpumask);
 
 	/*
@@ -425,7 +424,7 @@ static void flush_tlb_others(cpumask_t c
 	 */
 	send_IPI_mask(&cpumask, INVALIDATE_TLB_IPI, 0);
 
-	while (!cpus_empty(flush_cpumask)) {
+	while (!cpumask_empty((cpumask_t*)&flush_cpumask)) {
 		/* nothing. lockup detection does not belong here */
 		mb();
 	}
@@ -460,7 +459,7 @@ void smp_invalidate_interrupt(void)
 	int cpu_id = smp_processor_id();
 	unsigned long *mmc = &flush_mm->context[cpu_id];
 
-	if (!cpu_isset(cpu_id, flush_cpumask))
+	if (!cpumask_test_cpu(cpu_id, &flush_cpumask))
 		return;
 
 	if (flush_va == FLUSH_ALL) {
@@ -478,7 +477,7 @@ void smp_invalidate_interrupt(void)
 			__flush_tlb_page(va);
 		}
 	}
-	cpu_clear(cpu_id, flush_cpumask);
+	cpumask_clear_cpu(cpu_id, (cpumask_t*)&flush_cpumask);
 }
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
@@ -530,7 +529,7 @@ static void stop_this_cpu(void *dummy)
 	/*
 	 * Remove this CPU:
 	 */
-	cpu_clear(cpu_id, cpu_online_map);
+	set_cpu_online(cpu_id, false);
 
 	/*
 	 * PSW IE = 1;
@@ -725,8 +724,8 @@ static void send_IPI_allbutself(int ipi_
 {
 	cpumask_t cpumask;
 
-	cpumask = cpu_online_map;
-	cpu_clear(smp_processor_id(), cpumask);
+	cpumask_copy(&cpumask, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), &cpumask);
 
 	send_IPI_mask(&cpumask, ipi_num, try);
 }
@@ -763,13 +762,13 @@ static void send_IPI_mask(const struct c
 	cpumask_and(&tmp, cpumask, cpu_online_mask);
 	BUG_ON(!cpumask_equal(cpumask, &tmp));
 
-	physid_mask = CPU_MASK_NONE;
+	cpumask_clear(&physid_mask);
 	for_each_cpu(cpu_id, cpumask) {
 		if ((phys_id = cpu_to_physid(cpu_id)) != -1)
-			cpu_set(phys_id, physid_mask);
+			cpumask_set_cpu(phys_id, &physid_mask);
 	}
 
-	send_IPI_mask_phys(physid_mask, ipi_num, try);
+	send_IPI_mask_phys(&physid_mask, ipi_num, try);
 }
 
 /*==========================================================================*
@@ -792,14 +791,14 @@ static void send_IPI_mask(const struct c
  * ---------- --- --------------------------------------------------------
  *
  *==========================================================================*/
-unsigned long send_IPI_mask_phys(cpumask_t physid_mask, int ipi_num,
+unsigned long send_IPI_mask_phys(const cpumask_t *physid_mask, int ipi_num,
 	int try)
 {
 	spinlock_t *ipilock;
 	volatile unsigned long *ipicr_addr;
 	unsigned long ipicr_val;
 	unsigned long my_physid_mask;
-	unsigned long mask = cpus_addr(physid_mask)[0];
+	unsigned long mask = cpumask_bits(physid_mask)[0];
 
 
 	if (mask & ~physids_coerce(phys_cpu_present_map))
diff -puN arch/m32r/kernel/smpboot.c~m32r-convert-cpumask-api arch/m32r/kernel/smpboot.c
--- a/arch/m32r/kernel/smpboot.c~m32r-convert-cpumask-api
+++ a/arch/m32r/kernel/smpboot.c
@@ -135,9 +135,9 @@ void __devinit smp_prepare_boot_cpu(void
 {
 	bsp_phys_id = hard_smp_processor_id();
 	physid_set(bsp_phys_id, phys_cpu_present_map);
-	cpu_set(0, cpu_online_map);	/* BSP's cpu_id == 0 */
-	cpu_set(0, cpu_callout_map);
-	cpu_set(0, cpu_callin_map);
+	set_cpu_online(0, true);	/* BSP's cpu_id == 0 */
+	cpumask_set_cpu(0, &cpu_callout_map);
+	cpumask_set_cpu(0, &cpu_callin_map);
 
 	/*
 	 * Initialize the logical to physical CPU number mapping
@@ -178,7 +178,7 @@ void __init smp_prepare_cpus(unsigned in
 	for (phys_id = 0 ; phys_id < nr_cpu ; phys_id++)
 		physid_set(phys_id, phys_cpu_present_map);
 #ifndef CONFIG_HOTPLUG_CPU
-	init_cpu_present(&cpu_possible_map);
+	init_cpu_present(cpu_possible_mask);
 #endif
 
 	show_mp_info(nr_cpu);
@@ -294,10 +294,10 @@ static void __init do_boot_cpu(int phys_
 	send_status = 0;
 	boot_status = 0;
 
-	cpu_set(phys_id, cpu_bootout_map);
+	cpumask_set_cpu(phys_id, &cpu_bootout_map);
 
 	/* Send Startup IPI */
-	send_IPI_mask_phys(cpumask_of_cpu(phys_id), CPU_BOOT_IPI, 0);
+	send_IPI_mask_phys(cpumask_of(phys_id), CPU_BOOT_IPI, 0);
 
 	Dprintk("Waiting for send to finish...\n");
 	timeout = 0;
@@ -306,7 +306,7 @@ static void __init do_boot_cpu(int phys_
 	do {
 		Dprintk("+");
 		udelay(1000);
-		send_status = !cpu_isset(phys_id, cpu_bootin_map);
+		send_status = !cpumask_test_cpu(phys_id, &cpu_bootin_map);
 	} while (send_status && (timeout++ < 100));
 
 	Dprintk("After Startup.\n");
@@ -316,19 +316,19 @@ static void __init do_boot_cpu(int phys_
 		 * allow APs to start initializing.
 		 */
 		Dprintk("Before Callout %d.\n", cpu_id);
-		cpu_set(cpu_id, cpu_callout_map);
+		cpumask_set_cpu(cpu_id, &cpu_callout_map);
 		Dprintk("After Callout %d.\n", cpu_id);
 
 		/*
 		 * Wait 5s total for a response
 		 */
 		for (timeout = 0; timeout < 5000; timeout++) {
-			if (cpu_isset(cpu_id, cpu_callin_map))
+			if (cpumask_test_cpu(cpu_id, &cpu_callin_map))
 				break;	/* It has booted */
 			udelay(1000);
 		}
 
-		if (cpu_isset(cpu_id, cpu_callin_map)) {
+		if (cpumask_test_cpu(cpu_id, &cpu_callin_map)) {
 			/* number CPUs logically, starting from 1 (BSP is 0) */
 			Dprintk("OK.\n");
 		} else {
@@ -340,9 +340,9 @@ static void __init do_boot_cpu(int phys_
 
 	if (send_status || boot_status) {
 		unmap_cpu_to_physid(cpu_id, phys_id);
-		cpu_clear(cpu_id, cpu_callout_map);
-		cpu_clear(cpu_id, cpu_callin_map);
-		cpu_clear(cpu_id, cpu_initialized);
+		cpumask_clear_cpu(cpu_id, &cpu_callout_map);
+		cpumask_clear_cpu(cpu_id, &cpu_callin_map);
+		cpumask_clear_cpu(cpu_id, &cpu_initialized);
 		cpucount--;
 	}
 }
@@ -351,17 +351,17 @@ int __cpuinit __cpu_up(unsigned int cpu_
 {
 	int timeout;
 
-	cpu_set(cpu_id, smp_commenced_mask);
+	cpumask_set_cpu(cpu_id, &smp_commenced_mask);
 
 	/*
 	 * Wait 5s total for a response
 	 */
 	for (timeout = 0; timeout < 5000; timeout++) {
-		if (cpu_isset(cpu_id, cpu_online_map))
+		if (cpu_online(cpu_id))
 			break;
 		udelay(1000);
 	}
-	if (!cpu_isset(cpu_id, cpu_online_map))
+	if (!cpu_online(cpu_id))
 		BUG();
 
 	return 0;
@@ -373,11 +373,11 @@ void __init smp_cpus_done(unsigned int m
 	unsigned long bogosum = 0;
 
 	for (timeout = 0; timeout < 5000; timeout++) {
-		if (cpus_equal(cpu_callin_map, cpu_online_map))
+		if (cpumask_equal(&cpu_callin_map, cpu_online_mask))
 			break;
 		udelay(1000);
 	}
-	if (!cpus_equal(cpu_callin_map, cpu_online_map))
+	if (!cpumask_equal(&cpu_callin_map, cpu_online_mask))
 		BUG();
 
 	for (cpu_id = 0 ; cpu_id < num_online_cpus() ; cpu_id++)
@@ -388,7 +388,7 @@ void __init smp_cpus_done(unsigned int m
 	 */
 	Dprintk("Before bogomips.\n");
 	if (cpucount) {
-		for_each_cpu_mask(cpu_id, cpu_online_map)
+		for_each_cpu(cpu_id,cpu_online_mask)
 			bogosum += cpu_data[cpu_id].loops_per_jiffy;
 
 		printk(KERN_INFO "Total of %d processors activated " \
@@ -425,7 +425,7 @@ int __init start_secondary(void *unused)
 	cpu_init();
 	preempt_disable();
 	smp_callin();
-	while (!cpu_isset(smp_processor_id(), smp_commenced_mask))
+	while (!cpumask_test_cpu(smp_processor_id(), &smp_commenced_mask))
 		cpu_relax();
 
 	smp_online();
@@ -463,7 +463,7 @@ static void __init smp_callin(void)
 	int cpu_id = smp_processor_id();
 	unsigned long timeout;
 
-	if (cpu_isset(cpu_id, cpu_callin_map)) {
+	if (cpumask_test_cpu(cpu_id, &cpu_callin_map)) {
 		printk("huh, phys CPU#%d, CPU#%d already present??\n",
 			phys_id, cpu_id);
 		BUG();
@@ -474,7 +474,7 @@ static void __init smp_callin(void)
 	timeout = jiffies + (2 * HZ);
 	while (time_before(jiffies, timeout)) {
 		/* Has the boot CPU finished it's STARTUP sequence ? */
-		if (cpu_isset(cpu_id, cpu_callout_map))
+		if (cpumask_test_cpu(cpu_id, &cpu_callout_map))
 			break;
 		cpu_relax();
 	}
@@ -486,7 +486,7 @@ static void __init smp_callin(void)
 	}
 
 	/* Allow the master to continue. */
-	cpu_set(cpu_id, cpu_callin_map);
+	cpumask_set_cpu(cpu_id, &cpu_callin_map);
 }
 
 static void __init smp_online(void)
@@ -503,7 +503,7 @@ static void __init smp_online(void)
 	/* Save our processor parameters */
  	smp_store_cpu_info(cpu_id);
 
-	cpu_set(cpu_id, cpu_online_map);
+	set_cpu_online(cpu_id, true);
 }
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

