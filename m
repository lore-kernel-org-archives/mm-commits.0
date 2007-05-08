From: akpm@linux-foundation.org
Subject: - slub-fix-object-tracking.patch removed from -mm tree
Date: Mon, 07 May 2007 17:08:31 -0700
Message-ID: <200705080008.l4808VCP009386@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967457AbXEHAiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:38:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub: fix object tracking
has been removed from the -mm tree.  Its filename was
     slub-fix-object-tracking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slub: fix object tracking
From: Christoph Lameter <clameter@sgi.com>

Object tracking did not work the right way for several call chains. Fix this up
by adding a new parameter to slub_alloc and slub_free that specifies the
caller address explicitly.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   57 ++++++++++++++++++----------------------------------
 1 files changed, 20 insertions(+), 37 deletions(-)

diff -puN mm/slub.c~slub-fix-object-tracking mm/slub.c
--- a/mm/slub.c~slub-fix-object-tracking
+++ a/mm/slub.c
@@ -297,9 +297,6 @@ static void set_track(struct kmem_cache 
 		memset(p, 0, sizeof(struct track));
 }
 
-#define set_tracking(__s, __o, __a) set_track(__s, __o, __a, \
-			__builtin_return_address(0))
-
 static void init_tracking(struct kmem_cache *s, void *object)
 {
 	if (s->flags & SLAB_STORE_USER) {
@@ -1163,8 +1160,8 @@ static void flush_all(struct kmem_cache 
  * Fastpath is not possible if we need to get a new slab or have
  * debugging enabled (which means all slabs are marked with PageError)
  */
-static __always_inline void *slab_alloc(struct kmem_cache *s,
-					gfp_t gfpflags, int node)
+static void *slab_alloc(struct kmem_cache *s,
+				gfp_t gfpflags, int node, void *addr)
 {
 	struct page *page;
 	void **object;
@@ -1238,20 +1235,20 @@ debug:
 	if (!alloc_object_checks(s, page, object))
 		goto another_slab;
 	if (s->flags & SLAB_STORE_USER)
-		set_tracking(s, object, TRACK_ALLOC);
+		set_track(s, object, TRACK_ALLOC, addr);
 	goto have_object;
 }
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
-	return slab_alloc(s, gfpflags, -1);
+	return slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	return slab_alloc(s, gfpflags, node);
+	return slab_alloc(s, gfpflags, node, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 #endif
@@ -1262,7 +1259,8 @@ EXPORT_SYMBOL(kmem_cache_alloc_node);
  *
  * No special cachelines need to be read
  */
-static void slab_free(struct kmem_cache *s, struct page *page, void *x)
+static void slab_free(struct kmem_cache *s, struct page *page,
+					void *x, void *addr)
 {
 	void *prior;
 	void **object = (void *)x;
@@ -1314,20 +1312,20 @@ slab_empty:
 	return;
 
 debug:
-	if (free_object_checks(s, page, x))
-		goto checks_ok;
-	goto out_unlock;
+	if (!free_object_checks(s, page, x))
+		goto out_unlock;
+	if (s->flags & SLAB_STORE_USER)
+		set_track(s, x, TRACK_FREE, addr);
+	goto checks_ok;
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
 {
-	struct page * page;
+	struct page *page;
 
 	page = virt_to_head_page(x);
 
-	if (unlikely(PageError(page) && (s->flags & SLAB_STORE_USER)))
-		set_tracking(s, x, TRACK_FREE);
-	slab_free(s, page, x);
+	slab_free(s, page, x, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -2018,7 +2016,7 @@ void *__kmalloc(size_t size, gfp_t flags
 	struct kmem_cache *s = get_slab(size, flags);
 
 	if (s)
-		return kmem_cache_alloc(s, flags);
+		return slab_alloc(s, flags, -1, __builtin_return_address(0));
 	return NULL;
 }
 EXPORT_SYMBOL(__kmalloc);
@@ -2029,7 +2027,7 @@ void *__kmalloc_node(size_t size, gfp_t 
 	struct kmem_cache *s = get_slab(size, flags);
 
 	if (s)
-		return kmem_cache_alloc_node(s, flags, node);
+		return slab_alloc(s, flags, node, __builtin_return_address(0));
 	return NULL;
 }
 EXPORT_SYMBOL(__kmalloc_node);
@@ -2075,12 +2073,9 @@ void kfree(const void *x)
 		return;
 
 	page = virt_to_head_page(x);
-
 	s = page->slab;
 
-	if (unlikely(PageError(page) && (s->flags & SLAB_STORE_USER)))
-		set_tracking(s, (void *)x, TRACK_FREE);
-	slab_free(s, page, (void *)x);
+	slab_free(s, page, (void *)x, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(kfree);
 
@@ -2289,7 +2284,7 @@ void *kmem_cache_zalloc(struct kmem_cach
 {
 	void *x;
 
-	x = kmem_cache_alloc(s, flags);
+	x = slab_alloc(s, flags, -1, __builtin_return_address(0));
 	if (x)
 		memset(x, 0, s->objsize);
 	return x;
@@ -2497,34 +2492,22 @@ static void resiliency_test(void) {};
 void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, void *caller)
 {
 	struct kmem_cache *s = get_slab(size, gfpflags);
-	void *object;
 
 	if (!s)
 		return NULL;
 
-	object = kmem_cache_alloc(s, gfpflags);
-
-	if (object && (s->flags & SLAB_STORE_USER))
-		set_track(s, object, TRACK_ALLOC, caller);
-
-	return object;
+	return slab_alloc(s, gfpflags, -1, caller);
 }
 
 void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 					int node, void *caller)
 {
 	struct kmem_cache *s = get_slab(size, gfpflags);
-	void *object;
 
 	if (!s)
 		return NULL;
 
-	object = kmem_cache_alloc_node(s, gfpflags, node);
-
-	if (object && (s->flags & SLAB_STORE_USER))
-		set_track(s, object, TRACK_ALLOC, caller);
-
-	return object;
+	return slab_alloc(s, gfpflags, node, caller);
 }
 
 #ifdef CONFIG_SYSFS
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
