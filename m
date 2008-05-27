From: akpm@linux-foundation.org
Subject: - md-raid1-fix-restoration-of-bio-between-failed-read-and-write.patch removed from -mm tree
Date: Tue, 27 May 2008 00:27:13 -0700
Message-ID: <200805270727.m4R7RDrY014749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755826AbYE0H1s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:27:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, David.Fairbanks@stratus.com, mm-commits@vger.kernel.org


The patch titled
     md: raid1: Fix restoration of bio between failed read and write.
has been removed from the -mm tree.  Its filename was
     md-raid1-fix-restoration-of-bio-between-failed-read-and-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

md-fix-prexor-vs-sync_request-race.patch
md-fix-uninitialized-use-of-mddev-recovery_wait.patch
md-do-not-compute-parity-unless-it-is-on-a-failed-drive.patch
linux-next.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch

