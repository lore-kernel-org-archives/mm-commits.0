From: akpm@linux-foundation.org
Subject: + vmscan-implement-swap-token-priority-aging.patch added to -mm tree
Date: Fri, 20 May 2011 12:30:18 -0700
Message-ID: <201105201930.p4KJUI2R026163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934207Ab1ETTaz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 May 2011 15:30:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     vmscan: implement swap token priority aging
has been added to the -mm tree.  Its filename is
     vmscan-implement-swap-token-priority-aging.patch

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
Subject: vmscan: implement swap token priority aging
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

While testing for memcg aware swap token, I observed a swap token was
often grabbed an intermittent running process (eg init, auditd) and they
never release a token.

Why?

Some processes (eg init, auditd, audispd) wake up when a process exiting. 
And swap token can be get first page-in process when a process exiting
makes no swap token owner.  Thus such above intermittent running process
often get a token.

And currently, swap token priority is only decreased at page fault path. 
Then, if the process sleep immediately after to grab swap token, the swap
token priority never be decreased.  That's obviously undesirable.

This patch implement very poor (and lightweight) priority aging.  It only
be affect to the above corner case and doesn't change swap tendency
workload performance (eg multi process qsbench load)

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   20 +++++++++++++-------
 mm/thrash.c                   |   11 ++++++++++-
 2 files changed, 23 insertions(+), 8 deletions(-)

diff -puN include/trace/events/vmscan.h~vmscan-implement-swap-token-priority-aging include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~vmscan-implement-swap-token-priority-aging
+++ a/include/trace/events/vmscan.h
@@ -366,9 +366,10 @@ DEFINE_EVENT_CONDITION(put_swap_token_te
 
 TRACE_EVENT_CONDITION(update_swap_token_priority,
 	TP_PROTO(struct mm_struct *mm,
-		 unsigned int old_prio),
+		 unsigned int old_prio,
+		 struct mm_struct *swap_token_mm),
 
-	TP_ARGS(mm, old_prio),
+	TP_ARGS(mm, old_prio, swap_token_mm),
 
 	TP_CONDITION(mm->token_priority != old_prio),
 
@@ -376,16 +377,21 @@ TRACE_EVENT_CONDITION(update_swap_token_
 		__field(struct mm_struct*, mm)
 		__field(unsigned int, old_prio)
 		__field(unsigned int, new_prio)
+		__field(struct mm_struct*, swap_token_mm)
+		__field(unsigned int, swap_token_prio)
 	),
 
 	TP_fast_assign(
-		__entry->mm = mm;
-		__entry->old_prio = old_prio;
-		__entry->new_prio = mm->token_priority;
+		__entry->mm		= mm;
+		__entry->old_prio	= old_prio;
+		__entry->new_prio	= mm->token_priority;
+		__entry->swap_token_mm	= swap_token_mm;
+		__entry->swap_token_prio = swap_token_mm ? swap_token_mm->token_priority : 0;
 	),
 
-	TP_printk("mm=%p old_prio=%u new_prio=%u",
-		  __entry->mm, __entry->old_prio, __entry->new_prio)
+	TP_printk("mm=%p old_prio=%u new_prio=%u swap_token_mm=%p token_prio=%u",
+		  __entry->mm, __entry->old_prio, __entry->new_prio,
+		  __entry->swap_token_mm, __entry->swap_token_prio)
 );
 
 #endif /* _TRACE_VMSCAN_H */
diff -puN mm/thrash.c~vmscan-implement-swap-token-priority-aging mm/thrash.c
--- a/mm/thrash.c~vmscan-implement-swap-token-priority-aging
+++ a/mm/thrash.c
@@ -25,10 +25,13 @@
 
 #include <trace/events/vmscan.h>
 
+#define TOKEN_AGING_INTERVAL	(0xFF)
+
 static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
 struct mem_cgroup *swap_token_memcg;
 static unsigned int global_faults;
+static unsigned int last_aging;
 
 void grab_swap_token(struct mm_struct *mm)
 {
@@ -47,6 +50,11 @@ void grab_swap_token(struct mm_struct *m
 	if (!swap_token_mm)
 		goto replace_token;
 
+	if ((global_faults - last_aging) > TOKEN_AGING_INTERVAL) {
+		swap_token_mm->token_priority /= 2;
+		last_aging = global_faults;
+	}
+
 	if (mm == swap_token_mm) {
 		mm->token_priority += 2;
 		goto update_priority;
@@ -64,7 +72,7 @@ void grab_swap_token(struct mm_struct *m
 		goto replace_token;
 
 update_priority:
-	trace_update_swap_token_priority(mm, old_prio);
+	trace_update_swap_token_priority(mm, old_prio, swap_token_mm);
 
 out:
 	mm->faultstamp = global_faults;
@@ -80,6 +88,7 @@ replace_token:
 	trace_replace_swap_token(swap_token_mm, mm);
 	swap_token_mm = mm;
 	swap_token_memcg = memcg;
+	last_aging = global_faults;
 	goto out;
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

