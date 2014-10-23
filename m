From: akpm@linux-foundation.org
Subject: + zram-change-parameter-from-vaild_io_request.patch added to -mm
 tree
Date: Thu, 23 Oct 2014 12:53:49 -0700
Message-ID: <54495ccd.wf2HbBdM+vp+ylRT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaJWTxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 15:53:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: karam.lee@lge.com, jmarchan@redhat.com, matthew.r.wilcox@intel.com, minchan@kernel.org, ngupta@vflare.org, seungho1.park@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: change parameter from vaild_io_request()
has been added to the -mm tree.  Its filename is
     zram-change-parameter-from-vaild_io_request.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-change-parameter-from-vaild_io_request.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-change-parameter-from-vaild_io_request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -285,19 +285,18 @@ static inline int is_partial_io(struct b
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
@@ -912,7 +911,8 @@ static void zram_make_request(struct req
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

zram-remove-bio-parameter-from-zram_bvec_rw.patch
zram-change-parameter-from-vaild_io_request.patch
zram-implement-rw_page-operation-of-zram.patch

