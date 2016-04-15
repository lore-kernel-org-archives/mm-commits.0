From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch added to -mm tree
Date: Fri, 15 Apr 2016 16:12:37 -0700
Message-ID: <57117565.3Qk6mNkRKfuQI1m9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbcDOXMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 19:12:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: defer debugging checks of freed pages until a PCP drain
has been added to the -mm tree.  Its filename is
     mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: defer debugging checks of freed pages until a PCP drain

Every page free checks a number of page fields for validity.  This catches
premature frees and corruptions but it is also expensive.  This patch
weakens the debugging check by checking PCP pages at the time they are
drained from the PCP list.  This will trigger the bug but the site that
freed the corrupt page will be lost.  To get the full context, a kernel
rebuild with DEBUG_VM is necessary.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  244 +++++++++++++++++++++++++++-------------------
 1 file changed, 146 insertions(+), 98 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain
+++ a/mm/page_alloc.c
@@ -939,6 +939,148 @@ static inline int free_pages_check(struc
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
+static bool free_pages_prepare(struct page *page, unsigned int order)
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
+	if (order) {
+		bool compound = PageCompound(page);
+		int i;
+
+		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
+
+		for (i = 1; i < (1 << order); i++) {
+			if (compound)
+				bad += free_tail_pages_check(page, page + i);
+			bad += free_pages_check(page + i);
+		}
+	}
+	if (PageAnonHead(page))
+		page->mapping = NULL;
+	bad += free_pages_check(page);
+	if (bad)
+		return false;
+
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
@@ -999,6 +1141,9 @@ static void free_pcppages_bulk(struct zo
 			if (unlikely(isolated_pageblocks))
 				mt = get_pageblock_migratetype(page);
 
+			if (bulkfree_pcp_prepare(page))
+				continue;
+
 			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
 		} while (--count && --batch_free && !list_empty(list));
@@ -1025,56 +1170,6 @@ static void free_one_page(struct zone *z
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
-
 static void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid)
 {
@@ -1148,53 +1243,6 @@ void __meminit reserve_bootmem_region(un
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
-	if (order) {
-		bool compound = PageCompound(page);
-		int i;
-
-		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
-
-		for (i = 1; i < (1 << order); i++) {
-			if (compound)
-				bad += free_tail_pages_check(page, page + i);
-			bad += free_pages_check(page + i);
-		}
-	}
-	if (PageAnonHead(page))
-		page->mapping = NULL;
-	bad += free_pages_check(page);
-	if (bad)
-		return false;
-
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
-
 static void __free_pages_ok(struct page *page, unsigned int order)
 {
 	unsigned long flags;
@@ -2330,7 +2378,7 @@ void free_hot_cold_page(struct page *pag
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
 
-	if (!free_pages_prepare(page, 0))
+	if (!free_pcp_prepare(page))
 		return;
 
 	migratetype = get_pfnblock_migratetype(page, pfn);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-only-check-pagecompound-for-high-order-pages.patch
mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path.patch
mm-page_alloc-reduce-branches-in-zone_statistics.patch
mm-page_alloc-inline-zone_statistics.patch
mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch
mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch
mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch
mm-page_alloc-convert-alloc_flags-to-unsigned.patch
mm-page_alloc-convert-nr_fair_skipped-to-bool.patch
mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist.patch
mm-page_alloc-remove-unnecessary-initialisation-in-get_page_from_freelist.patch
mm-page_alloc-remove-redundant-check-for-empty-zonelist.patch
mm-page_alloc-simplify-last-cpupid-reset.patch
mm-page_alloc-move-might_sleep_if-check-to-the-allocator-slowpath.patch
mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath.patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks.patch
mm-page_alloc-shorten-the-page-allocator-fast-path.patch
mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch
mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch
mm-page_alloc-remove-field-from-alloc_context.patch
mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch
mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk.patch
mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch

