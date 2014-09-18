From: akpm@linux-foundation.org
Subject: + memcg-move-memcg_update_cache_size-to-slab_commonc.patch added
 to -mm tree
Date: Thu, 18 Sep 2014 12:12:08 -0700
Message-ID: <541b2e88.wkYr5GqJBfTqGajz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaIRTMJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 15:12:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, glommer@parallels.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: move memcg_update_cache_size to slab_common.c
has been added to the -mm tree.  Its filename is
     memcg-move-memcg_update_cache_size-to-slab_commonc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-move-memcg_update_cache_size-to-slab_commonc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-move-memcg_update_cache_size-to-slab_commonc.patch

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
Subject: memcg: move memcg_update_cache_size to slab_common.c

The only reason why this function lives in memcontrol.c is that it depends
on memcg_caches_array_size.  However, we can pass the new array size
immediately to it instead of new_id+1 so that it will be free of any
memcontrol.c dependencies.

So let's move this function to slab_common.c and make it static.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 
 mm/memcontrol.c            |  114 +++++++++++------------------------
 mm/slab_common.c           |   30 ++++++++-
 3 files changed, 65 insertions(+), 80 deletions(-)

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
@@ -646,11 +646,13 @@ int memcg_limited_groups_array_size;
 struct static_key memcg_kmem_enabled_key;
 EXPORT_SYMBOL(memcg_kmem_enabled_key);
 
+static void memcg_free_cache_id(int id);
+
 static void disarm_kmem_keys(struct mem_cgroup *memcg)
 {
 	if (memcg_kmem_is_active(memcg)) {
 		static_key_slow_dec(&memcg_kmem_enabled_key);
-		ida_simple_remove(&kmem_limited_groups, memcg->kmemcg_id);
+		memcg_free_cache_id(memcg->kmemcg_id);
 	}
 	/*
 	 * This check can't live in kmem destruction function,
@@ -2892,19 +2894,45 @@ int memcg_cache_id(struct mem_cgroup *me
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
-static size_t memcg_caches_array_size(int num_groups)
+static int memcg_alloc_cache_id(void)
 {
-	ssize_t size;
-	if (num_groups <= 0)
-		return 0;
+	int id, size;
+	int err;
+
+	id = ida_simple_get(&kmem_limited_groups,
+			    0, MEMCG_CACHES_MAX_SIZE, GFP_KERNEL);
+	if (id < 0)
+		return id;
 
-	size = 2 * num_groups;
+	if (id < memcg_limited_groups_array_size)
+		return id;
+
+	/*
+	 * There's no space for the new id in memcg_caches arrays,
+	 * so we have to grow them.
+	 */
+
+	size = 2 * (id + 1);
 	if (size < MEMCG_CACHES_MIN_SIZE)
 		size = MEMCG_CACHES_MIN_SIZE;
 	else if (size > MEMCG_CACHES_MAX_SIZE)
 		size = MEMCG_CACHES_MAX_SIZE;
 
-	return size;
+	mutex_lock(&memcg_slab_mutex);
+	err = memcg_update_all_caches(size);
+	mutex_unlock(&memcg_slab_mutex);
+
+	if (err) {
+		ida_simple_remove(&kmem_limited_groups, id);
+		return err;
+	}
+	return id;
+
+}
+
+static void memcg_free_cache_id(int id)
+{
+	ida_simple_remove(&kmem_limited_groups, id);
 }
 
 /*
@@ -2914,60 +2942,7 @@ static size_t memcg_caches_array_size(in
  */
 void memcg_update_array_size(int num)
 {
-	if (num > memcg_limited_groups_array_size)
-		memcg_limited_groups_array_size = memcg_caches_array_size(num);
-}
-
-int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
-{
-	struct memcg_cache_params *cur_params = s->memcg_params;
-
-	VM_BUG_ON(!is_root_cache(s));
-
-	if (num_groups > memcg_limited_groups_array_size) {
-		int i;
-		struct memcg_cache_params *new_params;
-		ssize_t size = memcg_caches_array_size(num_groups);
-
-		size *= sizeof(void *);
-		size += offsetof(struct memcg_cache_params, memcg_caches);
-
-		new_params = kzalloc(size, GFP_KERNEL);
-		if (!new_params)
-			return -ENOMEM;
-
-		new_params->is_root_cache = true;
-
-		/*
-		 * There is the chance it will be bigger than
-		 * memcg_limited_groups_array_size, if we failed an allocation
-		 * in a cache, in which case all caches updated before it, will
-		 * have a bigger array.
-		 *
-		 * But if that is the case, the data after
-		 * memcg_limited_groups_array_size is certainly unused
-		 */
-		for (i = 0; i < memcg_limited_groups_array_size; i++) {
-			if (!cur_params->memcg_caches[i])
-				continue;
-			new_params->memcg_caches[i] =
-						cur_params->memcg_caches[i];
-		}
-
-		/*
-		 * Ideally, we would wait until all caches succeed, and only
-		 * then free the old one. But this is not worth the extra
-		 * pointer per-cache we'd have to have for this.
-		 *
-		 * It is not a big deal if some caches are left with a size
-		 * bigger than the others. And all updates will reset this
-		 * anyway.
-		 */
-		rcu_assign_pointer(s->memcg_params, new_params);
-		if (cur_params)
-			kfree_rcu(cur_params, rcu_head);
-	}
-	return 0;
+	memcg_limited_groups_array_size = num;
 }
 
 static void memcg_register_cache(struct mem_cgroup *memcg,
@@ -4167,23 +4142,12 @@ static int __memcg_activate_kmem(struct
 	if (err)
 		goto out;
 
-	memcg_id = ida_simple_get(&kmem_limited_groups,
-				  0, MEMCG_CACHES_MAX_SIZE, GFP_KERNEL);
+	memcg_id = memcg_alloc_cache_id();
 	if (memcg_id < 0) {
 		err = memcg_id;
 		goto out;
 	}
 
-	/*
-	 * Make sure we have enough space for this cgroup in each root cache's
-	 * memcg_params.
-	 */
-	mutex_lock(&memcg_slab_mutex);
-	err = memcg_update_all_caches(memcg_id + 1);
-	mutex_unlock(&memcg_slab_mutex);
-	if (err)
-		goto out_rmid;
-
 	memcg->kmemcg_id = memcg_id;
 	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
 
@@ -4204,10 +4168,6 @@ static int __memcg_activate_kmem(struct
 out:
 	memcg_resume_kmem_account();
 	return err;
-
-out_rmid:
-	ida_simple_remove(&kmem_limited_groups, memcg_id);
-	goto out;
 }
 
 static int memcg_activate_kmem(struct mem_cgroup *memcg,
diff -puN mm/slab_common.c~memcg-move-memcg_update_cache_size-to-slab_commonc mm/slab_common.c
--- a/mm/slab_common.c~memcg-move-memcg_update_cache_size-to-slab_commonc
+++ a/mm/slab_common.c
@@ -120,6 +120,33 @@ static void memcg_free_cache_params(stru
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
@@ -130,9 +157,8 @@ int memcg_update_all_caches(int num_memc
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

memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
linux-next.patch

