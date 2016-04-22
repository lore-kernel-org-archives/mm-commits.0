From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch
 removed from -mm tree
Date: Fri, 22 Apr 2016 14:56:22 -0700
Message-ID: <571a9e06.2/gJKM6ovVRnw3kA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbcDVV4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 17:56:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: don't keep free slabs if free_objects exceeds free_limit
has been removed from the -mm tree.  Its filename was
     mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: don't keep free slabs if free_objects exceeds free_limit

Currently, determination to free a slab is done whenever free object is
put into the slab.  This has a problem that free slabs are not freed even
if we have free slabs and have more free_objects than free_limit when
processed slab isn't a free slab.  This would cause to keep too much
memory in the slab subsystem.  This patch try to fix it by checking number
of free object after all free work is done.  If there is free slab at that
time, we can free it so we keep free slab as minimal as possible.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN mm/slab.c~mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit mm/slab.c
--- a/mm/slab.c~mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit
+++ a/mm/slab.c
@@ -3266,6 +3266,9 @@ static void free_block(struct kmem_cache
 {
 	int i;
 	struct kmem_cache_node *n = get_node(cachep, node);
+	struct page *page;
+
+	n->free_objects += nr_objects;
 
 	for (i = 0; i < nr_objects; i++) {
 		void *objp;
@@ -3278,17 +3281,11 @@ static void free_block(struct kmem_cache
 		check_spinlock_acquired_node(cachep, node);
 		slab_put_obj(cachep, page, objp);
 		STATS_DEC_ACTIVE(cachep);
-		n->free_objects++;
 
 		/* fixup slab chains */
-		if (page->active == 0) {
-			if (n->free_objects > n->free_limit) {
-				n->free_objects -= cachep->num;
-				list_add_tail(&page->lru, list);
-			} else {
-				list_add(&page->lru, &n->slabs_free);
-			}
-		} else {
+		if (page->active == 0)
+			list_add(&page->lru, &n->slabs_free);
+		else {
 			/* Unconditionally move a slab to the end of the
 			 * partial list on free - maximum time for the
 			 * other objects to be freed, too.
@@ -3296,6 +3293,14 @@ static void free_block(struct kmem_cache
 			list_add_tail(&page->lru, &n->slabs_partial);
 		}
 	}
+
+	while (n->free_objects > n->free_limit && !list_empty(&n->slabs_free)) {
+		n->free_objects -= cachep->num;
+
+		page = list_last_entry(&n->slabs_free, struct page, lru);
+		list_del(&page->lru);
+		list_add(&page->lru, list);
+	}
 }
 
 static void cache_flusharray(struct kmem_cache *cachep, struct array_cache *ac)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-racy-access-modify-the-slab-color.patch
mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node.patch
mm-slab-separate-cache_grow-to-two-parts.patch
mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock.patch
mm-slab-lockless-decision-to-grow-cache.patch
mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix.patch
mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch
mm-memory_hotplug-add-comment-to-some-functions-related-to-memory-hotplug.patch
mm-vmstat-add-zone-range-overlapping-check.patch
mm-page_owner-add-zone-range-overlapping-check.patch
power-add-zone-range-overlapping-check.patch
mm-writeback-correct-dirty-page-calculation-for-highmem.patch
mm-page_alloc-correct-highmem-memory-statistics.patch
mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself.patch
mm-vmstat-make-node_page_state-handles-all-zones-by-itself.patch

