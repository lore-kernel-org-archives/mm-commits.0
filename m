From: akpm@linux-foundation.org
Subject: - slub-simplify-debug-code.patch removed from -mm tree
Date: Fri, 18 May 2007 00:05:45 -0700
Message-ID: <200705180705.l4I75iDh010121@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35830 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755709AbXERHHR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:07:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Simplify debug code
has been removed from the -mm tree.  Its filename was
     slub-simplify-debug-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: Simplify debug code
From: Christoph Lameter <clameter@sgi.com>

Consolidate functionality into the #ifdef section.

Extract tracing into one subroutine.

Move object debug processing into the #ifdef section so that the
code in __slab_alloc and __slab_free becomes minimal.

Reduce number of functions we need to provide stubs for in the !SLUB_DEBUG case.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |  112 ++++++++++++++++++++++++++--------------------------
 1 file changed, 57 insertions(+), 55 deletions(-)

diff -puN mm/slub.c~slub-simplify-debug-code mm/slub.c
--- a/mm/slub.c~slub-simplify-debug-code
+++ a/mm/slub.c
@@ -742,6 +742,22 @@ static int on_freelist(struct kmem_cache
 	return search == NULL;
 }
 
+static void trace(struct kmem_cache *s, struct page *page, void *object, int alloc)
+{
+	if (s->flags & SLAB_TRACE) {
+		printk(KERN_INFO "TRACE %s %s 0x%p inuse=%d fp=0x%p\n",
+			s->name,
+			alloc ? "alloc" : "free",
+			object, page->inuse,
+			page->freelist);
+
+		if (!alloc)
+			print_section("Object", (void *)object, s->objsize);
+
+		dump_stack();
+	}
+}
+
 /*
  * Tracking of fully allocated slabs for debugging purposes.
  */
@@ -766,8 +782,18 @@ static void remove_full(struct kmem_cach
 	spin_unlock(&n->list_lock);
 }
 
