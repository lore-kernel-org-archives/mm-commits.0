From: akpm@linux-foundation.org
Subject: [merged] arch-ia64-remove-references-to-cpu__map.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:44 -0700
Message-ID: <20120329191344.693EEA01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:65312 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933735Ab2C2TNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:45 -0400
Received: by mail-yx0-f202.google.com with SMTP id q2so303047yen.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srivatsa.bhat@linux.vnet.ibm.com, rusty@rustcorp.com.au, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/ia64: remove references to cpu_*_map
has been removed from the -mm tree.  Its filename was
     arch-ia64-remove-references-to-cpu__map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: arch/ia64: remove references to cpu_*_map

This was marked as obsolete for quite a while now..  Now it is time to
remove it altogether.  And while doing this, get rid of first_cpu() as
well.  Also, remove the redundant setting of cpu_online_mask in
smp_prepare_cpus() because the generic code would have already set cpu 0
in cpu_online_mask.

Reported-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/acpi.c     |    6 +++---
 arch/ia64/kernel/irq_ia64.c |    8 ++++----
 arch/ia64/kernel/mca.c      |    6 ++++--
 arch/ia64/kernel/msi_ia64.c |    4 ++--
 arch/ia64/kernel/setup.c    |    2 +-
 arch/ia64/kernel/smp.c      |    2 +-
 arch/ia64/kernel/smpboot.c  |   19 +++++++------------
 arch/ia64/kernel/topology.c |    3 ++-
 8 files changed, 24 insertions(+), 26 deletions(-)

