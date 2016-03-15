From: akpm@linux-foundation.org
Subject: [folded-merged] mm-slab-re-implement-pfmemalloc-support-v2.patch
 removed from -mm tree
Date: Tue, 15 Mar 2016 14:37:09 -0700
Message-ID: <56e88085.gJ645FRmXNnG+YDO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbcCOVhK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:37:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, mgorman@techsingularity.net, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slab-re-implement-pfmemalloc-support-v2
has been removed from the -mm tree.  Its filename was
     mm-slab-re-implement-pfmemalloc-support-v2.patch

This patch was dropped because it was folded into mm-slab-re-implement-pfmemalloc-support.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm-slab-re-implement-pfmemalloc-support-v2

v2)
o remove racy check whether there is free object or not in kmem_cache_node
o fix leak case

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff -puN mm/slab.c~mm-slab-re-implement-pfmemalloc-support-v2 mm/slab.c
--- a/mm/slab.c~mm-slab-re-implement-pfmemalloc-support-v2
+++ a/mm/slab.c
@@ -597,23 +597,20 @@ static struct array_cache *alloc_arrayca
 }
 
 static noinline void cache_free_pfmemalloc(struct kmem_cache *cachep,
-					void *objp)
+					struct page *page, void *objp)
 {
-	struct page *page = virt_to_head_page(objp);
 	struct kmem_cache_node *n;
 	int page_node;
 	LIST_HEAD(list);
 
-	if (unlikely(PageSlabPfmemalloc(page))) {
-		page_node = page_to_nid(page);
-		n = get_node(cachep, page_node);
+	page_node = page_to_nid(page);
+	n = get_node(cachep, page_node);
 
-		spin_lock(&n->list_lock);
-		free_block(cachep, &objp, 1, page_node, &list);
-		spin_unlock(&n->list_lock);
+	spin_lock(&n->list_lock);
+	free_block(cachep, &objp, 1, page_node, &list);
+	spin_unlock(&n->list_lock);
 
-		slabs_destroy(cachep, &list);
-	}
+	slabs_destroy(cachep, &list);
 }
 
 /*
@@ -2765,10 +2762,6 @@ static noinline void *cache_alloc_pfmema
 	if (!gfp_pfmemalloc_allowed(flags))
 		return NULL;
 
-	/* Racy check if there is free objects */
-	if (!n->free_objects)
-		return NULL;
-
 	spin_lock(&n->list_lock);
 	page = get_first_slab(n, true);
 	if (!page) {
@@ -3357,8 +3350,12 @@ static inline void __cache_free(struct k
 	}
 
 	if (sk_memalloc_socks()) {
-		cache_free_pfmemalloc(cachep, objp);
-		return;
+		struct page *page = virt_to_head_page(objp);
+
+		if (unlikely(PageSlabPfmemalloc(page))) {
+			cache_free_pfmemalloc(cachep, page, objp);
+			return;
+		}
 	}
 
 	ac->entry[ac->avail++] = objp;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch
mm-slab-avoid-returning-values-by-reference.patch
mm-slab-re-implement-pfmemalloc-support.patch
mm-slub-support-left-red-zone.patch
mm-slub-support-left-red-zone-fix.patch
mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch

