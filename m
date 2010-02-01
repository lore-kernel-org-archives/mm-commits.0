From: akpm@linux-foundation.org
Subject: [merged] freeze_bdev-dont-deactivate-successfully-frozen-ms_rdonly-sb.patch removed from -mm tree
Date: Mon, 01 Feb 2010 10:38:48 -0800
Message-ID: <201002011838.o11Icm8M004875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755621Ab0BASkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 13:40:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: j-nomura@ce.jp.nec.com, hch@lst.de, jens.axboe@oracle.com, neilb@suse.de, stable@kernel.org, tmb@mandriva.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     freeze_bdev(): don't deactivate successfully frozen MS_RDONLY sb
has been removed from the -mm tree.  Its filename was
     freeze_bdev-dont-deactivate-successfully-frozen-ms_rdonly-sb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: freeze_bdev(): don't deactivate successfully frozen MS_RDONLY sb
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>

If MS_RDONLY, freeze_bdev should just up_write(s_umount) instead of
deactivate_locked_super().

Also, keep sb->s_frozen consistent so that remount can check the frozen
state.

Otherwise a crash reported here can happen:
http://lkml.org/lkml/2010/1/16/37
http://lkml.org/lkml/2010/1/28/53

Thanks Thomas and Christoph for testing and review.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Thomas Backlund <tmb@mandriva.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@kernel.org>		[2.6.32.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/block_dev.c~freeze_bdev-dont-deactivate-successfully-frozen-ms_rdonly-sb fs/block_dev.c
--- a/fs/block_dev.c~freeze_bdev-dont-deactivate-successfully-frozen-ms_rdonly-sb
+++ a/fs/block_dev.c
@@ -246,7 +246,8 @@ struct super_block *freeze_bdev(struct b
 	if (!sb)
 		goto out;
 	if (sb->s_flags & MS_RDONLY) {
-		deactivate_locked_super(sb);
+		sb->s_frozen = SB_FREEZE_TRANS;
+		up_write(&sb->s_umount);
 		mutex_unlock(&bdev->bd_fsfreeze_mutex);
 		return sb;
 	}
@@ -307,7 +308,7 @@ int thaw_bdev(struct block_device *bdev,
 	BUG_ON(sb->s_bdev != bdev);
 	down_write(&sb->s_umount);
 	if (sb->s_flags & MS_RDONLY)
-		goto out_deactivate;
+		goto out_unfrozen;
 
 	if (sb->s_op->unfreeze_fs) {
 		error = sb->s_op->unfreeze_fs(sb);
@@ -321,11 +322,11 @@ int thaw_bdev(struct block_device *bdev,
 		}
 	}
 
+out_unfrozen:
 	sb->s_frozen = SB_UNFROZEN;
 	smp_wmb();
 	wake_up(&sb->s_wait_unfrozen);
 
-out_deactivate:
 	if (sb)
 		deactivate_locked_super(sb);
 out_unlock:
_

Patches currently in -mm which might be from j-nomura@ce.jp.nec.com are

linux-next.patch

