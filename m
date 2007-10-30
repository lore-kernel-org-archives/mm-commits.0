From: akpm@linux-foundation.org
Subject: + slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch added to -mm tree
Date: Tue, 30 Oct 2007 11:31:46 -0700
Message-ID: <200710301831.l9UIVkAl021440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57050 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbXJ3Sby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:31:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     SLUB: move kmem_cache_node determination into add_full and add_partial
has been added to the -mm tree.  Its filename is
     slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: move kmem_cache_node determination into add_full and add_partial
From: Christoph Lameter <clameter@sgi.com>

The kmem_cache_node determination can be moved into add_full() and
add_partial().  This removes some code from the slab_free() slow path and
reduces the register overhead that has to be managed in the slow path.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

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
@@ -1197,9 +1201,11 @@ static __always_inline int slab_trylock(
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
@@ -1336,19 +1342,18 @@ static struct page *get_partial(struct k
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
@@ -1357,7 +1362,7 @@ static void unfreeze_slab(struct kmem_ca
 			 * partial list stays small. kmem_cache_shrink can
 			 * reclaim empty slabs from the partial list.
 			 */
-			add_partial(n, page, 1);
+			add_partial(s, page, 1);
 			slab_unlock(page);
 		} else {
 			slab_unlock(page);
@@ -1633,7 +1638,7 @@ checks_ok:
 	 * then add it.
 	 */
 	if (unlikely(!prior))
-		add_partial(get_node(s, page_to_nid(page)), page, 0);
+		add_partial(s, page, 0);
 
 out_unlock:
 	slab_unlock(page);
@@ -2041,7 +2046,7 @@ static struct kmem_cache_node *early_kme
 #endif
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
-	add_partial(n, page, 0);
+	add_partial(kmalloc_caches, page, 0);
 	return n;
 }
 
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
