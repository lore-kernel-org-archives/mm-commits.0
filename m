From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-add-rss_huge-stat-to-memorystat.patch removed from -mm tree
Date: Wed, 08 May 2013 11:34:22 -0700
Message-ID: <20130508183422.801605A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:34663 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab3EHSeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:34:23 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so208073qcz.2
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:34:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: add rss_huge stat to memory.stat
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-rss_huge-stat-to-memorystat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: add rss_huge stat to memory.stat

This exports the amount of anonymous transparent hugepages for each memcg
via the new "rss_huge" stat in memory.stat.  The units are in bytes.

This is helpful to determine the hugepage utilization for individual jobs
on the system in comparison to rss and opportunities where MADV_HUGEPAGE
may be helpful.

The amount of anonymous transparent hugepages is also included in "rss"
for backwards compatibility.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    4 ++-
 mm/memcontrol.c                  |   36 ++++++++++++++++++++---------
 2 files changed, 29 insertions(+), 11 deletions(-)

diff -puN Documentation/cgroups/memory.txt~mm-memcg-add-rss_huge-stat-to-memorystat Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~mm-memcg-add-rss_huge-stat-to-memorystat
+++ a/Documentation/cgroups/memory.txt
@@ -480,7 +480,9 @@ memory.stat file includes following stat
 
 # per-memory cgroup local status
 cache		- # of bytes of page cache memory.
-rss		- # of bytes of anonymous and swap cache memory.
+rss		- # of bytes of anonymous and swap cache memory (includes
+		transparent hugepages).
+rss_huge	- # of bytes of anonymous transparent hugepages.
 mapped_file	- # of bytes of mapped file (includes tmpfs/shmem)
 pgpgin		- # of charging events to the memory cgroup. The charging
 		event happens each time a page is accounted as either mapped
diff -puN mm/memcontrol.c~mm-memcg-add-rss_huge-stat-to-memorystat mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-add-rss_huge-stat-to-memorystat
+++ a/mm/memcontrol.c
@@ -92,16 +92,18 @@ enum mem_cgroup_stat_index {
 	/*
 	 * For MEM_CONTAINER_TYPE_ALL, usage = pagecache + rss.
 	 */
-	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
-	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
-	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
-	MEM_CGROUP_STAT_SWAP, /* # of pages, swapped out */
+	MEM_CGROUP_STAT_CACHE,		/* # of pages charged as cache */
+	MEM_CGROUP_STAT_RSS,		/* # of pages charged as anon rss */
+	MEM_CGROUP_STAT_RSS_HUGE,	/* # of pages charged as anon huge */
+	MEM_CGROUP_STAT_FILE_MAPPED,	/* # of pages charged as file rss */
+	MEM_CGROUP_STAT_SWAP,		/* # of pages, swapped out */
 	MEM_CGROUP_STAT_NSTATS,
 };
 
 static const char * const mem_cgroup_stat_names[] = {
 	"cache",
 	"rss",
+	"rss_huge",
 	"mapped_file",
 	"swap",
 };
@@ -917,6 +919,7 @@ static unsigned long mem_cgroup_read_eve
 }
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
+					 struct page *page,
 					 bool anon, int nr_pages)
 {
 	preempt_disable();
@@ -932,6 +935,10 @@ static void mem_cgroup_charge_statistics
 		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_CACHE],
 				nr_pages);
 
+	if (PageTransHuge(page))
+		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_RSS_HUGE],
+				nr_pages);
+
 	/* pagein of a big page is an event. So, ignore page size */
 	if (nr_pages > 0)
 		__this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGPGIN]);
@@ -2914,7 +2921,7 @@ static void __mem_cgroup_commit_charge(s
 	else
 		anon = false;
 
-	mem_cgroup_charge_statistics(memcg, anon, nr_pages);
+	mem_cgroup_charge_statistics(memcg, page, anon, nr_pages);
 	unlock_page_cgroup(pc);
 
 	/*
@@ -3708,16 +3715,21 @@ void mem_cgroup_split_huge_fixup(struct
 {
 	struct page_cgroup *head_pc = lookup_page_cgroup(head);
 	struct page_cgroup *pc;
+	struct mem_cgroup *memcg;
 	int i;
 
 	if (mem_cgroup_disabled())
 		return;
+
+	memcg = head_pc->mem_cgroup;
 	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		pc = head_pc + i;
-		pc->mem_cgroup = head_pc->mem_cgroup;
+		pc->mem_cgroup = memcg;
 		smp_wmb();/* see __commit_charge() */
 		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
 	}
+	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS_HUGE],
+		       HPAGE_PMD_NR);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -3773,11 +3785,11 @@ static int mem_cgroup_move_account(struc
 		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		preempt_enable();
 	}
-	mem_cgroup_charge_statistics(from, anon, -nr_pages);
+	mem_cgroup_charge_statistics(from, page, anon, -nr_pages);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
-	mem_cgroup_charge_statistics(to, anon, nr_pages);
+	mem_cgroup_charge_statistics(to, page, anon, nr_pages);
 	move_unlock_mem_cgroup(from, &flags);
 	ret = 0;
 unlock:
@@ -4152,7 +4164,7 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	mem_cgroup_charge_statistics(memcg, anon, -nr_pages);
+	mem_cgroup_charge_statistics(memcg, page, anon, -nr_pages);
 
 	ClearPageCgroupUsed(pc);
 	/*
@@ -4502,7 +4514,7 @@ void mem_cgroup_replace_page_cache(struc
 	lock_page_cgroup(pc);
 	if (PageCgroupUsed(pc)) {
 		memcg = pc->mem_cgroup;
-		mem_cgroup_charge_statistics(memcg, false, -1);
+		mem_cgroup_charge_statistics(memcg, oldpage, false, -1);
 		ClearPageCgroupUsed(pc);
 	}
 	unlock_page_cgroup(pc);
@@ -5030,6 +5042,10 @@ static inline u64 mem_cgroup_usage(struc
 			return res_counter_read_u64(&memcg->memsw, RES_USAGE);
 	}
 
+	/*
+	 * Transparent hugepages are still accounted for in MEM_CGROUP_STAT_RSS
+	 * as well as in MEM_CGROUP_STAT_RSS_HUGE.
+	 */
 	val = mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_CACHE);
 	val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_RSS);
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

