From: akpm@linux-foundation.org
Subject: [merged] cris-convert-old-cpumask-api-into-new-one.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:50 -0700
Message-ID: <201105252029.p4PKTD7e014824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097Ab1EYU3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:29:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, jesper.nilsson@axis.com, starvik@axis.com, tfransosi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cris: convert old cpumask API into new one
has been removed from the -mm tree.  Its filename was
     cris-convert-old-cpumask-api-into-new-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: convert old cpumask API into new one
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Adapt to the new API.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Thiago Farina <tfransosi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/kernel/irq.c |    4 +--
 arch/cris/arch-v32/kernel/smp.c |   33 ++++++++++++++++--------------
 2 files changed, 20 insertions(+), 17 deletions(-)

diff -puN arch/cris/arch-v32/kernel/irq.c~cris-convert-old-cpumask-api-into-new-one arch/cris/arch-v32/kernel/irq.c
--- a/arch/cris/arch-v32/kernel/irq.c~cris-convert-old-cpumask-api-into-new-one
+++ a/arch/cris/arch-v32/kernel/irq.c
@@ -266,11 +266,11 @@ static int irq_cpu(int irq)
 
 
 	/* Let the interrupt stay if possible */
-	if (cpu_isset(cpu, irq_allocations[irq - FIRST_IRQ].mask))
+	if (cpumask_test_cpu(cpu, &irq_allocations[irq - FIRST_IRQ].mask))
 		goto out;
 
 	/* IRQ must be moved to another CPU. */
-	cpu = first_cpu(irq_allocations[irq - FIRST_IRQ].mask);
+	cpu = cpumask_first(&irq_allocations[irq - FIRST_IRQ].mask);
 	irq_allocations[irq - FIRST_IRQ].cpu = cpu;
 out:
 	spin_unlock_irqrestore(&irq_lock, flags);
diff -puN arch/cris/arch-v32/kernel/smp.c~cris-convert-old-cpumask-api-into-new-one arch/cris/arch-v32/kernel/smp.c
--- a/arch/cris/arch-v32/kernel/smp.c~cris-convert-old-cpumask-api-into-new-one
+++ a/arch/cris/arch-v32/kernel/smp.c
@@ -81,7 +81,7 @@ void __init smp_prepare_cpus(unsigned in
 
 	/* Mark all possible CPUs as present */
 	for (i = 0; i < max_cpus; i++)
-	    cpu_set(i, phys_cpu_present_map);
+		cpumask_set_cpu(i, &phys_cpu_present_map);
 }
 
 void __devinit smp_prepare_boot_cpu(void)
@@ -98,7 +98,7 @@ void __devinit smp_prepare_boot_cpu(void
 	SUPP_REG_WR(RW_MM_TLB_PGD, pgd);
 
 	set_cpu_online(0, true);
-	cpu_set(0, phys_cpu_present_map);
+	cpumask_set_cpu(0, &phys_cpu_present_map);
 	set_cpu_possible(0, true);
 }
 
@@ -112,8 +112,9 @@ smp_boot_one_cpu(int cpuid)
 {
 	unsigned timeout;
 	struct task_struct *idle;
-	cpumask_t cpu_mask = CPU_MASK_NONE;
+	cpumask_t cpu_mask;
 
+	cpumask_clear(&cpu_mask);
 	idle = fork_idle(cpuid);
 	if (IS_ERR(idle))
 		panic("SMP: fork failed for CPU:%d", cpuid);
@@ -125,10 +126,10 @@ smp_boot_one_cpu(int cpuid)
 	cpu_now_booting = cpuid;
 
 	/* Kick it */
-	cpu_set(cpuid, cpu_online_map);
-	cpu_set(cpuid, cpu_mask);
+	set_cpu_online(cpuid, true);
+	cpumask_set_cpu(cpuid, &cpu_mask);
 	send_ipi(IPI_BOOT, 0, cpu_mask);
-	cpu_clear(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, false);
 
 	/* Wait for CPU to come online */
 	for (timeout = 0; timeout < 10000; timeout++) {
@@ -176,7 +177,7 @@ void __init smp_callin(void)
 	notify_cpu_starting(cpu);
 	local_irq_enable();
 
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 	cpu_idle();
 }
 
@@ -214,8 +215,9 @@ int __cpuinit __cpu_up(unsigned int cpu)
 
 void smp_send_reschedule(int cpu)
 {
-	cpumask_t cpu_mask = CPU_MASK_NONE;
-	cpu_set(cpu, cpu_mask);
+	cpumask_t cpu_mask;
+	cpumask_clear(&cpu_mask);
+	cpumask_set_cpu(cpu, &cpu_mask);
 	send_ipi(IPI_SCHEDULE, 0, cpu_mask);
 }
 
@@ -232,7 +234,7 @@ void flush_tlb_common(struct mm_struct* 
 
 	spin_lock_irqsave(&tlbstate_lock, flags);
 	cpu_mask = (mm == FLUSH_ALL ? cpu_all_mask : *mm_cpumask(mm));
-	cpu_clear(smp_processor_id(), cpu_mask);
+	cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
 	flush_mm = mm;
 	flush_vma = vma;
 	flush_addr = addr;
@@ -277,10 +279,10 @@ int send_ipi(int vector, int wait, cpuma
 	int ret = 0;
 
 	/* Calculate CPUs to send to. */
-	cpus_and(cpu_mask, cpu_mask, cpu_online_map);
+	cpumask_and(&cpu_mask, &cpu_mask, cpu_online_mask);
 
 	/* Send the IPI. */
-	for_each_cpu_mask(i, cpu_mask)
+	for_each_cpu(i, &cpu_mask)
 	{
 		ipi.vector |= vector;
 		REG_WR(intr_vect, irq_regs[i], rw_ipi, ipi);
@@ -288,7 +290,7 @@ int send_ipi(int vector, int wait, cpuma
 
 	/* Wait for IPI to finish on other CPUS */
 	if (wait) {
-		for_each_cpu_mask(i, cpu_mask) {
+		for_each_cpu(i, &cpu_mask) {
                         int j;
                         for (j = 0 ; j < 1000; j++) {
 				ipi = REG_RD(intr_vect, irq_regs[i], rw_ipi);
@@ -314,11 +316,12 @@ int send_ipi(int vector, int wait, cpuma
  */
 int smp_call_function(void (*func)(void *info), void *info, int wait)
 {
-	cpumask_t cpu_mask = CPU_MASK_ALL;
+	cpumask_t cpu_mask;
 	struct call_data_struct data;
 	int ret;
 
-	cpu_clear(smp_processor_id(), cpu_mask);
+	cpumask_setall(&cpu_mask);
+	cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
 
 	WARN_ON(irqs_disabled());
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
m32r-convert-cpumask-api.patch
m32r-fix-spin_lock_irqsave-misuse.patch
m32r-remove-redundant-declaration.patch
getdelays-show-average-cpu-io-swap-reclaim-delays.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

