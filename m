From: akpm@linux-foundation.org
Subject: + slub-fix-object-tracking.patch added to -mm tree
Date: Mon, 09 Apr 2007 22:30:20 -0700
Message-ID: <200704100530.l3A5UKAg032308@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44851 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966098AbXDJFaY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 01:30:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slub: fix object tracking
has been added to the -mm tree.  Its filename is
     slub-fix-object-tracking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 20 insertions(+), 37 deletions(-)

diff -puN mm/slub.c~slub-fix-object-tracking mm/slub.c
--- a/mm/slub.c~slub-fix-object-tracking
+++ a/mm/slub.c
@@ -246,9 +246,6 @@ static void set_track(struct kmem_cache 
 		memset(p, 0, sizeof(struct track));
 }
 
-#define set_tracking(__s, __o, __a) set_track(__s, __o, __a, \
-			__builtin_return_address(0))
-
 static void init_tracking(struct kmem_cache *s, void *object)
 {
 	if (s->flags & SLAB_STORE_USER) {
@@ -1107,8 +1104,8 @@ static void flush_all(struct kmem_cache 
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
@@ -1189,20 +1186,20 @@ debug:
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
@@ -1213,7 +1210,8 @@ EXPORT_SYMBOL(kmem_cache_alloc_node);
  *
  * No special cachelines need to be read
  */
-static void slab_free(struct kmem_cache *s, struct page *page, void *x)
+static void slab_free(struct kmem_cache *s, struct page *page,
+					void *x, void *addr)
 {
 	void *prior;
 	void **object = (void *)x;
@@ -1265,20 +1263,20 @@ slab_empty:
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
 
@@ -1836,7 +1834,7 @@ void *__kmalloc(size_t size, gfp_t flags
 	struct kmem_cache *s = get_slab(size, flags);
 
 	if (s)
-		return kmem_cache_alloc(s, flags);
+		return slab_alloc(s, flags, -1, __builtin_return_address(0));
 	return NULL;
 }
 EXPORT_SYMBOL(__kmalloc);
@@ -1847,7 +1845,7 @@ void *__kmalloc_node(size_t size, gfp_t 
 	struct kmem_cache *s = get_slab(size, flags);
 
 	if (s)
-		return kmem_cache_alloc_node(s, flags, node);
+		return slab_alloc(s, flags, node, __builtin_return_address(0));
 	return NULL;
 }
 EXPORT_SYMBOL(__kmalloc_node);
@@ -1893,12 +1891,9 @@ void kfree(const void *x)
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
 
@@ -2098,7 +2093,7 @@ void *kmem_cache_zalloc(struct kmem_cach
 {
 	void *x;
 
-	x = kmem_cache_alloc(s, flags);
+	x = slab_alloc(s, flags, -1, __builtin_return_address(0));
 	if (x)
 		memset(x, 0, s->objsize);
 	return x;
@@ -2249,34 +2244,22 @@ __initcall(cpucache_init);
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

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-core-minor-fixes.patch
slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
slub-add-slabinfo-tool.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
fix-another-numa-bootstrap-issue.patch
update-slabinfoc.patch
quicklists-for-page-table-pages.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
