From: akpm@linux-foundation.org
Subject: + memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:04:22 -0700
Message-ID: <20121102000422.97669100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36051 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992605Ab2KBAEY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:04:24 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so365559ggm.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:04:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: memcg: allocate memory for memcg caches whenever a new memcg appears
has been added to the -mm tree.  Its filename is
     memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: allocate memory for memcg caches whenever a new memcg appears

Every cache that is considered a root cache (basically the "original"
caches, tied to the root memcg/no-memcg) will have an array that should be
large enough to store a cache pointer per each memcg in the system.

Theoreticaly, this is as high as 1 << sizeof(css_id), which is currently
in the 64k pointers range.  Most of the time, we won't be using that much.

What goes in this patch, is a simple scheme to dynamically allocate such
an array, in order to minimize memory usage for memcg caches.  Because we
would also like to avoid allocations all the time, at least for now, the
array will only grow.  It will tend to be big enough to hold the maximum
number of kmem-limited memcgs ever achieved.

We'll allocate it to be a minimum of 64 kmem-limited memcgs.  When we have
more than that, we'll start doubling the size of this array every time the
limit is reached.

Because we are only considering kmem limited memcgs, a natural point for
this to happen is when we write to the limit.  At that point, we already
have set_limit_mutex held, so that will become our natural synchronization
mechanism.

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

 include/linux/memcontrol.h |    2 
 mm/memcontrol.c            |  210 ++++++++++++++++++++++++++++++++---
 mm/slab_common.c           |   28 ++++
 3 files changed, 224 insertions(+), 16 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears
+++ a/include/linux/memcontrol.h
@@ -440,6 +440,8 @@ int memcg_register_cache(struct mem_cgro
 void memcg_release_cache(struct kmem_cache *cachep);
 void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep);
 
