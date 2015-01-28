From: akpm@linux-foundation.org
Subject: + slub-never-fail-to-shrink-cache.patch added to -mm tree
Date: Wed, 28 Jan 2015 13:59:13 -0800
Message-ID: <54c95bb1.7OLtx0A7CMKFBjvQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbbA2BhV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Jan 2015 20:37:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: never fail to shrink cache
has been added to the -mm tree.  Its filename is
     slub-never-fail-to-shrink-cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-never-fail-to-shrink-cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-never-fail-to-shrink-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   57 +++++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

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
@@ -3375,51 +3376,56 @@ int __kmem_cache_shrink(struct kmem_cach
 	struct kmem_cache_node *n;
 	struct page *page;
 	struct page *t;
-	int objects = oo_objects(s->max);
-	struct list_head *slabs_by_inuse =
-		kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
+	LIST_HEAD(discard);
+	struct list_head promote[SHRINK_PROMOTE_MAX];
 	unsigned long flags;
 
-	if (!slabs_by_inuse)
-		return -ENOMEM;
+	for (i = 0; i < SHRINK_PROMOTE_MAX; i++)
+		INIT_LIST_HEAD(promote + i);
 
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
 		if (!n->nr_partial)
 			continue;
 
-		for (i = 0; i < objects; i++)
-			INIT_LIST_HEAD(slabs_by_inuse + i);
-
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
+			list_splice_init(promote + i, &n->partial);
 
 		spin_unlock_irqrestore(&n->list_lock, flags);
 
 		/* Release empty slabs */
-		list_for_each_entry_safe(page, t, slabs_by_inuse, lru)
+		list_for_each_entry_safe(page, t, &discard, lru)
 			discard_slab(s, page);
 	}
 
-	kfree(slabs_by_inuse);
 	return 0;
 }
 
@@ -4686,12 +4692,9 @@ static ssize_t shrink_show(struct kmem_c
 static ssize_t shrink_store(struct kmem_cache *s,
 			const char *buf, size_t length)
 {
-	if (buf[0] == '1') {
-		int rc = kmem_cache_shrink(s);
-
-		if (rc)
-			return rc;
-	} else
+	if (buf[0] == '1')
+		kmem_cache_shrink(s);
+	else
 		return -EINVAL;
 	return length;
 }
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
mm-memcontrol-simplify-soft-limit-tree-init-code.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-embed-memcg_cache_params-to-kmem_cache-fix.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list-fix.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
slub-never-fail-to-shrink-cache.patch
slub-fix-kmem_cache_shrink-return-value.patch
slub-make-dead-caches-discard-free-slabs-immediately.patch
vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch

