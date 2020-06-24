From: akpm@linux-foundation.org
Subject: + mm-memcg-slab-deprecate-slab_root_caches.patch added to
 -mm tree
Date: Wed, 24 Jun 2020 14:47:25 -0700
Message-ID: <20200624214725.4pqDA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404728AbgFXVr1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:47:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org, shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: memcg/slab: deprecate slab_root_caches
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-deprecate-slab_root_caches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-deprecate-slab_root_caches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-deprecate-slab_root_caches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: deprecate slab_root_caches

Currently there are two lists of kmem_caches:
1) slab_caches, which contains all kmem_caches,
2) slab_root_caches, which contains only root kmem_caches.

And there is some preprocessor magic to have a single list if
CONFIG_MEMCG_KMEM isn't enabled.

It was required earlier because the number of non-root kmem_caches was
proportional to the number of memory cgroups and could reach really big
values.  Now, when it cannot exceed the number of root kmem_caches, there
is really no reason to maintain two lists.

We never iterate over the slab_root_caches list on any hot paths, so it's
perfectly fine to iterate over slab_caches and filter out non-root
kmem_caches.

It allows to remove a lot of config-dependent code and two pointers from
the kmem_cache structure.

Link: http://lkml.kernel.org/r/20200623174037.3951353-16-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    1 -
 mm/slab.h        |   17 -----------------
 mm/slab_common.c |   37 ++++++++-----------------------------
 mm/slub.c        |    1 -
 4 files changed, 8 insertions(+), 48 deletions(-)

--- a/mm/slab.c~mm-memcg-slab-deprecate-slab_root_caches
+++ a/mm/slab.c
@@ -1239,7 +1239,6 @@ void __init kmem_cache_init(void)
 				  nr_node_ids * sizeof(struct kmem_cache_node *),
 				  SLAB_HWCACHE_ALIGN, 0, 0);
 	list_add(&kmem_cache->list, &slab_caches);
-	memcg_link_cache(kmem_cache);
 	slab_state = PARTIAL;
 
 	/*
--- a/mm/slab_common.c~mm-memcg-slab-deprecate-slab_root_caches
+++ a/mm/slab_common.c
@@ -129,9 +129,6 @@ int __kmem_cache_alloc_bulk(struct kmem_
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-
-LIST_HEAD(slab_root_caches);
-
 static void memcg_kmem_cache_create_func(struct work_struct *work)
 {
 	struct kmem_cache *cachep = container_of(work, struct kmem_cache,
@@ -154,27 +151,11 @@ static void init_memcg_params(struct kme
 	else
 		slab_init_memcg_params(s);
 }
-
-void memcg_link_cache(struct kmem_cache *s)
-{
-	if (is_root_cache(s))
-		list_add(&s->root_caches_node, &slab_root_caches);
-}
-
-static void memcg_unlink_cache(struct kmem_cache *s)
-{
-	if (is_root_cache(s))
-		list_del(&s->root_caches_node);
-}
 #else
 static inline void init_memcg_params(struct kmem_cache *s,
 				     struct kmem_cache *root_cache)
 {
 }
-
-static inline void memcg_unlink_cache(struct kmem_cache *s)
-{
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 /*
@@ -251,7 +232,7 @@ struct kmem_cache *find_mergeable(unsign
 	if (flags & SLAB_NEVER_MERGE)
 		return NULL;
 
-	list_for_each_entry_reverse(s, &slab_root_caches, root_caches_node) {
+	list_for_each_entry_reverse(s, &slab_caches, list) {
 		if (slab_unmergeable(s))
 			continue;
 
@@ -310,7 +291,6 @@ static struct kmem_cache *create_cache(c
 
 	s->refcount = 1;
 	list_add(&s->list, &slab_caches);
-	memcg_link_cache(s);
 out:
 	if (err)
 		return ERR_PTR(err);
@@ -505,7 +485,6 @@ static int shutdown_cache(struct kmem_ca
 	if (__kmem_cache_shutdown(s) != 0)
 		return -EBUSY;
 
-	memcg_unlink_cache(s);
 	list_del(&s->list);
 
 	if (s->flags & SLAB_TYPESAFE_BY_RCU) {
@@ -749,7 +728,6 @@ struct kmem_cache *__init create_kmalloc
 
 	create_boot_cache(s, name, size, flags, useroffset, usersize);
 	list_add(&s->list, &slab_caches);
-	memcg_link_cache(s);
 	s->refcount = 1;
 	return s;
 }
@@ -1090,12 +1068,12 @@ static void print_slabinfo_header(struct
 void *slab_start(struct seq_file *m, loff_t *pos)
 {
 	mutex_lock(&slab_mutex);
-	return seq_list_start(&slab_root_caches, *pos);
+	return seq_list_start(&slab_caches, *pos);
 }
 
 void *slab_next(struct seq_file *m, void *p, loff_t *pos)
 {
-	return seq_list_next(p, &slab_root_caches, pos);
+	return seq_list_next(p, &slab_caches, pos);
 }
 
 void slab_stop(struct seq_file *m, void *p)
@@ -1148,11 +1126,12 @@ static void cache_show(struct kmem_cache
 
 static int slab_show(struct seq_file *m, void *p)
 {
-	struct kmem_cache *s = list_entry(p, struct kmem_cache, root_caches_node);
+	struct kmem_cache *s = list_entry(p, struct kmem_cache, list);
 
-	if (p == slab_root_caches.next)
+	if (p == slab_caches.next)
 		print_slabinfo_header(m);
-	cache_show(s, m);
+	if (is_root_cache(s))
+		cache_show(s, m);
 	return 0;
 }
 
@@ -1254,7 +1233,7 @@ static int memcg_slabinfo_show(struct se
 	mutex_lock(&slab_mutex);
 	seq_puts(m, "# <name> <css_id[:dead|deact]> <active_objs> <num_objs>");
 	seq_puts(m, " <active_slabs> <num_slabs>\n");
-	list_for_each_entry(s, &slab_root_caches, root_caches_node) {
+	list_for_each_entry(s, &slab_caches, list) {
 		/*
 		 * Skip kmem caches that don't have the memcg cache.
 		 */
