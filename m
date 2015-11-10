From: akpm@linux-foundation.org
Subject: [merged] fs-reiserfs-remove-unnecessary-new_valid_dev-check.patch removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:41 -0800
Message-ID: <564254a5.s1H4XWan1Yw3aJCs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbKJUdl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/reiserfs/namei.c: remove unnecessary new_valid_dev() check
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-remove-unnecessary-new_valid_dev-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: fs/reiserfs/namei.c: remove unnecessary new_valid_dev() check

new_valid_dev() always returns 1, so the !new_valid_dev() check is not
needed.  Remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/namei.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/reiserfs/namei.c~fs-reiserfs-remove-unnecessary-new_valid_dev-check fs/reiserfs/namei.c
--- a/fs/reiserfs/namei.c~fs-reiserfs-remove-unnecessary-new_valid_dev-check
+++ a/fs/reiserfs/namei.c
@@ -712,9 +712,6 @@ static int reiserfs_mknod(struct inode *
 	    2 * (REISERFS_QUOTA_INIT_BLOCKS(dir->i_sb) +
 		 REISERFS_QUOTA_TRANS_BLOCKS(dir->i_sb));
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
