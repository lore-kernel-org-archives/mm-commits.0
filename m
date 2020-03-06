From: akpm@linux-foundation.org
Subject: + memcg-optimize-memorynuma_stat-like-memorystat.patch
 added to -mm tree
Date: Thu, 05 Mar 2020 20:41:40 -0800
Message-ID: <20200306044140.5DhwUcbB7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgCFElm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Mar 2020 23:41:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm/memcg: optimize memory.numa_stat like memory.stat
has been added to the -mm tree.  Its filename is
     memcg-optimize-memorynuma_stat-like-memorystat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-optimize-memorynuma_stat-like-memorystat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-optimize-memorynuma_stat-like-memorystat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/20200304022058.248270-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   50 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

--- a/mm/memcontrol.c~memcg-optimize-memorynuma_stat-like-memorystat
+++ a/mm/memcontrol.c
@@ -3653,32 +3653,40 @@ static int mem_cgroup_move_charge_write(
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
 static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
-					   int nid, unsigned int lru_mask)
+				int nid, unsigned int lru_mask, bool tree)
 {
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 	unsigned long nr = 0;
 	enum lru_list lru;
+	unsigned long (*page_state)(struct lruvec *lruvec,
+				    enum node_stat_item idx);
 
 	VM_BUG_ON((unsigned)nid >= nr_node_ids);
 
+	page_state = tree ? lruvec_page_state : lruvec_page_state_local;
+
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
+		nr += page_state(lruvec, NR_LRU_BASE + lru);
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
+	unsigned long (*page_state)(struct mem_cgroup *memcg, int idx);
+
+	page_state = tree ? memcg_page_state : memcg_page_state_local;
 
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru);
+		nr += page_state(memcg, NR_LRU_BASE + lru);
 	}
 	return nr;
 }
@@ -3698,34 +3706,28 @@ static int memcg_numa_stat_show(struct s
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

memcg-css_tryget_online-cleanups.patch
memcg-optimize-memorynuma_stat-like-memorystat.patch
