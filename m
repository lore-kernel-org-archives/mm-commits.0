From: akpm@linux-foundation.org
Subject: [merged] loopdev-fix-a-deadlock.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:35 -0800
Message-ID: <20130225205635.CEC8C5A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:63687 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759857Ab3BYU4h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:37 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so347863vea.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan@linux.vnet.ibm.com, axboe@kernel.dk, hindessm@uk.ibm.com, knikanth@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: loopdev: fix a deadlock
has been removed from the -mm tree.  Its filename was
     loopdev-fix-a-deadlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: loopdev: fix a deadlock

bd_mutex and lo_ctl_mutex can be held in different order.

Path #1:

blkdev_open
 blkdev_get
  __blkdev_get (hold bd_mutex)
   lo_open (hold lo_ctl_mutex)

Path #2:

blkdev_ioctl
 lo_ioctl (hold lo_ctl_mutex)
  lo_set_capacity (hold bd_mutex)

Lockdep does not report it, because path #2 actually holds a subclass of
lo_ctl_mutex.  This subclass seems creep into the code by mistake.  The
patch author actually just mentioned it in the changelog, see commit
f028f3b2 ("loop: fix circular locking in loop_clr_fd()"), also see:

	http://marc.info/?l=linux-kernel&m=123806169129727&w=2

Path #2 hold bd_mutex to call bd_set_size(), I've protected it
with i_mutex in a previous patch, so drop bd_mutex at this site.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Guo Chao <yan@linux.vnet.ibm.com>
Cc: M. Hindess <hindessm@uk.ibm.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/block/loop.c~loopdev-fix-a-deadlock drivers/block/loop.c
--- a/drivers/block/loop.c~loopdev-fix-a-deadlock
+++ a/drivers/block/loop.c
@@ -1285,11 +1285,9 @@ static int loop_set_capacity(struct loop
 	/* the width of sector_t may be narrow for bit-shift */
 	sz = sec;
 	sz <<= 9;
-	mutex_lock(&bdev->bd_mutex);
 	bd_set_size(bdev, sz);
 	/* let user-space know about the new size */
 	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
-	mutex_unlock(&bdev->bd_mutex);
 
  out:
 	return err;
_

Patches currently in -mm which might be from yan@linux.vnet.ibm.com are

linux-next.patch

