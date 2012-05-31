From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-print-statistics-from-live-counters.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:05 -0700
Message-ID: <20120531191805.67DD4A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:38663 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002Ab2EaTSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:06 -0400
Received: by vbnl22 with SMTP id l22so134438vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: print statistics from live counters
has been removed from the -mm tree.  Its filename was
     mm-memcg-print-statistics-from-live-counters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: print statistics from live counters

Directly print statistics and event counters instead of going through an
intermediate accumulation stage into a separate array, which used to
require defining statistic items in more than one place.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  168 ++++++++++++++++++----------------------------
 1 file changed, 66 insertions(+), 102 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-print-statistics-from-live-counters mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-print-statistics-from-live-counters
+++ a/mm/memcontrol.c
@@ -91,6 +91,13 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_NSTATS,
 };
 
+static const char * const mem_cgroup_stat_names[] = {
+	"cache",
+	"rss",
+	"mapped_file",
+	"swap",
+};
+
 enum mem_cgroup_events_index {
 	MEM_CGROUP_EVENTS_PGPGIN,	/* # of pages paged in */
 	MEM_CGROUP_EVENTS_PGPGOUT,	/* # of pages paged out */
@@ -98,6 +105,14 @@ enum mem_cgroup_events_index {
 	MEM_CGROUP_EVENTS_PGMAJFAULT,	/* # of major page-faults */
 	MEM_CGROUP_EVENTS_NSTATS,
 };
+
+static const char * const mem_cgroup_events_names[] = {
+	"pgpgin",
+	"pgpgout",
+	"pgfault",
+	"pgmajfault",
+};
+
 /*
  * Per memcg event counter is incremented at every pagein/pageout. With THP,
  * it will be incremated by the number of pages. This counter is used for
@@ -4037,92 +4052,6 @@ static int mem_cgroup_move_charge_write(
 }
 #endif
 
-
-/* For read statistics */
-enum {
-	MCS_CACHE,
-	MCS_RSS,
-	MCS_FILE_MAPPED,
-	MCS_SWAP,
-	MCS_PGPGIN,
-	MCS_PGPGOUT,
-	MCS_PGFAULT,
-	MCS_PGMAJFAULT,
-	MCS_INACTIVE_ANON,
-	MCS_ACTIVE_ANON,
-	MCS_INACTIVE_FILE,
-	MCS_ACTIVE_FILE,
-	MCS_UNEVICTABLE,
-	NR_MCS_STAT,
-};
-
-struct mcs_total_stat {
-	s64 stat[NR_MCS_STAT];
-};
-
-static const char *memcg_stat_strings[NR_MCS_STAT] = {
-	"cache",
-	"rss",
-	"mapped_file",
-	"swap",
-	"pgpgin",
-	"pgpgout",
-	"pgfault",
-	"pgmajfault",
-	"inactive_anon",
-	"active_anon",
-	"inactive_file",
-	"active_file",
-	"unevictable",
-};
-
-static void
-mem_cgroup_get_local_stat(struct mem_cgroup *memcg, struct mcs_total_stat *s)
-{
-	s64 val;
-
-	/* per cpu stat */
-	val = mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_CACHE);
-	s->stat[MCS_CACHE] += val * PAGE_SIZE;
-	val = mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_RSS);
-	s->stat[MCS_RSS] += val * PAGE_SIZE;
-	val = mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
-	s->stat[MCS_FILE_MAPPED] += val * PAGE_SIZE;
-	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGPGIN);
-	s->stat[MCS_PGPGIN] += val;
-	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGPGOUT);
-	s->stat[MCS_PGPGOUT] += val;
-	if (do_swap_account) {
-		val = mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_SWAPOUT);
-		s->stat[MCS_SWAP] += val * PAGE_SIZE;
-	}
-	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGFAULT);
-	s->stat[MCS_PGFAULT] += val;
-	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGMAJFAULT);
-	s->stat[MCS_PGMAJFAULT] += val;
-
-	/* per zone stat */
-	val = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_INACTIVE_ANON));
-	s->stat[MCS_INACTIVE_ANON] += val * PAGE_SIZE;
-	val = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_ACTIVE_ANON));
-	s->stat[MCS_ACTIVE_ANON] += val * PAGE_SIZE;
-	val = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_INACTIVE_FILE));
-	s->stat[MCS_INACTIVE_FILE] += val * PAGE_SIZE;
-	val = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_ACTIVE_FILE));
-	s->stat[MCS_ACTIVE_FILE] += val * PAGE_SIZE;
-	val = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_UNEVICTABLE));
-	s->stat[MCS_UNEVICTABLE] += val * PAGE_SIZE;
-}
-
-static void
-mem_cgroup_get_total_stat(struct mem_cgroup *memcg, struct mcs_total_stat *s)
-{
-	struct mem_cgroup *iter;
-
-	for_each_mem_cgroup_tree(iter, memcg)
-		mem_cgroup_get_local_stat(iter, s);
-}
-
 #ifdef CONFIG_NUMA
 static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 				      struct seq_file *m)
