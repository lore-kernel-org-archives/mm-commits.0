From: akpm@linux-foundation.org
Subject: [patch 13/15] memcg: prevent memcg caches to be both OFF_SLAB &
 OBJFREELIST_SLAB
Date: Thu, 10 Nov 2016 10:46:41 -0800
Message-ID: <5824c091.wvWaeUU9cvlSuRJT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49408 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755791AbcKJSqn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2016 13:46:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, gthelen@google.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, rientjes@google.com, thgarnie@google.com, vdavydov.dev@gmail.com

From: Greg Thelen <gthelen@google.com>
Subject: memcg: prevent memcg caches to be both OFF_SLAB & OBJFREELIST_SLAB

While testing OBJFREELIST_SLAB integration with pagealloc, we found a bug
where kmem_cache(sys) would be created with both CFLGS_OFF_SLAB &
CFLGS_OBJFREELIST_SLAB.  When it happened, critical allocations needed for
loading drivers or creating new caches will fail.

The original kmem_cache is created early making OFF_SLAB not possible. 
When kmem_cache(sys) is created, OFF_SLAB is possible and if pagealloc is
enabled it will try to enable it first under certain conditions.  Given
kmem_cache(sys) reuses the original flag, you can have both flags at the
same time resulting in allocation failures and odd behaviors.

This fix discards allocator specific flags from memcg before calling
create_cache.

The bug exists since 4.6-rc1 and affects testing debug pagealloc
configurations.

Fixes: b03a017bebc4 ("mm/slab: introduce new slab management type, OBJFREELIST_SLAB")
Link: http://lkml.kernel.org/r/1478553075-120242-1-git-send-email-thgarnie@google.com
Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Thomas Garnier <thgarnie@google.com>
Tested-by: Thomas Garnier <thgarnie@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab_common.c~memcg-prevent-memcg-caches-to-be-both-off_slab-objfreelist_slab mm/slab_common.c
--- a/mm/slab_common.c~memcg-prevent-memcg-caches-to-be-both-off_slab-objfreelist_slab
+++ a/mm/slab_common.c
@@ -533,8 +533,8 @@ void memcg_create_kmem_cache(struct mem_
 
 	s = create_cache(cache_name, root_cache->object_size,
 			 root_cache->size, root_cache->align,
-			 root_cache->flags, root_cache->ctor,
-			 memcg, root_cache);
+			 root_cache->flags & CACHE_CREATE_MASK,
+			 root_cache->ctor, memcg, root_cache);
 	/*
 	 * If we could not create a memcg cache, do not complain, because
 	 * that's not critical at all as we can always proceed with the root
_
