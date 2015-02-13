From: akpm@linux-foundation.org
Subject: [merged]
 slub-make-dead-caches-discard-free-slabs-immediately.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:20:36 -0800
Message-ID: <54de5c94.lT+oPPfNr7xLLoRQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbbBMUUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: make dead caches discard free slabs immediately
has been removed from the -mm tree.  Its filename was
     slub-make-dead-caches-discard-free-slabs-immediately.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: make dead caches discard free slabs immediately

To speed up further allocations SLUB may store empty slabs in per cpu/node
partial lists instead of freeing them immediately.  This prevents per
memcg caches destruction, because kmem caches created for a memory cgroup
are only destroyed after the last page charged to the cgroup is freed.

To fix this issue, this patch resurrects approach first proposed in [1]. 
It forbids SLUB to cache empty slabs after the memory cgroup that the
cache belongs to was destroyed.  It is achieved by setting kmem_cache's
cpu_partial and min_partial constants to 0 and tuning put_cpu_partial() so
that it would drop frozen empty slabs immediately if cpu_partial = 0.

The runtime overhead is minimal.  From all the hot functions, we only
touch relatively cold put_cpu_partial(): we make it call
unfreeze_partials() after freezing a slab that belongs to an offline
memory cgroup.  Since slab freezing exists to avoid moving slabs from/to a
partial list on free/alloc, and there can't be allocations from dead
caches, it shouldn't cause any overhead.  We do have to disable preemption
for put_cpu_partial() to achieve that though.

The original patch was accepted well and even merged to the mm tree. 
However, I decided to withdraw it due to changes happening to the memcg
core at that time.  I had an idea of introducing per-memcg shrinkers for
kmem caches, but now, as memcg has finally settled down, I do not see it
as an option, because SLUB shrinker would be too costly to call since SLUB
does not keep free slabs on a separate list.  Besides, we currently do not
even call per-memcg shrinkers for offline memcgs.  Overall, it would
introduce much more complexity to both SLUB and memcg than this small
patch.

Regarding to SLAB, there's no problem with it, because it shrinks
per-cpu/node caches periodically.  Thanks to list_lru reparenting, we no
longer keep entries for offline cgroups in per-memcg arrays (such as
memcg_cache_params->memcg_caches), so we do not have to bother if a
per-memcg cache will be shrunk a bit later than it could be.

[1] http://thread.gmane.org/gmane.linux.kernel.mm/118649/focus=118650

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    4 ++--
 mm/slab.h        |    2 +-
 mm/slab_common.c |   15 +++++++++++++--
 mm/slob.c        |    2 +-
 mm/slub.c        |   31 ++++++++++++++++++++++++++-----
 5 files changed, 43 insertions(+), 11 deletions(-)

diff -puN mm/slab.c~slub-make-dead-caches-discard-free-slabs-immediately mm/slab.c
--- a/mm/slab.c~slub-make-dead-caches-discard-free-slabs-immediately
+++ a/mm/slab.c
@@ -2382,7 +2382,7 @@ out:
 	return nr_freed;
 }
 
