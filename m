From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-wrap-kmem_cache-cpu_partial-in-config-config_slub_cpu_partial.patch
 removed from -mm tree
Date: Fri, 07 Jul 2017 12:08:00 -0700
Message-ID: <20170707190800.VGliyU6Zx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60750 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbdGGTIB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:08:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, richard.weiyang@gmail.com, rientjes@google.com


The patch titled
     Subject: mm/slub.c: wrap kmem_cache->cpu_partial in config CONFIG_SLUB_CPU_PARTIAL
has been removed from the -mm tree.  Its filename was
     mm-slub-wrap-kmem_cache-cpu_partial-in-config-config_slub_cpu_partial.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/slub.c: wrap kmem_cache->cpu_partial in config CONFIG_SLUB_CPU_PARTIAL

kmem_cache->cpu_partial is just used when CONFIG_SLUB_CPU_PARTIAL is set,
so wrap it with config CONFIG_SLUB_CPU_PARTIAL will save some space on
32bit arch.

This patch wraps kmem_cache->cpu_partial in config CONFIG_SLUB_CPU_PARTIAL
and wraps its sysfs too.

Link: http://lkml.kernel.org/r/20170502144533.10729-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   13 ++++++
 mm/slub.c                |   69 ++++++++++++++++++++-----------------
 2 files changed, 51 insertions(+), 31 deletions(-)

diff -puN include/linux/slub_def.h~mm-slub-wrap-kmem_cache-cpu_partial-in-config-config_slub_cpu_partial include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-slub-wrap-kmem_cache-cpu_partial-in-config-config_slub_cpu_partial
+++ a/include/linux/slub_def.h
@@ -86,7 +86,9 @@ struct kmem_cache {
 	int size;		/* The size of an object including meta data */
 	int object_size;	/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	int cpu_partial;	/* Number of per cpu partial objects to keep around */
+#endif
 	struct kmem_cache_order_objects oo;
 
 	/* Allocation and freeing of slabs */
@@ -131,6 +133,17 @@ struct kmem_cache {
 	struct kmem_cache_node *node[MAX_NUMNODES];
 };
 
+#ifdef CONFIG_SLUB_CPU_PARTIAL
+#define slub_cpu_partial(s)		((s)->cpu_partial)
+#define slub_set_cpu_partial(s, n)		\
+({						\
+	slub_cpu_partial(s) = (n);		\
+})
+#else
+#define slub_cpu_partial(s)		(0)
+#define slub_set_cpu_partial(s, n)
+#endif // CONFIG_SLUB_CPU_PARTIAL
+
 #ifdef CONFIG_SYSFS
 #define SLAB_SUPPORTS_SYSFS
 void sysfs_slab_release(struct kmem_cache *);
diff -puN mm/slub.c~mm-slub-wrap-kmem_cache-cpu_partial-in-config-config_slub_cpu_partial mm/slub.c
--- a/mm/slub.c~mm-slub-wrap-kmem_cache-cpu_partial-in-config-config_slub_cpu_partial
+++ a/mm/slub.c
@@ -1829,7 +1829,7 @@ static void *get_partial_node(struct kme
 			stat(s, CPU_PARTIAL_NODE);
 		}
 		if (!kmem_cache_has_cpu_partial(s)
-			|| available > s->cpu_partial / 2)
+			|| available > slub_cpu_partial(s) / 2)
 			break;
 
 	}
@@ -3404,6 +3404,39 @@ static void set_min_partial(struct kmem_
 	s->min_partial = min;
 }
 
+static void set_cpu_partial(struct kmem_cache *s)
+{
+#ifdef CONFIG_SLUB_CPU_PARTIAL
+	/*
+	 * cpu_partial determined the maximum number of objects kept in the
+	 * per cpu partial lists of a processor.
+	 *
+	 * Per cpu partial lists mainly contain slabs that just have one
+	 * object freed. If they are used for allocation then they can be
+	 * filled up again with minimal effort. The slab will never hit the
+	 * per node partial lists and therefore no locking will be required.
+	 *
+	 * This setting also determines
+	 *
+	 * A) The number of objects from per cpu partial slabs dumped to the
+	 *    per node list when we reach the limit.
+	 * B) The number of objects in cpu partial slabs to extract from the
+	 *    per node list when we run out of per cpu objects. We only fetch
+	 *    50% to keep some capacity around for frees.
+	 */
+	if (!kmem_cache_has_cpu_partial(s))
+		s->cpu_partial = 0;
+	else if (s->size >= PAGE_SIZE)
+		s->cpu_partial = 2;
+	else if (s->size >= 1024)
+		s->cpu_partial = 6;
+	else if (s->size >= 256)
+		s->cpu_partial = 13;
+	else
+		s->cpu_partial = 30;
+#endif
+}
+
 /*
  * calculate_sizes() determines the order and the distribution of data within
  * a slab object.
@@ -3562,33 +3595,7 @@ static int kmem_cache_open(struct kmem_c
 	 */
 	set_min_partial(s, ilog2(s->size) / 2);
 
-	/*
-	 * cpu_partial determined the maximum number of objects kept in the
-	 * per cpu partial lists of a processor.
-	 *
-	 * Per cpu partial lists mainly contain slabs that just have one
-	 * object freed. If they are used for allocation then they can be
-	 * filled up again with minimal effort. The slab will never hit the
-	 * per node partial lists and therefore no locking will be required.
-	 *
-	 * This setting also determines
-	 *
-	 * A) The number of objects from per cpu partial slabs dumped to the
-	 *    per node list when we reach the limit.
-	 * B) The number of objects in cpu partial slabs to extract from the
-	 *    per node list when we run out of per cpu objects. We only fetch
-	 *    50% to keep some capacity around for frees.
-	 */
-	if (!kmem_cache_has_cpu_partial(s))
-		s->cpu_partial = 0;
-	else if (s->size >= PAGE_SIZE)
-		s->cpu_partial = 2;
-	else if (s->size >= 1024)
-		s->cpu_partial = 6;
-	else if (s->size >= 256)
-		s->cpu_partial = 13;
-	else
-		s->cpu_partial = 30;
+	set_cpu_partial(s);
 
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
@@ -3975,7 +3982,7 @@ void __kmemcg_cache_deactivate(struct km
 	 * Disable empty slabs caching. Used to avoid pinning offline
 	 * memory cgroups by kmem pages that can be freed.
 	 */
-	s->cpu_partial = 0;
+	slub_set_cpu_partial(s, 0);
 	s->min_partial = 0;
 
 	/*
@@ -4915,7 +4922,7 @@ SLAB_ATTR(min_partial);
 
 static ssize_t cpu_partial_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%u\n", s->cpu_partial);
+	return sprintf(buf, "%u\n", slub_cpu_partial(s));
 }
 
 static ssize_t cpu_partial_store(struct kmem_cache *s, const char *buf,
@@ -4930,7 +4937,7 @@ static ssize_t cpu_partial_store(struct
 	if (objects && !kmem_cache_has_cpu_partial(s))
 		return -EINVAL;
 
-	s->cpu_partial = objects;
+	slub_set_cpu_partial(s, objects);
 	flush_all(s);
 	return length;
 }
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memory_hotplug-just-build-zonelist-for-new-added-node.patch
mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch

