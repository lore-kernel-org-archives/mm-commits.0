From: akpm@linux-foundation.org
Subject: + md-clean-out-unplug-and-other-queue-function-on-md-shutdown.patch added to -mm tree
Date: Wed, 21 Feb 2007 14:48:26 -0800
Message-ID: <200702212248.l1LMmQmR028958@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53724 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423250AbXBUWsa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:48:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     From: NeilBrown <neilb@suse.de>
has been added to the -mm tree.  Its filename is
     md-clean-out-unplug-and-other-queue-function-on-md-shutdown.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: NeilBrown <neilb@suse.de>


The mddev and queue might be used for another array which does not
set these, so they need to be cleared.

Signed-off-by: NeilBrown <neilb@suse.de>

### Diffstat output
 1 file changed, 3 insertions(+)

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    3 +++
 1 files changed, 3 insertions(+)

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

fix-failure-paths-in-modules-init-in-umemc.patch
md-fix-raid10-recovery-problem.patch
md-raid6-clean-up-cpuid-and-fpu-enter-exit-code.patch
md-move-warning-about-creating-a-raid-array-on-partitions-of-the-one-device.patch
md-clean-out-unplug-and-other-queue-function-on-md-shutdown.patch
md-restart-a-raid5-reshape-that-has-been-aborted-due-to-a-read-write-error.patch
md-add-support-for-reshape-of-a-raid6.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous-tidy.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
