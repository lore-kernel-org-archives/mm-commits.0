From: akpm@linux-foundation.org
Subject: - slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:53:42 -0800
Message-ID: <200802050253.m152rN5k031499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628AbYBECxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:53:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     SLUB: Consolidate add_partial() and add_partial_tail() to one function
has been removed from the -mm tree.  Its filename was
     slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SLUB: Consolidate add_partial() and add_partial_tail() to one function
From: Christoph Lameter <clameter@sgi.com>

Add a parameter to add_partial instead of having separate functions.  The
parameter allows a more detailed control of where the slab pages is placed in
the partial queues.

If we put slabs back to the front then they are likely immediately used for
allocations.  If they are put at the end then we can maximize the time that
the partial slabs spent without being subject to allocations.

When deactivating slab we can put the slabs that had remote objects freed (we
can see that because objects were put on the freelist that requires locks) to
them at the end of the list so that the cachelines of remote processors can
cool down.  Slabs that had objects from the local cpu freed to them (objects
exist in the lockless freelist) are put in the front of the list to be reused
ASAP in order to exploit the cache hot state of the local cpu.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff -puN mm/slub.c~slub-consolidate-add_partial-and-add_partial_tail-to-one-function mm/slub.c
--- a/mm/slub.c~slub-consolidate-add_partial-and-add_partial_tail-to-one-function
+++ a/mm/slub.c
@@ -1195,19 +1195,15 @@ static __always_inline int slab_trylock(
 /*
  * Management of partially allocated slabs
  */
-static void add_partial_tail(struct kmem_cache_node *n, struct page *page)
+static void add_partial(struct kmem_cache_node *n,
+				struct page *page, int tail)
 {
 	spin_lock(&n->list_lock);
 	n->nr_partial++;
-	list_add_tail(&page->lru, &n->partial);
-	spin_unlock(&n->list_lock);
-}
-
-static void add_partial(struct kmem_cache_node *n, struct page *page)
-{
-	spin_lock(&n->list_lock);
-	n->nr_partial++;
-	list_add(&page->lru, &n->partial);
+	if (tail)
+		list_add_tail(&page->lru, &n->partial);
+	else
+		list_add(&page->lru, &n->partial);
 	spin_unlock(&n->list_lock);
 }
 
@@ -1336,7 +1332,7 @@ static struct page *get_partial(struct k
  *
  * On exit the slab lock will have been dropped.
  */
-static void unfreeze_slab(struct kmem_cache *s, struct page *page)
+static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
@@ -1344,7 +1340,7 @@ static void unfreeze_slab(struct kmem_ca
 	if (page->inuse) {
 
 		if (page->freelist)
-			add_partial(n, page);
+			add_partial(n, page, tail);
 		else if (SlabDebug(page) && (s->flags & SLAB_STORE_USER))
 			add_full(n, page);
 		slab_unlock(page);
@@ -1359,7 +1355,7 @@ static void unfreeze_slab(struct kmem_ca
 			 * partial list stays small. kmem_cache_shrink can
 			 * reclaim empty slabs from the partial list.
 			 */
-			add_partial_tail(n, page);
+			add_partial(n, page, 1);
 			slab_unlock(page);
 		} else {
 			slab_unlock(page);
@@ -1374,6 +1370,7 @@ static void unfreeze_slab(struct kmem_ca
 static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
 	struct page *page = c->page;
+	int tail = 1;
 	/*
 	 * Merge cpu freelist into freelist. Typically we get here
 	 * because both freelists are empty. So this is unlikely
@@ -1382,6 +1379,8 @@ static void deactivate_slab(struct kmem_
 	while (unlikely(c->freelist)) {
 		void **object;
 
+		tail = 0;	/* Hot objects. Put the slab first */
+
 		/* Retrieve object from cpu_freelist */
 		object = c->freelist;
 		c->freelist = c->freelist[c->offset];
@@ -1392,7 +1391,7 @@ static void deactivate_slab(struct kmem_
 		page->inuse--;
 	}
 	c->page = NULL;
-	unfreeze_slab(s, page);
+	unfreeze_slab(s, page, tail);
 }
 
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
@@ -1614,7 +1613,7 @@ checks_ok:
 	 * then add it.
 	 */
 	if (unlikely(!prior))
-		add_partial_tail(get_node(s, page_to_nid(page)), page);
+		add_partial(get_node(s, page_to_nid(page)), page, 1);
 
 out_unlock:
 	slab_unlock(page);
@@ -2022,7 +2021,7 @@ static struct kmem_cache_node *early_kme
 #endif
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
-	add_partial(n, page);
+	add_partial(n, page, 0);
 	return n;
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
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
