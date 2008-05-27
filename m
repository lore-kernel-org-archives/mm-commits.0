From: akpm@linux-foundation.org
Subject: - md-md-raid5-rate-limit-error-printk.patch removed from -mm tree
Date: Tue, 27 May 2008 00:27:12 -0700
Message-ID: <200805270727.m4R7RC5B014746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755466AbYE0H1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:27:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bernd-schubert@gmx.de, dan.j.williams@intel.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: md: raid5 rate limit error printk
has been removed from the -mm tree.  Its filename was
     md-md-raid5-rate-limit-error-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: md: raid5 rate limit error printk
From: Bernd Schubert <bernd-schubert@gmx.de>

Last night we had scsi problems and a hardware raid unit was offlined
during heavy i/o.  While this happened we got for about 3 minutes a huge
number messages like these

Apr 12 03:36:07 pfs1n14 kernel: [197510.696595] raid5:md7: read error not correctable (sector 2993096568 on sdj2).

I guess the high error rate is responsible for not scheduling other events
- during this time the system was not pingable and in the end also other
devices run into scsi command timeouts causing problems on these unrelated
devices as well.

Signed-off-by: Bernd Schubert <bernd-schubert@gmx.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff -puN drivers/md/raid5.c~md-md-raid5-rate-limit-error-printk drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-md-raid5-rate-limit-error-printk
+++ a/drivers/md/raid5.c
@@ -94,6 +94,8 @@
 #define __inline__
 #endif
 
+#define printk_rl(args...) ((void) (printk_ratelimit() && printk(args)))
+
 #if !RAID6_USE_EMPTY_ZERO_PAGE
 /* In .bss so it's zeroed */
 const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(256)));
@@ -1143,10 +1145,12 @@ static void raid5_end_read_request(struc
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 			rdev = conf->disks[i].rdev;
-			printk(KERN_INFO "raid5:%s: read error corrected (%lu sectors at %llu on %s)\n",
-			       mdname(conf->mddev), STRIPE_SECTORS,
-			       (unsigned long long)(sh->sector + rdev->data_offset),
-			       bdevname(rdev->bdev, b));
+			printk_rl(KERN_INFO "raid5:%s: read error corrected"
+				  " (%lu sectors at %llu on %s)\n",
+				  mdname(conf->mddev), STRIPE_SECTORS,
+				  (unsigned long long)(sh->sector
+						       + rdev->data_offset),
+				  bdevname(rdev->bdev, b));
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		}
@@ -1160,16 +1164,22 @@ static void raid5_end_read_request(struc
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		atomic_inc(&rdev->read_errors);
 		if (conf->mddev->degraded)
-			printk(KERN_WARNING "raid5:%s: read error not correctable (sector %llu on %s).\n",
-			       mdname(conf->mddev),
-			       (unsigned long long)(sh->sector + rdev->data_offset),
-			       bdn);
+			printk_rl(KERN_WARNING
+				  "raid5:%s: read error not correctable "
+				  "(sector %llu on %s).\n",
+				  mdname(conf->mddev),
+				  (unsigned long long)(sh->sector
+						       + rdev->data_offset),
+				  bdn);
 		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
 			/* Oh, no!!! */
-			printk(KERN_WARNING "raid5:%s: read error NOT corrected!! (sector %llu on %s).\n",
-			       mdname(conf->mddev),
-			       (unsigned long long)(sh->sector + rdev->data_offset),
-			       bdn);
+			printk_rl(KERN_WARNING
+				  "raid5:%s: read error NOT corrected!! "
+				  "(sector %llu on %s).\n",
+				  mdname(conf->mddev),
+				  (unsigned long long)(sh->sector
+						       + rdev->data_offset),
+				  bdn);
 		else if (atomic_read(&rdev->read_errors)
 			 > conf->max_nr_stripes)
 			printk(KERN_WARNING
_

Patches currently in -mm which might be from bernd-schubert@gmx.de are


