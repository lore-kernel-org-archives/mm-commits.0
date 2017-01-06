From: akpm@linux-foundation.org
Subject: +
 mm-rename-__page_frag-functions-to-__page_frag_cache-drop-order-from-drain.patch added to -mm tree
Date: Thu, 05 Jan 2017 16:00:13 -0800
Message-ID: <586ede0d.VFBvO7W5OfzpLITl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966421AbdAFAgm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 19:36:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename __page_frag functions to __page_frag_cache, drop order from drain
has been added to the -mm tree.  Its filename is
     mm-rename-__page_frag-functions-to-__page_frag_cache-drop-order-from-drain.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-__page_frag-functions-to-__page_frag_cache-drop-order-from-drain.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-__page_frag-functions-to-__page_frag_cache-drop-order-from-drain.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: mm: rename __page_frag functions to __page_frag_cache, drop order from drain

This patch does two things.

First it goes through and renames the __page_frag prefixed functions to
__page_frag_cache so that we can be clear that we are draining or
refilling the cache, not the frags themselves.

Second we drop the order parameter from __page_frag_cache_drain since we
don't actually need to pass it since all fragments are either order 0 or
must be a compound page.

Link: http://lkml.kernel.org/r/20170104023954.13451.5678.stgit@localhost.localdomain
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/intel/igb/igb_main.c |    6 +++---
 include/linux/gfp.h                       |    3 +--
 mm/page_alloc.c                           |   13 +++++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/net/ethernet/intel/igb/igb_main.c~mm-rename-__page_frag-functions-to-__page_frag_cache-drop-order-from-drain drivers/net/ethernet/intel/igb/igb_main.c
--- a/drivers/net/ethernet/intel/igb/igb_main.c~mm-rename-__page_frag-functions-to-__page_frag_cache-drop-order-from-drain
+++ a/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3962,8 +3962,8 @@ static void igb_clean_rx_ring(struct igb
 				     PAGE_SIZE,
 				     DMA_FROM_DEVICE,
 				     DMA_ATTR_SKIP_CPU_SYNC);
-		__page_frag_drain(buffer_info->page, 0,
-				  buffer_info->pagecnt_bias);
+		__page_frag_cache_drain(buffer_info->page,
+					buffer_info->pagecnt_bias);
 
 		buffer_info->page = NULL;
 	}
@@ -6991,7 +6991,7 @@ static struct sk_buff *igb_fetch_rx_buff
 		dma_unmap_page_attrs(rx_ring->dev, rx_buffer->dma,
 				     PAGE_SIZE, DMA_FROM_DEVICE,
 				     DMA_ATTR_SKIP_CPU_SYNC);
-		__page_frag_drain(page, 0, rx_buffer->pagecnt_bias);
+		__page_frag_cache_drain(page, rx_buffer->pagecnt_bias);
 	}
 
 	/* clear contents of rx_buffer */
diff -puN include/linux/gfp.h~mm-rename-__page_frag-functions-to-__page_frag_cache-drop-order-from-drain include/linux/gfp.h
--- a/include/linux/gfp.h~mm-rename-__page_frag-functions-to-__page_frag_cache-drop-order-from-drain
+++ a/include/linux/gfp.h
@@ -499,8 +499,7 @@ extern void free_hot_cold_page(struct pa
 extern void free_hot_cold_page_list(struct list_head *list, bool cold);
 
 struct page_frag_cache;
-extern void __page_frag_drain(struct page *page, unsigned int order,
-			      unsigned int count);
+extern void __page_frag_cache_drain(struct page *page, unsigned int count);
 extern void *page_frag_alloc(struct page_frag_cache *nc,
 			     unsigned int fragsz, gfp_t gfp_mask);
 extern void page_frag_free(void *addr);
diff -puN mm/page_alloc.c~mm-rename-__page_frag-functions-to-__page_frag_cache-drop-order-from-drain mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-__page_frag-functions-to-__page_frag_cache-drop-order-from-drain
+++ a/mm/page_alloc.c
@@ -3896,8 +3896,8 @@ EXPORT_SYMBOL(free_pages);
  * drivers to provide a backing region of memory for use as either an
  * sk_buff->head, or to be used in the "frags" portion of skb_shared_info.
  */
-static struct page *__page_frag_refill(struct page_frag_cache *nc,
-				       gfp_t gfp_mask)
+static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
+					     gfp_t gfp_mask)
 {
 	struct page *page = NULL;
 	gfp_t gfp = gfp_mask;
@@ -3917,19 +3917,20 @@ static struct page *__page_frag_refill(s
 	return page;
 }
 
-void __page_frag_drain(struct page *page, unsigned int order,
-		       unsigned int count)
+void __page_frag_cache_drain(struct page *page, unsigned int count)
 {
 	VM_BUG_ON_PAGE(page_ref_count(page) == 0, page);
 
 	if (page_ref_sub_and_test(page, count)) {
+		unsigned int order = compound_order(page);
+
 		if (order == 0)
 			free_hot_cold_page(page, false);
 		else
 			__free_pages_ok(page, order);
 	}
 }
-EXPORT_SYMBOL(__page_frag_drain);
+EXPORT_SYMBOL(__page_frag_cache_drain);
 
 void *page_frag_alloc(struct page_frag_cache *nc,
 		      unsigned int fragsz, gfp_t gfp_mask)
@@ -3940,7 +3941,7 @@ void *page_frag_alloc(struct page_frag_c
 
 	if (unlikely(!nc->va)) {
 refill:
-		page = __page_frag_refill(nc, gfp_mask);
+		page = __page_frag_cache_refill(nc, gfp_mask);
 		if (!page)
 			return NULL;
 
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are

mm-rename-__alloc_page_frag-to-page_frag_alloc-and-__free_page_frag-to-page_frag_free.patch
mm-rename-__page_frag-functions-to-__page_frag_cache-drop-order-from-drain.patch
mm-add-documentation-for-page-fragment-apis.patch

