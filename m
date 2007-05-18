From: akpm@linux-foundation.org
Subject: - slub-define-functions-for-cpu-slab-handling-instead-of-using.patch removed from -mm tree
Date: Fri, 18 May 2007 00:05:29 -0700
Message-ID: <200705180705.l4I75SWU010096@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41825 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450AbXERHHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:07:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Define functions for cpu slab handling instead of using PageActive
has been removed from the -mm tree.  Its filename was
     slub-define-functions-for-cpu-slab-handling-instead-of-using.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: Define functions for cpu slab handling instead of using PageActive
From: Christoph Lameter <clameter@sgi.com>

Use inline functions to access the per cpu bit.  Intoduce the notion of
"freezing" a slab to make things more understandable.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   57 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff -puN mm/slub.c~slub-define-functions-for-cpu-slab-handling-instead-of-using mm/slub.c
--- a/mm/slub.c~slub-define-functions-for-cpu-slab-handling-instead-of-using
+++ a/mm/slub.c
@@ -78,10 +78,18 @@
  *
  * Overloading of page flags that are otherwise used for LRU management.
  *
- * PageActive 		The slab is used as a cpu cache. Allocations
- * 			may be performed from the slab. The slab is not
- * 			on any slab list and cannot be moved onto one.
- * 			The cpu slab may be equipped with an additioanl
+ * PageActive 		The slab is frozen and exempt from list processing.
+ * 			This means that the slab is dedicated to a purpose
+ * 			such as satisfying allocations for a specific
+ * 			processor. Objects may be freed in the slab while
+ * 			it is frozen but slab_free will then skip the usual
+ * 			list operations. It is up to the processor holding
+ * 			the slab to integrate the slab into the slab lists
+ * 			when the slab is no longer needed.
+ *
+ * 			One use of this flag is to mark slabs that are
+ * 			used for allocations. Then such a slab becomes a cpu
+ * 			slab. The cpu slab may be equipped with an additional
  * 			lockless_freelist that allows lockless access to
  * 			free objects in addition to the regular freelist
  * 			that requires the slab lock.
@@ -91,6 +99,21 @@
  * 			the fast path and disables lockless freelists.
  */
 
+static inline int SlabFrozen(struct page *page)
+{
+	return PageActive(page);
+}
+
+static inline void SetSlabFrozen(struct page *page)
+{
+	SetPageActive(page);
+}
+
+static inline void ClearSlabFrozen(struct page *page)
+{
+	ClearPageActive(page);
+}
+
 static inline int SlabDebug(struct page *page)
 {
 #ifdef CONFIG_SLUB_DEBUG
@@ -1135,11 +1158,12 @@ static void remove_partial(struct kmem_c
  *
  * Must hold list_lock.
  */
-static int lock_and_del_slab(struct kmem_cache_node *n, struct page *page)
+static inline int lock_and_freeze_slab(struct kmem_cache_node *n, struct page *page)
 {
 	if (slab_trylock(page)) {
 		list_del(&page->lru);
 		n->nr_partial--;
+		SetSlabFrozen(page);
 		return 1;
 	}
 	return 0;
@@ -1163,7 +1187,7 @@ static struct page *get_partial_node(str
 
 	spin_lock(&n->list_lock);
 	list_for_each_entry(page, &n->partial, lru)
-		if (lock_and_del_slab(n, page))
+		if (lock_and_freeze_slab(n, page))
 			goto out;
 	page = NULL;
 out:
@@ -1242,10 +1266,11 @@ static struct page *get_partial(struct k
  *
  * On exit the slab lock will have been dropped.
  */
-static void putback_slab(struct kmem_cache *s, struct page *page)
+static void unfreeze_slab(struct kmem_cache *s, struct page *page)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
+	ClearSlabFrozen(page);
 	if (page->inuse) {
 
 		if (page->freelist)
@@ -1296,9 +1321,7 @@ static void deactivate_slab(struct kmem_
 		page->inuse--;
 	}
 	s->cpu_slab[cpu] = NULL;
-	ClearPageActive(page);
-
-	putback_slab(s, page);
+	unfreeze_slab(s, page);
 }
 
 static void flush_slab(struct kmem_cache *s, struct page *page, int cpu)
@@ -1389,9 +1412,7 @@ another_slab:
 new_slab:
 	page = get_partial(s, gfpflags, node);
 	if (page) {
-have_slab:
 		s->cpu_slab[cpu] = page;
-		SetPageActive(page);
 		goto load_freelist;
 	}
 
@@ -1421,7 +1442,9 @@ have_slab:
 			flush_slab(s, s->cpu_slab[cpu], cpu);
 		}
 		slab_lock(page);
-		goto have_slab;
+		SetSlabFrozen(page);
+		s->cpu_slab[cpu] = page;
+		goto load_freelist;
 	}
 	return NULL;
 debug:
@@ -1508,11 +1531,7 @@ checks_ok:
 	page->freelist = object;
 	page->inuse--;
 
-	if (unlikely(PageActive(page)))
-		/*
-		 * Cpu slabs are never on partial lists and are
-		 * never freed.
-		 */
+	if (unlikely(SlabFrozen(page)))
 		goto out_unlock;
 
 	if (unlikely(!page->inuse))
@@ -1544,7 +1563,7 @@ slab_empty:
 debug:
 	if (!free_object_checks(s, page, x))
 		goto out_unlock;
-	if (!PageActive(page) && !page->freelist)
+	if (!SlabFrozen(page) && !page->freelist)
 		remove_full(s, page);
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, x, TRACK_FREE, addr);
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
