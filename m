From: akpm@linux-foundation.org
Subject: - slub-enable-tracking-of-full-slabs.patch removed from -mm tree
Date: Mon, 07 May 2007 17:08:33 -0700
Message-ID: <200705080008.l4808Xto009389@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967435AbXEHAIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub: enable tracking of full slabs
has been removed from the -mm tree.  Its filename was
     slub-enable-tracking-of-full-slabs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slub: enable tracking of full slabs
From: Christoph Lameter <clameter@sgi.com>

If slab tracking is on then build a list of full slabs so that we can verify
the integrity of all slabs and are also able to built list of alloc/free
callers.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    1 
 mm/slub.c                |   41 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff -puN include/linux/slub_def.h~slub-enable-tracking-of-full-slabs include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-enable-tracking-of-full-slabs
+++ a/include/linux/slub_def.h
@@ -16,6 +16,7 @@ struct kmem_cache_node {
 	unsigned long nr_partial;
 	atomic_long_t nr_slabs;
 	struct list_head partial;
+	struct list_head full;
 };
 
 /*
diff -puN mm/slub.c~slub-enable-tracking-of-full-slabs mm/slub.c
--- a/mm/slub.c~slub-enable-tracking-of-full-slabs
+++ a/mm/slub.c
@@ -661,6 +661,40 @@ static int on_freelist(struct kmem_cache
 	return search == NULL;
 }
 
+/*
+ * Tracking of fully allocated slabs for debugging
+ */
+static void add_full(struct kmem_cache *s, struct page *page)
+{
+	struct kmem_cache_node *n;
+
+	VM_BUG_ON(!irqs_disabled());
+
+	VM_BUG_ON(!irqs_disabled());
+
+	if (!(s->flags & SLAB_STORE_USER))
+		return;
+
+	n = get_node(s, page_to_nid(page));
+	spin_lock(&n->list_lock);
+	list_add(&page->lru, &n->full);
+	spin_unlock(&n->list_lock);
+}
+
+static void remove_full(struct kmem_cache *s, struct page *page)
+{
+	struct kmem_cache_node *n;
+
+	if (!(s->flags & SLAB_STORE_USER))
+		return;
+
+	n = get_node(s, page_to_nid(page));
+
+	spin_lock(&n->list_lock);
+	list_del(&page->lru);
+	spin_unlock(&n->list_lock);
+}
+
 static int alloc_object_checks(struct kmem_cache *s, struct page *page,
 							void *object)
 {
@@ -1090,6 +1124,8 @@ static void putback_slab(struct kmem_cac
 	if (page->inuse) {
 		if (page->freelist)
 			add_partial(s, page);
+		else if (PageError(page))
+			add_full(s, page);
 		slab_unlock(page);
 	} else {
 		slab_unlock(page);
@@ -1302,7 +1338,7 @@ out_unlock:
 slab_empty:
 	if (prior)
 		/*
-		 * Partially used slab that is on the partial list.
+		 * Slab on the partial list.
 		 */
 		remove_partial(s, page);
 
@@ -1314,6 +1350,8 @@ slab_empty:
 debug:
 	if (!free_object_checks(s, page, x))
 		goto out_unlock;
+	if (!PageActive(page) && !page->freelist)
+		remove_full(s, page);
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, x, TRACK_FREE, addr);
 	goto checks_ok;
@@ -1466,6 +1504,7 @@ static void init_kmem_cache_node(struct 
 	atomic_long_set(&n->nr_slabs, 0);
 	spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
+	INIT_LIST_HEAD(&n->full);
 }
 
 #ifdef CONFIG_NUMA
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
