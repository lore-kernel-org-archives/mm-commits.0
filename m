From: akpm@linux-foundation.org
Subject: + slub-add-macros-for-scanning-objects-in-a-slab.patch added to -mm tree
Date: Tue, 08 May 2007 14:48:53 -0700
Message-ID: <200705082148.l48Lmrt1002623@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968350AbXEHVs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:48:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: add macros for scanning objects in a slab
has been added to the -mm tree.  Its filename is
     slub-add-macros-for-scanning-objects-in-a-slab.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: add macros for scanning objects in a slab
From: Christoph Lameter <clameter@sgi.com>

Scanning of objects happens in a number of functions.  Consolidate that code. 
DECLARE_BITMAP instead of coding the declaration for bitmaps.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   75 ++++++++++++++++++++++++++++++----------------------
 1 files changed, 44 insertions(+), 31 deletions(-)

diff -puN mm/slub.c~slub-add-macros-for-scanning-objects-in-a-slab mm/slub.c
--- a/mm/slub.c~slub-add-macros-for-scanning-objects-in-a-slab
+++ a/mm/slub.c
@@ -204,6 +204,38 @@ static inline struct kmem_cache_node *ge
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
@@ -239,23 +271,6 @@ static void print_section(char *text, u8
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
@@ -847,7 +862,7 @@ static struct page *new_slab(struct kmem
 		memset(start, POISON_INUSE, PAGE_SIZE << s->order);
 
 	last = start;
-	for (p = start + s->size; p < end; p += s->size) {
+	for_each_object(p, s, start) {
 		setup_object(s, page, last);
 		set_freepointer(s, last, p);
 		last = p;
@@ -868,12 +883,10 @@ static void __free_slab(struct kmem_cach
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
slub-add-support-for-dynamic-cacheline-size-determination.patch
slub-add-support-for-dynamic-cacheline-size-determination-fix.patch
slub-after-object-padding-only-needed-for-redzoning.patch
slub-slabinfo-upgrade.patch
slub-use-check_valid_pointer-in-kmem_ptr_validate.patch
slub-clean-up-krealloc.patch
slub-clean-up-krealloc-fix.patch
slub-get-rid-of-finish_bootstrap.patch
slub-update-comments.patch
slub-add-macros-for-scanning-objects-in-a-slab.patch
slub-move-resiliency-check-into-sysfs-section.patch
slub-introduce-debugslabpage.patch
slub-consolidate-trace-code.patch
slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code.patch
slub-add-config_slub_debug.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output-fix.patch
slub-rework-slab-order-determination.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
vmstat-use-our-own-timer-events-fix.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
move-remote-node-draining-out-of-slab-allocators.patch
