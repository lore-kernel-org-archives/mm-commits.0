From: akpm@linux-foundation.org
Subject: [merged] vfs-make-guard_bh_eod-more-generic.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:19:21 -0700
Message-ID: <543c17a9.P6Ev4N0SjX83ogc6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, axboe@kernel.dk, jmoyer@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: make guard_bh_eod() more generic
has been removed from the -mm tree.  Its filename was
     vfs-make-guard_bh_eod-more-generic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: vfs: make guard_bh_eod() more generic

This patchset implements readpages() operation for block device by using
mpage_readpages() which can create multipage BIOs instead of BIOs for each
page and reduce system CPU time consumption.


This patch (of 3):

guard_bh_eod() is used in submit_bh() to allow us to do IO even on the odd
last sectors of a device, even if the block size is some multiple of the
physical sector size.  This makes guard_bh_eod() more generic and renames
it guard_bio_eod() so that we can use it without struct buffer_head
argument.

The reason for this change is that using mpage_readpages() for block
device requires to add this guard check in mpage code.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff -puN fs/buffer.c~vfs-make-guard_bh_eod-more-generic fs/buffer.c
--- a/fs/buffer.c~vfs-make-guard_bh_eod-more-generic
+++ a/fs/buffer.c
@@ -2956,7 +2956,7 @@ static void end_bio_bh_io_sync(struct bi
 
 /*
  * This allows us to do IO even on the odd last sectors
- * of a device, even if the bh block size is some multiple
+ * of a device, even if the block size is some multiple
  * of the physical sector size.
  *
  * We'll just truncate the bio to the size of the device,
@@ -2966,10 +2966,11 @@ static void end_bio_bh_io_sync(struct bi
  * errors, this only handles the "we need to be able to
  * do IO at the final sector" case.
  */
-static void guard_bh_eod(int rw, struct bio *bio, struct buffer_head *bh)
+static void guard_bio_eod(int rw, struct bio *bio)
 {
 	sector_t maxsector;
-	unsigned bytes;
+	struct bio_vec *bvec = &bio->bi_io_vec[bio->bi_vcnt - 1];
+	unsigned truncated_bytes;
 
 	maxsector = i_size_read(bio->bi_bdev->bd_inode) >> 9;
 	if (!maxsector)
@@ -2984,23 +2985,20 @@ static void guard_bh_eod(int rw, struct
 		return;
 
 	maxsector -= bio->bi_iter.bi_sector;
-	bytes = bio->bi_iter.bi_size;
-	if (likely((bytes >> 9) <= maxsector))
+	if (likely((bio->bi_iter.bi_size >> 9) <= maxsector))
 		return;
 
-	/* Uhhuh. We've got a bh that straddles the device size! */
-	bytes = maxsector << 9;
+	/* Uhhuh. We've got a bio that straddles the device size! */
+	truncated_bytes = bio->bi_iter.bi_size - (maxsector << 9);
 
 	/* Truncate the bio.. */
-	bio->bi_iter.bi_size = bytes;
-	bio->bi_io_vec[0].bv_len = bytes;
+	bio->bi_iter.bi_size -= truncated_bytes;
+	bvec->bv_len -= truncated_bytes;
 
 	/* ..and clear the end of the buffer for reads */
 	if ((rw & RW_MASK) == READ) {
-		void *kaddr = kmap_atomic(bh->b_page);
-		memset(kaddr + bh_offset(bh) + bytes, 0, bh->b_size - bytes);
-		kunmap_atomic(kaddr);
-		flush_dcache_page(bh->b_page);
+		zero_user(bvec->bv_page, bvec->bv_offset + bvec->bv_len,
+				truncated_bytes);
 	}
 }
 
@@ -3041,7 +3039,7 @@ int _submit_bh(int rw, struct buffer_hea
 	bio->bi_flags |= bio_flags;
 
 	/* Take care of bh's that straddle the end of the device */
-	guard_bh_eod(rw, bio, bh);
+	guard_bio_eod(rw, bio);
 
 	if (buffer_meta(bh))
 		rw |= REQ_META;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch

