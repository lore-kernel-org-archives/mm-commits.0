From: akpm@linux-foundation.org
Subject: - md-raid10-fix-use-after-free-of-bio.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:43 -0700
Message-ID: <200707312355.l6VNthO5029268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37775 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761359AbXHAARK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.hampel@gmx.de, neilb@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     md: raid10: fix use-after-free of bio
has been removed from the -mm tree.  Its filename was
     md-raid10-fix-use-after-free-of-bio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: raid10: fix use-after-free of bio
From: Maik Hampel <m.hampel@gmx.de>

In case of read errors raid10d tries to print a nice error message,
unfortunately using data from an already put bio.

Signed-off-by: Maik Hampel <m.hampel@gmx.de>
Acked-By: NeilBrown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid10.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/md/raid10.c~md-raid10-fix-use-after-free-of-bio drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-raid10-fix-use-after-free-of-bio
+++ a/drivers/md/raid10.c
@@ -1557,7 +1557,6 @@ static void raid10d(mddev_t *mddev)
 			bio = r10_bio->devs[r10_bio->read_slot].bio;
 			r10_bio->devs[r10_bio->read_slot].bio =
 				mddev->ro ? IO_BLOCKED : NULL;
-			bio_put(bio);
 			mirror = read_balance(conf, r10_bio);
 			if (mirror == -1) {
 				printk(KERN_ALERT "raid10: %s: unrecoverable I/O"
@@ -1565,8 +1564,10 @@ static void raid10d(mddev_t *mddev)
 				       bdevname(bio->bi_bdev,b),
 				       (unsigned long long)r10_bio->sector);
 				raid_end_bio_io(r10_bio);
+				bio_put(bio);
 			} else {
 				const int do_sync = bio_sync(r10_bio->master_bio);
+				bio_put(bio);
 				rdev = conf->mirrors[mirror].rdev;
 				if (printk_ratelimit())
 					printk(KERN_ERR "raid10: %s: redirecting sector %llu to"
_

Patches currently in -mm which might be from m.hampel@gmx.de are

origin.patch
