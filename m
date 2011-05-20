From: akpm@linux-foundation.org
Subject: + vmscan-implement-swap-token-trace.patch added to -mm tree
Date: Fri, 20 May 2011 12:30:16 -0700
Message-ID: <201105201930.p4KJUG0L026160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934207Ab1ETTax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 May 2011 15:30:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     vmscan: implement swap token trace
has been added to the -mm tree.  Its filename is
     vmscan-implement-swap-token-trace.patch

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
Subject: vmscan: implement swap token trace
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

This is useful for observing swap token activity.

example output:

             zsh-1845  [000]   598.962716: update_swap_token_priority:
mm=ffff88015eaf7700 old_prio=1 new_prio=0
          memtoy-1830  [001]   602.033900: update_swap_token_priority:
mm=ffff880037a45880 old_prio=947 new_prio=949
          memtoy-1830  [000]   602.041509: update_swap_token_priority:
mm=ffff880037a45880 old_prio=949 new_prio=951
          memtoy-1830  [000]   602.051959: update_swap_token_priority:
mm=ffff880037a45880 old_prio=951 new_prio=953
          memtoy-1830  [000]   602.052188: update_swap_token_priority:
mm=ffff880037a45880 old_prio=953 new_prio=955
          memtoy-1830  [001]   602.427184: put_swap_token:
token_mm=ffff880037a45880
             zsh-1789  [000]   602.427281: replace_swap_token:
old_token_mm=          (null) old_prio=0 new_token_mm=ffff88015eaf7018
new_prio=2
             zsh-1789  [001]   602.433456: update_swap_token_priority:
mm=ffff88015eaf7018 old_prio=2 new_prio=4
             zsh-1789  [000]   602.437613: update_swap_token_priority:
mm=ffff88015eaf7018 old_prio=4 new_prio=6
             zsh-1789  [000]   602.443924: update_swap_token_priority:
mm=ffff88015eaf7018 old_prio=6 new_prio=8
             zsh-1789  [000]   602.451873: update_swap_token_priority:
mm=ffff88015eaf7018 old_prio=8 new_prio=10
             zsh-1789  [001]   602.462639: update_swap_token_priority:
mm=ffff88015eaf7018 old_prio=10 new_prio=12

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel<riel@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   77 ++++++++++++++++++++++++++++++++
 mm/thrash.c                   |   11 ++++
 2 files changed, 87 insertions(+), 1 deletion(-)

diff -puN include/trace/events/vmscan.h~vmscan-implement-swap-token-trace include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~vmscan-implement-swap-token-trace
+++ a/include/trace/events/vmscan.h
@@ -6,6 +6,8 @@
 
 #include <linux/types.h>
 #include <linux/tracepoint.h>
+#include <linux/mm.h>
+#include <linux/memcontrol.h>
 #include "gfpflags.h"
 
 #define RECLAIM_WB_ANON		0x0001u
@@ -310,6 +312,81 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 		show_reclaim_flags(__entry->reclaim_flags))
 );
 
