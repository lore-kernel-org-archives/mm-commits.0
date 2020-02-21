From: akpm@linux-foundation.org
Subject: [patch 10/15] mm/memcontrol.c: lost css_put in
 memcg_expand_shrinker_maps()
Date: Thu, 20 Feb 2020 20:04:18 -0800
Message-ID: <20200221040418.LZDCt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgBUEET (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 23:04:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov.dev@gmail.com, stable@vger.kernel.org, mhocko@suse.com, ktkhai@virtuozzo.com, hannes@cmpxchg.org, guro@fb.com, vvs@virtuozzo.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org

From: Vasily Averin <vvs@virtuozzo.com>
Subject: mm/memcontrol.c: lost css_put in memcg_expand_shrinker_maps()

for_each_mem_cgroup() increases css reference counter for memory cgroup
and requires to use mem_cgroup_iter_break() if the walk is cancelled.

Link: http://lkml.kernel.org/r/c98414fb-7e1f-da0f-867a-9340ec4bd30b@virtuozzo.com
Fixes: 0a4465d34028 ("mm, memcg: assign memcg-aware shrinkers bitmap to memcg")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-lost-css_put-in-memcg_expand_shrinker_maps
+++ a/mm/memcontrol.c
@@ -409,8 +409,10 @@ int memcg_expand_shrinker_maps(int new_i
 		if (mem_cgroup_is_root(memcg))
 			continue;
 		ret = memcg_expand_one_shrinker_map(memcg, size, old_size);
-		if (ret)
+		if (ret) {
+			mem_cgroup_iter_break(NULL, memcg);
 			goto unlock;
+		}
 	}
 unlock:
 	if (!ret)
_
