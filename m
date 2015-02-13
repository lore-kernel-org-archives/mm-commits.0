From: akpm@linux-foundation.org
Subject: [merged] slub-never-fail-to-shrink-cache.patch removed from -mm
 tree
Date: Fri, 13 Feb 2015 12:20:31 -0800
Message-ID: <54de5c8f.Kpv+ek1pPlJ7mLJi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbbBMUUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: never fail to shrink cache
has been removed from the -mm tree.  Its filename was
     slub-never-fail-to-shrink-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: never fail to shrink cache

SLUB's version of __kmem_cache_shrink() not only removes empty slabs, but
also tries to rearrange the partial lists to place slabs filled up most to
the head to cope with fragmentation.  To achieve that, it allocates a
temporary array of lists used to sort slabs by the number of objects in
use.  If the allocation fails, the whole procedure is aborted.

This is unacceptable for the kernel memory accounting extension of the
memory cgroup, where we want to make sure that kmem_cache_shrink()
successfully discarded empty slabs.  Although the allocation failure is
utterly unlikely with the current page allocator implementation, which
retries GFP_KERNEL allocations of order <= 2 infinitely, it is better not
to rely on that.

This patch therefore makes __kmem_cache_shrink() allocate the array on
stack instead of calling kmalloc, which may fail.  The array size is
chosen to be equal to 32, because most SLUB caches store not more than 32
objects per slab page.  Slab pages with <= 32 free objects are sorted
using the array by the number of objects in use and promoted to the head
of the partial list, while slab pages with > 32 free objects are left in
the end of the list without any ordering imposed on them.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   58 +++++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff -puN mm/slub.c~slub-never-fail-to-shrink-cache mm/slub.c
--- a/mm/slub.c~slub-never-fail-to-shrink-cache
+++ a/mm/slub.c
@@ -3358,11 +3358,12 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
+#define SHRINK_PROMOTE_MAX 32
+
 /*
- * kmem_cache_shrink removes empty slabs from the partial lists and sorts
- * the remaining slabs by the number of items in use. The slabs with the
- * most items in use come first. New allocations will then fill those up
- * and thus they can be removed from the partial lists.
+ * kmem_cache_shrink discards empty slabs and promotes the slabs filled
+ * up most to the head of the partial lists. New allocations will then
+ * fill those up and thus they can be removed from the partial lists.
  *
  * The slabs with the least items are placed last. This results in them
  * being allocated from last increasing the chance that the last objects
@@ -3375,51 +3376,57 @@ int __kmem_cache_shrink(struct kmem_cach
 	struct kmem_cache_node *n;
 	struct page *page;
 	struct page *t;
-	int objects = oo_objects(s->max);
-	struct list_head *slabs_by_inuse =
-		kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
+	struct list_head discard;
+	struct list_head promote[SHRINK_PROMOTE_MAX];
 	unsigned long flags;
 
-	if (!slabs_by_inuse)
-		return -ENOMEM;
-
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
 		if (!n->nr_partial)
 			continue;
 
-		for (i = 0; i < objects; i++)
-			INIT_LIST_HEAD(slabs_by_inuse + i);
+		INIT_LIST_HEAD(&discard);
+		for (i = 0; i < SHRINK_PROMOTE_MAX; i++)
+			INIT_LIST_HEAD(promote + i);
 
 		spin_lock_irqsave(&n->list_lock, flags);
 
 		/*
-		 * Build lists indexed by the items in use in each slab.
+		 * Build lists of slabs to discard or promote.
 		 *
 		 * Note that concurrent frees may occur while we hold the
 		 * list_lock. page->inuse here is the upper limit.
 		 */
 		list_for_each_entry_safe(page, t, &n->partial, lru) {
-			list_move(&page->lru, slabs_by_inuse + page->inuse);
-			if (!page->inuse)
+			int free = page->objects - page->inuse;
+
+			/* Do not reread page->inuse */
+			barrier();
+
+			/* We do not keep full slabs on the list */
+			BUG_ON(free <= 0);
+
+			if (free == page->objects) {
+				list_move(&page->lru, &discard);
 				n->nr_partial--;
+			} else if (free <= SHRINK_PROMOTE_MAX)
+				list_move(&page->lru, promote + free - 1);
 		}
 
 		/*
-		 * Rebuild the partial list with the slabs filled up most
-		 * first and the least used slabs at the end.
+		 * Promote the slabs filled up most to the head of the
+		 * partial list.
 		 */
-		for (i = objects - 1; i > 0; i--)
-			list_splice(slabs_by_inuse + i, n->partial.prev);
+		for (i = SHRINK_PROMOTE_MAX - 1; i >= 0; i--)
+			list_splice(promote + i, &n->partial);
 
 		spin_unlock_irqrestore(&n->list_lock, flags);
 
 		/* Release empty slabs */
-		list_for_each_entry_safe(page, t, slabs_by_inuse, lru)
+		list_for_each_entry_safe(page, t, &discard, lru)
 			discard_slab(s, page);
 	}
 
-	kfree(slabs_by_inuse);
 	return 0;
 }
 
@@ -4686,12 +4693,9 @@ static ssize_t shrink_show(struct kmem_c
 static ssize_t shrink_store(struct kmem_cache *s,
 			const char *buf, size_t length)
 {
-	if (buf[0] == '1') {
-		int rc = kmem_cache_shrink(s);
