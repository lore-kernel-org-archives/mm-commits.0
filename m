From: akpm@linux-foundation.org
Subject: - vmstat-use-our-own-timer-events.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:05 -0700
Message-ID: <200705092154.l49Ls5OV003137@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759163AbXEIVye (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:54:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, arjan@linux.intel.com, jirislaby@gmail.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     vmstat: use our own timer events
has been removed from the -mm tree.  Its filename was
     vmstat-use-our-own-timer-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vmstat: use our own timer events
From: Christoph Lameter <clameter@sgi.com>

vmstat is currently using the cache reaper to periodically bring the
statistics up to date.  The cache reaper does only exists in SLUB as a way to
provide compatibility with SLAB.  This patch removes the vmstat calls from the
slab allocators and provides its own handling.

The advantage is also that we can use a different frequency for the updates. 
Refreshing vm stats is a pretty fast job so we can run this every second and
stagger this by only one tick.  This will lead to some overlap in large
systems.  F.e a system running at 250 HZ with 1024 processors will have 4 vm
updates occurring at once.

However, the vm stats update only accesses per node information.  It is only
necessary to stagger the vm statistics updates per processor in each node.  Vm
counter updates occurring on distant nodes will not cause cacheline
contention.

We could implement an alternate approach that runs the first processor on each
node at the second and then each of the other processor on a node on a
subsequent tick.  That may be useful to keep a large amount of the second free
of timer activity.  Maybe the timer folks will have some feedback on this one?

[jirislaby@gmail.com: add missing break]
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    3 --
 mm/slab.c              |    1 
 mm/slub.c              |    1 
 mm/vmstat.c            |   40 +++++++++++++++++++++++++++++++++++----
 4 files changed, 36 insertions(+), 9 deletions(-)

diff -puN include/linux/vmstat.h~vmstat-use-our-own-timer-events include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmstat-use-our-own-timer-events
+++ a/include/linux/vmstat.h
@@ -212,8 +212,6 @@ extern void dec_zone_state(struct zone *
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
 void refresh_cpu_vm_stats(int);
-void refresh_vm_stats(void);
-
 #else /* CONFIG_SMP */
 
 /*
@@ -260,7 +258,6 @@ static inline void __dec_zone_page_state
 #define mod_zone_page_state __mod_zone_page_state
 
 static inline void refresh_cpu_vm_stats(int cpu) { }
-static inline void refresh_vm_stats(void) { }
 #endif
 
 #endif /* _LINUX_VMSTAT_H */
diff -puN mm/slab.c~vmstat-use-our-own-timer-events mm/slab.c
--- a/mm/slab.c~vmstat-use-our-own-timer-events
+++ a/mm/slab.c
@@ -4156,7 +4156,6 @@ next:
 	check_irq_on();
 	mutex_unlock(&cache_chain_mutex);
 	next_reap_node();
-	refresh_cpu_vm_stats(smp_processor_id());
 out:
 	/* Set up the next iteration */
 	schedule_delayed_work(work, round_jiffies_relative(REAPTIMEOUT_CPUC));
diff -puN mm/slub.c~vmstat-use-our-own-timer-events mm/slub.c
--- a/mm/slub.c~vmstat-use-our-own-timer-events
+++ a/mm/slub.c
@@ -2580,7 +2580,6 @@ static DEFINE_PER_CPU(struct delayed_wor
 static void cache_reap(struct work_struct *unused)
 {
 	next_reap_node();
-	refresh_cpu_vm_stats(smp_processor_id());
 	schedule_delayed_work(&__get_cpu_var(reap_work),
 				      REAPTIMEOUT_CPUC);
 }
diff -puN mm/vmstat.c~vmstat-use-our-own-timer-events mm/vmstat.c
--- a/mm/vmstat.c~vmstat-use-our-own-timer-events
+++ a/mm/vmstat.c
@@ -640,6 +640,22 @@ const struct seq_operations vmstat_op = 
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SMP
+static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
+
+static void vmstat_update(struct work_struct *w)
+{
+	refresh_cpu_vm_stats(smp_processor_id());
+	schedule_delayed_work(&__get_cpu_var(vmstat_work), HZ);
+}
+
+static void __devinit start_cpu_timer(int cpu)
+{
+	struct delayed_work *vmstat_work = &per_cpu(vmstat_work, cpu);
+
+	INIT_DELAYED_WORK(vmstat_work, vmstat_update);
+	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
+}
+
 /*
  * Use the cpu notifier to insure that the thresholds are recalculated
  * when necessary.
@@ -648,11 +664,22 @@ static int __cpuinit vmstat_cpuup_callba
 		unsigned long action,
 		void *hcpu)
 {
+	long cpu = (long)hcpu;
+
 	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		start_cpu_timer(cpu);
+		break;
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		cancel_rearming_delayed_work(&per_cpu(vmstat_work, cpu));
+		per_cpu(vmstat_work, cpu).work.func = NULL;
+		break;
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+		start_cpu_timer(cpu);
+		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		refresh_zone_stat_thresholds();
@@ -668,8 +695,13 @@ static struct notifier_block __cpuinitda
 
 int __init setup_vmstat(void)
 {
+	int cpu;
+
 	refresh_zone_stat_thresholds();
 	register_cpu_notifier(&vmstat_notifier);
+
+	for_each_online_cpu(cpu)
+		start_cpu_timer(cpu);
 	return 0;
 }
 module_init(setup_vmstat)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
