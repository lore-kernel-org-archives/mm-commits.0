From: akpm@linux-foundation.org
Subject: + tile-replace-mm-cpu_vm_mask-with-mm_cpumask.patch added to -mm tree
Date: Wed, 20 Apr 2011 14:12:03 -0700
Message-ID: <201104202112.p3KLC3NU027281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814Ab1DTVMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 17:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cmetcalf@tilera.com, dhowells@redhat.com, hughd@google.com, yasutake.koichi@jp.panasonic.com


The patch titled
     tile: replace mm->cpu_vm_mask with mm_cpumask()
has been added to the -mm tree.  Its filename is
     tile-replace-mm-cpu_vm_mask-with-mm_cpumask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

