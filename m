From: akpm@linux-foundation.org
Subject: + md-improve-the-is_mddev_idle-test.patch added to -mm tree
Date: Thu, 10 May 2007 00:32:34 -0700
Message-ID: <200705100732.l4A7WY22015128@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756542AbXEJHcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 03:32:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: improve the is_mddev_idle test
has been added to the -mm tree.  Its filename is
     md-improve-the-is_mddev_idle-test.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: improve the is_mddev_idle test
From: NeilBrown <neilb@suse.de>

During a 'resync' or similar activity, md checks if the devices in the
array are otherwise active and winds back resync activity when they are. 
This test in done in is_mddev_idle, and it is somewhat fragile - it
sometimes thinks there is non-sync io when there isn't.

The test compares the total sectors of io (disk_stat_read) with the sectors
of resync io (disk->sync_io).  This has problems because total sectors gets
updated when a request completes, while resync io gets updated when the
request is submitted.  The time difference can cause large differenced
between the two which do not actually imply non-resync activity.  The test
currently allows for some fuzz (+/- 4096) but there are some cases when it
is not enough.

The test currently looks for any (non-fuzz) difference, either positive or
negative.  This clearly is not needed.  Any non-sync activity will cause
the total sectors to grow faster than the sync_io count (never slower) so
we only need to look for a positive differences.

If we do this then the amount of in-flight sync io will never cause the
appearance of non-sync IO.  Once enough non-sync IO to worry about starts
happening, resync will be slowed down and the measurements will thus be
more precise (as there is less in-flight) and control of resync will still
be suitably responsive.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-improve-the-is_mddev_idle-test drivers/md/md.c
--- a/drivers/md/md.c~md-improve-the-is_mddev_idle-test
+++ a/drivers/md/md.c
@@ -5105,7 +5105,7 @@ static int is_mddev_idle(mddev_t *mddev)
 		 *
 		 * Note: the following is an unsigned comparison.
 		 */
-		if ((curr_events - rdev->last_events + 4096) > 8192) {
+		if ((long)curr_events - (long)rdev->last_events > 4096) {
 			rdev->last_events = curr_events;
 			idle = 0;
 		}
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
revert-md-improve-partition-detection-in-md-array.patch
md-avoid-a-possibility-that-a-read-error-can-wrongly-propagate-through-md-raid1-to-a-filesystem.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
git-md-accel.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
introduce-freezer-flags-rev-2.patch
md-improve-the-is_mddev_idle-test.patch
use-menuconfig-objects-ii-md.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
