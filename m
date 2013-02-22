From: akpm@linux-foundation.org
Subject: [folded-merged] cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:43:29 -0800
Message-ID: <20130222234329.716D431C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:63528 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab3BVXnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:43:31 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so120547yen.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:43:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, mingo@redhat.com, peterz@infradead.org, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix
has been removed from the -mm tree.  Its filename was
     cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch

This patch was dropped because it was folded into cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix

numa_clear_node() and numa_set_node() can no longer be __cpuinit.

WARNING: vmlinux.o(.text+0x222702): Section mismatch in reference from the function check_and_unmap_cpu_on_node() to the function .cpuinit.text:numa_clear_node()
The function check_and_unmap_cpu_on_node() references
the function __cpuinit numa_clear_node().
This is often because check_and_unmap_cpu_on_node lacks a __cpuinit 
annotation or the annotation of numa_clear_node is wrong.


Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/numa.h |    4 ++--
 arch/x86/mm/numa.c          |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/numa.h~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix arch/x86/include/asm/numa.h
--- a/arch/x86/include/asm/numa.h~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix
+++ a/arch/x86/include/asm/numa.h
@@ -57,8 +57,8 @@ static inline int numa_cpu_node(int cpu)
 #endif
 
 #ifdef CONFIG_NUMA
-extern void __cpuinit numa_set_node(int cpu, int node);
-extern void __cpuinit numa_clear_node(int cpu);
+extern void numa_set_node(int cpu, int node);
+extern void numa_clear_node(int cpu);
 extern void __init init_cpu_to_node(void);
 extern void __cpuinit numa_add_cpu(int cpu);
 extern void __cpuinit numa_remove_cpu(int cpu);
diff -puN arch/x86/mm/numa.c~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix
+++ a/arch/x86/mm/numa.c
@@ -78,7 +78,7 @@ EXPORT_SYMBOL(node_to_cpumask_map);
 DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
 
-void __cpuinit numa_set_node(int cpu, int node)
+void numa_set_node(int cpu, int node)
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
 
@@ -100,7 +100,7 @@ void __cpuinit numa_set_node(int cpu, in
 	set_cpu_numa_node(cpu, node);
 }
 
-void __cpuinit numa_clear_node(int cpu)
+void numa_clear_node(int cpu)
 {
 	numa_set_node(cpu, NUMA_NO_NODE);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
tmpfs-fix-mempolicy-object-leaks-fix.patch

