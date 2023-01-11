Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8847C5479D
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjAKU6a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjAKU63 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:58:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE479C11
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:58:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DF0E61E5D
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FA3C433EF;
        Wed, 11 Jan 2023 20:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470706;
        bh=EFB1arfkJwB20rUdnPOkXYk5GFhQk6h2iQNihaRRRyk=;
        h=Date:To:From:Subject:From;
        b=Eu4ti2Z/U7p3IenBSXcm86kyQaoewGyo9jEi7yigkEgdYv9rRtgpgeZPybIo6z3Aw
         vtM9fK43jSj/8R74E2CM8AHDd2m3nxyE6zJzVxRoO4j926SrZU7PFk7Ai79gjmOt09
         TE0bLN6OK2mDsdtBs6UcVdcP2EPiXG26UN6iz0v0=
Date:   Wed, 11 Jan 2023 12:58:26 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch added to mm-unstable branch
Message-Id: <20230111205826.D0FA3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert head_subpages_mapcount() into folio_nr_pages_mapped()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert head_subpages_mapcount() into folio_nr_pages_mapped()
Date: Wed, 11 Jan 2023 14:28:48 +0000

Calling this 'mapcount' is confusing since mapcount is usually the number
of times something is mapped; instead this is the number of mapped pages. 
It's also better to enforce that this is a folio rather than a head page.

Move folio_nr_pages_mapped() into mm/internal.h since this is not
something we want device drivers or filesystems poking at.  Get rid of
folio_subpages_mapcount_ptr() and use folio->_nr_pages_mapped directly.

Link: https://lkml.kernel.org/r/20230111142915.1001531-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   22 ++--------------------
 include/linux/mm_types.h |   12 +++---------
 mm/debug.c               |    4 ++--
 mm/hugetlb.c             |    4 ++--
 mm/internal.h            |   18 ++++++++++++++++++
 mm/rmap.c                |    9 +++++----
 6 files changed, 32 insertions(+), 37 deletions(-)

--- a/include/linux/mm.h~mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped
+++ a/include/linux/mm.h
@@ -844,24 +844,6 @@ static inline int head_compound_mapcount
 }
 
 /*
- * If a 16GB hugetlb page were mapped by PTEs of all of its 4kB sub-pages,
- * its subpages_mapcount would be 0x400000: choose the COMPOUND_MAPPED bit
- * above that range, instead of 2*(PMD_SIZE/PAGE_SIZE).  Hugetlb currently
- * leaves subpages_mapcount at 0, but avoid surprise if it participates later.
- */
-#define COMPOUND_MAPPED	0x800000
-#define SUBPAGES_MAPPED	(COMPOUND_MAPPED - 1)
-
-/*
- * Number of sub-pages mapped by PTE, does not include compound mapcount.
- * Must be called only on head of compound page.
- */
-static inline int head_subpages_mapcount(struct page *head)
-{
-	return atomic_read(subpages_mapcount_ptr(head)) & SUBPAGES_MAPPED;
-}
-
-/*
  * The atomic page->_mapcount, starts from -1: so that transitions
  * both from it and to it can be tracked, using atomic_inc_and_test
  * and atomic_add_negative(-1).
@@ -920,9 +902,9 @@ static inline bool folio_large_is_mapped
 {
 	/*
 	 * Reading folio_mapcount_ptr() below could be omitted if hugetlb
-	 * participated in incrementing subpages_mapcount when compound mapped.
+	 * participated in incrementing nr_pages_mapped when compound mapped.
 	 */
-	return atomic_read(folio_subpages_mapcount_ptr(folio)) > 0 ||
+	return atomic_read(&folio->_nr_pages_mapped) > 0 ||
 		atomic_read(folio_mapcount_ptr(folio)) >= 0;
 }
 
