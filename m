Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D3AC5479D
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbjAKU7j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbjAKU7P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:59:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA62060DC
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:59:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67FD461DD9
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4578C433EF;
        Wed, 11 Jan 2023 20:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470752;
        bh=d87/+jm0FaycsVtii2dfkyq2OJQotNBzIRJIYAW8ItA=;
        h=Date:To:From:Subject:From;
        b=U61im9QqNOQDk/4WdgWp+8xJNKShSWkxs+cueGCIVTH4bBOE6x9T7RBNK4jbWSJcM
         nkZrPzydr223eCIqdg0jSZ0bYhXZ5kZQx54EuoHe5L5gax8Zf9bAo5HeOMoFzWEU1k
         ONqGypqMTerrrTqrUbDKLU8PJ4/Yl/cx4qyBl5FY=
Date:   Wed, 11 Jan 2023 12:59:12 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch added to mm-unstable branch
Message-Id: <20230111205912.C4578C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert deferred_split_huge_page() to deferred_split_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch

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
Subject: mm: convert deferred_split_huge_page() to deferred_split_folio()
Date: Wed, 11 Jan 2023 14:29:13 +0000

Now that both callers use a folio, pass the folio in and save a call to
compound_head().

Link: https://lkml.kernel.org/r/20230111142915.1001531-28-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/transhuge.rst |    6 +++---
 include/linux/huge_mm.h        |    4 ++--
 mm/huge_memory.c               |    3 +--
 mm/rmap.c                      |    2 +-
 4 files changed, 7 insertions(+), 8 deletions(-)

--- a/Documentation/mm/transhuge.rst~mm-convert-deferred_split_huge_page-to-deferred_split_folio
+++ a/Documentation/mm/transhuge.rst
@@ -153,8 +153,8 @@ clear where references should go after s
 Note that split_huge_pmd() doesn't have any limitations on refcounting:
 pmd can be split at any point and never fails.
 
-Partial unmap and deferred_split_huge_page()
-============================================
+Partial unmap and deferred_split_folio()
+========================================
 
 Unmapping part of THP (with munmap() or other way) is not going to free
 memory immediately. Instead, we detect that a subpage of THP is not in use
@@ -166,6 +166,6 @@ the place where we can detect partial un
 counterproductive since in many cases partial unmap happens during exit(2) if
 a THP crosses a VMA boundary.
 
-The function deferred_split_huge_page() is used to queue a page for splitting.
+The function deferred_split_folio() is used to queue a folio for splitting.
 The splitting itself will happen when we get memory pressure via shrinker
 interface.
--- a/include/linux/huge_mm.h~mm-convert-deferred_split_huge_page-to-deferred_split_folio
+++ a/include/linux/huge_mm.h
@@ -187,7 +187,7 @@ static inline int split_huge_page(struct
 {
 	return split_huge_page_to_list(page, NULL);
 }
-void deferred_split_huge_page(struct page *page);
+void deferred_split_folio(struct folio *folio);
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze, struct folio *folio);
@@ -340,7 +340,7 @@ static inline int split_huge_page(struct
 {
 	return 0;
 }
-static inline void deferred_split_huge_page(struct page *page) {}
+static inline void deferred_split_folio(struct folio *folio) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
--- a/mm/huge_memory.c~mm-convert-deferred_split_huge_page-to-deferred_split_folio
+++ a/mm/huge_memory.c
@@ -2815,9 +2815,8 @@ void free_transhuge_page(struct page *pa
 	free_compound_page(page);
 }
 
-void deferred_split_huge_page(struct page *page)
+void deferred_split_folio(struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 #ifdef CONFIG_MEMCG
 	struct mem_cgroup *memcg = folio_memcg(folio);
--- a/mm/rmap.c~mm-convert-deferred_split_huge_page-to-deferred_split_folio
+++ a/mm/rmap.c
@@ -1427,7 +1427,7 @@ void page_remove_rmap(struct page *page,
 		 */
 		if (folio_test_pmd_mappable(folio) && folio_test_anon(folio))
 			if (!compound || nr < nr_pmdmapped)
-				deferred_split_huge_page(&folio->page);
+				deferred_split_folio(folio);
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

