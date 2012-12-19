From: akpm@linux-foundation.org
Subject: [merged] slub-slub-specific-propagation-changes.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:42:12 -0800
Message-ID: <20121219204213.8CA9320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:65375 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2LSUmR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:42:17 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so134063eei.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:42:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: slub-specific propagation changes
has been removed from the -mm tree.  Its filename was
     slub-slub-specific-propagation-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: slub: slub-specific propagation changes

SLUB allows us to tune a particular cache behavior with sysfs-based
tunables.  When creating a new memcg cache copy, we'd like to preserve any
tunables the parent cache already had.

This can be done by tapping into the store attribute function provided by
the allocator.  We of course don't need to mess with read-only fields. 
Since the attributes can have multiple types and are stored internally by
sysfs, the best strategy is to issue a ->show() in the root cache, and
then ->store() in the memcg cache.

The drawback of that, is that sysfs can allocate up to a page in buffering
for show(), that we are likely not to need, but also can't guarantee.  To
avoid always allocating a page for that, we can update the caches at store
time with the maximum attribute size ever stored to the root cache.  We
will then get a buffer big enough to hold it.  The corolary to this, is
that if no stores happened, nothing will be propagated.

It can also happen that a root cache has its tunables updated during
normal system operation.  In this case, we will propagate the change to
all caches that are already active.

[akpm@linux-foundation.org: tweak code to avoid __maybe_unused]
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

 include/linux/slub_def.h |    1 
 mm/slub.c                |   76 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 76 insertions(+), 1 deletion(-)

diff -puN include/linux/slub_def.h~slub-slub-specific-propagation-changes include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-slub-specific-propagation-changes
+++ a/include/linux/slub_def.h
@@ -103,6 +103,7 @@ struct kmem_cache {
 #endif
 #ifdef CONFIG_MEMCG_KMEM
 	struct memcg_cache_params *memcg_params;
+	int max_attr_size; /* for propagation, maximum size of a stored attr */
 #endif
 
 #ifdef CONFIG_NUMA
diff -puN mm/slub.c~slub-slub-specific-propagation-changes mm/slub.c
--- a/mm/slub.c~slub-slub-specific-propagation-changes
+++ a/mm/slub.c
@@ -201,13 +201,14 @@ enum track_item { TRACK_ALLOC, TRACK_FRE
 static int sysfs_slab_add(struct kmem_cache *);
 static int sysfs_slab_alias(struct kmem_cache *, const char *);
 static void sysfs_slab_remove(struct kmem_cache *);
-
+static void memcg_propagate_slab_attrs(struct kmem_cache *s);
 #else
 static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
 static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
 							{ return 0; }
 static inline void sysfs_slab_remove(struct kmem_cache *s) { }
 
+static inline void memcg_propagate_slab_attrs(struct kmem_cache *s) { }
 #endif
 
 static inline void stat(const struct kmem_cache *s, enum stat_item si)
@@ -3865,6 +3866,7 @@ int __kmem_cache_create(struct kmem_cach
 	if (slab_state <= UP)
 		return 0;
 
+	memcg_propagate_slab_attrs(s);
 	mutex_unlock(&slab_mutex);
 	err = sysfs_slab_add(s);
 	mutex_lock(&slab_mutex);
@@ -5098,10 +5100,82 @@ static ssize_t slab_attr_store(struct ko
 		return -EIO;
 
 	err = attribute->store(s, buf, len);
+#ifdef CONFIG_MEMCG_KMEM
+	if (slab_state >= FULL && err >= 0 && is_root_cache(s)) {
+		int i;
+
+		mutex_lock(&slab_mutex);
+		if (s->max_attr_size < len)
+			s->max_attr_size = len;
 
+		for_each_memcg_cache_index(i) {
+			struct kmem_cache *c = cache_from_memcg(s, i);
+			/*
+			 * This function's return value is determined by the
+			 * parent cache only
+			 */
+			if (c)
+				attribute->store(c, buf, len);
+		}
+		mutex_unlock(&slab_mutex);
+	}
+#endif
 	return err;
 }
 
+static void memcg_propagate_slab_attrs(struct kmem_cache *s)
+{
+#ifdef CONFIG_MEMCG_KMEM
+	int i;
+	char *buffer = NULL;
+
+	if (!is_root_cache(s))
+		return;
+
+	/*
+	 * This mean this cache had no attribute written. Therefore, no point
+	 * in copying default values around
+	 */
+	if (!s->max_attr_size)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(slab_attrs); i++) {
+		char mbuf[64];
+		char *buf;
+		struct slab_attribute *attr = to_slab_attr(slab_attrs[i]);
+
+		if (!attr || !attr->store || !attr->show)
+			continue;
+
+		/*
+		 * It is really bad that we have to allocate here, so we will
+		 * do it only as a fallback. If we actually allocate, though,
+		 * we can just use the allocated buffer until the end.
+		 *
+		 * Most of the slub attributes will tend to be very small in
+		 * size, but sysfs allows buffers up to a page, so they can
+		 * theoretically happen.
+		 */
+		if (buffer)
+			buf = buffer;
+		else if (s->max_attr_size < ARRAY_SIZE(mbuf))
+			buf = mbuf;
+		else {
+			buffer = (char *) get_zeroed_page(GFP_KERNEL);
+			if (WARN_ON(!buffer))
+				continue;
+			buf = buffer;
+		}
+
+		attr->show(s->memcg_params->root_cache, buf);
+		attr->store(s, buf, strlen(buf));
+	}
+
+	if (buffer)
+		free_page((unsigned long)buffer);
+#endif
+}
+
 static const struct sysfs_ops slab_sysfs_ops = {
 	.show = slab_attr_show,
 	.store = slab_attr_store,
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

