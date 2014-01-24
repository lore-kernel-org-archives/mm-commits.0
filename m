From: akpm@linux-foundation.org
Subject: [merged]
 memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 10:58:45 -0800
Message-ID: <52e2b7e5.iIayu+8NNba1GE1O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@gmail.com, cl@linux.com, bsingharora@gmail.com, vdavydov@parallels.com

Subject: [merged] memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch removed from -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,cl@linux.com,glommer@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:45 -0800


The patch titled
     Subject: memcg, slab: fix races in per-memcg cache creation/destruction
has been removed from the -mm tree.  Its filename was
     memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg, slab: fix races in per-memcg cache creation/destruction

We obtain a per-memcg cache from a root kmem_cache by dereferencing an
entry of the root cache's memcg_params::memcg_caches array.  If we find no
cache for a memcg there on allocation, we initiate the memcg cache
creation (see memcg_kmem_get_cache()).  The cache creation proceeds
asynchronously in memcg_create_kmem_cache() in order to avoid lock
clashes, so there can be several threads trying to create the same
kmem_cache concurrently, but only one of them may succeed.  However, due
to a race in the code, it is not always true.  The point is that the
memcg_caches array can be relocated when we activate kmem accounting for a
memcg (see memcg_update_all_caches(), memcg_update_cache_size()).  If
memcg_update_cache_size() and memcg_create_kmem_cache() proceed
concurrently as described below, we can leak a kmem_cache.

Asume two threads schedule creation of the same kmem_cache.  One of them
successfully creates it.  Another one should fail then, but if
memcg_create_kmem_cache() interleaves with memcg_update_cache_size() as
follows, it won't:

  memcg_create_kmem_cache()             memcg_update_cache_size()
  (called w/o mutexes held)             (called with slab_mutex,
                                         set_limit_mutex held)
  -------------------------             -------------------------

  mutex_lock(&memcg_cache_mutex)

                                        s->memcg_params=kzalloc(...)

  new_cachep=cache_from_memcg_idx(cachep,idx)
  // new_cachep==NULL => proceed to creation

                                        s->memcg_params->memcg_caches[i]
                                            =cur_params->memcg_caches[i]

  // kmem_cache_create_memcg takes slab_mutex
  // so we will hang around until
  // memcg_update_cache_size finishes, but
  // nothing will prevent it from succeeding so
  // memcg_caches[idx] will be overwritten in
  // memcg_register_cache!

  new_cachep = kmem_cache_create_memcg(...)
  mutex_unlock(&memcg_cache_mutex)

Let's fix this by moving the check for existence of the memcg cache to
kmem_cache_create_memcg() to be called under the slab_mutex and make it
return NULL if so.

A similar race is possible when destroying a memcg cache (see
kmem_cache_destroy()).  Since memcg_unregister_cache(), which clears the
pointer in the memcg_caches array, is called w/o protection, we can race
with memcg_update_cache_size() and omit clearing the pointer.  Therefore
memcg_unregister_cache() should be moved before we release the slab_mutex.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c  |   23 ++++++++++++++---------
 mm/slab_common.c |   14 +++++++++++++-
 2 files changed, 27 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-slab-fix-races-in-per-memcg-cache-creation-destruction mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slab-fix-races-in-per-memcg-cache-creation-destruction
+++ a/mm/memcontrol.c
@@ -3264,6 +3264,12 @@ void memcg_register_cache(struct kmem_ca
 	if (is_root_cache(s))
 		return;
 
+	/*
+	 * Holding the slab_mutex assures nobody will touch the memcg_caches
+	 * array while we are modifying it.
+	 */
+	lockdep_assert_held(&slab_mutex);
+
 	root = s->memcg_params->root_cache;
 	memcg = s->memcg_params->memcg;
 	id = memcg_cache_id(memcg);
@@ -3283,6 +3289,7 @@ void memcg_register_cache(struct kmem_ca
 	 * before adding it to the memcg_slab_caches list, otherwise we can
 	 * fail to convert memcg_params_to_cache() while traversing the list.
 	 */
+	VM_BUG_ON(root->memcg_params->memcg_caches[id]);
 	root->memcg_params->memcg_caches[id] = s;
 
 	mutex_lock(&memcg->slab_caches_mutex);
@@ -3299,6 +3306,12 @@ void memcg_unregister_cache(struct kmem_
 	if (is_root_cache(s))
 		return;
 
+	/*
+	 * Holding the slab_mutex assures nobody will touch the memcg_caches
+	 * array while we are modifying it.
+	 */
+	lockdep_assert_held(&slab_mutex);
+
 	root = s->memcg_params->root_cache;
 	memcg = s->memcg_params->memcg;
 	id = memcg_cache_id(memcg);
@@ -3312,6 +3325,7 @@ void memcg_unregister_cache(struct kmem_
 	 * after removing it from the memcg_slab_caches list, otherwise we can
 	 * fail to convert memcg_params_to_cache() while traversing the list.
 	 */
+	VM_BUG_ON(!root->memcg_params->memcg_caches[id]);
 	root->memcg_params->memcg_caches[id] = NULL;
 
 	css_put(&memcg->css);
@@ -3464,22 +3478,13 @@ static struct kmem_cache *memcg_create_k
 						  struct kmem_cache *cachep)
 {
 	struct kmem_cache *new_cachep;
-	int idx;
 
 	BUG_ON(!memcg_can_account_kmem(memcg));
 
-	idx = memcg_cache_id(memcg);
-
 	mutex_lock(&memcg_cache_mutex);
-	new_cachep = cache_from_memcg_idx(cachep, idx);
-	if (new_cachep)
-		goto out;
-
 	new_cachep = kmem_cache_dup(memcg, cachep);
 	if (new_cachep == NULL)
 		new_cachep = cachep;
-
-out:
 	mutex_unlock(&memcg_cache_mutex);
 	return new_cachep;
 }
diff -puN mm/slab_common.c~memcg-slab-fix-races-in-per-memcg-cache-creation-destruction mm/slab_common.c
--- a/mm/slab_common.c~memcg-slab-fix-races-in-per-memcg-cache-creation-destruction
+++ a/mm/slab_common.c
@@ -180,6 +180,18 @@ kmem_cache_create_memcg(struct mem_cgrou
 	if (err)
 		goto out_unlock;
 
+	if (memcg) {
+		/*
+		 * Since per-memcg caches are created asynchronously on first
+		 * allocation (see memcg_kmem_get_cache()), several threads can
+		 * try to create the same cache, but only one of them may
+		 * succeed. Therefore if we get here and see the cache has
+		 * already been created, we silently return NULL.
+		 */
+		if (cache_from_memcg_idx(parent_cache, memcg_cache_id(memcg)))
+			goto out_unlock;
+	}
+
 	/*
 	 * Some allocators will constraint the set of valid flags to a subset
 	 * of all flags. We expect them to define CACHE_CREATE_MASK in this
@@ -261,11 +273,11 @@ void kmem_cache_destroy(struct kmem_cach
 		list_del(&s->list);
 
 		if (!__kmem_cache_shutdown(s)) {
+			memcg_unregister_cache(s);
 			mutex_unlock(&slab_mutex);
 			if (s->flags & SLAB_DESTROY_BY_RCU)
 				rcu_barrier();
 
-			memcg_unregister_cache(s);
 			memcg_free_cache_params(s);
 			kfree(s->name);
 			kmem_cache_free(kmem_cache, s);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch

