From: akpm@linux-foundation.org
Subject: [nacked] parisc-enable-config_numa-for-discontigmem-and-fix-build-errors.patch removed from -mm tree
Date: Fri, 22 Apr 2011 13:36:38 -0700
Message-ID: <201104222036.p3MKadjV030860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894Ab1DVUhQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Apr 2011 16:37:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, deller@gmx.de, jejb@parisc-linux.org, kyle@mcmartin.ca, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     parisc: enable CONFIG_NUMA for DISCONTIGMEM and fix build errors
has been removed from the -mm tree.  Its filename was
     parisc-enable-config_numa-for-discontigmem-and-fix-build-errors.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parisc: enable CONFIG_NUMA for DISCONTIGMEM and fix build errors
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

CONFIG_DISCONTIGMEM requires CONFIG_NUMA because it represents its memory
regions as individual nodes that lack remote proximity, hence it already
has a default CONFIG_NODES_SHIFT of 3.

This configuration causes build errors, however, so fix them as well.

This was first realized when CONFIG_DISCONTIGMEM was used with CONFIG_SLUB
which depends heavily on CONFIG_NUMA being enabled or disabled to support
these memory regions.

A long-term fix is to separate the memory region abstraction required for
DISCONTIGMEM away from NUMA and then build NUMA on top of it with
proximity domains.

[rientjes@google.com: implicitly enable NUMA for DISCONTIGMEM, changelog]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <jejb@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/Kconfig            |    3 +++
 include/asm-generic/topology.h |    4 ----
 include/linux/topology.h       |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff -puN arch/parisc/Kconfig~parisc-enable-config_numa-for-discontigmem-and-fix-build-errors arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~parisc-enable-config_numa-for-discontigmem-and-fix-build-errors
+++ a/arch/parisc/Kconfig
@@ -244,6 +244,9 @@ config ARCH_DISCONTIGMEM_DEFAULT
 	def_bool y
 	depends on ARCH_DISCONTIGMEM_ENABLE
 
+config NUMA
+	def_bool ARCH_DISCONTIGMEM_ENABLE
+
 config NODES_SHIFT
 	int
 	default "3"
diff -puN include/asm-generic/topology.h~parisc-enable-config_numa-for-discontigmem-and-fix-build-errors include/asm-generic/topology.h
--- a/include/asm-generic/topology.h~parisc-enable-config_numa-for-discontigmem-and-fix-build-errors
+++ a/include/asm-generic/topology.h
@@ -27,8 +27,6 @@
 #ifndef _ASM_GENERIC_TOPOLOGY_H
 #define _ASM_GENERIC_TOPOLOGY_H
 
-#ifndef	CONFIG_NUMA
-
 /* Other architectures wishing to use this simple topology API should fill
    in the below functions as appropriate in their own <asm/topology.h> file. */
 #ifndef cpu_to_node
@@ -60,8 +58,6 @@
 				 cpumask_of_node(pcibus_to_node(bus)))
 #endif
 
-#endif	/* CONFIG_NUMA */
-
 #if !defined(CONFIG_NUMA) || !defined(CONFIG_HAVE_MEMORYLESS_NODES)
 
 #ifndef set_numa_mem
diff -puN include/linux/topology.h~parisc-enable-config_numa-for-discontigmem-and-fix-build-errors include/linux/topology.h
--- a/include/linux/topology.h~parisc-enable-config_numa-for-discontigmem-and-fix-build-errors
+++ a/include/linux/topology.h
@@ -209,7 +209,7 @@ int arch_update_cpu_topology(void);
 
 #ifdef CONFIG_NUMA
 #ifndef SD_NODE_INIT
-#error Please define an appropriate SD_NODE_INIT in include/asm/topology.h!!!
+#define SD_NODE_INIT SD_ALLNODES_INIT
 #endif
 
 #endif /* CONFIG_NUMA */
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
oom-use-pte-pages-in-oom-score.patch
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
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch
mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch
mm-strictly-require-elevated-page-refcount-in-isolate_lru_page.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
sparse-define-dummy-build_bug_on-definition-for-sparse.patch
sparse-define-__must_be_array-for-__checker__.patch
sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

