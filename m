From: akpm@linux-foundation.org
Subject: - allow-auto-destruction-of-loop-devices.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:12 -0800
Message-ID: <200802070020.m170KrOB006200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44328 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764496AbYBGApG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, bernie@codewiz.org, mm-commits@vger.kernel.org


The patch titled
     Allow auto-destruction of loop devices
has been removed from the -mm tree.  Its filename was
     allow-auto-destruction-of-loop-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

[akpm@linux-foundation.org: coding-style fixes]
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
 
+	if ((lo->lo_flags & LO_FLAGS_AUTOCLEAR) !=
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
power_supply-remove-capacity_level-from-list-of-sysfs-attributes.patch
audit-let-userspace-fully-control-tty-input-auditing.patch
git-mtd.patch
drivers-mtd-maps-physmapc-fix-compile-remove-ifdef.patch
eccbuf-is-statically-defined-and-always-evaluate-to-true.patch
mtd-fix-startup-lock-when-using-multiple-nor-flash-chips.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
unexport-asm-userh-and-linux-userh.patch
cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed.patch
cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed-fix.patch
unexport-asm-elfh.patch
unexport-asm-pageh.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
