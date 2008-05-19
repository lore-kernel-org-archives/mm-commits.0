From: akpm@linux-foundation.org
Subject: + md-raid1-fix-restoration-of-bio-between-failed-read-and-write.patch added to -mm tree
Date: Sun, 18 May 2008 18:27:33 -0700
Message-ID: <200805190127.m4J1RX0E009558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903AbYESB1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 May 2008 21:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, David.Fairbanks@stratus.com


The patch titled
     md: raid1: Fix restoration of bio between failed read and write.
has been added to the -mm tree.  Its filename is
     md-raid1-fix-restoration-of-bio-between-failed-read-and-write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: raid1: Fix restoration of bio between failed read and write.
From: NeilBrown <neilb@suse.de>

When performing a "recovery" or "check" pass on a RAID1 array, we read
from each device and possible, if there is a difference or a read error,
write back to some devices.

We use the same 'bio' for both read and write, resetting various fields
between the two operations.

We forgot to reset bv_offset and bv_len however.  These are often left
unchanged, but in the case where there is an IO error one or two sectors
into a page, they are changed.

This results in correctable errors not being corrected properly.  It does
not result in any data corruption.

Cc: "Fairbanks, David" <David.Fairbanks@stratus.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid1.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/md/raid1.c~md-raid1-fix-restoration-of-bio-between-failed-read-and-write drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-raid1-fix-restoration-of-bio-between-failed-read-and-write
+++ a/drivers/md/raid1.c
@@ -1284,6 +1284,7 @@ static void sync_request_write(mddev_t *
 					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 				} else {
 					/* fixup the bio for reuse */
+					int size;
 					sbio->bi_vcnt = vcnt;
 					sbio->bi_size = r1_bio->sectors << 9;
 					sbio->bi_idx = 0;
@@ -1297,10 +1298,20 @@ static void sync_request_write(mddev_t *
 					sbio->bi_sector = r1_bio->sector +
 						conf->mirrors[i].rdev->data_offset;
 					sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-					for (j = 0; j < vcnt ; j++)
-						memcpy(page_address(sbio->bi_io_vec[j].bv_page),
+					size = sbio->bi_size;
+					for (j = 0; j < vcnt ; j++) {
+						struct bio_vec *bi;
+						bi = &sbio->bi_io_vec[j];
+						bi->bv_offset = 0;
+						if (size > PAGE_SIZE)
+							bi->bv_len = PAGE_SIZE;
+						else
+							bi->bv_len = size;
+						size -= PAGE_SIZE;
+						memcpy(page_address(bi->bv_page),
 						       page_address(pbio->bi_io_vec[j].bv_page),
 						       PAGE_SIZE);
+					}
 
 				}
 			}
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch
md-fix-possible-oops-when-removing-a-bitmap-from-an-active-array.patch
md-proper-extern-for-mdp_major.patch
md-kill-file_path-wrapper.patch
md-md-raid5-rate-limit-error-printk.patch
md-raid1-fix-restoration-of-bio-between-failed-read-and-write.patch
md-notify-userspace-on-write-pending-changes-to-array_state.patch
md-notify-userspace-on-stop-events.patch
md-improve-setting-of-events_cleared-for-write-intent-bitmaps.patch
md-allow-parallel-resync-of-md-devices.patch
md-restart-recovery-cleanly-after-device-failure.patch

