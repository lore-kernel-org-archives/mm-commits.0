From: akpm@linux-foundation.org
Subject: [patch 115/117] mm, page_alloc: don't duplicate code in
 free_pcp_prepare
Date: Thu, 19 May 2016 17:14:38 -0700
Message-ID: <573e56ee.qVh34To8CwyfiFYk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbcETAOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: don't duplicate code in free_pcp_prepare

The new free_pcp_prepare() function shares a lot of code with
free_pages_prepare(), which makes this a maintenance risk when some future
patch modifies only one of them. We should be able to achieve the same effect
(skipping free_pages_check() from !DEBUG_VM configs) by adding a parameter to
free_pages_prepare() and making it inline, so the checks (and the order != 0
parts) are eliminated from the call from free_pcp_prepare().

!DEBUG_VM: bloat-o-meter reports no difference, as my gcc was already inlining
free_pages_prepare() and the elimination seems to work as expected

DEBUG_VM bloat-o-meter:

add/remove: 0/1 grow/shrink: 2/0 up/down: 1035/-778 (257)
function                                     old     new   delta
__free_pages_ok                              297    1060    +763
free_hot_cold_page                           480     752    +272
free_pages_prepare                           778       -    -778

Here inlining didn't occur before, and added some code, but it's ok for a debug
option.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  133 +++++++++++++++++++---------------------------
 1 file changed, 55 insertions(+), 78 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare
+++ a/mm/page_alloc.c
@@ -991,47 +991,77 @@ out:
 	return ret;
 }
 
-static bool free_pages_prepare(struct page *page, unsigned int order);
-
-#ifdef CONFIG_DEBUG_VM
-static inline bool free_pcp_prepare(struct page *page)
+static __always_inline bool free_pages_prepare(struct page *page,
+					unsigned int order, bool check_free)
 {
-	return free_pages_prepare(page, 0);
-}
+	int bad = 0;
 
-static inline bool bulkfree_pcp_prepare(struct page *page)
-{
-	return false;
-}
-#else
-static bool free_pcp_prepare(struct page *page)
-{
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
-	trace_mm_page_free(page, 0);
-	kmemcheck_free_shadow(page, 0);
-	kasan_free_pages(page, 0);
+	trace_mm_page_free(page, order);
+	kmemcheck_free_shadow(page, order);
+	kasan_free_pages(page, order);
+
+	/*
+	 * Check tail pages before head page information is cleared to
+	 * avoid checking PageCompound for order-0 pages.
+	 */
+	if (unlikely(order)) {
+		bool compound = PageCompound(page);
+		int i;
+
+		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
+		for (i = 1; i < (1 << order); i++) {
+			if (compound)
+				bad += free_tail_pages_check(page, page + i);
+			if (unlikely(free_pages_check(page + i))) {
+				bad++;
+				continue;
+			}
+			(page + i)->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+		}
+	}
 	if (PageAnonHead(page))
 		page->mapping = NULL;
+	if (check_free)
+		bad += free_pages_check(page);
+	if (bad)
+		return false;
 
-	reset_page_owner(page, 0);
+	page_cpupid_reset_last(page);
+	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	reset_page_owner(page, order);
 
 	if (!PageHighMem(page)) {
 		debug_check_no_locks_freed(page_address(page),
-					   PAGE_SIZE);
+					   PAGE_SIZE << order);
 		debug_check_no_obj_freed(page_address(page),
-					   PAGE_SIZE);
+					   PAGE_SIZE << order);
 	}
-	arch_free_page(page, 0);
-	kernel_poison_pages(page, 0, 0);
-	kernel_map_pages(page, 0, 0);
+	arch_free_page(page, order);
+	kernel_poison_pages(page, 1 << order, 0);
+	kernel_map_pages(page, 1 << order, 0);
 
-	page_cpupid_reset_last(page);
-	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	return true;
 }
 
+#ifdef CONFIG_DEBUG_VM
+static inline bool free_pcp_prepare(struct page *page)
+{
+	return free_pages_prepare(page, 0, true);
+}
+
+static inline bool bulkfree_pcp_prepare(struct page *page)
+{
+	return false;
+}
+#else
+static bool free_pcp_prepare(struct page *page)
+{
+	return free_pages_prepare(page, 0, false);
+}
+
 static bool bulkfree_pcp_prepare(struct page *page)
 {
 	return free_pages_check(page);
@@ -1201,66 +1231,13 @@ void __meminit reserve_bootmem_region(un
 	}
 }
 
-static bool free_pages_prepare(struct page *page, unsigned int order)
-{
-	int bad = 0;
-
-	VM_BUG_ON_PAGE(PageTail(page), page);
-
-	trace_mm_page_free(page, order);
-	kmemcheck_free_shadow(page, order);
-	kasan_free_pages(page, order);
-
-	/*
-	 * Check tail pages before head page information is cleared to
-	 * avoid checking PageCompound for order-0 pages.
-	 */
-	if (unlikely(order)) {
-		bool compound = PageCompound(page);
-		int i;
-
-		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
-
-		for (i = 1; i < (1 << order); i++) {
-			if (compound)
-				bad += free_tail_pages_check(page, page + i);
-			if (unlikely(free_pages_check(page + i))) {
-				bad++;
-				continue;
-			}
-			(page + i)->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
-		}
-	}
-	if (PageAnonHead(page))
-		page->mapping = NULL;
-	bad += free_pages_check(page);
-	if (bad)
-		return false;
-
-	page_cpupid_reset_last(page);
-	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
-	reset_page_owner(page, order);
-
-	if (!PageHighMem(page)) {
-		debug_check_no_locks_freed(page_address(page),
-					   PAGE_SIZE << order);
-		debug_check_no_obj_freed(page_address(page),
-					   PAGE_SIZE << order);
-	}
-	arch_free_page(page, order);
-	kernel_poison_pages(page, 1 << order, 0);
-	kernel_map_pages(page, 1 << order, 0);
-
-	return true;
-}
