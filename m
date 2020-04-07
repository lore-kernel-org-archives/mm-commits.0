From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 001/166] mm, memcg: bypass high reclaim iteration
 for cgroup hierarchy root
Date: Mon, 06 Apr 2020 20:03:30 -0700
Message-ID: <20200407030330.bq9AB7_k1%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGDDb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:03:31 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org

From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: bypass high reclaim iteration for cgroup hierarchy root

The root of the hierarchy cannot have high set, so we will never reclaim
based on it.  This makes that clearer and avoids another entry.

Link: http://lkml.kernel.org/r/20200312164137.GA1753625@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root
+++ a/mm/memcontrol.c
@@ -2254,7 +2254,8 @@ static void reclaim_high(struct mem_cgro
 			continue;
 		memcg_memory_event(memcg, MEMCG_HIGH);
 		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
-	} while ((memcg = parent_mem_cgroup(memcg)));
+	} while ((memcg = parent_mem_cgroup(memcg)) &&
+		 !mem_cgroup_is_root(memcg));
 }
 
 static void high_work_func(struct work_struct *work)
_
