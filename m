From: akpm@linux-foundation.org
Subject: + mm-slab-re-implement-pfmemalloc-support-v2.patch added to -mm
 tree
Date: Fri, 12 Feb 2016 13:26:51 -0800
Message-ID: <56be4e1b.8Dyjaor/ISvp0w/i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbcBLV0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Feb 2016 16:26:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, mgorman@techsingularity.net, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slab-re-implement-pfmemalloc-support-v2
has been added to the -mm tree.  Its filename is
     mm-slab-re-implement-pfmemalloc-support-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-re-implement-pfmemalloc-support-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-re-implement-pfmemalloc-support-v2.patch

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
@@ -594,23 +594,20 @@ static struct array_cache *alloc_arrayca
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
@@ -2762,10 +2759,6 @@ static noinline void *cache_alloc_pfmema
 	if (!gfp_pfmemalloc_allowed(flags))
 		return NULL;
 
-	/* Racy check if there is free objects */
-	if (!n->free_objects)
-		return NULL;
-
 	spin_lock(&n->list_lock);
 	page = get_first_slab(n, true);
 	if (!page) {
@@ -3354,8 +3347,12 @@ static inline void __cache_free(struct k
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
mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix.patch
mm-slab-re-implement-pfmemalloc-support.patch
mm-slab-re-implement-pfmemalloc-support-v2.patch
mm-slub-support-left-red-zone.patch
mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch

