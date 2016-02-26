From: akpm@linux-foundation.org
Subject: + mm-slub-support-left-red-zone-fix.patch added to -mm tree
Date: Fri, 26 Feb 2016 15:59:58 -0800
Message-ID: <56d0e6fe.wN0kKPt3kt/PmV7C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbcBZX77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Feb 2016 18:59:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: support left redzone
has been added to the -mm tree.  Its filename is
     mm-slub-support-left-red-zone-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-support-left-red-zone-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-support-left-red-zone-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slub: support left redzone

v2: fixes per Christoph
o move red_left_pad field to after the non debugging fields.
o make for_each_object(_idx) handle red_left_pad
o remove KASAN dependcy which is incorrect

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    2 
 mm/slub.c                |   82 ++++++++++++-------------------------
 2 files changed, 28 insertions(+), 56 deletions(-)

diff -puN include/linux/slub_def.h~mm-slub-support-left-red-zone-fix include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-slub-support-left-red-zone-fix
+++ a/include/linux/slub_def.h
@@ -77,11 +77,11 @@ struct kmem_cache {
 	int refcount;		/* Refcount for slab cache destroy */
 	void (*ctor)(void *);
 	int inuse;		/* Offset to metadata */
-	int red_left_pad;	/* Left redzone padding size */
 	int align;		/* Alignment */
 	int reserved;		/* Reserved bytes at the end of slabs */
 	const char *name;	/* Name (only for display!) */
 	struct list_head list;	/* List of slab caches */
+	int red_left_pad;	/* Left redzone padding size */
 #ifdef CONFIG_SYSFS
 	struct kobject kobj;	/* For sysfs */
 #endif
diff -puN mm/slub.c~mm-slub-support-left-red-zone-fix mm/slub.c
--- a/mm/slub.c~mm-slub-support-left-red-zone-fix
+++ a/mm/slub.c
@@ -39,10 +39,6 @@
 
 #include "internal.h"
 
-#ifdef CONFIG_KASAN
-#include "kasan/kasan.h"
-#endif
-
 /*
  * Lock order:
  *   1. slab_mutex (Global Mutex)
@@ -273,12 +269,14 @@ static inline void set_freepointer(struc
 
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
@@ -1044,17 +1042,14 @@ static inline void dec_slabs_node(struct
 }
 
 /* Object debug checks for alloc/free paths */
-static void *setup_object_debug(struct kmem_cache *s, struct page *page,
+static void setup_object_debug(struct kmem_cache *s, struct page *page,
 								void *object)
 {
 	if (!(s->flags & (SLAB_STORE_USER|SLAB_RED_ZONE|__OBJECT_POISON)))
-		return object;
+		return;
 
-	object = fixup_red_left(s, object);
 	init_object(s, object, SLUB_RED_INACTIVE);
 	init_tracking(s, object);
-
-	return object;
 }
 
 static inline int alloc_consistency_checks(struct kmem_cache *s,
@@ -1272,8 +1267,8 @@ unsigned long kmem_cache_flags(unsigned
 	return flags;
 }
 #else /* !CONFIG_SLUB_DEBUG */
-static inline void *setup_object_debug(struct kmem_cache *s,
-			struct page *page, void *object) { return object; }
+static inline void setup_object_debug(struct kmem_cache *s,
+			struct page *page, void *object) {}
 
 static inline int alloc_debug_processing(struct kmem_cache *s,
 	struct page *page, void *object, unsigned long addr) { return 0; }
@@ -1376,17 +1371,15 @@ static inline void slab_free_freelist_ho
 #endif
 }
 
-static void *setup_object(struct kmem_cache *s, struct page *page,
+static void setup_object(struct kmem_cache *s, struct page *page,
 				void *object)
 {
-	object = setup_object_debug(s, page, object);
+	setup_object_debug(s, page, object);
 	if (unlikely(s->ctor)) {
 		kasan_unpoison_object_data(s, object);
 		s->ctor(object);
 		kasan_poison_object_data(s, object);
 	}
-
-	return object;
 }
 
 /*
@@ -1482,13 +1475,11 @@ static struct page *allocate_slab(struct
 	kasan_poison_slab(page);
 
 	for_each_object_idx(p, idx, s, start, page->objects) {
-		void *object = setup_object(s, page, p);
-
-		if (likely(idx < page->objects)) {
-			set_freepointer(s, object,
-				fixup_red_left(s, p + s->size));
-		} else
-			set_freepointer(s, object, NULL);
+		setup_object(s, page, p);
+		if (likely(idx < page->objects))
+			set_freepointer(s, p, p + s->size);
+		else
+			set_freepointer(s, p, NULL);
 	}
 
 	page->freelist = fixup_red_left(s, start);
@@ -1532,11 +1523,8 @@ static void __free_slab(struct kmem_cach
 
 		slab_pad_check(s, page);
 		for_each_object(p, s, page_address(page),
-						page->objects) {
-			void *object = fixup_red_left(s, p);
-
-			check_object(s, page, object, SLUB_RED_INACTIVE);
-		}
+						page->objects)
+			check_object(s, page, p, SLUB_RED_INACTIVE);
 	}
 
 	kmemcheck_free_shadow(page, compound_order(page));
@@ -3323,7 +3311,7 @@ static int calculate_sizes(struct kmem_c
 		 */
 		size += 2 * sizeof(struct track);
 
-	if (flags & SLAB_RED_ZONE)
+	if (flags & SLAB_RED_ZONE) {
 		/*
 		 * Add some empty padding so that we can catch
 		 * overwrites from earlier objects rather than let
@@ -3333,12 +3321,7 @@ static int calculate_sizes(struct kmem_c
 		 */
 		size += sizeof(void *);
 
-	if (flags & SLAB_RED_ZONE) {
 		s->red_left_pad = sizeof(void *);
-#ifdef CONFIG_KASAN
-		s->red_left_pad = min_t(int, s->red_left_pad,
-				KASAN_SHADOW_SCALE_SIZE);
-#endif
 		s->red_left_pad = ALIGN(s->red_left_pad, s->align);
 		size += s->red_left_pad;
 	}
@@ -3478,12 +3461,10 @@ static void list_slab_objects(struct kme
 
 	get_map(s, page, map);
 	for_each_object(p, s, addr, page->objects) {
-		void *object = fixup_red_left(s, p);
 
 		if (!test_bit(slab_index(p, s, addr), map)) {
-			pr_err("INFO: Object 0x%p @offset=%tu\n",
-					object, object - addr);
-			print_tracking(s, object);
+			pr_err("INFO: Object 0x%p @offset=%tu\n", p, p - addr);
+			print_tracking(s, p);
 		}
 	}
 	slab_unlock(page);
@@ -4148,21 +4129,15 @@ static int validate_slab(struct kmem_cac
 
 	get_map(s, page, map);
 	for_each_object(p, s, addr, page->objects) {
-		void *object = fixup_red_left(s, p);
-
 		if (test_bit(slab_index(p, s, addr), map))
-			if (!check_object(s, page, object, SLUB_RED_INACTIVE))
+			if (!check_object(s, page, p, SLUB_RED_INACTIVE))
 				return 0;
 	}
 
-	for_each_object(p, s, addr, page->objects) {
-		void *object = fixup_red_left(s, p);
-
+	for_each_object(p, s, addr, page->objects)
 		if (!test_bit(slab_index(p, s, addr), map))
-			if (!check_object(s, page, object, SLUB_RED_ACTIVE))
+			if (!check_object(s, page, p, SLUB_RED_ACTIVE))
 				return 0;
-	}
-
 	return 1;
 }
 
@@ -4360,12 +4335,9 @@ static void process_slab(struct loc_trac
 	bitmap_zero(map, page->objects);
 	get_map(s, page, map);
 
-	for_each_object(p, s, addr, page->objects) {
-		void *object = fixup_red_left(s, p);
-
+	for_each_object(p, s, addr, page->objects)
 		if (!test_bit(slab_index(p, s, addr), map))
-			add_location(t, s, get_track(s, object, alloc));
-	}
+			add_location(t, s, get_track(s, p, alloc));
 }
 
 static int list_locations(struct kmem_cache *s, char *buf,
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

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
mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix.patch
mm-slab-avoid-returning-values-by-reference.patch
mm-slab-re-implement-pfmemalloc-support.patch
mm-slab-re-implement-pfmemalloc-support-v2.patch
mm-slub-support-left-red-zone.patch
mm-slub-support-left-red-zone-fix.patch
mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch

