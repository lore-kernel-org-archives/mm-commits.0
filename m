From: akpm@linux-foundation.org
Subject: [to-be-updated] mn10300-replace-mm-cpu_vm_mask-with-mm_cpumask.patch removed from -mm tree
Date: Thu, 05 May 2011 12:53:32 -0700
Message-ID: <201105051953.p45JrWoI031672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961Ab1EETxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2011 15:53:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cmetcalf@tilera.com, dhowells@redhat.com, hughd@google.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: replace mm->cpu_vm_mask with mm_cpumask
has been removed from the -mm tree.  Its filename was
     mn10300-replace-mm-cpu_vm_mask-with-mm_cpumask.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: replace mm->cpu_vm_mask with mm_cpumask
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

We plan to change mm->cpu_vm_mask definition later.  Thus this patch
convert it into mm_cpumask().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/smp.c |    2 +-
 arch/mn10300/mm/tlb-smp.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/mn10300/kernel/smp.c~mn10300-replace-mm-cpu_vm_mask-with-mm_cpumask arch/mn10300/kernel/smp.c
--- a/arch/mn10300/kernel/smp.c~mn10300-replace-mm-cpu_vm_mask-with-mm_cpumask
+++ a/arch/mn10300/kernel/smp.c
@@ -986,7 +986,7 @@ int __cpu_disable(void)
 		return -EBUSY;
 
 	migrate_irqs();
-	cpu_clear(cpu, current->active_mm->cpu_vm_mask);
+	cpu_clear(cpu, mm_cpumask(current->active_mm));
 	return 0;
 }
 
diff -puN arch/mn10300/mm/tlb-smp.c~mn10300-replace-mm-cpu_vm_mask-with-mm_cpumask arch/mn10300/mm/tlb-smp.c
--- a/arch/mn10300/mm/tlb-smp.c~mn10300-replace-mm-cpu_vm_mask-with-mm_cpumask
+++ a/arch/mn10300/mm/tlb-smp.c
@@ -146,7 +146,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
+	cpu_mask = mm_cpumask(mm);
 	cpu_clear(smp_processor_id(), cpu_mask);
 
 	local_flush_tlb();
@@ -165,7 +165,7 @@ void flush_tlb_current_task(void)
 	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
+	cpu_mask = mm_cpumask(mm);
 	cpu_clear(smp_processor_id(), cpu_mask);
 
 	local_flush_tlb();
@@ -186,7 +186,7 @@ void flush_tlb_page(struct vm_area_struc
 	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
+	cpu_mask = mm_cpumask(mm);
 	cpu_clear(smp_processor_id(), cpu_mask);
 
 	local_flush_tlb_page(mm, va);
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
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
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

