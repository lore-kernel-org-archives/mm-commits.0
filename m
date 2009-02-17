From: akpm@linux-foundation.org
Subject: + pm-hibernate-fix-swap-breaks-after-hibernation-failures.patch added to -mm tree
Date: Tue, 17 Feb 2009 15:50:17 -0800
Message-ID: <200902172350.n1HNoIYS026751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408AbZBQXvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 18:51:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan-jenkins@tuffmail.co.uk, lenb@kernel.org, rjw@sisk.pl


The patch titled
     PM/hibernate: fix "swap breaks after hibernation failures"
has been added to the -mm tree.  Its filename is
     pm-hibernate-fix-swap-breaks-after-hibernation-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

pm-hibernate-fix-swap-breaks-after-hibernation-failures.patch

