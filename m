From: akpm@linux-foundation.org
Subject: [patch 095/114] fs: ufs: use ktime_get_real_ts64() for
 birthtime
Date: Mon, 08 May 2017 15:59:22 -0700
Message-ID: <20170508225922.Rpafn7pOw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47476 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753033AbdEHW7X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, deepa.kernel@gmail.com, dushistov@mail.ru, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
