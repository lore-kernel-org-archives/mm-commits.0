From: akpm@linux-foundation.org
Subject: + mm-slub-support-left-red-zone.patch added to -mm tree
Date: Thu, 04 Feb 2016 15:28:38 -0800
Message-ID: <56b3dea6.bbZIoRDeOFJV5OMJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbcBDX2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:28:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: support left redzone
has been added to the -mm tree.  Its filename is
     mm-slub-support-left-red-zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-support-left-red-zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-support-left-red-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/slub: support left redzone

SLUB already has a redzone debugging feature.  But it is only positioned
at the end of object (aka right redzone) so it cannot catch left oob. 
Although current object's right redzone acts as left redzone of next
object, first object in a slab cannot take advantage of this effect.  This
patch explicitly adds a left red zone to each object to detect left oob
more precisely.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    1 
 mm/slub.c                |  158 ++++++++++++++++++++++++++-----------
 2 files changed, 115 insertions(+), 44 deletions(-)

diff -puN include/linux/slub_def.h~mm-slub-support-left-red-zone include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-slub-support-left-red-zone
+++ a/include/linux/slub_def.h
@@ -77,6 +77,7 @@ struct kmem_cache {
 	int refcount;		/* Refcount for slab cache destroy */
 	void (*ctor)(void *);
 	int inuse;		/* Offset to metadata */
+	int red_left_pad;	/* Left redzone padding size */
 	int align;		/* Alignment */
 	int reserved;		/* Reserved bytes at the end of slabs */
 	const char *name;	/* Name (only for display!) */
diff -puN mm/slub.c~mm-slub-support-left-red-zone mm/slub.c
--- a/mm/slub.c~mm-slub-support-left-red-zone
+++ a/mm/slub.c
@@ -39,6 +39,10 @@
 
 #include "internal.h"
 
+#ifdef CONFIG_KASAN
+#include "kasan/kasan.h"
+#endif
+
 /*
  * Lock order:
  *   1. slab_mutex (Global Mutex)
@@ -124,6 +128,14 @@ static inline int kmem_cache_debug(struc
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
@@ -224,24 +236,6 @@ static inline void stat(const struct kme
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
@@ -434,6 +428,22 @@ static void get_map(struct kmem_cache *s
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
@@ -467,6 +477,26 @@ static inline void metadata_access_disab
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
@@ -606,7 +636,9 @@ static void print_trailer(struct kmem_ca
 	pr_err("INFO: Object 0x%p @offset=%tu fp=0x%p\n\n",
 	       p, p - addr, get_freepointer(s, p));
 
-	if (p > addr + 16)
+	if (s->flags & SLAB_RED_ZONE)
+		print_section("Redzone ", p - s->red_left_pad, s->red_left_pad);
+	else if (p > addr + 16)
 		print_section("Bytes b4 ", p - 16, 16);
 
 	print_section("Object ", p, min_t(unsigned long, s->object_size,
@@ -623,9 +655,9 @@ static void print_trailer(struct kmem_ca
 	if (s->flags & SLAB_STORE_USER)
 		off += 2 * sizeof(struct track);
 
-	if (off != s->size)
+	if (off != size_from_object(s))
 		/* Beginning of the filler is the free pointer */
-		print_section("Padding ", p + off, s->size - off);
+		print_section("Padding ", p + off, size_from_object(s) - off);
 
 	dump_stack();
 }
