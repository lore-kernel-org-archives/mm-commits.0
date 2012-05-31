From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-print-statistics-directly-to-seq_file.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:58 -0700
Message-ID: <20120531191758.64260A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:57717 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002Ab2EaTSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:00 -0400
Received: by wgbdt11 with SMTP id dt11so76172wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: print statistics directly to seq_file
has been removed from the -mm tree.  Its filename was
     mm-memcg-print-statistics-directly-to-seq_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: print statistics directly to seq_file

Being able to use seq_printf() allows being smarter about statistics name
strings, which are currently listed twice, with the only difference being
a "total_" prefix on the hierarchical version.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   55 ++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-print-statistics-directly-to-seq_file mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-print-statistics-directly-to-seq_file
+++ a/mm/memcontrol.c
@@ -4060,26 +4060,22 @@ struct mcs_total_stat {
 	s64 stat[NR_MCS_STAT];
 };
 
-static struct {
-	char *local_name;
-	char *total_name;
-} memcg_stat_strings[NR_MCS_STAT] = {
-	{"cache", "total_cache"},
-	{"rss", "total_rss"},
-	{"mapped_file", "total_mapped_file"},
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
 
-
 static void
 mem_cgroup_get_local_stat(struct mem_cgroup *memcg, struct mcs_total_stat *s)
 {
@@ -4175,7 +4171,7 @@ static int mem_control_numa_stat_show(st
 #endif /* CONFIG_NUMA */
 
 static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
-				 struct cgroup_map_cb *cb)
+				 struct seq_file *m)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 	struct mcs_total_stat mystat;
@@ -4188,16 +4184,18 @@ static int mem_control_stat_show(struct 
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
@@ -4205,7 +4203,8 @@ static int mem_control_stat_show(struct 
 	for (i = 0; i < NR_MCS_STAT; i++) {
 		if (i == MCS_SWAP && !do_swap_account)
 			continue;
-		cb->fill(cb, memcg_stat_strings[i].total_name, mystat.stat[i]);
+		seq_printf(m, "total_%s %llu\n", memcg_stat_strings[i],
+			   (unsigned long long)mystat.stat[i]);
 	}
 
 #ifdef CONFIG_DEBUG_VM
@@ -4226,10 +4225,10 @@ static int mem_control_stat_show(struct 
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
 
@@ -4663,7 +4662,7 @@ static struct cftype mem_cgroup_files[] 
 	},
 	{
 		.name = "stat",
-		.read_map = mem_control_stat_show,
+		.read_seq_string = mem_control_stat_show,
 	},
 	{
 		.name = "force_empty",
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
mm-slab-remove-duplicate-check.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
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
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

