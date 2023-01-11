Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF80C46467
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjAKU7D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbjAKU6m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:58:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0377360DC
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:58:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 47B86CE1D09
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBA2C433D2;
        Wed, 11 Jan 2023 20:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470713;
        bh=Z6ASOgqDKUwXjotungS3s4dM0K3aq75GjBDxwD9x7u8=;
        h=Date:To:From:Subject:From;
        b=icBiWe75D0AqyArtXRJg1IqnAte/7kpoPFkohggaL4e3FovaA8dPlg5B6aXcGXGwo
         gj484AaZrPmmYbbypws7dpJsZen7lp8qhZbLYuSy1RDeqv9GMfOOL4/OFHwORGbdZ4
         QGAc6MzqnqhY+/1kYsEUKPpeA+U3h2CEfeQKzOHk=
Date:   Wed, 11 Jan 2023 12:58:32 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-page_remove_rmap-to-use-a-folio-internally.patch added to mm-unstable branch
Message-Id: <20230111205833.4DBA2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert page_remove_rmap() to use a folio internally
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-page_remove_rmap-to-use-a-folio-internally.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-page_remove_rmap-to-use-a-folio-internally.patch

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
Subject: mm: convert page_remove_rmap() to use a folio internally
Date: Wed, 11 Jan 2023 14:28:51 +0000

The API for page_remove_rmap() needs to be page-based, because we can
remove mappings of pages individually.  But inside the function, we want
to only call compound_head() once and then use the folio APIs instead of
the page APIs that each call compound_head().

Link: https://lkml.kernel.org/r/20230111142915.1001531-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

--- a/mm/rmap.c~mm-convert-page_remove_rmap-to-use-a-folio-internally
+++ a/mm/rmap.c
@@ -1365,19 +1365,21 @@ void page_add_file_rmap(struct page *pag
  *
  * The caller needs to hold the pte lock.
  */
-void page_remove_rmap(struct page *page,
-	struct vm_area_struct *vma, bool compound)
+void page_remove_rmap(struct page *page, struct vm_area_struct *vma,
+		bool compound)
 {
-	atomic_t *mapped;
+	struct folio *folio = page_folio(page);
+	atomic_t *mapped = &folio->_nr_pages_mapped;
 	int nr = 0, nr_pmdmapped = 0;
 	bool last;
+	enum node_stat_item idx;
 
 	VM_BUG_ON_PAGE(compound && !PageHead(page), page);
 
 	/* Hugetlb pages are not counted in NR_*MAPPED */
-	if (unlikely(PageHuge(page))) {
+	if (unlikely(folio_test_hugetlb(folio))) {
 		/* hugetlb pages are always mapped with pmds */
-		atomic_dec(compound_mapcount_ptr(page));
+		atomic_dec(&folio->_entire_mapcount);
 		return;
 	}
 
@@ -1385,20 +1387,18 @@ void page_remove_rmap(struct page *page,
 	if (likely(!compound)) {
 		last = atomic_add_negative(-1, &page->_mapcount);
 		nr = last;
-		if (last && PageCompound(page)) {
-			mapped = subpages_mapcount_ptr(compound_head(page));
+		if (last && folio_test_large(folio)) {
 			nr = atomic_dec_return_relaxed(mapped);
 			nr = (nr < COMPOUND_MAPPED);
 		}
-	} else if (PageTransHuge(page)) {
+	} else if (folio_test_pmd_mappable(folio)) {
 		/* That test is redundant: it's for safety or to optimize out */
 
-		last = atomic_add_negative(-1, compound_mapcount_ptr(page));
+		last = atomic_add_negative(-1, &folio->_entire_mapcount);
 		if (last) {
-			mapped = subpages_mapcount_ptr(page);
 			nr = atomic_sub_return_relaxed(COMPOUND_MAPPED, mapped);
 			if (likely(nr < COMPOUND_MAPPED)) {
-				nr_pmdmapped = thp_nr_pages(page);
+				nr_pmdmapped = folio_nr_pages(folio);
 				nr = nr_pmdmapped - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of another remove and an add? */
 				if (unlikely(nr < 0))
@@ -1411,21 +1411,26 @@ void page_remove_rmap(struct page *page,
 	}
 
 	if (nr_pmdmapped) {
-		__mod_lruvec_page_state(page, PageAnon(page) ? NR_ANON_THPS :
-				(PageSwapBacked(page) ? NR_SHMEM_PMDMAPPED :
-				NR_FILE_PMDMAPPED), -nr_pmdmapped);
+		if (folio_test_anon(folio))
+			idx = NR_ANON_THPS;
+		else if (folio_test_swapbacked(folio))
+			idx = NR_SHMEM_PMDMAPPED;
+		else
+			idx = NR_FILE_PMDMAPPED;
+		__lruvec_stat_mod_folio(folio, idx, -nr_pmdmapped);
 	}
 	if (nr) {
-		__mod_lruvec_page_state(page, PageAnon(page) ? NR_ANON_MAPPED :
-				NR_FILE_MAPPED, -nr);
+		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
+		__lruvec_stat_mod_folio(folio, idx, -nr);
+
 		/*
-		 * Queue anon THP for deferred split if at least one small
-		 * page of the compound page is unmapped, but at least one
-		 * small page is still mapped.
+		 * Queue anon THP for deferred split if at least one
+		 * page of the folio is unmapped and at least one page
+		 * is still mapped.
 		 */
-		if (PageTransCompound(page) && PageAnon(page))
+		if (folio_test_pmd_mappable(folio) && folio_test_anon(folio))
 			if (!compound || nr < nr_pmdmapped)
-				deferred_split_huge_page(compound_head(page));
+				deferred_split_huge_page(&folio->page);
 	}
 
 	/*
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