@@ -655,6 +687,9 @@ static void init_object(struct kmem_cach
 {
 	u8 *p = object;
 
+	if (s->flags & SLAB_RED_ZONE)
+		memset(p - s->red_left_pad, val, s->red_left_pad);
+
 	if (s->flags & __OBJECT_POISON) {
 		memset(p, POISON_FREE, s->object_size - 1);
 		p[s->object_size - 1] = POISON_END;
@@ -747,11 +782,11 @@ static int check_pad_bytes(struct kmem_c
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
@@ -796,6 +831,10 @@ static int check_object(struct kmem_cach
 
 	if (s->flags & SLAB_RED_ZONE) {
 		if (!check_bytes_and_report(s, page, object, "Redzone",
+			object - s->red_left_pad, val, s->red_left_pad))
+			return 0;
+
+		if (!check_bytes_and_report(s, page, object, "Redzone",
 			endobject, val, s->inuse - s->object_size))
 			return 0;
 	} else {
@@ -997,14 +1036,17 @@ static inline void dec_slabs_node(struct
 }
 
 /* Object debug checks for alloc/free paths */
-static void setup_object_debug(struct kmem_cache *s, struct page *page,
+static void *setup_object_debug(struct kmem_cache *s, struct page *page,
 								void *object)
 {
 	if (!(s->flags & (SLAB_STORE_USER|SLAB_RED_ZONE|__OBJECT_POISON)))
-		return;
+		return object;
 
+	object = fixup_red_left(s, object);
 	init_object(s, object, SLUB_RED_INACTIVE);
 	init_tracking(s, object);
+
+	return object;
 }
 
 static noinline int alloc_debug_processing(struct kmem_cache *s,
@@ -1201,8 +1243,8 @@ unsigned long kmem_cache_flags(unsigned
 	return flags;
 }
 #else /* !CONFIG_SLUB_DEBUG */
-static inline void setup_object_debug(struct kmem_cache *s,
-			struct page *page, void *object) {}
+static inline void *setup_object_debug(struct kmem_cache *s,
+			struct page *page, void *object) { return object; }
 
 static inline int alloc_debug_processing(struct kmem_cache *s,
 	struct page *page, void *object, unsigned long addr) { return 0; }
@@ -1305,15 +1347,17 @@ static inline void slab_free_freelist_ho
 #endif
 }
 
-static void setup_object(struct kmem_cache *s, struct page *page,
+static void *setup_object(struct kmem_cache *s, struct page *page,
 				void *object)
 {
-	setup_object_debug(s, page, object);
+	object = setup_object_debug(s, page, object);
 	if (unlikely(s->ctor)) {
 		kasan_unpoison_object_data(s, object);
 		s->ctor(object);
 		kasan_poison_object_data(s, object);
 	}
+
+	return object;
 }
 
 /*
@@ -1409,14 +1453,16 @@ static struct page *allocate_slab(struct
 	kasan_poison_slab(page);
 
 	for_each_object_idx(p, idx, s, start, page->objects) {
-		setup_object(s, page, p);
-		if (likely(idx < page->objects))
-			set_freepointer(s, p, p + s->size);
-		else
-			set_freepointer(s, p, NULL);
+		void *object = setup_object(s, page, p);
+
+		if (likely(idx < page->objects)) {
+			set_freepointer(s, object,
+				fixup_red_left(s, p + s->size));
+		} else
+			set_freepointer(s, object, NULL);
 	}
 
-	page->freelist = start;
+	page->freelist = fixup_red_left(s, start);
 	page->inuse = page->objects;
 	page->frozen = 1;
 
@@ -1457,8 +1503,11 @@ static void __free_slab(struct kmem_cach
 
 		slab_pad_check(s, page);
 		for_each_object(p, s, page_address(page),
-						page->objects)
-			check_object(s, page, p, SLUB_RED_INACTIVE);
+						page->objects) {
+			void *object = fixup_red_left(s, p);
+
+			check_object(s, page, object, SLUB_RED_INACTIVE);
+		}
 	}
 
 	kmemcheck_free_shadow(page, compound_order(page));
@@ -3255,6 +3304,16 @@ static int calculate_sizes(struct kmem_c
 		 * of the object.
 		 */
 		size += sizeof(void *);
+
+	if (flags & SLAB_RED_ZONE) {
+		s->red_left_pad = sizeof(void *);
+#ifdef CONFIG_KASAN
+		s->red_left_pad = min_t(int, s->red_left_pad,
+				KASAN_SHADOW_SCALE_SIZE);
+#endif
+		s->red_left_pad = ALIGN(s->red_left_pad, s->align);
+		size += s->red_left_pad;
+	}
 #endif
 
 	/*
@@ -3391,10 +3450,12 @@ static void list_slab_objects(struct kme
 
 	get_map(s, page, map);
 	for_each_object(p, s, addr, page->objects) {
+		void *object = fixup_red_left(s, p);
 
 		if (!test_bit(slab_index(p, s, addr), map)) {
-			pr_err("INFO: Object 0x%p @offset=%tu\n", p, p - addr);
-			print_tracking(s, p);
+			pr_err("INFO: Object 0x%p @offset=%tu\n",
+					object, object - addr);
+			print_tracking(s, object);
 		}
 	}
 	slab_unlock(page);
@@ -4063,15 +4124,21 @@ static int validate_slab(struct kmem_cac
 
 	get_map(s, page, map);
 	for_each_object(p, s, addr, page->objects) {
+		void *object = fixup_red_left(s, p);
+
 		if (test_bit(slab_index(p, s, addr), map))
-			if (!check_object(s, page, p, SLUB_RED_INACTIVE))
+			if (!check_object(s, page, object, SLUB_RED_INACTIVE))
 				return 0;
 	}
 
-	for_each_object(p, s, addr, page->objects)
+	for_each_object(p, s, addr, page->objects) {
+		void *object = fixup_red_left(s, p);
+
 		if (!test_bit(slab_index(p, s, addr), map))
-			if (!check_object(s, page, p, SLUB_RED_ACTIVE))
+			if (!check_object(s, page, object, SLUB_RED_ACTIVE))
 				return 0;
+	}
+
 	return 1;
 }
 
@@ -4269,9 +4336,12 @@ static void process_slab(struct loc_trac
 	bitmap_zero(map, page->objects);
 	get_map(s, page, map);
 
-	for_each_object(p, s, addr, page->objects)
+	for_each_object(p, s, addr, page->objects) {
+		void *object = fixup_red_left(s, p);
+
 		if (!test_bit(slab_index(p, s, addr), map))
-			add_location(t, s, get_track(s, p, alloc));
+			add_location(t, s, get_track(s, object, alloc));
+	}
 }
 
 static int list_locations(struct kmem_cache *s, char *buf,
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch
mm-slab-re-implement-pfmemalloc-support.patch
mm-slub-support-left-red-zone.patch
mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch

