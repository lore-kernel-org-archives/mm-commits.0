From: akpm@linux-foundation.org
Subject: + m32r-remove-redundant-declaration.patch added to -mm tree
Date: Mon, 25 Apr 2011 14:50:57 -0700
Message-ID: <201104252150.p3PLovRI012610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888Ab1DYVy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Apr 2011 17:54:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, takata@linux-m32r.org


The patch titled
     m32r: remove redundant declaration
has been added to the -mm tree.  Its filename is
     m32r-remove-redundant-declaration.patch

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
Subject: m32r: remove redundant declaration
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

They has no meanings.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/smp.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN arch/m32r/kernel/smp.c~m32r-remove-redundant-declaration arch/m32r/kernel/smp.c
--- a/arch/m32r/kernel/smp.c~m32r-remove-redundant-declaration
+++ a/arch/m32r/kernel/smp.c
@@ -30,6 +30,7 @@
 #include <asm/io.h>
 #include <asm/mmu_context.h>
 #include <asm/m32r.h>
+#include <asm/tlbflush.h>
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 /* Data structures and variables                                             */
@@ -61,27 +62,17 @@ extern spinlock_t ipi_lock[];
 /* Function Prototypes                                                       */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
-void smp_send_reschedule(int);
 void smp_reschedule_interrupt(void);
-
-void smp_flush_cache_all(void);
 void smp_flush_cache_all_interrupt(void);
 
-void smp_flush_tlb_all(void);
 static void flush_tlb_all_ipi(void *);
-
-void smp_flush_tlb_mm(struct mm_struct *);
-void smp_flush_tlb_range(struct vm_area_struct *, unsigned long, \
-	unsigned long);
-void smp_flush_tlb_page(struct vm_area_struct *, unsigned long);
 static void flush_tlb_others(cpumask_t, struct mm_struct *,
 	struct vm_area_struct *, unsigned long);
+
 void smp_invalidate_interrupt(void);
 
-void smp_send_stop(void);
 static void stop_this_cpu(void *);
 
-void smp_send_timer(void);
 void smp_ipi_timer_interrupt(struct pt_regs *);
 void smp_local_timer_interrupt(void);
 
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
alpha-replace-with-new-cpumask-apis.patch
m32r-convert-cpumask-api.patch
m32r-fix-spin_lock_irqsave-misuse.patch
m32r-remove-redundant-declaration.patch
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
proc-put-check_mem_permission-before-__get_free_page-in-mem_read.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

