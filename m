From: akpm@linux-foundation.org
Subject: [merged] fs-vfs-remove-unnecessary-new_valid_dev-check.patch
 removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:22 -0800
Message-ID: <56425492.BHoVTIvTrTGKJjrT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbKJUdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/9p: remove unnecessary new_valid_dev() checks
has been removed from the -mm tree.  Its filename was
     fs-vfs-remove-unnecessary-new_valid_dev-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: fs/9p: remove unnecessary new_valid_dev() checks

new_valid_dev() always returns 1, so the !new_valid_dev() check is not
needed.  Remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/vfs_inode.c      |    3 ---
 fs/9p/vfs_inode_dotl.c |    3 ---
 2 files changed, 6 deletions(-)

diff -puN fs/9p/vfs_inode.c~fs-vfs-remove-unnecessary-new_valid_dev-check fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c~fs-vfs-remove-unnecessary-new_valid_dev-check
+++ a/fs/9p/vfs_inode.c
@@ -1368,9 +1368,6 @@ v9fs_vfs_mknod(struct inode *dir, struct
 		 dir->i_ino, dentry, mode,
 		 MAJOR(rdev), MINOR(rdev));
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
-
 	/* build extension */
 	if (S_ISBLK(mode))
 		sprintf(name, "b %u %u", MAJOR(rdev), MINOR(rdev));
diff -puN fs/9p/vfs_inode_dotl.c~fs-vfs-remove-unnecessary-new_valid_dev-check fs/9p/vfs_inode_dotl.c
--- a/fs/9p/vfs_inode_dotl.c~fs-vfs-remove-unnecessary-new_valid_dev-check
+++ a/fs/9p/vfs_inode_dotl.c
@@ -829,9 +829,6 @@ v9fs_vfs_mknod_dotl(struct inode *dir, s
 		 dir->i_ino, dentry, omode,
 		 MAJOR(rdev), MINOR(rdev));
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
