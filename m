From: akpm@linux-foundation.org
Subject: + zram-do-not-pass-rw-argument-to-__zram_make_request.patch added to -mm tree
Date: Tue, 04 Feb 2014 14:19:11 -0800
Message-ID: <52f1675f.m7yXF0n/Kcs+ZaUG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934246AbaBDWTM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:19:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: + zram-do-not-pass-rw-argument-to-__zram_make_request.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:19:11 -0800


The patch titled
     Subject: zram: do not pass rw argument to __zram_make_request()
has been added to the -mm tree.  Its filename is
     zram-do-not-pass-rw-argument-to-__zram_make_request.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-do-not-pass-rw-argument-to-__zram_make_request.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-do-not-pass-rw-argument-to-__zram_make_request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: do not pass rw argument to __zram_make_request()

Do not pass rw argument down the __zram_make_request() -> zram_bvec_rw()
chain, decode it in zram_bvec_rw() instead.  Besides, this is the place
where we distinguish READ and WRITE bio data directions, so account zram
RW stats here, instead of __zram_make_request().  This also allows to
account a real number of zram READ/WRITE operations, not just requests
(single RW request may cause a number of zram RW ops with separate
locking, compression/decompression, etc).

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-do-not-pass-rw-argument-to-__zram_make_request drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-do-not-pass-rw-argument-to-__zram_make_request
+++ a/drivers/block/zram/zram_drv.c
@@ -533,14 +533,18 @@ out:
 }
 
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
-			int offset, struct bio *bio, int rw)
+			int offset, struct bio *bio)
 {
 	int ret;
+	int rw = bio_data_dir(bio);
 
-	if (rw == READ)
+	if (rw == READ) {
+		atomic64_inc(&zram->stats.num_reads);
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
-	else
+	} else {
+		atomic64_inc(&zram->stats.num_writes);
 		ret = zram_bvec_write(zram, bvec, index, offset);
+	}
 
 	return ret;
 }
@@ -670,22 +674,13 @@ out:
 	return ret;
 }
 
-static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
+static void __zram_make_request(struct zram *zram, struct bio *bio)
 {
 	int offset;
 	u32 index;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 
-	switch (rw) {
-	case READ:
-		atomic64_inc(&zram->stats.num_reads);
-		break;
-	case WRITE:
-		atomic64_inc(&zram->stats.num_writes);
-		break;
-	}
-
 	index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
 	offset = (bio->bi_iter.bi_sector &
 		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
@@ -704,16 +699,15 @@ static void __zram_make_request(struct z
 			bv.bv_len = max_transfer_size;
 			bv.bv_offset = bvec.bv_offset;
 
-			if (zram_bvec_rw(zram, &bv, index, offset, bio, rw) < 0)
+			if (zram_bvec_rw(zram, &bv, index, offset, bio) < 0)
 				goto out;
 
 			bv.bv_len = bvec.bv_len - max_transfer_size;
 			bv.bv_offset += max_transfer_size;
-			if (zram_bvec_rw(zram, &bv, index+1, 0, bio, rw) < 0)
+			if (zram_bvec_rw(zram, &bv, index + 1, 0, bio) < 0)
 				goto out;
 		} else
-			if (zram_bvec_rw(zram, &bvec, index, offset, bio, rw)
-			    < 0)
+			if (zram_bvec_rw(zram, &bvec, index, offset, bio) < 0)
 				goto out;
 
 		update_position(&index, &offset, &bvec);
@@ -743,7 +737,7 @@ static void zram_make_request(struct req
 		goto error;
 	}
 
-	__zram_make_request(zram, bio, bio_data_dir(bio));
+	__zram_make_request(zram, bio);
 	up_read(&zram->init_lock);
 
 	return;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch

