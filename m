From: akpm@linux-foundation.org
Subject: + allow-auto-destruction-of-loop-devices.patch added to -mm tree
Date: Tue, 30 Oct 2007 13:19:11 -0700
Message-ID: <200710302019.l9UKJBAB026139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58376 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbXJ3UT0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:19:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwmw2@infradead.org, bernie@codewiz.org


The patch titled
     Allow auto-destruction of loop devices
has been added to the -mm tree.  Its filename is
     allow-auto-destruction-of-loop-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Allow auto-destruction of loop devices
From: David Woodhouse <dwmw2@infradead.org>

This allows a flag to be set on loop devices so that when they are
closed for the last time, they'll self-destruct.

In general, so that we can automatically allocate loop devices (as with
losetup -f) and have them disappear when we're done with them.

In particular, right now, so that we can stop relying on the hackish
special-case in umount(8) which kills off loop devices which were set up by
'mount -oloop'.  That means we can stop putting crap in /etc/mtab which
doesn't belong there, which means it can be a symlink to /proc/mounts, which
means yet another writable file on the root filesystem is eliminated and the
'stateless' folks get happier...  and OLPC trac #356 can be closed.

The mount(8) side of that is at
http://marc.info/?l=util-linux-ng&m=119362955431694&w=2

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cc: Bernardo Innocenti <bernie@codewiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    8 ++++++++
 include/linux/loop.h |    1 +
 2 files changed, 9 insertions(+)

diff -puN drivers/block/loop.c~allow-auto-destruction-of-loop-devices drivers/block/loop.c
--- a/drivers/block/loop.c~allow-auto-destruction-of-loop-devices
+++ a/drivers/block/loop.c
@@ -973,6 +973,10 @@ loop_set_status(struct loop_device *lo, 
 	lo->transfer = xfer->transfer;
 	lo->ioctl = xfer->ioctl;
 
+	if ( (lo->lo_flags & LO_FLAGS_AUTOCLEAR) !=
+	     (info->lo_flags & LO_FLAGS_AUTOCLEAR))
+		lo->lo_flags ^= LO_FLAGS_AUTOCLEAR;
+
 	lo->lo_encrypt_key_size = info->lo_encrypt_key_size;
 	lo->lo_init[0] = info->lo_init[0];
 	lo->lo_init[1] = info->lo_init[1];
@@ -1331,6 +1335,10 @@ static int lo_release(struct inode *inod
 
 	mutex_lock(&lo->lo_ctl_mutex);
 	--lo->lo_refcnt;
+
+	if ((lo->lo_flags & LO_FLAGS_AUTOCLEAR) && !lo->lo_refcnt)
+		loop_clr_fd(lo, inode->i_bdev);
+
 	mutex_unlock(&lo->lo_ctl_mutex);
 
 	return 0;
diff -puN include/linux/loop.h~allow-auto-destruction-of-loop-devices include/linux/loop.h
--- a/include/linux/loop.h~allow-auto-destruction-of-loop-devices
+++ a/include/linux/loop.h
@@ -76,6 +76,7 @@ struct loop_device {
 enum {
 	LO_FLAGS_READ_ONLY	= 1,
 	LO_FLAGS_USE_AOPS	= 2,
+	LO_FLAGS_AUTOCLEAR	= 4,
 };
 
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
git-mtd.patch
eccbuf-is-statically-defined-and-always-evaluate-to-true.patch
remove-fs-jffs2-ioctlc.patch
remove-support-for-un-needed-_extratext-section.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
