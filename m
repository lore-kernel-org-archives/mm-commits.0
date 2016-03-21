From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-make-tree_statevents-fetch-all-stats.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:37:57 -0700
Message-ID: <56f03f85.SadAPKUmX0Go2j+N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364AbcCUT4V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: make tree_{stat,events} fetch all stats
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-make-tree_statevents-fetch-all-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 mm/memcontrol.c |   67 ++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-make-tree_statevents-fetch-all-stats mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-make-tree_statevents-fetch-all-stats
+++ a/mm/memcontrol.c
@@ -2717,39 +2717,48 @@ static int mem_cgroup_hierarchy_write(st
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
-	unsigned long val;
+	unsigned long val = 0;
 
 	if (mem_cgroup_is_root(memcg)) {
-		val = tree_stat(memcg, MEM_CGROUP_STAT_CACHE);
-		val += tree_stat(memcg, MEM_CGROUP_STAT_RSS);
-		if (swap)
-			val += tree_stat(memcg, MEM_CGROUP_STAT_SWAP);
+		struct mem_cgroup *iter;
+
+		for_each_mem_cgroup_tree(iter, memcg) {
+			val += mem_cgroup_read_stat(iter,
+					MEM_CGROUP_STAT_CACHE);
+			val += mem_cgroup_read_stat(iter,
+					MEM_CGROUP_STAT_RSS);
+			if (swap)
+				val += mem_cgroup_read_stat(iter,
+						MEM_CGROUP_STAT_SWAP);
+		}
 	} else {
 		if (!swap)
 			val = page_counter_read(&memcg->memory);
@@ -5075,6 +5084,8 @@ static int memory_events_show(struct seq
 static int memory_stat_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+	unsigned long stat[MEMCG_NR_STAT];
+	unsigned long events[MEMCG_NR_EVENTS];
 	int i;
 
 	/*
@@ -5088,22 +5099,22 @@ static int memory_stat_show(struct seq_f
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
@@ -5118,9 +5129,9 @@ static int memory_stat_show(struct seq_f
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

mm-oom_reaper-implement-oom-victims-queuing-fix.patch

