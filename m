From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-prevent-memoryswapmax-load-tearing.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:38:02 -0700
Message-ID: <20200403203802.HnPzVH1kl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgDCUiD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm, memcg: prevent memory.swap.max load tearing
has been removed from the -mm tree.  Its filename was
     mm-memcg-prevent-memoryswapmax-load-tearing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: prevent memory.swap.max load tearing

The write side of this is xchg()/smp_mb(), so that's all good.  Just a few
sites missing a READ_ONCE.

Link: http://lkml.kernel.org/r/bbec2c3d822217334855c8877a9d28b2a6d395fb.1584034301.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-memoryswapmax-load-tearing
+++ a/mm/memcontrol.c
@@ -1525,7 +1525,7 @@ void mem_cgroup_print_oom_meminfo(struct
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		pr_info("swap: usage %llukB, limit %llukB, failcnt %lu\n",
 			K((u64)page_counter_read(&memcg->swap)),
-			K((u64)memcg->swap.max), memcg->swap.failcnt);
+			K((u64)READ_ONCE(memcg->swap.max)), memcg->swap.failcnt);
 	else {
 		pr_info("memory+swap: usage %llukB, limit %llukB, failcnt %lu\n",
 			K((u64)page_counter_read(&memcg->memsw)),
@@ -1558,7 +1558,7 @@ unsigned long mem_cgroup_get_max(struct
 		unsigned long swap_max;
 
 		memsw_max = memcg->memsw.max;
-		swap_max = memcg->swap.max;
+		swap_max = READ_ONCE(memcg->swap.max);
 		swap_max = min(swap_max, (unsigned long)total_swap_pages);
 		max = min(max + swap_max, memsw_max);
 	}
@@ -7117,7 +7117,8 @@ bool mem_cgroup_swap_full(struct page *p
 		return false;
 
 	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
-		if (page_counter_read(&memcg->swap) * 2 >= memcg->swap.max)
+		if (page_counter_read(&memcg->swap) * 2 >=
+		    READ_ONCE(memcg->swap.max))
 			return true;
 
 	return false;
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root.patch