-static int alloc_object_checks(struct kmem_cache *s, struct page *page,
-							void *object)
+static void setup_object_debug(struct kmem_cache *s, struct page *page,
+								void *object)
+{
+	if (!(s->flags & (SLAB_STORE_USER|SLAB_RED_ZONE|__OBJECT_POISON)))
+		return;
+
+	init_object(s, object, 0);
+	init_tracking(s, object);
+}
+
+static int alloc_debug_processing(struct kmem_cache *s, struct page *page,
+						void *object, void *addr)
 {
 	if (!check_slab(s, page))
 		goto bad;
@@ -782,13 +808,16 @@ static int alloc_object_checks(struct km
 		goto bad;
 	}
 
-	if (!object)
-		return 1;
-
-	if (!check_object(s, page, object, 0))
+	if (object && !check_object(s, page, object, 0))
 		goto bad;
 
+	/* Success perform special debug activities for allocs */
+	if (s->flags & SLAB_STORE_USER)
+		set_track(s, object, TRACK_ALLOC, addr);
+	trace(s, page, object, 1);
+	init_object(s, object, 1);
 	return 1;
+
 bad:
 	if (PageSlab(page)) {
 		/*
@@ -806,8 +835,8 @@ bad:
 	return 0;
 }
 
-static int free_object_checks(struct kmem_cache *s, struct page *page,
-							void *object)
+static int free_debug_processing(struct kmem_cache *s, struct page *page,
+						void *object, void *addr)
 {
 	if (!check_slab(s, page))
 		goto fail;
@@ -841,29 +870,22 @@ static int free_object_checks(struct kme
 				"to slab %s", object, page->slab->name);
 		goto fail;
 	}
+
+	/* Special debug activities for freeing objects */
+	if (!SlabFrozen(page) && !page->freelist)
+		remove_full(s, page);
+	if (s->flags & SLAB_STORE_USER)
+		set_track(s, object, TRACK_FREE, addr);
+	trace(s, page, object, 0);
+	init_object(s, object, 0);
 	return 1;
+
 fail:
 	printk(KERN_ERR "@@@ SLUB: %s slab 0x%p object at 0x%p not freed.\n",
 		s->name, page, object);
 	return 0;
 }
 
-static void trace(struct kmem_cache *s, struct page *page, void *object, int alloc)
-{
-	if (s->flags & SLAB_TRACE) {
-		printk(KERN_INFO "TRACE %s %s 0x%p inuse=%d fp=0x%p\n",
-			s->name,
-			alloc ? "alloc" : "free",
-			object, page->inuse,
-			page->freelist);
-
-		if (!alloc)
-			print_section("Object", (void *)object, s->objsize);
-
-		dump_stack();
-	}
-}
-
 static int __init setup_slub_debug(char *str)
 {
 	if (!str || *str != '=')
@@ -932,26 +954,20 @@ static void kmem_cache_open_debug_check(
 				s->flags |= slub_debug;
 }
 #else
+static inline void setup_object_debug(struct kmem_cache *s,
+			struct page *page, void *object) {}
 
-static inline int alloc_object_checks(struct kmem_cache *s,
-		struct page *page, void *object) { return 0; }
+static inline int alloc_debug_processing(struct kmem_cache *s,
+	struct page *page, void *object, void *addr) { return 0; }
 
-static inline int free_object_checks(struct kmem_cache *s,
-		struct page *page, void *object) { return 0; }
+static inline int free_debug_processing(struct kmem_cache *s,
+	struct page *page, void *object, void *addr) { return 0; }
 
-static inline void add_full(struct kmem_cache_node *n, struct page *page) {}
-static inline void remove_full(struct kmem_cache *s, struct page *page) {}
-static inline void trace(struct kmem_cache *s, struct page *page,
-			void *object, int alloc) {}
-static inline void init_object(struct kmem_cache *s,
-			void *object, int active) {}
-static inline void init_tracking(struct kmem_cache *s, void *object) {}
 static inline int slab_pad_check(struct kmem_cache *s, struct page *page)
 			{ return 1; }
 static inline int check_object(struct kmem_cache *s, struct page *page,
 			void *object, int active) { return 1; }
-static inline void set_track(struct kmem_cache *s, void *object,
-			enum track_item alloc, void *addr) {}
+static inline void add_full(struct kmem_cache_node *n, struct page *page) {}
 static inline void kmem_cache_open_debug_check(struct kmem_cache *s) {}
 #define slub_debug 0
 #endif
@@ -988,11 +1004,7 @@ static struct page *allocate_slab(struct
 static void setup_object(struct kmem_cache *s, struct page *page,
 				void *object)
 {
-	if (SlabDebug(page)) {
-		init_object(s, object, 0);
-		init_tracking(s, object);
-	}
-
+	setup_object_debug(s, page, object);
 	if (unlikely(s->ctor))
 		s->ctor(object, s, 0);
 }
@@ -1449,12 +1461,8 @@ new_slab:
 	return NULL;
 debug:
 	object = page->freelist;
-	if (!alloc_object_checks(s, page, object))
+	if (!alloc_debug_processing(s, page, object, addr))
 		goto another_slab;
-	if (s->flags & SLAB_STORE_USER)
-		set_track(s, object, TRACK_ALLOC, addr);
-	trace(s, page, object, 1);
-	init_object(s, object, 1);
 
 	page->inuse++;
 	page->freelist = object[page->offset];
@@ -1561,14 +1569,8 @@ slab_empty:
 	return;
 
 debug:
-	if (!free_object_checks(s, page, x))
+	if (!free_debug_processing(s, page, x, addr))
 		goto out_unlock;
-	if (!SlabFrozen(page) && !page->freelist)
-		remove_full(s, page);
-	if (s->flags & SLAB_STORE_USER)
-		set_track(s, x, TRACK_FREE, addr);
-	trace(s, page, object, 0);
-	init_object(s, object, 0);
 	goto checks_ok;
 }
 
@@ -1805,7 +1807,7 @@ static struct kmem_cache_node * __init e
 	page->freelist = get_freepointer(kmalloc_caches, n);
 	page->inuse++;
 	kmalloc_caches->node[node] = n;
-	init_object(kmalloc_caches, n, 1);
+	setup_object_debug(kmalloc_caches, page, n);
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
 	add_partial(n, page);
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-another-slabinfo-fix.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-bio_alloc-allocations-correctly.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-page-cache-pages-as-__gfp_pagecache-instead-of-__gfp_movable.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch
group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
revoke-core-code.patch
