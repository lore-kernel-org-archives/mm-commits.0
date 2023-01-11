Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE97C5479D
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 21:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbjAKU7H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbjAKU6n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:58:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF041DF1D
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:58:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DABD1B81D4D
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8174CC433F1;
        Wed, 11 Jan 2023 20:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470718;
        bh=VXfGINDwonvNB79yL/u8wK15RvEIQwNH+R/s9ZB92Cw=;
        h=Date:To:From:Subject:From;
        b=BxVjPE6B8nfp6u7Z35CZC5NuOZwEP34Pvfy+05U/Rt0fG2G0pxmECd/Q9NtkXjO2H
         I8GjWACAoT8sf1i/whf1wxd2lVeoMfAuiIIATYtwddVXvzySaHvAnjMy4fXc2PJ4yS
         qpHp8O2/b+KQZdR6BsMoMJdsGq6gXvbXD8MyZCoU=
Date:   Wed, 11 Jan 2023 12:58:38 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_add_new_anon_rmap.patch added to mm-unstable branch
Message-Id: <20230111205838.8174CC433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add folio_add_new_anon_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-folio_add_new_anon_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_add_new_anon_rmap.patch

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
Subject: mm: add folio_add_new_anon_rmap()
Date: Wed, 11 Jan 2023 14:28:54 +0000

In contrast to other rmap functions, page_add_new_anon_rmap() is always
called with a freshly allocated page.  That means it can't be called with
a tail page.  Turn page_add_new_anon_rmap() into folio_add_new_anon_rmap()
and add a page_add_new_anon_rmap() wrapper.  Callers can be converted
individually.

Link: https://lkml.kernel.org/r/20230111142915.1001531-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 ++
 mm/folio-compat.c    |    8 ++++++++
 mm/rmap.c            |   37 ++++++++++++++++++-------------------
 3 files changed, 28 insertions(+), 19 deletions(-)

--- a/include/linux/rmap.h~mm-add-folio_add_new_anon_rmap
+++ a/include/linux/rmap.h
@@ -194,6 +194,8 @@ void page_add_anon_rmap(struct page *, s
 		unsigned long address, rmap_t flags);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address);
+void folio_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
+		unsigned long address);
 void page_add_file_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
 void page_remove_rmap(struct page *, struct vm_area_struct *,
--- a/mm/folio-compat.c~mm-add-folio_add_new_anon_rmap
+++ a/mm/folio-compat.c
@@ -123,3 +123,11 @@ void putback_lru_page(struct page *page)
 {
 	folio_putback_lru(page_folio(page));
 }
+
+void page_add_new_anon_rmap(struct page *page, struct vm_area_struct *vma,
+		unsigned long address)
+{
+	VM_BUG_ON_PAGE(PageTail(page), page);
+
+	return folio_add_new_anon_rmap((struct folio *)page, vma, address);
+}
--- a/mm/rmap.c~mm-add-folio_add_new_anon_rmap
+++ a/mm/rmap.c
@@ -1264,41 +1264,40 @@ void page_add_anon_rmap(struct page *pag
 }
 
 /**
- * page_add_new_anon_rmap - add mapping to a new anonymous page
- * @page:	the page to add the mapping to
+ * folio_add_new_anon_rmap - Add mapping to a new anonymous folio.
+ * @folio:	The folio to add the mapping to.
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
  *
- * If it's a compound page, it is accounted as a compound page. As the page
- * is new, it's assume to get mapped exclusively by a single process.
- *
- * Same as page_add_anon_rmap but must only be called on *new* pages.
+ * Like page_add_anon_rmap() but must only be called on *new* folios.
  * This means the inc-and-test can be bypassed.
- * Page does not have to be locked.
+ * The folio does not have to be locked.
+ *
+ * If the folio is large, it is accounted as a THP.  As the folio
+ * is new, it's assumed to be mapped exclusively by a single process.
  */
-void page_add_new_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address)
+void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
+		unsigned long address)
 {
 	int nr;
 
 	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
-	__SetPageSwapBacked(page);
+	__folio_set_swapbacked(folio);
 
-	if (likely(!PageCompound(page))) {
+	if (likely(!folio_test_pmd_mappable(folio))) {
 		/* increment count (starts at -1) */
-		atomic_set(&page->_mapcount, 0);
+		atomic_set(&folio->_mapcount, 0);
 		nr = 1;
 	} else {
-		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		/* increment count (starts at -1) */
-		atomic_set(compound_mapcount_ptr(page), 0);
-		atomic_set(subpages_mapcount_ptr(page), COMPOUND_MAPPED);
-		nr = thp_nr_pages(page);
-		__mod_lruvec_page_state(page, NR_ANON_THPS, nr);
+		atomic_set(&folio->_entire_mapcount, 0);
+		atomic_set(&folio->_nr_pages_mapped, COMPOUND_MAPPED);
+		nr = folio_nr_pages(folio);
+		__lruvec_stat_mod_folio(folio, NR_ANON_THPS, nr);
 	}
 
-	__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
-	__page_set_anon_rmap(page, vma, address, 1);
+	__lruvec_stat_mod_folio(folio, NR_ANON_MAPPED, nr);
+	__page_set_anon_rmap(&folio->page, vma, address, 1);
 }
 
 /**
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

