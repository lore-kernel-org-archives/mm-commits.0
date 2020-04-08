From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 18:56:14 -0700
Message-ID: <20200408015614.BshIEZ-Lz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbgDHB4P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm, memcg: bypass high reclaim iteration for cgroup hierarchy root
has been removed from the -mm tree.  Its filename was
     mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from chris@chrisdown.name are
