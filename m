Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A24ECAAD1
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 22:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiH0W3I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 18:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiH0W3D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 18:29:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD6243E56
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 15:29:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC82CB80A53
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 22:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFC2C433D6;
        Sat, 27 Aug 2022 22:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661639339;
        bh=IeN0Q4WdQ8IAsSg/ZnYpZ1O39qlh9q8YPv1mc5jgWUs=;
        h=Date:To:From:Subject:From;
        b=y+iCWzwaLxSNziWzHCwYy331claYkzRI1ruI/Jal90+FOecFblbCIZwNIfF2fQSMO
         4rqjZ94c19JmaCAu3y66g7SdWd2jka2eGjmFJfpuI0Xxv/N+ewDkM6O962siBhbSJj
         20bWEIrrs3Nt5lDqEbzV3L1XBAIPWqeXx8Hj9k84=
Date:   Sat, 27 Aug 2022 15:28:58 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        logang@deltatee.com, jack@suse.cz, hch@infradead.org,
        djwong@kernel.org, axboe@kernel.dk, anna@kernel.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast.patch added to mm-unstable branch
Message-Id: <20220827222859.7BFC2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: block, bio, fs: convert most filesystems to pin_user_pages_fast()
has been added to the -mm mm-unstable branch.  Its filename is
     block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast.patch

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
From: John Hubbard <jhubbard@nvidia.com>
Subject: block, bio, fs: convert most filesystems to pin_user_pages_fast()
Date: Sat, 27 Aug 2022 01:36:05 -0700

Use dio_w_*() wrapper calls, in place of get_user_pages_fast(), get_page()
and put_page().

This converts the Direct IO parts of most filesystems over to using
FOLL_PIN (pin_user_page*()) page pinning.

Link: https://lkml.kernel.org/r/20220827083607.2345453-5-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bio.c          |   27 ++++++++++++++-------------
 block/blk-map.c      |    7 ++++---
 fs/direct-io.c       |   40 ++++++++++++++++++++--------------------
 fs/iomap/direct-io.c |    2 +-
 4 files changed, 39 insertions(+), 37 deletions(-)

--- a/block/bio.c~block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast
+++ a/block/bio.c
@@ -1125,7 +1125,7 @@ void __bio_release_pages(struct bio *bio
 	bio_for_each_segment_all(bvec, bio, iter_all) {
 		if (mark_dirty && !PageCompound(bvec->bv_page))
 			set_page_dirty_lock(bvec->bv_page);
-		put_page(bvec->bv_page);
+		dio_w_unpin_user_page(bvec->bv_page);
 	}
 }
 EXPORT_SYMBOL_GPL(__bio_release_pages);
@@ -1162,7 +1162,7 @@ static int bio_iov_add_page(struct bio *
 	}
 
 	if (same_page)
-		put_page(page);
+		dio_w_unpin_user_page(page);
 	return 0;
 }
 
@@ -1176,7 +1176,7 @@ static int bio_iov_add_zone_append_page(
 			queue_max_zone_append_sectors(q), &same_page) != len)
 		return -EINVAL;
 	if (same_page)
-		put_page(page);
+		dio_w_unpin_user_page(page);
 	return 0;
 }
 
