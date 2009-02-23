From: akpm@linux-foundation.org
Subject: [merged] pm-hibernate-fix-swap-breaks-after-hibernation-failures.patch removed from -mm tree
Date: Mon, 23 Feb 2009 12:06:59 -0800
Message-ID: <200902232006.n1NK6x0W013447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439AbZBWUHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 15:07:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan-jenkins@tuffmail.co.uk, lenb@kernel.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     PM/hibernate: fix "swap breaks after hibernation failures"
has been removed from the -mm tree.  Its filename was
     pm-hibernate-fix-swap-breaks-after-hibernation-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PM/hibernate: fix "swap breaks after hibernation failures"
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=12239

The image writing code dropped a reference to the current swap device. 
This doesn't show up if the hibernation succeeds - because it doesn't
affect the image which gets resumed.  But it means multiple _failed_
hibernations end up freeing the swap device while it is still use!

swsusp_write() finds the block device for the swap file using
swap_type_of().  It then uses blkdev_get() / blkdev_put() to open and
close the block device.

Unfortunately, blkdev_get() assumes ownership of the inode of the
block_device passed to it.  So blkdev_put() calls iput() on the inode. 
This is by design and other callers expect this behaviour.  The fix is for
swap_type_of() to take a reference on the inode using bdget().

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/swapfile.c~pm-hibernate-fix-swap-breaks-after-hibernation-failures mm/swapfile.c
--- a/mm/swapfile.c~pm-hibernate-fix-swap-breaks-after-hibernation-failures
+++ a/mm/swapfile.c
@@ -635,7 +635,7 @@ int swap_type_of(dev_t device, sector_t 
 
 		if (!bdev) {
 			if (bdev_p)
-				*bdev_p = sis->bdev;
+				*bdev_p = bdget(sis->bdev->bd_dev);
 
 			spin_unlock(&swap_lock);
 			return i;
@@ -647,7 +647,7 @@ int swap_type_of(dev_t device, sector_t 
 					struct swap_extent, list);
 			if (se->start_block == offset) {
 				if (bdev_p)
-					*bdev_p = sis->bdev;
+					*bdev_p = bdget(sis->bdev->bd_dev);
 
 				spin_unlock(&swap_lock);
 				bdput(bdev);
_

Patches currently in -mm which might be from alan-jenkins@tuffmail.co.uk are


