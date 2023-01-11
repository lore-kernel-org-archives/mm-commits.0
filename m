Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F552C63797
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbjAKU7E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbjAKU6m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:58:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13428C16
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:58:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2E4F61E0B
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052C0C433F0;
        Wed, 11 Jan 2023 20:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470715;
        bh=GWC/o7mQOyWEQP4lSQK3PmZs9U8jqrE4SPxuTR/sVJY=;
        h=Date:To:From:Subject:From;
        b=wKUf1kgDbGK8vP3GI4jXHW8+58N+MRTdQ/MD9rhHHzesJ2tIYh7deZBHu23wu8QXK
         fEk+AvToaGj6YhPFJWl2aANQ+nnl4/cRCfdqY3/Fd61nkN+QHuKC2hhjFf+V71lr4Z
         hQVML5zRqnkGeOnLa1j8xuZOYg1gGlKZM6J6QkMY=
Date:   Wed, 11 Jan 2023 12:58:34 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch added to mm-unstable branch
Message-Id: <20230111205835.052C0C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert page_add_anon_rmap() to use a folio internally
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch

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
Subject: mm: convert page_add_anon_rmap() to use a folio internally
Date: Wed, 11 Jan 2023 14:28:52 +0000

The API for page_add_anon_rmap() needs to be page-based, because we can
add mappings of individual pages.  But inside the function, we want to
only call compound_head() once and then use the folio APIs instead of the
page APIs that each call compound_head().

Link: https://lkml.kernel.org/r/20230111142915.1001531-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/mm/rmap.c~mm-convert-page_add_anon_rmap-to-use-a-folio-internally
+++ a/mm/rmap.c
@@ -1207,10 +1207,11 @@ static void __page_check_anon_rmap(struc
  * and to ensure that PageAnon is not being upgraded racily to PageKsm
  * (but PageKsm is never downgraded to PageAnon).
  */
-void page_add_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address, rmap_t flags)
+void page_add_anon_rmap(struct page *page, struct vm_area_struct *vma,
+		unsigned long address, rmap_t flags)
 {
-	atomic_t *mapped;
+	struct folio *folio = page_folio(page);
+	atomic_t *mapped = &folio->_nr_pages_mapped;
 	int nr = 0, nr_pmdmapped = 0;
 	bool compound = flags & RMAP_COMPOUND;
 	bool first = true;
@@ -1219,20 +1220,18 @@ void page_add_anon_rmap(struct page *pag
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
@@ -1248,11 +1247,11 @@ void page_add_anon_rmap(struct page *pag
 	VM_BUG_ON_PAGE(!first && PageAnonExclusive(page), page);
 
 	if (nr_pmdmapped)
-		__mod_lruvec_page_state(page, NR_ANON_THPS, nr_pmdmapped);
+		__lruvec_stat_mod_folio(folio, NR_ANON_THPS, nr_pmdmapped);
 	if (nr)
-		__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
+		__lruvec_stat_mod_folio(folio, NR_ANON_MAPPED, nr);
 
-	if (likely(!PageKsm(page))) {
+	if (likely(!folio_test_ksm(folio))) {
 		/* address might be in next vma when migration races vma_adjust */
 		if (first)
 			__page_set_anon_rmap(page, vma, address,
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

