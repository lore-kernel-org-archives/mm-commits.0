From: akpm@linux-foundation.org
Subject: [merged] mn10300-convert-old-cpumask-api-into-new-one.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:48 -0700
Message-ID: <201105252029.p4PKTBs3014821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755767Ab1EYU3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:29:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cmetcalf@tilera.com, dhowells@redhat.com, hughd@google.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: convert old cpumask API into new one
has been removed from the -mm tree.  Its filename was
     mn10300-convert-old-cpumask-api-into-new-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: convert old cpumask API into new one
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Adapt to the new API.

We plan to remove old cpumask APIs later.  Thus this patch converts them
into the new one.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/irq.c   |   16 ++++---
 arch/mn10300/kernel/smp.c   |   75 +++++++++++++++++-----------------
 arch/mn10300/mm/cache-smp.c |    8 +--
 arch/mn10300/mm/tlb-smp.c   |   32 +++++++-------
 4 files changed, 68 insertions(+), 63 deletions(-)

diff -puN arch/mn10300/kernel/irq.c~mn10300-convert-old-cpumask-api-into-new-one arch/mn10300/kernel/irq.c
--- a/arch/mn10300/kernel/irq.c~mn10300-convert-old-cpumask-api-into-new-one
+++ a/arch/mn10300/kernel/irq.c
@@ -87,7 +87,7 @@ static void mn10300_cpupic_mask_ack(stru
 		tmp2 = GxICR(irq);
 
 		irq_affinity_online[irq] =
-			any_online_cpu(*d->affinity);
+			cpumask_any_and(d->affinity, cpu_online_mask);
 		CROSS_GxICR(irq, irq_affinity_online[irq]) =
 			(tmp & (GxICR_LEVEL | GxICR_ENABLE)) | GxICR_DETECT;
 		tmp = CROSS_GxICR(irq, irq_affinity_online[irq]);
@@ -124,7 +124,8 @@ static void mn10300_cpupic_unmask_clear(
 	} else {
 		tmp = GxICR(irq);
 
-		irq_affinity_online[irq] = any_online_cpu(*d->affinity);
+		irq_affinity_online[irq] = cpumask_any_and(d->affinity,
+							   cpu_online_mask);
 		CROSS_GxICR(irq, irq_affinity_online[irq]) = (tmp & GxICR_LEVEL) | GxICR_ENABLE | GxICR_DETECT;
 		tmp = CROSS_GxICR(irq, irq_affinity_online[irq]);
 	}
@@ -366,11 +367,11 @@ void migrate_irqs(void)
 		if (irqd_is_per_cpu(data))
 			continue;
 
-		if (cpu_isset(self, data->affinity) &&
-		    !cpus_intersects(irq_affinity[irq], cpu_online_map)) {
+		if (cpumask_test_cpu(self, &data->affinity) &&
+		    !cpumask_intersects(&irq_affinity[irq], cpu_online_mask)) {
 			int cpu_id;
-			cpu_id = first_cpu(cpu_online_map);
-			cpu_set(cpu_id, data->affinity);
+			cpu_id = cpumask_first(cpu_online_mask);
+			cpumask_set_cpu(cpu_id, &data->affinity);
 		}
 		/* We need to operate irq_affinity_online atomically. */
 		arch_local_cli_save(flags);
@@ -381,7 +382,8 @@ void migrate_irqs(void)
 			GxICR(irq) = x & GxICR_LEVEL;
 			tmp = GxICR(irq);
 
-			new = any_online_cpu(data->affinity);
+			new = cpumask_any_and(&data->affinity,
+					      cpu_online_mask);
 			irq_affinity_online[irq] = new;
 
 			CROSS_GxICR(irq, new) =
diff -puN arch/mn10300/kernel/smp.c~mn10300-convert-old-cpumask-api-into-new-one arch/mn10300/kernel/smp.c
--- a/arch/mn10300/kernel/smp.c~mn10300-convert-old-cpumask-api-into-new-one
+++ a/arch/mn10300/kernel/smp.c
@@ -309,7 +309,7 @@ static void send_IPI_mask(const cpumask_
 	u16 tmp;
 
 	for (i = 0; i < NR_CPUS; i++) {
-		if (cpu_isset(i, *cpumask)) {
+		if (cpumask_test_cpu(i, cpumask)) {
 			/* send IPI */
 			tmp = CROSS_GxICR(irq, i);
 			CROSS_GxICR(irq, i) =
@@ -342,8 +342,8 @@ void send_IPI_allbutself(int irq)
 {
 	cpumask_t cpumask;
 
-	cpumask = cpu_online_map;
-	cpu_clear(smp_processor_id(), cpumask);
+	cpumask_copy(&cpumask, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), &cpumask);
 	send_IPI_mask(&cpumask, irq);
 }
 
@@ -393,8 +393,8 @@ int smp_nmi_call_function(smp_call_func_
 
 	data.func = func;
 	data.info = info;
-	data.started = cpu_online_map;
-	cpu_clear(smp_processor_id(), data.started);
+	cpumask_copy(&data.started, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), &data.started);
 	data.wait = wait;
 	if (wait)
 		data.finished = data.started;
@@ -410,14 +410,14 @@ int smp_nmi_call_function(smp_call_func_
 	if (CALL_FUNCTION_NMI_IPI_TIMEOUT > 0) {
 		for (cnt = 0;
 		     cnt < CALL_FUNCTION_NMI_IPI_TIMEOUT &&
-			     !cpus_empty(data.started);
+			     !cpumask_empty(&data.started);
 		     cnt++)
 			mdelay(1);
 
 		if (wait && cnt < CALL_FUNCTION_NMI_IPI_TIMEOUT) {
 			for (cnt = 0;
 			     cnt < CALL_FUNCTION_NMI_IPI_TIMEOUT &&
-				     !cpus_empty(data.finished);
+				     !cpumask_empty(&data.finished);
 			     cnt++)
 				mdelay(1);
 		}
@@ -428,10 +428,10 @@ int smp_nmi_call_function(smp_call_func_
 	} else {
 		/* If timeout value is zero, wait until cpumask has been
 		 * cleared */
-		while (!cpus_empty(data.started))
+		while (!cpumask_empty(&data.started))
 			barrier();
 		if (wait)
-			while (!cpus_empty(data.finished))
+			while (!cpumask_empty(&data.finished))
 				barrier();
 	}
 
@@ -472,12 +472,12 @@ void stop_this_cpu(void *unused)
 #endif	/* CONFIG_GDBSTUB */
 
 	flags = arch_local_cli_save();
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 
 	while (!stopflag)
 		cpu_relax();
 
-	cpu_set(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), true);
 	arch_local_irq_restore(flags);
 }
 
@@ -529,12 +529,13 @@ void smp_nmi_call_function_interrupt(voi
 	 * execute the function
 	 */
 	smp_mb();
-	cpu_clear(smp_processor_id(), nmi_call_data->started);
+	cpumask_clear_cpu(smp_processor_id(), &nmi_call_data->started);
 	(*func)(info);
 
 	if (wait) {
 		smp_mb();
-		cpu_clear(smp_processor_id(), nmi_call_data->finished);
+		cpumask_clear_cpu(smp_processor_id(),
+				  &nmi_call_data->finished);
 	}
 }
 
@@ -657,7 +658,7 @@ int __init start_secondary(void *unused)
 {
 	smp_cpu_init();
 	smp_callin();
-	while (!cpu_isset(smp_processor_id(), smp_commenced_mask))
+	while (!cpumask_test_cpu(smp_processor_id(), &smp_commenced_mask))
 		cpu_relax();
 
 	local_flush_tlb();
@@ -780,13 +781,14 @@ static int __init do_boot_cpu(int phy_id
 
 	if (send_status == 0) {
 		/* Allow AP to start initializing */
-		cpu_set(cpu_id, cpu_callout_map);
+		cpumask_set_cpu(cpu_id, &cpu_callout_map);
 
 		/* Wait for setting cpu_callin_map */
 		timeout = 0;
 		do {
 			udelay(1000);
-			callin_status = cpu_isset(cpu_id, cpu_callin_map);
+			callin_status = cpumask_test_cpu(cpu_id,
+							 &cpu_callin_map);
 		} while (callin_status == 0 && timeout++ < 5000);
 
 		if (callin_status == 0)
@@ -796,9 +798,9 @@ static int __init do_boot_cpu(int phy_id
 	}
 
 	if (send_status == GxICR_REQUEST || callin_status == 0) {
-		cpu_clear(cpu_id, cpu_callout_map);
-		cpu_clear(cpu_id, cpu_callin_map);
-		cpu_clear(cpu_id, cpu_initialized);
+		cpumask_clear_cpu(cpu_id, &cpu_callout_map);
+		cpumask_clear_cpu(cpu_id, &cpu_callin_map);
+		cpumask_clear_cpu(cpu_id, &cpu_initialized);
 		cpucount--;
 		return 1;
 	}
@@ -833,7 +835,7 @@ static void __init smp_callin(void)
 	cpu = smp_processor_id();
 	timeout = jiffies + (2 * HZ);
 
-	if (cpu_isset(cpu, cpu_callin_map)) {
+	if (cpumask_test_cpu(cpu, &cpu_callin_map)) {
 		printk(KERN_ERR "CPU#%d already present.\n", cpu);
 		BUG();
 	}
@@ -841,7 +843,7 @@ static void __init smp_callin(void)
 
 	/* Wait for AP startup 2s total */
 	while (time_before(jiffies, timeout)) {
-		if (cpu_isset(cpu, cpu_callout_map))
+		if (cpumask_test_cpu(cpu, &cpu_callout_map))
 			break;
 		cpu_relax();
 	}
@@ -861,11 +863,11 @@ static void __init smp_callin(void)
 	smp_store_cpu_info(cpu);
 
 	/* Allow the boot processor to continue */
-	cpu_set(cpu, cpu_callin_map);
+	cpumask_set_cpu(cpu, &cpu_callin_map);
 }
 
 /**
- * smp_online - Set cpu_online_map
+ * smp_online - Set cpu_online_mask
  */
 static void __init smp_online(void)
 {
@@ -875,7 +877,7 @@ static void __init smp_online(void)
 
 	local_irq_enable();
 
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 	smp_wmb();
 }
 
@@ -892,13 +894,13 @@ void __init smp_cpus_done(unsigned int m
 /*
  * smp_prepare_boot_cpu - Set up stuff for the boot processor.
  *
- * Set up the cpu_online_map, cpu_callout_map and cpu_callin_map of the boot
+ * Set up the cpu_online_mask, cpu_callout_map and cpu_callin_map of the boot
  * processor (CPU 0).
  */
 void __devinit smp_prepare_boot_cpu(void)
 {
-	cpu_set(0, cpu_callout_map);
-	cpu_set(0, cpu_callin_map);
+	cpumask_set_cpu(0, &cpu_callout_map);
+	cpumask_set_cpu(0, &cpu_callin_map);
 	current_thread_info()->cpu = 0;
 }
 
@@ -931,16 +933,16 @@ int __devinit __cpu_up(unsigned int cpu)
 		run_wakeup_cpu(cpu);
 #endif /* CONFIG_HOTPLUG_CPU */
 
-	cpu_set(cpu, smp_commenced_mask);
+	cpumask_set_cpu(cpu, &smp_commenced_mask);
 
 	/* Wait 5s total for a response */
 	for (timeout = 0 ; timeout < 5000 ; timeout++) {
-		if (cpu_isset(cpu, cpu_online_map))
+		if (cpu_online(cpu))
 			break;
 		udelay(1000);
 	}
 
-	BUG_ON(!cpu_isset(cpu, cpu_online_map));
+	BUG_ON(!cpu_online(cpu));
 	return 0;
 }
 
@@ -986,7 +988,7 @@ int __cpu_disable(void)
 		return -EBUSY;
 
 	migrate_irqs();
-	cpu_clear(cpu, current->active_mm->cpu_vm_mask);
+	cpumask_clear_cpu(cpu, &mm_cpumask(current->active_mm));
 	return 0;
 }
 
@@ -1091,13 +1093,13 @@ static int hotplug_cpu_nmi_call_function
 	do {
 		mn10300_local_dcache_inv_range(start, end);
 		barrier();
-	} while (!cpus_empty(nmi_call_func_mask_data.started));
+	} while (!cpumask_empty(&nmi_call_func_mask_data.started));
 
 	if (wait) {
 		do {
 			mn10300_local_dcache_inv_range(start, end);
 			barrier();
-		} while (!cpus_empty(nmi_call_func_mask_data.finished));
+		} while (!cpumask_empty(&nmi_call_func_mask_data.finished));
 	}
 
 	spin_unlock(&smp_nmi_call_lock);
@@ -1108,9 +1110,9 @@ static void restart_wakeup_cpu(void)
 {
 	unsigned int cpu = smp_processor_id();
 
-	cpu_set(cpu, cpu_callin_map);
+	cpumask_set_cpu(cpu, &cpu_callin_map);
 	local_flush_tlb();
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 	smp_wmb();
 }
 
@@ -1141,8 +1143,9 @@ static void sleep_cpu(void *unused)
 static void run_sleep_cpu(unsigned int cpu)
 {
 	unsigned long flags;
-	cpumask_t cpumask = cpumask_of(cpu);
+	cpumask_t cpumask;
 
+	cpumask_copy(&cpumask, &cpumask_of(cpu));
 	flags = arch_local_cli_save();
 	hotplug_cpu_nmi_call_function(cpumask, prepare_sleep_cpu, NULL, 1);
 	hotplug_cpu_nmi_call_function(cpumask, sleep_cpu, NULL, 0);
diff -puN arch/mn10300/mm/cache-smp.c~mn10300-convert-old-cpumask-api-into-new-one arch/mn10300/mm/cache-smp.c
--- a/arch/mn10300/mm/cache-smp.c~mn10300-convert-old-cpumask-api-into-new-one
+++ a/arch/mn10300/mm/cache-smp.c
@@ -74,7 +74,7 @@ void smp_cache_interrupt(void)
 		break;
 	}
 
-	cpu_clear(smp_processor_id(), smp_cache_ipi_map);
+	cpumask_clear_cpu(smp_processor_id(), &smp_cache_ipi_map);
 }
 
 /**
@@ -94,12 +94,12 @@ void smp_cache_call(unsigned long opr_ma
 	smp_cache_mask = opr_mask;
 	smp_cache_start = start;
 	smp_cache_end = end;
-	smp_cache_ipi_map = cpu_online_map;
-	cpu_clear(smp_processor_id(), smp_cache_ipi_map);
+	cpumask_copy(&smp_cache_ipi_map, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), &smp_cache_ipi_map);
 
 	send_IPI_allbutself(FLUSH_CACHE_IPI);
 
-	while (!cpus_empty(smp_cache_ipi_map))
+	while (!cpumask_empty(&smp_cache_ipi_map))
 		/* nothing. lockup detection does not belong here */
 		mb();
 }
diff -puN arch/mn10300/mm/tlb-smp.c~mn10300-convert-old-cpumask-api-into-new-one arch/mn10300/mm/tlb-smp.c
--- a/arch/mn10300/mm/tlb-smp.c~mn10300-convert-old-cpumask-api-into-new-one
+++ a/arch/mn10300/mm/tlb-smp.c
@@ -64,7 +64,7 @@ void smp_flush_tlb(void *unused)
 
 	cpu_id = get_cpu();
 
-	if (!cpu_isset(cpu_id, flush_cpumask))
+	if (!cpumask_test_cpu(cpu_id, &flush_cpumask))
 		/* This was a BUG() but until someone can quote me the line
 		 * from the intel manual that guarantees an IPI to multiple
 		 * CPUs is retried _only_ on the erroring CPUs its staying as a
@@ -80,7 +80,7 @@ void smp_flush_tlb(void *unused)
 		local_flush_tlb_page(flush_mm, flush_va);
 
 	smp_mb__before_clear_bit();
-	cpu_clear(cpu_id, flush_cpumask);
+	cpumask_clear_cpu(cpu_id, &flush_cpumask);
 	smp_mb__after_clear_bit();
 out:
 	put_cpu();
@@ -103,11 +103,11 @@ static void flush_tlb_others(cpumask_t c
 	 * - we do not send IPIs to as-yet unbooted CPUs.
 	 */
 	BUG_ON(!mm);
-	BUG_ON(cpus_empty(cpumask));
-	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
+	BUG_ON(cpumask_empty(&cpumask));
+	BUG_ON(cpumask_test_cpu(smp_processor_id(), &cpumask));
 
-	cpus_and(tmp, cpumask, cpu_online_map);
-	BUG_ON(!cpus_equal(cpumask, tmp));
+	cpumask_and(&tmp, &cpumask, cpu_online_mask);
+	BUG_ON(!cpumask_equal(&cpumask, &tmp));
 
 	/* I'm not happy about this global shared spinlock in the MM hot path,
 	 * but we'll see how contended it is.
@@ -128,7 +128,7 @@ static void flush_tlb_others(cpumask_t c
 	/* FIXME: if NR_CPUS>=3, change send_IPI_mask */
 	smp_call_function(smp_flush_tlb, NULL, 1);
 
-	while (!cpus_empty(flush_cpumask))
+	while (!cpumask_empty(&flush_cpumask))
 		/* Lockup detection does not belong here */
 		smp_mb();
 
@@ -146,11 +146,11 @@ void flush_tlb_mm(struct mm_struct *mm)
 	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
+	cpumask_copy(&cpu_mask, mm_cpumask(mm));
+	cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
 
 	local_flush_tlb();
-	if (!cpus_empty(cpu_mask))
+	if (!cpumask_empty(&cpu_mask))
 		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
 
 	preempt_enable();
@@ -165,11 +165,11 @@ void flush_tlb_current_task(void)
 	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
+	cpumask_copy(&cpu_mask, mm_cpumask(mm));
+	cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
 
 	local_flush_tlb();
-	if (!cpus_empty(cpu_mask))
+	if (!cpumask_empty(&cpu_mask))
 		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
 
 	preempt_enable();
@@ -186,11 +186,11 @@ void flush_tlb_page(struct vm_area_struc
 	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
+	cpumask_copy(&cpu_mask, mm_cpumask(mm));
+	cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
 
 	local_flush_tlb_page(mm, va);
-	if (!cpus_empty(cpu_mask))
+	if (!cpumask_empty(&cpu_mask))
 		flush_tlb_others(cpu_mask, mm, va);
 
 	preempt_enable();
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