@@ -1187,10 +1187,10 @@ static int bio_iov_add_zone_append_page(
  * @bio: bio to add pages to
  * @iter: iov iterator describing the region to be mapped
  *
- * Pins pages from *iter and appends them to @bio's bvec array. The
- * pages will have to be released using put_page() when done.
- * For multi-segment *iter, this function only adds pages from the
- * next non-empty segment of the iov iterator.
+ * Pins pages from *iter and appends them to @bio's bvec array. The pages will
+ * have to be released using dio_w_unpin_user_page when done. For multi-segment
+ * *iter, this function only adds pages from the next non-empty segment of the
+ * iov iterator.
  */
 static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 {
@@ -1218,8 +1218,9 @@ static int __bio_iov_iter_get_pages(stru
 	 * result to ensure the bio's total size is correct. The remainder of
 	 * the iov data will be picked up in the next bio iteration.
 	 */
-	size = iov_iter_get_pages2(iter, pages, UINT_MAX - bio->bi_iter.bi_size,
-				  nr_pages, &offset);
+	size = dio_w_iov_iter_pin_pages(iter, pages,
+					UINT_MAX - bio->bi_iter.bi_size,
+					nr_pages, &offset);
 	if (unlikely(size <= 0))
 		return size ? size : -EFAULT;
 
@@ -1252,7 +1253,7 @@ static int __bio_iov_iter_get_pages(stru
 	iov_iter_revert(iter, left);
 out:
 	while (i < nr_pages)
-		put_page(pages[i++]);
+		dio_w_unpin_user_page(pages[i++]);
 
 	return ret;
 }
@@ -1444,9 +1445,9 @@ void bio_set_pages_dirty(struct bio *bio
  * have been written out during the direct-IO read.  So we take another ref on
  * the BIO and re-dirty the pages in process context.
  *
- * It is expected that bio_check_pages_dirty() will wholly own the BIO from
- * here on.  It will run one put_page() against each page and will run one
- * bio_put() against the BIO.
+ * It is expected that bio_check_pages_dirty() will wholly own the BIO from here
+ * on.  It will run one dio_w_unpin_user_page() against each page and will run
+ * one bio_put() against the BIO.
  */
 
 static void bio_dirty_fn(struct work_struct *work);
--- a/block/blk-map.c~block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast
+++ a/block/blk-map.c
@@ -254,7 +254,8 @@ static int bio_map_user_iov(struct reque
 		size_t offs, added = 0;
 		int npages;
 
-		bytes = iov_iter_get_pages_alloc2(iter, &pages, LONG_MAX, &offs);
+		bytes = dio_w_iov_iter_pin_pages_alloc(iter, &pages, LONG_MAX,
+						       &offs);
 		if (unlikely(bytes <= 0)) {
 			ret = bytes ? bytes : -EFAULT;
 			goto out_unmap;
@@ -276,7 +277,7 @@ static int bio_map_user_iov(struct reque
 				if (!bio_add_hw_page(rq->q, bio, page, n, offs,
 						     max_sectors, &same_page)) {
 					if (same_page)
-						put_page(page);
+						dio_w_unpin_user_page(page);
 					break;
 				}
 
@@ -289,7 +290,7 @@ static int bio_map_user_iov(struct reque
 		 * release the pages we didn't map into the bio, if any
 		 */
 		while (j < npages)
-			put_page(pages[j++]);
+			dio_w_unpin_user_page(pages[j++]);
 		kvfree(pages);
 		/* couldn't stuff something into bio? */
 		if (bytes) {
--- a/fs/direct-io.c~block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast
+++ a/fs/direct-io.c
@@ -169,8 +169,8 @@ static inline int dio_refill_pages(struc
 	const enum req_op dio_op = dio->opf & REQ_OP_MASK;
 	ssize_t ret;
 
-	ret = iov_iter_get_pages2(sdio->iter, dio->pages, LONG_MAX, DIO_PAGES,
-				&sdio->from);
+	ret = dio_w_iov_iter_pin_pages(sdio->iter, dio->pages, LONG_MAX,
+				       DIO_PAGES, &sdio->from);
 
 	if (ret < 0 && sdio->blocks_available && dio_op == REQ_OP_WRITE) {
 		struct page *page = ZERO_PAGE(0);
@@ -181,7 +181,7 @@ static inline int dio_refill_pages(struc
 		 */
 		if (dio->page_errors == 0)
 			dio->page_errors = ret;
-		get_page(page);
+		dio_w_pin_user_page(page);
 		dio->pages[0] = page;
 		sdio->head = 0;
 		sdio->tail = 1;
@@ -197,7 +197,7 @@ static inline int dio_refill_pages(struc
 		sdio->to = ((ret - 1) & (PAGE_SIZE - 1)) + 1;
 		return 0;
 	}
-	return ret;	
+	return ret;
 }
 
 /*
@@ -324,7 +324,7 @@ static void dio_aio_complete_work(struct
 static blk_status_t dio_bio_complete(struct dio *dio, struct bio *bio);
 
 /*
- * Asynchronous IO callback. 
+ * Asynchronous IO callback.
  */
 static void dio_bio_end_aio(struct bio *bio)
 {
@@ -449,7 +449,7 @@ static inline void dio_bio_submit(struct
 static inline void dio_cleanup(struct dio *dio, struct dio_submit *sdio)
 {
 	while (sdio->head < sdio->tail)
-		put_page(dio->pages[sdio->head++]);
+		dio_w_unpin_user_page(dio->pages[sdio->head++]);
 }
 
 /*
@@ -716,7 +716,7 @@ static inline int dio_bio_add_page(struc
 		 */
 		if ((sdio->cur_page_len + sdio->cur_page_offset) == PAGE_SIZE)
 			sdio->pages_in_io--;
-		get_page(sdio->cur_page);
+		dio_w_pin_user_page(sdio->cur_page);
 		sdio->final_block_in_bio = sdio->cur_page_block +
 			(sdio->cur_page_len >> sdio->blkbits);
 		ret = 0;
@@ -725,7 +725,7 @@ static inline int dio_bio_add_page(struc
 	}
 	return ret;
 }
-		
+
 /*
  * Put cur_page under IO.  The section of cur_page which is described by
  * cur_page_offset,cur_page_len is put into a BIO.  The section of cur_page
@@ -787,7 +787,7 @@ out:
  * An autonomous function to put a chunk of a page under deferred IO.
  *
  * The caller doesn't actually know (or care) whether this piece of page is in
- * a BIO, or is under IO or whatever.  We just take care of all possible 
+ * a BIO, or is under IO or whatever.  We just take care of all possible
  * situations here.  The separation between the logic of do_direct_IO() and
  * that of submit_page_section() is important for clarity.  Please don't break.
  *
@@ -832,13 +832,13 @@ submit_page_section(struct dio *dio, str
 	 */
 	if (sdio->cur_page) {
 		ret = dio_send_cur_page(dio, sdio, map_bh);
-		put_page(sdio->cur_page);
+		dio_w_unpin_user_page(sdio->cur_page);
 		sdio->cur_page = NULL;
 		if (ret)
 			return ret;
 	}
 
-	get_page(page);		/* It is in dio */
+	dio_w_pin_user_page(page); /* It is in dio */
 	sdio->cur_page = page;
 	sdio->cur_page_offset = offset;
 	sdio->cur_page_len = len;
@@ -853,7 +853,7 @@ out:
 		ret = dio_send_cur_page(dio, sdio, map_bh);
 		if (sdio->bio)
 			dio_bio_submit(dio, sdio);
-		put_page(sdio->cur_page);
+		dio_w_unpin_user_page(sdio->cur_page);
 		sdio->cur_page = NULL;
 	}
 	return ret;
@@ -890,7 +890,7 @@ static inline void dio_zero_block(struct
 	 * We need to zero out part of an fs block.  It is either at the
 	 * beginning or the end of the fs block.
 	 */
-	if (end) 
+	if (end)
 		this_chunk_blocks = dio_blocks_per_fs_block - this_chunk_blocks;
 
 	this_chunk_bytes = this_chunk_blocks << sdio->blkbits;
@@ -954,7 +954,7 @@ static int do_direct_IO(struct dio *dio,
 
 				ret = get_more_blocks(dio, sdio, map_bh);
 				if (ret) {
-					put_page(page);
+					dio_w_unpin_user_page(page);
 					goto out;
 				}
 				if (!buffer_mapped(map_bh))
@@ -999,7 +999,7 @@ do_holes:
 
 				/* AKPM: eargh, -ENOTBLK is a hack */
 				if (dio_op == REQ_OP_WRITE) {
-					put_page(page);
+					dio_w_unpin_user_page(page);
 					return -ENOTBLK;
 				}
 
@@ -1012,7 +1012,7 @@ do_holes:
 				if (sdio->block_in_file >=
 						i_size_aligned >> blkbits) {
 					/* We hit eof */
-					put_page(page);
+					dio_w_unpin_user_page(page);
 					goto out;
 				}
 				zero_user(page, from, 1 << blkbits);
@@ -1052,7 +1052,7 @@ do_holes:
 						  sdio->next_block_for_io,
 						  map_bh);
 			if (ret) {
-				put_page(page);
+				dio_w_unpin_user_page(page);
 				goto out;
 			}
 			sdio->next_block_for_io += this_chunk_blocks;
@@ -1067,8 +1067,8 @@ next_block:
 				break;
 		}
 
-		/* Drop the ref which was taken in get_user_pages() */
-		put_page(page);
+		/* Drop the ref which was taken in [get|pin]_user_pages() */
+		dio_w_unpin_user_page(page);
 	}
 out:
 	return ret;
@@ -1288,7 +1288,7 @@ ssize_t __blockdev_direct_IO(struct kioc
 		ret2 = dio_send_cur_page(dio, &sdio, &map_bh);
 		if (retval == 0)
 			retval = ret2;
-		put_page(sdio.cur_page);
+		dio_w_unpin_user_page(sdio.cur_page);
 		sdio.cur_page = NULL;
 	}
 	if (sdio.bio)
--- a/fs/iomap/direct-io.c~block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast
+++ a/fs/iomap/direct-io.c
@@ -202,7 +202,7 @@ static void iomap_dio_zero(const struct
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
-	get_page(page);
+	dio_w_pin_user_page(page);
 	__bio_add_page(bio, page, len, 0);
 	iomap_dio_submit_bio(iter, dio, bio, pos);
 }
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-introduce-pin_user_page.patch
block-add-dio_w_-wrappers-for-pin-unpin-user-pages.patch
iov_iter-new-iov_iter_pin_pages-routines.patch
block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast.patch
nfs-direct-io-convert-to-foll_pin-pages.patch
fuse-convert-direct-io-paths-to-use-foll_pin.patch

