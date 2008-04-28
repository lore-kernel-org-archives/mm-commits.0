From: akpm@linux-foundation.org
Subject: - raid-remove-leading-tab-on-printk-messages.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:01 -0700
Message-ID: <200804282200.m3SM01qg018634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965567AbYD1WAa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nick@nick-andrew.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     raid: remove leading TAB on printk messages
has been removed from the -mm tree.  Its filename was
     raid-remove-leading-tab-on-printk-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: raid: remove leading TAB on printk messages
From: Nick Andrew <nick@nick-andrew.net>

MD drivers use one printk() call to print 2 log messages and the second line
may be prefixed by a TAB character.  It may also output a trailing space
before newline.  klogd (I think) turns the TAB character into the 2 characters
'^I' when logging to a file.  This looks ugly.

Instead of a leading TAB to indicate continuation, prefix both output lines
with 'raid:' or similar.  Also remove any trailing space in the vicinity of
the affected code and consistently end the sentences with a period.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/multipath.c |    3 ++-
 drivers/md/raid1.c     |    4 ++--
 drivers/md/raid10.c    |    4 ++--
 drivers/md/raid5.c     |    4 ++--
 4 files changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/md/multipath.c~raid-remove-leading-tab-on-printk-messages drivers/md/multipath.c
--- a/drivers/md/multipath.c~raid-remove-leading-tab-on-printk-messages
+++ a/drivers/md/multipath.c
@@ -244,7 +244,8 @@ static void multipath_error (mddev_t *md
 			conf->working_disks--;
 			mddev->degraded++;
 			printk(KERN_ALERT "multipath: IO failure on %s,"
-				" disabling IO path. \n	Operation continuing"
+				" disabling IO path.\n"
+				"multipath: Operation continuing"
 				" on %d IO paths.\n",
 				bdevname (rdev->bdev,b),
 				conf->working_disks);
diff -puN drivers/md/raid1.c~raid-remove-leading-tab-on-printk-messages drivers/md/raid1.c
--- a/drivers/md/raid1.c~raid-remove-leading-tab-on-printk-messages
+++ a/drivers/md/raid1.c
@@ -1008,8 +1008,8 @@ static void error(mddev_t *mddev, mdk_rd
 	} else
 		set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-	printk(KERN_ALERT "raid1: Disk failure on %s, disabling device. \n"
-		"	Operation continuing on %d devices\n",
+	printk(KERN_ALERT "raid1: Disk failure on %s, disabling device.\n"
+		"raid1: Operation continuing on %d devices.\n",
 		bdevname(rdev->bdev,b), conf->raid_disks - mddev->degraded);
 }
 
diff -puN drivers/md/raid10.c~raid-remove-leading-tab-on-printk-messages drivers/md/raid10.c
--- a/drivers/md/raid10.c~raid-remove-leading-tab-on-printk-messages
+++ a/drivers/md/raid10.c
@@ -1001,8 +1001,8 @@ static void error(mddev_t *mddev, mdk_rd
 	}
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-	printk(KERN_ALERT "raid10: Disk failure on %s, disabling device. \n"
-		"	Operation continuing on %d devices\n",
+	printk(KERN_ALERT "raid10: Disk failure on %s, disabling device.\n"
+		"raid10: Operation continuing on %d devices.\n",
 		bdevname(rdev->bdev,b), conf->raid_disks - mddev->degraded);
 }
 
diff -puN drivers/md/raid5.c~raid-remove-leading-tab-on-printk-messages drivers/md/raid5.c
--- a/drivers/md/raid5.c~raid-remove-leading-tab-on-printk-messages
+++ a/drivers/md/raid5.c
@@ -1262,8 +1262,8 @@ static void error(mddev_t *mddev, mdk_rd
 		}
 		set_bit(Faulty, &rdev->flags);
 		printk (KERN_ALERT
-			"raid5: Disk failure on %s, disabling device."
-			" Operation continuing on %d devices\n",
+			"raid5: Disk failure on %s, disabling device.\n"
+			"raid5: Operation continuing on %d devices.\n",
 			bdevname(rdev->bdev,b), conf->raid_disks - mddev->degraded);
 	}
 }
_

Patches currently in -mm which might be from nick@nick-andrew.net are

origin.patch

