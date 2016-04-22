From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-slab-clean-up-kmem_cache_node-setup-fix.patch
 removed from -mm tree
Date: Fri, 22 Apr 2016 14:56:19 -0700
Message-ID: <571a9e03.n/2pNRxbKdRhNVGE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbcDVV4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 17:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, Valdis.Kletnieks@vt.edu, jonathanh@nvidia.com, nm@ti.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: clean-up kmem_cache_node setup-fix
has been removed from the -mm tree.  Its filename was
     mm-slab-clean-up-kmem_cache_node-setup-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: clean-up kmem_cache_node setup-fix

After calling free_block(), we need to re-calculate array_cache's
avail counter. Fix it.

And, it's better to free objects in shared array when it is
really necessary. Check it before calling free_block().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Nishanth Menon <nm@ti.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-clean-up-kmem_cache_node-setup-fix mm/slab.c
--- a/mm/slab.c~mm-slab-clean-up-kmem_cache_node-setup-fix
+++ a/mm/slab.c
@@ -934,9 +934,10 @@ static int setup_kmem_cache_node(struct
 
 	n = get_node(cachep, node);
 	spin_lock_irq(&n->list_lock);
-	if (n->shared) {
+	if (n->shared && force_change) {
 		free_block(cachep, n->shared->entry,
 				n->shared->avail, node, &list);
+		n->shared->avail = 0;
 	}
 
 	if (!n->shared || force_change) {
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

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

