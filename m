From: akpm@linux-foundation.org
Subject: + mm-slab-racy-access-modify-the-slab-color.patch added to -mm
 tree
Date: Fri, 22 Apr 2016 15:02:05 -0700
Message-ID: <571a9f5d.3eLX0PF73P9kfy13%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbcDVWCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 18:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: racy access/modify the slab color
has been added to the -mm tree.  Its filename is
     mm-slab-racy-access-modify-the-slab-color.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-racy-access-modify-the-slab-color.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-racy-access-modify-the-slab-color.patch

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
Subject: mm/slab: racy access/modify the slab color

Slab color isn't needed to be changed strictly.  Because locking for
changing slab color could cause more lock contention so this patch
implements racy access/modify the slab color.  This is a preparation step
to implement lockless allocation path when there is no free objects in the
kmem_cache.

Below is the result of concurrent allocation/free in slab allocation
benchmark made by Christoph a long time ago.  I make the output simpler. 
The number shows cycle count during alloc/free respectively so less is
better.

* Before
Kmalloc N*alloc N*free(32): Average=365/806
Kmalloc N*alloc N*free(64): Average=452/690
Kmalloc N*alloc N*free(128): Average=736/886
Kmalloc N*alloc N*free(256): Average=1167/985
Kmalloc N*alloc N*free(512): Average=2088/1125
Kmalloc N*alloc N*free(1024): Average=4115/1184
Kmalloc N*alloc N*free(2048): Average=8451/1748
Kmalloc N*alloc N*free(4096): Average=16024/2048

* After
Kmalloc N*alloc N*free(32): Average=355/750
Kmalloc N*alloc N*free(64): Average=452/812
Kmalloc N*alloc N*free(128): Average=559/1070
Kmalloc N*alloc N*free(256): Average=1176/980
Kmalloc N*alloc N*free(512): Average=1939/1189
Kmalloc N*alloc N*free(1024): Average=3521/1278
Kmalloc N*alloc N*free(2048): Average=7152/1838
Kmalloc N*alloc N*free(4096): Average=13438/2013

It shows that contention is reduced for object size >= 1024 and
performance increases by roughly 15%.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN mm/slab.c~mm-slab-racy-access-modify-the-slab-color mm/slab.c
--- a/mm/slab.c~mm-slab-racy-access-modify-the-slab-color
+++ a/mm/slab.c
@@ -2568,20 +2568,7 @@ static int cache_grow(struct kmem_cache
 	}
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
-	/* Take the node list lock to change the colour_next on this node */
 	check_irq_off();
-	n = get_node(cachep, nodeid);
-	spin_lock(&n->list_lock);
-
-	/* Get colour for the slab, and cal the next value. */
-	offset = n->colour_next;
-	n->colour_next++;
-	if (n->colour_next >= cachep->colour)
-		n->colour_next = 0;
-	spin_unlock(&n->list_lock);
-
-	offset *= cachep->colour_off;
-
 	if (gfpflags_allow_blocking(local_flags))
 		local_irq_enable();
 
@@ -2602,6 +2589,19 @@ static int cache_grow(struct kmem_cache
 	if (!page)
 		goto failed;
 
+	n = get_node(cachep, nodeid);
+
+	/* Get colour for the slab, and cal the next value. */
+	n->colour_next++;
+	if (n->colour_next >= cachep->colour)
+		n->colour_next = 0;
+
+	offset = n->colour_next;
+	if (offset >= cachep->colour)
+		offset = 0;
+
+	offset *= cachep->colour_off;
+
 	/* Get slab management. */
 	freelist = alloc_slabmgmt(cachep, page, offset,
 			local_flags & ~GFP_CONSTRAINT_MASK, nodeid);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-fix-the-theoretical-race-by-holding-proper-lock.patch
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

