Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B80C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbjBCGou (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbjBCGnV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:43:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7172911AA
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEFF1B8298A
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8081FC4339B;
        Fri,  3 Feb 2023 06:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406332;
        bh=tifhlBs64Yd3td7B1AGG3IVbbluYltKiAKI1fKDK3OI=;
        h=Date:To:From:Subject:From;
        b=MNeNSLLtEs7M+iUQnd53pfAkSXUTocI+CqZCM6uNN3RMdxDTZoKBwlNBL1InPmckI
         2YwEdwTDlkeyDGN5qupbxv/D3YCAygENYB++xP024Ag5RZy3shTRRdTk6Y7CiLH8Vm
         OkwL3F7eSF6R3QELPYJea2mKbzjN4YDPJGMD7Xm4=
Date:   Thu, 02 Feb 2023 22:38:51 -0800
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mpage-convert-__mpage_writepage-to-use-a-folio-more-fully.patch removed from -mm tree
Message-Id: <20230203063852.8081FC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mpage: convert __mpage_writepage() to use a folio more fully
has been removed from the -mm tree.  Its filename was
     mpage-convert-__mpage_writepage-to-use-a-folio-more-fully.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mpage: convert __mpage_writepage() to use a folio more fully
Date: Thu, 26 Jan 2023 20:12:55 +0000

This is just a conversion to the folio API.  While there are some nods
towards supporting multi-page folios in here, the blocks array is still
sized for one page's worth of blocks, and there are other assumptions such
as the blocks_per_page variable.

[willy@infradead.org: fix accidentally-triggering WARN_ON_ONCE]
  Link: https://lkml.kernel.org/r/Y9kuaBgXf9lKJ8b0@casper.infradead.org
Link: https://lkml.kernel.org/r/20230126201255.1681189-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
@@ -556,8 +554,11 @@ static int __mpage_writepage(struct foli
 	first_unmapped = page_block;
 
 page_is_mapped:
-	end_index = i_size >> PAGE_SHIFT;
-	if (page->index >= end_index) {
+	/* Don't bother writing beyond EOF, truncate will discard the folio */
+	if (folio_pos(folio) >= i_size)
+		goto confused;
+	length = folio_size(folio);
+	if (folio_pos(folio) + length > i_size) {
 		/*
 		 * The page straddles i_size.  It must be zeroed out on each
 		 * and every writepage invocation because it may be mmapped.
@@ -566,11 +567,8 @@ page_is_mapped:
 		 * is zeroed when mapped, and writes to that region are not
 		 * written out to the file."
 		 */
-		unsigned offset = i_size & (PAGE_SIZE - 1);
-
-		if (page->index > end_index || !offset)
-			goto confused;
-		zero_user_segment(page, offset, PAGE_SIZE);
+		length = i_size - folio_pos(folio);
+		folio_zero_segment(folio, length, folio_size(folio));
 	}
 
 	/*
@@ -593,18 +591,18 @@ alloc_new:
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
@@ -623,7 +621,7 @@ confused:
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


