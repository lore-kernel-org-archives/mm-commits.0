From: akpm@linux-foundation.org
Subject: [merged] mm-slabc-add-a-helper-function-get_first_slab.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:32:08 -0800
Message-ID: <56997368.SBwsxBH90zoVv8i7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbcAOWcJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: add a helper function get_first_slab
has been removed from the -mm tree.  Its filename was
     mm-slabc-add-a-helper-function-get_first_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm/slab.c: add a helper function get_first_slab

Add a new helper function get_first_slab() that get the first slab from a
kmem_cache_node.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff -puN mm/slab.c~mm-slabc-add-a-helper-function-get_first_slab mm/slab.c
--- a/mm/slab.c~mm-slabc-add-a-helper-function-get_first_slab
+++ a/mm/slab.c
@@ -2756,6 +2756,21 @@ static void *cache_free_debugcheck(struc
 #define cache_free_debugcheck(x,objp,z) (objp)
 #endif
 
+static struct page *get_first_slab(struct kmem_cache_node *n)
+{
+	struct page *page;
+
+	page = list_first_entry_or_null(&n->slabs_partial,
+			struct page, lru);
+	if (!page) {
+		n->free_touched = 1;
+		page = list_first_entry_or_null(&n->slabs_free,
+				struct page, lru);
+	}
+
+	return page;
+}
+
 static void *cache_alloc_refill(struct kmem_cache *cachep, gfp_t flags,
 							bool force_refill)
 {
@@ -2793,15 +2808,9 @@ retry:
 	while (batchcount > 0) {
 		struct page *page;
 		/* Get slab alloc is to come from. */
-		page = list_first_entry_or_null(&n->slabs_partial,
-				struct page, lru);
-		if (!page) {
-			n->free_touched = 1;
-			page = list_first_entry_or_null(&n->slabs_free,
-					struct page, lru);
-			if (!page)
-				goto must_grow;
-		}
+		page = get_first_slab(n);
+		if (!page)
+			goto must_grow;
 
 		check_spinlock_acquired(cachep);
 
@@ -3097,15 +3106,9 @@ static void *____cache_alloc_node(struct
 retry:
 	check_irq_off();
 	spin_lock(&n->list_lock);
-	page = list_first_entry_or_null(&n->slabs_partial,
-			struct page, lru);
-	if (!page) {
-		n->free_touched = 1;
-		page = list_first_entry_or_null(&n->slabs_free,
-				struct page, lru);
-		if (!page)
-			goto must_grow;
-	}
+	page = get_first_slab(n);
+	if (!page)
+		goto must_grow;
 
 	check_spinlock_acquired_node(cachep, nodeid);
 
_

Patches currently in -mm which might be from geliangtang@163.com are

mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch
mm-move-lru_to_page-to-mm_inlineh.patch
mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch
rapidio-use-kobj_to_dev.patch
dma-mapping-use-offset_in_page-macro.patch

