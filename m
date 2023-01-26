Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E9BC61DA7
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 23:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbjAZXCm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 18:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbjAZXCm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 18:02:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E8D53E63
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 15:02:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D6E961983
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 23:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D34C433EF;
        Thu, 26 Jan 2023 23:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674774159;
        bh=/FoNP0/Lvn3GXeIti5uOsVd4jWduSROr2Nkc4gQgbXM=;
        h=Date:To:From:Subject:From;
        b=pxOUsMBt6uskNIewIaYIaJOZFGNrnUCghoZaP9cu3DstsMW8Petp/tbX4fuD4jQPP
         mlhyQ2Dq/3SuM4nznldFOvjMQgh0enm7zKoVXGrlHPWLwjxd4RwHhZ2C5jbqIC2kzD
         9VC8l4YGGajGQbNeE1NuRPYE43lShOX3ZktR52wE=
Date:   Thu, 26 Jan 2023 15:02:39 -0800
To:     mm-commits@vger.kernel.org, hch@infradead.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mpage-convert-__mpage_writepage-to-use-a-folio-more-fully.patch added to mm-unstable branch
Message-Id: <20230126230239.A2D34C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mpage: convert __mpage_writepage() to use a folio more fully
has been added to the -mm mm-unstable branch.  Its filename is
     mpage-convert-__mpage_writepage-to-use-a-folio-more-fully.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mpage-convert-__mpage_writepage-to-use-a-folio-more-fully.patch

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
Subject: mpage: convert __mpage_writepage() to use a folio more fully
Date: Thu, 26 Jan 2023 20:12:55 +0000

This is just a conversion to the folio API.  While there are some nods
towards supporting multi-page folios in here, the blocks array is still
sized for one page's worth of blocks, and there are other assumptions such
as the blocks_per_page variable.

Link: https://lkml.kernel.org/r/20230126201255.1681189-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

--- a/fs/mpage.c~mpage-convert-__mpage_writepage-to-use-a-folio-more-fully
+++ a/fs/mpage.c
@@ -443,13 +443,11 @@ void clean_page_buffers(struct page *pag
 static int __mpage_writepage(struct folio *folio, struct writeback_control *wbc,
 		      void *data)
 {
-	struct page *page = &folio->page;
 	struct mpage_data *mpd = data;
 	struct bio *bio = mpd->bio;
-	struct address_space *mapping = page->mapping;
-	struct inode *inode = page->mapping->host;
+	struct address_space *mapping = folio->mapping;
+	struct inode *inode = mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
-	unsigned long end_index;
 	const unsigned blocks_per_page = PAGE_SIZE >> blkbits;
 	sector_t last_block;
 	sector_t block_in_file;
@@ -460,13 +458,13 @@ static int __mpage_writepage(struct foli
 	int boundary = 0;
 	sector_t boundary_block = 0;
 	struct block_device *boundary_bdev = NULL;
-	int length;
+	size_t length;
 	struct buffer_head map_bh;
 	loff_t i_size = i_size_read(inode);
 	int ret = 0;
+	struct buffer_head *head = folio_buffers(folio);
 
-	if (page_has_buffers(page)) {
-		struct buffer_head *head = page_buffers(page);
+	if (head) {
 		struct buffer_head *bh = head;
 
 		/* If they're all mapped and dirty, do it */
@@ -518,8 +516,8 @@ static int __mpage_writepage(struct foli
 	/*
 	 * The page has no buffers: map it to disk
 	 */
-	BUG_ON(!PageUptodate(page));
-	block_in_file = (sector_t)page->index << (PAGE_SHIFT - blkbits);
+	BUG_ON(!folio_test_uptodate(folio));
+	block_in_file = (sector_t)folio->index << (PAGE_SHIFT - blkbits);
 	/*
 	 * Whole page beyond EOF? Skip allocating blocks to avoid leaking
 	 * space.
@@ -527,7 +525,7 @@ static int __mpage_writepage(struct foli
 	if (block_in_file >= (i_size + (1 << blkbits) - 1) >> blkbits)
 		goto page_is_mapped;
 	last_block = (i_size - 1) >> blkbits;
-	map_bh.b_page = page;
+	map_bh.b_folio = folio;
 	for (page_block = 0; page_block < blocks_per_page; ) {
 
 		map_bh.b_state = 0;
@@ -556,8 +554,8 @@ static int __mpage_writepage(struct foli
 	first_unmapped = page_block;
 
 page_is_mapped:
-	end_index = i_size >> PAGE_SHIFT;
-	if (page->index >= end_index) {
+	length = folio_size(folio);
+	if (folio_pos(folio) + length > i_size) {
 		/*
 		 * The page straddles i_size.  It must be zeroed out on each
 		 * and every writepage invocation because it may be mmapped.
@@ -566,11 +564,10 @@ page_is_mapped:
 		 * is zeroed when mapped, and writes to that region are not
 		 * written out to the file."
 		 */
-		unsigned offset = i_size & (PAGE_SIZE - 1);
-
-		if (page->index > end_index || !offset)
+		length = i_size - folio_pos(folio);
+		if (WARN_ON_ONCE(folio_pos(folio) >= i_size))
 			goto confused;
-		zero_user_segment(page, offset, PAGE_SIZE);
+		folio_zero_segment(folio, length, folio_size(folio));
 	}
 
 	/*
@@ -593,18 +590,18 @@ alloc_new:
 	 * the confused fail path above (OOM) will be very confused when
 	 * it finds all bh marked clean (i.e. it will not write anything)
 	 */
-	wbc_account_cgroup_owner(wbc, page, PAGE_SIZE);
+	wbc_account_cgroup_owner(wbc, &folio->page, folio_size(folio));
 	length = first_unmapped << blkbits;
-	if (bio_add_page(bio, page, length, 0) < length) {
+	if (!bio_add_folio(bio, folio, length, 0)) {
 		bio = mpage_bio_submit(bio);
 		goto alloc_new;
 	}
 
-	clean_buffers(page, first_unmapped);
+	clean_buffers(&folio->page, first_unmapped);
 
-	BUG_ON(PageWriteback(page));
-	set_page_writeback(page);
-	unlock_page(page);
+	BUG_ON(folio_test_writeback(folio));
+	folio_start_writeback(folio);
+	folio_unlock(folio);
 	if (boundary || (first_unmapped != blocks_per_page)) {
 		bio = mpage_bio_submit(bio);
 		if (boundary_block) {
@@ -623,7 +620,7 @@ confused:
 	/*
 	 * The caller has a ref on the inode, so *mapping is stable
 	 */
-	ret = block_write_full_page(page, mpd->get_block, wbc);
+	ret = block_write_full_page(&folio->page, mpd->get_block, wbc);
 	mapping_set_error(mapping, ret);
 out:
 	mpd->bio = bio;
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
mm-add-memcpy_from_file_folio.patch
fs-convert-writepage_t-callback-to-pass-a-folio.patch
mpage-convert-__mpage_writepage-to-use-a-folio-more-fully.patch