@@ -4170,24 +4099,41 @@ static int mem_control_numa_stat_show(st
 }
 #endif /* CONFIG_NUMA */
 
+static const char * const mem_cgroup_lru_names[] = {
+	"inactive_anon",
+	"active_anon",
+	"inactive_file",
+	"active_file",
+	"unevictable",
+};
+
+static inline void mem_cgroup_lru_names_not_uptodate(void)
+{
+	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
+}
+
 static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
 				 struct seq_file *m)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
-	struct mcs_total_stat mystat;
-	int i;
-
-	memset(&mystat, 0, sizeof(mystat));
-	mem_cgroup_get_local_stat(memcg, &mystat);
-
+	struct mem_cgroup *mi;
+	unsigned int i;
 
-	for (i = 0; i < NR_MCS_STAT; i++) {
-		if (i == MCS_SWAP && !do_swap_account)
+	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
+		if (i == MEM_CGROUP_STAT_SWAPOUT && !do_swap_account)
 			continue;
-		seq_printf(m, "%s %llu\n", memcg_stat_strings[i],
-			   (unsigned long long)mystat.stat[i]);
+		seq_printf(m, "%s %ld\n", mem_cgroup_stat_names[i],
+			   mem_cgroup_read_stat(memcg, i) * PAGE_SIZE);
 	}
 
+	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++)
+		seq_printf(m, "%s %lu\n", mem_cgroup_events_names[i],
+			   mem_cgroup_read_events(memcg, i));
+
+	for (i = 0; i < NR_LRU_LISTS; i++)
+		seq_printf(m, "%s %lu\n", mem_cgroup_lru_names[i],
+			   mem_cgroup_nr_lru_pages(memcg, BIT(i)) * PAGE_SIZE);
+
 	/* Hierarchical information */
 	{
 		unsigned long long limit, memsw_limit;
@@ -4198,13 +4144,31 @@ static int mem_control_stat_show(struct 
 				   memsw_limit);
 	}
 
-	memset(&mystat, 0, sizeof(mystat));
-	mem_cgroup_get_total_stat(memcg, &mystat);
-	for (i = 0; i < NR_MCS_STAT; i++) {
-		if (i == MCS_SWAP && !do_swap_account)
+	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
+		long long val = 0;
+
+		if (i == MEM_CGROUP_STAT_SWAPOUT && !do_swap_account)
 			continue;
-		seq_printf(m, "total_%s %llu\n", memcg_stat_strings[i],
-			   (unsigned long long)mystat.stat[i]);
+		for_each_mem_cgroup_tree(mi, memcg)
+			val += mem_cgroup_read_stat(mi, i) * PAGE_SIZE;
+		seq_printf(m, "total_%s %lld\n", mem_cgroup_stat_names[i], val);
+	}
+
+	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++) {
+		unsigned long long val = 0;
+
+		for_each_mem_cgroup_tree(mi, memcg)
+			val += mem_cgroup_read_events(mi, i);
+		seq_printf(m, "total_%s %llu\n",
+			   mem_cgroup_events_names[i], val);
+	}
+
+	for (i = 0; i < NR_LRU_LISTS; i++) {
+		unsigned long long val = 0;
+
+		for_each_mem_cgroup_tree(mi, memcg)
+			val += mem_cgroup_nr_lru_pages(mi, BIT(i)) * PAGE_SIZE;
+		seq_printf(m, "total_%s %llu\n", mem_cgroup_lru_names[i], val);
 	}
 
 #ifdef CONFIG_DEBUG_VM
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

