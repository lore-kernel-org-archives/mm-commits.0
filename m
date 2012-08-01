From: akpm@linux-foundation.org
Subject: [merged] memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:11:30 -0700
Message-ID: <20120801201131.1AD405C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:50652 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2HAULd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:11:33 -0400
Received: by weyr1 with SMTP id r1so344079wey.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:11:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: rename MEM_CGROUP_STAT_SWAPOUT as MEM_CGROUP_STAT_SWAP
has been removed from the -mm tree.  Its filename was
     memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: rename MEM_CGROUP_STAT_SWAPOUT as MEM_CGROUP_STAT_SWAP

MEM_CGROUP_STAT_SWAPOUT represents the usage of swap rather than
the number of swap-out events. Rename it to be MEM_CGROUP_STAT_SWAP.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap
+++ a/mm/memcontrol.c
@@ -87,7 +87,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
-	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
+	MEM_CGROUP_STAT_SWAP, /* # of pages, swapped out */
 	MEM_CGROUP_STAT_NSTATS,
 };
 
@@ -703,7 +703,7 @@ static void mem_cgroup_swap_statistics(s
 					 bool charge)
 {
 	int val = (charge) ? 1 : -1;
-	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAPOUT], val);
+	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAP], val);
 }
 
 static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
@@ -3831,7 +3831,7 @@ static inline u64 mem_cgroup_usage(struc
 	val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_RSS);
 
 	if (swap)
-		val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_SWAPOUT);
+		val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_SWAP);
 
 	return val << PAGE_SHIFT;
 }
@@ -4082,7 +4082,7 @@ static int mem_control_stat_show(struct 
 	unsigned int i;
 
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
-		if (i == MEM_CGROUP_STAT_SWAPOUT && !do_swap_account)
+		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
 			continue;
 		seq_printf(m, "%s %ld\n", mem_cgroup_stat_names[i],
 			   mem_cgroup_read_stat(memcg, i) * PAGE_SIZE);
@@ -4109,7 +4109,7 @@ static int mem_control_stat_show(struct 
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
 		long long val = 0;
 
-		if (i == MEM_CGROUP_STAT_SWAPOUT && !do_swap_account)
+		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
 			continue;
 		for_each_mem_cgroup_tree(mi, memcg)
 			val += mem_cgroup_read_stat(mi, i) * PAGE_SIZE;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

