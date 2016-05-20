From: akpm@linux-foundation.org
Subject: [patch 027/117] mm/slab: don't keep free slabs if free_objects
 exceeds free_limit
Date: Thu, 19 May 2016 17:10:17 -0700
Message-ID: <573e55e9.WThpzqpfMMxI5bFH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbcETAKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:10:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: don't keep free slabs if free_objects exceeds free_limit

Currently, determination to free a slab is done whenever each freed object
is put into the slab.  This has a following problem.

Assume free_limit = 10 and nr_free = 9.

Free happens as following sequence and nr_free changes as following.

free(become a free slab) free(not become a free slab)
nr_free: 9 -> 10 (at first free) -> 11 (at second free)

If we try to check if we can free current slab or not on each object free,
we can't free any slab in this situation because current slab isn't a free
slab when nr_free exceed free_limit (at second free) even if there is a
free slab.

However, if we check it lastly, we can free 1 free slab.

This problem would cause to keep too much memory in the slab subsystem. 
This patch try to fix it by checking number of free object after all free
work is done.  If there is free slab at that time, we can free slab as
much as possible so we keep free slab as minimal.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN mm/slab.c~mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit mm/slab.c
--- a/mm/slab.c~mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit
+++ a/mm/slab.c
@@ -3296,6 +3296,9 @@ static void free_block(struct kmem_cache
 {
 	int i;
 	struct kmem_cache_node *n = get_node(cachep, node);
+	struct page *page;
+
+	n->free_objects += nr_objects;
 
 	for (i = 0; i < nr_objects; i++) {
 		void *objp;
@@ -3308,17 +3311,11 @@ static void free_block(struct kmem_cache
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
@@ -3326,6 +3323,14 @@ static void free_block(struct kmem_cache
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
