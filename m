From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 061/155] mm/memcontrol.c: allocate shrinker_map on
 appropriate NUMA node
Date: Wed, 01 Apr 2020 21:06:33 -0700
Message-ID: <20200402040633.5-YaIX2Uz%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEGe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:06:34 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, guro@fb.com, hannes@cmpxchg.org, ktkhai@virtuozzo.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

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
