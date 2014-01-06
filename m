From: akpm@linux-foundation.org
Subject: + memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
 added to -mm tree
Date: Mon, 06 Jan 2014 14:56:21 -0800
Message-ID: <52cb3495.4dVn+kbgteShy6di%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933515AbaAFW4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jan 2014 17:56:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@gmail.com, cl@linux.com, bsingharora@gmail.com, vdavydov@parallels.com

Subject: + memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch added to -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,cl@linux.com,glommer@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 06 Jan 2014 14:56:21 -0800


The patch titled
     Subject: memcg, slab: fix barrier usage when accessing memcg_caches
has been added to the -mm tree.  Its filename is
     memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3234,12 +3234,14 @@ void memcg_register_cache(struct kmem_ca
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
@@ -3565,7 +3567,7 @@ struct kmem_cache *__memcg_kmem_get_cach
 					  gfp_t gfp)
 {
 	struct mem_cgroup *memcg;
-	int idx;
+	struct kmem_cache *memcg_cachep;
 
 	VM_BUG_ON(!cachep->memcg_params);
 	VM_BUG_ON(!cachep->memcg_params->is_root_cache);
@@ -3579,15 +3581,9 @@ struct kmem_cache *__memcg_kmem_get_cach
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
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
slab-clean-up-kmem_cache_create_memcg-error-handling.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
memcg-slab-clean-up-memcg-cache-initialization-destruction.patch
memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch
memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch
memcg-get-rid-of-kmem_cache_dup.patch
slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch
memcg-slab-rcu-protect-memcg_params-for-root-caches.patch
memcg-remove-kmem_accounted_activated-flag.patch
memcg-rework-memcg_update_kmem_limit-synchronization.patch
linux-next.patch

