From: akpm@linux-foundation.org
Subject: +
 fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch added
 to -mm tree
Date: Thu, 13 Mar 2014 14:35:34 -0700
Message-ID: <532224a6.L81nCdwQGMyv3dY+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaCMVff (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Mar 2014 17:35:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, jack@suse.cz, axboe@kernel.dk, r.peniaev@gmail.com

Subject: + fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch added to -mm tree
To: r.peniaev@gmail.com,axboe@kernel.dk,jack@suse.cz,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Mar 2014 14:35:34 -0700


The patch titled
     Subject: fs/mpage.c: forgotten WRITE_SYNC in case of data integrity write
has been added to the -mm tree.  Its filename is
     fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Pen <r.peniaev@gmail.com>
Subject: fs/mpage.c: forgotten WRITE_SYNC in case of data integrity write

In case of wbc->sync_mode == WB_SYNC_ALL we need to do data integrity
write, thus mark request as WRITE_SYNC.

akpm: afaict this change will cause the data integrity write bios to be
placed onto the second queue in cfq_io_cq.cfqq[], which presumably results
in special treatment.  The documentation for REQ_SYNC is horrid.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN fs/mpage.c~fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write fs/mpage.c
--- a/fs/mpage.c~fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write
+++ a/fs/mpage.c
@@ -462,6 +462,7 @@ static int __mpage_writepage(struct page
 	struct buffer_head map_bh;
 	loff_t i_size = i_size_read(inode);
 	int ret = 0;
+	int wr = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC : WRITE);
 
 	if (page_has_buffers(page)) {
 		struct buffer_head *head = page_buffers(page);
@@ -570,7 +571,7 @@ page_is_mapped:
 	 * This page will go to BIO.  Do we need to send this BIO off first?
 	 */
 	if (bio && mpd->last_block_in_bio != blocks[0] - 1)
-		bio = mpage_bio_submit(WRITE, bio);
+		bio = mpage_bio_submit(wr, bio);
 
 alloc_new:
 	if (bio == NULL) {
@@ -587,7 +588,7 @@ alloc_new:
 	 */
 	length = first_unmapped << blkbits;
 	if (bio_add_page(bio, page, length, 0) < length) {
-		bio = mpage_bio_submit(WRITE, bio);
+		bio = mpage_bio_submit(wr, bio);
 		goto alloc_new;
 	}
 
@@ -620,7 +621,7 @@ alloc_new:
 	set_page_writeback(page);
 	unlock_page(page);
 	if (boundary || (first_unmapped != blocks_per_page)) {
-		bio = mpage_bio_submit(WRITE, bio);
+		bio = mpage_bio_submit(wr, bio);
 		if (boundary_block) {
 			write_boundary_block(boundary_bdev,
 					boundary_block, 1 << blkbits);
@@ -632,7 +633,7 @@ alloc_new:
 
 confused:
 	if (bio)
-		bio = mpage_bio_submit(WRITE, bio);
+		bio = mpage_bio_submit(wr, bio);
 
 	if (mpd->use_writepage) {
 		ret = mapping->a_ops->writepage(page, wbc);
@@ -688,8 +689,11 @@ mpage_writepages(struct address_space *m
 		};
 
 		ret = write_cache_pages(mapping, wbc, __mpage_writepage, &mpd);
-		if (mpd.bio)
-			mpage_bio_submit(WRITE, mpd.bio);
+		if (mpd.bio) {
+			int wr = (wbc->sync_mode == WB_SYNC_ALL ?
+				  WRITE_SYNC : WRITE);
+			mpage_bio_submit(wr, mpd.bio);
+		}
 	}
 	blk_finish_plug(&plug);
 	return ret;
@@ -706,8 +710,11 @@ int mpage_writepage(struct page *page, g
 		.use_writepage = 0,
 	};
 	int ret = __mpage_writepage(page, wbc, &mpd);
-	if (mpd.bio)
-		mpage_bio_submit(WRITE, mpd.bio);
+	if (mpd.bio) {
+		int wr = (wbc->sync_mode == WB_SYNC_ALL ?
+			  WRITE_SYNC : WRITE);
+		mpage_bio_submit(wr, mpd.bio);
+	}
 	return ret;
 }
 EXPORT_SYMBOL(mpage_writepage);
_

Patches currently in -mm which might be from r.peniaev@gmail.com are

fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
linux-next.patch

