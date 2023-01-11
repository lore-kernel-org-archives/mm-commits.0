Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50756C46467
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbjAKU63 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjAKU61 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:58:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673BFC16
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:58:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25CAAB81CD2
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B936FC433EF;
        Wed, 11 Jan 2023 20:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470703;
        bh=keHGjQYfqtCbrt3Kez/98vzVXW8NwBqeHrveEb+e0gs=;
        h=Date:To:From:Subject:From;
        b=ZuW1rf7YWPwHxGeEG3SE6yzyXDl3qMbD03dPeHrIENLmYegzmwpQLp+g6Smo1ryaY
         oEYeVdXLUVqGAndaWzrDqgvNcQxH2KWym33n2hcn0Dm5IKPEusIGmfZu2i43EPQ25o
         X6qeAHUvuFQMcpW6q1sa1fsn4CdGzk4iLGHlzwmU=
Date:   Wed, 11 Jan 2023 12:58:23 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch added to mm-unstable branch
Message-Id: <20230111205823.B936FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove folio_pincount_ptr() and head_compound_pincount()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch

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
Subject: mm: remove folio_pincount_ptr() and head_compound_pincount()
Date: Wed, 11 Jan 2023 14:28:47 +0000

We can use folio->_pincount directly, since all users are guarded by tests
of compound/large.

Link: https://lkml.kernel.org/r/20230111142915.1001531-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/pin_user_pages.rst |   27 +++++++++-----------
 include/linux/mm.h                        |   14 +---------
 include/linux/mm_types.h                  |    5 ---
 mm/debug.c                                |    4 +-
 mm/gup.c                                  |    8 ++---
 mm/huge_memory.c                          |    4 +-
 mm/hugetlb.c                              |    4 +-
 mm/page_alloc.c                           |    9 ++++--
 8 files changed, 31 insertions(+), 44 deletions(-)

--- a/Documentation/core-api/pin_user_pages.rst~mm-remove-folio_pincount_ptr-and-head_compound_pincount
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -55,18 +55,17 @@ flags the caller provides. The caller is
 pages* array, and the function then pins pages by incrementing each by a special
 value: GUP_PIN_COUNTING_BIAS.
 
-For compound pages, the GUP_PIN_COUNTING_BIAS scheme is not used. Instead,
-an exact form of pin counting is achieved, by using the 2nd struct page
-in the compound page. A new struct page field, compound_pincount, has
-been added in order to support this.
-
-This approach for compound pages avoids the counting upper limit problems that
-are discussed below. Those limitations would have been aggravated severely by
-huge pages, because each tail page adds a refcount to the head page. And in
-fact, testing revealed that, without a separate compound_pincount field,
-page overflows were seen in some huge page stress tests.
+For large folios, the GUP_PIN_COUNTING_BIAS scheme is not used. Instead,
+the extra space available in the struct folio is used to store the
+pincount directly.
+
+This approach for large folios avoids the counting upper limit problems
+that are discussed below. Those limitations would have been aggravated
+severely by huge pages, because each tail page adds a refcount to the
+head page. And in fact, testing revealed that, without a separate pincount
+field, refcount overflows were seen in some huge page stress tests.
 
-This also means that huge pages and compound pages do not suffer
+This also means that huge pages and large folios do not suffer
 from the false positives problem that is mentioned below.::
 
  Function
@@ -264,9 +263,9 @@ place.)
 Other diagnostics
 =================
 
-dump_page() has been enhanced slightly, to handle these new counting
-fields, and to better report on compound pages in general. Specifically,
-for compound pages, the exact (compound_pincount) pincount is reported.
+dump_page() has been enhanced slightly to handle these new counting
+fields, and to better report on large folios in general.  Specifically,
+for large folios, the exact pincount is reported.
 
 References
 ==========
--- a/include/linux/mm.h~mm-remove-folio_pincount_ptr-and-head_compound_pincount
+++ a/include/linux/mm.h
@@ -1011,11 +1011,6 @@ static inline void folio_set_compound_dt
 
 void destroy_large_folio(struct folio *folio);
 
-static inline int head_compound_pincount(struct page *head)
-{
-	return atomic_read(compound_pincount_ptr(head));
-}
-
 static inline void set_compound_order(struct page *page, unsigned int order)
 {
 	page[1].compound_order = order;
@@ -1641,11 +1636,6 @@ static inline struct folio *pfn_folio(un
 	return page_folio(pfn_to_page(pfn));
 }
 
-static inline atomic_t *folio_pincount_ptr(struct folio *folio)
-{
-	return &folio_page(folio, 1)->compound_pincount;
-}
-
 /**
  * folio_maybe_dma_pinned - Report if a folio may be pinned for DMA.
  * @folio: The folio.
@@ -1663,7 +1653,7 @@ static inline atomic_t *folio_pincount_p
  * expected to be able to deal gracefully with a false positive.
  *
  * For large folios, the result will be exactly correct. That's because
- * we have more tracking data available: the compound_pincount is used
+ * we have more tracking data available: the _pincount field is used
  * instead of the GUP_PIN_COUNTING_BIAS scheme.
  *
  * For more information, please see Documentation/core-api/pin_user_pages.rst.
@@ -1674,7 +1664,7 @@ static inline atomic_t *folio_pincount_p
 static inline bool folio_maybe_dma_pinned(struct folio *folio)
 {
 	if (folio_test_large(folio))
-		return atomic_read(folio_pincount_ptr(folio)) > 0;
+		return atomic_read(&folio->_pincount) > 0;
 
 	/*
 	 * folio_ref_count() is signed. If that refcount overflows, then
--- a/include/linux/mm_types.h~mm-remove-folio_pincount_ptr-and-head_compound_pincount
+++ a/include/linux/mm_types.h
@@ -443,11 +443,6 @@ static inline atomic_t *subpages_mapcoun
 	return &page[1].subpages_mapcount;
 }
 
-static inline atomic_t *compound_pincount_ptr(struct page *page)
-{
-	return &page[1].compound_pincount;
-}
-
 /*
  * Used for sizing the vmemmap region on some architectures
  */
--- a/mm/debug.c~mm-remove-folio_pincount_ptr-and-head_compound_pincount
+++ a/mm/debug.c
@@ -94,11 +94,11 @@ static void __dump_page(struct page *pag
 			page, page_ref_count(head), mapcount, mapping,
 			page_to_pgoff(page), page_to_pfn(page));
 	if (compound) {
-		pr_warn("head:%p order:%u compound_mapcount:%d subpages_mapcount:%d compound_pincount:%d\n",
+		pr_warn("head:%p order:%u compound_mapcount:%d subpages_mapcount:%d pincount:%d\n",
 				head, compound_order(head),
 				head_compound_mapcount(head),
 				head_subpages_mapcount(head),
-				head_compound_pincount(head));
+				atomic_read(&folio->_pincount));
 	}
 
 #ifdef CONFIG_MEMCG
--- a/mm/gup.c~mm-remove-folio_pincount_ptr-and-head_compound_pincount
+++ a/mm/gup.c
@@ -111,7 +111,7 @@ retry:
  *    FOLL_GET: folio's refcount will be incremented by @refs.
  *
  *    FOLL_PIN on large folios: folio's refcount will be incremented by
- *    @refs, and its compound_pincount will be incremented by @refs.
+ *    @refs, and its pincount will be incremented by @refs.
  *
  *    FOLL_PIN on single-page folios: folio's refcount will be incremented by
  *    @refs * GUP_PIN_COUNTING_BIAS.
@@ -157,7 +157,7 @@ struct folio *try_grab_folio(struct page
 		 * try_get_folio() is left intact.
 		 */
 		if (folio_test_large(folio))
-			atomic_add(refs, folio_pincount_ptr(folio));
+			atomic_add(refs, &folio->_pincount);
 		else
 			folio_ref_add(folio,
 					refs * (GUP_PIN_COUNTING_BIAS - 1));
@@ -182,7 +182,7 @@ static void gup_put_folio(struct folio *
 	if (flags & FOLL_PIN) {
 		node_stat_mod_folio(folio, NR_FOLL_PIN_RELEASED, refs);
 		if (folio_test_large(folio))
-			atomic_sub(refs, folio_pincount_ptr(folio));
+			atomic_sub(refs, &folio->_pincount);
 		else
 			refs *= GUP_PIN_COUNTING_BIAS;
 	}
@@ -232,7 +232,7 @@ int __must_check try_grab_page(struct pa
 		 */
 		if (folio_test_large(folio)) {
 			folio_ref_add(folio, 1);
-			atomic_add(1, folio_pincount_ptr(folio));
+			atomic_add(1, &folio->_pincount);
 		} else {
 			folio_ref_add(folio, GUP_PIN_COUNTING_BIAS);
 		}
--- a/mm/huge_memory.c~mm-remove-folio_pincount_ptr-and-head_compound_pincount
+++ a/mm/huge_memory.c
@@ -2477,9 +2477,9 @@ static void __split_huge_page_tail(struc
 	 * of swap cache pages that store the swp_entry_t in tail pages.
 	 * Fix up and warn once if private is unexpectedly set.
 	 *
-	 * What of 32-bit systems, on which head[1].compound_pincount overlays
+	 * What of 32-bit systems, on which folio->_pincount overlays
 	 * head[1].private?  No problem: THP_SWAP is not enabled on 32-bit, and
-	 * compound_pincount must be 0 for folio_ref_freeze() to have succeeded.
+	 * pincount must be 0 for folio_ref_freeze() to have succeeded.
 	 */
 	if (!folio_test_swapcache(page_folio(head))) {
 		VM_WARN_ON_ONCE_PAGE(page_tail->private != 0, page_tail);
--- a/mm/hugetlb.c~mm-remove-folio_pincount_ptr-and-head_compound_pincount
+++ a/mm/hugetlb.c
@@ -1476,7 +1476,7 @@ static void __destroy_compound_gigantic_
 
 	atomic_set(folio_mapcount_ptr(folio), 0);
 	atomic_set(folio_subpages_mapcount_ptr(folio), 0);
-	atomic_set(folio_pincount_ptr(folio), 0);
+	atomic_set(&folio->_pincount, 0);
 
 	for (i = 1; i < nr_pages; i++) {
 		p = folio_page(folio, i);
@@ -1998,7 +1998,7 @@ static bool __prep_compound_gigantic_fol
 	}
 	atomic_set(folio_mapcount_ptr(folio), -1);
 	atomic_set(folio_subpages_mapcount_ptr(folio), 0);
-	atomic_set(folio_pincount_ptr(folio), 0);
+	atomic_set(&folio->_pincount, 0);
 	return true;
 
 out_error:
--- a/mm/page_alloc.c~mm-remove-folio_pincount_ptr-and-head_compound_pincount
+++ a/mm/page_alloc.c
@@ -775,11 +775,13 @@ void free_compound_page(struct page *pag
 
 static void prep_compound_head(struct page *page, unsigned int order)
 {
+	struct folio *folio = (struct folio *)page;
+
 	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
 	set_compound_order(page, order);
 	atomic_set(compound_mapcount_ptr(page), -1);
 	atomic_set(subpages_mapcount_ptr(page), 0);
-	atomic_set(compound_pincount_ptr(page), 0);
+	atomic_set(&folio->_pincount, 0);
 }
 
 static void prep_compound_tail(struct page *head, int tail_idx)
@@ -1291,6 +1293,7 @@ static inline bool free_page_is_bad(stru
 
 static int free_tail_pages_check(struct page *head_page, struct page *page)
 {
+	struct folio *folio = (struct folio *)head_page;
 	int ret = 1;
 
 	/*
@@ -1314,8 +1317,8 @@ static int free_tail_pages_check(struct
 			bad_page(page, "nonzero subpages_mapcount");
 			goto out;
 		}
-		if (unlikely(head_compound_pincount(head_page))) {
-			bad_page(page, "nonzero compound_pincount");
+		if (unlikely(atomic_read(&folio->_pincount))) {
+			bad_page(page, "nonzero pincount");
 			goto out;
 		}
 		break;
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

