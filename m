From: akpm@linux-foundation.org
Subject: + memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
 added to -mm tree
Date: Thu, 18 Dec 2014 14:12:31 -0800
Message-ID: <5493514f.V77q8qDRY/i23G9x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaLRWMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 17:12:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: zap memcg_name argument of memcg_create_kmem_cache
has been added to the -mm tree.  Its filename is
     memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch

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
Subject: memcg: zap memcg_name argument of memcg_create_kmem_cache

Instead of passing the name of the memory cgroup which the cache is
created for in the memcg_name_argument, let's obtain it immediately in
memcg_create_kmem_cache.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    3 +--
 mm/memcontrol.c      |    5 +----
 mm/slab_common.c     |    9 +++++----
 3 files changed, 7 insertions(+), 10 deletions(-)

diff -puN include/linux/slab.h~memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache include/linux/slab.h
--- a/include/linux/slab.h~memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache
+++ a/include/linux/slab.h
@@ -117,8 +117,7 @@ struct kmem_cache *kmem_cache_create(con
 			void (*)(void *));
 #ifdef CONFIG_MEMCG_KMEM
 struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *,
-					   struct kmem_cache *,
-					   const char *);
+					   struct kmem_cache *);
 #endif
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
diff -puN mm/memcontrol.c~memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache
+++ a/mm/memcontrol.c
@@ -2607,8 +2607,6 @@ void memcg_update_array_size(int num)
 static void memcg_register_cache(struct mem_cgroup *memcg,
 				 struct kmem_cache *root_cache)
 {
-	static char memcg_name_buf[NAME_MAX + 1]; /* protected by
-						     memcg_slab_mutex */
 	struct kmem_cache *cachep;
 	int id;
 
@@ -2624,8 +2622,7 @@ static void memcg_register_cache(struct
 	if (cache_from_memcg_idx(root_cache, id))
 		return;
 
-	cgroup_name(memcg->css.cgroup, memcg_name_buf, NAME_MAX + 1);
-	cachep = memcg_create_kmem_cache(memcg, root_cache, memcg_name_buf);
+	cachep = memcg_create_kmem_cache(memcg, root_cache);
 	/*
 	 * If we could not create a memcg cache, do not complain, because
 	 * that's not critical at all as we can always proceed with the root
diff -puN mm/slab_common.c~memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache mm/slab_common.c
--- a/mm/slab_common.c~memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache
+++ a/mm/slab_common.c
@@ -430,16 +430,15 @@ EXPORT_SYMBOL(kmem_cache_create);
  * memcg_create_kmem_cache - Create a cache for a memory cgroup.
  * @memcg: The memory cgroup the new cache is for.
  * @root_cache: The parent of the new cache.
- * @memcg_name: The name of the memory cgroup (used for naming the new cache).
  *
  * This function attempts to create a kmem cache that will serve allocation
  * requests going from @memcg to @root_cache. The new cache inherits properties
  * from its parent.
  */
 struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
-					   struct kmem_cache *root_cache,
-					   const char *memcg_name)
+					   struct kmem_cache *root_cache)
 {
+	static char memcg_name_buf[NAME_MAX + 1]; /* protected by slab_mutex */
 	struct kmem_cache *s = NULL;
 	char *cache_name;
 
@@ -448,8 +447,10 @@ struct kmem_cache *memcg_create_kmem_cac
 
 	mutex_lock(&slab_mutex);
 
+	cgroup_name(mem_cgroup_css(memcg)->cgroup,
+		    memcg_name_buf, sizeof(memcg_name_buf));
 	cache_name = kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
-			       memcg_cache_id(memcg), memcg_name);
+			       memcg_cache_id(memcg), memcg_name_buf);
 	if (!cache_name)
 		goto out_unlock;
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch

