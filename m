From: akpm@linux-foundation.org
Subject: + vfs-make-guard_bh_eod-more-generic.patch added to -mm tree
Date: Thu, 21 Aug 2014 14:44:17 -0700
Message-ID: <53f66831.GfNAExqnDltkEH5z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:41172 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbaHUVoT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 17:44:19 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so1179578vcb.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 14:44:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, axboe@kernel.dk, jmoyer@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: make guard_bh_eod() more generic
has been added to the -mm tree.  Its filename is
     vfs-make-guard_bh_eod-more-generic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-make-guard_bh_eod-more-generic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-make-guard_bh_eod-more-generic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2954,7 +2954,7 @@ static void end_bio_bh_io_sync(struct bi
 
 /*
  * This allows us to do IO even on the odd last sectors
- * of a device, even if the bh block size is some multiple
+ * of a device, even if the block size is some multiple
  * of the physical sector size.
  *
  * We'll just truncate the bio to the size of the device,
@@ -2964,10 +2964,11 @@ static void end_bio_bh_io_sync(struct bi
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
@@ -2982,23 +2983,20 @@ static void guard_bh_eod(int rw, struct
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
 
@@ -3039,7 +3037,7 @@ int _submit_bh(int rw, struct buffer_hea
 	bio->bi_flags |= bio_flags;
 
 	/* Take care of bh's that straddle the end of the device */
-	guard_bh_eod(rw, bio, bh);
+	guard_bio_eod(rw, bio);
 
 	if (buffer_meta(bh))
 		rw |= REQ_META;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

vfs-make-guard_bh_eod-more-generic.patch
vfs-guard-end-of-device-for-mpage-interface.patch
block_dev-implement-readpages-to-optimize-sequential-read.patch
linux-next.patch

