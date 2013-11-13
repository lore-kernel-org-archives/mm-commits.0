From: akpm@linux-foundation.org
Subject: [merged]
 memcg-kmem-rename-cache_from_memcg-to-cache_from_memcg_idx.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:39:26 -0800
Message-ID: <5283e37e.JTp1SYu9wnAnunoH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3KMUj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@parallels.com, h.huangqiang@huawei.com

Subject: [merged] memcg-kmem-rename-cache_from_memcg-to-cache_from_memcg_idx.patch removed from -mm tree
To: h.huangqiang@huawei.com,glommer@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:26 -0800


The patch titled
     Subject: memcg, kmem: rename cache_from_memcg to cache_from_memcg_idx
has been removed from the -mm tree.  Its filename was
     memcg-kmem-rename-cache_from_memcg-to-cache_from_memcg_idx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qiang Huang <h.huangqiang@huawei.com>
Subject: memcg, kmem: rename cache_from_memcg to cache_from_memcg_idx

We can't see the relationship with memcg from the parameters,
so the name with memcg_idx would be more reasonable.

Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    2 +-
 mm/slab.h        |    6 ++++--
 mm/slab_common.c |    2 +-
 mm/slub.c        |    2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/slab.c~memcg-kmem-rename-cache_from_memcg-to-cache_from_memcg_idx mm/slab.c
--- a/mm/slab.c~memcg-kmem-rename-cache_from_memcg-to-cache_from_memcg_idx
+++ a/mm/slab.c
@@ -3982,7 +3982,7 @@ static int do_tune_cpucache(struct kmem_
 
 	VM_BUG_ON(!mutex_is_locked(&slab_mutex));
 	for_each_memcg_cache_index(i) {
-		c = cache_from_memcg(cachep, i);
+		c = cache_from_memcg_idx(cachep, i);
 		if (c)
 			/* return value determined by the parent cache only */
 			__do_tune_cpucache(c, limit, batchcount, shared, gfp);
diff -puN mm/slab.h~memcg-kmem-rename-cache_from_memcg-to-cache_from_memcg_idx mm/slab.h
--- a/mm/slab.h~memcg-kmem-rename-cache_from_memcg-to-cache_from_memcg_idx
+++ a/mm/slab.h
@@ -160,7 +160,8 @@ static inline const char *cache_name(str
 	return s->name;
 }
 
-static inline struct kmem_cache *cache_from_memcg(struct kmem_cache *s, int idx)
+static inline struct kmem_cache *
+cache_from_memcg_idx(struct kmem_cache *s, int idx)
 {
 	if (!s->memcg_params)
 		return NULL;
@@ -204,7 +205,8 @@ static inline const char *cache_name(str
 	return s->name;
 }
 
-static inline struct kmem_cache *cache_from_memcg(struct kmem_cache *s, int idx)
+static inline struct kmem_cache *
+cache_from_memcg_idx(struct kmem_cache *s, int idx)
 {
 	return NULL;
 }
diff -puN mm/slab_common.c~memcg-kmem-rename-cache_from_memcg-to-cache_from_memcg_idx mm/slab_common.c
--- a/mm/slab_common.c~memcg-kmem-rename-cache_from_memcg-to-cache_from_memcg_idx
+++ a/mm/slab_common.c
@@ -571,7 +571,7 @@ memcg_accumulate_slabinfo(struct kmem_ca
 		return;
 
 	for_each_memcg_cache_index(i) {
-		c = cache_from_memcg(s, i);
+		c = cache_from_memcg_idx(s, i);
 		if (!c)
 			continue;
 
diff -puN mm/slub.c~memcg-kmem-rename-cache_from_memcg-to-cache_from_memcg_idx mm/slub.c
--- a/mm/slub.c~memcg-kmem-rename-cache_from_memcg-to-cache_from_memcg_idx
+++ a/mm/slub.c
@@ -4983,7 +4983,7 @@ static ssize_t slab_attr_store(struct ko
 		 * through the descendants with best-effort propagation.
 		 */
 		for_each_memcg_cache_index(i) {
-			struct kmem_cache *c = cache_from_memcg(s, i);
+			struct kmem_cache *c = cache_from_memcg_idx(s, i);
 			if (c)
 				attribute->store(c, buf, len);
 		}
_

Patches currently in -mm which might be from h.huangqiang@huawei.com are

origin.patch

