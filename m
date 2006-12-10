From: akpm@osdl.org
Subject: - md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-error-handling-of-aligned-reads.patch removed from -mm tree
Date: Sun, 10 Dec 2006 00:28:10 -0800
Message-ID: <200612100828.kBA8SA8l018872@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33432 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760411AbWLJI2O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 03:28:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: misc fixes for error handling of aligned-reads
has been removed from the -mm tree.  Its filename was
     md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-error-handling-of-aligned-reads.patch

This patch was dropped because it was folded into md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch

------------------------------------------------------
Subject: md: misc fixes for error handling of aligned-reads
From: NeilBrown <neilb@suse.de>

1/ When aligned requests fail (read error) they need to be retried
   via the normal method (stripe cache).  As we cannot be sure that
   we can process a single read in one go (we may not be able to
   allocate all the stripes needed) we store a bio-being-retried
   and a list of bioes-that-still-need-to-be-retried.
   When find a bio that needs to be retried, we should add it to
   the list, not to single-bio...

2/ We were never incrementing 'scnt' when resubmitting failed
   aligned requests.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid5.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/md/raid5.c~md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-error-handling-of-aligned-reads drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-error-handling-of-aligned-reads
+++ a/drivers/md/raid5.c
@@ -2656,8 +2656,8 @@ static void add_bio_to_retry(struct bio 
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 
-	bi->bi_next = conf->retry_read_aligned;
-	conf->retry_read_aligned = bi;
+	bi->bi_next = conf->retry_read_aligned_list;
+	conf->retry_read_aligned_list = bi;
 
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 	md_wakeup_thread(conf->mddev->thread);
@@ -3154,7 +3154,8 @@ static int  retry_aligned_read(raid5_con
 					conf);
 	last_sector = raid_bio->bi_sector + (raid_bio->bi_size>>9);
 
-	for (; logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
+	for (; logical_sector < last_sector;
+	     logical_sector += STRIPE_SECTORS, scnt++) {
 
 		if (scnt < raid_bio->bi_hw_segments)
 			/* already done this stripe */
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
md-tidy-up-device-change-notification-when-an-md-array-is-stopped.patch
md-define-raid5_mergeable_bvec.patch
md-handle-bypassing-the-read-cache-assuming-nothing-fails.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-error-handling-of-aligned-reads.patch
md-enable-bypassing-cache-for-reads.patch
md-fix-innocuous-bug-in-raid6-stripe_to_pdidx.patch
md-conditionalize-some-code.patch
md-remove-some-old-ifdefed-out-code-from-raid5c.patch
md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5.patch
md-assorted-md-and-raid1-one-liners.patch

