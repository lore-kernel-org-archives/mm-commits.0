From: akpm@linux-foundation.org
Subject: + ocfs2-cleanup-unused-variable-ip-in-dlmfs_get_root_inode.patch
 added to -mm tree
Date: Tue, 27 Aug 2013 13:51:58 -0700
Message-ID: <521d116e.lWW2l1JpVxkM1Wts%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3H0Uv6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Aug 2013 16:51:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joseph.qi@huawei.com

Subject: + ocfs2-cleanup-unused-variable-ip-in-dlmfs_get_root_inode.patch added to -mm tree
To: joseph.qi@huawei.com
From: akpm@linux-foundation.org
Date: Tue, 27 Aug 2013 13:51:58 -0700


The patch titled
     Subject: ocfs2: remove unused variable ip in dlmfs_get_root_inode()
has been added to the -mm tree.  Its filename is
     ocfs2-cleanup-unused-variable-ip-in-dlmfs_get_root_inode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-cleanup-unused-variable-ip-in-dlmfs_get_root_inode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-cleanup-unused-variable-ip-in-dlmfs_get_root_inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: remove unused variable ip in dlmfs_get_root_inode()

Variable ip in dlmfs_get_root_inode() is defined but not used.  So clean
it up.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
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
