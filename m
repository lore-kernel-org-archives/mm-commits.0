From: akpm@linux-foundation.org
Subject: - md-clear-the-congested_fn-when-stopping-a-raid5.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:41:44 -0700
Message-ID: <200703290741.l2T7fi3F030255@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46059 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbXC2Hls (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: clear the congested_fn when stopping a raid5
has been removed from the -mm tree.  Its filename was
     md-clear-the-congested_fn-when-stopping-a-raid5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: clear the congested_fn when stopping a raid5
From: NeilBrown <neilb@suse.de>

If this mddev and queue got reused for another array that doesn't register a
congested_fn, this function would get called incorretly.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c    |    1 +
 drivers/md/raid5.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-clear-the-congested_fn-when-stopping-a-raid5 drivers/md/md.c
--- a/drivers/md/md.c~md-clear-the-congested_fn-when-stopping-a-raid5
+++ a/drivers/md/md.c
@@ -3325,6 +3325,7 @@ static int do_md_stop(mddev_t * mddev, i
 			mddev->queue->merge_bvec_fn = NULL;
 			mddev->queue->unplug_fn = NULL;
 			mddev->queue->issue_flush_fn = NULL;
+			mddev->queue->backing_dev_info.congested_fn = NULL;
 			if (mddev->pers->sync_request)
 				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
 
diff -puN drivers/md/raid5.c~md-clear-the-congested_fn-when-stopping-a-raid5 drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-clear-the-congested_fn-when-stopping-a-raid5
+++ a/drivers/md/raid5.c
@@ -3646,8 +3646,8 @@ static int run(mddev_t *mddev)
 
 	mddev->queue->unplug_fn = raid5_unplug_device;
 	mddev->queue->issue_flush_fn = raid5_issue_flush;
-	mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
+	mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 
 	mddev->array_size =  mddev->size * (conf->previous_raid_disks -
 					    conf->max_degraded);
@@ -3678,6 +3678,7 @@ static int stop(mddev_t *mddev)
 	mddev->thread = NULL;
 	shrink_stripes(conf);
 	kfree(conf->stripe_hashtbl);
+	mddev->queue->backing_dev_info.congested_fn = NULL;
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	sysfs_remove_group(&mddev->kobj, &raid5_attrs_group);
 	kfree(conf->disks);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
net-sunrpc-svcsockc-fix-a-check.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
