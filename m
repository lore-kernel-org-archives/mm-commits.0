From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root.patch
 added to -mm tree
Date: Thu, 12 Mar 2020 15:46:18 -0700
Message-ID: <20200312224618.e0K70Oa_j%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgCLWqT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 18:46:19 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm, memcg: bypass high reclaim iteration for cgroup hierarchy root
has been added to the -mm tree.  Its filename is
     mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root.patch

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
Subject: mm, memcg: bypass high reclaim iteration for cgroup hierarchy root

The root of the hierarchy cannot have high set, so we will never reclaim
based on it.  This makes that clearer and avoids another entry.

Link: http://lkml.kernel.org/r/20200312164137.GA1753625@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root
+++ a/mm/memcontrol.c
@@ -2246,7 +2246,8 @@ static void reclaim_high(struct mem_cgro
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

mm-memcg-fix-corruption-on-64-bit-divisor-in-memoryhigh-throttling.patch
mm-memcg-throttle-allocators-based-on-ancestral-memoryhigh.patch
mm-memcg-prevent-memoryhigh-load-store-tearing.patch
mm-memcg-prevent-memorymax-load-tearing.patch
mm-memcg-prevent-memorylow-load-store-tearing.patch
mm-memcg-prevent-memorymin-load-store-tearing.patch
mm-memcg-prevent-memoryswapmax-load-tearing.patch
mm-memcg-prevent-mem_cgroup_protected-store-tearing.patch
mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root.patch