--- a/mm/slab.h~mm-memcg-slab-deprecate-slab_root_caches
+++ a/mm/slab.h
@@ -44,14 +44,12 @@ struct kmem_cache {
  *
  * @memcg_cache: pointer to memcg kmem cache, used by all non-root memory
  *		cgroups.
- * @root_caches_node: list node for slab_root_caches list.
  * @work: work struct used to create the non-root cache.
  */
 struct memcg_cache_params {
 	struct kmem_cache *root_cache;
 
 	struct kmem_cache *memcg_cache;
-	struct list_head __root_caches_node;
 	struct work_struct work;
 };
 #endif /* CONFIG_SLOB */
@@ -264,11 +262,6 @@ static inline bool kmem_cache_debug_flag
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-
-/* List of all root caches. */
-extern struct list_head		slab_root_caches;
-#define root_caches_node	memcg_params.__root_caches_node
-
 static inline bool is_root_cache(struct kmem_cache *s)
 {
 	return !s->memcg_params.root_cache;
@@ -446,14 +439,8 @@ static inline void memcg_slab_free_hook(
 }
 
 extern void slab_init_memcg_params(struct kmem_cache *);
-extern void memcg_link_cache(struct kmem_cache *s);
 
 #else /* CONFIG_MEMCG_KMEM */
-
-/* If !memcg, all caches are root. */
-#define slab_root_caches	slab_caches
-#define root_caches_node	list
-
 static inline bool is_root_cache(struct kmem_cache *s)
 {
 	return true;
@@ -522,10 +509,6 @@ static inline void slab_init_memcg_param
 {
 }
 
-static inline void memcg_link_cache(struct kmem_cache *s)
-{
-}
-
 #endif /* CONFIG_MEMCG_KMEM */
 
 static inline struct kmem_cache *virt_to_cache(const void *obj)
--- a/mm/slub.c~mm-memcg-slab-deprecate-slab_root_caches
+++ a/mm/slub.c
@@ -4364,7 +4364,6 @@ static struct kmem_cache * __init bootst
 	}
 	slab_init_memcg_params(s);
 	list_add(&s->list, &slab_caches);
-	memcg_link_cache(s);
 	return s;
 }
 
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state.patch
mm-memcg-prepare-for-byte-sized-vmstat-items.patch
mm-memcg-convert-vmstat-slab-counters-to-bytes.patch
mm-slub-implement-slub-version-of-obj_to_index.patch
mm-memcg-slab-obj_cgroup-api.patch
mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch
mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects.patch
mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch
mm-memcg-slab-deprecate-memorykmemslabinfo.patch
mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-accounted-allocations.patch
mm-memcg-slab-simplify-memcg-cache-creation.patch
mm-memcg-slab-remove-memcg_kmem_get_cache.patch
mm-memcg-slab-deprecate-slab_root_caches.patch
mm-memcg-slab-remove-redundant-check-in-memcg_accumulate_slabinfo.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations.patch
kselftests-cgroup-add-kernel-memory-accounting-tests.patch
tools-cgroup-add-memcg_slabinfopy-tool.patch
percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