--- a/include/linux/mm_types.h~mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped
+++ a/include/linux/mm_types.h
@@ -307,7 +307,7 @@ static inline struct page *encoded_page_
  * @_folio_dtor: Which destructor to use for this folio.
  * @_folio_order: Do not use directly, call folio_order().
  * @_compound_mapcount: Do not use directly, call folio_entire_mapcount().
- * @_subpages_mapcount: Do not use directly, call folio_mapcount().
+ * @_nr_pages_mapped: Do not use directly, call folio_mapcount().
  * @_pincount: Do not use directly, call folio_maybe_dma_pinned().
  * @_folio_nr_pages: Do not use directly, call folio_nr_pages().
  * @_flags_2: For alignment.  Do not use.
@@ -361,7 +361,7 @@ struct folio {
 			unsigned char _folio_dtor;
 			unsigned char _folio_order;
 			atomic_t _compound_mapcount;
-			atomic_t _subpages_mapcount;
+			atomic_t _nr_pages_mapped;
 			atomic_t _pincount;
 #ifdef CONFIG_64BIT
 			unsigned int _folio_nr_pages;
@@ -404,7 +404,7 @@ FOLIO_MATCH(compound_head, _head_1);
 FOLIO_MATCH(compound_dtor, _folio_dtor);
 FOLIO_MATCH(compound_order, _folio_order);
 FOLIO_MATCH(compound_mapcount, _compound_mapcount);
-FOLIO_MATCH(subpages_mapcount, _subpages_mapcount);
+FOLIO_MATCH(subpages_mapcount, _nr_pages_mapped);
 FOLIO_MATCH(compound_pincount, _pincount);
 #ifdef CONFIG_64BIT
 FOLIO_MATCH(compound_nr, _folio_nr_pages);
@@ -427,12 +427,6 @@ static inline atomic_t *folio_mapcount_p
 	return &tail->compound_mapcount;
 }
 
