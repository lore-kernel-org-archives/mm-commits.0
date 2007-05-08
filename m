From: akpm@linux-foundation.org
Subject: + slub-introduce-debugslabpage.patch added to -mm tree
Date: Tue, 08 May 2007 14:48:57 -0700
Message-ID: <200705082148.l48Lmvnj002630@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031546AbXEHVtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:49:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: introduce DebugSlab(page)
has been added to the -mm tree.  Its filename is
     slub-introduce-debugslabpage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 28 insertions(+), 12 deletions(-)

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
@@ -818,7 +833,7 @@ static struct page *allocate_slab(struct
 static void setup_object(struct kmem_cache *s, struct page *page,
 				void *object)
 {
-	if (PageError(page)) {
+	if (SlabDebug(page)) {
 		init_object(s, object, 0);
 		init_tracking(s, object);
 	}
@@ -853,7 +868,7 @@ static struct page *new_slab(struct kmem
 	page->flags |= 1 << PG_slab;
 	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
 			SLAB_STORE_USER | SLAB_TRACE))
-		page->flags |= 1 << PG_error;
+		SetSlabDebug(page);
 
 	start = page_address(page);
 	end = start + s->objects * s->size;
@@ -882,7 +897,7 @@ static void __free_slab(struct kmem_cach
 {
 	int pages = 1 << s->order;
 
-	if (unlikely(PageError(page) || s->dtor)) {
+	if (unlikely(SlabDebug(page) || s->dtor)) {
 		void *p;
 
 		slab_pad_check(s, page);
@@ -929,7 +944,8 @@ static void discard_slab(struct kmem_cac
 
 	atomic_long_dec(&n->nr_slabs);
 	reset_page_mapcount(page);
-	page->flags &= ~(1 << PG_slab | 1 << PG_error);
+	ClearSlabDebug(page);
+	__ClearPageSlab(page);
 	free_slab(s, page);
 }
 
@@ -1104,7 +1120,7 @@ static void putback_slab(struct kmem_cac
 
 		if (page->freelist)
 			add_partial(n, page);
-		else if (PageError(page) && (s->flags & SLAB_STORE_USER))
+		else if (SlabDebug(page) && (s->flags & SLAB_STORE_USER))
 			add_full(n, page);
 		slab_unlock(page);
 
@@ -1188,7 +1204,7 @@ static void flush_all(struct kmem_cache 
  * per cpu array in the kmem_cache struct.
  *
  * Fastpath is not possible if we need to get a new slab or have
- * debugging enabled (which means all slabs are marked with PageError)
+ * debugging enabled (which means all slabs are marked with SlabDebug)
  */
 static void *slab_alloc(struct kmem_cache *s,
 				gfp_t gfpflags, int node, void *addr)
@@ -1211,7 +1227,7 @@ redo:
 	object = page->freelist;
 	if (unlikely(!object))
 		goto another_slab;
-	if (unlikely(PageError(page)))
+	if (unlikely(SlabDebug(page)))
 		goto debug;
 
 have_object:
@@ -1309,7 +1325,7 @@ static void slab_free(struct kmem_cache 
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
