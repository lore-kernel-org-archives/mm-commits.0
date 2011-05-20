From: akpm@linux-foundation.org
Subject: + vmscanmemcg-memcg-aware-swap-token.patch added to -mm tree
Date: Fri, 20 May 2011 12:30:14 -0700
Message-ID: <201105201930.p4KJUF3a026157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935718Ab1ETTav (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 May 2011 15:30:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     vmscan,memcg: memcg aware swap token
has been added to the -mm tree.  Its filename is
     vmscanmemcg-memcg-aware-swap-token.patch

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
Subject: vmscan,memcg: memcg aware swap token
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, memcg reclaim can disable swap token even if the swap token mm
doesn't belong in its memory cgroup.  It's slightly risky.  If an admin
creates very small mem-cgroup and silly guy runs contentious heavy memory
pressure workload, every tasks are going to lose swap token and then
system may become unresponsive.  That's bad.

This patch adds 'memcg' parameter into disable_swap_token().  and if the
parameter doesn't match swap token, VM doesn't disable it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Rik van Riel<riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++
 include/linux/swap.h       |    8 ---
 mm/memcontrol.c            |   16 +++----
 mm/thrash.c                |   73 +++++++++++++++++++++++++----------
 mm/vmscan.c                |    4 -
 5 files changed, 71 insertions(+), 36 deletions(-)

diff -puN include/linux/memcontrol.h~vmscanmemcg-memcg-aware-swap-token include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscanmemcg-memcg-aware-swap-token
+++ a/include/linux/memcontrol.h
@@ -82,6 +82,7 @@ int task_in_mem_cgroup(struct task_struc
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
+extern struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm);
 
 static inline
 int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
@@ -243,6 +244,11 @@ static inline struct mem_cgroup *try_get
 	return NULL;
 }
 
