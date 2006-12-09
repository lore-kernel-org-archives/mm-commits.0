From: akpm@osdl.org
Subject: + md-assorted-md-and-raid1-one-liners.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:02:48 -0800
Message-ID: <200612090002.kB902mMe010078@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55030 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947567AbWLIACw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:02:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: assorted md and raid1 one-liners
has been added to the -mm tree.  Its filename is
     md-assorted-md-and-raid1-one-liners.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: assorted md and raid1 one-liners
From: NeilBrown <neilb@suse.de>

Fix few bugs that meant that:
  - superblocks weren't alway written at exactly the right time (this
    could show up if the array was not written to - writting to the array
    causes lots of superblock updates and so hides these errors).

  - restarting device recovery after a clean shutdown (version-1 metadata
    only) didn't work as intended (or at all).

1/ Ensure superblock is updated when a new device is added.
2/ Remove an inappropriate test on MD_RECOVERY_SYNC in md_do_sync.
   The body of this if takes one of two branches depending on whether
   MD_RECOVERY_SYNC is set, so testing it in the clause of the if
   is wrong.
3/ Flag superblock for updating after a resync/recovery finishes.
4/ If we find the neeed to restart a recovery in the middle (version-1
   metadata only) make sure a full recovery (not just as guided by
   bitmaps) does get done.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c    |    3 ++-
 drivers/md/raid1.c |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-assorted-md-and-raid1-one-liners drivers/md/md.c
--- a/drivers/md/md.c~md-assorted-md-and-raid1-one-liners
+++ a/drivers/md/md.c
@@ -3724,6 +3724,7 @@ static int add_new_disk(mddev_t * mddev,
 		if (err)
 			export_rdev(rdev);
 
+		md_update_sb(mddev, 1);
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
 		return err;
@@ -5275,7 +5276,6 @@ void md_do_sync(mddev_t *mddev)
 	mddev->pers->sync_request(mddev, max_sectors, &skipped, 1);
 
 	if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
-	    test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
 	    mddev->curr_resync > 2) {
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
@@ -5299,6 +5299,7 @@ void md_do_sync(mddev_t *mddev)
 					rdev->recovery_offset = mddev->curr_resync;
 		}
 	}
+	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 
  skip:
 	mddev->curr_resync = 0;
diff -puN drivers/md/raid1.c~md-assorted-md-and-raid1-one-liners drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-assorted-md-and-raid1-one-liners
+++ a/drivers/md/raid1.c
@@ -1951,6 +1951,7 @@ static int run(mddev_t *mddev)
 		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
 			mddev->degraded++;
+			conf->fullsync = 1;
 		}
 	}
 	if (mddev->degraded == conf->raid_disks) {
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-tidy-up-device-change-notification-when-an-md-array-is-stopped.patch
md-define-raid5_mergeable_bvec.patch
md-handle-bypassing-the-read-cache-assuming-nothing-fails.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-aligned-read-handling-including-raid6-read-corruption.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-error-handling-of-aligned-reads.patch
md-enable-bypassing-cache-for-reads.patch
md-fix-innocuous-bug-in-raid6-stripe_to_pdidx.patch
md-conditionalize-some-code.patch
md-remove-some-old-ifdefed-out-code-from-raid5c.patch
md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5.patch
md-assorted-md-and-raid1-one-liners.patch
md-change-lifetime-rules-for-md-devices.patch
md-close-a-race-between-destroying-and-recreating-an-md-device.patch
md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

