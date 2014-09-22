From: akpm@linux-foundation.org
Subject: +
 memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch added to -mm tree
Date: Mon, 22 Sep 2014 12:44:42 -0700
Message-ID: <54207c2a.btcnUV+DLTbZuAk+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaIVTon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Sep 2014 15:44:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, glommer@gmail.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: don't call memcg_update_all_caches if new cache id fits
has been added to the -mm tree.  Its filename is
     memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch

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
Subject: memcg: don't call memcg_update_all_caches if new cache id fits

memcg_update_all_caches grows arrays of per-memcg caches, so we only need
to call it when memcg_limited_groups_array_size is increased.  However,
currently we invoke it each time a new kmem-active memory cgroup is
created.  Then it just iterates over all slab_caches and does nothing
(memcg_update_cache_size returns immediately).

This patch fixes this insanity.  In the meantime it moves the code dealing
with id allocations to separate functions, memcg_alloc_cache_id and
memcg_free_cache_id.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  136 ++++++++++++++++++++++++----------------------
 1 file changed, 72 insertions(+), 64 deletions(-)

diff -puN mm/memcontrol.c~memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits
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
@@ -2892,19 +2894,44 @@ int memcg_cache_id(struct mem_cgroup *me
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
+
+	if (id < memcg_limited_groups_array_size)
+		return id;
+
+	/*
+	 * There's no space for the new id in memcg_caches arrays,
+	 * so we have to grow them.
+	 */
 
-	size = 2 * num_groups;
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
+}
+
+static void memcg_free_cache_id(int id)
+{
+	ida_simple_remove(&kmem_limited_groups, id);
 }
 
 /*
@@ -2914,59 +2941,55 @@ static size_t memcg_caches_array_size(in
  */
 void memcg_update_array_size(int num)
 {
-	if (num > memcg_limited_groups_array_size)
-		memcg_limited_groups_array_size = memcg_caches_array_size(num);
+	memcg_limited_groups_array_size = num;
 }
 
 int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
 {
 	struct memcg_cache_params *cur_params = s->memcg_params;
+	struct memcg_cache_params *new_params;
+	size_t size;
+	int i;
 
 	VM_BUG_ON(!is_root_cache(s));
 
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
+	size = num_groups * sizeof(void *);
+	size += offsetof(struct memcg_cache_params, memcg_caches);
 
-		new_params->is_root_cache = true;
+	new_params = kzalloc(size, GFP_KERNEL);
+	if (!new_params)
+		return -ENOMEM;
 
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
+	new_params->is_root_cache = true;
 
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
+	/*
+	 * There is the chance it will be bigger than
+	 * memcg_limited_groups_array_size, if we failed an allocation
+	 * in a cache, in which case all caches updated before it, will
+	 * have a bigger array.
+	 *
+	 * But if that is the case, the data after
+	 * memcg_limited_groups_array_size is certainly unused
+	 */
+	for (i = 0; i < memcg_limited_groups_array_size; i++) {
+		if (!cur_params->memcg_caches[i])
+			continue;
+		new_params->memcg_caches[i] =
+			cur_params->memcg_caches[i];
 	}
+
+	/*
+	 * Ideally, we would wait until all caches succeed, and only
+	 * then free the old one. But this is not worth the extra
+	 * pointer per-cache we'd have to have for this.
+	 *
+	 * It is not a big deal if some caches are left with a size
+	 * bigger than the others. And all updates will reset this
+	 * anyway.
+	 */
+	rcu_assign_pointer(s->memcg_params, new_params);
+	if (cur_params)
+		kfree_rcu(cur_params, rcu_head);
 	return 0;
 }
 
@@ -4167,23 +4190,12 @@ static int __memcg_activate_kmem(struct
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
 
@@ -4204,10 +4216,6 @@ static int __memcg_activate_kmem(struct
 out:
 	memcg_resume_kmem_account();
 	return err;
