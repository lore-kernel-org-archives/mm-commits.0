From: akpm@linux-foundation.org
Subject: +
 memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch added to
 -mm tree
Date: Mon, 06 Jan 2014 14:56:17 -0800
Message-ID: <52cb3491.zx9Cc7h3ffgHK3GJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957AbaAFW4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jan 2014 17:56:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@gmail.com, cl@linux.com, bsingharora@gmail.com, vdavydov@parallels.com

Subject: + memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch added to -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,cl@linux.com,glommer@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 06 Jan 2014 14:56:17 -0800


The patch titled
     Subject: memcg, slab: kmem_cache_create_memcg(): fix memleak on fail path
has been added to the -mm tree.  Its filename is
     memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch

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
Subject: memcg, slab: kmem_cache_create_memcg(): fix memleak on fail path

We do not free the cache's memcg_params if __kmem_cache_create fails.  Fix
this.

Plus, rename memcg_register_cache() to memcg_alloc_cache_params(), because
it actually does not register the cache anywhere, but simply initialize
kmem_cache::memcg_params.

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
 
+static inline void memcg_free_cache_params(struct kmem_cache *s);
+{
+}
+
 static inline void memcg_release_cache(struct kmem_cache *cachep)
 {
 }
diff -puN mm/memcontrol.c~memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path
+++ a/mm/memcontrol.c
@@ -3191,8 +3191,8 @@ int memcg_update_cache_size(struct kmem_
 	return 0;
 }
 
-int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
-			 struct kmem_cache *root_cache)
+int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
+			     struct kmem_cache *root_cache)
 {
 	size_t size;
 
@@ -3220,6 +3220,11 @@ int memcg_register_cache(struct mem_cgro
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
@@ -3248,7 +3253,7 @@ void memcg_release_cache(struct kmem_cac
 
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

