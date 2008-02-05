From: akpm@linux-foundation.org
Subject: - slub-provide-unique-end-marker-for-each-slab.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:45:24 -0800
Message-ID: <200802050245.m152j5jZ031156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60974 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265AbYBECpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:45:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     SLUB: provide unique end marker for each slab
has been removed from the -mm tree.  Its filename was
     slub-provide-unique-end-marker-for-each-slab.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SLUB: provide unique end marker for each slab
From: Christoph Lameter <clameter@sgi.com>

Currently we use the NULL pointer to signal that there are no more objects. 
However the NULL pointers of all slabs match in contrast to the pointers to
the real objects which are distinct for each slab page.

Change the end pointer to be simply a pointer to the first object with bit 0
set.  That way all end pointers are different for each slab.  This is
necessary to allow reliable end marker identification for the next patch that
implements a fast path without the need to disable interrupts.

Bring back the use of the mapping field by SLUB since we would otherwise have
to call a relatively expensive function page_address() in __slab_alloc().  Use
of the mapping field allows avoiding calling page_address() in various other
functions as well.

There is no need to change the page_mapping() function since bit 0 is set on
the mapping as also for anonymous pages.  page_mapping(slab_page) will
therefore still return NULL although the mapping field is overloaded.

[akpm@linux-foundation.org: unbreak indenting]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    5 ++
 mm/slub.c                |   70 ++++++++++++++++++++++++-------------
 2 files changed, 51 insertions(+), 24 deletions(-)

diff -puN include/linux/mm_types.h~slub-provide-unique-end-marker-for-each-slab include/linux/mm_types.h
--- a/include/linux/mm_types.h~slub-provide-unique-end-marker-for-each-slab
+++ a/include/linux/mm_types.h
@@ -64,7 +64,10 @@ struct page {
 #if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
 	    spinlock_t ptl;
 #endif
-	    struct kmem_cache *slab;	/* SLUB: Pointer to slab */
+	    struct {
+		   struct kmem_cache *slab;	/* SLUB: Pointer to slab */
+		   void *end;			/* SLUB: end marker */
+	    };
 	    struct page *first_page;	/* Compound tail pages */
 	};
 	union {
diff -puN mm/slub.c~slub-provide-unique-end-marker-for-each-slab mm/slub.c
--- a/mm/slub.c~slub-provide-unique-end-marker-for-each-slab
+++ a/mm/slub.c
@@ -277,15 +277,32 @@ static inline struct kmem_cache_cpu *get
 #endif
 }
 
