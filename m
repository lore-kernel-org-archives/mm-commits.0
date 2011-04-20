From: akpm@linux-foundation.org
Subject: + mn10300-replace-mm-cpu_vm_mask-with-mm_cpumask.patch added to -mm tree
Date: Wed, 20 Apr 2011 14:12:00 -0700
Message-ID: <201104202112.p3KLC0CO027269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814Ab1DTVMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 17:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cmetcalf@tilera.com, dhowells@redhat.com, hughd@google.com, yasutake.koichi@jp.panasonic.com


The patch titled
     mn10300: replace mm->cpu_vm_mask with mm_cpumask
has been added to the -mm tree.  Its filename is
     mn10300-replace-mm-cpu_vm_mask-with-mm_cpumask.patch

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

