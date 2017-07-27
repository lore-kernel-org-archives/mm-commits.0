From: akpm@linux-foundation.org
Subject: + mm-memcg-reset-memorylow-during-memcg-offlining.patch added to
 -mm tree
Date: Thu, 27 Jul 2017 13:49:55 -0700
Message-ID: <597a51f3.v71HrLL/iUaRR36H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48378 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbdG0Ut4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 16:49:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: reset memory.low during memcg offlining
has been added to the -mm tree.  Its filename is
     mm-memcg-reset-memorylow-during-memcg-offlining.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-reset-memorylow-during-memcg-offlining.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-reset-memorylow-during-memcg-offlining.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -4300,6 +4300,8 @@ static void mem_cgroup_css_offline(struc
 	}
 	spin_unlock(&memcg->event_list_lock);
 
+	memcg->low = 0;
+
 	memcg_offline_kmem(memcg);
 	wb_memcg_offline(memcg);
 
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-reset-memorylow-during-memcg-offlining.patch
cgroup-revert-fa06235b8eb0-cgroup-reset-css-on-destruction.patch

