From: akpm@osdl.org
Subject: - md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:04:39 -0800
Message-ID: <200612140604.kBE64doZ001816@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51773 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbWLNGFI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:05:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, jens.axboe@oracle.com, raziebe@gmail.com, mm-commits@vger.kernel.org


The patch titled
     md: Don't assume that READ==0 and WRITE==1 - use the names explicitly
has been removed from the -mm tree.  Its filename was
     md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses.patch
knfsd-sunrpc-make-rq_daddr-field-address-version-independent.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch
knfsd-sunrpc-add-a-generic-function-to-see-if-the-peer-uses-a-secure-port.patch
knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch
knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length.patch
knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

