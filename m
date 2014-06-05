From: akpm@linux-foundation.org
Subject: [merged] memcg-get-rid-of-memcg_create_cache_name.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:51:37 -0700
Message-ID: <5390ca49.nKI4Rd82gu+SZMSv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaFETvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, vdavydov@parallels.com

Subject: [merged] memcg-get-rid-of-memcg_create_cache_name.patch removed from -mm tree
To: vdavydov@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:37 -0700


The patch titled
     Subject: memcg: get rid of memcg_create_cache_name
has been removed from the -mm tree.  Its filename was
     memcg-get-rid-of-memcg_create_cache_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: get rid of memcg_create_cache_name

Instead of calling back to memcontrol.c from kmem_cache_create_memcg in
order to just create the name of a per memcg cache, let's allocate it in
place.  We only need to pass the memcg name to kmem_cache_create_memcg for
that - everything else can be done in slab_common.c.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 --
 include/linux/slab.h       |    3 ++-
 mm/memcontrol.c            |   33 +++++++++------------------------
 mm/slab_common.c           |    7 +++++--
 4 files changed, 16 insertions(+), 29 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-get-rid-of-memcg_create_cache_name include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-get-rid-of-memcg_create_cache_name
+++ a/include/linux/memcontrol.h
@@ -492,8 +492,6 @@ void __memcg_kmem_uncharge_pages(struct
 
 int memcg_cache_id(struct mem_cgroup *memcg);
 
-char *memcg_create_cache_name(struct mem_cgroup *memcg,
-			      struct kmem_cache *root_cache);
 int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
 			     struct kmem_cache *root_cache);
 void memcg_free_cache_params(struct kmem_cache *s);
diff -puN include/linux/slab.h~memcg-get-rid-of-memcg_create_cache_name include/linux/slab.h
--- a/include/linux/slab.h~memcg-get-rid-of-memcg_create_cache_name
+++ a/include/linux/slab.h
@@ -117,7 +117,8 @@ struct kmem_cache *kmem_cache_create(con
 			void (*)(void *));
 #ifdef CONFIG_MEMCG_KMEM
 struct kmem_cache *kmem_cache_create_memcg(struct mem_cgroup *,
-					   struct kmem_cache *);
+					   struct kmem_cache *,
+					   const char *);
 #endif
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
diff -puN mm/memcontrol.c~memcg-get-rid-of-memcg_create_cache_name mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-get-rid-of-memcg_create_cache_name
+++ a/mm/memcontrol.c
@@ -3095,29 +3095,6 @@ int memcg_update_cache_size(struct kmem_
 	return 0;
 }
 
-char *memcg_create_cache_name(struct mem_cgroup *memcg,
-			      struct kmem_cache *root_cache)
-{
-	static char *buf;
-
-	/*
-	 * We need a mutex here to protect the shared buffer. Since this is
-	 * expected to be called only on cache creation, we can employ the
-	 * slab_mutex for that purpose.
-	 */
-	lockdep_assert_held(&slab_mutex);
-
-	if (!buf) {
-		buf = kmalloc(NAME_MAX + 1, GFP_KERNEL);
-		if (!buf)
-			return NULL;
-	}
-
-	cgroup_name(memcg->css.cgroup, buf, NAME_MAX + 1);
-	return kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
-			 memcg_cache_id(memcg), buf);
-}
-
 int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
 			     struct kmem_cache *root_cache)
 {
@@ -3158,6 +3135,7 @@ void memcg_free_cache_params(struct kmem
 static void memcg_kmem_create_cache(struct mem_cgroup *memcg,
 				    struct kmem_cache *root_cache)
 {
+	static char *memcg_name_buf;	/* protected by memcg_slab_mutex */
 	struct kmem_cache *cachep;
 	int id;
 
@@ -3173,7 +3151,14 @@ static void memcg_kmem_create_cache(stru
 	if (cache_from_memcg_idx(root_cache, id))
 		return;
 
-	cachep = kmem_cache_create_memcg(memcg, root_cache);
+	if (!memcg_name_buf) {
+		memcg_name_buf = kmalloc(NAME_MAX + 1, GFP_KERNEL);
+		if (!memcg_name_buf)
+			return;
+	}
+
+	cgroup_name(memcg->css.cgroup, memcg_name_buf, NAME_MAX + 1);
+	cachep = kmem_cache_create_memcg(memcg, root_cache, memcg_name_buf);
 	/*
 	 * If we could not create a memcg cache, do not complain, because
 	 * that's not critical at all as we can always proceed with the root
diff -puN mm/slab_common.c~memcg-get-rid-of-memcg_create_cache_name mm/slab_common.c
--- a/mm/slab_common.c~memcg-get-rid-of-memcg_create_cache_name
+++ a/mm/slab_common.c
@@ -264,13 +264,15 @@ EXPORT_SYMBOL(kmem_cache_create);
  * kmem_cache_create_memcg - Create a cache for a memory cgroup.
  * @memcg: The memory cgroup the new cache is for.
  * @root_cache: The parent of the new cache.
+ * @memcg_name: The name of the memory cgroup (used for naming the new cache).
  *
  * This function attempts to create a kmem cache that will serve allocation
  * requests going from @memcg to @root_cache. The new cache inherits properties
  * from its parent.
  */
 struct kmem_cache *kmem_cache_create_memcg(struct mem_cgroup *memcg,
-					   struct kmem_cache *root_cache)
+					   struct kmem_cache *root_cache,
+					   const char *memcg_name)
 {
 	struct kmem_cache *s = NULL;
 	char *cache_name;
@@ -280,7 +282,8 @@ struct kmem_cache *kmem_cache_create_mem
 
 	mutex_lock(&slab_mutex);
 
-	cache_name = memcg_create_cache_name(memcg, root_cache);
+	cache_name = kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
+			       memcg_cache_id(memcg), memcg_name);
 	if (!cache_name)
 		goto out_unlock;
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

