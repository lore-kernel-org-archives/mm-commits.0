Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E34BC678D8
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbjAKU7T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbjAKU7D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:59:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDB3C16
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:59:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67FBF61E0B
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D10C433D2;
        Wed, 11 Jan 2023 20:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470741;
        bh=TRVXvUSvXSnb9SmLn7k9Nm9n3DaueO17eNk3sx41T9A=;
        h=Date:To:From:Subject:From;
        b=Lg1NwzUdRYwWzyB/Pk3M3FLF4H2Sw5TOG3t/iTk1+rzFr8glqWtIsFFk8OZgEWGCx
         ubsJhHAMThD3KqwhTcuzp6qAFZWQ70pXZ0U1prteLb3Fs8eqVWfzKAo2XsVGAwcLUT
         8iAscE0daarNHehYGxb861tz21ZuPnM78SfFbMnU=
Date:   Wed, 11 Jan 2023 12:59:01 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch added to mm-unstable branch
Message-Id: <20230111205901.C4D10C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: remove uses of compound_dtor and compound_nr
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch

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
Subject: hugetlb: remove uses of compound_dtor and compound_nr
Date: Wed, 11 Jan 2023 14:29:07 +0000

Convert the entire file to use the folio equivalents.

Link: https://lkml.kernel.org/r/20230111142915.1001531-22-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~hugetlb-remove-uses-of-compound_dtor-and-compound_nr
+++ a/mm/hugetlb.c
@@ -2038,11 +2038,12 @@ static bool prep_compound_gigantic_folio
  */
 int PageHuge(struct page *page)
 {
+	struct folio *folio;
+
 	if (!PageCompound(page))
 		return 0;
-
-	page = compound_head(page);
-	return page[1].compound_dtor == HUGETLB_PAGE_DTOR;
+	folio = page_folio(page);
+	return folio->_folio_dtor == HUGETLB_PAGE_DTOR;
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
@@ -2052,10 +2053,11 @@ EXPORT_SYMBOL_GPL(PageHuge);
  */
 int PageHeadHuge(struct page *page_head)
 {
-	if (!PageHead(page_head))
+	struct folio *folio = (struct folio *)page_head;
+	if (!folio_test_large(folio))
 		return 0;
 
-	return page_head[1].compound_dtor == HUGETLB_PAGE_DTOR;
+	return folio->_folio_dtor == HUGETLB_PAGE_DTOR;
 }
 EXPORT_SYMBOL_GPL(PageHeadHuge);
 
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

