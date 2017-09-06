From: akpm@linux-foundation.org
Subject: [patch 058/119] mm, memcg: reset memory.low during memcg
 offlining
Date: Wed, 06 Sep 2017 16:21:47 -0700
Message-ID: <20170906232147.p3xnQlu_t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49996 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753778AbdIFXVs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:21:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Roman Gushchin <guro@fb.com>
Subject: mm, memcg: reset memory.low during memcg offlining

A removed memory cgroup with a defined memory.low and some belonging
pagecache has very low chances to be freed.

If a cgroup has been removed, there is likely no memory pressure inside
the cgroup, and the pagecache is protected from the external pressure by
the defined low limit.  The cgroup will be freed only after the reclaim of
all belonging pages.  And it will not happen until there are any
reclaimable memory in the system.  That means, there is a good chance,
that a cold pagecache will reside in the memory for an undefined amount of
time, wasting system resources.

This problem was fixed earlier by fa06235b8eb0 ("cgroup: reset css on
destruction"), but it's not a best way to do it, as we can't really reset
all limits/counters during cgroup offlining.

Link: http://lkml.kernel.org/r/20170727130428.28856-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~mm-memcg-reset-memorylow-during-memcg-offlining mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-reset-memorylow-during-memcg-offlining
+++ a/mm/memcontrol.c
@@ -4319,6 +4319,8 @@ static void mem_cgroup_css_offline(struc
 	}
 	spin_unlock(&memcg->event_list_lock);
 
+	memcg->low = 0;
+
 	memcg_offline_kmem(memcg);
 	wb_memcg_offline(memcg);
 
_
