From: akpm@linux-foundation.org
Subject: + mm-memcontrol-make-tree_statevents-fetch-all-stats.patch added
 to -mm tree
Date: Thu, 04 Feb 2016 15:07:45 -0800
Message-ID: <56b3d9c1.XWkdn9laoMCmqEwf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbcBDXHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:07:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: make tree_{stat,events} fetch all stats
has been added to the -mm tree.  Its filename is
     mm-memcontrol-make-tree_statevents-fetch-all-stats.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-make-tree_statevents-fetch-all-stats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: make tree_{stat,events} fetch all stats

Currently, tree_{stat,events} helpers can only get one stat index at a
time, so when there are a lot of stats to be reported one has to call it
over and over again (see memory_stat_show).  This is neither effective,
nor does it look good.  Instead, let's make these helpers take a snapshot
of all available counters.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   57 +++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-make-tree_statevents-fetch-all-stats mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-make-tree_statevents-fetch-all-stats
+++ a/mm/memcontrol.c
@@ -2717,39 +2717,42 @@ static int mem_cgroup_hierarchy_write(st
 	return retval;
 }
 
-static unsigned long tree_stat(struct mem_cgroup *memcg,
-			       enum mem_cgroup_stat_index idx)
+static void tree_stat(struct mem_cgroup *memcg, unsigned long *stat)
 {
 	struct mem_cgroup *iter;
-	unsigned long val = 0;
+	int i;
 
-	for_each_mem_cgroup_tree(iter, memcg)
-		val += mem_cgroup_read_stat(iter, idx);
+	memset(stat, 0, sizeof(*stat) * MEMCG_NR_STAT);
 
-	return val;
+	for_each_mem_cgroup_tree(iter, memcg) {
+		for (i = 0; i < MEMCG_NR_STAT; i++)
+			stat[i] += mem_cgroup_read_stat(iter, i);
+	}
 }
 
-static unsigned long tree_events(struct mem_cgroup *memcg,
-				 enum mem_cgroup_events_index idx)
+static void tree_events(struct mem_cgroup *memcg, unsigned long *events)
 {
 	struct mem_cgroup *iter;
-	unsigned long val = 0;
+	int i;
 
-	for_each_mem_cgroup_tree(iter, memcg)
-		val += mem_cgroup_read_events(iter, idx);
+	memset(events, 0, sizeof(*events) * MEMCG_NR_EVENTS);
 
-	return val;
+	for_each_mem_cgroup_tree(iter, memcg) {
+		for (i = 0; i < MEMCG_NR_EVENTS; i++)
+			events[i] += mem_cgroup_read_events(iter, i);
+	}
 }
 
 static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 {
+	unsigned long stat[MEMCG_NR_STAT];
 	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
-		val = tree_stat(memcg, MEM_CGROUP_STAT_CACHE);
-		val += tree_stat(memcg, MEM_CGROUP_STAT_RSS);
+		tree_stat(memcg, stat);
+		val = stat[MEM_CGROUP_STAT_CACHE] + stat[MEM_CGROUP_STAT_RSS];
 		if (swap)
-			val += tree_stat(memcg, MEM_CGROUP_STAT_SWAP);
+			val += stat[MEM_CGROUP_STAT_SWAP];
 	} else {
 		if (!swap)
 			val = page_counter_read(&memcg->memory);
@@ -5075,6 +5078,8 @@ static int memory_events_show(struct seq
 static int memory_stat_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+	unsigned long stat[MEMCG_NR_STAT];
+	unsigned long events[MEMCG_NR_EVENTS];
 	int i;
 
 	/*
@@ -5088,22 +5093,22 @@ static int memory_stat_show(struct seq_f
 	 * Current memory state:
 	 */
 
+	tree_stat(memcg, stat);
+	tree_events(memcg, events);
+
 	seq_printf(m, "anon %llu\n",
-		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_RSS) * PAGE_SIZE);
+		   (u64)stat[MEM_CGROUP_STAT_RSS] * PAGE_SIZE);
 	seq_printf(m, "file %llu\n",
-		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_CACHE) * PAGE_SIZE);
+		   (u64)stat[MEM_CGROUP_STAT_CACHE] * PAGE_SIZE);
 	seq_printf(m, "sock %llu\n",
-		   (u64)tree_stat(memcg, MEMCG_SOCK) * PAGE_SIZE);
+		   (u64)stat[MEMCG_SOCK] * PAGE_SIZE);
 
 	seq_printf(m, "file_mapped %llu\n",
-		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED) *
-		   PAGE_SIZE);
+		   (u64)stat[MEM_CGROUP_STAT_FILE_MAPPED] * PAGE_SIZE);
 	seq_printf(m, "file_dirty %llu\n",
-		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_DIRTY) *
-		   PAGE_SIZE);
+		   (u64)stat[MEM_CGROUP_STAT_DIRTY] * PAGE_SIZE);
 	seq_printf(m, "file_writeback %llu\n",
-		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_WRITEBACK) *
-		   PAGE_SIZE);
+		   (u64)stat[MEM_CGROUP_STAT_WRITEBACK] * PAGE_SIZE);
 
 	for (i = 0; i < NR_LRU_LISTS; i++) {
 		struct mem_cgroup *mi;
@@ -5118,9 +5123,9 @@ static int memory_stat_show(struct seq_f
 	/* Accumulated memory events */
 
 	seq_printf(m, "pgfault %lu\n",
-		   tree_events(memcg, MEM_CGROUP_EVENTS_PGFAULT));
+		   events[MEM_CGROUP_EVENTS_PGFAULT]);
 	seq_printf(m, "pgmajfault %lu\n",
-		   tree_events(memcg, MEM_CGROUP_EVENTS_PGMAJFAULT));
+		   events[MEM_CGROUP_EVENTS_PGMAJFAULT]);
 
 	return 0;
 }
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix-2.patch
mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch

