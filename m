From: akpm@linux-foundation.org
Subject: + loopdev-fix-a-deadlock.patch added to -mm tree
Date: Mon, 28 Jan 2013 16:40:14 -0800
Message-ID: <20130129004015.6682631C25A@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:52271 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3A2AkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 19:40:16 -0500
Received: by mail-ia0-f202.google.com with SMTP id p22so632682iad.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 16:40:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yan@linux.vnet.ibm.com, axboe@kernel.dk, hindessm@uk.ibm.com, knikanth@suse.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: loopdev: fix a deadlock
has been added to the -mm tree.  Its filename is
     loopdev-fix-a-deadlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
block-use-i_size_write-in-bd_set_size.patch
block-remove-redundant-check-to-bd_openers.patch
loopdev-fix-a-deadlock.patch
loopdev-update-block-device-size-in-loop_set_status.patch
loopdev-move-common-code-into-loop_figure_size.patch
loopdev-remove-an-user-triggerable-oops.patch
loopdev-ignore-negative-offset-when-calculate-loop-device-size.patch