+int memcg_update_cache_size(struct kmem_cache *s, int num_groups);
+void memcg_update_array_size(int num_groups);
 /**
  * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
  * @gfp: the gfp allocation flags.
diff -puN mm/memcontrol.c~memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears
+++ a/mm/memcontrol.c
@@ -376,6 +376,11 @@ static void memcg_kmem_set_activated(str
 	set_bit(KMEM_ACCOUNTED_ACTIVATED, &memcg->kmem_account_flags);
 }
 
+static void memcg_kmem_clear_activated(struct mem_cgroup *memcg)
+{
+	clear_bit(KMEM_ACCOUNTED_ACTIVATED, &memcg->kmem_account_flags);
+}
+
 static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
 {
 	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags))
@@ -547,12 +552,48 @@ static void disarm_sock_keys(struct mem_
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
+/*
+ * This will be the memcg's index in each cache's ->memcg_params->memcg_caches.
+ * There are two main reasons for not using the css_id for this:
+ *  1) this works better in sparse environments, where we have a lot of memcgs,
+ *     but only a few kmem-limited. Or also, if we have, for instance, 200
+ *     memcgs, and none but the 200th is kmem-limited, we'd have to have a
+ *     200 entry array for that.
+ *
+ *  2) In order not to violate the cgroup API, we would like to do all memory
+ *     allocation in ->create(). At that point, we haven't yet allocated the
+ *     css_id. Having a separate index prevents us from messing with the cgroup
+ *     core for this
+ *
+ * The current size of the caches array is stored in
+ * memcg_limited_groups_array_size.  It will double each time we have to
+ * increase it.
+ */
+static struct ida kmem_limited_groups;
+static int memcg_limited_groups_array_size;
+/*
+ * MIN_SIZE is different than 1, because we would like to avoid going through
+ * the alloc/free process all the time. In a small machine, 4 kmem-limited
+ * cgroups is a reasonable guess. In the future, it could be a parameter or
+ * tunable, but that is strictly not necessary.
+ *
+ * MAX_SIZE should be as large as the number of css_ids. Ideally, we could get
+ * this constant directly from cgroup, but it is understandable that this is
+ * better kept as an internal representation in cgroup.c. In any case, the
+ * css_id space is not getting any smaller, and we don't have to necessarily
+ * increase ours as well if it increases.
+ */
+#define MEMCG_CACHES_MIN_SIZE 4
+#define MEMCG_CACHES_MAX_SIZE 65535
+
 struct static_key memcg_kmem_enabled_key;
 
 static void disarm_kmem_keys(struct mem_cgroup *memcg)
 {
-	if (memcg_kmem_is_active(memcg))
+	if (memcg_kmem_is_active(memcg)) {
 		static_key_slow_dec(&memcg_kmem_enabled_key);
+		ida_simple_remove(&kmem_limited_groups, memcg->kmemcg_id);
+	}
 	/*
 	 * This check can't live in kmem destruction function,
 	 * since the charges will outlive the cgroup
@@ -2782,6 +2823,120 @@ int memcg_cache_id(struct mem_cgroup *me
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
+/*
+ * This ends up being protected by the set_limit mutex, during normal
+ * operation, because that is its main call site.
+ *
+ * But when we create a new cache, we can call this as well if its parent
+ * is kmem-limited. That will have to hold set_limit_mutex as well.
+ */
+int memcg_update_cache_sizes(struct mem_cgroup *memcg)
+{
+	int num, ret;
+
+	num = ida_simple_get(&kmem_limited_groups,
+				0, MEMCG_CACHES_MAX_SIZE, GFP_KERNEL);
+	if (num < 0)
+		return num;
+	/*
+	 * After this point, kmem_accounted (that we test atomically in
+	 * the beginning of this conditional), is no longer 0. This
+	 * guarantees only one process will set the following boolean
+	 * to true. We don't need test_and_set because we're protected
+	 * by the set_limit_mutex anyway.
+	 */
+	memcg_kmem_set_activated(memcg);
+
+	ret = memcg_update_all_caches(num+1);
+	if (ret) {
+		ida_simple_remove(&kmem_limited_groups, num);
+		memcg_kmem_clear_activated(memcg);
+		return ret;
+	}
+
+	memcg->kmemcg_id = num;
+	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
+	mutex_init(&memcg->slab_caches_mutex);
+	return 0;
+}
+
+static size_t memcg_caches_array_size(int num_groups)
+{
+	ssize_t size;
+	if (num_groups <= 0)
+		return 0;
+
+	size = 2 * num_groups;
+	if (size < MEMCG_CACHES_MIN_SIZE)
+		size = MEMCG_CACHES_MIN_SIZE;
+	else if (size > MEMCG_CACHES_MAX_SIZE)
+		size = MEMCG_CACHES_MAX_SIZE;
+
+	return size;
+}
+
+/*
+ * We should update the current array size iff all caches updates succeed. This
+ * can only be done from the slab side. The slab mutex needs to be held when
+ * calling this.
+ */
+void memcg_update_array_size(int num)
+{
+	if (num > memcg_limited_groups_array_size)
+		memcg_limited_groups_array_size = memcg_caches_array_size(num);
+}
+
+int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
+{
+	struct memcg_cache_params *cur_params = s->memcg_params;
+
+	VM_BUG_ON(s->memcg_params && !s->memcg_params->is_root_cache);
+
+	if (num_groups > memcg_limited_groups_array_size) {
+		int i;
+		ssize_t size = memcg_caches_array_size(num_groups);
+
+		size *= sizeof(void *);
+		size += sizeof(struct memcg_cache_params);
+
+		s->memcg_params = kzalloc(size, GFP_KERNEL);
+		if (!s->memcg_params) {
+			s->memcg_params = cur_params;
+			return -ENOMEM;
+		}
+
+		s->memcg_params->is_root_cache = true;
+
+		/*
+		 * There is the chance it will be bigger than
+		 * memcg_limited_groups_array_size, if we failed an allocation
+		 * in a cache, in which case all caches updated before it, will
+		 * have a bigger array.
+		 *
+		 * But if that is the case, the data after
+		 * memcg_limited_groups_array_size is certainly unused
+		 */
+		for (i = 0; i < memcg_limited_groups_array_size; i++) {
+			if (!cur_params->memcg_caches[i])
+				continue;
+			s->memcg_params->memcg_caches[i] =
+						cur_params->memcg_caches[i];
+		}
+
+		/*
+		 * Ideally, we would wait until all caches succeed, and only
+		 * then free the old one. But this is not worth the extra
+		 * pointer per-cache we'd have to have for this.
+		 *
+		 * It is not a big deal if some caches are left with a size
+		 * bigger than the others. And all updates will reset this
+		 * anyway.
+		 */
+		kfree(cur_params);
+	}
+	return 0;
+}
+
 int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s)
 {
 	size_t size = sizeof(struct memcg_cache_params);
@@ -2789,6 +2944,9 @@ int memcg_register_cache(struct mem_cgro
 	if (!memcg_kmem_enabled())
 		return 0;
 
+	if (!memcg)
+		size += memcg_limited_groups_array_size * sizeof(void *);
+
 	s->memcg_params = kzalloc(size, GFP_KERNEL);
 	if (!s->memcg_params)
 		return -ENOMEM;
@@ -4317,14 +4475,11 @@ static int memcg_update_kmem_limit(struc
 		ret = res_counter_set_limit(&memcg->kmem, val);
 		VM_BUG_ON(ret);
 
-		/*
-		 * After this point, kmem_accounted (that we test atomically in
-		 * the beginning of this conditional), is no longer 0. This
-		 * guarantees only one process will set the following boolean
-		 * to true. We don't need test_and_set because we're protected
-		 * by the set_limit_mutex anyway.
-		 */
-		memcg_kmem_set_activated(memcg);
+		ret = memcg_update_cache_sizes(memcg);
+		if (ret) {
+			res_counter_set_limit(&memcg->kmem, RESOURCE_MAX);
+			goto out;
+		}
 		must_inc_static_branch = true;
 		/*
 		 * kmem charges can outlive the cgroup. In the case of slab
@@ -4363,11 +4518,13 @@ out:
 	return ret;
 }
 
-static void memcg_propagate_kmem(struct mem_cgroup *memcg)
+static int memcg_propagate_kmem(struct mem_cgroup *memcg)
 {
+	int ret = 0;
 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 	if (!parent)
-		return;
+		goto out;
+
 	memcg->kmem_account_flags = parent->kmem_account_flags;
 #ifdef CONFIG_MEMCG_KMEM
 	/*
@@ -4380,11 +4537,24 @@ static void memcg_propagate_kmem(struct 
 	 * It is a lot simpler just to do static_key_slow_inc() on every child
 	 * that is accounted.
 	 */
-	if (memcg_kmem_is_active(memcg)) {
-		mem_cgroup_get(memcg);
-		static_key_slow_inc(&memcg_kmem_enabled_key);
-	}
+	if (!memcg_kmem_is_active(memcg))
+		goto out;
+
+	/*
+	 * destroy(), called if we fail, will issue static_key_slow_inc() and
+	 * mem_cgroup_put() if kmem is enabled. We have to either call them
+	 * unconditionally, or clear the KMEM_ACTIVE flag. I personally find
+	 * this more consistent, since it always leads to the same destroy path
+	 */
+	mem_cgroup_get(memcg);
+	static_key_slow_inc(&memcg_kmem_enabled_key);
+
+	mutex_lock(&set_limit_mutex);
+	ret = memcg_update_cache_sizes(memcg);
+	mutex_unlock(&set_limit_mutex);
 #endif
+out:
+	return ret;
 }
 
 /*
@@ -5066,8 +5236,15 @@ static int mem_cgroup_oom_control_write(
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
+	int ret;
+
 	memcg->kmemcg_id = -1;
-	memcg_propagate_kmem(memcg);
+	ret = memcg_propagate_kmem(memcg);
+	if (ret)
+		return ret;
+
+	if (mem_cgroup_is_root(memcg))
+		ida_init(&kmem_limited_groups);
 
 	return mem_cgroup_sockets_init(memcg, ss);
 };
@@ -5470,6 +5647,7 @@ mem_cgroup_create(struct cgroup *cont)
 		res_counter_init(&memcg->res, &parent->res);
 		res_counter_init(&memcg->memsw, &parent->memsw);
 		res_counter_init(&memcg->kmem, &parent->kmem);
+
 		/*
 		 * We increment refcnt of the parent to ensure that we can
 		 * safely access it on res_counter_charge/uncharge.
diff -puN mm/slab_common.c~memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears mm/slab_common.c
--- a/mm/slab_common.c~memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears
+++ a/mm/slab_common.c
@@ -81,6 +81,34 @@ static inline int kmem_cache_sanity_chec
 }
 #endif
 
+#ifdef CONFIG_MEMCG_KMEM
+int memcg_update_all_caches(int num_memcgs)
+{
+	struct kmem_cache *s;
+	int ret = 0;
+	mutex_lock(&slab_mutex);
+
+	list_for_each_entry(s, &slab_caches, list) {
+		if (!is_root_cache(s))
+			continue;
+
+		ret = memcg_update_cache_size(s, num_memcgs);
+		/*
+		 * See comment in memcontrol.c, memcg_update_cache_size:
+		 * Instead of freeing the memory, we'll just leave the caches
+		 * up to this point in an updated state.
+		 */
+		if (ret)
+			goto out;
+	}
+
+	memcg_update_array_size(num_memcgs);
+out:
+	mutex_unlock(&slab_mutex);
+	return ret;
+}
+#endif
+
 /*
  * kmem_cache_create - Create a cache.
  * @name: A string which is used in /proc/slabinfo to identify this cache.
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch

