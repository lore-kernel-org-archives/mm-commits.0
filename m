From: akpm@linux-foundation.org
Subject: - slub-add-min_partial.patch removed from -mm tree
Date: Mon, 07 May 2007 17:08:39 -0700
Message-ID: <200705080008.l4808dYJ009396@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967440AbXEHAJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:09:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Add MIN_PARTIAL
has been removed from the -mm tree.  Its filename was
     slub-add-min_partial.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: Add MIN_PARTIAL
From: Christoph Lameter <clameter@sgi.com>

We leave a mininum of partial slabs on nodes when we search for
partial slabs on other node. Define a constant for that value.

Then modify slub to keep MIN_PARTIAL slabs around.

This avoids bad situations where a function frees the last object
in a slab (which results in the page being returned to the page
allocator) only to then allocate one again (which requires getting
a page back from the page allocator if the partial list was empty).
Keeping a couple of slabs on the partial list reduces overhead.

Empty slabs are added to the end of the partial list to insure that
partially allocated slabs are consumed first (defragmentation).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   55 ++++++++++++++++++++++++++++++++++------------------
 1 files changed, 36 insertions(+), 19 deletions(-)

diff -puN mm/slub.c~slub-add-min_partial mm/slub.c
--- a/mm/slub.c~slub-add-min_partial
+++ a/mm/slub.c
@@ -133,6 +133,9 @@
  */
 #define SLUB_UNIMPLEMENTED (SLAB_DEBUG_INITIAL)
 
+/* Mininum number of partial slabs */
+#define MIN_PARTIAL 2
+
 #define DEBUG_DEFAULT_FLAGS (SLAB_DEBUG_FREE | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
 /*
@@ -664,16 +667,8 @@ static int on_freelist(struct kmem_cache
 /*
  * Tracking of fully allocated slabs for debugging
  */
-static void add_full(struct kmem_cache *s, struct page *page)
+static void add_full(struct kmem_cache_node *n, struct page *page)
 {
-	struct kmem_cache_node *n;
-
-	VM_BUG_ON(!irqs_disabled());
-
-	if (!(s->flags & SLAB_STORE_USER))
-		return;
-
-	n = get_node(s, page_to_nid(page));
 	spin_lock(&n->list_lock);
 	list_add(&page->lru, &n->full);
 	spin_unlock(&n->list_lock);
@@ -982,10 +977,16 @@ static __always_inline int slab_trylock(
 /*
  * Management of partially allocated slabs
  */
-static void add_partial(struct kmem_cache *s, struct page *page)
+static void add_partial_tail(struct kmem_cache_node *n, struct page *page)
 {
-	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
+	spin_lock(&n->list_lock);
+	n->nr_partial++;
+	list_add_tail(&page->lru, &n->partial);
+	spin_unlock(&n->list_lock);
+}
 
+static void add_partial(struct kmem_cache_node *n, struct page *page)
+{
 	spin_lock(&n->list_lock);
 	n->nr_partial++;
 	list_add(&page->lru, &n->partial);
@@ -1085,7 +1086,7 @@ static struct page *get_any_partial(stru
 		n = get_node(s, zone_to_nid(*z));
 
 		if (n && cpuset_zone_allowed_hardwall(*z, flags) &&
-				n->nr_partial > 2) {
+				n->nr_partial > MIN_PARTIAL) {
 			page = get_partial_node(n);
 			if (page)
 				return page;
@@ -1119,15 +1120,31 @@ static struct page *get_partial(struct k
  */
 static void putback_slab(struct kmem_cache *s, struct page *page)
 {
+	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
+
 	if (page->inuse) {
+
 		if (page->freelist)
-			add_partial(s, page);
-		else if (PageError(page))
-			add_full(s, page);
+			add_partial(n, page);
+		else if (PageError(page) && (s->flags & SLAB_STORE_USER))
+			add_full(n, page);
 		slab_unlock(page);
+
 	} else {
-		slab_unlock(page);
-		discard_slab(s, page);
+		if (n->nr_partial < MIN_PARTIAL) {
+			/*
+			 * Adding an empty page to the partial slabs in order
+			 * to avoid page allocator overhead. This page needs to
+			 * come after all the others that are not fully empty
+			 * in order to make sure that we do maximum
+			 * defragmentation.
+			 */
+			add_partial_tail(n, page);
+			slab_unlock(page);
+		} else {
+			slab_unlock(page);
+			discard_slab(s, page);
+		}
 	}
 }
 
@@ -1326,7 +1343,7 @@ checks_ok:
 	 * then add it.
 	 */
 	if (unlikely(!prior))
-		add_partial(s, page);
+		add_partial(get_node(s, page_to_nid(page)), page);
 
 out_unlock:
 	slab_unlock(page);
@@ -1535,7 +1552,7 @@ static struct kmem_cache_node * __init e
 	init_object(kmalloc_caches, n, 1);
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
-	add_partial(kmalloc_caches, page);
+	add_partial(n, page);
 	return n;
 }
 
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
