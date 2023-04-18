Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19AF3C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjDRXhD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbjDRXfw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901D8C670
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 728FB615F4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC12C433EF;
        Tue, 18 Apr 2023 23:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860905;
        bh=/4uoGyLZjXkVFZJRfgq6daS0j72KMoc3BCxdSynHS84=;
        h=Date:To:From:Subject:From;
        b=cEihK7efRMR/PlEzoswWJIL99S16yqzuuLtUaJ7oYjywy7S030FulFyhbf+n2Ry/M
         GTyURvRgS79MBiv010NKV6tgZPbF/Atxn8k6FAYdUwOu3rMnNANjWDLvgOw5gDdcXi
         EcLMYtvmZU3nYHPU4aIgetqB8dTDE2dMOWC+SSDA=
Date:   Tue, 18 Apr 2023 16:35:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, senozhatsky@chromium.org,
        minchan@kernel.org, mcgrof@kernel.org, martin@omnibond.com,
        hubcap@omnibond.com, hch@lst.de, brauner@kernel.org,
        axboe@kernel.dk, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mpage-split-submit_bio-and-bio-end_io-handler-for-reads-and-writes.patch removed from -mm tree
Message-Id: <20230418233505.CDC12C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mpage: split submit_bio and bio end_io handler for reads and writes
has been removed from the -mm tree.  Its filename was
     mpage-split-submit_bio-and-bio-end_io-handler-for-reads-and-writes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: mpage: split submit_bio and bio end_io handler for reads and writes
Date: Tue, 11 Apr 2023 14:29:19 +0200

Split the submit_bio() and bio end_io handler for reads and writes similar
to other aops.

This is a prep patch before we convert end_io handlers to use folios.

Link: https://lkml.kernel.org/r/20230411122920.30134-3-p.raghav@samsung.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Martin Brandenburg <martin@omnibond.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   54 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 18 deletions(-)

--- a/fs/mpage.c~mpage-split-submit_bio-and-bio-end_io-handler-for-reads-and-writes
+++ a/fs/mpage.c
@@ -43,23 +43,41 @@
  * status of that page is hard.  See end_buffer_async_read() for the details.
  * There is no point in duplicating all that complexity.
  */
-static void mpage_end_io(struct bio *bio)
+static void mpage_read_end_io(struct bio *bio)
 {
 	struct bio_vec *bv;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bv, bio, iter_all) {
-		struct page *page = bv->bv_page;
-		page_endio(page, bio_op(bio),
+	bio_for_each_segment_all(bv, bio, iter_all)
+		page_endio(bv->bv_page, REQ_OP_READ,
 			   blk_status_to_errno(bio->bi_status));
-	}
 
 	bio_put(bio);
 }
 
