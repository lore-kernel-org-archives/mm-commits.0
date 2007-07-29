From: akpm@linux-foundation.org
Subject: + md-raid10-fix-use-after-free-of-bio.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:55:24 -0700
Message-ID: <200707290655.l6T6tOfA012547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759926AbXG2Gzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.hampel@gmx.de, neilb@suse.de


The patch titled
     md: raid10: fix use-after-free of bio
has been added to the -mm tree.  Its filename is
     md-raid10-fix-use-after-free-of-bio.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: raid10: fix use-after-free of bio
From: Maik Hampel <m.hampel@gmx.de>

In case of read errors raid10d tries to print a nice error message,
unfortunately using data from an already put bio.

Signed-off-by: Maik Hampel <m.hampel@gmx.de>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid10.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/md/raid10.c~md-raid10-fix-use-after-free-of-bio drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-raid10-fix-use-after-free-of-bio
+++ a/drivers/md/raid10.c
@@ -1534,7 +1534,6 @@ static void raid10d(mddev_t *mddev)
 			bio = r10_bio->devs[r10_bio->read_slot].bio;
 			r10_bio->devs[r10_bio->read_slot].bio =
 				mddev->ro ? IO_BLOCKED : NULL;
-			bio_put(bio);
 			mirror = read_balance(conf, r10_bio);
 			if (mirror == -1) {
 				printk(KERN_ALERT "raid10: %s: unrecoverable I/O"
@@ -1542,8 +1541,10 @@ static void raid10d(mddev_t *mddev)
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

md-raid10-fix-use-after-free-of-bio.patch
