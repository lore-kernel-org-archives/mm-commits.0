From: akpm@linux-foundation.org
Subject: +
 mm-slab-factor-out-kmem_cache_node-initialization-code-fix.patch added to
 -mm tree
Date: Tue, 26 Apr 2016 15:56:39 -0700
Message-ID: <571ff227.GGWrlj0/raegy0uj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbcDZW4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2016 18:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] mm/slab: fix bug
has been added to the -mm tree.  Its filename is
     mm-slab-factor-out-kmem_cache_node-initialization-code-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-factor-out-kmem_cache_node-initialization-code-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-factor-out-kmem_cache_node-initialization-code-fix.patch

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
Subject: [PATCH] mm/slab: fix bug

n->free_limit is once set in boot-up process without enabling multiple
cpu so it could be very low value. If we don't re-set when another cpu
is up, it will stay too low. Fix it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-factor-out-kmem_cache_node-initialization-code-fix mm/slab.c
--- a/mm/slab.c~mm-slab-factor-out-kmem_cache_node-initialization-code-fix
+++ a/mm/slab.c
@@ -858,8 +858,14 @@ static int init_cache_node(struct kmem_c
 	 * node has not already allocated this
 	 */
 	n = get_node(cachep, node);
-	if (n)
+	if (n) {
+		spin_lock_irq(&n->list_lock);
+		n->free_limit = (1 + nr_cpus_node(node)) * cachep->batchcount +
+				cachep->num;
+		spin_unlock_irq(&n->list_lock);
+
 		return 0;
+	}
 
 	n = kmalloc_node(sizeof(struct kmem_cache_node), gfp, node);
 	if (!n)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-fix-the-theoretical-race-by-holding-proper-lock.patch
mm-slab-remove-bad_alien_magic-again.patch
mm-slab-drain-the-free-slab-as-much-as-possible.patch
mm-slab-factor-out-kmem_cache_node-initialization-code.patch
mm-slab-factor-out-kmem_cache_node-initialization-code-fix.patch
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

