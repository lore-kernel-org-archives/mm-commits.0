From: akpm@linux-foundation.org
Subject: + mm-memcg-convert-numa-stat-to-read_seq_string-interface.patch added to -mm tree
Date: Tue, 15 May 2012 14:54:40 -0700
Message-ID: <20120515215440.CD53DA028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:48018 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839Ab2EOVyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 17:54:43 -0400
Received: by wgbdt11 with SMTP id dt11so2940wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 14:54:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, tj@kernel.org, yinghan@google.com


The patch titled
     Subject: mm: memcg: convert numa stat to read_seq_string interface
has been added to the -mm tree.  Its filename is
     mm-memcg-convert-numa-stat-to-read_seq_string-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: convert numa stat to read_seq_string interface

Instead of using the raw seq_file file interface, switch over to the
read_seq_string cftype callback and let cgroup core code set up the
seq_file.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-convert-numa-stat-to-read_seq_string-interface mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-convert-numa-stat-to-read_seq_string-interface
+++ a/mm/memcontrol.c
@@ -4353,12 +4353,12 @@ mem_cgroup_get_total_stat(struct mem_cgr
 }
 
 #ifdef CONFIG_NUMA
-static int mem_control_numa_stat_show(struct seq_file *m, void *arg)
+static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
+				      struct seq_file *m)
 {
 	int nid;
 	unsigned long total_nr, file_nr, anon_nr, unevictable_nr;
 	unsigned long node_nr;
-	struct cgroup *cont = m->private;
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
 	total_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL);
@@ -4833,22 +4833,6 @@ static int mem_cgroup_oom_control_write(
 	return 0;
 }
 
-#ifdef CONFIG_NUMA
-static const struct file_operations mem_control_numa_stat_file_operations = {
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int mem_control_numa_stat_open(struct inode *unused, struct file *file)
-{
-	struct cgroup *cont = file->f_dentry->d_parent->d_fsdata;
-
-	file->f_op = &mem_control_numa_stat_file_operations;
-	return single_open(file, mem_control_numa_stat_show, cont);
-}
-#endif /* CONFIG_NUMA */
-
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
@@ -4936,8 +4920,7 @@ static struct cftype mem_cgroup_files[] 
 #ifdef CONFIG_NUMA
 	{
 		.name = "numa_stat",
-		.open = mem_control_numa_stat_open,
-		.mode = S_IRUGO,
+		.read_seq_string = mem_control_numa_stat_show,
 	},
 #endif
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
_
Subject: Subject: mm: memcg: convert numa stat to read_seq_string interface

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
mm-slab-remove-duplicate-check.patch
mm-remove-swap-token-code.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-thp-drop-page_table_lock-to-uncharge-memcg-pages.patch
documentation-memcg-future-proof-hierarchical-statistics-documentation.patch
mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem.patch
mm-bootmem-remove-redundant-offset-check-when-finally-freeing-bootmem.patch
mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata.patch
mm-bootmem-split-out-goal-to-node-mapping-from-goal-dropping.patch
mm-bootmem-allocate-in-order-nodegoal-goal-node-anywhere.patch
mm-bootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-nobootmem-panic-on-node-specific-allocation-failure.patch
mm-nobootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-bootmem-pass-pgdat-instead-of-pgdat-bdata-down-the-stack.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix-2.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
memcg-add-mlock-statistic-in-memorystat.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
rescounters-add-res_counter_uncharge_until.patch
memcg-use-res_counter_uncharge_until-in-move_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0.patch
memcg-dont-uncharge-in-mem_cgroup_move_account.patch
remove-__must_check-for-res_counter_charge_nofail.patch
mm-memcg-remove-obsolete-statistics-array-boundary-enum-item.patch
mm-memcg-convert-numa-stat-to-read_seq_string-interface.patch
mm-memcg-print-statistics-directly-to-seq_file.patch
mm-memcg-keep-ratelimit-counter-separate-from-event-counters.patch
mm-memcg-group-swapped-out-statistics-counter-logically.patch
mm-memcg-print-statistics-from-live-counters.patch
mm-memcg-print-statistics-from-live-counters-checkpatch-fixes.patch

