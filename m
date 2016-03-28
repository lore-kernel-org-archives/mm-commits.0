From: akpm@linux-foundation.org
Subject: +
 mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch added to -mm tree
Date: Mon, 28 Mar 2016 14:22:31 -0700
Message-ID: <56f9a097.wyBmJqnPno1P5aTG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbcC1VWc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 17:22:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: don't keep free slabs if free_objects exceeds free_limit
has been added to the -mm tree.  Its filename is
     mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3265,6 +3265,9 @@ static void free_block(struct kmem_cache
 {
 	int i;
 	struct kmem_cache_node *n = get_node(cachep, node);
+	struct page *page;
+
+	n->free_objects += nr_objects;
 
 	for (i = 0; i < nr_objects; i++) {
 		void *objp;
@@ -3277,17 +3280,11 @@ static void free_block(struct kmem_cache
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
@@ -3295,6 +3292,14 @@ static void free_block(struct kmem_cache
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

mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
mm-slab-hold-a-slab_mutex-when-calling-__kmem_cache_shrink.patch
mm-slab-remove-bad_alien_magic-again.patch
mm-slab-drain-the-free-slab-as-much-as-possible.patch
mm-slab-factor-out-kmem_cache_node-initialization-code.patch
mm-slab-clean-up-kmem_cache_node-setup.patch
mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch
mm-slab-racy-access-modify-the-slab-color.patch
mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node.patch
mm-slab-separate-cache_grow-to-two-parts.patch
mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock.patch
mm-slab-lockless-decision-to-grow-cache.patch