+/*
+ * The end pointer in a slab is special. It points to the first object in the
+ * slab but has bit 0 set to mark it.
+ *
+ * Note that SLUB relies on page_mapping returning NULL for pages with bit 0
+ * in the mapping set.
+ */
+static inline int is_end(void *addr)
+{
+	return (unsigned long)addr & PAGE_MAPPING_ANON;
+}
+
+void *slab_address(struct page *page)
+{
+	return page->end - PAGE_MAPPING_ANON;
+}
+
 static inline int check_valid_pointer(struct kmem_cache *s,
 				struct page *page, const void *object)
 {
 	void *base;
 
-	if (!object)
+	if (object == page->end)
 		return 1;
 
-	base = page_address(page);
+	base = slab_address(page);
 	if (object < base || object >= base + s->objects * s->size ||
 		(object - base) % s->size) {
 		return 0;
@@ -318,7 +335,8 @@ static inline void set_freepointer(struc
 
 /* Scan freelist */
 #define for_each_free_object(__p, __s, __free) \
-	for (__p = (__free); __p; __p = get_freepointer((__s), __p))
+	for (__p = (__free); (__p) != page->end; __p = get_freepointer((__s),\
+		__p))
 
 /* Determine object index from a given position */
 static inline int slab_index(void *p, struct kmem_cache *s, void *addr)
@@ -470,7 +488,7 @@ static void slab_fix(struct kmem_cache *
 static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 {
 	unsigned int off;	/* Offset of last byte */
-	u8 *addr = page_address(page);
+	u8 *addr = slab_address(page);
 
 	print_tracking(s, p);
 
@@ -648,7 +666,7 @@ static int slab_pad_check(struct kmem_ca
 	if (!(s->flags & SLAB_POISON))
 		return 1;
 
-	start = page_address(page);
+	start = slab_address(page);
 	end = start + (PAGE_SIZE << s->order);
 	length = s->objects * s->size;
 	remainder = end - (start + length);
@@ -715,7 +733,7 @@ static int check_object(struct kmem_cach
 		 * of the free objects in this slab. May cause
 		 * another error because the object count is now wrong.
 		 */
-		set_freepointer(s, p, NULL);
+		set_freepointer(s, p, page->end);
 		return 0;
 	}
 	return 1;
@@ -749,18 +767,18 @@ static int on_freelist(struct kmem_cache
 	void *fp = page->freelist;
 	void *object = NULL;
 
-	while (fp && nr <= s->objects) {
+	while (fp != page->end && nr <= s->objects) {
 		if (fp == search)
 			return 1;
 		if (!check_valid_pointer(s, page, fp)) {
 			if (object) {
 				object_err(s, page, object,
 					"Freechain corrupt");
-				set_freepointer(s, object, NULL);
+				set_freepointer(s, object, page->end);
 				break;
 			} else {
 				slab_err(s, page, "Freepointer corrupt");
-				page->freelist = NULL;
+				page->freelist = page->end;
 				page->inuse = s->objects;
 				slab_fix(s, "Freelist cleared");
 				return 0;
@@ -870,7 +888,7 @@ bad:
 		 */
 		slab_fix(s, "Marking all objects used");
 		page->inuse = s->objects;
-		page->freelist = NULL;
+		page->freelist = page->end;
 	}
 	return 0;
 }
@@ -911,7 +929,7 @@ static noinline int free_debug_processin
 	}
 
 	/* Special debug activities for freeing objects */
-	if (!SlabFrozen(page) && !page->freelist)
+	if (!SlabFrozen(page) && page->freelist == page->end)
 		remove_full(s, page);
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, object, TRACK_FREE, addr);
@@ -1104,6 +1122,7 @@ static noinline struct page *new_slab(st
 		SetSlabDebug(page);
 
 	start = page_address(page);
+	page->end = start + 1;
 
 	if (unlikely(s->flags & SLAB_POISON))
 		memset(start, POISON_INUSE, PAGE_SIZE << s->order);
@@ -1115,7 +1134,7 @@ static noinline struct page *new_slab(st
 		last = p;
 	}
 	setup_object(s, page, last);
-	set_freepointer(s, last, NULL);
+	set_freepointer(s, last, page->end);
 
 	page->freelist = start;
 	page->inuse = 0;
@@ -1131,7 +1150,7 @@ static void __free_slab(struct kmem_cach
 		void *p;
 
 		slab_pad_check(s, page);
-		for_each_object(p, s, page_address(page))
+		for_each_object(p, s, slab_address(page))
 			check_object(s, page, p, 0);
 		ClearSlabDebug(page);
 	}
@@ -1141,6 +1160,7 @@ static void __free_slab(struct kmem_cach
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		-pages);
 
+	page->mapping = NULL;
 	__free_pages(page, s->order);
 }
 
@@ -1343,7 +1363,7 @@ static void unfreeze_slab(struct kmem_ca
 	ClearSlabFrozen(page);
 	if (page->inuse) {
 
-		if (page->freelist)
+		if (page->freelist != page->end)
 			add_partial(s, page, tail);
 		else
 			add_full(s, page);
@@ -1380,8 +1400,12 @@ static void deactivate_slab(struct kmem_
 	 * Merge cpu freelist into freelist. Typically we get here
 	 * because both freelists are empty. So this is unlikely
 	 * to occur.
+	 *
+	 * We need to use _is_end here because deactivate slab may
+	 * be called for a debug slab. Then c->freelist may contain
+	 * a dummy pointer.
 	 */
-	while (unlikely(c->freelist)) {
+	while (unlikely(!is_end(c->freelist))) {
 		void **object;
 
 		tail = 0;	/* Hot objects. Put the slab first */
@@ -1481,7 +1505,7 @@ static void *__slab_alloc(struct kmem_ca
 		goto another_slab;
 load_freelist:
 	object = c->page->freelist;
-	if (unlikely(!object))
+	if (unlikely(object == c->page->end))
 		goto another_slab;
 	if (unlikely(SlabDebug(c->page)))
 		goto debug;
@@ -1489,7 +1513,7 @@ load_freelist:
 	object = c->page->freelist;
 	c->freelist = object[c->offset];
 	c->page->inuse = s->objects;
-	c->page->freelist = NULL;
+	c->page->freelist = c->page->end;
 	c->node = page_to_nid(c->page);
 unlock_out:
 	slab_unlock(c->page);
@@ -1555,7 +1579,7 @@ static __always_inline void *slab_alloc(
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(!c->freelist || !node_match(c, node))) {
+	if (unlikely((is_end(c->freelist)) || !node_match(c, node))) {
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 		if (unlikely(!object)) {
@@ -1622,7 +1646,7 @@ checks_ok:
 	 * was not on the partial list before
 	 * then add it.
 	 */
-	if (unlikely(!prior))
+	if (unlikely(prior == page->end))
 		add_partial(s, page, 1);
 
 out_unlock:
@@ -1630,7 +1654,7 @@ out_unlock:
 	return;
 
 slab_empty:
-	if (prior)
+	if (prior != page->end)
 		/*
 		 * Slab still on the partial list.
 		 */
@@ -1850,7 +1874,7 @@ static void init_kmem_cache_cpu(struct k
 			struct kmem_cache_cpu *c)
 {
 	c->page = NULL;
-	c->freelist = NULL;
+	c->freelist = (void *)PAGE_MAPPING_ANON;
 	c->node = 0;
 	c->offset = s->offset / sizeof(void *);
 	c->objsize = s->objsize;
@@ -3113,7 +3137,7 @@ static int validate_slab(struct kmem_cac
 						unsigned long *map)
 {
 	void *p;
-	void *addr = page_address(page);
+	void *addr = slab_address(page);
 
 	if (!check_slab(s, page) ||
 			!on_freelist(s, page, NULL))
@@ -3393,7 +3417,7 @@ static int add_location(struct loc_track
 static void process_slab(struct loc_track *t, struct kmem_cache *s,
 		struct page *page, enum track_item alloc)
 {
-	void *addr = page_address(page);
+	void *addr = slab_address(page);
 	DECLARE_BITMAP(map, s->objects);
 	void *p;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
slub-fix-sysfs-refcounting.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
vmstat-remove-prefetch.patch
set_page_refcounted-vm_bug_on-fix.patch
page-migraton-handle-orphaned-pages.patch
mm-fix-section-mismatch-warning-in-sparsec.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
git-newsetup.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
