From: akpm@osdl.org
Subject: + md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:02:46 -0800
Message-ID: <200612090002.kB902kCX010073@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55025 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947556AbWLIACv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:02:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: return a non-zero error to bi_end_io as appropriate in raid5
has been added to the -mm tree.  Its filename is
     md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: return a non-zero error to bi_end_io as appropriate in raid5
From: NeilBrown <neilb@suse.de>

Currently raid5 depends on clearing the BIO_UPTODATE flag to signal an error
to higher levels.  While this should be sufficient, it is safer to explicitly
set the error code as well - less room for confusion.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid5.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/md/raid5.c~md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5 drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5
+++ a/drivers/md/raid5.c
@@ -1818,7 +1818,9 @@ static void handle_stripe5(struct stripe
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes, 0);
+		bi->bi_end_io(bi, bytes,
+			      test_bit(BIO_UPTODATE, &bi->bi_flags)
+			        ? 0 : -EIO);
 	}
 	for (i=disks; i-- ;) {
 		int rw;
@@ -2359,7 +2361,9 @@ static void handle_stripe6(struct stripe
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes, 0);
+		bi->bi_end_io(bi, bytes,
+			      test_bit(BIO_UPTODATE, &bi->bi_flags)
+			        ? 0 : -EIO);
 	}
 	for (i=disks; i-- ;) {
 		int rw;
@@ -2859,7 +2863,9 @@ static int make_request(request_queue_t 
 		if ( rw == WRITE )
 			md_write_end(mddev);
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes, 0);
+		bi->bi_end_io(bi, bytes,
+			      test_bit(BIO_UPTODATE, &bi->bi_flags)
+			        ? 0 : -EIO);
 	}
 	return 0;
 }
@@ -3127,7 +3133,9 @@ static int  retry_aligned_read(raid5_con
 		int bytes = raid_bio->bi_size;
 
 		raid_bio->bi_size = 0;
-		raid_bio->bi_end_io(raid_bio, bytes, 0);
+		raid_bio->bi_end_io(raid_bio, bytes,
+			      test_bit(BIO_UPTODATE, &raid_bio->bi_flags)
+			        ? 0 : -EIO);
 	}
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
 		wake_up(&conf->wait_for_stripe);
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

