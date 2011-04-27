From: akpm@linux-foundation.org
Subject: [to-be-updated] vmscanmemcg-memcg-aware-swap-token.patch removed from -mm tree
Date: Tue, 26 Apr 2011 18:29:33 -0700
Message-ID: <201104270124.p3R1OTYW032517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab1D0BZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 21:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan,memcg: memcg aware swap token
has been removed from the -mm tree.  Its filename was
     vmscanmemcg-memcg-aware-swap-token.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan,memcg: memcg aware swap token
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, memcg reclaim can disable the swap token even if the swap token
mm doesn't belong to its memory cgroup.  It's slightly riskly.  If an
admin makes very small mem-cgroup and silly guy runs contenious heavy
memory pressure workloa, whole tasks in the system are going to lose
swap-token and then system may become unresponsive.  That's bad.

This patch adds 'memcg' parameter into disable_swap_token().  and if the
parameter doesn't match swap-token, VM doesn't put swap-token.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++++
 include/linux/swap.h       |   24 +++++++++++++++++-------
 mm/memcontrol.c            |    2 +-
 mm/thrash.c                |   17 +++++++++++++++++
 mm/vmscan.c                |    4 ++--
 5 files changed, 43 insertions(+), 10 deletions(-)

diff -puN include/linux/memcontrol.h~vmscanmemcg-memcg-aware-swap-token include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscanmemcg-memcg-aware-swap-token
+++ a/include/linux/memcontrol.h
@@ -84,6 +84,7 @@ int task_in_mem_cgroup(struct task_struc
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
+extern struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm);
 
 static inline
 int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
@@ -244,6 +245,11 @@ static inline struct mem_cgroup *try_get
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
@@ -358,21 +358,31 @@ struct backing_dev_info;
 extern struct mm_struct *swap_token_mm;
 extern void grab_swap_token(struct mm_struct *);
 extern void __put_swap_token(struct mm_struct *);
+extern int has_swap_token_memcg(struct mm_struct *mm, struct mem_cgroup *memcg);
 
-static inline int has_swap_token(struct mm_struct *mm)
+static inline
+int has_swap_token(struct mm_struct *mm)
 {
-	return (mm == swap_token_mm);
+	return has_swap_token_memcg(mm, NULL);
 }
 
-static inline void put_swap_token(struct mm_struct *mm)
+static inline
+void put_swap_token_memcg(struct mm_struct *mm, struct mem_cgroup *memcg)
 {
-	if (has_swap_token(mm))
+	if (has_swap_token_memcg(mm, memcg))
 		__put_swap_token(mm);
 }
 
-static inline void disable_swap_token(void)
+static inline
+void put_swap_token(struct mm_struct *mm)
+{
+	return put_swap_token_memcg(mm, NULL);
+}
+
+static inline
+void disable_swap_token(struct mem_cgroup *memcg)
 {
-	put_swap_token(swap_token_mm);
+	put_swap_token_memcg(swap_token_mm, memcg);
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
@@ -500,7 +510,7 @@ static inline int has_swap_token(struct 
 	return 0;
 }
 
-static inline void disable_swap_token(void)
+static inline void disable_swap_token(struct mem_cgroup *memcg)
 {
 }
 
diff -puN mm/memcontrol.c~vmscanmemcg-memcg-aware-swap-token mm/memcontrol.c
--- a/mm/memcontrol.c~vmscanmemcg-memcg-aware-swap-token
+++ a/mm/memcontrol.c
@@ -735,7 +735,7 @@ struct mem_cgroup *mem_cgroup_from_task(
 				struct mem_cgroup, css);
 }
 
-static struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
+struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *mem = NULL;
 
diff -puN mm/thrash.c~vmscanmemcg-memcg-aware-swap-token mm/thrash.c
--- a/mm/thrash.c~vmscanmemcg-memcg-aware-swap-token
+++ a/mm/thrash.c
@@ -21,6 +21,7 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/swap.h>
+#include <linux/memcontrol.h>
 
 static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
@@ -75,3 +76,19 @@ void __put_swap_token(struct mm_struct *
 		swap_token_mm = NULL;
 	spin_unlock(&swap_token_lock);
 }
+
+int has_swap_token_memcg(struct mm_struct *mm, struct mem_cgroup *memcg)
+{
+	if (memcg) {
+		struct mem_cgroup *swap_token_memcg;
+
+		/*
+		 * memcgroup reclaim can disable swap token only if token task
+		 * is in the same cgroup.
+		 */
+		swap_token_memcg = try_get_mem_cgroup_from_mm(swap_token_mm);
+		return ((mm == swap_token_mm) && (memcg == swap_token_memcg));
+	} else
+		return (mm == swap_token_mm);
+}
+
diff -puN mm/vmscan.c~vmscanmemcg-memcg-aware-swap-token mm/vmscan.c
--- a/mm/vmscan.c~vmscanmemcg-memcg-aware-swap-token
+++ a/mm/vmscan.c
@@ -2053,7 +2053,7 @@ static unsigned long do_try_to_free_page
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		sc->nr_scanned = 0;
 		if (!priority)
-			disable_swap_token();
+			disable_swap_token(sc->mem_cgroup);
 		shrink_zones(priority, zonelist, sc);
 		/*
 		 * Don't shrink slabs when reclaiming memory from
@@ -2369,7 +2369,7 @@ loop_again:
 
 		/* The swap token gets in the way of swapout... */
 		if (!priority)
-			disable_swap_token();
+			disable_swap_token(NULL);
 
 		all_zones_ok = 1;
 		balanced = 0;
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
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix.patch
readahead-readahead-page-allocations-are-ok-to-fail.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
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
vmscanmemcg-memcg-aware-swap-token-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

