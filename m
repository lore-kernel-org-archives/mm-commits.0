Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818C6C67871
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbjAKU7N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbjAKU66 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:58:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A97C11
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:58:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18297B81D2A
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B320BC433D2;
        Wed, 11 Jan 2023 20:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470734;
        bh=lbr7Wcg3037bbxF7mvzK4IQK5T5/7KYg04W0Z/8Tq+w=;
        h=Date:To:From:Subject:From;
        b=1aYWkYT0z0s4aEZFDfkmWzFhacX1JG0jd9cd65gU2WDwxL7Fz3VvYP73zPIiWeDhd
         ySHwApN2N9ywfKhT+WRsy3zA6VLEhJtP0+dxH+0k/3Oi4ufSflUSW9EtxrUCBC8CPP
         DYAfBjZQOsD2NTm///6L8BIAt0JnM/9eS5SiZlf0=
Date:   Wed, 11 Jan 2023 12:58:54 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reimplement-compound_nr.patch added to mm-unstable branch
Message-Id: <20230111205854.B320BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: reimplement compound_nr()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-reimplement-compound_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reimplement-compound_nr.patch

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
Subject: mm: reimplement compound_nr()
Date: Wed, 11 Jan 2023 14:29:03 +0000

Turn compound_nr() into a wrapper around folio_nr_pages().  Similarly to
compound_order(), casting the struct page directly to struct folio
preserves the existing behaviour, while calling page_folio() would change
the behaviour.  Move thp_nr_pages() down in the file so that compound_nr()
can be after folio_nr_pages().

Link: https://lkml.kernel.org/r/20230111142915.1001531-18-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

--- a/include/linux/mm.h~mm-reimplement-compound_nr
+++ a/include/linux/mm.h
@@ -1005,18 +1005,6 @@ static inline void set_compound_order(st
 #endif
 }
 
-/* Returns the number of pages in this potentially compound page. */
-static inline unsigned long compound_nr(struct page *page)
-{
-	if (!PageHead(page))
-		return 1;
-#ifdef CONFIG_64BIT
-	return page[1].compound_nr;
-#else
-	return 1UL << compound_order(page);
-#endif
-}
-
 /* Returns the number of bytes in this potentially compound page. */
 static inline unsigned long page_size(struct page *page)
 {
@@ -1040,16 +1028,6 @@ static inline unsigned int thp_order(str
 }
 
 /**
- * thp_nr_pages - The number of regular pages in this huge page.
- * @page: The head page of a huge page.
- */
-static inline int thp_nr_pages(struct page *page)
-{
-	VM_BUG_ON_PGFLAGS(PageTail(page), page);
-	return compound_nr(page);
-}
-
-/**
  * thp_size - Size of a transparent huge page.
  * @page: Head page of a transparent huge page.
  *
@@ -1758,6 +1736,22 @@ static inline long folio_nr_pages(struct
 #endif
 }
 
+/* Returns the number of pages in this potentially compound page. */
+static inline unsigned long compound_nr(struct page *page)
+{
+	return folio_nr_pages((struct folio *)page);
+}
+
+/**
+ * thp_nr_pages - The number of regular pages in this huge page.
+ * @page: The head page of a huge page.
+ */
+static inline int thp_nr_pages(struct page *page)
+{
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	return compound_nr(page);
+}
+
 /**
  * folio_next - Move to the next physical folio.
  * @folio: The folio we're currently operating on.
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

