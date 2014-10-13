From: akpm@linux-foundation.org
Subject: [merged] mm-slab_common-commonize-slab-merge-logic.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:18:52 -0700
Message-ID: <543c178c.xMhOrTVbVq0wD7Cd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaJMSSw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rdunlap@infradead.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common: commonize slab merge logic
has been removed from the -mm tree.  Its filename was
     mm-slab_common-commonize-slab-merge-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab_common: commonize slab merge logic

Slab merge is good feature to reduce fragmentation.  Now, it is only
applied to SLUB, but, it would be good to apply it to SLAB.  This patch is
preparation step to apply slab merge to SLAB by commonizing slab merge
logic.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   14 ++--
 mm/slab.h                           |   15 ++++
 mm/slab_common.c                    |   91 ++++++++++++++++++++++++++
 mm/slub.c                           |   91 --------------------------
 4 files changed, 117 insertions(+), 94 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-slab_common-commonize-slab-merge-logic Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-slab_common-commonize-slab-merge-logic
+++ a/Documentation/kernel-parameters.txt
@@ -3158,6 +3158,13 @@ bytes respectively. Such letter suffixes
 
 	slram=		[HW,MTD]
 
+	slab_nomerge	[MM]
+			Disable merging of slabs with similar size. May be
+			necessary if there is some reason to distinguish
+			allocs to different slabs. Debug options disable
+			merging on their own.
+			For more information see Documentation/vm/slub.txt.
+
 	slab_max_order=	[MM, SLAB]
 			Determines the maximum allowed order for slabs.
 			A high setting may cause OOMs due to memory
@@ -3193,11 +3200,8 @@ bytes respectively. Such letter suffixes
 			For more information see Documentation/vm/slub.txt.
 
 	slub_nomerge	[MM, SLUB]
-			Disable merging of slabs with similar size. May be
-			necessary if there is some reason to distinguish
-			allocs to different slabs. Debug options disable
-			merging on their own.
-			For more information see Documentation/vm/slub.txt.
+			Same with slab_nomerge. This is supported for legacy.
+			See slab_nomerge for more information.
 
 	smart2=		[HW]
 			Format: <io1>[,<io2>[,...,<io8>]]
diff -puN mm/slab.h~mm-slab_common-commonize-slab-merge-logic mm/slab.h
--- a/mm/slab.h~mm-slab_common-commonize-slab-merge-logic
+++ a/mm/slab.h
@@ -88,15 +88,30 @@ extern void create_boot_cache(struct kme
 			size_t size, unsigned long flags);
 
 struct mem_cgroup;
+
+int slab_unmergeable(struct kmem_cache *s);
+struct kmem_cache *find_mergeable(size_t size, size_t align,
+		unsigned long flags, const char *name, void (*ctor)(void *));
 #ifdef CONFIG_SLUB
 struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
 		   unsigned long flags, void (*ctor)(void *));
+
+unsigned long kmem_cache_flags(unsigned long object_size,
+	unsigned long flags, const char *name,
+	void (*ctor)(void *));
 #else
 static inline struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
 		   unsigned long flags, void (*ctor)(void *))
 { return NULL; }
+
+static inline unsigned long kmem_cache_flags(unsigned long object_size,
+	unsigned long flags, const char *name,
+	void (*ctor)(void *))
+{
+	return flags;
+}
 #endif
 
 
diff -puN mm/slab_common.c~mm-slab_common-commonize-slab-merge-logic mm/slab_common.c
--- a/mm/slab_common.c~mm-slab_common-commonize-slab-merge-logic
+++ a/mm/slab_common.c
@@ -31,6 +31,34 @@ DEFINE_MUTEX(slab_mutex);
 struct kmem_cache *kmem_cache;
 
 /*
+ * Set of flags that will prevent slab merging
+ */
+#define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
+		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE | \
+		SLAB_FAILSLAB)
+
+#define SLAB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
+		SLAB_CACHE_DMA | SLAB_NOTRACK)
+
+/*
+ * Merge control. If this is set then no merging of slab caches will occur.
+ * (Could be removed. This was introduced to pacify the merge skeptics.)
+ */
+static int slab_nomerge;
+
+static int __init setup_slab_nomerge(char *str)
+{
+	slab_nomerge = 1;
+	return 1;
+}
+
+#ifdef CONFIG_SLUB
+__setup_param("slub_nomerge", slub_nomerge, setup_slab_nomerge, 0);
+#endif
+
+__setup("slab_nomerge", setup_slab_nomerge);
+
+/*
  * Determine the size of a slab object
  */
 unsigned int kmem_cache_size(struct kmem_cache *s)
