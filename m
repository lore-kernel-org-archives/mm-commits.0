From: akpm@linux-foundation.org
Subject: + slub-provide-unique-end-marker-for-each-slab.patch added to -mm tree
Date: Tue, 30 Oct 2007 11:35:51 -0700
Message-ID: <200710301835.l9UIZpQm021641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbXJ3Sf6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:35:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     SLUB: provide unique end marker for each slab
has been added to the -mm tree.  Its filename is
     slub-provide-unique-end-marker-for-each-slab.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: provide unique end marker for each slab
From: Christoph Lameter <clameter@sgi.com>

Currently we use the NULL pointer to signal that there are no more objects. 
However the NULL pointers of all slabs match in contrast to the pointers to
the real objects which are distinctive for each slab page.

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

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    5 ++
 mm/slub.c                |   72 ++++++++++++++++++++++++-------------
 2 files changed, 51 insertions(+), 26 deletions(-)

diff -puN include/linux/mm_types.h~slub-provide-unique-end-marker-for-each-slab include/linux/mm_types.h
--- a/include/linux/mm_types.h~slub-provide-unique-end-marker-for-each-slab
+++ a/include/linux/mm_types.h
@@ -64,7 +64,10 @@ struct page {
 #if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
 	    spinlock_t ptl;
 #endif
-	    struct kmem_cache *slab;	/* SLUB: Pointer to slab */
+		struct {
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
@@ -1084,7 +1102,6 @@ static noinline struct page *new_slab(st
 	struct page *page;
 	struct kmem_cache_node *n;
 	void *start;
-	void *end;
 	void *last;
 	void *p;
 
@@ -1105,7 +1122,7 @@ static noinline struct page *new_slab(st
 		SetSlabDebug(page);
 
 	start = page_address(page);
-	end = start + s->objects * s->size;
+	page->end = start + 1;
 
 	if (unlikely(s->flags & SLAB_POISON))
 		memset(start, POISON_INUSE, PAGE_SIZE << s->order);
@@ -1117,7 +1134,7 @@ static noinline struct page *new_slab(st
 		last = p;
 	}
 	setup_object(s, page, last);
-	set_freepointer(s, last, NULL);
+	set_freepointer(s, last, page->end);
 
 	page->freelist = start;
 	page->inuse = 0;
@@ -1133,7 +1150,7 @@ static void __free_slab(struct kmem_cach
 		void *p;
 
 		slab_pad_check(s, page);
-		for_each_object(p, s, page_address(page))
+		for_each_object(p, s, slab_address(page))
 			check_object(s, page, p, 0);
 		ClearSlabDebug(page);
 	}
@@ -1143,6 +1160,7 @@ static void __free_slab(struct kmem_cach
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		-pages);
 
+	page->mapping = NULL;
 	__free_pages(page, s->order);
 }
 
@@ -1345,7 +1363,7 @@ static void unfreeze_slab(struct kmem_ca
 	ClearSlabFrozen(page);
 	if (page->inuse) {
 
-		if (page->freelist)
+		if (page->freelist != page->end)
 			add_partial(s, page, tail);
 		else
 			add_full(s, page);
@@ -1382,8 +1400,12 @@ static void deactivate_slab(struct kmem_
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
@@ -1483,7 +1505,7 @@ static void *__slab_alloc(struct kmem_ca
 		goto another_slab;
 load_freelist:
 	object = c->page->freelist;
-	if (unlikely(!object))
+	if (unlikely(object == c->page->end))
 		goto another_slab;
 	if (unlikely(SlabDebug(c->page)))
 		goto debug;
@@ -1491,7 +1513,7 @@ load_freelist:
 	object = c->page->freelist;
 	c->freelist = object[c->offset];
 	c->page->inuse = s->objects;
-	c->page->freelist = NULL;
+	c->page->freelist = c->page->end;
 	c->node = page_to_nid(c->page);
 unlock_out:
 	slab_unlock(c->page);
@@ -1575,7 +1597,7 @@ static __always_inline void *slab_alloc(
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(!c->freelist || !node_match(c, node))) {
+	if (unlikely((is_end(c->freelist)) || !node_match(c, node))) {
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 		if (unlikely(!object)) {
@@ -1642,7 +1664,7 @@ checks_ok:
 	 * was not on the partial list before
 	 * then add it.
 	 */
-	if (unlikely(!prior))
+	if (unlikely(prior == page->end))
 		add_partial(s, page, 0);
 
 out_unlock:
@@ -1650,7 +1672,7 @@ out_unlock:
 	return;
 
 slab_empty:
-	if (prior)
+	if (prior != page->end)
 		/*
 		 * Slab still on the partial list.
 		 */
@@ -1870,7 +1892,7 @@ static void init_kmem_cache_cpu(struct k
 			struct kmem_cache_cpu *c)
 {
 	c->page = NULL;
-	c->freelist = NULL;
+	c->freelist = (void *)PAGE_MAPPING_ANON;
 	c->node = 0;
 	c->offset = s->offset / sizeof(void *);
 	c->objsize = s->objsize;
@@ -3121,7 +3143,7 @@ static int validate_slab(struct kmem_cac
 						unsigned long *map)
 {
 	void *p;
-	void *addr = page_address(page);
+	void *addr = slab_address(page);
 
 	if (!check_slab(s, page) ||
 			!on_freelist(s, page, NULL))
@@ -3401,7 +3423,7 @@ static int add_location(struct loc_track
 static void process_slab(struct loc_track *t, struct kmem_cache *s,
 		struct page *page, enum track_item alloc)
 {
-	void *addr = page_address(page);
+	void *addr = slab_address(page);
 	DECLARE_BITMAP(map, s->objects);
 	void *p;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

ia64-slim-down-__clear_bit_unlock.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
git-unionfs.patch
git-x86.patch
fix-mm-utilckrealloc.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-use-non-atomic-bit-unlock.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-restructure-slab-alloc.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
