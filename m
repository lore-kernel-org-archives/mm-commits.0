From: akpm@linux-foundation.org
Subject: - slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch removed from -mm tree
Date: Mon, 07 May 2007 17:08:50 -0700
Message-ID: <200705080008.l4808oMD009404@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967450AbXEHAJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:09:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mel@skynet.ie, mm-commits@vger.kernel.org


The patch titled
     SLUB: Free slabs and sort partial slab lists in kmem_cache_shrink
has been removed from the -mm tree.  Its filename was
     slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: Free slabs and sort partial slab lists in kmem_cache_shrink
From: Christoph Lameter <clameter@sgi.com>

At kmem_cache_shrink check if we have any empty slabs on the partial
if so then remove them.

Also--as an anti-fragmentation measure--sort the partial slabs so that
the most fully allocated ones come first and the least allocated last.

The next allocations may fill up the nearly full slabs. Having the
least allocated slabs last gives them the maximum chance that their
remaining objects may be freed. Thus we can hopefully minimize the
partial slabs.

I think this is the best one can do in terms antifragmentation
measures. Real defragmentation (meaning moving objects out of slabs with
the least free objects to those that are almost full) can be implemted
by reverse scanning through the list produced here but that would mean
that we need to provide a callback at slab cache creation that allows
the deletion or moving of an object. This will involve slab API
changes, so defer for now.

Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 112 insertions(+), 13 deletions(-)

diff -puN mm/slub.c~slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink mm/slub.c
--- a/mm/slub.c~slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink
+++ a/mm/slub.c
@@ -130,9 +130,19 @@
  */
 #define SLUB_UNIMPLEMENTED (SLAB_DEBUG_INITIAL)
 
-/* Mininum number of partial slabs */
+/*
+ * Mininum number of partial slabs. These will be left on the partial
+ * lists even if they are empty. kmem_cache_shrink may reclaim them.
+ */
 #define MIN_PARTIAL 2
 
+/*
+ * Maximum number of desirable partial slabs.
+ * The existence of more partial slabs makes kmem_cache_shrink
+ * sort the partial list by the number of objects in the.
+ */
+#define MAX_PARTIAL 10
+
 #define DEBUG_DEFAULT_FLAGS (SLAB_DEBUG_FREE | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
 /*
@@ -1882,7 +1892,7 @@ static int kmem_cache_close(struct kmem_
 	for_each_online_node(node) {
 		struct kmem_cache_node *n = get_node(s, node);
 
-		free_list(s, n, &n->partial);
+		n->nr_partial -= free_list(s, n, &n->partial);
 		if (atomic_long_read(&n->nr_slabs))
 			return 1;
 	}
@@ -2130,6 +2140,86 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
+/*
+ *  kmem_cache_shrink removes empty slabs from the partial lists
+ *  and then sorts the partially allocated slabs by the number
+ *  of items in use. The slabs with the most items in use
+ *  come first. New allocations will remove these from the
+ *  partial list because they are full. The slabs with the
+ *  least items are placed last. If it happens that the objects
+ *  are freed then the page can be returned to the page allocator.
+ */
+int kmem_cache_shrink(struct kmem_cache *s)
+{
+	int node;
+	int i;
+	struct kmem_cache_node *n;
+	struct page *page;
+	struct page *t;
+	struct list_head *slabs_by_inuse =
+		kmalloc(sizeof(struct list_head) * s->objects, GFP_KERNEL);
+	unsigned long flags;
+
+	if (!slabs_by_inuse)
+		return -ENOMEM;
+
+	flush_all(s);
+	for_each_online_node(node) {
+		n = get_node(s, node);
+
+		if (!n->nr_partial)
+			continue;
+
+		for (i = 0; i < s->objects; i++)
+			INIT_LIST_HEAD(slabs_by_inuse + i);
+
+		spin_lock_irqsave(&n->list_lock, flags);
+
+		/*
+		 * Build lists indexed by the items in use in
+		 * each slab or free slabs if empty.
+		 *
+		 * Note that concurrent frees may occur while
+		 * we hold the list_lock. page->inuse here is
+		 * the upper limit.
+		 */
+		list_for_each_entry_safe(page, t, &n->partial, lru) {
+			if (!page->inuse && slab_trylock(page)) {
+				/*
+				 * Must hold slab lock here because slab_free
+				 * may have freed the last object and be
+				 * waiting to release the slab.
+				 */
+				list_del(&page->lru);
+				n->nr_partial--;
+				slab_unlock(page);
+				discard_slab(s, page);
+			} else {
+				if (n->nr_partial > MAX_PARTIAL)
+					list_move(&page->lru,
+					slabs_by_inuse + page->inuse);
+			}
+		}
+
+		if (n->nr_partial <= MAX_PARTIAL)
+			goto out;
+
+		/*
+		 * Rebuild the partial list with the slabs filled up
+		 * most first and the least used slabs at the end.
+		 */
+		for (i = s->objects - 1; i >= 0; i--)
+			list_splice(slabs_by_inuse + i, n->partial.prev);
+
+	out:
+		spin_unlock_irqrestore(&n->list_lock, flags);
+	}
+
+	kfree(slabs_by_inuse);
+	return 0;
+}
+EXPORT_SYMBOL(kmem_cache_shrink);
+
 /**
  * krealloc - reallocate memory. The contents will remain unchanged.
  *
@@ -2382,17 +2472,6 @@ static struct notifier_block __cpuinitda
 
 #endif
 
-/***************************************************************
- *	Compatiblility definitions
- **************************************************************/
-
-int kmem_cache_shrink(struct kmem_cache *s)
-{
-	flush_all(s);
-	return 0;
-}
-EXPORT_SYMBOL(kmem_cache_shrink);
-
 #ifdef CONFIG_NUMA
 
 /*****************************************************************
@@ -3169,6 +3248,25 @@ static ssize_t validate_store(struct kme
 }
 SLAB_ATTR(validate);
 
+static ssize_t shrink_show(struct kmem_cache *s, char *buf)
+{
+	return 0;
+}
+
+static ssize_t shrink_store(struct kmem_cache *s,
+			const char *buf, size_t length)
+{
+	if (buf[0] == '1') {
+		int rc = kmem_cache_shrink(s);
+
+		if (rc)
+			return rc;
+	} else
+		return -EINVAL;
+	return length;
+}
+SLAB_ATTR(shrink);
+
 static ssize_t alloc_calls_show(struct kmem_cache *s, char *buf)
 {
 	if (!(s->flags & SLAB_STORE_USER))
@@ -3225,6 +3323,7 @@ static struct attribute * slab_attrs[] =
 	&poison_attr.attr,
 	&store_user_attr.attr,
 	&validate_attr.attr,
+	&shrink_attr.attr,
 	&alloc_calls_attr.attr,
 	&free_calls_attr.attr,
 #ifdef CONFIG_ZONE_DMA
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
