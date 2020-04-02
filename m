From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 078/155] mm, memcg: prevent memory.swap.max load
 tearing
Date: Wed, 01 Apr 2020 21:07:30 -0700
Message-ID: <20200402040730.jK4QNPwaV%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbgDBEHd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:07:33 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org

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
