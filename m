From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-add-missing-errno-in-ocfs2_ioctl_move_extents.patch removed from -mm
 tree
Date: Wed, 13 Nov 2013 12:37:31 -0800
Message-ID: <5283e30b.HhEjK3qwqWY6OpDP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3KMUhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, dan.carpenter@oracle.com, younger.liu@huawei.com

Subject: [merged] ocfs2-add-missing-errno-in-ocfs2_ioctl_move_extents.patch removed from -mm tree
To: younger.liu@huawei.com,dan.carpenter@oracle.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:31 -0800


The patch titled
     Subject: ocfs2: add missing errno in ocfs2_ioctl_move_extents()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-missing-errno-in-ocfs2_ioctl_move_extents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: add missing errno in ocfs2_ioctl_move_extents()

If the file is not regular or writeable, it should return errno(EPERM).

This patch is based on 85a258b70d ("ocfs2: fix error handling in
ocfs2_ioctl_move_extents()").

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/move_extents.c~ocfs2-add-missing-errno-in-ocfs2_ioctl_move_extents fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-add-missing-errno-in-ocfs2_ioctl_move_extents
+++ a/fs/ocfs2/move_extents.c
@@ -1066,8 +1066,10 @@ int ocfs2_ioctl_move_extents(struct file
 	if (status)
 		return status;
 
-	if ((!S_ISREG(inode->i_mode)) || !(filp->f_mode & FMODE_WRITE))
+	if ((!S_ISREG(inode->i_mode)) || !(filp->f_mode & FMODE_WRITE)) {
+		status = -EPERM;
 		goto out_drop;
+	}
 
 	if (inode->i_flags & (S_IMMUTABLE|S_APPEND)) {
 		status = -EPERM;
@@ -1089,8 +1091,10 @@ int ocfs2_ioctl_move_extents(struct file
 		goto out_free;
 	}
 
-	if (range.me_start > i_size_read(inode))
+	if (range.me_start > i_size_read(inode)) {
+		status = -EINVAL;
 		goto out_free;
+	}
 
 	if (range.me_start + range.me_len > i_size_read(inode))
 			range.me_len = i_size_read(inode) - range.me_start;
_

Patches currently in -mm which might be from younger.liu@huawei.com are

origin.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch

