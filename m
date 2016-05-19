From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch removed from -mm tree
Date: Thu, 19 May 2016 16:57:32 -0700
Message-ID: <573e52ec.7j21+C46oVhfZWbE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbcESX5d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:57:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

This patch was dropped because it was folded into mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix

mm/page_alloc.c:995: warning: 'free_pages_prepare' declared inline after being called
mm/page_alloc.c:995: warning: previous declaration of 'free_pages_prepare' was here

Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  111 ++++++++++++++++++++++------------------------
 1 file changed, 54 insertions(+), 57 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix
+++ a/mm/page_alloc.c
@@ -991,8 +991,60 @@ out:
 	return ret;
 }
 
-static bool free_pages_prepare(struct page *page, unsigned int order,
-			       bool check_free);
+static __always_inline bool free_pages_prepare(struct page *page,
+					unsigned int order, bool check_free)
+{
+	int bad = 0;
+
+	VM_BUG_ON_PAGE(PageTail(page), page);
+
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
+
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
+	if (PageAnonHead(page))
+		page->mapping = NULL;
+	if (check_free)
+		bad += free_pages_check(page);
+	if (bad)
+		return false;
+
+	page_cpupid_reset_last(page);
+	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	reset_page_owner(page, order);
+
+	if (!PageHighMem(page)) {
+		debug_check_no_locks_freed(page_address(page),
+					   PAGE_SIZE << order);
+		debug_check_no_obj_freed(page_address(page),
+					   PAGE_SIZE << order);
+	}
+	arch_free_page(page, order);
+	kernel_poison_pages(page, 1 << order, 0);
+	kernel_map_pages(page, 1 << order, 0);
+
+	return true;
+}
 
 #ifdef CONFIG_DEBUG_VM
 static inline bool free_pcp_prepare(struct page *page)
@@ -1179,61 +1231,6 @@ void __meminit reserve_bootmem_region(un
 	}
 }
 
-static __always_inline bool free_pages_prepare(struct page *page,
-					unsigned int order, bool check_free)
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
-	if (check_free)
-		bad += free_pages_check(page);
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
