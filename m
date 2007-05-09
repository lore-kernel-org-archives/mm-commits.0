From: akpm@linux-foundation.org
Subject: - slub-add-macros-for-scanning-objects-in-a-slab.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:01 -0700
Message-ID: <200705092148.l49Lm1vS002536@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755308AbXEIVsE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: add macros for scanning objects in a slab
has been removed from the -mm tree.  Its filename was
     slub-add-macros-for-scanning-objects-in-a-slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: add macros for scanning objects in a slab
From: Christoph Lameter <clameter@sgi.com>

Scanning of objects happens in a number of functions.  Consolidate that code. 
DECLARE_BITMAP instead of coding the declaration for bitmaps.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   75 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff -puN mm/slub.c~slub-add-macros-for-scanning-objects-in-a-slab mm/slub.c
--- a/mm/slub.c~slub-add-macros-for-scanning-objects-in-a-slab
+++ a/mm/slub.c
@@ -209,6 +209,38 @@ static inline struct kmem_cache_node *ge
 }
 
 /*
+ * Slow version of get and set free pointer.
+ *
+ * This version requires touching the cache lines of kmem_cache which
+ * we avoid to do in the fast alloc free paths. There we obtain the offset
+ * from the page struct.
+ */
+static inline void *get_freepointer(struct kmem_cache *s, void *object)
+{
+	return *(void **)(object + s->offset);
+}
+
+static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
+{
+	*(void **)(object + s->offset) = fp;
+}
+
+/* Loop over all objects in a slab */
+#define for_each_object(__p, __s, __addr) \
+	for (__p = (__addr); __p < (__addr) + (__s)->objects * (__s)->size;\
+			__p += (__s)->size)
+
+/* Scan freelist */
+#define for_each_free_object(__p, __s, __free) \
+	for (__p = (__free); __p; __p = get_freepointer((__s), __p))
+
+/* Determine object index from a given position */
+static inline int slab_index(void *p, struct kmem_cache *s, void *addr)
+{
+	return (p - addr) / s->size;
+}
+
+/*
  * Object debugging
  */
 static void print_section(char *text, u8 *addr, unsigned int length)
@@ -244,23 +276,6 @@ static void print_section(char *text, u8
 }
 
 /*
- * Slow version of get and set free pointer.
- *
- * This version requires touching the cache lines of kmem_cache which
- * we avoid to do in the fast alloc free paths. There we obtain the offset
- * from the page struct.
- */
-static void *get_freepointer(struct kmem_cache *s, void *object)
-{
-	return *(void **)(object + s->offset);
-}
-
-static void set_freepointer(struct kmem_cache *s, void *object, void *fp)
-{
-	*(void **)(object + s->offset) = fp;
-}
-
-/*
  * Tracking user of a slab.
  */
 struct track {
@@ -852,7 +867,7 @@ static struct page *new_slab(struct kmem
 		memset(start, POISON_INUSE, PAGE_SIZE << s->order);
 
 	last = start;
-	for (p = start + s->size; p < end; p += s->size) {
+	for_each_object(p, s, start) {
 		setup_object(s, page, last);
 		set_freepointer(s, last, p);
 		last = p;
@@ -873,12 +888,10 @@ static void __free_slab(struct kmem_cach
 	int pages = 1 << s->order;
 
 	if (unlikely(PageError(page) || s->dtor)) {
-		void *start = page_address(page);
-		void *end = start + (pages << PAGE_SHIFT);
 		void *p;
 
 		slab_pad_check(s, page);
-		for (p = start; p <= end - s->size; p += s->size) {
+		for_each_object(p, s, page_address(page)) {
 			if (s->dtor)
 				s->dtor(p, s, 0);
 			check_object(s, page, p, 0);
@@ -2583,7 +2596,7 @@ static int validate_slab(struct kmem_cac
 {
 	void *p;
 	void *addr = page_address(page);
-	unsigned long map[BITS_TO_LONGS(s->objects)];
+	DECLARE_BITMAP(map, s->objects);
 
 	if (!check_slab(s, page) ||
 			!on_freelist(s, page, NULL))
@@ -2592,14 +2605,14 @@ static int validate_slab(struct kmem_cac
 	/* Now we know that a valid freelist exists */
 	bitmap_zero(map, s->objects);
 
-	for(p = page->freelist; p; p = get_freepointer(s, p)) {
-		set_bit((p - addr) / s->size, map);
+	for_each_free_object(p, s, page->freelist) {
+		set_bit(slab_index(p, s, addr), map);
 		if (!check_object(s, page, p, 0))
 			return 0;
 	}
 
-	for(p = addr; p < addr + s->objects * s->size; p += s->size)
-		if (!test_bit((p - addr) / s->size, map))
+	for_each_object(p, s, addr)
+		if (!test_bit(slab_index(p, s, addr), map))
 			if (!check_object(s, page, p, 1))
 				return 0;
 	return 1;
@@ -2771,15 +2784,15 @@ static void process_slab(struct loc_trac
 		struct page *page, enum track_item alloc)
 {
 	void *addr = page_address(page);
-	unsigned long map[BITS_TO_LONGS(s->objects)];
+	DECLARE_BITMAP(map, s->objects);
 	void *p;
 
 	bitmap_zero(map, s->objects);
-	for (p = page->freelist; p; p = get_freepointer(s, p))
-		set_bit((p - addr) / s->size, map);
+	for_each_free_object(p, s, page->freelist)
+		set_bit(slab_index(p, s, addr), map);
 
-	for (p = addr; p < addr + s->objects * s->size; p += s->size)
-		if (!test_bit((p - addr) / s->size, map)) {
+	for_each_object(p, s, addr)
+		if (!test_bit(slab_index(p, s, addr), map)) {
 			void *addr = get_track(s, p, alloc)->addr;
 
 			add_location(t, s, addr);
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
