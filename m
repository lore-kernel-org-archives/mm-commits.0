Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D55AC727A1
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244144AbjHXXWj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244114AbjHXXWJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96480A1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34F7E64FED
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B76FC433C8;
        Thu, 24 Aug 2023 23:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919326;
        bh=FAnEuS6W97QH+cUcNbTCwn9uZUDGtRtXLxgsbRBw9xw=;
        h=Date:To:From:Subject:From;
        b=ybF+nqG54Yw9lppFj4+ucLx5vETViTBVq+spcSgNCg0qnE9aycn5DU64f+ncBT3qC
         7tDFTuVRvgy3P2hZzgV/ofSYRtfMdJ4S+FEE6yGq0DKIM4OVcMPxECE82sCm70gymy
         x8dQPjWVvVz4SJBK0zC8c9EGJxXNcaPxB2FuZXT0=
Date:   Thu, 24 Aug 2023 16:22:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com, peterx@redhat.com,
        hughd@google.com, ddstreet@ieee.org, chrisl@kernel.org,
        catalin.marinas@arm.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-work-on-folio-swap-instead-of-page-private-when-splitting-folio.patch removed from -mm tree
Message-Id: <20230824232206.8B76FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: work on folio->swap instead of page->private when splitting folio
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-work-on-folio-swap-instead-of-page-private-when-splitting-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: work on folio->swap instead of page->private when splitting folio
Date: Mon, 21 Aug 2023 18:08:49 +0200

Let's work on folio->swap instead.  While at it, use folio_test_anon() and
folio_test_swapcache() -- the original folio remains valid even after
splitting (but is then an order-0 folio).

We can probably convert a lot more to folios in that code, let's focus on
folio->swap handling only for now.

Link: https://lkml.kernel.org/r/20230821160849.531668-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Chris Li <chrisl@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-work-on-folio-swap-instead-of-page-private-when-splitting-folio
+++ a/mm/huge_memory.c
@@ -2401,10 +2401,16 @@ static void lru_add_page_tail(struct pag
 	}
 }
 
-static void __split_huge_page_tail(struct page *head, int tail,
+static void __split_huge_page_tail(struct folio *folio, int tail,
 		struct lruvec *lruvec, struct list_head *list)
 {
+	struct page *head = &folio->page;
 	struct page *page_tail = head + tail;
+	/*
+	 * Careful: new_folio is not a "real" folio before we cleared PageTail.
+	 * Don't pass it around before clear_compound_head().
+	 */
+	struct folio *new_folio = (struct folio *)page_tail;
 
 	VM_BUG_ON_PAGE(atomic_read(&page_tail->_mapcount) != -1, page_tail);
 
@@ -2453,8 +2459,8 @@ static void __split_huge_page_tail(struc
 		VM_WARN_ON_ONCE_PAGE(true, page_tail);
 		page_tail->private = 0;
 	}
-	if (PageSwapCache(head))
-		set_page_private(page_tail, (unsigned long)head->private + tail);
+	if (folio_test_swapcache(folio))
+		new_folio->swap.val = folio->swap.val + tail;
 
 	/* Page flags must be visible before we make the page non-compound. */
 	smp_wmb();
@@ -2500,11 +2506,9 @@ static void __split_huge_page(struct pag
 	/* complete memcg works before add pages to LRU */
 	split_page_memcg(head, nr);
 
-	if (PageAnon(head) && PageSwapCache(head)) {
-		swp_entry_t entry = { .val = page_private(head) };
-
-		offset = swp_offset(entry);
-		swap_cache = swap_address_space(entry);
+	if (folio_test_anon(folio) && folio_test_swapcache(folio)) {
+		offset = swp_offset(folio->swap);
+		swap_cache = swap_address_space(folio->swap);
 		xa_lock(&swap_cache->i_pages);
 	}
 
@@ -2514,7 +2518,7 @@ static void __split_huge_page(struct pag
 	ClearPageHasHWPoisoned(head);
 
 	for (i = nr - 1; i >= 1; i--) {
-		__split_huge_page_tail(head, i, lruvec, list);
+		__split_huge_page_tail(folio, i, lruvec, list);
 		/* Some pages can be beyond EOF: drop them from page cache */
 		if (head[i].index >= end) {
 			struct folio *tail = page_folio(head + i);
@@ -2559,11 +2563,8 @@ static void __split_huge_page(struct pag
 
 	remap_page(folio, nr);
 
-	if (PageSwapCache(head)) {
-		swp_entry_t entry = { .val = page_private(head) };
-
-		split_swap_cluster(entry);
-	}
+	if (folio_test_swapcache(folio))
+		split_swap_cluster(folio->swap);
 
 	for (i = 0; i < nr; i++) {
 		struct page *subpage = head + i;
_

Patches currently in -mm which might be from david@redhat.com are


