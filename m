From: akpm@linux-foundation.org
Subject: + mm-memcg-print-statistics-directly-to-seq_file.patch added to -mm tree
Date: Tue, 15 May 2012 14:54:42 -0700
Message-ID: <20120515215442.D29C4A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:45348 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab2EOVyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 17:54:43 -0400
Received: by ggeh3 with SMTP id h3so16206gge.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 14:54:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, tj@kernel.org, yinghan@google.com


The patch titled
     Subject: mm: memcg: print statistics directly to seq_file
has been added to the -mm tree.  Its filename is
     mm-memcg-print-statistics-directly-to-seq_file.patch

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
Subject: mm: memcg: print statistics directly to seq_file

Being able to use seq_printf() allows being smarter about statistics name
strings, which are currently listed twice, with the only

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   56 +++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-print-statistics-directly-to-seq_file mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-print-statistics-directly-to-seq_file
+++ a/mm/memcontrol.c
@@ -4282,24 +4282,21 @@ struct mcs_total_stat {
 	s64 stat[NR_MCS_STAT];
 };
 
-static struct {
-	char *local_name;
-	char *total_name;
-} memcg_stat_strings[NR_MCS_STAT] = {
-	{"cache", "total_cache"},
-	{"rss", "total_rss"},
-	{"mapped_file", "total_mapped_file"},
-	{"mlock", "total_mlock"},
-	{"pgpgin", "total_pgpgin"},
-	{"pgpgout", "total_pgpgout"},
-	{"swap", "total_swap"},
-	{"pgfault", "total_pgfault"},
-	{"pgmajfault", "total_pgmajfault"},
-	{"inactive_anon", "total_inactive_anon"},
-	{"active_anon", "total_active_anon"},
-	{"inactive_file", "total_inactive_file"},
-	{"active_file", "total_active_file"},
-	{"unevictable", "total_unevictable"}
+static const char *memcg_stat_strings[NR_MCS_STAT] = {
+	"cache",
+	"rss",
+	"mapped_file",
+	"mlock",
+	"pgpgin",
+	"pgpgout",
+	"swap",
+	"pgfault",
+	"pgmajfault",
+	"inactive_anon",
+	"active_anon",
+	"inactive_file",
+	"active_file",
+	"unevictable",
 };
 
 
@@ -4400,7 +4397,7 @@ static int mem_control_numa_stat_show(st
 #endif /* CONFIG_NUMA */
 
 static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
-				 struct cgroup_map_cb *cb)
+				 struct seq_file *m)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 	struct mcs_total_stat mystat;
@@ -4413,16 +4410,18 @@ static int mem_control_stat_show(struct 
 	for (i = 0; i < NR_MCS_STAT; i++) {
 		if (i == MCS_SWAP && !do_swap_account)
 			continue;
-		cb->fill(cb, memcg_stat_strings[i].local_name, mystat.stat[i]);
+		seq_printf(m, "%s %llu\n", memcg_stat_strings[i],
+			   (unsigned long long)mystat.stat[i]);
 	}
 
 	/* Hierarchical information */
 	{
 		unsigned long long limit, memsw_limit;
 		memcg_get_hierarchical_limit(memcg, &limit, &memsw_limit);
-		cb->fill(cb, "hierarchical_memory_limit", limit);
+		seq_printf(m, "hierarchical_memory_limit %llu\n", limit);
 		if (do_swap_account)
-			cb->fill(cb, "hierarchical_memsw_limit", memsw_limit);
+			seq_printf(m, "hierarchical_memsw_limit %llu\n",
+				   memsw_limit);
 	}
 
 	memset(&mystat, 0, sizeof(mystat));
@@ -4430,7 +4429,8 @@ static int mem_control_stat_show(struct 
 	for (i = 0; i < NR_MCS_STAT; i++) {
 		if (i == MCS_SWAP && !do_swap_account)
 			continue;
-		cb->fill(cb, memcg_stat_strings[i].total_name, mystat.stat[i]);
+		seq_printf(m, "total_%s %llu\n", memcg_stat_strings[i],
+			   (unsigned long long)mystat.stat[i]);
 	}
 
 #ifdef CONFIG_DEBUG_VM
@@ -4451,10 +4451,10 @@ static int mem_control_stat_show(struct 
 				recent_scanned[0] += rstat->recent_scanned[0];
 				recent_scanned[1] += rstat->recent_scanned[1];
 			}
-		cb->fill(cb, "recent_rotated_anon", recent_rotated[0]);
-		cb->fill(cb, "recent_rotated_file", recent_rotated[1]);
-		cb->fill(cb, "recent_scanned_anon", recent_scanned[0]);
-		cb->fill(cb, "recent_scanned_file", recent_scanned[1]);
+		seq_printf(m, "recent_rotated_anon %lu\n", recent_rotated[0]);
+		seq_printf(m, "recent_rotated_file %lu\n", recent_rotated[1]);
+		seq_printf(m, "recent_scanned_anon %lu\n", recent_scanned[0]);
+		seq_printf(m, "recent_scanned_file %lu\n", recent_scanned[1]);
 	}
 #endif
 
@@ -4888,7 +4888,7 @@ static struct cftype mem_cgroup_files[] 
 	},
 	{
 		.name = "stat",
-		.read_map = mem_control_stat_show,
+		.read_seq_string = mem_control_stat_show,
 	},
 	{
 		.name = "force_empty",
_
Subject: Subject: mm: memcg: print statistics directly to seq_file

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

