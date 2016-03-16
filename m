From: akpm@linux-foundation.org
Subject: [merged] mm-slub-support-left-red-zone.patch removed from -mm
 tree
Date: Wed, 16 Mar 2016 12:55:10 -0700
Message-ID: <56e9ba1e.M83SDeLqCKuX5eL6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934697AbcCPTzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:55:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: support left redzone
has been removed from the -mm tree.  Its filename was
     mm-slub-support-left-red-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slub: support left redzone

SLUB already has a redzone debugging feature.  But it is only positioned
at the end of object (aka right redzone) so it cannot catch left oob. 
Although current object's right redzone acts as left redzone of next
object, first object in a slab cannot take advantage of this effect.  This
patch explicitly adds a left red zone to each object to detect left oob
more precisely.

Background:

Someone complained to me that left OOB doesn't catch even if KASAN is
enabled which does page allocation debugging.  That page is out of our
control so it would be allocated when left OOB happens and, in this
case, we can't find OOB.  Moreover, SLUB debugging feature can be
enabled without page allocator debugging and, in this case, we will
miss that OOB.

Before trying to implement, I expected that changes would be too
complex, but, it doesn't look that complex to me now.  Almost changes
are applied to debug specific functions so I feel okay.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    1 
 mm/slub.c                |  100 ++++++++++++++++++++++++++-----------
 2 files changed, 72 insertions(+), 29 deletions(-)

