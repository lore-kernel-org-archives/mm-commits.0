From: akpm@linux-foundation.org
Subject: [merged]
 memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:42:57 -0700
Message-ID: <53446d61.Pk8mKdOzAMrlFpFW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675AbaDHVm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:42:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@gmail.com, vdavydov@parallels.com

Subject: [merged] memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch removed from -mm tree
To: vdavydov@parallels.com,glommer@gmail.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:42:57 -0700


The patch titled
     Subject: memcg, slab: unregister cache from memcg before starting to destroy it
has been removed from the -mm tree.  Its filename was
     memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg, slab: unregister cache from memcg before starting to destroy it

Currently, memcg_unregister_cache(), which deletes the cache being
destroyed from the memcg_slab_caches list, is called after
__kmem_cache_shutdown() (see kmem_cache_destroy()), which starts to
destroy the cache.  As a result, one can access a partially destroyed
cache while traversing a memcg_slab_caches list, which can have deadly
consequences (for instance, cache_show() called for each cache on a
memcg_slab_caches list from mem_cgroup_slabinfo_read() will dereference
pointers to already freed data).

To fix this, let's move memcg_unregister_cache() before the cache
destruction process beginning, issuing memcg_register_cache() on failure.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Glauber Costa <glommer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c  |   12 ++++++------
 mm/slab_common.c |    3 ++-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it
+++ a/mm/memcontrol.c
@@ -3140,6 +3140,7 @@ int memcg_alloc_cache_params(struct mem_
 		s->memcg_params->root_cache = root_cache;
 		INIT_WORK(&s->memcg_params->destroy,
 				kmem_cache_destroy_work_func);
+		css_get(&memcg->css);
 	} else
 		s->memcg_params->is_root_cache = true;
 
@@ -3148,6 +3149,10 @@ int memcg_alloc_cache_params(struct mem_
 
 void memcg_free_cache_params(struct kmem_cache *s)
 {
+	if (!s->memcg_params)
+		return;
+	if (!s->memcg_params->is_root_cache)
+		css_put(&s->memcg_params->memcg->css);
 	kfree(s->memcg_params);
 }
 
@@ -3170,9 +3175,6 @@ void memcg_register_cache(struct kmem_ca
 	memcg = s->memcg_params->memcg;
 	id = memcg_cache_id(memcg);
 
-	css_get(&memcg->css);
-
-
 	/*
 	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
 	 * barrier here to ensure nobody will see the kmem_cache partially
@@ -3221,10 +3223,8 @@ void memcg_unregister_cache(struct kmem_
 	 * after removing it from the memcg_slab_caches list, otherwise we can
 	 * fail to convert memcg_params_to_cache() while traversing the list.
 	 */
-	VM_BUG_ON(!root->memcg_params->memcg_caches[id]);
+	VM_BUG_ON(root->memcg_params->memcg_caches[id] != s);
 	root->memcg_params->memcg_caches[id] = NULL;
-
-	css_put(&memcg->css);
 }
 
 /*
diff -puN mm/slab_common.c~memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it mm/slab_common.c
--- a/mm/slab_common.c~memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it
+++ a/mm/slab_common.c
@@ -313,9 +313,9 @@ void kmem_cache_destroy(struct kmem_cach
 	s->refcount--;
 	if (!s->refcount) {
 		list_del(&s->list);
+		memcg_unregister_cache(s);
 
 		if (!__kmem_cache_shutdown(s)) {
-			memcg_unregister_cache(s);
 			mutex_unlock(&slab_mutex);
 			if (s->flags & SLAB_DESTROY_BY_RCU)
 				rcu_barrier();
@@ -325,6 +325,7 @@ void kmem_cache_destroy(struct kmem_cach
 			kmem_cache_free(kmem_cache, s);
 		} else {
 			list_add(&s->list, &slab_caches);
+			memcg_register_cache(s);
 			mutex_unlock(&slab_mutex);
 			printk(KERN_ERR "kmem_cache_destroy %s: Slab cache still has objects\n",
 				s->name);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch

