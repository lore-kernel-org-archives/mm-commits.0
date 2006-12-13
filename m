From: akpm@osdl.org
Subject: - md-handle-bypassing-the-read-cache-assuming-nothing-fails.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:44 -0800
Message-ID: <200612130655.kBD6tiBc030670@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57835 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965033AbWLMGzt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raziebe@gmail.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: handle bypassing the read cache (assuming nothing fails)
has been removed from the -mm tree.  Its filename was
     md-handle-bypassing-the-read-cache-assuming-nothing-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: handle bypassing the read cache (assuming nothing fails)
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid5.c |   78 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff -puN drivers/md/raid5.c~md-handle-bypassing-the-read-cache-assuming-nothing-fails drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-handle-bypassing-the-read-cache-assuming-nothing-fails
+++ a/drivers/md/raid5.c
@@ -2633,6 +2633,84 @@ static int raid5_mergeable_bvec(request_
 		return max;
 }
 
+
+static int in_chunk_boundary(mddev_t *mddev, struct bio *bio)
+{
+	sector_t sector = bio->bi_sector + get_start_sect(bio->bi_bdev);
+	unsigned int chunk_sectors = mddev->chunk_size >> 9;
+	unsigned int bio_sectors = bio->bi_size >> 9;
+
+	return  chunk_sectors >=
+		((sector & (chunk_sectors - 1)) + bio_sectors);
+}
+
+/*
+ *  The "raid5_align_endio" should check if the read succeeded and if it
+ *  did, call bio_endio on the original bio (having bio_put the new bio
+ *  first).
+ *  If the read failed..
+ */
+int raid5_align_endio(struct bio *bi, unsigned int bytes , int error)
+{
+	struct bio* raid_bi  = bi->bi_private;
+	if (bi->bi_size)
+		return 1;
+	bio_put(bi);
+	bio_endio(raid_bi, bytes, error);
+	return 0;
+}
+
+static int chunk_aligned_read(request_queue_t *q, struct bio * raid_bio)
+{
+	mddev_t *mddev = q->queuedata;
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	const unsigned int raid_disks = conf->raid_disks;
+	const unsigned int data_disks = raid_disks - 1;
+	unsigned int dd_idx, pd_idx;
+	struct bio* align_bi;
+	mdk_rdev_t *rdev;
+
+	if (!in_chunk_boundary(mddev, raid_bio)) {
+		printk("chunk_aligned_read : non aligned\n");
+		return 0;
+	}
+	/*
+ 	 * use bio_clone to make a copy of the bio
+	 */
+	align_bi = bio_clone(raid_bio, GFP_NOIO);
+	if (!align_bi)
+		return 0;
+	/*
+	 *   set bi_end_io to a new function, and set bi_private to the
+	 *     original bio.
+	 */
+	align_bi->bi_end_io  = raid5_align_endio;
+	align_bi->bi_private = raid_bio;
+	/*
+	 *	compute position
+	 */
+	align_bi->bi_sector =  raid5_compute_sector(raid_bio->bi_sector,
+					raid_disks,
+					data_disks,
+					&dd_idx,
+					&pd_idx,
+					conf);
+
+	rcu_read_lock();
+	rdev = rcu_dereference(conf->disks[dd_idx].rdev);
+	if (rdev && test_bit(In_sync, &rdev->flags)) {
+		align_bi->bi_bdev =  rdev->bdev;
+		atomic_inc(&rdev->nr_pending);
+		rcu_read_unlock();
+		generic_make_request(align_bi);
+		return 1;
+	} else {
+		rcu_read_unlock();
+		return 0;
+	}
+}
+
+
 static int make_request(request_queue_t *q, struct bio * bi)
 {
 	mddev_t *mddev = q->queuedata;
_

Patches currently in -mm which might be from raziebe@gmail.com are

origin.patch
md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly.patch

