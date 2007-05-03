From: akpm@linux-foundation.org
Subject: + make-vm-statistics-update-interval-configurable.patch added to -mm tree
Date: Wed, 02 May 2007 22:39:42 -0700
Message-ID: <200705030539.l435dg6j005668@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767401AbXECFju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 01:39:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Make vm statistics update interval configurable
has been added to the -mm tree.  Its filename is
     make-vm-statistics-update-interval-configurable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make vm statistics update interval configurable
From: Christoph Lameter <clameter@sgi.com>

Make it configurable.  Code in mm makes the vm statistics intervals
independent from the cache reaper use that opportunity to make it
configurable.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   19 +++++++++++++++++++
 include/linux/sysctl.h      |    1 +
 kernel/sysctl.c             |   12 ++++++++++++
 mm/vmstat.c                 |    4 +++-
 4 files changed, 35 insertions(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~make-vm-statistics-update-interval-configurable Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~make-vm-statistics-update-interval-configurable
+++ a/Documentation/sysctl/vm.txt
@@ -32,6 +32,7 @@ Currently, these files are in /proc/sys/
 - min_slab_ratio
 - panic_on_oom
 - swap_prefetch
+- stat_interval
 
 ==============================================================
 
@@ -229,3 +230,21 @@ copying back pages from swap into the sw
 practice it can take many minutes before the vm is idle enough.
 
 The default value is 1.
+
+================================================================
+
+stat_interval
+
+The period (seconds) in which the vm statistics are consolidated if the
+kernel supports SMP. Differentials to VM statistics are kept in per cpu
+fields and are only consolidated with per zone and global counters if the
+differentials cross certain limits. This limits the frequency of global
+updates and results in good scaling of the VM counters. However, if those
+counters are below the limits then the global and per zone counters are
+off by that value.  So we should consolidate the counters at some point.
+So the kernel runs a statistics update at regular intervals to consolidate
+the per cpu differentials that are below the update limits. The interval
+determines the frequency of these consolidations.
+
+The default value is 1 second.
+
diff -puN include/linux/sysctl.h~make-vm-statistics-update-interval-configurable include/linux/sysctl.h
--- a/include/linux/sysctl.h~make-vm-statistics-update-interval-configurable
+++ a/include/linux/sysctl.h
@@ -208,6 +208,7 @@ enum
 	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
 	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
 	VM_HUGETLB_TREAT_MOVABLE=36, /* Allocate hugepages from ZONE_MOVABLE */
+	VM_STAT_INTERVAL=37,	/* Statistics timer */
 
 	/* s390 vm cmm sysctls */
 	VM_CMM_PAGES=1111,
diff -puN kernel/sysctl.c~make-vm-statistics-update-interval-configurable kernel/sysctl.c
--- a/kernel/sysctl.c~make-vm-statistics-update-interval-configurable
+++ a/kernel/sysctl.c
@@ -78,6 +78,7 @@ extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int maps_protect;
+extern int sysctl_stat_interval;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -866,6 +867,17 @@ static ctl_table vm_table[] = {
 		.extra2		= &one_hundred,
 	},
 #endif
+#ifdef CONFIG_SMP
+	{
+		.ctl_name	= VM_STAT_INTERVAL,
+		.procname	= "stat_interval",
+		.data		= &sysctl_stat_interval,
+		.maxlen		= sizeof(sysctl_stat_interval),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+		.strategy	= &sysctl_jiffies,
+	},
+#endif
 #if defined(CONFIG_X86_32) || \
    (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
 	{
diff -puN mm/vmstat.c~make-vm-statistics-update-interval-configurable mm/vmstat.c
--- a/mm/vmstat.c~make-vm-statistics-update-interval-configurable
+++ a/mm/vmstat.c
@@ -641,11 +641,13 @@ const struct seq_operations vmstat_op = 
 
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
+int sysctl_stat_interval __read_mostly = HZ;
 
 static void vmstat_update(struct work_struct *w)
 {
 	refresh_cpu_vm_stats(smp_processor_id());
-	schedule_delayed_work(&__get_cpu_var(vmstat_work), HZ);
+	schedule_delayed_work(&__get_cpu_var(vmstat_work),
+		sysctl_stat_interval);
 }
 
 static void __devinit start_cpu_timer(int cpu)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-introduce-krealloc.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
make-page-private-usable-in-compound-pages-v1.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-add-slabinfo-tool.patch
quicklists-for-page-table-pages.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-multiple-alignment-specifications.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_ctor_atomic.patch
slab-allocators-remove-useless-__gfp_no_grow-flag.patch
page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
readahead-state-based-method-aging-accounting.patch
make-vm-statistics-update-interval-configurable-fix.patch
