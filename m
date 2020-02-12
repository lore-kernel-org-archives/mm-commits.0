From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-lost-css_put-in-memcg_expand_shrinker_maps.patch
 added to -mm tree
Date: Tue, 11 Feb 2020 16:33:24 -0800
Message-ID: <20200212003324.Q8v63ZuPP%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbgBLAdZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 19:33:25 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, ktkhai@virtuozzo.com, mhocko@suse.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, vdavydov.dev@gmail.com, vvs@virtuozzo.com


The patch titled
     Subject: mm/memcontrol.c: lost css_put in memcg_expand_shrinker_maps()
has been added to the -mm tree.  Its filename is
     memcg-lost-css_put-in-memcg_expand_shrinker_maps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-lost-css_put-in-memcg_expand_shrinker_maps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-lost-css_put-in-memcg_expand_shrinker_maps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from vvs@virtuozzo.com are

memcg-lost-css_put-in-memcg_expand_shrinker_maps.patch
