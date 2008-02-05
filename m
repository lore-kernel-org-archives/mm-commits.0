From: akpm@linux-foundation.org
Subject: - slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:44:46 -0800
Message-ID: <200802050244.m152iSET031138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbYBECok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:44:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     SLUB: move kmem_cache_node determination into add_full and add_partial
has been removed from the -mm tree.  Its filename was
     slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SLUB: move kmem_cache_node determination into add_full and add_partial
From: Christoph Lameter <clameter@sgi.com>

The kmem_cache_node determination can be moved into add_full() and
add_partial().  This removes some code from the slab_free() slow path and
reduces the register overhead that has to be managed in the slow path.

[a.p.zijlstra@chello.nl: workaround for lockdep confusion]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff -puN mm/slub.c~slub-move-kmem_cache_node-determination-into-add_full-and-add_partial mm/slub.c
--- a/mm/slub.c~slub-move-kmem_cache_node-determination-into-add_full-and-add_partial
+++ a/mm/slub.c
@@ -800,8 +800,12 @@ static void trace(struct kmem_cache *s, 
 /*
  * Tracking of fully allocated slabs for debugging purposes.
  */
-static void add_full(struct kmem_cache_node *n, struct page *page)
+static void add_full(struct kmem_cache *s, struct page *page)
 {
+	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
+
+	if (!SlabDebug(page) || !(s->flags & SLAB_STORE_USER))
+		return;
 	spin_lock(&n->list_lock);
 	list_add(&page->lru, &n->full);
 	spin_unlock(&n->list_lock);
@@ -1024,7 +1028,7 @@ static inline int slab_pad_check(struct 
 			{ return 1; }
 static inline int check_object(struct kmem_cache *s, struct page *page,
 			void *object, int active) { return 1; }
-static inline void add_full(struct kmem_cache_node *n, struct page *page) {}
+static inline void add_full(struct kmem_cache *s, struct page *page) {}
 static inline unsigned long kmem_cache_flags(unsigned long objsize,
 	unsigned long flags, const char *name,
 	void (*ctor)(struct kmem_cache *, void *))
@@ -1195,9 +1199,11 @@ static __always_inline int slab_trylock(
 /*
  * Management of partially allocated slabs
  */
-static void add_partial(struct kmem_cache_node *n,
+static void add_partial(struct kmem_cache *s,
 				struct page *page, int tail)
 {
+	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
+
 	spin_lock(&n->list_lock);
 	n->nr_partial++;
 	if (tail)
@@ -1334,19 +1340,18 @@ static struct page *get_partial(struct k
  */
 static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 {
-	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
-
 	ClearSlabFrozen(page);
 	if (page->inuse) {
 
 		if (page->freelist)
-			add_partial(n, page, tail);
-		else if (SlabDebug(page) && (s->flags & SLAB_STORE_USER))
-			add_full(n, page);
+			add_partial(s, page, tail);
+		else
+			add_full(s, page);
 		slab_unlock(page);
 
 	} else {
-		if (n->nr_partial < MIN_PARTIAL) {
+		if (get_node(s, page_to_nid(page))->nr_partial
+							< MIN_PARTIAL) {
 			/*
 			 * Adding an empty slab to the partial slabs in order
 			 * to avoid page allocator overhead. This slab needs
@@ -1355,7 +1360,7 @@ static void unfreeze_slab(struct kmem_ca
 			 * partial list stays small. kmem_cache_shrink can
 			 * reclaim empty slabs from the partial list.
 			 */
-			add_partial(n, page, 1);
+			add_partial(s, page, 1);
 			slab_unlock(page);
 		} else {
 			slab_unlock(page);
@@ -1613,7 +1618,7 @@ checks_ok:
 	 * then add it.
 	 */
 	if (unlikely(!prior))
-		add_partial(get_node(s, page_to_nid(page)), page, 1);
+		add_partial(s, page, 1);
 
 out_unlock:
 	slab_unlock(page);
@@ -1997,6 +2002,7 @@ static struct kmem_cache_node *early_kme
 {
 	struct page *page;
 	struct kmem_cache_node *n;
+	unsigned long flags;
 
 	BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
 
@@ -2021,7 +2027,14 @@ static struct kmem_cache_node *early_kme
 #endif
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
-	add_partial(n, page, 0);
+	/*
+	 * lockdep requires consistent irq usage for each lock
+	 * so even though there cannot be a race this early in
+	 * the boot sequence, we still disable irqs.
+	 */
+	local_irq_save(flags);
+	add_partial(kmalloc_caches, page, 0);
+	local_irq_restore(flags);
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
vunmap-return-page-array-passed-on-vmap.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
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