-int __kmem_cache_shrink(struct kmem_cache *cachep)
+int __kmem_cache_shrink(struct kmem_cache *cachep, bool deactivate)
 {
 	int ret = 0;
 	int node;
@@ -2404,7 +2404,7 @@ int __kmem_cache_shutdown(struct kmem_ca
 {
 	int i;
 	struct kmem_cache_node *n;
-	int rc = __kmem_cache_shrink(cachep);
+	int rc = __kmem_cache_shrink(cachep, false);
 
 	if (rc)
 		return rc;
diff -puN mm/slab.h~slub-make-dead-caches-discard-free-slabs-immediately mm/slab.h
--- a/mm/slab.h~slub-make-dead-caches-discard-free-slabs-immediately
+++ a/mm/slab.h
@@ -138,7 +138,7 @@ static inline unsigned long kmem_cache_f
 #define CACHE_CREATE_MASK (SLAB_CORE_FLAGS | SLAB_DEBUG_FLAGS | SLAB_CACHE_FLAGS)
 
 int __kmem_cache_shutdown(struct kmem_cache *);
-int __kmem_cache_shrink(struct kmem_cache *);
+int __kmem_cache_shrink(struct kmem_cache *, bool);
 void slab_kmem_cache_release(struct kmem_cache *);
 
 struct seq_file;
diff -puN mm/slab_common.c~slub-make-dead-caches-discard-free-slabs-immediately mm/slab_common.c
--- a/mm/slab_common.c~slub-make-dead-caches-discard-free-slabs-immediately
+++ a/mm/slab_common.c
@@ -549,10 +549,13 @@ void memcg_deactivate_kmem_caches(struct
 {
 	int idx;
 	struct memcg_cache_array *arr;
-	struct kmem_cache *s;
+	struct kmem_cache *s, *c;
 
 	idx = memcg_cache_id(memcg);
 
+	get_online_cpus();
+	get_online_mems();
+
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list) {
 		if (!is_root_cache(s))
@@ -560,9 +563,17 @@ void memcg_deactivate_kmem_caches(struct
 
 		arr = rcu_dereference_protected(s->memcg_params.memcg_caches,
 						lockdep_is_held(&slab_mutex));
+		c = arr->entries[idx];
+		if (!c)
+			continue;
+
+		__kmem_cache_shrink(c, true);
 		arr->entries[idx] = NULL;
 	}
 	mutex_unlock(&slab_mutex);
+
+	put_online_mems();
+	put_online_cpus();
 }
 
 void memcg_destroy_kmem_caches(struct mem_cgroup *memcg)
@@ -649,7 +660,7 @@ int kmem_cache_shrink(struct kmem_cache
 
 	get_online_cpus();
 	get_online_mems();
-	ret = __kmem_cache_shrink(cachep);
+	ret = __kmem_cache_shrink(cachep, false);
 	put_online_mems();
 	put_online_cpus();
 	return ret;
diff -puN mm/slob.c~slub-make-dead-caches-discard-free-slabs-immediately mm/slob.c
--- a/mm/slob.c~slub-make-dead-caches-discard-free-slabs-immediately
+++ a/mm/slob.c
@@ -618,7 +618,7 @@ int __kmem_cache_shutdown(struct kmem_ca
 	return 0;
 }
 
-int __kmem_cache_shrink(struct kmem_cache *d)
+int __kmem_cache_shrink(struct kmem_cache *d, bool deactivate)
 {
 	return 0;
 }
diff -puN mm/slub.c~slub-make-dead-caches-discard-free-slabs-immediately mm/slub.c
--- a/mm/slub.c~slub-make-dead-caches-discard-free-slabs-immediately
+++ a/mm/slub.c
@@ -2007,6 +2007,7 @@ static void put_cpu_partial(struct kmem_
 	int pages;
 	int pobjects;
 
+	preempt_disable();
 	do {
 		pages = 0;
 		pobjects = 0;
@@ -2040,6 +2041,14 @@ static void put_cpu_partial(struct kmem_
 
 	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page)
 								!= oldpage);
+	if (unlikely(!s->cpu_partial)) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
+		local_irq_restore(flags);
+	}
+	preempt_enable();
 #endif
 }
 
@@ -3369,7 +3378,7 @@ EXPORT_SYMBOL(kfree);
  * being allocated from last increasing the chance that the last objects
  * are freed in them.
  */
-int __kmem_cache_shrink(struct kmem_cache *s)
+int __kmem_cache_shrink(struct kmem_cache *s, bool deactivate)
 {
 	int node;
 	int i;
@@ -3381,11 +3390,23 @@ int __kmem_cache_shrink(struct kmem_cach
 	unsigned long flags;
 	int ret = 0;
 
+	if (deactivate) {
+		/*
+		 * Disable empty slabs caching. Used to avoid pinning offline
+		 * memory cgroups by kmem pages that can be freed.
+		 */
+		s->cpu_partial = 0;
+		s->min_partial = 0;
+
+		/*
+		 * s->cpu_partial is checked locklessly (see put_cpu_partial),
+		 * so we have to make sure the change is visible.
+		 */
+		kick_all_cpus_sync();
+	}
+
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
-		if (!n->nr_partial)
-			continue;
