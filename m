Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD348C678D5
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbjAKU7O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbjAKU7A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:59:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8241DF0C
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:58:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD304B81CD2
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD78C433EF;
        Wed, 11 Jan 2023 20:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470736;
        bh=LToO+0s2tosZL2b8EDJLo/gKY4kqcseaBAtIc8icKBo=;
        h=Date:To:From:Subject:From;
        b=yUGBOejjze5TVRSswXh9WqgGDJKkVfz89Sq3rqQk6Hm7DvmyCQJj06P0spmvu/w6+
         QjWx8oIxV8IOAIgkgJf0SW1oBlxuggVI+XcOhne5W/h/Nk9HTb+Ct5bZ1Hy4F5BmsX
         XMISma8g8c7buHNgQrfbLQesvMFXmXbxMV7/JmrQ=
Date:   Wed, 11 Jan 2023 12:58:56 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch added to mm-unstable branch
Message-Id: <20230111205856.7DD78C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert set_compound_page_dtor() and set_compound_order() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch

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
Subject: mm: convert set_compound_page_dtor() and set_compound_order() to folios
Date: Wed, 11 Jan 2023 14:29:04 +0000

Replace uses of compound_dtor, compound_order and compound_nr by their
folio equivalents.

Link: https://lkml.kernel.org/r/20230111142915.1001531-19-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios
+++ a/include/linux/mm.h
@@ -984,8 +984,11 @@ extern compound_page_dtor * const compou
 static inline void set_compound_page_dtor(struct page *page,
 		enum compound_dtor_id compound_dtor)
 {
+	struct folio *folio = (struct folio *)page;
+
 	VM_BUG_ON_PAGE(compound_dtor >= NR_COMPOUND_DTORS, page);
-	page[1].compound_dtor = compound_dtor;
+	VM_BUG_ON_PAGE(!PageHead(page), page);
+	folio->_folio_dtor = compound_dtor;
 }
 
 static inline void folio_set_compound_dtor(struct folio *folio,
@@ -999,9 +1002,11 @@ void destroy_large_folio(struct folio *f
 
 static inline void set_compound_order(struct page *page, unsigned int order)
 {
-	page[1].compound_order = order;
+	struct folio *folio = (struct folio *)page;
+
+	folio->_folio_order = order;
 #ifdef CONFIG_64BIT
-	page[1].compound_nr = 1U << order;
+	folio->_folio_nr_pages = 1U << order;
 #endif
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

