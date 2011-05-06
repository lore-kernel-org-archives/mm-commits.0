From: akpm@linux-foundation.org
Subject: [merged] tile-replace-mm-cpu_vm_mask-with-mm_cpumask.patch removed from -mm tree
Date: Fri, 06 May 2011 12:54:26 -0700
Message-ID: <201105061947.p46JlrNj000310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932602Ab1EFTsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2011 15:48:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cmetcalf@tilera.com, dhowells@redhat.com, hughd@google.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     tile: replace mm->cpu_vm_mask with mm_cpumask()
has been removed from the -mm tree.  Its filename was
     tile-replace-mm-cpu_vm_mask-with-mm_cpumask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tile: replace mm->cpu_vm_mask with mm_cpumask()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

We plan to change mm->cpu_vm_mask definition later. Thus, this patch convert
it into proper macro.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/mmu_context.h |    4 ++--
 arch/tile/kernel/tlb.c              |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/tile/include/asm/mmu_context.h~tile-replace-mm-cpu_vm_mask-with-mm_cpumask arch/tile/include/asm/mmu_context.h
--- a/arch/tile/include/asm/mmu_context.h~tile-replace-mm-cpu_vm_mask-with-mm_cpumask
+++ a/arch/tile/include/asm/mmu_context.h
@@ -100,8 +100,8 @@ static inline void switch_mm(struct mm_s
 		__get_cpu_var(current_asid) = asid;
 
 		/* Clear cpu from the old mm, and set it in the new one. */
-		cpumask_clear_cpu(cpu, &prev->cpu_vm_mask);
-		cpumask_set_cpu(cpu, &next->cpu_vm_mask);
+		cpumask_clear_cpu(cpu, mm_cpumask(prev));
+		cpumask_set_cpu(cpu, mm_cpumask(next));
 
 		/* Re-load page tables */
 		install_page_table(next->pgd, asid);
diff -puN arch/tile/kernel/tlb.c~tile-replace-mm-cpu_vm_mask-with-mm_cpumask arch/tile/kernel/tlb.c
--- a/arch/tile/kernel/tlb.c~tile-replace-mm-cpu_vm_mask-with-mm_cpumask
+++ a/arch/tile/kernel/tlb.c
@@ -34,13 +34,13 @@ void flush_tlb_mm(struct mm_struct *mm)
 {
 	HV_Remote_ASID asids[NR_CPUS];
 	int i = 0, cpu;
-	for_each_cpu(cpu, &mm->cpu_vm_mask) {
+	for_each_cpu(cpu, mm_cpumask(mm)) {
 		HV_Remote_ASID *asid = &asids[i++];
 		asid->y = cpu / smp_topology.width;
 		asid->x = cpu % smp_topology.width;
 		asid->asid = per_cpu(current_asid, cpu);
 	}
-	flush_remote(0, HV_FLUSH_EVICT_L1I, &mm->cpu_vm_mask,
+	flush_remote(0, HV_FLUSH_EVICT_L1I, mm_cpumask(mm),
 		     0, 0, 0, NULL, asids, i);
 }
 
@@ -54,8 +54,8 @@ void flush_tlb_page_mm(const struct vm_a
 {
 	unsigned long size = hv_page_size(vma);
 	int cache = (vma->vm_flags & VM_EXEC) ? HV_FLUSH_EVICT_L1I : 0;
-	flush_remote(0, cache, &mm->cpu_vm_mask,
-		     va, size, size, &mm->cpu_vm_mask, NULL, 0);
+	flush_remote(0, cache, mm_cpumask(mm),
+		     va, size, size, mm_cpumask(mm), NULL, 0);
 }
 
 void flush_tlb_page(const struct vm_area_struct *vma, unsigned long va)
@@ -70,8 +70,8 @@ void flush_tlb_range(const struct vm_are
 	unsigned long size = hv_page_size(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	int cache = (vma->vm_flags & VM_EXEC) ? HV_FLUSH_EVICT_L1I : 0;
-	flush_remote(0, cache, &mm->cpu_vm_mask, start, end - start, size,
-		     &mm->cpu_vm_mask, NULL, 0);
+	flush_remote(0, cache, mm_cpumask(mm), start, end - start, size,
+		     mm_cpumask(mm), NULL, 0);
 }
 
 void flush_tlb_all(void)
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
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch
mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch
mm-strictly-require-elevated-page-refcount-in-isolate_lru_page.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix-2.patch
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
mn10300-convert-old-cpumask-api-into-new-one.patch
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
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

