From: akpm@linux-foundation.org
Subject: [merged] memcg-slab-cleanup-memcg-cache-creation.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:41:53 -0700
Message-ID: <53446d21.t4LKcnljXP4AgBiT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbaDHVly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@gmail.com, vdavydov@parallels.com

Subject: [merged] memcg-slab-cleanup-memcg-cache-creation.patch removed from -mm tree
To: vdavydov@parallels.com,glommer@gmail.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:41:53 -0700


The patch titled
     Subject: memcg, slab: cleanup memcg cache creation
has been removed from the -mm tree.  Its filename was
     memcg-slab-cleanup-memcg-cache-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg, slab: cleanup memcg cache creation

This patch cleans up the memcg cache creation path as follows:

- Move memcg cache name creation to a separate function to be called
  from kmem_cache_create_memcg().  This allows us to get rid of the mutex
  protecting the temporary buffer used for the name formatting, because
  the whole cache creation path is protected by the slab_mutex.

- Get rid of memcg_create_kmem_cache().  This function serves as a proxy
  to kmem_cache_create_memcg().  After separating the cache name creation
  path, it would be reduced to a function call, so let's inline it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Glauber Costa <glommer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 +++
 mm/memcontrol.c            |   91 +++++++++++++++--------------------
 mm/slab_common.c           |    5 +
 3 files changed, 53 insertions(+), 52 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-slab-cleanup-memcg-cache-creation include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-slab-cleanup-memcg-cache-creation
+++ a/include/linux/memcontrol.h
@@ -491,6 +491,9 @@ void __memcg_kmem_commit_charge(struct p
 void __memcg_kmem_uncharge_pages(struct page *page, int order);
 
 int memcg_cache_id(struct mem_cgroup *memcg);
+
+char *memcg_create_cache_name(struct mem_cgroup *memcg,
+			      struct kmem_cache *root_cache);
 int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
 			     struct kmem_cache *root_cache);
 void memcg_free_cache_params(struct kmem_cache *s);
@@ -635,6 +638,12 @@ static inline int memcg_cache_id(struct
 	return -1;
 }
 
+static inline char *memcg_create_cache_name(struct mem_cgroup *memcg,
+					    struct kmem_cache *root_cache)
+{
+	return NULL;
+}
+
 static inline int memcg_alloc_cache_params(struct mem_cgroup *memcg,
 		struct kmem_cache *s, struct kmem_cache *root_cache)
 {
diff -puN mm/memcontrol.c~memcg-slab-cleanup-memcg-cache-creation mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slab-cleanup-memcg-cache-creation
+++ a/mm/memcontrol.c
@@ -3094,6 +3094,29 @@ int memcg_update_cache_size(struct kmem_
 	return 0;
 }
 
+char *memcg_create_cache_name(struct mem_cgroup *memcg,
+			      struct kmem_cache *root_cache)
+{
+	static char *buf = NULL;
+
+	/*
+	 * We need a mutex here to protect the shared buffer. Since this is
+	 * expected to be called only on cache creation, we can employ the
+	 * slab_mutex for that purpose.
+	 */
+	lockdep_assert_held(&slab_mutex);
+
+	if (!buf) {
+		buf = kmalloc(NAME_MAX + 1, GFP_KERNEL);
+		if (!buf)
+			return NULL;
+	}
+
+	cgroup_name(memcg->css.cgroup, buf, NAME_MAX + 1);
+	return kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
+			 memcg_cache_id(memcg), buf);
+}
+
 int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
 			     struct kmem_cache *root_cache)
 {
@@ -3298,46 +3321,6 @@ void mem_cgroup_destroy_cache(struct kme
 	schedule_work(&cachep->memcg_params->destroy);
 }
 
-static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
-						  struct kmem_cache *s)
-{
-	struct kmem_cache *new = NULL;
-	static char *tmp_path = NULL, *tmp_name = NULL;
-	static DEFINE_MUTEX(mutex);	/* protects tmp_name */
-
-	BUG_ON(!memcg_can_account_kmem(memcg));
-
-	mutex_lock(&mutex);
-	/*
-	 * kmem_cache_create_memcg duplicates the given name and
-	 * cgroup_name for this name requires RCU context.
-	 * This static temporary buffer is used to prevent from
-	 * pointless shortliving allocation.
-	 */
-	if (!tmp_path || !tmp_name) {
-		if (!tmp_path)
-			tmp_path = kmalloc(PATH_MAX, GFP_KERNEL);
-		if (!tmp_name)
-			tmp_name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
-		if (!tmp_path || !tmp_name)
-			goto out;
-	}
-
-	cgroup_name(memcg->css.cgroup, tmp_name, NAME_MAX + 1);
-	snprintf(tmp_path, PATH_MAX, "%s(%d:%s)", s->name,
-		 memcg_cache_id(memcg), tmp_name);
-
-	new = kmem_cache_create_memcg(memcg, tmp_path, s->object_size, s->align,
-				      (s->flags & ~SLAB_PANIC), s->ctor, s);
-	if (new)
-		new->allocflags |= __GFP_KMEMCG;
-	else
-		new = s;
-out:
-	mutex_unlock(&mutex);
-	return new;
-}
-
 void kmem_cache_destroy_memcg_children(struct kmem_cache *s)
 {
 	struct kmem_cache *c;
@@ -3384,12 +3367,6 @@ void kmem_cache_destroy_memcg_children(s
 	mutex_unlock(&activate_kmem_mutex);
 }
 
-struct create_work {
-	struct mem_cgroup *memcg;
-	struct kmem_cache *cachep;
-	struct work_struct work;
-};
-
 static void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
 {
 	struct kmem_cache *cachep;
@@ -3407,13 +3384,25 @@ static void mem_cgroup_destroy_all_cache
 	mutex_unlock(&memcg->slab_caches_mutex);
 }
 
+struct create_work {
+	struct mem_cgroup *memcg;
+	struct kmem_cache *cachep;
+	struct work_struct work;
+};
+
 static void memcg_create_cache_work_func(struct work_struct *w)
 {
-	struct create_work *cw;
-
-	cw = container_of(w, struct create_work, work);
-	memcg_create_kmem_cache(cw->memcg, cw->cachep);
-	css_put(&cw->memcg->css);
+	struct create_work *cw = container_of(w, struct create_work, work);
+	struct mem_cgroup *memcg = cw->memcg;
+	struct kmem_cache *cachep = cw->cachep;
+	struct kmem_cache *new;
+
+	new = kmem_cache_create_memcg(memcg, cachep->name,
+			cachep->object_size, cachep->align,
+			cachep->flags & ~SLAB_PANIC, cachep->ctor, cachep);
+	if (new)
+		new->allocflags |= __GFP_KMEMCG;
+	css_put(&memcg->css);
 	kfree(cw);
 }
 
diff -puN mm/slab_common.c~memcg-slab-cleanup-memcg-cache-creation mm/slab_common.c
--- a/mm/slab_common.c~memcg-slab-cleanup-memcg-cache-creation
+++ a/mm/slab_common.c
@@ -215,7 +215,10 @@ kmem_cache_create_memcg(struct mem_cgrou
 	s->align = calculate_alignment(flags, align, size);
 	s->ctor = ctor;
 
-	s->name = kstrdup(name, GFP_KERNEL);
+	if (memcg)
+		s->name = memcg_create_cache_name(memcg, parent_cache);
+	else
+		s->name = kstrdup(name, GFP_KERNEL);
 	if (!s->name)
 		goto out_free_cache;
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch

