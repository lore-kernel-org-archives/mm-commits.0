Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89871C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjASBPm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjASBOa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9B56923B
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67706B81D66
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B5DC433EF;
        Thu, 19 Jan 2023 01:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090844;
        bh=n6i/YcgIHuHnWJbxTy8CmVKxDStyRQdnnQb/1u9cvqU=;
        h=Date:To:From:Subject:From;
        b=FtsJyi5pWmEnJA/oKUNHzCHgVqjrJPxfoBUJQuBVe73vEPNFX30vBc3KrNbjD8fcM
         mWjQwJXVsSgf6cTJg0OMAm6q8cD6MGFImbLwZUtPVmjHVK5rDCM4OKjaBJwnu17T/5
         tDzEcMs++YMAz7wEOjyXAYvJmm39Smq+B6aCwyjE=
Date:   Wed, 18 Jan 2023 17:14:03 -0800
To:     mm-commits@vger.kernel.org, jack@suse.cz, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-use-b_folio-in-end_buffer_async_read.patch removed from -mm tree
Message-Id: <20230119011404.15B5DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: use b_folio in end_buffer_async_read()
has been removed from the -mm tree.  Its filename was
     buffer-use-b_folio-in-end_buffer_async_read.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: use b_folio in end_buffer_async_read()
Date: Thu, 15 Dec 2022 21:43:54 +0000

Removes a call to compound_head() in SetPageError(), saving 76 bytes of
text.

Link: https://lkml.kernel.org/r/20221215214402.3522366-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/buffer.c~buffer-use-b_folio-in-end_buffer_async_read
+++ a/fs/buffer.c
@@ -246,18 +246,18 @@ static void end_buffer_async_read(struct
 	unsigned long flags;
 	struct buffer_head *first;
 	struct buffer_head *tmp;
-	struct page *page;
-	int page_uptodate = 1;
+	struct folio *folio;
+	int folio_uptodate = 1;
 
 	BUG_ON(!buffer_async_read(bh));
 
-	page = bh->b_page;
+	folio = bh->b_folio;
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
 		clear_buffer_uptodate(bh);
 		buffer_io_error(bh, ", async page read");
-		SetPageError(page);
+		folio_set_error(folio);
 	}
 
 	/*
@@ -265,14 +265,14 @@ static void end_buffer_async_read(struct
 	 * two buffer heads end IO at almost the same time and both
 	 * decide that the page is now completely done.
 	 */
-	first = page_buffers(page);
+	first = folio_buffers(folio);
 	spin_lock_irqsave(&first->b_uptodate_lock, flags);
 	clear_buffer_async_read(bh);
 	unlock_buffer(bh);
 	tmp = bh;
 	do {
 		if (!buffer_uptodate(tmp))
-			page_uptodate = 0;
+			folio_uptodate = 0;
 		if (buffer_async_read(tmp)) {
 			BUG_ON(!buffer_locked(tmp));
 			goto still_busy;
@@ -285,9 +285,9 @@ static void end_buffer_async_read(struct
 	 * If all of the buffers are uptodate then we can set the page
 	 * uptodate.
 	 */
-	if (page_uptodate)
-		SetPageUptodate(page);
-	unlock_page(page);
+	if (folio_uptodate)
+		folio_mark_uptodate(folio);
+	folio_unlock(folio);
 	return;
 
 still_busy:
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
mm-add-folio_add_new_anon_rmap-fix-2.patch
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
mm-reimplement-compound_nr-fix.patch
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
shmem-convert-shmem_write_end-to-use-a-folio.patch
mm-add-vma_alloc_zeroed_movable_folio.patch
mm-convert-do_anonymous_page-to-use-a-folio.patch
mm-convert-wp_page_copy-to-use-folios.patch
mm-use-a-folio-in-copy_pte_range.patch
mm-use-a-folio-in-copy_present_pte.patch
mm-fs-convert-inode_attach_wb-to-take-a-folio.patch
mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch
mm-remove-page_evictable.patch
mm-remove-mlock_vma_page.patch
mm-remove-munlock_vma_page.patch
mm-clean-up-mlock_page-munlock_page-references-in-comments.patch
rmap-add-folio-parameter-to-__page_set_anon_rmap.patch
filemap-convert-filemap_map_pmd-to-take-a-folio.patch
filemap-convert-filemap_range_has_page-to-use-a-folio.patch
readahead-convert-readahead_expand-to-use-a-folio.patch

