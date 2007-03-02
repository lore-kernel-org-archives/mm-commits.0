From: akpm@linux-foundation.org
Subject: - md-clean-out-unplug-and-other-queue-function-on-md-shutdown.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:04 -0800
Message-ID: <200703020506.l22564aK000762@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42225 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422657AbXCBFGI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: clean out unplug and other queue function on md shutdown
has been removed from the -mm tree.  Its filename was
     md-clean-out-unplug-and-other-queue-function-on-md-shutdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: clean out unplug and other queue function on md shutdown
From: NeilBrown <neilb@suse.de>

The mddev and queue might be used for another array which does not set these,
so they need to be cleared.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/md/md.c~md-clean-out-unplug-and-other-queue-function-on-md-shutdown drivers/md/md.c
--- a/drivers/md/md.c~md-clean-out-unplug-and-other-queue-function-on-md-shutdown
+++ a/drivers/md/md.c
@@ -3322,6 +3322,9 @@ static int do_md_stop(mddev_t * mddev, i
 				set_disk_ro(disk, 0);
 			blk_queue_make_request(mddev->queue, md_fail_request);
 			mddev->pers->stop(mddev);
+			mddev->queue->merge_bvec_fn = NULL;
+			mddev->queue->unplug_fn = NULL;
+			mddev->queue->issue_flush_fn = NULL;
 			if (mddev->pers->sync_request)
 				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
 
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
md-fix-for-raid6-reshape.patch