+static inline struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
+{
+	return NULL;
+}
+
 static inline int mm_match_cgroup(struct mm_struct *mm, struct mem_cgroup *mem)
 {
 	return 1;
diff -puN include/linux/swap.h~vmscanmemcg-memcg-aware-swap-token include/linux/swap.h
--- a/include/linux/swap.h~vmscanmemcg-memcg-aware-swap-token
+++ a/include/linux/swap.h
@@ -358,6 +358,7 @@ struct backing_dev_info;
 extern struct mm_struct *swap_token_mm;
 extern void grab_swap_token(struct mm_struct *);
 extern void __put_swap_token(struct mm_struct *);
+extern void disable_swap_token(struct mem_cgroup *memcg);
 
 static inline int has_swap_token(struct mm_struct *mm)
 {
@@ -370,11 +371,6 @@ static inline void put_swap_token(struct
 		__put_swap_token(mm);
 }
 
-static inline void disable_swap_token(void)
-{
-	put_swap_token(swap_token_mm);
-}
-
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 extern void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
@@ -500,7 +496,7 @@ static inline int has_swap_token(struct 
 	return 0;
 }
 
-static inline void disable_swap_token(void)
+static inline void disable_swap_token(struct mem_cgroup *memcg)
 {
 }
 
diff -puN mm/memcontrol.c~vmscanmemcg-memcg-aware-swap-token mm/memcontrol.c
--- a/mm/memcontrol.c~vmscanmemcg-memcg-aware-swap-token
+++ a/mm/memcontrol.c
@@ -723,7 +723,7 @@ struct mem_cgroup *mem_cgroup_from_task(
 				struct mem_cgroup, css);
 }
 
-static struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
+struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *mem = NULL;
 
@@ -5212,18 +5212,16 @@ static void mem_cgroup_move_task(struct 
 				struct cgroup *old_cont,
 				struct task_struct *p)
 {
-	struct mm_struct *mm;
+	struct mm_struct *mm = get_task_mm(p);
 
-	if (!mc.to)
-		/* no need to move charge */
-		return;
-
-	mm = get_task_mm(p);
 	if (mm) {
-		mem_cgroup_move_charge(mm);
+		if (mc.to)
+			mem_cgroup_move_charge(mm);
+		put_swap_token(mm);
 		mmput(mm);
 	}
-	mem_cgroup_clear_mc();
+	if (mc.to)
+		mem_cgroup_clear_mc();
 }
 #else	/* !CONFIG_MMU */
 static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
diff -puN mm/thrash.c~vmscanmemcg-memcg-aware-swap-token mm/thrash.c
--- a/mm/thrash.c~vmscanmemcg-memcg-aware-swap-token
+++ a/mm/thrash.c
@@ -21,14 +21,17 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/swap.h>
+#include <linux/memcontrol.h>
 
 static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
+struct mem_cgroup *swap_token_memcg;
 static unsigned int global_faults;
 
 void grab_swap_token(struct mm_struct *mm)
 {
 	int current_interval;
+	struct mem_cgroup *memcg;
 
 	global_faults++;
 
@@ -38,40 +41,72 @@ void grab_swap_token(struct mm_struct *m
 		return;
 
 	/* First come first served */
-	if (swap_token_mm == NULL) {
-		mm->token_priority = mm->token_priority + 2;
-		swap_token_mm = mm;
+	if (!swap_token_mm)
+		goto replace_token;
+
+	if (mm == swap_token_mm) {
+		mm->token_priority += 2;
 		goto out;
 	}
 
-	if (mm != swap_token_mm) {
-		if (current_interval < mm->last_interval)
-			mm->token_priority++;
-		else {
-			if (likely(mm->token_priority > 0))
-				mm->token_priority--;
-		}
-		/* Check if we deserve the token */
-		if (mm->token_priority > swap_token_mm->token_priority) {
-			mm->token_priority += 2;
-			swap_token_mm = mm;
-		}
-	} else {
-		/* Token holder came in again! */
-		mm->token_priority += 2;
+	if (current_interval < mm->last_interval)
+		mm->token_priority++;
+	else {
+		if (likely(mm->token_priority > 0))
+			mm->token_priority--;
 	}
 
+	/* Check if we deserve the token */
+	if (mm->token_priority > swap_token_mm->token_priority)
+		goto replace_token;
+
 out:
 	mm->faultstamp = global_faults;
 	mm->last_interval = current_interval;
 	spin_unlock(&swap_token_lock);
+	return;
+
+replace_token:
+	mm->token_priority += 2;
+	memcg = try_get_mem_cgroup_from_mm(mm);
+	if (memcg)
+		css_put(mem_cgroup_css(memcg));
+	swap_token_mm = mm;
+	swap_token_memcg = memcg;
+	goto out;
 }
 
 /* Called on process exit. */
 void __put_swap_token(struct mm_struct *mm)
 {
 	spin_lock(&swap_token_lock);
-	if (likely(mm == swap_token_mm))
+	if (likely(mm == swap_token_mm)) {
 		swap_token_mm = NULL;
+		swap_token_memcg = NULL;
+	}
 	spin_unlock(&swap_token_lock);
 }
+
+static bool match_memcg(struct mem_cgroup *a, struct mem_cgroup *b)
+{
+	if (!a)
+		return true;
+	if (!b)
+		return true;
+	if (a == b)
+		return true;
+	return false;
+}
+
+void disable_swap_token(struct mem_cgroup *memcg)
+{
+	/* memcg reclaim don't disable unrelated mm token. */
+	if (match_memcg(memcg, swap_token_memcg)) {
+		spin_lock(&swap_token_lock);
+		if (match_memcg(memcg, swap_token_memcg)) {
+			swap_token_mm = NULL;
+			swap_token_memcg = NULL;
+		}
+		spin_unlock(&swap_token_lock);
+	}
+}
diff -puN mm/vmscan.c~vmscanmemcg-memcg-aware-swap-token mm/vmscan.c
--- a/mm/vmscan.c~vmscanmemcg-memcg-aware-swap-token
+++ a/mm/vmscan.c
@@ -2075,7 +2075,7 @@ static unsigned long do_try_to_free_page
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		sc->nr_scanned = 0;
 		if (!priority)
-			disable_swap_token();
+			disable_swap_token(sc->mem_cgroup);
 		total_scanned += shrink_zones(priority, zonelist, sc);
 		/*
 		 * Don't shrink slabs when reclaiming memory from
@@ -2405,7 +2405,7 @@ loop_again:
 
 		/* The swap token gets in the way of swapout... */
 		if (!priority)
-			disable_swap_token();
+			disable_swap_token(NULL);
 
 		all_zones_ok = 1;
 		balanced = 0;
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

