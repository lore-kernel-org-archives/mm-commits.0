From: akpm@linux-foundation.org
Subject: [merged]
 fs-ufs-use-ktime_get_real_ts64-for-birthtime.patch removed from -mm tree
Date: Tue, 09 May 2017 11:04:04 -0700
Message-ID: <20170509180404.Z7Toydy-P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753737AbdEISEF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:04:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: ufs: use ktime_get_real_ts64() for birthtime
has been removed from the -mm tree.  Its filename was
     fs-ufs-use-ktime_get_real_ts64-for-birthtime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: fs: ufs: use ktime_get_real_ts64() for birthtime

CURRENT_TIME is not y2038 safe.  Replace it with ktime_get_real_ts64(). 
Inode time formats are already 64 bit long and accommodates time64_t.

Link: http://lkml.kernel.org/r/1491613030-11599-6-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/ialloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/ufs/ialloc.c~fs-ufs-use-ktime_get_real_ts64-for-birthtime fs/ufs/ialloc.c
--- a/fs/ufs/ialloc.c~fs-ufs-use-ktime_get_real_ts64-for-birthtime
+++ a/fs/ufs/ialloc.c
@@ -176,6 +176,7 @@ struct inode *ufs_new_inode(struct inode
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	struct inode * inode;
+	struct timespec64 ts;
 	unsigned cg, bit, i, j, start;
 	struct ufs_inode_info *ufsi;
 	int err = -ENOSPC;
@@ -323,8 +324,9 @@ cg_found:
 		lock_buffer(bh);
 		ufs2_inode = (struct ufs2_inode *)bh->b_data;
 		ufs2_inode += ufs_inotofsbo(inode->i_ino);
-		ufs2_inode->ui_birthtime = cpu_to_fs64(sb, CURRENT_TIME.tv_sec);
-		ufs2_inode->ui_birthnsec = cpu_to_fs32(sb, CURRENT_TIME.tv_nsec);
+		ktime_get_real_ts64(&ts);
+		ufs2_inode->ui_birthtime = cpu_to_fs64(sb, ts.tv_sec);
+		ufs2_inode->ui_birthnsec = cpu_to_fs32(sb, ts.tv_nsec);
 		mark_buffer_dirty(bh);
 		unlock_buffer(bh);
 		if (sb->s_flags & MS_SYNCHRONOUS)
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are

time-delete-current_fs_time-function.patch

