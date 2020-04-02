From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 075/155] mm, memcg: prevent memory.max load
 tearing
Date: Wed, 01 Apr 2020 21:07:20 -0700
Message-ID: <20200402040720.t76zXBOZv%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbgDBEHW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:07:22 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org

From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: prevent memory.max load tearing

This one is a bit more nuanced because we have memcg_max_mutex, which is
mostly just used for enforcing invariants, but we still need to READ_ONCE
since (despite its name) it doesn't really protect memory.max access.

On write (page_counter_set_max() and memory_max_write()) we use xchg(),
which uses smp_mb(), so that's already fine.

Link: http://lkml.kernel.org/r/50a31e5f39f8ae6c8fb73966ba1455f0924e8f44.1584034301.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-memorymax-load-tearing
+++ a/mm/memcontrol.c
@@ -1521,7 +1521,7 @@ void mem_cgroup_print_oom_meminfo(struct
 
 	pr_info("memory: usage %llukB, limit %llukB, failcnt %lu\n",
 		K((u64)page_counter_read(&memcg->memory)),
-		K((u64)memcg->memory.max), memcg->memory.failcnt);
+		K((u64)READ_ONCE(memcg->memory.max)), memcg->memory.failcnt);
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		pr_info("swap: usage %llukB, limit %llukB, failcnt %lu\n",
 			K((u64)page_counter_read(&memcg->swap)),
@@ -1552,7 +1552,7 @@ unsigned long mem_cgroup_get_max(struct
 {
 	unsigned long max;
 
-	max = memcg->memory.max;
+	max = READ_ONCE(memcg->memory.max);
 	if (mem_cgroup_swappiness(memcg)) {
 		unsigned long memsw_max;
 		unsigned long swap_max;
@@ -3068,7 +3068,7 @@ static int mem_cgroup_resize_max(struct
 		 * Make sure that the new limit (memsw or memory limit) doesn't
 		 * break our basic invariant rule memory.max <= memsw.max.
 		 */
-		limits_invariant = memsw ? max >= memcg->memory.max :
+		limits_invariant = memsw ? max >= READ_ONCE(memcg->memory.max) :
 					   max <= memcg->memsw.max;
 		if (!limits_invariant) {
 			mutex_unlock(&memcg_max_mutex);
@@ -3815,8 +3815,8 @@ static int memcg_stat_show(struct seq_fi
 	/* Hierarchical information */
 	memory = memsw = PAGE_COUNTER_MAX;
 	for (mi = memcg; mi; mi = parent_mem_cgroup(mi)) {
-		memory = min(memory, mi->memory.max);
-		memsw = min(memsw, mi->memsw.max);
+		memory = min(memory, READ_ONCE(mi->memory.max));
+		memsw = min(memsw, READ_ONCE(mi->memsw.max));
 	}
 	seq_printf(m, "hierarchical_memory_limit %llu\n",
 		   (u64)memory * PAGE_SIZE);
@@ -4325,7 +4325,7 @@ void mem_cgroup_wb_stats(struct bdi_writ
 	*pheadroom = PAGE_COUNTER_MAX;
 
 	while ((parent = parent_mem_cgroup(memcg))) {
-		unsigned long ceiling = min(memcg->memory.max,
+		unsigned long ceiling = min(READ_ONCE(memcg->memory.max),
 					    READ_ONCE(memcg->high));
 		unsigned long used = page_counter_read(&memcg->memory);
 
_