-static inline atomic_t *folio_subpages_mapcount_ptr(struct folio *folio)
-{
-	struct page *tail = &folio->page + 1;
-	return &tail->subpages_mapcount;
-}
-
 static inline atomic_t *compound_mapcount_ptr(struct page *page)
 {
 	return &page[1].compound_mapcount;
--- a/mm/debug.c~mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped
+++ a/mm/debug.c
@@ -94,10 +94,10 @@ static void __dump_page(struct page *pag
 			page, page_ref_count(head), mapcount, mapping,
 			page_to_pgoff(page), page_to_pfn(page));
 	if (compound) {
-		pr_warn("head:%p order:%u compound_mapcount:%d subpages_mapcount:%d pincount:%d\n",
+		pr_warn("head:%p order:%u compound_mapcount:%d nr_pages_mapped:%d pincount:%d\n",
 				head, compound_order(head),
 				head_compound_mapcount(head),
-				head_subpages_mapcount(head),
+				folio_nr_pages_mapped(folio),
 				atomic_read(&folio->_pincount));
 	}
 
--- a/mm/hugetlb.c~mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped
+++ a/mm/hugetlb.c
@@ -1475,7 +1475,7 @@ static void __destroy_compound_gigantic_
 	struct page *p;
 
 	atomic_set(folio_mapcount_ptr(folio), 0);
-	atomic_set(folio_subpages_mapcount_ptr(folio), 0);
+	atomic_set(&folio->_nr_pages_mapped, 0);
 	atomic_set(&folio->_pincount, 0);
 
 	for (i = 1; i < nr_pages; i++) {
@@ -1997,7 +1997,7 @@ static bool __prep_compound_gigantic_fol
 			set_compound_head(p, &folio->page);
 	}
 	atomic_set(folio_mapcount_ptr(folio), -1);
-	atomic_set(folio_subpages_mapcount_ptr(folio), 0);
+	atomic_set(&folio->_nr_pages_mapped, 0);
 	atomic_set(&folio->_pincount, 0);
 	return true;
 
--- a/mm/internal.h~mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped
+++ a/mm/internal.h
@@ -52,6 +52,24 @@ struct folio_batch;
 
 void page_writeback_init(void);
 
+/*
+ * If a 16GB hugetlb folio were mapped by PTEs of all of its 4kB pages,
+ * its nr_pages_mapped would be 0x400000: choose the COMPOUND_MAPPED bit
+ * above that range, instead of 2*(PMD_SIZE/PAGE_SIZE).  Hugetlb currently
+ * leaves nr_pages_mapped at 0, but avoid surprise if it participates later.
+ */
+#define COMPOUND_MAPPED		0x800000
+#define FOLIO_PAGES_MAPPED	(COMPOUND_MAPPED - 1)
+
+/*
+ * How many individual pages have an elevated _mapcount.  Excludes
+ * the folio's entire_mapcount.
+ */
+static inline int folio_nr_pages_mapped(struct folio *folio)
+{
+	return atomic_read(&folio->_nr_pages_mapped) & FOLIO_PAGES_MAPPED;
+}
+
 static inline void *folio_raw_mapping(struct folio *folio)
 {
 	unsigned long mapping = (unsigned long)folio->mapping;
--- a/mm/rmap.c~mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped
+++ a/mm/rmap.c
@@ -1080,12 +1080,13 @@ int pfn_mkclean_range(unsigned long pfn,
 
 int total_compound_mapcount(struct page *head)
 {
+	struct folio *folio = (struct folio *)head;
 	int mapcount = head_compound_mapcount(head);
 	int nr_subpages;
 	int i;
 
 	/* In the common case, avoid the loop when no subpages mapped by PTE */
-	if (head_subpages_mapcount(head) == 0)
+	if (folio_nr_pages_mapped(folio) == 0)
 		return mapcount;
 	/*
 	 * Add all the PTE mappings of those subpages mapped by PTE.
@@ -1233,7 +1234,7 @@ void page_add_anon_rmap(struct page *pag
 			nr = atomic_add_return_relaxed(COMPOUND_MAPPED, mapped);
 			if (likely(nr < COMPOUND_MAPPED + COMPOUND_MAPPED)) {
 				nr_pmdmapped = thp_nr_pages(page);
-				nr = nr_pmdmapped - (nr & SUBPAGES_MAPPED);
+				nr = nr_pmdmapped - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of a remove and another add? */
 				if (unlikely(nr < 0))
 					nr = 0;
@@ -1337,7 +1338,7 @@ void page_add_file_rmap(struct page *pag
 			nr = atomic_add_return_relaxed(COMPOUND_MAPPED, mapped);
 			if (likely(nr < COMPOUND_MAPPED + COMPOUND_MAPPED)) {
 				nr_pmdmapped = thp_nr_pages(page);
-				nr = nr_pmdmapped - (nr & SUBPAGES_MAPPED);
+				nr = nr_pmdmapped - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of a remove and another add? */
 				if (unlikely(nr < 0))
 					nr = 0;
@@ -1399,7 +1400,7 @@ void page_remove_rmap(struct page *page,
 			nr = atomic_sub_return_relaxed(COMPOUND_MAPPED, mapped);
 			if (likely(nr < COMPOUND_MAPPED)) {
 				nr_pmdmapped = thp_nr_pages(page);
-				nr = nr_pmdmapped - (nr & SUBPAGES_MAPPED);
+				nr = nr_pmdmapped - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of another remove and an add? */
 				if (unlikely(nr < 0))
 					nr = 0;
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch
mm-memcg-add-folio_memcg_check.patch
mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch
mm-convert-is_transparent_hugepage-to-use-a-folio.patch
mm-convert-destroy_large_folio-to-use-folio_dtor.patch
hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch
mm-remove-first-tail-page-members-from-struct-page.patch
doc-correct-struct-folio-kernel-doc.patch
mm-move-page-deferred_list-to-folio-_deferred_list.patch
mm-huge_memory-remove-page_deferred_list.patch
mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch
mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch

