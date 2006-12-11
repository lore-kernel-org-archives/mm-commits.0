From: akpm@osdl.org
Subject: + md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly.patch added to -mm tree
Date: Mon, 11 Dec 2006 15:35:46 -0800
Message-ID: <200612112335.kBBNZkUi012701@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49662 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbWLKXgE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 18:36:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, jens.axboe@oracle.com, raziebe@gmail.com


The patch titled
     md: Don't assume that READ==0 and WRITE==1 - use the names explicitly
has been added to the -mm tree.  Its filename is
     md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: Don't assume that READ==0 and WRITE==1 - use the names explicitly
From: NeilBrown <neilb@suse.de>

Thanks Jens for alerting me to this.

Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <raziebe@gmail.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/faulty.c |    2 +-
 drivers/md/raid1.c  |    2 +-
 drivers/md/raid10.c |    6 +++---
 drivers/md/raid5.c  |   20 ++++++++++----------
 4 files changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/md/faulty.c~md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly drivers/md/faulty.c
--- a/drivers/md/faulty.c~md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly
+++ a/drivers/md/faulty.c
@@ -173,7 +173,7 @@ static int make_request(request_queue_t 
 	conf_t *conf = (conf_t*)mddev->private;
 	int failit = 0;
 
-	if (bio->bi_rw & 1) {
+	if (bio_data_dir(bio) == WRITE) {
 		/* write request */
 		if (atomic_read(&conf->counters[WriteAll])) {
 			/* special case - don't decrement, don't generic_make_request,
diff -puN drivers/md/raid1.c~md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly
+++ a/drivers/md/raid1.c
@@ -1736,7 +1736,7 @@ static sector_t sync_request(mddev_t *md
 		/* take from bio_init */
 		bio->bi_next = NULL;
 		bio->bi_flags |= 1 << BIO_UPTODATE;
-		bio->bi_rw = 0;
+		bio->bi_rw = READ;
 		bio->bi_vcnt = 0;
 		bio->bi_idx = 0;
 		bio->bi_phys_segments = 0;
diff -puN drivers/md/raid10.c~md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly
+++ a/drivers/md/raid10.c
@@ -1785,7 +1785,7 @@ static sector_t sync_request(mddev_t *md
 						biolist = bio;
 						bio->bi_private = r10_bio;
 						bio->bi_end_io = end_sync_read;
-						bio->bi_rw = 0;
+						bio->bi_rw = READ;
 						bio->bi_sector = r10_bio->devs[j].addr +
 							conf->mirrors[d].rdev->data_offset;
 						bio->bi_bdev = conf->mirrors[d].rdev->bdev;
@@ -1801,7 +1801,7 @@ static sector_t sync_request(mddev_t *md
 						biolist = bio;
 						bio->bi_private = r10_bio;
 						bio->bi_end_io = end_sync_write;
-						bio->bi_rw = 1;
+						bio->bi_rw = WRITE;
 						bio->bi_sector = r10_bio->devs[k].addr +
 							conf->mirrors[i].rdev->data_offset;
 						bio->bi_bdev = conf->mirrors[i].rdev->bdev;
@@ -1870,7 +1870,7 @@ static sector_t sync_request(mddev_t *md
 			biolist = bio;
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_read;
-			bio->bi_rw = 0;
+			bio->bi_rw = READ;
 			bio->bi_sector = r10_bio->devs[i].addr +
 				conf->mirrors[d].rdev->data_offset;
 			bio->bi_bdev = conf->mirrors[d].rdev->bdev;
diff -puN drivers/md/raid5.c~md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly
+++ a/drivers/md/raid5.c
@@ -1827,16 +1827,16 @@ static void handle_stripe5(struct stripe
 		struct bio *bi;
 		mdk_rdev_t *rdev;
 		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags))
-			rw = 1;
+			rw = WRITE;
 		else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
-			rw = 0;
+			rw = READ;
 		else
 			continue;
  
 		bi = &sh->dev[i].req;
  
 		bi->bi_rw = rw;
-		if (rw)
+		if (rw == WRITE)
 			bi->bi_end_io = raid5_end_write_request;
 		else
 			bi->bi_end_io = raid5_end_read_request;
@@ -1872,7 +1872,7 @@ static void handle_stripe5(struct stripe
 				atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
 			generic_make_request(bi);
 		} else {
-			if (rw == 1)
+			if (rw == WRITE)
 				set_bit(STRIPE_DEGRADED, &sh->state);
 			PRINTK("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
@@ -2370,16 +2370,16 @@ static void handle_stripe6(struct stripe
 		struct bio *bi;
 		mdk_rdev_t *rdev;
 		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags))
-			rw = 1;
+			rw = WRITE;
 		else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
-			rw = 0;
+			rw = READ;
 		else
 			continue;
 
 		bi = &sh->dev[i].req;
 
 		bi->bi_rw = rw;
-		if (rw)
+		if (rw == WRITE)
 			bi->bi_end_io = raid5_end_write_request;
 		else
 			bi->bi_end_io = raid5_end_read_request;
@@ -2415,7 +2415,7 @@ static void handle_stripe6(struct stripe
 				atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
 			generic_make_request(bi);
 		} else {
-			if (rw == 1)
+			if (rw == WRITE)
 				set_bit(STRIPE_DEGRADED, &sh->state);
 			PRINTK("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
@@ -2567,7 +2567,7 @@ static int raid5_mergeable_bvec(request_
 	unsigned int chunk_sectors = mddev->chunk_size >> 9;
 	unsigned int bio_sectors = bio->bi_size >> 9;
 
-	if (bio_data_dir(bio))
+	if (bio_data_dir(bio) == WRITE)
 		return biovec->bv_len; /* always allow writes to be mergeable */
 
 	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
@@ -2751,7 +2751,7 @@ static int make_request(request_queue_t 
 	disk_stat_inc(mddev->gendisk, ios[rw]);
 	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bi));
 
-	if (bio_data_dir(bi) == READ &&
+	if (rw == READ &&
 	     mddev->reshape_position == MaxSector &&
 	     chunk_aligned_read(q,bi))
             	return 0;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly.patch
fix-numerous-kcalloc-calls-convert-to-kzalloc.patch
knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch
knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch
knfsd-nfsd4-clarify-units-of-compound_slack_space.patch
knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch
knfsd-nfsd-simplify-exp_pseudoroot.patch
knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch
knfsd-nfsd-dont-drop-silently-on-upcall-deferral.patch
knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch
knfsd-nfsd4-pass-saved-and-current-fh-together-into-nfsd4-operations.patch
knfsd-nfsd4-remove-spurious-replay_owner-check.patch
knfsd-nfsd4-move-replay_owner-to-cstate.patch
knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch
knfsd-nfsd4-make-verify-and-nverify-wrappers.patch
knfsd-nfsd4-reorganize-compound-ops.patch
knfsd-nfsd4-simplify-migration-op-check.patch
knfsd-nfsd4-simplify-filehandle-check.patch
knfsd-dont-ignore-kstrdup-failure-in-rpc-caches.patch
knfsd-fix-up-some-bit-rot-in-exp_export.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-change-lifetime-rules-for-md-devices.patch
md-close-a-race-between-destroying-and-recreating-an-md-device.patch
md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

