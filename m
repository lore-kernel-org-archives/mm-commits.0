From: akpm@linux-foundation.org
Subject: [merged] zram-remove-bio-parameter-from-zram_bvec_rw.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:08:36 -0800
Message-ID: <548d0d44.YeL18om6mjOOyRKN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaLNEI2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: karam.lee@lge.com, jmarchan@redhat.com, matthew.r.wilcox@intel.com, minchan@kernel.org, ngupta@vflare.org, seungho1.park@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove bio parameter from zram_bvec_rw()
has been removed from the -mm tree.  Its filename was
     zram-remove-bio-parameter-from-zram_bvec_rw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "karam.lee" <karam.lee@lge.com>
Subject: zram: remove bio parameter from zram_bvec_rw()

Recently rw_page block device operation has been added.  This patchset
implements rw_page operation for zram block device and does some clean-up.


This patch (of 3):

Remove an unnecessary parameter(bio) from zram_bvec_rw() and
zram_bvec_read().  zram_bvec_read() doesn't use a bio parameter, so remove
it.  zram_bvec_rw() calls a read/write operation not using bio, so a rw
parameter replaces a bio parameter.

Signed-off-by: karam.lee <karam.lee@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: <seungho1.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-bio-parameter-from-zram_bvec_rw drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-bio-parameter-from-zram_bvec_rw
+++ a/drivers/block/zram/zram_drv.c
@@ -453,7 +453,7 @@ static int zram_decompress_page(struct z
 }
 
 static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
-			  u32 index, int offset, struct bio *bio)
+			  u32 index, int offset)
 {
 	int ret;
 	struct page *page;
@@ -645,14 +645,13 @@ out:
 }
 
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
-			int offset, struct bio *bio)
+			int offset, int rw)
 {
 	int ret;
-	int rw = bio_data_dir(bio);
 
 	if (rw == READ) {
 		atomic64_inc(&zram->stats.num_reads);
-		ret = zram_bvec_read(zram, bvec, index, offset, bio);
+		ret = zram_bvec_read(zram, bvec, index, offset);
 	} else {
 		atomic64_inc(&zram->stats.num_writes);
 		ret = zram_bvec_write(zram, bvec, index, offset);
@@ -853,7 +852,7 @@ out:
 
 static void __zram_make_request(struct zram *zram, struct bio *bio)
 {
-	int offset;
+	int offset, rw;
 	u32 index;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
@@ -868,6 +867,7 @@ static void __zram_make_request(struct z
 		return;
 	}
 
+	rw = bio_data_dir(bio);
 	bio_for_each_segment(bvec, bio, iter) {
 		int max_transfer_size = PAGE_SIZE - offset;
 
@@ -882,15 +882,15 @@ static void __zram_make_request(struct z
 			bv.bv_len = max_transfer_size;
 			bv.bv_offset = bvec.bv_offset;
 
-			if (zram_bvec_rw(zram, &bv, index, offset, bio) < 0)
+			if (zram_bvec_rw(zram, &bv, index, offset, rw) < 0)
 				goto out;
 
 			bv.bv_len = bvec.bv_len - max_transfer_size;
 			bv.bv_offset += max_transfer_size;
-			if (zram_bvec_rw(zram, &bv, index + 1, 0, bio) < 0)
+			if (zram_bvec_rw(zram, &bv, index + 1, 0, rw) < 0)
 				goto out;
 		} else
-			if (zram_bvec_rw(zram, &bvec, index, offset, bio) < 0)
+			if (zram_bvec_rw(zram, &bvec, index, offset, rw) < 0)
 				goto out;
 
 		update_position(&index, &offset, &bvec);
_

Patches currently in -mm which might be from karam.lee@lge.com are

origin.patch

