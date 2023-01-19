Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DDFC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjASBP6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjASBOn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BDC689E9
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5628CB81D66
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCAFC433EF;
        Thu, 19 Jan 2023 01:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090851;
        bh=bGn0MyoyUHNHXd/zVVz4/9P0VbfLd0YrZFZ/zLMIusM=;
        h=Date:To:From:Subject:From;
        b=I4ssrsk5Y5qiLhYpi78cdVm8bBYH7z8HRhsxOiCMsWz5xLebtVCiUJsoQs7lXMYnf
         1aj2VIRkMQwy+9ZIjHgominXyWZ+S8VMZ96gHamppCqIoQksg0VIQYs1+Gb0fBvtn7
         n/G8CZGeNqwMh6dlzeaXF5evzefGauk3dC27iHLA=
Date:   Wed, 18 Jan 2023 17:14:10 -0800
To:     mm-commits@vger.kernel.org, jack@suse.cz, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch removed from -mm tree
Message-Id: <20230119011410.EBCAFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: jbd2: replace obvious uses of b_page with b_folio
has been removed from the -mm tree.  Its filename was
     jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: jbd2: replace obvious uses of b_page with b_folio
Date: Thu, 15 Dec 2022 21:43:59 +0000

These places just use b_page to get to the buffer's address_space or have
already been converted to folio.

Link: https://lkml.kernel.org/r/20221215214402.3522366-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/commit.c  |    8 ++------
 fs/jbd2/journal.c |    2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

--- a/fs/jbd2/commit.c~jbd2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/jbd2/commit.c
@@ -63,16 +63,12 @@ static void journal_end_buffer_io_sync(s
 static void release_buffer_page(struct buffer_head *bh)
 {
 	struct folio *folio;
-	struct page *page;
 
 	if (buffer_dirty(bh))
 		goto nope;
 	if (atomic_read(&bh->b_count) != 1)
 		goto nope;
-	page = bh->b_page;
-	if (!page)
-		goto nope;
-	folio = page_folio(page);
+	folio = bh->b_folio;
 	if (folio->mapping)
 		goto nope;
 
@@ -1040,7 +1036,7 @@ restart_loop:
 			 * already detached from the mapping and buffers cannot
 			 * get reused.
 			 */
-			mapping = READ_ONCE(bh->b_page->mapping);
+			mapping = READ_ONCE(bh->b_folio->mapping);
 			if (mapping && !sb_is_blkdev_sb(mapping->host->i_sb)) {
 				clear_buffer_mapped(bh);
 				clear_buffer_new(bh);
--- a/fs/jbd2/journal.c~jbd2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/jbd2/journal.c
@@ -2938,7 +2938,7 @@ repeat:
 	} else {
 		J_ASSERT_BH(bh,
 			(atomic_read(&bh->b_count) > 0) ||
-			(bh->b_page && bh->b_page->mapping));
+			(bh->b_folio && bh->b_folio->mapping));
 
 		if (!new_jh) {
 			jbd_unlock_bh_journal_head(bh);
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

