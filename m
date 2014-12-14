From: akpm@linux-foundation.org
Subject: [merged] zram-change-parameter-from-vaild_io_request.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:08:39 -0800
Message-ID: <548d0d47.zPH0Su5wA7tDsbIY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaLNEIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: karam.lee@lge.com, jmarchan@redhat.com, matthew.r.wilcox@intel.com, minchan@kernel.org, ngupta@vflare.org, seungho1.park@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: change parameter from vaild_io_request()
has been removed from the -mm tree.  Its filename was
     zram-change-parameter-from-vaild_io_request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "karam.lee" <karam.lee@lge.com>
Subject: zram: change parameter from vaild_io_request()

This patch changes parameter of valid_io_request for common usage.  The
purpose of valid_io_request() is to determine if bio request is valid or
not.

This patch use I/O start address and size instead of a BIO parameter for
common usage.

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

diff -puN drivers/block/zram/zram_drv.c~zram-change-parameter-from-vaild_io_request drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-change-parameter-from-vaild_io_request
+++ a/drivers/block/zram/zram_drv.c
@@ -287,19 +287,18 @@ static inline int is_partial_io(struct b
 /*
  * Check if request is within bounds and aligned on zram logical blocks.
  */
-static inline int valid_io_request(struct zram *zram, struct bio *bio)
+static inline int valid_io_request(struct zram *zram,
+		sector_t start, unsigned int size)
 {
-	u64 start, end, bound;
+	u64 end, bound;
 
 	/* unaligned request */
-	if (unlikely(bio->bi_iter.bi_sector &
-		     (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
+	if (unlikely(start & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
 		return 0;
-	if (unlikely(bio->bi_iter.bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
+	if (unlikely(size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
 		return 0;
 
-	start = bio->bi_iter.bi_sector;
-	end = start + (bio->bi_iter.bi_size >> SECTOR_SHIFT);
+	end = start + (size >> SECTOR_SHIFT);
 	bound = zram->disksize >> SECTOR_SHIFT;
 	/* out of range range */
 	if (unlikely(start >= bound || end > bound || start > end))
@@ -915,7 +914,8 @@ static void zram_make_request(struct req
 	if (unlikely(!init_done(zram)))
 		goto error;
 
-	if (!valid_io_request(zram, bio)) {
+	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
+					bio->bi_iter.bi_size)) {
 		atomic64_inc(&zram->stats.invalid_io);
 		goto error;
 	}
_

Patches currently in -mm which might be from karam.lee@lge.com are

origin.patch

