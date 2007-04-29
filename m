From: akpm@linux-foundation.org
Subject: + vmstat-use-our-own-timer-events.patch added to -mm tree
Date: Sun, 29 Apr 2007 02:31:31 -0700
Message-ID: <200704290931.l3T9VV7h012940@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093AbXD2Jbp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Apr 2007 05:31:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, arjan@linux.intel.com


The patch titled
     vmstat: use our own timer events
has been added to the -mm tree.  Its filename is
     vmstat-use-our-own-timer-events.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    3 ---
 mm/slab.c              |    1 -
 mm/slub.c              |    1 -
 mm/vmstat.c            |   39 +++++++++++++++++++++++++++++++++++----
 4 files changed, 35 insertions(+), 9 deletions(-)

diff -puN include/linux/vmstat.h~vmstat-use-our-own-timer-events include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmstat-use-our-own-timer-events
+++ a/include/linux/vmstat.h
@@ -213,8 +213,6 @@ extern void dec_zone_state(struct zone *
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
 void refresh_cpu_vm_stats(int);
-void refresh_vm_stats(void);
-
 #else /* CONFIG_SMP */
 
 /*
@@ -261,7 +259,6 @@ static inline void __dec_zone_page_state
 #define mod_zone_page_state __mod_zone_page_state
 
 static inline void refresh_cpu_vm_stats(int cpu) { }
-static inline void refresh_vm_stats(void) { }
 #endif
 
 #endif /* _LINUX_VMSTAT_H */
diff -puN mm/slab.c~vmstat-use-our-own-timer-events mm/slab.c
--- a/mm/slab.c~vmstat-use-our-own-timer-events
+++ a/mm/slab.c
@@ -4155,7 +4155,6 @@ next:
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
@@ -2515,7 +2515,6 @@ static DEFINE_PER_CPU(struct delayed_wor
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
@@ -648,11 +664,21 @@ static int __cpuinit vmstat_cpuup_callba
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
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+		start_cpu_timer(cpu);
+		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		refresh_zone_stat_thresholds();
@@ -668,8 +694,13 @@ static struct notifier_block __cpuinitda
 
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

extend-print_symbol-capability.patch
slab-introduce-krealloc.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix-2.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-core-conform-more-to-slabs-slab_hwcache_align-behavior.patch
slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation.patch
slub-core-sysfs-support-fix-unique-id-generation.patch
slub-core-printk-cleanup-object_err.patch
slub-core-printk-cleanup-add-slab_err.patch
slub-core-printk-cleanup-fix-up-printks-in-the-resiliency-check.patch
slub-core-fix-slab-validation-error-in-bootstrap-cache.patch
slub-core-remove-per-cpu-flusher.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-enable-tracking-of-full-slabs-add-checks-for-interrupts-disabled.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-validation-of-slabs-metadata-and-guard-zones-fix-pageerror-checks-during-validation.patch
slub-validation-of-slabs-metadata-and-guard-zones-remove-duplicate-vm_bug_on.patch
slub-validation-of-slabs-metadata-and-guard-zones-printk-cleanup-slab-validation-printks.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink-fixes-to-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-remove-object-activities-out-of-checking-functions-printk-cleanup-diagnostic-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
slub-major-slabinfo-update.patch
slub-slabinfo-remove-hackname.patch
slub-slabinfo-more-statistic-fixes-and-handling-fixes.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion-fix.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_debug_initial-flag-locks-fix.patch
slab-allocators-remove-multiple-alignment-specifications.patch
slab-allocators-remove-slab_ctor_atomic.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slub-i386-support.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
readahead-state-based-method-aging-accounting.patch
