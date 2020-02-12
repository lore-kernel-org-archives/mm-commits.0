From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allocate-shrinker_map-on-appropriate-numa-node.patch
 added to -mm tree
Date: Wed, 12 Feb 2020 14:59:51 -0800
Message-ID: <20200212225951.pgx60nMDF%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbgBLW7w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 17:59:52 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, guro@fb.com, hannes@cmpxchg.org, ktkhai@virtuozzo.com, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm/memcontrol.c: allocate shrinker_map on appropriate NUMA node
has been added to the -mm tree.  Its filename is
     mm-allocate-shrinker_map-on-appropriate-numa-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-allocate-shrinker_map-on-appropriate-numa-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-allocate-shrinker_map-on-appropriate-numa-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: mm/memcontrol.c: allocate shrinker_map on appropriate NUMA node

The shrinker_map may be touched from any cpu (e.g., a bit there may be set
by a task running everywhere) but kswapd is always bound to specific node.
So allocate shrinker_map from the related NUMA node to respect its NUMA
locality.  Also, this follows generic way we use for allocation of memcg's
per-node data.

Link: http://lkml.kernel.org/r/fff0e636-4c36-ed10-281c-8cdb0687c839@virtuozzo.com
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-allocate-shrinker_map-on-appropriate-numa-node
+++ a/mm/memcontrol.c
@@ -334,7 +334,7 @@ static int memcg_expand_one_shrinker_map
 		if (!old)
 			return 0;
 
-		new = kvmalloc(sizeof(*new) + size, GFP_KERNEL);
+		new = kvmalloc_node(sizeof(*new) + size, GFP_KERNEL, nid);
 		if (!new)
 			return -ENOMEM;
 
@@ -378,7 +378,7 @@ static int memcg_alloc_shrinker_maps(str
 	mutex_lock(&memcg_shrinker_map_mutex);
 	size = memcg_shrinker_map_size;
 	for_each_node(nid) {
-		map = kvzalloc(sizeof(*map) + size, GFP_KERNEL);
+		map = kvzalloc_node(sizeof(*map) + size, GFP_KERNEL, nid);
 		if (!map) {
 			memcg_free_shrinker_maps(memcg);
 			ret = -ENOMEM;
_

Patches currently in -mm which might be from ktkhai@virtuozzo.com are

mm-allocate-shrinker_map-on-appropriate-numa-node.patch
