From: akpm@linux-foundation.org
Subject: + cris-convert-old-cpumask-api-into-new-one.patch added to -mm tree
Date: Thu, 05 May 2011 12:51:03 -0700
Message-ID: <201105051951.p45Jp3eC031597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028Ab1EETvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2011 15:51:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, jesper.nilsson@axis.com, starvik@axis.com, tfransosi@gmail.com


The patch titled
     cris: convert old cpumask API into new one
has been added to the -mm tree.  Its filename is
     cris-convert-old-cpumask-api-into-new-one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: convert old cpumask API into new one
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Adapt to the new API.

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
+	    cpumask_set_cpu(i, &phys_cpu_present_map);
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

mm-check-pageunevictable-in-lru_deactivate_fn.patch
linux-next.patch
slab-use-numa_no_node.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
mn10300-replace-mm-cpu_vm_mask-with-mm_cpumask.patch
tile-replace-mm-cpu_vm_mask-with-mm_cpumask.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch
mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch
mm-strictly-require-elevated-page-refcount-in-isolate_lru_page.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix.patch
readahead-readahead-page-allocations-are-ok-to-fail.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-filter-unevictable-page-out-in-deactivate_page.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured.patch
mm-export-get_vma_policy.patch
mm-use-walk_page_range-instead-of-custom-page-table-walking-code.patch
mm-remove-mpol_mf_stats.patch
mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch
mm-remove-check_huge_range.patch
mm-proc-move-show_numa_map-to-fs-proc-task_mmuc.patch
proc-make-struct-proc_maps_private-truly-private.patch
proc-allocate-storage-for-numa_maps-statistics-once.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
alpha-replace-with-new-cpumask-apis.patch
m32r-convert-cpumask-api.patch
m32r-fix-spin_lock_irqsave-misuse.patch
m32r-remove-redundant-declaration.patch
cris-convert-old-cpumask-api-into-new-one.patch
sparse-define-dummy-build_bug_on-definition-for-sparse.patch
sparse-define-__must_be_array-for-__checker__.patch
sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

