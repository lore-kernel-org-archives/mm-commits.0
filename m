From: akpm@linux-foundation.org
Subject: [merged] slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:41:14 -0800
Message-ID: <20121219204115.6F2A7200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:65268 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab2LSUlT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:41:19 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so134016wgb.3
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:41:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab/slub: consider a memcg parameter in kmem_create_cache
has been removed from the -mm tree.  Its filename was
     slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: slab/slub: consider a memcg parameter in kmem_create_cache

Allow a memcg parameter to be passed during cache creation.  When the slub
allocator is being used, it will only merge caches that belong to the same
memcg.  We'll do this by scanning the global list, and then translating
the cache to a memcg-specific cache

Default function is created as a wrapper, passing NULL to the memcg
version.  We only merge caches that belong to the same memcg.

A helper is provided, memcg_css_id: because slub needs a unique cache name
for sysfs.  Since this is visible, but not the canonical location for slab
data, the cache name is not used, the css_id should suffice.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   26 +++++++++++++++++
 include/linux/slab.h       |   14 ++++++++-
 mm/memcontrol.c            |   51 +++++++++++++++++++++++++++++++++++
 mm/slab.h                  |   23 +++++++++++++--
 mm/slab_common.c           |   42 ++++++++++++++++++++++------
 mm/slub.c                  |   19 ++++++++++---
 6 files changed, 157 insertions(+), 18 deletions(-)

diff -puN include/linux/memcontrol.h~slab-slub-consider-a-memcg-parameter-in-kmem_create_cache include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~slab-slub-consider-a-memcg-parameter-in-kmem_create_cache
+++ a/include/linux/memcontrol.h
@@ -28,6 +28,7 @@ struct mem_cgroup;
 struct page_cgroup;
 struct page;
 struct mm_struct;
+struct kmem_cache;
 
 /* Stats that can be updated by kernel. */
 enum mem_cgroup_page_stat_item {
@@ -441,6 +442,11 @@ void __memcg_kmem_commit_charge(struct p
 				       struct mem_cgroup *memcg, int order);
 void __memcg_kmem_uncharge_pages(struct page *page, int order);
 
+int memcg_cache_id(struct mem_cgroup *memcg);
+int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s);
+void memcg_release_cache(struct kmem_cache *cachep);
+void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep);
+
 /**
  * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
  * @gfp: the gfp allocation flags.
@@ -525,6 +531,26 @@ static inline void
 memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg, int order)
 {
 }
+
+static inline int memcg_cache_id(struct mem_cgroup *memcg)
+{
+	return -1;
+}
+
+static inline int memcg_register_cache(struct mem_cgroup *memcg,
+				       struct kmem_cache *s)
+{
+	return 0;
+}
+
+static inline void memcg_release_cache(struct kmem_cache *cachep)
+{
+}
+
+static inline void memcg_cache_list_add(struct mem_cgroup *memcg,
+					struct kmem_cache *s)
+{
+}
 #endif /* CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN include/linux/slab.h~slab-slub-consider-a-memcg-parameter-in-kmem_create_cache include/linux/slab.h
--- a/include/linux/slab.h~slab-slub-consider-a-memcg-parameter-in-kmem_create_cache
+++ a/include/linux/slab.h
@@ -116,6 +116,7 @@ struct kmem_cache {
 };
 #endif
 
+struct mem_cgroup;
 /*
  * struct kmem_cache related prototypes
  */
@@ -125,6 +126,9 @@ int slab_is_available(void);
 struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
 			unsigned long,
 			void (*)(void *));
+struct kmem_cache *
+kmem_cache_create_memcg(struct mem_cgroup *, const char *, size_t, size_t,
+			unsigned long, void (*)(void *));
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
 void kmem_cache_free(struct kmem_cache *, void *);
