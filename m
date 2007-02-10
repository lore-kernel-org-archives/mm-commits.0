From: akpm@linux-foundation.org
Subject: - md-fix-various-bugs-with-aligned-reads-in-raid5.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:21:38 -0800
Message-ID: <200702100521.l1A5LcWo004477@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36561 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbXBJFV7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:21:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, epimetreus@fastmail.fm, jens.axboe@oracle.com, org@suse.de, stable@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: fix various bugs with aligned reads in RAID5
has been removed from the -mm tree.  Its filename was
     md-fix-various-bugs-with-aligned-reads-in-raid5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: fix various bugs with aligned reads in RAID5
From: Neil Brown <neilb@suse.de>

It is possible for raid5 to be sent a bio that is too big for an underlying
device.  So if it is a READ that we pass stright down to a device, it will
fail and confuse RAID5.

So in 'chunk_aligned_read' we check that the bio fits within the parameters
for the target device and if it doesn't fit, fall back on reading through
the stripe cache and making lots of one-page requests.

Note that this is the earliest time we can check against the device because
earlier we don't have a lock on the device, so it could change underneath
us.

Also, the code for handling a retry through the cache when a read fails has
not been tested and was badly broken.  This patch fixes that code.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: "Kai" <epimetreus@fastmail.fm>
Cc: <stable@suse.de>
Cc: <org@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c  |    2 +-
 drivers/md/raid5.c |   42 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 40 insertions(+), 4 deletions(-)

diff -puN block/ll_rw_blk.c~md-fix-various-bugs-with-aligned-reads-in-raid5 block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~md-fix-various-bugs-with-aligned-reads-in-raid5
+++ a/block/ll_rw_blk.c
@@ -1264,7 +1264,7 @@ new_hw_segment:
 	bio->bi_hw_segments = nr_hw_segs;
 	bio->bi_flags |= (1 << BIO_SEG_VALID);
 }
-
+EXPORT_SYMBOL(blk_recount_segments);
 
 static int blk_phys_contig_segment(request_queue_t *q, struct bio *bio,
 				   struct bio *nxt)
diff -puN drivers/md/raid5.c~md-fix-various-bugs-with-aligned-reads-in-raid5 drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-fix-various-bugs-with-aligned-reads-in-raid5
+++ a/drivers/md/raid5.c
@@ -2620,7 +2620,7 @@ static struct bio *remove_bio_from_retry
 	}
 	bi = conf->retry_read_aligned_list;
 	if(bi) {
-		conf->retry_read_aligned = bi->bi_next;
+		conf->retry_read_aligned_list = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_phys_segments = 1; /* biased count of active stripes */
 		bi->bi_hw_segments = 0; /* count of processed stripes */
@@ -2669,6 +2669,27 @@ static int raid5_align_endio(struct bio 
 	return 0;
 }
 
+static int bio_fits_rdev(struct bio *bi)
+{
+	request_queue_t *q = bdev_get_queue(bi->bi_bdev);
+
+	if ((bi->bi_size>>9) > q->max_sectors)
+		return 0;
+	blk_recount_segments(q, bi);
+	if (bi->bi_phys_segments > q->max_phys_segments ||
+	    bi->bi_hw_segments > q->max_hw_segments)
+		return 0;
+
+	if (q->merge_bvec_fn)
+		/* it's too hard to apply the merge_bvec_fn at this stage,
+		 * just just give up
+		 */
+		return 0;
+
+	return 1;
+}
+
+
 static int chunk_aligned_read(request_queue_t *q, struct bio * raid_bio)
 {
 	mddev_t *mddev = q->queuedata;
@@ -2715,6 +2736,13 @@ static int chunk_aligned_read(request_qu
 		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
 		align_bi->bi_sector += rdev->data_offset;
 
+		if (!bio_fits_rdev(align_bi)) {
+			/* too big in some way */
+			bio_put(align_bi);
+			rdev_dec_pending(rdev, mddev);
+			return 0;
+		}
+
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    conf->quiesce == 0,
@@ -3107,7 +3135,9 @@ static int  retry_aligned_read(raid5_con
 	last_sector = raid_bio->bi_sector + (raid_bio->bi_size>>9);
 
 	for (; logical_sector < last_sector;
-	     logical_sector += STRIPE_SECTORS, scnt++) {
+	     logical_sector += STRIPE_SECTORS,
+		     sector += STRIPE_SECTORS,
+		     scnt++) {
 
 		if (scnt < raid_bio->bi_hw_segments)
 			/* already done this stripe */
@@ -3123,7 +3153,13 @@ static int  retry_aligned_read(raid5_con
 		}
 
 		set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
-		add_stripe_bio(sh, raid_bio, dd_idx, 0);
+		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
+			release_stripe(sh);
+			raid_bio->bi_hw_segments = scnt;
+			conf->retry_read_aligned = raid_bio;
+			return handled;
+		}
+
 		handle_stripe(sh, NULL);
 		release_stripe(sh);
 		handled++;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
igrab-should-check-for-i_clear.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
replace-highest_possible_node_id-with-nr_node_ids-fix.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
fix-d_path-for-lazy-unmounts.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-aplit-svc_sock_enqueue-out-of-svc_setup_socket.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses.patch
knfsd-sunrpc-make-rq_daddr-field-address-version-independent.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-add-a-generic-function-to-see-if-the-peer-uses-a-secure-port.patch
knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
