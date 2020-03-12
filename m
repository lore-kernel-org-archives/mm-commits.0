From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-prevent-memoryswapmax-load-tearing.patch added
 to -mm tree
Date: Thu, 12 Mar 2020 15:45:10 -0700
Message-ID: <20200312224510.LaRInHKx2%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgCLWpL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 18:45:11 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm, memcg: prevent memory.swap.max load tearing
has been added to the -mm tree.  Its filename is
     mm-memcg-prevent-memoryswapmax-load-tearing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-prevent-memoryswapmax-load-tearing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-prevent-memoryswapmax-load-tearing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: prevent memory.swap.max load tearing

The write side of this is xchg()/smp_mb(), so that's all good.  Just a few
sites missing a READ_ONCE.

Link: http://lkml.kernel.org/r/bbec2c3d822217334855c8877a9d28b2a6d395fb.1584034301.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
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
@@ -7128,7 +7128,8 @@ bool mem_cgroup_swap_full(struct page *p
 		return false;
 
 	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
-		if (page_counter_read(&memcg->swap) * 2 >= memcg->swap.max)
+		if (page_counter_read(&memcg->swap) * 2 >=
+		    READ_ONCE(memcg->swap.max))
 			return true;
 
 	return false;
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-memcg-fix-corruption-on-64-bit-divisor-in-memoryhigh-throttling.patch
mm-memcg-throttle-allocators-based-on-ancestral-memoryhigh.patch
mm-memcg-prevent-memoryhigh-load-store-tearing.patch
mm-memcg-prevent-memorymax-load-tearing.patch
mm-memcg-prevent-memorylow-load-store-tearing.patch
mm-memcg-prevent-memorymin-load-store-tearing.patch
mm-memcg-prevent-memoryswapmax-load-tearing.patch
mm-memcg-prevent-mem_cgroup_protected-store-tearing.patch
