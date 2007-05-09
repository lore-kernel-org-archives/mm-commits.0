From: akpm@linux-foundation.org
Subject: - slub-introduce-debugslabpage.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:05 -0700
Message-ID: <200705092148.l49Lm51T002542@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756499AbXEIVsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: introduce DebugSlab(page)
has been removed from the -mm tree.  Its filename was
     slub-introduce-debugslabpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: introduce DebugSlab(page)
From: Christoph Lameter <clameter@sgi.com>

This replaces the PageError() checking.  DebugSlab is clearer and allows for
future changes to the page bit used.  We also need it to support
CONFIG_SLUB_DEBUG.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff -puN mm/slub.c~slub-introduce-debugslabpage mm/slub.c
--- a/mm/slub.c~slub-introduce-debugslabpage
+++ a/mm/slub.c
@@ -87,6 +87,21 @@
  * 			the fast path.
  */
 
+static inline int SlabDebug(struct page *page)
+{
+	return PageError(page);
+}
+
+static inline void SetSlabDebug(struct page *page)
+{
+	SetPageError(page);
+}
+
+static inline void ClearSlabDebug(struct page *page)
+{
+	ClearPageError(page);
+}
+
 /*
  * Issues still to be resolved:
  *
@@ -823,7 +838,7 @@ static struct page *allocate_slab(struct
 static void setup_object(struct kmem_cache *s, struct page *page,
 				void *object)
 {
-	if (PageError(page)) {
+	if (SlabDebug(page)) {
 		init_object(s, object, 0);
 		init_tracking(s, object);
 	}
@@ -858,7 +873,7 @@ static struct page *new_slab(struct kmem
 	page->flags |= 1 << PG_slab;
 	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
 			SLAB_STORE_USER | SLAB_TRACE))
-		page->flags |= 1 << PG_error;
+		SetSlabDebug(page);
 
 	start = page_address(page);
 	end = start + s->objects * s->size;
@@ -887,7 +902,7 @@ static void __free_slab(struct kmem_cach
 {
 	int pages = 1 << s->order;
 
-	if (unlikely(PageError(page) || s->dtor)) {
+	if (unlikely(SlabDebug(page) || s->dtor)) {
 		void *p;
 
 		slab_pad_check(s, page);
@@ -934,7 +949,8 @@ static void discard_slab(struct kmem_cac
 
 	atomic_long_dec(&n->nr_slabs);
 	reset_page_mapcount(page);
-	page->flags &= ~(1 << PG_slab | 1 << PG_error);
+	ClearSlabDebug(page);
+	__ClearPageSlab(page);
 	free_slab(s, page);
 }
 
@@ -1109,7 +1125,7 @@ static void putback_slab(struct kmem_cac
 
 		if (page->freelist)
 			add_partial(n, page);
-		else if (PageError(page) && (s->flags & SLAB_STORE_USER))
+		else if (SlabDebug(page) && (s->flags & SLAB_STORE_USER))
 			add_full(n, page);
 		slab_unlock(page);
 
@@ -1193,7 +1209,7 @@ static void flush_all(struct kmem_cache 
  * per cpu array in the kmem_cache struct.
  *
  * Fastpath is not possible if we need to get a new slab or have
- * debugging enabled (which means all slabs are marked with PageError)
+ * debugging enabled (which means all slabs are marked with SlabDebug)
  */
 static void *slab_alloc(struct kmem_cache *s,
 				gfp_t gfpflags, int node, void *addr)
@@ -1216,7 +1232,7 @@ redo:
 	object = page->freelist;
 	if (unlikely(!object))
 		goto another_slab;
-	if (unlikely(PageError(page)))
+	if (unlikely(SlabDebug(page)))
 		goto debug;
 
 have_object:
@@ -1314,7 +1330,7 @@ static void slab_free(struct kmem_cache 
 	local_irq_save(flags);
 	slab_lock(page);
 
-	if (unlikely(PageError(page)))
+	if (unlikely(SlabDebug(page)))
 		goto debug;
 checks_ok:
 	prior = object[page->offset] = page->freelist;
@@ -2571,12 +2587,12 @@ static void validate_slab_slab(struct km
 			s->name, page);
 
 	if (s->flags & DEBUG_DEFAULT_FLAGS) {
-		if (!PageError(page))
-			printk(KERN_ERR "SLUB %s: PageError not set "
+		if (!SlabDebug(page))
+			printk(KERN_ERR "SLUB %s: SlabDebug not set "
 				"on slab 0x%p\n", s->name, page);
 	} else {
-		if (PageError(page))
-			printk(KERN_ERR "SLUB %s: PageError set on "
+		if (SlabDebug(page))
+			printk(KERN_ERR "SLUB %s: SlabDebug set on "
 				"slab 0x%p\n", s->name, page);
 	}
 }
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
