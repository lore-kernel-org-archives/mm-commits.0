From: akpm@osdl.org
Subject: - md-define-raid5_mergeable_bvec.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:43 -0800
Message-ID: <200612130655.kBD6thSQ030667@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57880 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965035AbWLMG4F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raziebe@gmail.com, jens.axboe@oracle.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: define raid5_mergeable_bvec
has been removed from the -mm tree.  Its filename was
     md-define-raid5_mergeable_bvec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: define raid5_mergeable_bvec
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>

This will encourage read request to be on only one device, so we will often be
able to bypass the cache for read requests.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid5.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN drivers/md/raid5.c~md-define-raid5_mergeable_bvec drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-define-raid5_mergeable_bvec
+++ a/drivers/md/raid5.c
@@ -2611,6 +2611,28 @@ static int raid5_congested(void *data, i
 	return 0;
 }
 
+/* We want read requests to align with chunks where possible,
+ * but write requests don't need to.
+ */
+static int raid5_mergeable_bvec(request_queue_t *q, struct bio *bio, struct bio_vec *biovec)
+{
+	mddev_t *mddev = q->queuedata;
+	sector_t sector = bio->bi_sector + get_start_sect(bio->bi_bdev);
+	int max;
+	unsigned int chunk_sectors = mddev->chunk_size >> 9;
+	unsigned int bio_sectors = bio->bi_size >> 9;
+
+	if (bio_data_dir(bio))
+		return biovec->bv_len; /* always allow writes to be mergeable */
+
+	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
+	if (max < 0) max = 0;
+	if (max <= biovec->bv_len && bio_sectors == 0)
+		return biovec->bv_len;
+	else
+		return max;
+}
+
 static int make_request(request_queue_t *q, struct bio * bi)
 {
 	mddev_t *mddev = q->queuedata;
@@ -3320,6 +3342,8 @@ static int run(mddev_t *mddev)
 	mddev->array_size =  mddev->size * (conf->previous_raid_disks -
 					    conf->max_degraded);
 
+	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
+
 	return 0;
 abort:
 	if (conf) {
_

Patches currently in -mm which might be from raziebe@gmail.com are

origin.patch
md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly.patch

