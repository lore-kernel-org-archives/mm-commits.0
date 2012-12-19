From: akpm@linux-foundation.org
Subject: [merged] slab-slub-struct-memcg_params.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:41:06 -0800
Message-ID: <20121219204107.03D13100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:36886 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab2LSUlJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:41:09 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so278164yhr.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:41:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab/slub: struct memcg_params
has been removed from the -mm tree.  Its filename was
     slab-slub-struct-memcg_params.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: slab/slub: struct memcg_params

For the kmem slab controller, we need to record some extra information in
the kmem_cache structure.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
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
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h     |   24 ++++++++++++++++++++++++
 include/linux/slab_def.h |    3 +++
 include/linux/slub_def.h |    3 +++
 mm/slab.h                |   13 +++++++++++++
 4 files changed, 43 insertions(+)

diff -puN include/linux/slab.h~slab-slub-struct-memcg_params include/linux/slab.h
--- a/include/linux/slab.h~slab-slub-struct-memcg_params
+++ a/include/linux/slab.h
@@ -177,6 +177,30 @@ void kmem_cache_free(struct kmem_cache *
 #endif
 
 /*
+ * This is the main placeholder for memcg-related information in kmem caches.
+ * struct kmem_cache will hold a pointer to it, so the memory cost while
+ * disabled is 1 pointer. The runtime cost while enabled, gets bigger than it
+ * would otherwise be if that would be bundled in kmem_cache: we'll need an
+ * extra pointer chase. But the trade off clearly lays in favor of not
+ * penalizing non-users.
+ *
+ * Both the root cache and the child caches will have it. For the root cache,
+ * this will hold a dynamically allocated array large enough to hold
+ * information about the currently limited memcgs in the system.
+ *
+ * Child caches will hold extra metadata needed for its operation. Fields are:
+ *
+ * @memcg: pointer to the memcg this cache belongs to
+ */
+struct memcg_cache_params {
+	bool is_root_cache;
+	union {
+		struct kmem_cache *memcg_caches[0];
+		struct mem_cgroup *memcg;
+	};
+};
+
+/*
  * Common kmalloc functions provided by all allocators
  */
 void * __must_check __krealloc(const void *, size_t, gfp_t);
diff -puN include/linux/slab_def.h~slab-slub-struct-memcg_params include/linux/slab_def.h
--- a/include/linux/slab_def.h~slab-slub-struct-memcg_params
+++ a/include/linux/slab_def.h
@@ -81,6 +81,9 @@ struct kmem_cache {
 	 */
 	int obj_offset;
 #endif /* CONFIG_DEBUG_SLAB */
+#ifdef CONFIG_MEMCG_KMEM
+	struct memcg_cache_params *memcg_params;
+#endif
 
 /* 6) per-cpu/per-node data, touched during every alloc/free */
 	/*
diff -puN include/linux/slub_def.h~slab-slub-struct-memcg_params include/linux/slub_def.h
--- a/include/linux/slub_def.h~slab-slub-struct-memcg_params
+++ a/include/linux/slub_def.h
@@ -101,6 +101,9 @@ struct kmem_cache {
 #ifdef CONFIG_SYSFS
 	struct kobject kobj;	/* For sysfs */
 #endif
+#ifdef CONFIG_MEMCG_KMEM
+	struct memcg_cache_params *memcg_params;
+#endif
 
 #ifdef CONFIG_NUMA
 	/*
diff -puN mm/slab.h~slab-slub-struct-memcg_params mm/slab.h
--- a/mm/slab.h~slab-slub-struct-memcg_params
+++ a/mm/slab.h
@@ -100,4 +100,17 @@ void get_slabinfo(struct kmem_cache *s, 
 void slabinfo_show_stats(struct seq_file *m, struct kmem_cache *s);
 ssize_t slabinfo_write(struct file *file, const char __user *buffer,
 		       size_t count, loff_t *ppos);
+
+#ifdef CONFIG_MEMCG_KMEM
+static inline bool is_root_cache(struct kmem_cache *s)
+{
+	return !s->memcg_params || s->memcg_params->is_root_cache;
+}
+#else
+static inline bool is_root_cache(struct kmem_cache *s)
+{
+	return true;
+}
+
+#endif
 #endif
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

