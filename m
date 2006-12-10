From: akpm@osdl.org
Subject: - md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-aligned-read-handling-including-raid6-read-corruption.patch removed from -mm tree
Date: Sun, 10 Dec 2006 00:28:00 -0800
Message-ID: <200612100828.kBA8S0in018865@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33425 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760423AbWLJI2E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 03:28:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: misc fixes for aligned-read handling including raid6 read corruption
has been removed from the -mm tree.  Its filename was
     md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-aligned-read-handling-including-raid6-read-corruption.patch

This patch was dropped because it was folded into md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch

------------------------------------------------------
Subject: md: misc fixes for aligned-read handling including raid6 read corruption
From: NeilBrown <neilb@suse.de>

1/
  chunk_aligned_read and retry_aligned_read assume that
      data_disks == raid_disks - 1
  which is not true for raid6.
  So when an aligned read request bypasses the cache, we can get the wrong data.

2/ The cloned bio is being used-after-free in raid5_align_endio
   (to test BIO_UPTODATE).

3/ We forgot to add rdev->data_offset when submitting
   a bio for aligned-read

4/ clone_bio calls blk_recount_segments and then we change bi_bdev,
   so we need to invalidate the segment counts.

5/ We don't de-reference the rdev when the read completes.
   This means we need to record the rdev to so it is still
   available in the end_io routine.  Fortunately
   bi_next in the original bio is unused at this point so
   we can stuff it in there.

6/ We leak a cloned bio if the target rdev is not usable.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid5.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN drivers/md/raid5.c~md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-aligned-read-handling-including-raid6-read-corruption drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-aligned-read-handling-including-raid6-read-corruption
+++ a/drivers/md/raid5.c
@@ -2696,6 +2696,8 @@ static int raid5_align_endio(struct bio 
 	struct bio* raid_bi  = bi->bi_private;
 	mddev_t *mddev;
 	raid5_conf_t *conf;
+	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
+	mdk_rdev_t *rdev;
 
 	if (bi->bi_size)
 		return 1;
@@ -2703,8 +2705,12 @@ static int raid5_align_endio(struct bio 
 
 	mddev = raid_bi->bi_bdev->bd_disk->queue->queuedata;
 	conf = mddev_to_conf(mddev);
+	rdev = (void*)raid_bi->bi_next;
+	raid_bi->bi_next = NULL;
+
+	rdev_dec_pending(rdev, conf->mddev);
 
-	if (!error && test_bit(BIO_UPTODATE, &bi->bi_flags)) {
+	if (!error && uptodate) {
 		bio_endio(raid_bi, bytes, 0);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
 			wake_up(&conf->wait_for_stripe);
@@ -2723,7 +2729,7 @@ static int chunk_aligned_read(request_qu
 	mddev_t *mddev = q->queuedata;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	const unsigned int raid_disks = conf->raid_disks;
-	const unsigned int data_disks = raid_disks - 1;
+	const unsigned int data_disks = raid_disks - conf->max_degraded;
 	unsigned int dd_idx, pd_idx;
 	struct bio* align_bi;
 	mdk_rdev_t *rdev;
@@ -2757,9 +2763,12 @@ static int chunk_aligned_read(request_qu
 	rcu_read_lock();
 	rdev = rcu_dereference(conf->disks[dd_idx].rdev);
 	if (rdev && test_bit(In_sync, &rdev->flags)) {
-		align_bi->bi_bdev =  rdev->bdev;
 		atomic_inc(&rdev->nr_pending);
 		rcu_read_unlock();
+		raid_bio->bi_next = (void*)rdev;
+		align_bi->bi_bdev =  rdev->bdev;
+		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
+		align_bi->bi_sector += rdev->data_offset;
 
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
@@ -2772,6 +2781,7 @@ static int chunk_aligned_read(request_qu
 		return 1;
 	} else {
 		rcu_read_unlock();
+		bio_put(align_bi);
 		return 0;
 	}
 }
@@ -3138,7 +3148,7 @@ static int  retry_aligned_read(raid5_con
 	logical_sector = raid_bio->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	sector = raid5_compute_sector(	logical_sector,
 					conf->raid_disks,
-					conf->raid_disks-1,
+					conf->raid_disks - conf->max_degraded,
 					&dd_idx,
 					&pd_idx,
 					conf);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
md-tidy-up-device-change-notification-when-an-md-array-is-stopped.patch
md-define-raid5_mergeable_bvec.patch
md-handle-bypassing-the-read-cache-assuming-nothing-fails.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-aligned-read-handling-including-raid6-read-corruption.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-error-handling-of-aligned-reads.patch
md-enable-bypassing-cache-for-reads.patch
md-fix-innocuous-bug-in-raid6-stripe_to_pdidx.patch
md-conditionalize-some-code.patch
md-remove-some-old-ifdefed-out-code-from-raid5c.patch
md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5.patch
md-assorted-md-and-raid1-one-liners.patch

