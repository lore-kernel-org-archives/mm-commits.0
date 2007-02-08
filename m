From: akpm@linux-foundation.org
Subject: + revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch added to -mm tree
Date: Wed, 07 Feb 2007 16:47:04 -0800
Message-ID: <200702080048.l180m9MH000826@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48299 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161500AbXBHAsS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 19:48:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com, neilb@suse.de


The patch titled
     revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block
has been added to the -mm tree.  Its filename is
     revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block
From: Andrew Morton <akpm@linux-foundation.org>

my life sucks.

Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c         |   22 +---------------------
 include/linux/raid/bitmap.h |    1 -
 2 files changed, 1 insertion(+), 22 deletions(-)

diff -puN drivers/md/bitmap.c~revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block
+++ a/drivers/md/bitmap.c
@@ -1160,22 +1160,6 @@ int bitmap_startwrite(struct bitmap *bit
 			return 0;
 		}
 
-		if (unlikely((*bmc & COUNTER_MAX) == COUNTER_MAX)) {
-			DEFINE_WAIT(__wait);
-			/* note that it is safe to do the prepare_to_wait
-			 * after the test as long as we do it before dropping
-			 * the spinlock.
-			 */
-			prepare_to_wait(&bitmap->overflow_wait, &__wait,
-					TASK_UNINTERRUPTIBLE);
-			spin_unlock_irq(&bitmap->lock);
-			bitmap->mddev->queue
-				->unplug_fn(bitmap->mddev->queue);
-			schedule();
-			finish_wait(&bitmap->overflow_wait, &__wait);
-			continue;
-		}
-
 		switch(*bmc) {
 		case 0:
 			bitmap_file_set_bit(bitmap, offset);
@@ -1185,7 +1169,7 @@ int bitmap_startwrite(struct bitmap *bit
 		case 1:
 			*bmc = 2;
 		}
-
+		BUG_ON((*bmc & COUNTER_MAX) == COUNTER_MAX);
 		(*bmc)++;
 
 		spin_unlock_irq(&bitmap->lock);
@@ -1223,9 +1207,6 @@ void bitmap_endwrite(struct bitmap *bitm
 		if (!success && ! (*bmc & NEEDED_MASK))
 			*bmc |= NEEDED_MASK;
 
-		if ((*bmc & COUNTER_MAX) == COUNTER_MAX)
-			wake_up(&bitmap->overflow_wait);
-
 		(*bmc)--;
 		if (*bmc <= 2) {
 			set_page_attr(bitmap,
@@ -1450,7 +1431,6 @@ int bitmap_create(mddev_t *mddev)
 	spin_lock_init(&bitmap->lock);
 	atomic_set(&bitmap->pending_writes, 0);
 	init_waitqueue_head(&bitmap->write_wait);
-	init_waitqueue_head(&bitmap->overflow_wait);
 
 	bitmap->mddev = mddev;
 
diff -puN include/linux/raid/bitmap.h~revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block include/linux/raid/bitmap.h
--- a/include/linux/raid/bitmap.h~revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block
+++ a/include/linux/raid/bitmap.h
@@ -247,7 +247,6 @@ struct bitmap {
 
 	atomic_t pending_writes; /* pending writes to the bitmap file */
 	wait_queue_head_t write_wait;
-	wait_queue_head_t overflow_wait;
 
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
spi-filesystem-api-tweaks.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
fix-utrace-utrace-ptrace-compat.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-3-fix.patch
