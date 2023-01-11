Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C857C67871
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 21:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbjAKU7I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbjAKU6n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:58:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440391DF1C
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:58:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 919D2CE1D07
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF81EC433EF;
        Wed, 11 Jan 2023 20:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470716;
        bh=gsvO8j12aFP50yg9LJ8aVZf6PyXGIJsMHRha2rvDJXo=;
        h=Date:To:From:Subject:From;
        b=oxxvOik8E5vLZOC6ykIEctw5sLx6es3zkm7A4wb40vpdoS9gHGepXSygW/7qroE7g
         M+YYiXcYe/NvxMwiW37NTmVux4ew+kdOFlXHs9aYWaR3YJyUx0b+TVPjLa5Qa4vpr9
         fyeiBM6hsRvquvg3XqXO62fZms3pYUBGqFyvmsbY=
Date:   Wed, 11 Jan 2023 12:58:36 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch added to mm-unstable branch
Message-Id: <20230111205836.AF81EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert page_add_file_rmap() to use a folio internally
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch

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
Subject: mm: convert page_add_file_rmap() to use a folio internally
Date: Wed, 11 Jan 2023 14:28:53 +0000

The API for page_add_file_rmap() needs to be page-based, because we can
add mappings of individual pages.  But inside the function, we want to
only call compound_head() once and then use the folio APIs instead of the
page APIs that each call compound_head().

Link: https://lkml.kernel.org/r/20230111142915.1001531-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/mm/rmap.c~mm-convert-page_add_file_rmap-to-use-a-folio-internally
+++ a/mm/rmap.c
@@ -1309,10 +1309,11 @@ void page_add_new_anon_rmap(struct page
  *
  * The caller needs to hold the pte lock.
  */
-void page_add_file_rmap(struct page *page,
-	struct vm_area_struct *vma, bool compound)
+void page_add_file_rmap(struct page *page, struct vm_area_struct *vma,
+		bool compound)
 {
-	atomic_t *mapped;
+	struct folio *folio = page_folio(page);
+	atomic_t *mapped = &folio->_nr_pages_mapped;
 	int nr = 0, nr_pmdmapped = 0;
 	bool first;
 
@@ -1322,20 +1323,18 @@ void page_add_file_rmap(struct page *pag
 	if (likely(!compound)) {
 		first = atomic_inc_and_test(&page->_mapcount);
 		nr = first;
-		if (first && PageCompound(page)) {
-			mapped = subpages_mapcount_ptr(compound_head(page));
+		if (first && folio_test_large(folio)) {
 			nr = atomic_inc_return_relaxed(mapped);
 			nr = (nr < COMPOUND_MAPPED);
 		}
-	} else if (PageTransHuge(page)) {
+	} else if (folio_test_pmd_mappable(folio)) {
 		/* That test is redundant: it's for safety or to optimize out */
 
-		first = atomic_inc_and_test(compound_mapcount_ptr(page));
+		first = atomic_inc_and_test(&folio->_entire_mapcount);
 		if (first) {
-			mapped = subpages_mapcount_ptr(page);
 			nr = atomic_add_return_relaxed(COMPOUND_MAPPED, mapped);
 			if (likely(nr < COMPOUND_MAPPED + COMPOUND_MAPPED)) {
-				nr_pmdmapped = thp_nr_pages(page);
+				nr_pmdmapped = folio_nr_pages(folio);
 				nr = nr_pmdmapped - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of a remove and another add? */
 				if (unlikely(nr < 0))
@@ -1348,10 +1347,10 @@ void page_add_file_rmap(struct page *pag
 	}
 
 	if (nr_pmdmapped)
-		__mod_lruvec_page_state(page, PageSwapBacked(page) ?
+		__lruvec_stat_mod_folio(folio, folio_test_swapbacked(folio) ?
 			NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED, nr_pmdmapped);
 	if (nr)
-		__mod_lruvec_page_state(page, NR_FILE_MAPPED, nr);
+		__lruvec_stat_mod_folio(folio, NR_FILE_MAPPED, nr);
 
 	mlock_vma_page(page, vma, compound);
 }
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

