Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC830C678D7
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 21:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbjAKU7M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbjAKU6x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:58:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6B8C11
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:58:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD4BD61E73
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AF1C433D2;
        Wed, 11 Jan 2023 20:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470731;
        bh=sjcJ5Ysh11GkfaSUetJ8m0HGWKCE/BuLdG+1hUeEvnw=;
        h=Date:To:From:Subject:From;
        b=e2BW3YEBDOK48QTgohIQ5apr4U8XSQZW8TLj019izZLP4U56eOILB5RDKjadOH8Rv
         hxH7mqAljBTsRfkLRrohEYrWkVNmYYLzGs8fM7QGhNGcwpofSOjr/RqV1NFZUUuhUW
         bogFdFWBL6MnU9ynCd397mXpf7r7a93PTXNQxVDQ=
Date:   Wed, 11 Jan 2023 12:58:50 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-head_compound_mapcount-and-_ptr-functions.patch added to mm-unstable branch
Message-Id: <20230111205851.20AF1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove head_compound_mapcount() and _ptr functions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-head_compound_mapcount-and-_ptr-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-head_compound_mapcount-and-_ptr-functions.patch

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
Subject: mm: remove head_compound_mapcount() and _ptr functions
Date: Wed, 11 Jan 2023 14:29:01 +0000

folio_mapcount_ptr(), compound_mapcount_ptr() and subpages_mapcount_ptr()
are all now unused.

Link: https://lkml.kernel.org/r/20230111142915.1001531-16-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   15 +++------------
 include/linux/mm_types.h |   16 ----------------
 2 files changed, 3 insertions(+), 28 deletions(-)

--- a/include/linux/mm.h~mm-remove-head_compound_mapcount-and-_ptr-functions
+++ a/include/linux/mm.h
@@ -831,16 +831,7 @@ static inline int is_vmalloc_or_module_a
 static inline int folio_entire_mapcount(struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
-	return atomic_read(folio_mapcount_ptr(folio)) + 1;
-}
-
-/*
- * Mapcount of compound page as a whole, does not include mapped sub-pages.
- * Must be called only on head of compound page.
- */
-static inline int head_compound_mapcount(struct page *head)
-{
-	return atomic_read(compound_mapcount_ptr(head)) + 1;
+	return atomic_read(&folio->_entire_mapcount) + 1;
 }
 
 /*
@@ -905,11 +896,11 @@ static inline int total_mapcount(struct
 static inline bool folio_large_is_mapped(struct folio *folio)
 {
 	/*
-	 * Reading folio_mapcount_ptr() below could be omitted if hugetlb
+	 * Reading _entire_mapcount below could be omitted if hugetlb
 	 * participated in incrementing nr_pages_mapped when compound mapped.
 	 */
 	return atomic_read(&folio->_nr_pages_mapped) > 0 ||
-		atomic_read(folio_mapcount_ptr(folio)) >= 0;
+		atomic_read(&folio->_entire_mapcount) >= 0;
 }
 
 /**
--- a/include/linux/mm_types.h~mm-remove-head_compound_mapcount-and-_ptr-functions
+++ a/include/linux/mm_types.h
@@ -421,22 +421,6 @@ FOLIO_MATCH(hugetlb_cgroup_rsvd, _hugetl
 FOLIO_MATCH(hugetlb_hwpoison, _hugetlb_hwpoison);
 #undef FOLIO_MATCH
 
-static inline atomic_t *folio_mapcount_ptr(struct folio *folio)
-{
-	struct page *tail = &folio->page + 1;
-	return &tail->compound_mapcount;
-}
-
-static inline atomic_t *compound_mapcount_ptr(struct page *page)
-{
-	return &page[1].compound_mapcount;
-}
-
-static inline atomic_t *subpages_mapcount_ptr(struct page *page)
-{
-	return &page[1].subpages_mapcount;
-}
-
 /*
  * Used for sizing the vmemmap region on some architectures
  */
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

