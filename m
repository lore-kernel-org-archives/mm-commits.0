From: akpm@linux-foundation.org
Subject: [merged] alpha-replace-with-new-cpumask-apis.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:42 -0700
Message-ID: <201105252029.p4PKT5Sg014814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754084Ab1EYU3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:29:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: replace with new cpumask APIs
has been removed from the -mm tree.  Its filename was
     alpha-replace-with-new-cpumask-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: replace with new cpumask APIs
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

We plan to remove cpu_xx() old APIs.  Thus convert them.  This patch has
no functional change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/process.c   |    2 +-
 arch/alpha/kernel/setup.c     |    2 +-
 arch/alpha/kernel/smp.c       |    7 ++++---
 arch/alpha/kernel/sys_dp264.c |    2 +-
 arch/alpha/kernel/sys_titan.c |   13 +++++++------
 5 files changed, 14 insertions(+), 12 deletions(-)

diff -puN arch/alpha/kernel/process.c~alpha-replace-with-new-cpumask-apis arch/alpha/kernel/process.c
--- a/arch/alpha/kernel/process.c~alpha-replace-with-new-cpumask-apis
+++ a/arch/alpha/kernel/process.c
@@ -121,7 +121,7 @@ common_shutdown_1(void *generic_ptr)
 	/* Wait for the secondaries to halt. */
 	set_cpu_present(boot_cpuid, false);
 	set_cpu_possible(boot_cpuid, false);
-	while (cpus_weight(cpu_present_map))
+	while (cpumask_weight(cpu_present_mask))
 		barrier();
 #endif
 
diff -puN arch/alpha/kernel/setup.c~alpha-replace-with-new-cpumask-apis arch/alpha/kernel/setup.c
--- a/arch/alpha/kernel/setup.c~alpha-replace-with-new-cpumask-apis
+++ a/arch/alpha/kernel/setup.c
@@ -1257,7 +1257,7 @@ show_cpuinfo(struct seq_file *f, void *s
 #ifdef CONFIG_SMP
 	seq_printf(f, "cpus active\t\t: %u\n"
 		      "cpu active mask\t\t: %016lx\n",
-		       num_online_cpus(), cpus_addr(cpu_possible_map)[0]);
+		       num_online_cpus(), cpumask_bits(cpu_possible_mask)[0]);
 #endif
 
 	show_cache_size (f, "L1 Icache", alpha_l1i_cacheshape);
diff -puN arch/alpha/kernel/smp.c~alpha-replace-with-new-cpumask-apis arch/alpha/kernel/smp.c
--- a/arch/alpha/kernel/smp.c~alpha-replace-with-new-cpumask-apis
+++ a/arch/alpha/kernel/smp.c
@@ -451,7 +451,7 @@ setup_smp(void)
 	}
 
 	printk(KERN_INFO "SMP: %d CPUs probed -- cpu_present_map = %lx\n",
-	       smp_num_probed, cpu_present_map.bits[0]);
+	       smp_num_probed, cpumask_bits(cpu_present_mask)[0]);
 }
 
 /*
@@ -629,8 +629,9 @@ smp_send_reschedule(int cpu)
 void
 smp_send_stop(void)
 {
-	cpumask_t to_whom = cpu_possible_map;
-	cpu_clear(smp_processor_id(), to_whom);
+	cpumask_t to_whom;
+	cpumask_copy(&to_whom, cpu_possible_mask);
+	cpumask_clear_cpu(smp_processor_id(), &to_whom);
 #ifdef DEBUG_IPI_MSG
 	if (hard_smp_processor_id() != boot_cpu_id)
 		printk(KERN_WARNING "smp_send_stop: Not on boot cpu.\n");
diff -puN arch/alpha/kernel/sys_dp264.c~alpha-replace-with-new-cpumask-apis arch/alpha/kernel/sys_dp264.c
--- a/arch/alpha/kernel/sys_dp264.c~alpha-replace-with-new-cpumask-apis
+++ a/arch/alpha/kernel/sys_dp264.c
@@ -140,7 +140,7 @@ cpu_set_irq_affinity(unsigned int irq, c
 
 	for (cpu = 0; cpu < 4; cpu++) {
 		unsigned long aff = cpu_irq_affinity[cpu];
-		if (cpu_isset(cpu, affinity))
+		if (cpumask_test_cpu(cpu, &affinity))
 			aff |= 1UL << irq;
 		else
 			aff &= ~(1UL << irq);
diff -puN arch/alpha/kernel/sys_titan.c~alpha-replace-with-new-cpumask-apis arch/alpha/kernel/sys_titan.c
--- a/arch/alpha/kernel/sys_titan.c~alpha-replace-with-new-cpumask-apis
+++ a/arch/alpha/kernel/sys_titan.c
@@ -65,10 +65,11 @@ titan_update_irq_hw(unsigned long mask)
 	register int bcpu = boot_cpuid;
 
 #ifdef CONFIG_SMP
-	cpumask_t cpm = cpu_present_map;
+	cpumask_t cpm;
 	volatile unsigned long *dim0, *dim1, *dim2, *dim3;
 	unsigned long mask0, mask1, mask2, mask3, dummy;
 
+	cpumask_copy(&cpm, cpu_present_mask);
 	mask &= ~isa_enable;
 	mask0 = mask & titan_cpu_irq_affinity[0];
 	mask1 = mask & titan_cpu_irq_affinity[1];
@@ -84,10 +85,10 @@ titan_update_irq_hw(unsigned long mask)
 	dim1 = &cchip->dim1.csr;
 	dim2 = &cchip->dim2.csr;
 	dim3 = &cchip->dim3.csr;
-	if (!cpu_isset(0, cpm)) dim0 = &dummy;
-	if (!cpu_isset(1, cpm)) dim1 = &dummy;
-	if (!cpu_isset(2, cpm)) dim2 = &dummy;
-	if (!cpu_isset(3, cpm)) dim3 = &dummy;
+	if (!cpumask_test_cpu(0, &cpm)) dim0 = &dummy;
+	if (!cpumask_test_cpu(1, &cpm)) dim1 = &dummy;
+	if (!cpumask_test_cpu(2, &cpm)) dim2 = &dummy;
+	if (!cpumask_test_cpu(3, &cpm)) dim3 = &dummy;
 
 	*dim0 = mask0;
 	*dim1 = mask1;
@@ -137,7 +138,7 @@ titan_cpu_set_irq_affinity(unsigned int 
 	int cpu;
 
 	for (cpu = 0; cpu < 4; cpu++) {
-		if (cpu_isset(cpu, affinity))
+		if (cpumask_test_cpu(cpu, &affinity))
 			titan_cpu_irq_affinity[cpu] |= 1UL << irq;
 		else
 			titan_cpu_irq_affinity[cpu] &= ~(1UL << irq);
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

