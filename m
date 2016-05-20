From: akpm@linux-foundation.org
Subject: [patch 113/117] mm, page_alloc: defer debugging checks of freed
 pages until a PCP drain
Date: Thu, 19 May 2016 17:14:32 -0700
Message-ID: <573e56e8.abhK/rU8HOcjf9jc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbcETAOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:14:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: defer debugging checks of freed pages until a PCP drain

Every page free checks a number of page fields for validity.  This catches
premature frees and corruptions but it is also expensive.  This patch
weakens the debugging check by checking PCP pages at the time they are
drained from the PCP list.  This will trigger the bug but the site that
freed the corrupt page will be lost.  To get the full context, a kernel
rebuild with DEBUG_VM is necessary.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  152 ++++++++++++++++++++++++++++++----------------
 1 file changed, 101 insertions(+), 51 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain
+++ a/mm/page_alloc.c
@@ -941,6 +941,103 @@ static inline int free_pages_check(struc
 	return 1;
 }
 
+static int free_tail_pages_check(struct page *head_page, struct page *page)
+{
+	int ret = 1;
+
+	/*
+	 * We rely page->lru.next never has bit 0 set, unless the page
+	 * is PageTail(). Let's make sure that's true even for poisoned ->lru.
+	 */
+	BUILD_BUG_ON((unsigned long)LIST_POISON1 & 1);
+
+	if (!IS_ENABLED(CONFIG_DEBUG_VM)) {
+		ret = 0;
+		goto out;
+	}
+	switch (page - head_page) {
+	case 1:
+		/* the first tail page: ->mapping is compound_mapcount() */
+		if (unlikely(compound_mapcount(page))) {
+			bad_page(page, "nonzero compound_mapcount", 0);
+			goto out;
+		}
+		break;
+	case 2:
+		/*
+		 * the second tail page: ->mapping is
+		 * page_deferred_list().next -- ignore value.
+		 */
+		break;
+	default:
+		if (page->mapping != TAIL_MAPPING) {
+			bad_page(page, "corrupted mapping in tail page", 0);
+			goto out;
+		}
+		break;
+	}
+	if (unlikely(!PageTail(page))) {
+		bad_page(page, "PageTail not set", 0);
+		goto out;
+	}
+	if (unlikely(compound_head(page) != head_page)) {
+		bad_page(page, "compound_head not consistent", 0);
+		goto out;
+	}
+	ret = 0;
+out:
+	page->mapping = NULL;
+	clear_compound_head(page);
+	return ret;
+}
+
+static bool free_pages_prepare(struct page *page, unsigned int order);
+
+#ifdef CONFIG_DEBUG_VM
+static inline bool free_pcp_prepare(struct page *page)
+{
+	return free_pages_prepare(page, 0);
+}
+
+static inline bool bulkfree_pcp_prepare(struct page *page)
+{
+	return false;
+}
+#else
+static bool free_pcp_prepare(struct page *page)
+{
+	VM_BUG_ON_PAGE(PageTail(page), page);
+
+	trace_mm_page_free(page, 0);
+	kmemcheck_free_shadow(page, 0);
+	kasan_free_pages(page, 0);
+
+	if (PageAnonHead(page))
+		page->mapping = NULL;
+
+	reset_page_owner(page, 0);
+
+	if (!PageHighMem(page)) {
+		debug_check_no_locks_freed(page_address(page),
+					   PAGE_SIZE);
+		debug_check_no_obj_freed(page_address(page),
+					   PAGE_SIZE);
+	}
+	arch_free_page(page, 0);
+	kernel_poison_pages(page, 0, 0);
+	kernel_map_pages(page, 0, 0);
+
+	page_cpupid_reset_last(page);
+	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	return true;
+}
+
+static bool bulkfree_pcp_prepare(struct page *page)
+{
+	return free_pages_check(page);
+}
+#endif /* CONFIG_DEBUG_VM */
+
 /*
  * Frees a number of pages from the PCP lists
  * Assumes all pages on list are in same zone, and of same order.
@@ -1002,6 +1099,9 @@ static void free_pcppages_bulk(struct zo
 			if (unlikely(isolated_pageblocks))
 				mt = get_pageblock_migratetype(page);
 
+			if (bulkfree_pcp_prepare(page))
+				continue;
+
 			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
 		} while (--count && --batch_free && !list_empty(list));
@@ -1028,56 +1128,6 @@ static void free_one_page(struct zone *z
 	spin_unlock(&zone->lock);
 }
 
-static int free_tail_pages_check(struct page *head_page, struct page *page)
-{
-	int ret = 1;
-
-	/*
-	 * We rely page->lru.next never has bit 0 set, unless the page
-	 * is PageTail(). Let's make sure that's true even for poisoned ->lru.
-	 */
-	BUILD_BUG_ON((unsigned long)LIST_POISON1 & 1);
-
-	if (!IS_ENABLED(CONFIG_DEBUG_VM)) {
-		ret = 0;
-		goto out;
-	}
-	switch (page - head_page) {
-	case 1:
-		/* the first tail page: ->mapping is compound_mapcount() */
-		if (unlikely(compound_mapcount(page))) {
-			bad_page(page, "nonzero compound_mapcount", 0);
-			goto out;
-		}
-		break;
-	case 2:
-		/*
-		 * the second tail page: ->mapping is
-		 * page_deferred_list().next -- ignore value.
-		 */
-		break;
-	default:
-		if (page->mapping != TAIL_MAPPING) {
-			bad_page(page, "corrupted mapping in tail page", 0);
-			goto out;
-		}
-		break;
-	}
-	if (unlikely(!PageTail(page))) {
-		bad_page(page, "PageTail not set", 0);
-		goto out;
-	}
-	if (unlikely(compound_head(page) != head_page)) {
-		bad_page(page, "compound_head not consistent", 0);
-		goto out;
-	}
-	ret = 0;
-out:
-	page->mapping = NULL;
-	clear_compound_head(page);
-	return ret;
-}