+TRACE_EVENT(replace_swap_token,
+	TP_PROTO(struct mm_struct *old_mm,
+		 struct mm_struct *new_mm),
+
+	TP_ARGS(old_mm, new_mm),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct*,	old_mm)
+		__field(unsigned int,		old_prio)
+		__field(struct mm_struct*,	new_mm)
+		__field(unsigned int,		new_prio)
+	),
+
+	TP_fast_assign(
+		__entry->old_mm   = old_mm;
+		__entry->old_prio = old_mm ? old_mm->token_priority : 0;
+		__entry->new_mm   = new_mm;
+		__entry->new_prio = new_mm->token_priority;
+	),
+
+	TP_printk("old_token_mm=%p old_prio=%u new_token_mm=%p new_prio=%u",
+		  __entry->old_mm, __entry->old_prio,
+		  __entry->new_mm, __entry->new_prio)
+);
+
+DECLARE_EVENT_CLASS(put_swap_token_template,
+	TP_PROTO(struct mm_struct *swap_token_mm),
+
+	TP_ARGS(swap_token_mm),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct*, swap_token_mm)
+	),
+
+	TP_fast_assign(
+		__entry->swap_token_mm = swap_token_mm;
+	),
+
+	TP_printk("token_mm=%p", __entry->swap_token_mm)
+);
+
+DEFINE_EVENT(put_swap_token_template, put_swap_token,
+	TP_PROTO(struct mm_struct *swap_token_mm),
+	TP_ARGS(swap_token_mm)
+);
+
+DEFINE_EVENT_CONDITION(put_swap_token_template, disable_swap_token,
+	TP_PROTO(struct mm_struct *swap_token_mm),
+	TP_ARGS(swap_token_mm),
+	TP_CONDITION(swap_token_mm != NULL)
+);
+
+TRACE_EVENT_CONDITION(update_swap_token_priority,
+	TP_PROTO(struct mm_struct *mm,
+		 unsigned int old_prio),
+
+	TP_ARGS(mm, old_prio),
+
+	TP_CONDITION(mm->token_priority != old_prio),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct*, mm)
+		__field(unsigned int, old_prio)
+		__field(unsigned int, new_prio)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->old_prio = old_prio;
+		__entry->new_prio = mm->token_priority;
+	),
+
+	TP_printk("mm=%p old_prio=%u new_prio=%u",
+		  __entry->mm, __entry->old_prio, __entry->new_prio)
+);
 
 #endif /* _TRACE_VMSCAN_H */
 
diff -puN mm/thrash.c~vmscan-implement-swap-token-trace mm/thrash.c
--- a/mm/thrash.c~vmscan-implement-swap-token-trace
+++ a/mm/thrash.c
@@ -23,6 +23,8 @@
 #include <linux/swap.h>
 #include <linux/memcontrol.h>
 
+#include <trace/events/vmscan.h>
+
 static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
 struct mem_cgroup *swap_token_memcg;
@@ -31,6 +33,7 @@ static unsigned int global_faults;
 void grab_swap_token(struct mm_struct *mm)
 {
 	int current_interval;
+	unsigned int old_prio = mm->token_priority;
 	struct mem_cgroup *memcg;
 
 	global_faults++;
@@ -46,7 +49,7 @@ void grab_swap_token(struct mm_struct *m
 
 	if (mm == swap_token_mm) {
 		mm->token_priority += 2;
-		goto out;
+		goto update_priority;
 	}
 
 	if (current_interval < mm->last_interval)
@@ -60,6 +63,9 @@ void grab_swap_token(struct mm_struct *m
 	if (mm->token_priority > swap_token_mm->token_priority)
 		goto replace_token;
 
+update_priority:
+	trace_update_swap_token_priority(mm, old_prio);
+
 out:
 	mm->faultstamp = global_faults;
 	mm->last_interval = current_interval;
@@ -71,6 +77,7 @@ replace_token:
 	memcg = try_get_mem_cgroup_from_mm(mm);
 	if (memcg)
 		css_put(mem_cgroup_css(memcg));
+	trace_replace_swap_token(swap_token_mm, mm);
 	swap_token_mm = mm;
 	swap_token_memcg = memcg;
 	goto out;
@@ -81,6 +88,7 @@ void __put_swap_token(struct mm_struct *
 {
 	spin_lock(&swap_token_lock);
 	if (likely(mm == swap_token_mm)) {
+		trace_put_swap_token(swap_token_mm);
 		swap_token_mm = NULL;
 		swap_token_memcg = NULL;
 	}
@@ -104,6 +112,7 @@ void disable_swap_token(struct mem_cgrou
 	if (match_memcg(memcg, swap_token_memcg)) {
 		spin_lock(&swap_token_lock);
 		if (match_memcg(memcg, swap_token_memcg)) {
+			trace_disable_swap_token(swap_token_mm);
 			swap_token_mm = NULL;
 			swap_token_memcg = NULL;
 		}
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
slab-use-numa_no_node.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix-2.patch
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
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch
mm-filter-unevictable-page-out-in-deactivate_page.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured.patch
mm-export-get_vma_policy.patch
mm-use-walk_page_range-instead-of-custom-page-table-walking-code.patch
mm-remove-mpol_mf_stats.patch
mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch
mm-remove-check_huge_range.patch
mm-declare-mpol_to_str-when-config_tmpfs=n.patch
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
getdelays-show-average-cpu-io-swap-reclaim-delays.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
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

