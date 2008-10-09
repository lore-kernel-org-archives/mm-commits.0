From: akpm@linux-foundation.org
Subject: - block-mark-bio_split_pool-static.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:28:30 -0700
Message-ID: <200810092228.m99MSULf006085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbYJIW3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:29:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, jens.axboe@oracle.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     block: mark bio_split_pool static
has been removed from the -mm tree.  Its filename was
     block-mark-bio_split_pool-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: mark bio_split_pool static
From: Denis ChengRq <crquan@gmail.com>

Since all bio_split calls refer the same single bio_split_pool, the
bio_split function can use bio_split_pool directly instead of the
mempool_t parameter;

Then the mempool_t parameter can be removed from bio_split param list, and
bio_split_pool is only referred in fs/bio.c file, can be marked static.

Signed-off-by: Denis ChengRq <crquan@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |    2 +-
 drivers/md/linear.c     |    2 +-
 drivers/md/raid0.c      |    2 +-
 drivers/md/raid10.c     |    2 +-
 fs/bio.c                |    9 ++++-----
 include/linux/bio.h     |    4 +---
 6 files changed, 9 insertions(+), 12 deletions(-)

diff -puN drivers/block/pktcdvd.c~block-mark-bio_split_pool-static drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~block-mark-bio_split_pool-static
+++ a/drivers/block/pktcdvd.c
@@ -2543,7 +2543,7 @@ static int pkt_make_request(struct reque
 		if (last_zone != zone) {
 			BUG_ON(last_zone != zone + pd->settings.size);
 			first_sectors = last_zone - bio->bi_sector;
-			bp = bio_split(bio, bio_split_pool, first_sectors);
+			bp = bio_split(bio, first_sectors);
 			BUG_ON(!bp);
 			pkt_make_request(q, &bp->bio1);
 			pkt_make_request(q, &bp->bio2);
diff -puN drivers/md/linear.c~block-mark-bio_split_pool-static drivers/md/linear.c
--- a/drivers/md/linear.c~block-mark-bio_split_pool-static
+++ a/drivers/md/linear.c
@@ -343,7 +343,7 @@ static int linear_make_request (struct r
 		 * split it.
 		 */
 		struct bio_pair *bp;
-		bp = bio_split(bio, bio_split_pool,
+		bp = bio_split(bio,
 			       tmp_dev->start_sector + tmp_dev->num_sectors
 			       - bio->bi_sector);
 		if (linear_make_request(q, &bp->bio1))
diff -puN drivers/md/raid0.c~block-mark-bio_split_pool-static drivers/md/raid0.c
--- a/drivers/md/raid0.c~block-mark-bio_split_pool-static
+++ a/drivers/md/raid0.c
@@ -422,7 +422,7 @@ static int raid0_make_request (struct re
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
 		 */
-		bp = bio_split(bio, bio_split_pool, chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
+		bp = bio_split(bio, chunk_sects - (bio->bi_sector & (chunk_sects - 1)));
 		if (raid0_make_request(q, &bp->bio1))
 			generic_make_request(&bp->bio1);
 		if (raid0_make_request(q, &bp->bio2))
diff -puN drivers/md/raid10.c~block-mark-bio_split_pool-static drivers/md/raid10.c
--- a/drivers/md/raid10.c~block-mark-bio_split_pool-static
+++ a/drivers/md/raid10.c
@@ -817,7 +817,7 @@ static int make_request(struct request_q
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
 		 */
-		bp = bio_split(bio, bio_split_pool,
+		bp = bio_split(bio,
 			       chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
 		if (make_request(q, &bp->bio1))
 			generic_make_request(&bp->bio1);
diff -puN fs/bio.c~block-mark-bio_split_pool-static fs/bio.c
--- a/fs/bio.c~block-mark-bio_split_pool-static
+++ a/fs/bio.c
@@ -30,7 +30,7 @@
 
 static struct kmem_cache *bio_slab __read_mostly;
 
-mempool_t *bio_split_pool __read_mostly;
+static mempool_t *bio_split_pool __read_mostly;
 
 /*
  * if you change this list, also change bvec_alloc or things will
@@ -1256,9 +1256,9 @@ static void bio_pair_end_2(struct bio *b
  * split a bio - only worry about a bio with a single page
  * in it's iovec
  */
-struct bio_pair *bio_split(struct bio *bi, mempool_t *pool, int first_sectors)
+struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 {
-	struct bio_pair *bp = mempool_alloc(pool, GFP_NOIO);
+	struct bio_pair *bp = mempool_alloc(bio_split_pool, GFP_NOIO);
 
 	if (!bp)
 		return bp;
@@ -1292,7 +1292,7 @@ struct bio_pair *bio_split(struct bio *b
 	bp->bio2.bi_end_io = bio_pair_end_2;
 
 	bp->bio1.bi_private = bi;
-	bp->bio2.bi_private = pool;
+	bp->bio2.bi_private = bio_split_pool;
 
 	if (bio_integrity(bi))
 		bio_integrity_split(bi, bp, first_sectors);
@@ -1455,7 +1455,6 @@ EXPORT_SYMBOL(bio_map_kern);
 EXPORT_SYMBOL(bio_copy_kern);
 EXPORT_SYMBOL(bio_pair_release);
 EXPORT_SYMBOL(bio_split);
-EXPORT_SYMBOL(bio_split_pool);
 EXPORT_SYMBOL(bio_copy_user);
 EXPORT_SYMBOL(bio_uncopy_user);
 EXPORT_SYMBOL(bioset_create);
diff -puN include/linux/bio.h~block-mark-bio_split_pool-static include/linux/bio.h
--- a/include/linux/bio.h~block-mark-bio_split_pool-static
+++ a/include/linux/bio.h
@@ -300,9 +300,7 @@ struct bio_pair {
 	atomic_t			cnt;
 	int				error;
 };
-extern struct bio_pair *bio_split(struct bio *bi, mempool_t *pool,
-				  int first_sectors);
-extern mempool_t *bio_split_pool;
+extern struct bio_pair *bio_split(struct bio *bi, int first_sectors);
 extern void bio_pair_release(struct bio_pair *dbio);
 
 extern struct bio_set *bioset_create(int, int);
_

Patches currently in -mm which might be from crquan@gmail.com are

git-net.patch
git-block.patch
fs-block_devc-__read_mostly-improvement-and-sb_is_blkdev_sb-utilization.patch

