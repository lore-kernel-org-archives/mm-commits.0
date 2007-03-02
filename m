From: akpm@linux-foundation.org
Subject: - md-fix-raid10-recovery-problem.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:05:58 -0800
Message-ID: <200703020505.l2255wUw000753@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42209 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964863AbXCBFGC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: fix raid10 recovery problem.
has been removed from the -mm tree.  Its filename was
     md-fix-raid10-recovery-problem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: fix raid10 recovery problem.
From: NeilBrown <neilb@suse.de>

There are two errors that can lead to recovery problems with raid10
when used in 'far' more (not the default).

Due to a '>' instead of '>=' the wrong block is located which would result in
garbage being written to some random location, quite possible outside the
range of the device, causing the newly reconstructed device to fail.

The device size calculation had some rounding errors (it didn't round when it
should) and so recovery would go a few blocks too far which would again cause
a write to a random block address and probably a device error.

The code for working with device sizes was fairly confused and spread out, so
this has been tided up a bit.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid10.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff -puN drivers/md/raid10.c~md-fix-raid10-recovery-problem drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-fix-raid10-recovery-problem
+++ a/drivers/md/raid10.c
@@ -429,7 +429,7 @@ static sector_t raid10_find_virt(conf_t 
 		if (dev < 0)
 			dev += conf->raid_disks;
 	} else {
-		while (sector > conf->stride) {
+		while (sector >= conf->stride) {
 			sector -= conf->stride;
 			if (dev < conf->near_copies)
 				dev += conf->raid_disks - conf->near_copies;
@@ -1801,6 +1801,7 @@ static sector_t sync_request(mddev_t *md
 						for (k=0; k<conf->copies; k++)
 							if (r10_bio->devs[k].devnum == i)
 								break;
+						BUG_ON(k == conf->copies);
 						bio = r10_bio->devs[1].bio;
 						bio->bi_next = biolist;
 						biolist = bio;
@@ -2021,19 +2022,30 @@ static int run(mddev_t *mddev)
 	if (!conf->tmppage)
 		goto out_free_conf;
 
+	conf->mddev = mddev;
+	conf->raid_disks = mddev->raid_disks;
 	conf->near_copies = nc;
 	conf->far_copies = fc;
 	conf->copies = nc*fc;
 	conf->far_offset = fo;
 	conf->chunk_mask = (sector_t)(mddev->chunk_size>>9)-1;
 	conf->chunk_shift = ffz(~mddev->chunk_size) - 9;
+	size = mddev->size >> (conf->chunk_shift-1);
+	sector_div(size, fc);
+	size = size * conf->raid_disks;
+	sector_div(size, nc);
+	/* 'size' is now the number of chunks in the array */
+	/* calculate "used chunks per device" in 'stride' */
+	stride = size * conf->copies;
+	sector_div(stride, conf->raid_disks);
+	mddev->size = stride  << (conf->chunk_shift-1);
+
 	if (fo)
-		conf->stride = 1 << conf->chunk_shift;
-	else {
-		stride = mddev->size >> (conf->chunk_shift-1);
+		stride = 1;
+	else
 		sector_div(stride, fc);
-		conf->stride = stride << conf->chunk_shift;
-	}
+	conf->stride = stride << conf->chunk_shift;
+
 	conf->r10bio_pool = mempool_create(NR_RAID10_BIOS, r10bio_pool_alloc,
 						r10bio_pool_free, conf);
 	if (!conf->r10bio_pool) {
@@ -2063,8 +2075,6 @@ static int run(mddev_t *mddev)
 
 		disk->head_position = 0;
 	}
-	conf->raid_disks = mddev->raid_disks;
-	conf->mddev = mddev;
 	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 
@@ -2106,16 +2116,8 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	if (conf->far_offset) {
-		size = mddev->size >> (conf->chunk_shift-1);
-		size *= conf->raid_disks;
-		size <<= conf->chunk_shift;
-		sector_div(size, conf->far_copies);
-	} else
-		size = conf->stride * conf->raid_disks;
-	sector_div(size, conf->near_copies);
-	mddev->array_size = size/2;
-	mddev->resync_max_sectors = size;
+	mddev->array_size = size << (conf->chunk_shift-1);
+	mddev->resync_max_sectors = size << conf->chunk_shift;
 
 	mddev->queue->unplug_fn = raid10_unplug;
 	mddev->queue->issue_flush_fn = raid10_issue_flush;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying.patch
knfsd-avoid-checksum-checks-when-collecting-metadata-for-a-udp-packet.patch
knfsd-remove-config_ipv6-ifdefs-from-sunrpc-server-code.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous-tidy.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