@@ -116,6 +144,69 @@ out:
 #endif
 
 /*
+ * Find a mergeable slab cache
+ */
+int slab_unmergeable(struct kmem_cache *s)
+{
+	if (slab_nomerge || (s->flags & SLAB_NEVER_MERGE))
+		return 1;
+
+	if (!is_root_cache(s))
+		return 1;
+
+	if (s->ctor)
+		return 1;
+
+	/*
+	 * We may have set a slab to be unmergeable during bootstrap.
+	 */
+	if (s->refcount < 0)
+		return 1;
+
+	return 0;
+}
+
+struct kmem_cache *find_mergeable(size_t size, size_t align,
+		unsigned long flags, const char *name, void (*ctor)(void *))
+{
+	struct kmem_cache *s;
+
+	if (slab_nomerge || (flags & SLAB_NEVER_MERGE))
+		return NULL;
+
+	if (ctor)
+		return NULL;
+
+	size = ALIGN(size, sizeof(void *));
+	align = calculate_alignment(flags, align, size);
+	size = ALIGN(size, align);
+	flags = kmem_cache_flags(size, flags, name, NULL);
+
+	list_for_each_entry(s, &slab_caches, list) {
+		if (slab_unmergeable(s))
+			continue;
+
+		if (size > s->size)
+			continue;
+
+		if ((flags & SLAB_MERGE_SAME) != (s->flags & SLAB_MERGE_SAME))
+			continue;
+		/*
+		 * Check if alignment is compatible.
+		 * Courtesy of Adrian Drzewiecki
+		 */
+		if ((s->size & ~(align - 1)) != s->size)
+			continue;
+
+		if (s->size - size >= sizeof(void *))
+			continue;
+
+		return s;
+	}
+	return NULL;
+}
+
+/*
  * Figure out what the alignment of the objects will be given a set of
  * flags, a user specified alignment and the size of the objects.
  */
diff -puN mm/slub.c~mm-slab_common-commonize-slab-merge-logic mm/slub.c
--- a/mm/slub.c~mm-slab_common-commonize-slab-merge-logic
+++ a/mm/slub.c
@@ -169,16 +169,6 @@ static inline bool kmem_cache_has_cpu_pa
  */
 #define DEBUG_METADATA_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
 
-/*
- * Set of flags that will prevent slab merging
- */
-#define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE | \
-		SLAB_FAILSLAB)
-
-#define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
-		SLAB_CACHE_DMA | SLAB_NOTRACK)
-
 #define OO_SHIFT	16
 #define OO_MASK		((1 << OO_SHIFT) - 1)
 #define MAX_OBJS_PER_PAGE	32767 /* since page.objects is u15 */
@@ -1176,7 +1166,7 @@ out:
 
 __setup("slub_debug", setup_slub_debug);
 
-static unsigned long kmem_cache_flags(unsigned long object_size,
+unsigned long kmem_cache_flags(unsigned long object_size,
 	unsigned long flags, const char *name,
 	void (*ctor)(void *))
 {
@@ -1208,7 +1198,7 @@ static inline void add_full(struct kmem_
 					struct page *page) {}
 static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
 					struct page *page) {}
-static inline unsigned long kmem_cache_flags(unsigned long object_size,
+unsigned long kmem_cache_flags(unsigned long object_size,
 	unsigned long flags, const char *name,
 	void (*ctor)(void *))
 {
@@ -2719,12 +2709,6 @@ static int slub_max_order = PAGE_ALLOC_C
 static int slub_min_objects;
 
 /*
- * Merge control. If this is set then no merging of slab caches will occur.
- * (Could be removed. This was introduced to pacify the merge skeptics.)
- */
-static int slub_nomerge;
-
-/*
  * Calculate the order of allocation given an slab object size.
  *
  * The order of allocation has significant impact on performance and other
@@ -3252,14 +3236,6 @@ static int __init setup_slub_min_objects
 
 __setup("slub_min_objects=", setup_slub_min_objects);
 
-static int __init setup_slub_nomerge(char *str)
-{
-	slub_nomerge = 1;
-	return 1;
-}
-
-__setup("slub_nomerge", setup_slub_nomerge);
-
 void *__kmalloc(size_t size, gfp_t flags)
 {
 	struct kmem_cache *s;
@@ -3637,69 +3613,6 @@ void __init kmem_cache_init_late(void)
 {
 }
 
-/*
- * Find a mergeable slab cache
- */
-static int slab_unmergeable(struct kmem_cache *s)
-{
-	if (slub_nomerge || (s->flags & SLUB_NEVER_MERGE))
-		return 1;
-
-	if (!is_root_cache(s))
-		return 1;
-
-	if (s->ctor)
-		return 1;
-
-	/*
-	 * We may have set a slab to be unmergeable during bootstrap.
-	 */
-	if (s->refcount < 0)
-		return 1;
-
-	return 0;
-}
-
-static struct kmem_cache *find_mergeable(size_t size, size_t align,
-		unsigned long flags, const char *name, void (*ctor)(void *))
-{
-	struct kmem_cache *s;
-
-	if (slub_nomerge || (flags & SLUB_NEVER_MERGE))
-		return NULL;
-
-	if (ctor)
-		return NULL;
-
-	size = ALIGN(size, sizeof(void *));
-	align = calculate_alignment(flags, align, size);
-	size = ALIGN(size, align);
-	flags = kmem_cache_flags(size, flags, name, NULL);
-
-	list_for_each_entry(s, &slab_caches, list) {
-		if (slab_unmergeable(s))
-			continue;
-
-		if (size > s->size)
-			continue;
-
-		if ((flags & SLUB_MERGE_SAME) != (s->flags & SLUB_MERGE_SAME))
-			continue;
-		/*
-		 * Check if alignment is compatible.
-		 * Courtesy of Adrian Drzewiecki
-		 */
-		if ((s->size & ~(align - 1)) != s->size)
-			continue;
-
-		if (s->size - size >= sizeof(void *))
-			continue;
-
-		return s;
-	}
-	return NULL;
-}
