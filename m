Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725A8C46467
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbjAKU7M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235196AbjAKU6y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:58:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DE4C11
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:58:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 975A161E5D
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BD4C433EF;
        Wed, 11 Jan 2023 20:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470733;
        bh=hzp70C7hT5moYI4g6K1K4hoME6jGuxHrniOiYakm4jQ=;
        h=Date:To:From:Subject:From;
        b=qoy3kIx3SjUvOEbEbDhESZo3Nh22KJdm7D9mRpPn0OB+S/RPTFqaa4FjxRd7MwK/C
         Zbr2uWJz3J72vZhxheVneaw1yzzyc9WpyYyNGhI9KuBJeGCCgzXzrnORZcus6JMULC
         c9ON/9NxEMsmTL1b3tsfJ+jMCqKiFtFGjWBGyKgQ=
Date:   Wed, 11 Jan 2023 12:58:52 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reimplement-compound_order.patch added to mm-unstable branch
Message-Id: <20230111205852.F3BD4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: reimplement compound_order()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-reimplement-compound_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reimplement-compound_order.patch

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
Subject: mm: reimplement compound_order()
Date: Wed, 11 Jan 2023 14:29:02 +0000

Make compound_order() use struct folio.  It can't be turned into a wrapper
around folio_order() as a page can be turned into a tail page between a
check in compound_order() and the assertion in folio_test_large().

Link: https://lkml.kernel.org/r/20230111142915.1001531-17-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-reimplement-compound_order
+++ a/include/linux/mm.h
@@ -719,11 +719,20 @@ int vma_is_stack_for_current(struct vm_a
 struct mmu_gather;
 struct inode;
 
+/*
+ * compound_order() can be called without holding a reference, which means
+ * that niceties like page_folio() don't work.  These callers should be
+ * prepared to handle wild return values.  For example, PG_head may be
+ * set before _folio_order is initialised, or this may be a tail page.
+ * See compaction.c for some good examples.
+ */
 static inline unsigned int compound_order(struct page *page)
 {
-	if (!PageHead(page))
+	struct folio *folio = (struct folio *)page;
+
+	if (!test_bit(PG_head, &folio->flags))
 		return 0;
-	return page[1].compound_order;
+	return folio->_folio_order;
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

