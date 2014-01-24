From: akpm@linux-foundation.org
Subject: [merged]
 memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch removed from -mm tree
Date: Fri, 24 Jan 2014 10:58:41 -0800
Message-ID: <52e2b7e1.b+/nyP/u9pmpnjVb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@gmail.com, cl@linux.com, bsingharora@gmail.com, vdavydov@parallels.com

Subject: [merged] memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch removed from -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,cl@linux.com,glommer@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:41 -0800


The patch titled
     Subject: memcg, slab: fix barrier usage when accessing memcg_caches
has been removed from the -mm tree.  Its filename was
     memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg, slab: fix barrier usage when accessing memcg_caches

Each root kmem_cache has pointers to per-memcg caches stored in its
memcg_params::memcg_caches array.  Whenever we want to allocate a slab for
a memcg, we access this array to get per-memcg cache to allocate from (see
memcg_kmem_get_cache()).  The access must be lock-free for performance
reasons, so we should use barriers to assert the kmem_cache is up-to-date.

First, we should place a write barrier immediately before setting the
pointer to it in the memcg_caches array in order to make sure nobody will
see a partially initialized object.  Second, we should issue a read
barrier before dereferencing the pointer to conform to the write barrier.

However, currently the barrier usage looks rather strange.  We have a
write barrier *after* setting the pointer and a read barrier *before*
reading the pointer, which is incorrect.  This patch fixes this.

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

 mm/memcontrol.c |   24 ++++++++++--------------
 mm/slab.h       |   12 +++++++++++-
 2 files changed, 21 insertions(+), 15 deletions(-)

diff -puN mm/memcontrol.c~memcg-slab-fix-barrier-usage-when-accessing-memcg_caches mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slab-fix-barrier-usage-when-accessing-memcg_caches
+++ a/mm/memcontrol.c
@@ -3274,12 +3274,14 @@ void memcg_register_cache(struct kmem_ca
 	list_add(&s->memcg_params->list, &memcg->memcg_slab_caches);
 	mutex_unlock(&memcg->slab_caches_mutex);
 
-	root->memcg_params->memcg_caches[id] = s;
 	/*
-	 * the readers won't lock, make sure everybody sees the updated value,
-	 * so they won't put stuff in the queue again for no reason
+	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
+	 * barrier here to ensure nobody will see the kmem_cache partially
+	 * initialized.
 	 */
-	wmb();
+	smp_wmb();
+
+	root->memcg_params->memcg_caches[id] = s;
 }
 
 void memcg_unregister_cache(struct kmem_cache *s)
@@ -3605,7 +3607,7 @@ struct kmem_cache *__memcg_kmem_get_cach
 					  gfp_t gfp)
 {
 	struct mem_cgroup *memcg;
-	int idx;
+	struct kmem_cache *memcg_cachep;
 
 	VM_BUG_ON(!cachep->memcg_params);
 	VM_BUG_ON(!cachep->memcg_params->is_root_cache);
@@ -3619,15 +3621,9 @@ struct kmem_cache *__memcg_kmem_get_cach
 	if (!memcg_can_account_kmem(memcg))
 		goto out;
 
-	idx = memcg_cache_id(memcg);
-
-	/*
-	 * barrier to mare sure we're always seeing the up to date value.  The
-	 * code updating memcg_caches will issue a write barrier to match this.
-	 */
-	read_barrier_depends();
-	if (likely(cache_from_memcg_idx(cachep, idx))) {
-		cachep = cache_from_memcg_idx(cachep, idx);
+	memcg_cachep = cache_from_memcg_idx(cachep, memcg_cache_id(memcg));
+	if (likely(memcg_cachep)) {
+		cachep = memcg_cachep;
 		goto out;
 	}
 
diff -puN mm/slab.h~memcg-slab-fix-barrier-usage-when-accessing-memcg_caches mm/slab.h
--- a/mm/slab.h~memcg-slab-fix-barrier-usage-when-accessing-memcg_caches
+++ a/mm/slab.h
@@ -163,9 +163,19 @@ static inline const char *cache_name(str
 static inline struct kmem_cache *
 cache_from_memcg_idx(struct kmem_cache *s, int idx)
 {
+	struct kmem_cache *cachep;
+
 	if (!s->memcg_params)
 		return NULL;
-	return s->memcg_params->memcg_caches[idx];
+	cachep = s->memcg_params->memcg_caches[idx];
+
+	/*
+	 * Make sure we will access the up-to-date value. The code updating
+	 * memcg_caches issues a write barrier to match this (see
+	 * memcg_register_cache()).
+	 */
+	smp_read_barrier_depends();
+	return cachep;
 }
 
 static inline struct kmem_cache *memcg_root_cache(struct kmem_cache *s)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch

