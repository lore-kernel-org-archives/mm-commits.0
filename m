From: akpm@linux-foundation.org
Subject: [patch 19/27] mm: rename __alloc_page_frag to page_frag_alloc and __free_page_frag to page_frag_free
Date: Tue, 10 Jan 2017 16:58:06 -0800
Message-ID: <5875831e.I0U55U/utISsPQg/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33484 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760141AbdAKA6I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2017 19:58:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com

From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: mm: rename __alloc_page_frag to page_frag_alloc and __free_page_frag to page_frag_free

Patch series "Page fragment updates", v4.

This patch series takes care of a few cleanups for the page fragments API.

First we do some renames so that things are much more consistent.  First
we move the page_frag_ portion of the name to the front of the functions
names.  Secondly we split out the cache specific functions from the other
page fragment functions by adding the word "cache" to the name.

Finally I added a bit of documentation that will hopefully help to explain
some of this.  I plan to revisit this later as we get things more ironed
out in the near future with the changes planned for the DMA setup to
support eXpress Data Path.


This patch (of 3):

This patch renames the page frag functions to be more consistent with
other APIs.  Specifically we place the name page_frag first in the name
and then have either an alloc or free call name that we append as the
suffix.  This makes it a bit clearer in terms of naming.

In addition we drop the leading double underscores since we are technically
no longer a backing interface and instead the front end that is called from
the networking APIs.

Link: http://lkml.kernel.org/r/20170104023854.13451.67390.stgit@localhost.localdomain
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |    6 +++---
 include/linux/skbuff.h |    2 +-
 mm/page_alloc.c        |   10 +++++-----
 net/core/skbuff.c      |    8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff -puN include/linux/gfp.h~mm-rename-__alloc_page_frag-to-page_frag_alloc-and-__free_page_frag-to-page_frag_free include/linux/gfp.h
--- a/include/linux/gfp.h~mm-rename-__alloc_page_frag-to-page_frag_alloc-and-__free_page_frag-to-page_frag_free
+++ a/include/linux/gfp.h
@@ -501,9 +501,9 @@ extern void free_hot_cold_page_list(stru
 struct page_frag_cache;
 extern void __page_frag_drain(struct page *page, unsigned int order,
 			      unsigned int count);
-extern void *__alloc_page_frag(struct page_frag_cache *nc,
-			       unsigned int fragsz, gfp_t gfp_mask);
-extern void __free_page_frag(void *addr);
+extern void *page_frag_alloc(struct page_frag_cache *nc,
+			     unsigned int fragsz, gfp_t gfp_mask);
+extern void page_frag_free(void *addr);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
diff -puN include/linux/skbuff.h~mm-rename-__alloc_page_frag-to-page_frag_alloc-and-__free_page_frag-to-page_frag_free include/linux/skbuff.h
--- a/include/linux/skbuff.h~mm-rename-__alloc_page_frag-to-page_frag_alloc-and-__free_page_frag-to-page_frag_free
+++ a/include/linux/skbuff.h
@@ -2480,7 +2480,7 @@ static inline struct sk_buff *netdev_all
 
 static inline void skb_free_frag(void *addr)
 {
-	__free_page_frag(addr);
+	page_frag_free(addr);
 }
 
 void *napi_alloc_frag(unsigned int fragsz);
diff -puN mm/page_alloc.c~mm-rename-__alloc_page_frag-to-page_frag_alloc-and-__free_page_frag-to-page_frag_free mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-__alloc_page_frag-to-page_frag_alloc-and-__free_page_frag-to-page_frag_free
+++ a/mm/page_alloc.c
@@ -3931,8 +3931,8 @@ void __page_frag_drain(struct page *page
 }
 EXPORT_SYMBOL(__page_frag_drain);
 
-void *__alloc_page_frag(struct page_frag_cache *nc,
-			unsigned int fragsz, gfp_t gfp_mask)
+void *page_frag_alloc(struct page_frag_cache *nc,
+		      unsigned int fragsz, gfp_t gfp_mask)
 {
 	unsigned int size = PAGE_SIZE;
 	struct page *page;
@@ -3983,19 +3983,19 @@ refill:
 
 	return nc->va + offset;
 }
-EXPORT_SYMBOL(__alloc_page_frag);
+EXPORT_SYMBOL(page_frag_alloc);
 
 /*
  * Frees a page fragment allocated out of either a compound or order 0 page.
  */
-void __free_page_frag(void *addr)
+void page_frag_free(void *addr)
 {
 	struct page *page = virt_to_head_page(addr);
 
 	if (unlikely(put_page_testzero(page)))
 		__free_pages_ok(page, compound_order(page));
 }
-EXPORT_SYMBOL(__free_page_frag);
+EXPORT_SYMBOL(page_frag_free);
 
 static void *make_alloc_exact(unsigned long addr, unsigned int order,
 		size_t size)
diff -puN net/core/skbuff.c~mm-rename-__alloc_page_frag-to-page_frag_alloc-and-__free_page_frag-to-page_frag_free net/core/skbuff.c
--- a/net/core/skbuff.c~mm-rename-__alloc_page_frag-to-page_frag_alloc-and-__free_page_frag-to-page_frag_free
+++ a/net/core/skbuff.c
@@ -369,7 +369,7 @@ static void *__netdev_alloc_frag(unsigne
 
 	local_irq_save(flags);
 	nc = this_cpu_ptr(&netdev_alloc_cache);
-	data = __alloc_page_frag(nc, fragsz, gfp_mask);
+	data = page_frag_alloc(nc, fragsz, gfp_mask);
 	local_irq_restore(flags);
 	return data;
 }
@@ -391,7 +391,7 @@ static void *__napi_alloc_frag(unsigned
 {
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
 
-	return __alloc_page_frag(&nc->page, fragsz, gfp_mask);
+	return page_frag_alloc(&nc->page, fragsz, gfp_mask);
 }
 
 void *napi_alloc_frag(unsigned int fragsz)
@@ -441,7 +441,7 @@ struct sk_buff *__netdev_alloc_skb(struc
 	local_irq_save(flags);
 
 	nc = this_cpu_ptr(&netdev_alloc_cache);
-	data = __alloc_page_frag(nc, len, gfp_mask);
+	data = page_frag_alloc(nc, len, gfp_mask);
 	pfmemalloc = nc->pfmemalloc;
 
 	local_irq_restore(flags);
@@ -505,7 +505,7 @@ struct sk_buff *__napi_alloc_skb(struct
 	if (sk_memalloc_socks())
 		gfp_mask |= __GFP_MEMALLOC;
 
-	data = __alloc_page_frag(&nc->page, len, gfp_mask);
+	data = page_frag_alloc(&nc->page, len, gfp_mask);
 	if (unlikely(!data))
 		return NULL;
 
_
