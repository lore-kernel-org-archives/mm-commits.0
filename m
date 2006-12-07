From: akpm@osdl.org
Subject: - leak-tracking-for-kmalloc_node.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:09 -0800
Message-ID: <200612072257.kB7Mv9ms029262@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50586 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163585AbWLGW5Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     leak tracking for kmalloc_node
has been removed from the -mm tree.  Its filename was
     leak-tracking-for-kmalloc_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: leak tracking for kmalloc_node
From: Christoph Hellwig <hch@lst.de>

We have variants of kmalloc and kmem_cache_alloc that leave leak tracking to
the caller.  This is used for subsystem-specific allocators like skb_alloc.

To make skb_alloc node-aware we need similar routines for the node-aware slab
allocator, which this patch adds.

Note that the code is rather ugly, but it mirrors the non-node-aware code 1:1:

[akpm@osdl.org: add module export]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/slab.h |   23 +++++++++++++++++
 mm/slab.c            |   55 +++++++++++++++++++++++++++++++----------
 2 files changed, 65 insertions(+), 13 deletions(-)

diff -puN include/linux/slab.h~leak-tracking-for-kmalloc_node include/linux/slab.h
--- a/include/linux/slab.h~leak-tracking-for-kmalloc_node
+++ a/include/linux/slab.h
@@ -236,7 +236,25 @@ found:
 	}
 	return __kmalloc_node(size, flags, node);
 }
+
+/*
+ * kmalloc_node_track_caller is a special version of kmalloc_node that
+ * records the calling function of the routine calling it for slab leak
+ * tracking instead of just the calling function (confusing, eh?).
+ * It's useful when the call to kmalloc_node comes from a widely-used
+ * standard allocator where we care about the real place the memory
+ * allocation request comes from.
+ */
+#ifndef CONFIG_DEBUG_SLAB
+#define kmalloc_node_track_caller(size, flags, node) \
+	__kmalloc_node(size, flags, node)
 #else
+extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, void *);
+#define kmalloc_node_track_caller(size, flags, node) \
+	__kmalloc_node_track_caller(size, flags, node, \
+			__builtin_return_address(0))
+#endif
+#else /* CONFIG_NUMA */
 static inline void *kmem_cache_alloc_node(kmem_cache_t *cachep, gfp_t flags, int node)
 {
 	return kmem_cache_alloc(cachep, flags);
@@ -245,6 +263,9 @@ static inline void *kmalloc_node(size_t 
 {
 	return kmalloc(size, flags);
 }
+
+#define kmalloc_node_track_caller(size, flags, node) \
+	kmalloc_track_caller(size, flags)
 #endif
 
 extern int FASTCALL(kmem_cache_reap(int));
@@ -283,6 +304,8 @@ static inline void *kcalloc(size_t n, si
 #define kzalloc(s, f) __kzalloc(s, f)
 #define kmalloc_track_caller kmalloc
 
+#define kmalloc_node_track_caller kmalloc_node
+
 #endif /* CONFIG_SLOB */
 
 /* System wide caches */
diff -puN mm/slab.c~leak-tracking-for-kmalloc_node mm/slab.c
--- a/mm/slab.c~leak-tracking-for-kmalloc_node
+++ a/mm/slab.c
@@ -1015,7 +1015,7 @@ static inline void *alternate_node_alloc
 	return NULL;
 }
 
-static inline void *__cache_alloc_node(struct kmem_cache *cachep,
+static inline void *____cache_alloc_node(struct kmem_cache *cachep,
 		 gfp_t flags, int nodeid)
 {
 	return NULL;
@@ -1023,7 +1023,7 @@ static inline void *__cache_alloc_node(s
 
 #else	/* CONFIG_NUMA */
 
-static void *__cache_alloc_node(struct kmem_cache *, gfp_t, int);
+static void *____cache_alloc_node(struct kmem_cache *, gfp_t, int);
 static void *alternate_node_alloc(struct kmem_cache *, gfp_t);
 
 static struct array_cache **alloc_alien_cache(int node, int limit)
@@ -3130,10 +3130,10 @@ static __always_inline void *__cache_all
 		objp = ____cache_alloc(cachep, flags);
 	/*
 	 * We may just have run out of memory on the local node.
-	 * __cache_alloc_node() knows how to locate memory on other nodes
+	 * ____cache_alloc_node() knows how to locate memory on other nodes
 	 */
  	if (NUMA_BUILD && !objp)
- 		objp = __cache_alloc_node(cachep, flags, numa_node_id());
+ 		objp = ____cache_alloc_node(cachep, flags, numa_node_id());
 	local_irq_restore(save_flags);
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp,
 					    caller);
@@ -3160,7 +3160,7 @@ static void *alternate_node_alloc(struct
 	else if (current->mempolicy)
 		nid_alloc = slab_node(current->mempolicy);
 	if (nid_alloc != nid_here)
-		return __cache_alloc_node(cachep, flags, nid_alloc);
+		return ____cache_alloc_node(cachep, flags, nid_alloc);
 	return NULL;
 }
 
@@ -3183,7 +3183,7 @@ void *fallback_alloc(struct kmem_cache *
 		if (zone_idx(*z) <= ZONE_NORMAL &&
 				cpuset_zone_allowed(*z, flags) &&
 				cache->nodelists[nid])
-			obj = __cache_alloc_node(cache,
+			obj = ____cache_alloc_node(cache,
 					flags | __GFP_THISNODE, nid);
 	}
 	return obj;
@@ -3192,7 +3192,7 @@ void *fallback_alloc(struct kmem_cache *
 /*
  * A interface to enable slab creation on nodeid
  */
-static void *__cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
+static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 				int nodeid)
 {
 	struct list_head *entry;
@@ -3465,7 +3465,9 @@ out:
  * New and improved: it will now make sure that the object gets
  * put on the correct node list so that there is no false sharing.
  */
-void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
+static __always_inline void *
+__cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
+		int nodeid, void *caller)
 {
 	unsigned long save_flags;
 	void *ptr;
@@ -3477,17 +3479,23 @@ void *kmem_cache_alloc_node(struct kmem_
 			!cachep->nodelists[nodeid])
 		ptr = ____cache_alloc(cachep, flags);
 	else
-		ptr = __cache_alloc_node(cachep, flags, nodeid);
+		ptr = ____cache_alloc_node(cachep, flags, nodeid);
 	local_irq_restore(save_flags);
 
-	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr,
-					   __builtin_return_address(0));
+	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
 
 	return ptr;
 }
+
+void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
+{
+	return __cache_alloc_node(cachep, flags, nodeid,
+			__builtin_return_address(0));
+}
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 
-void *__kmalloc_node(size_t size, gfp_t flags, int node)
+static __always_inline void *
+__do_kmalloc_node(size_t size, gfp_t flags, int node, void *caller)
 {
 	struct kmem_cache *cachep;
 
@@ -3496,8 +3504,29 @@ void *__kmalloc_node(size_t size, gfp_t 
 		return NULL;
 	return kmem_cache_alloc_node(cachep, flags, node);
 }
+
+#ifdef CONFIG_DEBUG_SLAB
+void *__kmalloc_node(size_t size, gfp_t flags, int node)
+{
+	return __do_kmalloc_node(size, flags, node,
+			__builtin_return_address(0));
+}
 EXPORT_SYMBOL(__kmalloc_node);
-#endif
+
+void *__kmalloc_node_track_caller(size_t size, gfp_t flags,
+		int node, void *caller)
+{
+	return __do_kmalloc_node(size, flags, node, caller);
+}
+EXPORT_SYMBOL(__kmalloc_node_track_caller);
+#else
+void *__kmalloc_node(size_t size, gfp_t flags, int node)
+{
+	return __do_kmalloc_node(size, flags, node, NULL);
+}
+EXPORT_SYMBOL(__kmalloc_node);
+#endif /* CONFIG_DEBUG_SLAB */
+#endif /* CONFIG_NUMA */
 
 /**
  * __do_kmalloc - allocate memory
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
touch_atime-cleanup.patch
relative-atime.patch
ocfs2-relative-atime-support.patch
ocfs2-relative-atime-support-tweaks.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch
fdtable-delete-pointless-code-in-dup_fd.patch
fdtable-make-fdarray-and-fdsets-equal-in-size.patch
fdtable-remove-the-free_files-field.patch
fdtable-implement-new-pagesize-based-fdtable-allocator.patch

