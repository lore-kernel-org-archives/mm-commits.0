From: akpm@linux-foundation.org
Subject: + mm-memcg-add-rss_huge-stat-to-memorystat.patch added to -mm tree
Date: Tue, 30 Apr 2013 12:33:50 -0700
Message-ID: <20130430193350.7B94131C2B9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:45528 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661Ab3D3Tdv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:33:51 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so91711vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:33:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: mm, memcg: add rss_huge stat to memory.stat
has been added to the -mm tree.  Its filename is
     mm-memcg-add-rss_huge-stat-to-memorystat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Michal Hocko <mhocko@suse.cz>
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
memory-hotplug-fix-warnings.patch
linux-next.patch
drivers-usb-storage-realtek_crc-fix-build.patch
mm-memcg-add-rss_huge-stat-to-memorystat.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch
fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes.patch

