Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19BDC5479D
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbjAKU7H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbjAKU6m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:58:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6D5C11
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:58:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 147AB61E5D
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F69CC433D2;
        Wed, 11 Jan 2023 20:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470709;
        bh=XXOvBcn6EA/Xo8/mctncLaoCg+yRnb08DzLZf8Y0eFM=;
        h=Date:To:From:Subject:From;
        b=A/j3u5vKEKCM+Ps1CDWKrQWyWNDBZLPApr02K1nROWkOV/3Rdq/ag5mqETzcQW2D+
         7qqfIilgcX0Q8TGR0j5mVcQ9Mkc6tz9N8kJrclEFaRX8Lf0JBPuNO/RtG0U2Bv7ITY
         o30/J+YJO+gc6XpEOEUuh1REa5oJOAbGkvWhrKo0=
Date:   Wed, 11 Jan 2023 12:58:28 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-clarify-refcount-section-by-referring-to-folios-pages.patch added to mm-unstable branch
Message-Id: <20230111205829.6F69CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: doc: clarify refcount section by referring to folios & pages
has been added to the -mm mm-unstable branch.  Its filename is
     doc-clarify-refcount-section-by-referring-to-folios-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/doc-clarify-refcount-section-by-referring-to-folios-pages.patch

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
Subject: doc: clarify refcount section by referring to folios & pages
Date: Wed, 11 Jan 2023 14:28:49 +0000

Include the rename of subpages_mapcount to _nr_pages_mapped.

Link: https://lkml.kernel.org/r/20230111142915.1001531-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/transhuge.rst |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/Documentation/mm/transhuge.rst~doc-clarify-refcount-section-by-referring-to-folios-pages
+++ a/Documentation/mm/transhuge.rst
@@ -112,20 +112,20 @@ Refcounts and transparent huge pages
 Refcounting on THP is mostly consistent with refcounting on other compound
 pages:
 
-  - get_page()/put_page() and GUP operate on head page's ->_refcount.
+  - get_page()/put_page() and GUP operate on the folio->_refcount.
 
   - ->_refcount in tail pages is always zero: get_page_unless_zero() never
     succeeds on tail pages.
 
-  - map/unmap of PMD entry for the whole compound page increment/decrement
-    ->compound_mapcount, stored in the first tail page of the compound page;
-    and also increment/decrement ->subpages_mapcount (also in the first tail)
-    by COMPOUND_MAPPED when compound_mapcount goes from -1 to 0 or 0 to -1.
+  - map/unmap of a PMD entry for the whole THP increment/decrement
+    folio->_entire_mapcount and also increment/decrement
+    folio->_nr_pages_mapped by COMPOUND_MAPPED when _entire_mapcount
+    goes from -1 to 0 or 0 to -1.
 
-  - map/unmap of sub-pages with PTE entry increment/decrement ->_mapcount
-    on relevant sub-page of the compound page, and also increment/decrement
-    ->subpages_mapcount, stored in first tail page of the compound page, when
-    _mapcount goes from -1 to 0 or 0 to -1: counting sub-pages mapped by PTE.
+  - map/unmap of individual pages with PTE entry increment/decrement
+    page->_mapcount and also increment/decrement folio->_nr_pages_mapped
+    when page->_mapcount goes from -1 to 0 or 0 to -1 as this counts
+    the number of pages mapped by PTE.
 
 split_huge_page internally has to distribute the refcounts in the head
 page to the tail pages before clearing all PG_head/tail bits from the page
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