-static struct bio *mpage_bio_submit(struct bio *bio)
+static void mpage_write_end_io(struct bio *bio)
+{
+	struct bio_vec *bv;
+	struct bvec_iter_all iter_all;
+
+	bio_for_each_segment_all(bv, bio, iter_all)
+		page_endio(bv->bv_page, REQ_OP_WRITE,
+			   blk_status_to_errno(bio->bi_status));
+
+	bio_put(bio);
+}
+
+static struct bio *mpage_bio_submit_read(struct bio *bio)
+{
+	bio->bi_end_io = mpage_read_end_io;
+	guard_bio_eod(bio);
+	submit_bio(bio);
+	return NULL;
+}
+
+static struct bio *mpage_bio_submit_write(struct bio *bio)
 {
-	bio->bi_end_io = mpage_end_io;
+	bio->bi_end_io = mpage_write_end_io;
 	guard_bio_eod(bio);
 	submit_bio(bio);
 	return NULL;
@@ -265,7 +283,7 @@ static struct bio *do_mpage_readpage(str
 	 * This folio will go to BIO.  Do we need to send this BIO off first?
 	 */
 	if (args->bio && (args->last_block_in_bio != blocks[0] - 1))
-		args->bio = mpage_bio_submit(args->bio);
+		args->bio = mpage_bio_submit_read(args->bio);
 
 alloc_new:
 	if (args->bio == NULL) {
@@ -278,7 +296,7 @@ alloc_new:
 
 	length = first_hole << blkbits;
 	if (!bio_add_folio(args->bio, folio, length, 0)) {
-		args->bio = mpage_bio_submit(args->bio);
+		args->bio = mpage_bio_submit_read(args->bio);
 		goto alloc_new;
 	}
 
@@ -286,7 +304,7 @@ alloc_new:
 	nblocks = map_bh->b_size >> blkbits;
 	if ((buffer_boundary(map_bh) && relative_block == nblocks) ||
 	    (first_hole != blocks_per_page))
-		args->bio = mpage_bio_submit(args->bio);
+		args->bio = mpage_bio_submit_read(args->bio);
 	else
 		args->last_block_in_bio = blocks[blocks_per_page - 1];
 out:
@@ -294,7 +312,7 @@ out:
 
 confused:
 	if (args->bio)
-		args->bio = mpage_bio_submit(args->bio);
+		args->bio = mpage_bio_submit_read(args->bio);
 	if (!folio_test_uptodate(folio))
 		block_read_full_folio(folio, args->get_block);
 	else
@@ -356,7 +374,7 @@ void mpage_readahead(struct readahead_co
 		args.bio = do_mpage_readpage(&args);
 	}
 	if (args.bio)
-		mpage_bio_submit(args.bio);
+		mpage_bio_submit_read(args.bio);
 }
 EXPORT_SYMBOL(mpage_readahead);
 
@@ -373,7 +391,7 @@ int mpage_read_folio(struct folio *folio
 
 	args.bio = do_mpage_readpage(&args);
 	if (args.bio)
-		mpage_bio_submit(args.bio);
+		mpage_bio_submit_read(args.bio);
 	return 0;
 }
 EXPORT_SYMBOL(mpage_read_folio);
@@ -577,7 +595,7 @@ page_is_mapped:
 	 * This page will go to BIO.  Do we need to send this BIO off first?
 	 */
 	if (bio && mpd->last_block_in_bio != blocks[0] - 1)
-		bio = mpage_bio_submit(bio);
+		bio = mpage_bio_submit_write(bio);
 
 alloc_new:
 	if (bio == NULL) {
@@ -596,7 +614,7 @@ alloc_new:
 	wbc_account_cgroup_owner(wbc, &folio->page, folio_size(folio));
 	length = first_unmapped << blkbits;
 	if (!bio_add_folio(bio, folio, length, 0)) {
-		bio = mpage_bio_submit(bio);
+		bio = mpage_bio_submit_write(bio);
 		goto alloc_new;
 	}
 
@@ -606,7 +624,7 @@ alloc_new:
 	folio_start_writeback(folio);
 	folio_unlock(folio);
 	if (boundary || (first_unmapped != blocks_per_page)) {
-		bio = mpage_bio_submit(bio);
+		bio = mpage_bio_submit_write(bio);
 		if (boundary_block) {
 			write_boundary_block(boundary_bdev,
 					boundary_block, 1 << blkbits);
@@ -618,7 +636,7 @@ alloc_new:
 
 confused:
 	if (bio)
-		bio = mpage_bio_submit(bio);
+		bio = mpage_bio_submit_write(bio);
 
 	/*
 	 * The caller has a ref on the inode, so *mapping is stable
@@ -652,7 +670,7 @@ mpage_writepages(struct address_space *m
 	blk_start_plug(&plug);
 	ret = write_cache_pages(mapping, wbc, __mpage_writepage, &mpd);
 	if (mpd.bio)
-		mpage_bio_submit(mpd.bio);
+		mpage_bio_submit_write(mpd.bio);
 	blk_finish_plug(&plug);
 	return ret;
 }
_

Patches currently in -mm which might be from p.raghav@samsung.com are

mpage-use-folios-in-bio-end_io-handler.patch
fs-buffer-add-folio_set_bh-helper.patch
buffer-add-folio_alloc_buffers-helper.patch
fs-buffer-add-folio_create_empty_buffers-helper.patch
fs-buffer-convert-create_page_buffers-to-folio_create_buffers.patch

