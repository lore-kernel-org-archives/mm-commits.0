From: akpm@linux-foundation.org
Subject: [merged]
 memcg-optimize-memorynuma_stat-like-memorystat.patch removed from -mm tree
Date: Thu, 04 Jun 2020 10:15:56 -0700
Message-ID: <20200604171556.VNZGoEPYU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729866AbgFDRP5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:15:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm/memcg: optimize memory.numa_stat like memory.stat
has been removed from the -mm tree.  Its filename was
     memcg-optimize-memorynuma_stat-like-memorystat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm/memcg: optimize memory.numa_stat like memory.stat

Currently reading memory.numa_stat traverses the underlying memcg tree
multiple times to accumulate the stats to present the hierarchical view of
the memcg tree.  However the kernel already maintains the hierarchical
view of the stats and use it in memory.stat.  Just use the same mechanism
in memory.numa_stat as well.

I ran a simple benchmark which reads root_mem_cgroup's memory.numa_stat
file in the presense of 10000 memcgs.  The results are:

Without the patch:
$ time cat /dev/cgroup/memory/memory.numa_stat > /dev/null

real    0m0.700s
user    0m0.001s
sys     0m0.697s

With the patch:
$ time cat /dev/cgroup/memory/memory.numa_stat > /dev/null

real    0m0.001s
user    0m0.001s
sys     0m0.000s

[akpm@linux-foundation.org: avoid forcing out-of-line code generation]
Link: http://lkml.kernel.org/r/20200304022058.248270-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   49 +++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

--- a/mm/memcontrol.c~memcg-optimize-memorynuma_stat-like-memorystat
+++ a/mm/memcontrol.c
@@ -3743,7 +3743,7 @@ static int mem_cgroup_move_charge_write(
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
 static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
-					   int nid, unsigned int lru_mask)
+				int nid, unsigned int lru_mask, bool tree)
 {
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 	unsigned long nr = 0;
@@ -3754,13 +3754,17 @@ static unsigned long mem_cgroup_node_nr_
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
+		if (tree)
+			nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru);
+		else
+			nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
 	}
 	return nr;
 }
 
 static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
-					     unsigned int lru_mask)
+					     unsigned int lru_mask,
+					     bool tree)
 {
 	unsigned long nr = 0;
 	enum lru_list lru;
@@ -3768,7 +3772,10 @@ static unsigned long mem_cgroup_nr_lru_p
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru);
+		if (tree)
+			nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
+		else
+			nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru);
 	}
 	return nr;
 }
@@ -3788,34 +3795,28 @@ static int memcg_numa_stat_show(struct s
 	};
 	const struct numa_stat *stat;
 	int nid;
-	unsigned long nr;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
-		nr = mem_cgroup_nr_lru_pages(memcg, stat->lru_mask);
-		seq_printf(m, "%s=%lu", stat->name, nr);
-		for_each_node_state(nid, N_MEMORY) {
-			nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
-							  stat->lru_mask);
-			seq_printf(m, " N%d=%lu", nid, nr);
-		}
+		seq_printf(m, "%s=%lu", stat->name,
+			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
+						   false));
+		for_each_node_state(nid, N_MEMORY)
+			seq_printf(m, " N%d=%lu", nid,
+				   mem_cgroup_node_nr_lru_pages(memcg, nid,
+							stat->lru_mask, false));
 		seq_putc(m, '\n');
 	}
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
-		struct mem_cgroup *iter;
 
-		nr = 0;
-		for_each_mem_cgroup_tree(iter, memcg)
-			nr += mem_cgroup_nr_lru_pages(iter, stat->lru_mask);
-		seq_printf(m, "hierarchical_%s=%lu", stat->name, nr);
-		for_each_node_state(nid, N_MEMORY) {
-			nr = 0;
-			for_each_mem_cgroup_tree(iter, memcg)
-				nr += mem_cgroup_node_nr_lru_pages(
-					iter, nid, stat->lru_mask);
-			seq_printf(m, " N%d=%lu", nid, nr);
-		}
+		seq_printf(m, "hierarchical_%s=%lu", stat->name,
+			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
+						   true));
+		for_each_node_state(nid, N_MEMORY)
+			seq_printf(m, " N%d=%lu", nid,
+				   mem_cgroup_node_nr_lru_pages(memcg, nid,
+							stat->lru_mask, true));
 		seq_putc(m, '\n');
 	}
 
_

Patches currently in -mm which might be from shakeelb@google.com are
