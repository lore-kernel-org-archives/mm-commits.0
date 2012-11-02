From: akpm@linux-foundation.org
Subject: + memcg-aggregate-memcg-cache-values-in-slabinfo.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:05:03 -0700
Message-ID: <20121102000504.C35A45C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43255 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992681Ab2KBAFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:05:09 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so194558eek.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:05:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: memcg: aggregate memcg cache values in slabinfo
has been added to the -mm tree.  Its filename is
     memcg-aggregate-memcg-cache-values-in-slabinfo.patch

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
Subject: memcg: aggregate memcg cache values in slabinfo

When we create caches in memcgs, we need to display their usage
information somewhere.  We'll adopt a scheme similar to /proc/meminfo,
with aggregate totals shown in the global file, and per-group information
stored in the group itself.

For the time being, only reads are allowed in the per-group cache.

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

 include/linux/memcontrol.h |    8 ++++++
 include/linux/slab.h       |    4 +++
 mm/memcontrol.c            |   30 +++++++++++++++++++++++
 mm/slab.h                  |   27 +++++++++++++++++++++
 mm/slab_common.c           |   44 +++++++++++++++++++++++++++++++----
 5 files changed, 108 insertions(+), 5 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-aggregate-memcg-cache-values-in-slabinfo include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-aggregate-memcg-cache-values-in-slabinfo
+++ a/include/linux/memcontrol.h
@@ -413,6 +413,11 @@ static inline void sock_release_memcg(st
 
 #ifdef CONFIG_MEMCG_KMEM
 extern struct static_key memcg_kmem_enabled_key;
+
+extern int memcg_limited_groups_array_size;
+#define for_each_memcg_cache_index(_idx)	\
+	for ((_idx) = 0; i < memcg_limited_groups_array_size; (_idx)++)
+
 static inline bool memcg_kmem_enabled(void)
 {
 	return static_key_false(&memcg_kmem_enabled_key);
@@ -550,6 +555,9 @@ memcg_kmem_get_cache(struct kmem_cache *
 	return __memcg_kmem_get_cache(cachep, gfp);
 }
 #else
+#define for_each_memcg_cache_index(_idx)	\
+	for (; NULL; )
+
 static inline bool memcg_kmem_enabled(void)
 {
 	return false;
diff -puN include/linux/slab.h~memcg-aggregate-memcg-cache-values-in-slabinfo include/linux/slab.h
--- a/include/linux/slab.h~memcg-aggregate-memcg-cache-values-in-slabinfo
+++ a/include/linux/slab.h
@@ -220,6 +220,10 @@ struct memcg_cache_params {
 
 int memcg_update_all_caches(int num_memcgs);
 
+struct seq_file;
+int cache_show(struct kmem_cache *s, struct seq_file *m);
+void print_slabinfo_header(struct seq_file *m);
+
 /*
  * Common kmalloc functions provided by all allocators
  */
diff -puN mm/memcontrol.c~memcg-aggregate-memcg-cache-values-in-slabinfo mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-aggregate-memcg-cache-values-in-slabinfo
+++ a/mm/memcontrol.c
@@ -570,7 +570,8 @@ static void disarm_sock_keys(struct mem_
  * increase it.
  */
 static struct ida kmem_limited_groups;
-static int memcg_limited_groups_array_size;
+int memcg_limited_groups_array_size;
+
 /*
  * MIN_SIZE is different than 1, because we would like to avoid going through
  * the alloc/free process all the time. In a small machine, 4 kmem-limited
@@ -2763,6 +2764,27 @@ static struct kmem_cache *memcg_params_t
 	return cachep->memcg_params->memcg_caches[memcg_cache_id(p->memcg)];
 }
 
+#ifdef CONFIG_SLABINFO
+static int mem_cgroup_slabinfo_read(struct cgroup *cont, struct cftype *cft,
+					struct seq_file *m)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
+	struct memcg_cache_params *params;
+
+	if (!memcg_can_account_kmem(memcg))
+		return -EIO;
+
+	print_slabinfo_header(m);
+
+	mutex_lock(&memcg->slab_caches_mutex);
+	list_for_each_entry(params, &memcg->memcg_slab_caches, list)
+		cache_show(memcg_params_to_cache(params), m);
+	mutex_unlock(&memcg->slab_caches_mutex);
+
+	return 0;
+}
+#endif
+
 static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
 {
 	struct res_counter *fail_res;
@@ -5827,6 +5849,12 @@ static struct cftype mem_cgroup_files[] 
 		.trigger = mem_cgroup_reset,
 		.read = mem_cgroup_read,
 	},
+#ifdef CONFIG_SLABINFO
+	{
+		.name = "kmem.slabinfo",
+		.read_seq_string = mem_cgroup_slabinfo_read,
+	},
+#endif
 #endif
 	{ },	/* terminate */
 };
diff -puN mm/slab.h~memcg-aggregate-memcg-cache-values-in-slabinfo mm/slab.h
--- a/mm/slab.h~memcg-aggregate-memcg-cache-values-in-slabinfo
+++ a/mm/slab.h
@@ -130,6 +130,23 @@ static inline bool slab_equal_or_root(st
 	return (p == s) ||
 		(s->memcg_params && (p == s->memcg_params->root_cache));
 }
+
+/*
+ * We use suffixes to the name in memcg because we can't have caches
+ * created in the system with the same name. But when we print them
+ * locally, better refer to them with the base name
+ */
+static inline const char *cache_name(struct kmem_cache *s)
+{
+	if (!is_root_cache(s))
+		return s->memcg_params->root_cache->name;
+	return s->name;
+}
+
+static inline struct kmem_cache *cache_from_memcg(struct kmem_cache *s, int idx)
+{
+	return s->memcg_params->memcg_caches[idx];
+}
 #else
 static inline bool is_root_cache(struct kmem_cache *s)
 {
@@ -155,6 +172,16 @@ static inline bool slab_equal_or_root(st
 {
 	return true;
 }
+
+static inline const char *cache_name(struct kmem_cache *s)
+{
+	return s->name;
+}
+
+static inline struct kmem_cache *cache_from_memcg(struct kmem_cache *s, int idx)
+{
+	return NULL;
+}
 #endif
 
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
diff -puN mm/slab_common.c~memcg-aggregate-memcg-cache-values-in-slabinfo mm/slab_common.c
--- a/mm/slab_common.c~memcg-aggregate-memcg-cache-values-in-slabinfo
+++ a/mm/slab_common.c
@@ -258,7 +258,7 @@ int slab_is_available(void)
 }
 
 #ifdef CONFIG_SLABINFO
-static void print_slabinfo_header(struct seq_file *m)
+void print_slabinfo_header(struct seq_file *m)
 {
 	/*
 	 * Output format version, so at least we can change it
@@ -302,16 +302,43 @@ static void s_stop(struct seq_file *m, v
 	mutex_unlock(&slab_mutex);
 }
 
-static int s_show(struct seq_file *m, void *p)
+static void
+memcg_accumulate_slabinfo(struct kmem_cache *s, struct slabinfo *info)
+{
+	struct kmem_cache *c;
+	struct slabinfo sinfo;
+	int i;
+
+	if (!is_root_cache(s))
+		return;
+
+	for_each_memcg_cache_index(i) {
+		c = cache_from_memcg(s, i);
+		if (!c)
+			continue;
+
+		memset(&sinfo, 0, sizeof(sinfo));
+		get_slabinfo(c, &sinfo);
+
+		info->active_slabs += sinfo.active_slabs;
+		info->num_slabs += sinfo.num_slabs;
+		info->shared_avail += sinfo.shared_avail;
+		info->active_objs += sinfo.active_objs;
+		info->num_objs += sinfo.num_objs;
+	}
+}
+
+int cache_show(struct kmem_cache *s, struct seq_file *m)
 {
-	struct kmem_cache *s = list_entry(p, struct kmem_cache, list);
 	struct slabinfo sinfo;
 
 	memset(&sinfo, 0, sizeof(sinfo));
 	get_slabinfo(s, &sinfo);
 
+	memcg_accumulate_slabinfo(s, &sinfo);
+
 	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d",
-		   s->name, sinfo.active_objs, sinfo.num_objs, s->size,
+		   cache_name(s), sinfo.active_objs, sinfo.num_objs, s->size,
 		   sinfo.objects_per_slab, (1 << sinfo.cache_order));
 
 	seq_printf(m, " : tunables %4u %4u %4u",
@@ -323,6 +350,15 @@ static int s_show(struct seq_file *m, vo
 	return 0;
 }
 
+static int s_show(struct seq_file *m, void *p)
+{
+	struct kmem_cache *s = list_entry(p, struct kmem_cache, list);
+
+	if (!is_root_cache(s))
+		return 0;
+	return cache_show(s, m);
+}
+
 /*
  * slabinfo_op - iterator that generates /proc/slabinfo
  *
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

