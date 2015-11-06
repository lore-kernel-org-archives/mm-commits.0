From: akpm@linux-foundation.org
Subject: [merged] slab_common-rename-cache-create-destroy-helpers.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:34 -0800
Message-ID: <563d084a.SbdGAYS7fnpOb0eh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161787AbbKFUGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common.c: rename cache create/destroy helpers
has been removed from the -mm tree.  Its filename was
     slab_common-rename-cache-create-destroy-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm/slab_common.c: rename cache create/destroy helpers

do_kmem_cache_create(), do_kmem_cache_shutdown(), and
do_kmem_cache_release() sound awkward for static helper functions that are
not supposed to be used outside slab_common.c.  Rename them to
create_cache(), shutdown_cache(), and release_caches(), respectively. 
This patch is a pure cleanup and does not introduce any functional
changes.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff -puN mm/slab_common.c~slab_common-rename-cache-create-destroy-helpers mm/slab_common.c
--- a/mm/slab_common.c~slab_common-rename-cache-create-destroy-helpers
+++ a/mm/slab_common.c
@@ -316,10 +316,10 @@ unsigned long calculate_alignment(unsign
 	return ALIGN(align, sizeof(void *));
 }
 
-static struct kmem_cache *
-do_kmem_cache_create(const char *name, size_t object_size, size_t size,
-		     size_t align, unsigned long flags, void (*ctor)(void *),
-		     struct mem_cgroup *memcg, struct kmem_cache *root_cache)
+static struct kmem_cache *create_cache(const char *name,
+		size_t object_size, size_t size, size_t align,
+		unsigned long flags, void (*ctor)(void *),
+		struct mem_cgroup *memcg, struct kmem_cache *root_cache)
 {
 	struct kmem_cache *s;
 	int err;
@@ -418,9 +418,9 @@ kmem_cache_create(const char *name, size
 		goto out_unlock;
 	}
 
-	s = do_kmem_cache_create(cache_name, size, size,
-				 calculate_alignment(flags, align, size),
-				 flags, ctor, NULL, NULL);
+	s = create_cache(cache_name, size, size,
+			 calculate_alignment(flags, align, size),
+			 flags, ctor, NULL, NULL);
 	if (IS_ERR(s)) {
 		err = PTR_ERR(s);
 		kfree_const(cache_name);
@@ -448,7 +448,7 @@ out_unlock:
 }
 EXPORT_SYMBOL(kmem_cache_create);
 
-static int do_kmem_cache_shutdown(struct kmem_cache *s,
+static int shutdown_cache(struct kmem_cache *s,
 		struct list_head *release, bool *need_rcu_barrier)
 {
 	if (__kmem_cache_shutdown(s) != 0) {
@@ -469,8 +469,7 @@ static int do_kmem_cache_shutdown(struct
 	return 0;
 }
 
-static void do_kmem_cache_release(struct list_head *release,
-				  bool need_rcu_barrier)
+static void release_caches(struct list_head *release, bool need_rcu_barrier)
 {
 	struct kmem_cache *s, *s2;
 
@@ -536,10 +535,10 @@ void memcg_create_kmem_cache(struct mem_
 	if (!cache_name)
 		goto out_unlock;
 
-	s = do_kmem_cache_create(cache_name, root_cache->object_size,
-				 root_cache->size, root_cache->align,
-				 root_cache->flags, root_cache->ctor,
-				 memcg, root_cache);
+	s = create_cache(cache_name, root_cache->object_size,
+			 root_cache->size, root_cache->align,
+			 root_cache->flags, root_cache->ctor,
+			 memcg, root_cache);
 	/*
 	 * If we could not create a memcg cache, do not complain, because
 	 * that's not critical at all as we can always proceed with the root
@@ -615,14 +614,14 @@ void memcg_destroy_kmem_caches(struct me
 		 * The cgroup is about to be freed and therefore has no charges
 		 * left. Hence, all its caches must be empty by now.
 		 */
-		BUG_ON(do_kmem_cache_shutdown(s, &release, &need_rcu_barrier));
+		BUG_ON(shutdown_cache(s, &release, &need_rcu_barrier));
 	}
 	mutex_unlock(&slab_mutex);
 
 	put_online_mems();
 	put_online_cpus();
 
-	do_kmem_cache_release(&release, need_rcu_barrier);
+	release_caches(&release, need_rcu_barrier);
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
@@ -655,12 +654,12 @@ void kmem_cache_destroy(struct kmem_cach
 		goto out_unlock;
 
 	for_each_memcg_cache_safe(c, c2, s) {
-		if (do_kmem_cache_shutdown(c, &release, &need_rcu_barrier))
+		if (shutdown_cache(c, &release, &need_rcu_barrier))
 			busy = true;
 	}
 
 	if (!busy)
-		do_kmem_cache_shutdown(s, &release, &need_rcu_barrier);
+		shutdown_cache(s, &release, &need_rcu_barrier);
 
 out_unlock:
 	mutex_unlock(&slab_mutex);
@@ -668,7 +667,7 @@ out_unlock:
 	put_online_mems();
 	put_online_cpus();
 
-	do_kmem_cache_release(&release, need_rcu_barrier);
+	release_caches(&release, need_rcu_barrier);
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

memcg-simplify-charging-kmem-pages.patch
memcg-unify-slab-and-other-kmem-pages-charging.patch
memcg-simplify-and-inline-__mem_cgroup_from_kmem.patch
mm-do-not-inc-nr_pagetable-if-ptlock_init-failed.patch

