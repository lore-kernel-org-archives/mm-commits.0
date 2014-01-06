From: akpm@linux-foundation.org
Subject: + memcg-slab-rcu-protect-memcg_params-for-root-caches.patch added to -mm tree
Date: Mon, 06 Jan 2014 14:56:28 -0800
Message-ID: <52cb349c.dlFkAaokm1lNO9K/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501AbaAFW43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jan 2014 17:56:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@gmail.com, cl@linux.com, bsingharora@gmail.com, vdavydov@parallels.com

Subject: + memcg-slab-rcu-protect-memcg_params-for-root-caches.patch added to -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,cl@linux.com,glommer@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 06 Jan 2014 14:56:28 -0800


The patch titled
     Subject: memcg, slab: RCU protect memcg_params for root caches
has been added to the -mm tree.  Its filename is
     memcg-slab-rcu-protect-memcg_params-for-root-caches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-slab-rcu-protect-memcg_params-for-root-caches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-slab-rcu-protect-memcg_params-for-root-caches.patch

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
Subject: memcg, slab: RCU protect memcg_params for root caches

We relocate root cache's memcg_params whenever we need to grow the
memcg_caches array to accommodate all kmem-active memory cgroups. 
Currently on relocation we free the old version immediately, which can
lead to use-after-free, because the memcg_caches array is accessed
lock-free (see cache_from_memcg_idx()).  This patch fixes this by making
memcg_params RCU-protected for root caches.

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

 include/linux/slab.h |    9 +++++++--
 mm/memcontrol.c      |   15 ++++++++-------
 mm/slab.h            |   16 +++++++++++++++-
 3 files changed, 30 insertions(+), 10 deletions(-)

diff -puN include/linux/slab.h~memcg-slab-rcu-protect-memcg_params-for-root-caches include/linux/slab.h
--- a/include/linux/slab.h~memcg-slab-rcu-protect-memcg_params-for-root-caches
+++ a/include/linux/slab.h
@@ -513,7 +513,9 @@ static __always_inline void *kmalloc_nod
  *
  * Both the root cache and the child caches will have it. For the root cache,
  * this will hold a dynamically allocated array large enough to hold
- * information about the currently limited memcgs in the system.
+ * information about the currently limited memcgs in the system. To allow the
+ * array to be accessed without taking any locks, on relocation we free the old
+ * version only after a grace period.
  *
  * Child caches will hold extra metadata needed for its operation. Fields are:
  *
@@ -528,7 +530,10 @@ static __always_inline void *kmalloc_nod
 struct memcg_cache_params {
 	bool is_root_cache;
 	union {
-		struct kmem_cache *memcg_caches[0];
+		struct {
+			struct rcu_head rcu_head;
+			struct kmem_cache *memcg_caches[0];
+		};
 		struct {
 			struct mem_cgroup *memcg;
 			struct list_head list;
diff -puN mm/memcontrol.c~memcg-slab-rcu-protect-memcg_params-for-root-caches mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slab-rcu-protect-memcg_params-for-root-caches
+++ a/mm/memcontrol.c
@@ -3138,18 +3138,17 @@ int memcg_update_cache_size(struct kmem_
 
 	if (num_groups > memcg_limited_groups_array_size) {
 		int i;
+		struct memcg_cache_params *new_params;
 		ssize_t size = memcg_caches_array_size(num_groups);
 
 		size *= sizeof(void *);
 		size += offsetof(struct memcg_cache_params, memcg_caches);
 
-		s->memcg_params = kzalloc(size, GFP_KERNEL);
-		if (!s->memcg_params) {
-			s->memcg_params = cur_params;
+		new_params = kzalloc(size, GFP_KERNEL);
+		if (!new_params)
 			return -ENOMEM;
-		}
 
-		s->memcg_params->is_root_cache = true;
+		new_params->is_root_cache = true;
 
 		/*
 		 * There is the chance it will be bigger than
@@ -3163,7 +3162,7 @@ int memcg_update_cache_size(struct kmem_
 		for (i = 0; i < memcg_limited_groups_array_size; i++) {
 			if (!cur_params->memcg_caches[i])
 				continue;
-			s->memcg_params->memcg_caches[i] =
+			new_params->memcg_caches[i] =
 						cur_params->memcg_caches[i];
 		}
 
@@ -3176,7 +3175,9 @@ int memcg_update_cache_size(struct kmem_
 		 * bigger than the others. And all updates will reset this
 		 * anyway.
 		 */
-		kfree(cur_params);
+		rcu_assign_pointer(s->memcg_params, new_params);
+		if (cur_params)
+			kfree_rcu(cur_params, rcu_head);
 	}
 	return 0;
 }
diff -puN mm/slab.h~memcg-slab-rcu-protect-memcg_params-for-root-caches mm/slab.h
--- a/mm/slab.h~memcg-slab-rcu-protect-memcg_params-for-root-caches
+++ a/mm/slab.h
@@ -160,14 +160,28 @@ static inline const char *cache_name(str
 	return s->name;
 }
 
+/*
+ * Note, we protect with RCU only the memcg_caches array, not per-memcg caches.
+ * That said the caller must assure the memcg's cache won't go away. Since once
+ * created a memcg's cache is destroyed only along with the root cache, it is
+ * true if we are going to allocate from the cache or hold a reference to the
+ * root cache by other means. Otherwise, we should hold either the slab_mutex
+ * or the memcg's slab_caches_mutex while calling this function and accessing
+ * the returned value.
+ */
 static inline struct kmem_cache *
 cache_from_memcg_idx(struct kmem_cache *s, int idx)
 {
 	struct kmem_cache *cachep;
+	struct memcg_cache_params *params;
 
 	if (!s->memcg_params)
 		return NULL;
-	cachep = s->memcg_params->memcg_caches[idx];
+
+	rcu_read_lock();
+	params = rcu_dereference(s->memcg_params);
+	cachep = params->memcg_caches[idx];
+	rcu_read_unlock();
 
 	/*
 	 * Make sure we will access the up-to-date value. The code updating
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