diff -puN include/linux/slub_def.h~mm-slub-support-left-red-zone include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-slub-support-left-red-zone
+++ a/include/linux/slub_def.h
@@ -81,6 +81,7 @@ struct kmem_cache {
 	int reserved;		/* Reserved bytes at the end of slabs */
 	const char *name;	/* Name (only for display!) */
 	struct list_head list;	/* List of slab caches */
+	int red_left_pad;	/* Left redzone padding size */
 #ifdef CONFIG_SYSFS
 	struct kobject kobj;	/* For sysfs */
 #endif
diff -puN mm/slub.c~mm-slub-support-left-red-zone mm/slub.c
--- a/mm/slub.c~mm-slub-support-left-red-zone
+++ a/mm/slub.c
@@ -124,6 +124,14 @@ static inline int kmem_cache_debug(struc
 #endif
 }
 
+static inline void *fixup_red_left(struct kmem_cache *s, void *p)
+{
+	if (kmem_cache_debug(s) && s->flags & SLAB_RED_ZONE)
+		p += s->red_left_pad;
+
+	return p;
+}
+
 static inline bool kmem_cache_has_cpu_partial(struct kmem_cache *s)
 {
 #ifdef CONFIG_SLUB_CPU_PARTIAL
@@ -232,24 +240,6 @@ static inline void stat(const struct kme
  * 			Core slab cache functions
  *******************************************************************/
 
-/* Verify that a pointer has an address that is valid within a slab page */
-static inline int check_valid_pointer(struct kmem_cache *s,
-				struct page *page, const void *object)
-{
-	void *base;
-
-	if (!object)
-		return 1;
-
-	base = page_address(page);
-	if (object < base || object >= base + page->objects * s->size ||
-		(object - base) % s->size) {
-		return 0;
-	}
-
-	return 1;
-}
-
 static inline void *get_freepointer(struct kmem_cache *s, void *object)
 {
 	return *(void **)(object + s->offset);
@@ -279,12 +269,14 @@ static inline void set_freepointer(struc
 
 /* Loop over all objects in a slab */
 #define for_each_object(__p, __s, __addr, __objects) \
-	for (__p = (__addr); __p < (__addr) + (__objects) * (__s)->size;\
-			__p += (__s)->size)
+	for (__p = fixup_red_left(__s, __addr); \
+		__p < (__addr) + (__objects) * (__s)->size; \
+		__p += (__s)->size)
 
 #define for_each_object_idx(__p, __idx, __s, __addr, __objects) \
-	for (__p = (__addr), __idx = 1; __idx <= __objects;\
-			__p += (__s)->size, __idx++)
+	for (__p = fixup_red_left(__s, __addr), __idx = 1; \
+		__idx <= __objects; \
+		__p += (__s)->size, __idx++)
 
 /* Determine object index from a given position */
 static inline int slab_index(void *p, struct kmem_cache *s, void *addr)
@@ -442,6 +434,22 @@ static void get_map(struct kmem_cache *s
 		set_bit(slab_index(p, s, addr), map);
 }
 
+static inline int size_from_object(struct kmem_cache *s)
+{
+	if (s->flags & SLAB_RED_ZONE)
+		return s->size - s->red_left_pad;
+
+	return s->size;
+}
+
+static inline void *restore_red_left(struct kmem_cache *s, void *p)
+{
+	if (s->flags & SLAB_RED_ZONE)
+		p -= s->red_left_pad;
+
+	return p;
+}
+
 /*
  * Debug settings:
  */
@@ -475,6 +483,26 @@ static inline void metadata_access_disab
 /*
  * Object debugging
  */
+
+/* Verify that a pointer has an address that is valid within a slab page */
+static inline int check_valid_pointer(struct kmem_cache *s,
+				struct page *page, void *object)
+{
+	void *base;
+
+	if (!object)
+		return 1;
+
+	base = page_address(page);
+	object = restore_red_left(s, object);
+	if (object < base || object >= base + page->objects * s->size ||
+		(object - base) % s->size) {
+		return 0;
+	}
+
+	return 1;
+}
+
 static void print_section(char *text, u8 *addr, unsigned int length)
 {
 	metadata_access_enable();
@@ -614,7 +642,9 @@ static void print_trailer(struct kmem_ca
 	pr_err("INFO: Object 0x%p @offset=%tu fp=0x%p\n\n",
 	       p, p - addr, get_freepointer(s, p));
 
-	if (p > addr + 16)
+	if (s->flags & SLAB_RED_ZONE)
+		print_section("Redzone ", p - s->red_left_pad, s->red_left_pad);
+	else if (p > addr + 16)
 		print_section("Bytes b4 ", p - 16, 16);
 
 	print_section("Object ", p, min_t(unsigned long, s->object_size,
@@ -631,9 +661,9 @@ static void print_trailer(struct kmem_ca
 	if (s->flags & SLAB_STORE_USER)
 		off += 2 * sizeof(struct track);
 
-	if (off != s->size)
+	if (off != size_from_object(s))
 		/* Beginning of the filler is the free pointer */
-		print_section("Padding ", p + off, s->size - off);
+		print_section("Padding ", p + off, size_from_object(s) - off);
 
 	dump_stack();
 }
@@ -663,6 +693,9 @@ static void init_object(struct kmem_cach
 {
 	u8 *p = object;
 
+	if (s->flags & SLAB_RED_ZONE)
+		memset(p - s->red_left_pad, val, s->red_left_pad);
+
 	if (s->flags & __OBJECT_POISON) {
 		memset(p, POISON_FREE, s->object_size - 1);
 		p[s->object_size - 1] = POISON_END;
@@ -755,11 +788,11 @@ static int check_pad_bytes(struct kmem_c
 		/* We also have user information there */
 		off += 2 * sizeof(struct track);
 
-	if (s->size == off)
+	if (size_from_object(s) == off)
 		return 1;
 
 	return check_bytes_and_report(s, page, p, "Object padding",
-				p + off, POISON_INUSE, s->size - off);
+			p + off, POISON_INUSE, size_from_object(s) - off);
 }
 
 /* Check the pad bytes at the end of a slab page */
@@ -804,6 +837,10 @@ static int check_object(struct kmem_cach
 
 	if (s->flags & SLAB_RED_ZONE) {
 		if (!check_bytes_and_report(s, page, object, "Redzone",
+			object - s->red_left_pad, val, s->red_left_pad))
+			return 0;
+
+		if (!check_bytes_and_report(s, page, object, "Redzone",
 			endobject, val, s->inuse - s->object_size))
 			return 0;
 	} else {
@@ -1445,7 +1482,7 @@ static struct page *allocate_slab(struct
 			set_freepointer(s, p, NULL);
 	}
 
-	page->freelist = start;
+	page->freelist = fixup_red_left(s, start);
 	page->inuse = page->objects;
 	page->frozen = 1;
 
@@ -3274,7 +3311,7 @@ static int calculate_sizes(struct kmem_c
 		 */
 		size += 2 * sizeof(struct track);
 
-	if (flags & SLAB_RED_ZONE)
+	if (flags & SLAB_RED_ZONE) {
 		/*
 		 * Add some empty padding so that we can catch
 		 * overwrites from earlier objects rather than let
@@ -3283,6 +3320,11 @@ static int calculate_sizes(struct kmem_c
 		 * of the object.
 		 */
 		size += sizeof(void *);
+
+		s->red_left_pad = sizeof(void *);
+		s->red_left_pad = ALIGN(s->red_left_pad, s->align);
+		size += s->red_left_pad;
+	}
 #endif
 
 	/*
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

