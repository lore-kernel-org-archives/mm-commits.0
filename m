From: akpm@linux-foundation.org
Subject: [merged]
 memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 10:58:37 -0800
Message-ID: <52e2b7dd.69+ouPcAXIQTJwNg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@gmail.com, cl@linux.com, bsingharora@gmail.com, vdavydov@parallels.com

Subject: [merged] memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch removed from -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,cl@linux.com,glommer@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:37 -0800


The patch titled
     Subject: memcg, slab: kmem_cache_create_memcg(): fix memleak on fail path
has been removed from the -mm tree.  Its filename was
     memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg, slab: kmem_cache_create_memcg(): fix memleak on fail path

We do not free the cache's memcg_params if __kmem_cache_create fails.  Fix
this.

Plus, rename memcg_register_cache() to memcg_alloc_cache_params(), because
it actually does not register the cache anywhere, but simply initialize
kmem_cache::memcg_params.

[akpm@linux-foundation.org: fix build]
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

 include/linux/memcontrol.h |   14 +++++++++-----
 mm/memcontrol.c            |   11 ++++++++---
 mm/slab_common.c           |    3 ++-
 3 files changed, 19 insertions(+), 9 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path
+++ a/include/linux/memcontrol.h
@@ -497,8 +497,9 @@ void __memcg_kmem_commit_charge(struct p
 void __memcg_kmem_uncharge_pages(struct page *page, int order);
 
 int memcg_cache_id(struct mem_cgroup *memcg);
-int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
-			 struct kmem_cache *root_cache);
+int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
+			     struct kmem_cache *root_cache);
+void memcg_free_cache_params(struct kmem_cache *s);
 void memcg_release_cache(struct kmem_cache *cachep);
 void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep);
 
@@ -640,13 +641,16 @@ static inline int memcg_cache_id(struct
 	return -1;
 }
 
-static inline int
-memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
-		     struct kmem_cache *root_cache)
+static inline int memcg_alloc_cache_params(struct mem_cgroup *memcg,
+		struct kmem_cache *s, struct kmem_cache *root_cache)
 {
 	return 0;
 }
 
+static inline void memcg_free_cache_params(struct kmem_cache *s)
+{
+}
+
 static inline void memcg_release_cache(struct kmem_cache *cachep)
 {
 }
diff -puN mm/memcontrol.c~memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path
+++ a/mm/memcontrol.c
@@ -3231,8 +3231,8 @@ int memcg_update_cache_size(struct kmem_
 	return 0;
 }
 
-int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
-			 struct kmem_cache *root_cache)
+int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
+			     struct kmem_cache *root_cache)
 {
 	size_t size;
 
@@ -3260,6 +3260,11 @@ int memcg_register_cache(struct mem_cgro
 	return 0;
 }
 
+void memcg_free_cache_params(struct kmem_cache *s)
+{
+	kfree(s->memcg_params);
+}
+
 void memcg_release_cache(struct kmem_cache *s)
 {
 	struct kmem_cache *root;
@@ -3288,7 +3293,7 @@ void memcg_release_cache(struct kmem_cac
 
 	css_put(&memcg->css);
 out:
-	kfree(s->memcg_params);
+	memcg_free_cache_params(s);
 }
 
 /*
diff -puN mm/slab_common.c~memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path mm/slab_common.c
--- a/mm/slab_common.c~memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path
+++ a/mm/slab_common.c
@@ -205,7 +205,7 @@ kmem_cache_create_memcg(struct mem_cgrou
 	if (!s->name)
 		goto out_free_cache;
 
-	err = memcg_register_cache(memcg, s, parent_cache);
+	err = memcg_alloc_cache_params(memcg, s, parent_cache);
 	if (err)
 		goto out_free_cache;
 
@@ -235,6 +235,7 @@ out_unlock:
 	return s;
 
 out_free_cache:
+	memcg_free_cache_params(s);
 	kfree(s->name);
 	kmem_cache_free(kmem_cache, s);
 	goto out_unlock;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch

