From: akpm@linux-foundation.org
Subject: [merged] memcg-aggregate-memcg-cache-values-in-slabinfo.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:42:04 -0800
Message-ID: <20121219204205.03EFF82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:41754 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab2LSUmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:42:07 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so278218qcq.3
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:42:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: aggregate memcg cache values in slabinfo
has been removed from the -mm tree.  Its filename was
     memcg-aggregate-memcg-cache-values-in-slabinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -420,6 +420,11 @@ static inline void sock_release_memcg(st
 
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
@@ -557,6 +562,9 @@ memcg_kmem_get_cache(struct kmem_cache *
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
@@ -572,7 +572,8 @@ static void disarm_sock_keys(struct mem_
  * increase it.
  */
 static DEFINE_IDA(kmem_limited_groups);
-static int memcg_limited_groups_array_size;
+int memcg_limited_groups_array_size;
+
 /*
  * MIN_SIZE is different than 1, because we would like to avoid going through
  * the alloc/free process all the time. In a small machine, 4 kmem-limited
@@ -2794,6 +2795,27 @@ static struct kmem_cache *memcg_params_t
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
@@ -5822,6 +5844,12 @@ static struct cftype mem_cgroup_files[] 
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
@@ -138,6 +138,23 @@ static inline bool slab_equal_or_root(st
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
@@ -163,6 +180,16 @@ static inline bool slab_equal_or_root(st
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
@@ -322,7 +322,7 @@ struct kmem_cache *__init create_kmalloc
 
 
 #ifdef CONFIG_SLABINFO
-static void print_slabinfo_header(struct seq_file *m)
+void print_slabinfo_header(struct seq_file *m)
 {
 	/*
 	 * Output format version, so at least we can change it
@@ -366,16 +366,43 @@ static void s_stop(struct seq_file *m, v
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
@@ -387,6 +414,15 @@ static int s_show(struct seq_file *m, vo
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

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