@@ -191,15 +195,23 @@ void kmem_cache_free(struct kmem_cache *
  * Child caches will hold extra metadata needed for its operation. Fields are:
  *
  * @memcg: pointer to the memcg this cache belongs to
+ * @list: list_head for the list of all caches in this memcg
+ * @root_cache: pointer to the global, root cache, this cache was derived from
  */
 struct memcg_cache_params {
 	bool is_root_cache;
 	union {
 		struct kmem_cache *memcg_caches[0];
-		struct mem_cgroup *memcg;
+		struct {
+			struct mem_cgroup *memcg;
+			struct list_head list;
+			struct kmem_cache *root_cache;
+		};
 	};
 };
 
+int memcg_update_all_caches(int num_memcgs);
+
 /*
  * Common kmalloc functions provided by all allocators
  */
diff -puN mm/memcontrol.c~slab-slub-consider-a-memcg-parameter-in-kmem_create_cache mm/memcontrol.c
--- a/mm/memcontrol.c~slab-slub-consider-a-memcg-parameter-in-kmem_create_cache
+++ a/mm/memcontrol.c
@@ -341,6 +341,14 @@ struct mem_cgroup {
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
 	struct tcp_memcontrol tcp_mem;
 #endif
+#if defined(CONFIG_MEMCG_KMEM)
+	/* analogous to slab_common's slab_caches list. per-memcg */
+	struct list_head memcg_slab_caches;
+	/* Not a spinlock, we can take a lot of time walking the list */
+	struct mutex slab_caches_mutex;
+        /* Index in the kmem_cache->memcg_params->memcg_caches array */
+	int kmemcg_id;
+#endif
 };
 
 /* internal only representation about the status of kmem accounting. */
@@ -2785,6 +2793,47 @@ static void memcg_uncharge_kmem(struct m
 		mem_cgroup_put(memcg);
 }
 
+void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep)
+{
+	if (!memcg)
+		return;
+
+	mutex_lock(&memcg->slab_caches_mutex);
+	list_add(&cachep->memcg_params->list, &memcg->memcg_slab_caches);
+	mutex_unlock(&memcg->slab_caches_mutex);
+}
+
+/*
+ * helper for acessing a memcg's index. It will be used as an index in the
+ * child cache array in kmem_cache, and also to derive its name. This function
+ * will return -1 when this is not a kmem-limited memcg.
+ */
+int memcg_cache_id(struct mem_cgroup *memcg)
+{
+	return memcg ? memcg->kmemcg_id : -1;
+}
+
+int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s)
+{
+	size_t size = sizeof(struct memcg_cache_params);
+
+	if (!memcg_kmem_enabled())
+		return 0;
+
+	s->memcg_params = kzalloc(size, GFP_KERNEL);
+	if (!s->memcg_params)
+		return -ENOMEM;
+
+	if (memcg)
+		s->memcg_params->memcg = memcg;
+	return 0;
+}
+
+void memcg_release_cache(struct kmem_cache *s)
+{
+	kfree(s->memcg_params);
+}
+
 /*
  * We need to verify if the allocation against current->mm->owner's memcg is
  * possible for the given order. But the page is not allocated yet, so we'll
@@ -5026,7 +5075,9 @@ static int mem_cgroup_oom_control_write(
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
+	memcg->kmemcg_id = -1;
 	memcg_propagate_kmem(memcg);
+
 	return mem_cgroup_sockets_init(memcg, ss);
 };
 
diff -puN mm/slab.h~slab-slub-consider-a-memcg-parameter-in-kmem_create_cache mm/slab.h
--- a/mm/slab.h~slab-slub-consider-a-memcg-parameter-in-kmem_create_cache
+++ a/mm/slab.h
@@ -43,12 +43,15 @@ extern struct kmem_cache *create_kmalloc
 extern void create_boot_cache(struct kmem_cache *, const char *name,
 			size_t size, unsigned long flags);
 
+struct mem_cgroup;
 #ifdef CONFIG_SLUB
-struct kmem_cache *__kmem_cache_alias(const char *name, size_t size,
-	size_t align, unsigned long flags, void (*ctor)(void *));
+struct kmem_cache *
+__kmem_cache_alias(struct mem_cgroup *memcg, const char *name, size_t size,
+		   size_t align, unsigned long flags, void (*ctor)(void *));
 #else
-static inline struct kmem_cache *__kmem_cache_alias(const char *name, size_t size,
-	size_t align, unsigned long flags, void (*ctor)(void *))
+static inline struct kmem_cache *
+__kmem_cache_alias(struct mem_cgroup *memcg, const char *name, size_t size,
+		   size_t align, unsigned long flags, void (*ctor)(void *))
 { return NULL; }
 #endif
 
@@ -106,11 +109,23 @@ static inline bool is_root_cache(struct 
 {
 	return !s->memcg_params || s->memcg_params->is_root_cache;
 }
+
+static inline bool cache_match_memcg(struct kmem_cache *cachep,
+				     struct mem_cgroup *memcg)
+{
+	return (is_root_cache(cachep) && !memcg) ||
+				(cachep->memcg_params->memcg == memcg);
+}
 #else
 static inline bool is_root_cache(struct kmem_cache *s)
 {
 	return true;
 }
 
+static inline bool cache_match_memcg(struct kmem_cache *cachep,
+				     struct mem_cgroup *memcg)
+{
+	return true;
+}
 #endif
 #endif
diff -puN mm/slab_common.c~slab-slub-consider-a-memcg-parameter-in-kmem_create_cache mm/slab_common.c
--- a/mm/slab_common.c~slab-slub-consider-a-memcg-parameter-in-kmem_create_cache
+++ a/mm/slab_common.c
@@ -18,6 +18,7 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/page.h>
+#include <linux/memcontrol.h>
 
 #include "slab.h"
 
@@ -27,7 +28,8 @@ DEFINE_MUTEX(slab_mutex);
 struct kmem_cache *kmem_cache;
 
 #ifdef CONFIG_DEBUG_VM
-static int kmem_cache_sanity_check(const char *name, size_t size)
+static int kmem_cache_sanity_check(struct mem_cgroup *memcg, const char *name,
+				   size_t size)
 {
 	struct kmem_cache *s = NULL;
 
@@ -53,7 +55,13 @@ static int kmem_cache_sanity_check(const
 			continue;
 		}
 
-		if (!strcmp(s->name, name)) {
+		/*
+		 * For simplicity, we won't check this in the list of memcg
+		 * caches. We have control over memcg naming, and if there
+		 * aren't duplicates in the global list, there won't be any
+		 * duplicates in the memcg lists as well.
+		 */
+		if (!memcg && !strcmp(s->name, name)) {
 			pr_err("%s (%s): Cache name already exists.\n",
 			       __func__, name);
 			dump_stack();
@@ -66,7 +74,8 @@ static int kmem_cache_sanity_check(const
 	return 0;
 }
 #else
-static inline int kmem_cache_sanity_check(const char *name, size_t size)
+static inline int kmem_cache_sanity_check(struct mem_cgroup *memcg,
+					  const char *name, size_t size)
 {
 	return 0;
 }
@@ -125,8 +134,9 @@ unsigned long calculate_alignment(unsign
  * as davem.
  */
 
-struct kmem_cache *kmem_cache_create(const char *name, size_t size, size_t align,
-		unsigned long flags, void (*ctor)(void *))
+struct kmem_cache *
+kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
+			size_t align, unsigned long flags, void (*ctor)(void *))
 {
 	struct kmem_cache *s = NULL;
 	int err = 0;
@@ -134,7 +144,7 @@ struct kmem_cache *kmem_cache_create(con
 	get_online_cpus();
 	mutex_lock(&slab_mutex);
 
-	if (!kmem_cache_sanity_check(name, size) == 0)
+	if (!kmem_cache_sanity_check(memcg, name, size) == 0)
 		goto out_locked;
 
 	/*
@@ -145,7 +155,7 @@ struct kmem_cache *kmem_cache_create(con
 	 */
 	flags &= CACHE_CREATE_MASK;
 
-	s = __kmem_cache_alias(name, size, align, flags, ctor);
+	s = __kmem_cache_alias(memcg, name, size, align, flags, ctor);
 	if (s)
 		goto out_locked;
 
@@ -154,6 +164,13 @@ struct kmem_cache *kmem_cache_create(con
 		s->object_size = s->size = size;
 		s->align = calculate_alignment(flags, align, size);
 		s->ctor = ctor;
+
+		if (memcg_register_cache(memcg, s)) {
+			kmem_cache_free(kmem_cache, s);
+			err = -ENOMEM;
+			goto out_locked;
+		}
+
 		s->name = kstrdup(name, GFP_KERNEL);
 		if (!s->name) {
 			kmem_cache_free(kmem_cache, s);
@@ -163,10 +180,9 @@ struct kmem_cache *kmem_cache_create(con
 
 		err = __kmem_cache_create(s, flags);
 		if (!err) {
-
 			s->refcount = 1;
 			list_add(&s->list, &slab_caches);
-
+			memcg_cache_list_add(memcg, s);
 		} else {
 			kfree(s->name);
 			kmem_cache_free(kmem_cache, s);
@@ -194,6 +210,13 @@ out_locked:
 
 	return s;
 }
+
+struct kmem_cache *
+kmem_cache_create(const char *name, size_t size, size_t align,
+		  unsigned long flags, void (*ctor)(void *))
+{
+	return kmem_cache_create_memcg(NULL, name, size, align, flags, ctor);
+}
 EXPORT_SYMBOL(kmem_cache_create);
 
 void kmem_cache_destroy(struct kmem_cache *s)
@@ -209,6 +232,7 @@ void kmem_cache_destroy(struct kmem_cach
 			if (s->flags & SLAB_DESTROY_BY_RCU)
 				rcu_barrier();
 
+			memcg_release_cache(s);
 			kfree(s->name);
 			kmem_cache_free(kmem_cache, s);
 		} else {
diff -puN mm/slub.c~slab-slub-consider-a-memcg-parameter-in-kmem_create_cache mm/slub.c
--- a/mm/slub.c~slab-slub-consider-a-memcg-parameter-in-kmem_create_cache
+++ a/mm/slub.c
@@ -31,6 +31,7 @@
 #include <linux/fault-inject.h>
 #include <linux/stacktrace.h>
 #include <linux/prefetch.h>
+#include <linux/memcontrol.h>
 
 #include <trace/events/kmem.h>
 
@@ -3786,7 +3787,7 @@ static int slab_unmergeable(struct kmem_
 	return 0;
 }
 
-static struct kmem_cache *find_mergeable(size_t size,
+static struct kmem_cache *find_mergeable(struct mem_cgroup *memcg, size_t size,
 		size_t align, unsigned long flags, const char *name,
 		void (*ctor)(void *))
 {
@@ -3822,17 +3823,21 @@ static struct kmem_cache *find_mergeable
 		if (s->size - size >= sizeof(void *))
 			continue;
 
+		if (!cache_match_memcg(s, memcg))
+			continue;
+
 		return s;
 	}
 	return NULL;
 }
 
-struct kmem_cache *__kmem_cache_alias(const char *name, size_t size,
-		size_t align, unsigned long flags, void (*ctor)(void *))
+struct kmem_cache *
+__kmem_cache_alias(struct mem_cgroup *memcg, const char *name, size_t size,
+		   size_t align, unsigned long flags, void (*ctor)(void *))
 {
 	struct kmem_cache *s;
 
-	s = find_mergeable(size, align, flags, name, ctor);
+	s = find_mergeable(memcg, size, align, flags, name, ctor);
 	if (s) {
 		s->refcount++;
 		/*
@@ -5156,6 +5161,12 @@ static char *create_unique_id(struct kme
 	if (p != name + 1)
 		*p++ = '-';
 	p += sprintf(p, "%07d", s->size);
+
+#ifdef CONFIG_MEMCG_KMEM
+	if (!is_root_cache(s))
+		p += sprintf(p, "-%08d", memcg_cache_id(s->memcg_params->memcg));
+#endif
+
 	BUG_ON(p > name + ID_STR_LENGTH - 1);
 	return name;
 }
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

