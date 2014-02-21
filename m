From: akpm@linux-foundation.org
Subject: + memcg-slab-cleanup-memcg-cache-creation.patch added to -mm tree
Date: Fri, 21 Feb 2014 14:29:12 -0800
Message-ID: <5307d338.UBiaPd9hKIh0H1aU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaBUW3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 17:29:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@gmail.com, vdavydov@parallels.com

Subject: + memcg-slab-cleanup-memcg-cache-creation.patch added to -mm tree
To: vdavydov@parallels.com,glommer@gmail.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 14:29:12 -0800


The patch titled
     Subject: memcg, slab: cleanup memcg cache creation
has been added to the -mm tree.  Its filename is
     memcg-slab-cleanup-memcg-cache-creation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-slab-cleanup-memcg-cache-creation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-slab-cleanup-memcg-cache-creation.patch

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
 mm/memcontrol.c            |   89 +++++++++++++++--------------------
 mm/slab_common.c           |    5 +
 3 files changed, 53 insertions(+), 50 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-slab-cleanup-memcg-cache-creation include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-slab-cleanup-memcg-cache-creation
+++ a/include/linux/memcontrol.h
@@ -497,6 +497,9 @@ void __memcg_kmem_commit_charge(struct p
 void __memcg_kmem_uncharge_pages(struct page *page, int order);
 
 int memcg_cache_id(struct mem_cgroup *memcg);
+
+char *memcg_create_cache_name(struct mem_cgroup *memcg,
+			      struct kmem_cache *root_cache);
 int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
 			     struct kmem_cache *root_cache);
 void memcg_free_cache_params(struct kmem_cache *s);
@@ -641,6 +644,12 @@ static inline int memcg_cache_id(struct
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
@@ -3193,6 +3193,29 @@ int memcg_update_cache_size(struct kmem_
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
@@ -3397,44 +3420,6 @@ void mem_cgroup_destroy_cache(struct kme
 	schedule_work(&cachep->memcg_params->destroy);
 }
 
-static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
-						  struct kmem_cache *s)
-{
-	struct kmem_cache *new = NULL;
-	static char *tmp_name = NULL;
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
-	if (!tmp_name) {
-		tmp_name = kmalloc(PATH_MAX, GFP_KERNEL);
-		if (!tmp_name)
-			goto out;
-	}
-
-	rcu_read_lock();
-	snprintf(tmp_name, PATH_MAX, "%s(%d:%s)", s->name,
-			 memcg_cache_id(memcg), cgroup_name(memcg->css.cgroup));
-	rcu_read_unlock();
-
-	new = kmem_cache_create_memcg(memcg, tmp_name, s->object_size, s->align,
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
@@ -3481,12 +3466,6 @@ void kmem_cache_destroy_memcg_children(s
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
@@ -3504,13 +3483,25 @@ static void mem_cgroup_destroy_all_cache
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

mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
linux-next.patch