diff -puN arch/ia64/kernel/acpi.c~arch-ia64-remove-references-to-cpu__map arch/ia64/kernel/acpi.c
--- a/arch/ia64/kernel/acpi.c~arch-ia64-remove-references-to-cpu__map
+++ a/arch/ia64/kernel/acpi.c
@@ -844,7 +844,7 @@ early_param("additional_cpus", setup_add
  * are onlined, or offlined. The reason is per-cpu data-structures
  * are allocated by some modules at init time, and dont expect to
  * do this dynamically on cpu arrival/departure.
- * cpu_present_map on the other hand can change dynamically.
+ * cpu_present_mask on the other hand can change dynamically.
  * In case when cpu_hotplug is not compiled, then we resort to current
  * behaviour, which is cpu_possible == cpu_present.
  * - Ashok Raj
@@ -922,7 +922,7 @@ static int __cpuinit _acpi_map_lsapic(ac
 
 	acpi_map_cpu2node(handle, cpu, physid);
 
-	cpu_set(cpu, cpu_present_map);
+	set_cpu_present(cpu, true);
 	ia64_cpu_to_sapicid[cpu] = physid;
 
 	acpi_processor_set_pdc(handle);
@@ -941,7 +941,7 @@ EXPORT_SYMBOL(acpi_map_lsapic);
 int acpi_unmap_lsapic(int cpu)
 {
 	ia64_cpu_to_sapicid[cpu] = -1;
-	cpu_clear(cpu, cpu_present_map);
+	set_cpu_present(cpu, false);
 
 #ifdef CONFIG_ACPI_NUMA
 	/* NUMA specific cleanup's */
diff -puN arch/ia64/kernel/irq_ia64.c~arch-ia64-remove-references-to-cpu__map arch/ia64/kernel/irq_ia64.c
--- a/arch/ia64/kernel/irq_ia64.c~arch-ia64-remove-references-to-cpu__map
+++ a/arch/ia64/kernel/irq_ia64.c
@@ -118,7 +118,7 @@ static inline int find_unassigned_vector
 	cpumask_t mask;
 	int pos, vector;
 
-	cpus_and(mask, domain, cpu_online_map);
+	cpumask_and(&mask, &domain, cpu_online_mask);
 	if (cpus_empty(mask))
 		return -EINVAL;
 
@@ -141,7 +141,7 @@ static int __bind_irq_vector(int irq, in
 	BUG_ON((unsigned)irq >= NR_IRQS);
 	BUG_ON((unsigned)vector >= IA64_NUM_VECTORS);
 
-	cpus_and(mask, domain, cpu_online_map);
+	cpumask_and(&mask, &domain, cpu_online_mask);
 	if (cpus_empty(mask))
 		return -EINVAL;
 	if ((cfg->vector == vector) && cpus_equal(cfg->domain, domain))
@@ -179,7 +179,7 @@ static void __clear_irq_vector(int irq)
 	BUG_ON(cfg->vector == IRQ_VECTOR_UNASSIGNED);
 	vector = cfg->vector;
 	domain = cfg->domain;
-	cpus_and(mask, cfg->domain, cpu_online_map);
+	cpumask_and(&mask, &cfg->domain, cpu_online_mask);
 	for_each_cpu_mask(cpu, mask)
 		per_cpu(vector_irq, cpu)[vector] = -1;
 	cfg->vector = IRQ_VECTOR_UNASSIGNED;
@@ -322,7 +322,7 @@ void irq_complete_move(unsigned irq)
 	if (unlikely(cpu_isset(smp_processor_id(), cfg->old_domain)))
 		return;
 
-	cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
+	cpumask_and(&cleanup_mask, &cfg->old_domain, cpu_online_mask);
 	cfg->move_cleanup_count = cpus_weight(cleanup_mask);
 	for_each_cpu_mask(i, cleanup_mask)
 		platform_send_ipi(i, IA64_IRQ_MOVE_VECTOR, IA64_IPI_DM_INT, 0);
diff -puN arch/ia64/kernel/mca.c~arch-ia64-remove-references-to-cpu__map arch/ia64/kernel/mca.c
--- a/arch/ia64/kernel/mca.c~arch-ia64-remove-references-to-cpu__map
+++ a/arch/ia64/kernel/mca.c
@@ -1515,7 +1515,8 @@ static void
 ia64_mca_cmc_poll (unsigned long dummy)
 {
 	/* Trigger a CMC interrupt cascade  */
-	platform_send_ipi(first_cpu(cpu_online_map), IA64_CMCP_VECTOR, IA64_IPI_DM_INT, 0);
+	platform_send_ipi(cpumask_first(cpu_online_mask), IA64_CMCP_VECTOR,
+							IA64_IPI_DM_INT, 0);
 }
 
 /*
@@ -1591,7 +1592,8 @@ static void
 ia64_mca_cpe_poll (unsigned long dummy)
 {
 	/* Trigger a CPE interrupt cascade  */
-	platform_send_ipi(first_cpu(cpu_online_map), IA64_CPEP_VECTOR, IA64_IPI_DM_INT, 0);
+	platform_send_ipi(cpumask_first(cpu_online_mask), IA64_CPEP_VECTOR,
+							IA64_IPI_DM_INT, 0);
 }
 
 #endif /* CONFIG_ACPI */
diff -puN arch/ia64/kernel/msi_ia64.c~arch-ia64-remove-references-to-cpu__map arch/ia64/kernel/msi_ia64.c
--- a/arch/ia64/kernel/msi_ia64.c~arch-ia64-remove-references-to-cpu__map
+++ a/arch/ia64/kernel/msi_ia64.c
@@ -57,7 +57,7 @@ int ia64_setup_msi_irq(struct pci_dev *p
 		return irq;
 
 	irq_set_msi_desc(irq, desc);
-	cpus_and(mask, irq_to_domain(irq), cpu_online_map);
+	cpumask_and(&mask, &(irq_to_domain(irq)), cpu_online_mask);
 	dest_phys_id = cpu_physical_id(first_cpu(mask));
 	vector = irq_to_vector(irq);
 
@@ -179,7 +179,7 @@ msi_compose_msg(struct pci_dev *pdev, un
 	unsigned dest;
 	cpumask_t mask;
 
-	cpus_and(mask, irq_to_domain(irq), cpu_online_map);
+	cpumask_and(&mask, &(irq_to_domain(irq)), cpu_online_mask);
 	dest = cpu_physical_id(first_cpu(mask));
 
 	msg->address_hi = 0;
diff -puN arch/ia64/kernel/setup.c~arch-ia64-remove-references-to-cpu__map arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~arch-ia64-remove-references-to-cpu__map
+++ a/arch/ia64/kernel/setup.c
@@ -486,7 +486,7 @@ mark_bsp_online (void)
 {
 #ifdef CONFIG_SMP
 	/* If we register an early console, allow CPU 0 to printk */
-	cpu_set(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), true);
 #endif
 }
 
diff -puN arch/ia64/kernel/smp.c~arch-ia64-remove-references-to-cpu__map arch/ia64/kernel/smp.c
--- a/arch/ia64/kernel/smp.c~arch-ia64-remove-references-to-cpu__map
+++ a/arch/ia64/kernel/smp.c
@@ -77,7 +77,7 @@ stop_this_cpu(void)
 	/*
 	 * Remove this CPU:
 	 */
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 	max_xtp();
 	local_irq_disable();
 	cpu_halt();
diff -puN arch/ia64/kernel/smpboot.c~arch-ia64-remove-references-to-cpu__map arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~arch-ia64-remove-references-to-cpu__map
+++ a/arch/ia64/kernel/smpboot.c
@@ -401,7 +401,7 @@ smp_callin (void)
 	/* Setup the per cpu irq handling data structures */
 	__setup_vector_irq(cpuid);
 	notify_cpu_starting(cpuid);
-	cpu_set(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, true);
 	per_cpu(cpu_state, cpuid) = CPU_ONLINE;
 	spin_unlock(&vector_lock);
 	ipi_call_unlock_irq();
@@ -548,7 +548,7 @@ do_rest:
 	if (!cpu_isset(cpu, cpu_callin_map)) {
 		printk(KERN_ERR "Processor 0x%x/0x%x is stuck.\n", cpu, sapicid);
 		ia64_cpu_to_sapicid[cpu] = -1;
-		cpu_clear(cpu, cpu_online_map);  /* was set in smp_callin() */
+		set_cpu_online(cpu, false);  /* was set in smp_callin() */
 		return -EINVAL;
 	}
 	return 0;
@@ -578,8 +578,7 @@ smp_build_cpu_map (void)
 	}
 
 	ia64_cpu_to_sapicid[0] = boot_cpu_id;
-	cpus_clear(cpu_present_map);
-	set_cpu_present(0, true);
+	init_cpu_present(cpumask_of(0));
 	set_cpu_possible(0, true);
 	for (cpu = 1, i = 0; i < smp_boot_data.cpu_count; i++) {
 		sapicid = smp_boot_data.cpu_phys_id[i];
@@ -606,10 +605,6 @@ smp_prepare_cpus (unsigned int max_cpus)
 
 	smp_setup_percpu_timer();
 
-	/*
-	 * We have the boot CPU online for sure.
-	 */
-	cpu_set(0, cpu_online_map);
 	cpu_set(0, cpu_callin_map);
 
 	local_cpu_data->loops_per_jiffy = loops_per_jiffy;
@@ -633,7 +628,7 @@ smp_prepare_cpus (unsigned int max_cpus)
 
 void __devinit smp_prepare_boot_cpu(void)
 {
-	cpu_set(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), true);
 	cpu_set(smp_processor_id(), cpu_callin_map);
 	set_numa_node(cpu_to_node_map[smp_processor_id()]);
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
@@ -690,7 +685,7 @@ int migrate_platform_irqs(unsigned int c
 			/*
 			 * Now re-target the CPEI to a different processor
 			 */
-			new_cpei_cpu = any_online_cpu(cpu_online_map);
+			new_cpei_cpu = cpumask_any(cpu_online_mask);
 			mask = cpumask_of(new_cpei_cpu);
 			set_cpei_target_cpu(new_cpei_cpu);
 			data = irq_get_irq_data(ia64_cpe_irq);
@@ -732,10 +727,10 @@ int __cpu_disable(void)
 			return -EBUSY;
 	}
 
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 
 	if (migrate_platform_irqs(cpu)) {
-		cpu_set(cpu, cpu_online_map);
+		set_cpu_online(cpu, true);
 		return -EBUSY;
 	}
 
diff -puN arch/ia64/kernel/topology.c~arch-ia64-remove-references-to-cpu__map arch/ia64/kernel/topology.c
--- a/arch/ia64/kernel/topology.c~arch-ia64-remove-references-to-cpu__map
+++ a/arch/ia64/kernel/topology.c
@@ -220,7 +220,8 @@ static ssize_t show_shared_cpu_map(struc
 	ssize_t	len;
 	cpumask_t shared_cpu_map;
 
-	cpus_and(shared_cpu_map, this_leaf->shared_cpu_map, cpu_online_map);
+	cpumask_and(&shared_cpu_map,
+				&this_leaf->shared_cpu_map, cpu_online_mask);
 	len = cpumask_scnprintf(buf, NR_CPUS+1, &shared_cpu_map);
 	len += sprintf(buf+len, "\n");
 	return len;
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

origin.patch
nohz-fix-idle-ticks-in-cpu-summary-line-of-proc-stat.patch

