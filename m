From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-cleanup-unused-variable-ip-in-dlmfs_get_root_inode.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:41:53 -0700
Message-ID: <52321901.tWBgzVTF6L15HCEA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTlx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jeff.liu@oracle.com, joseph.qi@huawei.com

Subject: [merged] ocfs2-cleanup-unused-variable-ip-in-dlmfs_get_root_inode.patch removed from -mm tree
To: joseph.qi@huawei.com,jeff.liu@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:53 -0700


The patch titled
     Subject: ocfs2: remove unused variable ip in dlmfs_get_root_inode()
has been removed from the -mm tree.  Its filename was
     ocfs2-cleanup-unused-variable-ip-in-dlmfs_get_root_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: remove unused variable ip in dlmfs_get_root_inode()

Variable ip in dlmfs_get_root_inode() is defined but not used.  So clean
it up.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmfs/dlmfs.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ocfs2/dlmfs/dlmfs.c~ocfs2-cleanup-unused-variable-ip-in-dlmfs_get_root_inode fs/ocfs2/dlmfs/dlmfs.c
--- a/fs/ocfs2/dlmfs/dlmfs.c~ocfs2-cleanup-unused-variable-ip-in-dlmfs_get_root_inode
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -401,11 +401,8 @@ static struct inode *dlmfs_get_root_inod
 {
 	struct inode *inode = new_inode(sb);
 	umode_t mode = S_IFDIR | 0755;
-	struct dlmfs_inode_private *ip;
 
 	if (inode) {
-		ip = DLMFS_I(inode);
