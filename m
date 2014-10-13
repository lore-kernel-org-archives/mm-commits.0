From: akpm@linux-foundation.org
Subject: [merged] memcg-move-memcg_update_cache_size-to-slab_commonc.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:21:03 -0700
Message-ID: <543c180f.OmaCn6cKF+g06Kmq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaJMSVD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:21:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, glommer@gmail.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: move memcg_update_cache_size() to slab_common.c
has been removed from the -mm tree.  Its filename was
     memcg-move-memcg_update_cache_size-to-slab_commonc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: move memcg_update_cache_size() to slab_common.c

`While growing per memcg caches arrays, we jump between memcontrol.c and
slab_common.c in a weird way:

  memcg_alloc_cache_id - memcontrol.c
    memcg_update_all_caches - slab_common.c
      memcg_update_cache_size - memcontrol.c

There's absolutely no reason why memcg_update_cache_size can't live on the
slab's side though.  So let's move it there and settle it comfortably amid
per-memcg cache allocation functions.

Besides, this patch cleans this function up a bit, removing all the
useless comments from it, and renames it to memcg_update_cache_params to
conform to memcg_alloc/free_cache_params, which we already have in
slab_common.c.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 
 mm/memcontrol.c            |   49 -----------------------------------
 mm/slab_common.c           |   30 ++++++++++++++++++++-
 3 files changed, 28 insertions(+), 52 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-move-memcg_update_cache_size-to-slab_commonc include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-move-memcg_update_cache_size-to-slab_commonc
+++ a/include/linux/memcontrol.h
@@ -440,7 +440,6 @@ void __memcg_kmem_uncharge_pages(struct
 
 int memcg_cache_id(struct mem_cgroup *memcg);
 
-int memcg_update_cache_size(struct kmem_cache *s, int num_groups);
 void memcg_update_array_size(int num_groups);
 
 struct kmem_cache *
diff -puN mm/memcontrol.c~memcg-move-memcg_update_cache_size-to-slab_commonc mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-memcg_update_cache_size-to-slab_commonc
+++ a/mm/memcontrol.c
@@ -2958,55 +2958,6 @@ void memcg_update_array_size(int num)
 	memcg_limited_groups_array_size = num;
 }
 
-int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
-{
-	struct memcg_cache_params *cur_params = s->memcg_params;
-	struct memcg_cache_params *new_params;
-	size_t size;
-	int i;
-
-	VM_BUG_ON(!is_root_cache(s));
-
-	size = num_groups * sizeof(void *);
-	size += offsetof(struct memcg_cache_params, memcg_caches);
-
-	new_params = kzalloc(size, GFP_KERNEL);
-	if (!new_params)
-		return -ENOMEM;
-
-	new_params->is_root_cache = true;
-
-	/*
-	 * There is the chance it will be bigger than
-	 * memcg_limited_groups_array_size, if we failed an allocation
-	 * in a cache, in which case all caches updated before it, will
-	 * have a bigger array.
-	 *
-	 * But if that is the case, the data after
-	 * memcg_limited_groups_array_size is certainly unused
-	 */
-	for (i = 0; i < memcg_limited_groups_array_size; i++) {
-		if (!cur_params->memcg_caches[i])
-			continue;
-		new_params->memcg_caches[i] =
-			cur_params->memcg_caches[i];
-	}
-
-	/*
-	 * Ideally, we would wait until all caches succeed, and only
-	 * then free the old one. But this is not worth the extra
-	 * pointer per-cache we'd have to have for this.
-	 *
-	 * It is not a big deal if some caches are left with a size
-	 * bigger than the others. And all updates will reset this
-	 * anyway.
-	 */
-	rcu_assign_pointer(s->memcg_params, new_params);
-	if (cur_params)
-		kfree_rcu(cur_params, rcu_head);
-	return 0;
-}
-
 static void memcg_register_cache(struct mem_cgroup *memcg,
 				 struct kmem_cache *root_cache)
 {
diff -puN mm/slab_common.c~memcg-move-memcg_update_cache_size-to-slab_commonc mm/slab_common.c
--- a/mm/slab_common.c~memcg-move-memcg_update_cache_size-to-slab_commonc
+++ a/mm/slab_common.c
@@ -148,6 +148,33 @@ static void memcg_free_cache_params(stru
 	kfree(s->memcg_params);
 }
 
+static int memcg_update_cache_params(struct kmem_cache *s, int num_memcgs)
+{
+	int size;
+	struct memcg_cache_params *new_params, *cur_params;
+
+	BUG_ON(!is_root_cache(s));
+
+	size = offsetof(struct memcg_cache_params, memcg_caches);
+	size += num_memcgs * sizeof(void *);
+
+	new_params = kzalloc(size, GFP_KERNEL);
+	if (!new_params)
+		return -ENOMEM;
+
+	cur_params = s->memcg_params;
+	memcpy(new_params->memcg_caches, cur_params->memcg_caches,
+	       memcg_limited_groups_array_size * sizeof(void *));
+
+	new_params->is_root_cache = true;
+
+	rcu_assign_pointer(s->memcg_params, new_params);
+	if (cur_params)
+		kfree_rcu(cur_params, rcu_head);
+
+	return 0;
+}
+
 int memcg_update_all_caches(int num_memcgs)
 {
 	struct kmem_cache *s;
@@ -158,9 +185,8 @@ int memcg_update_all_caches(int num_memc
 		if (!is_root_cache(s))
 			continue;
 
-		ret = memcg_update_cache_size(s, num_memcgs);
+		ret = memcg_update_cache_params(s, num_memcgs);
 		/*
-		 * See comment in memcontrol.c, memcg_update_cache_size:
 		 * Instead of freeing the memory, we'll just leave the caches
 		 * up to this point in an updated state.
 		 */
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

