From: akpm@linux-foundation.org
Subject: [merged] fs-debugsfs-remove-unnecessary-inode-i_private-initialization.patch removed from -mm tree
Date: Mon, 26 Nov 2012 14:21:30 -0800
Message-ID: <20121126222131.14775200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:52176 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab2KZWVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 17:21:33 -0500
Received: by mail-wi0-f202.google.com with SMTP id cb5so330096wib.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 14:21:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clouds.yan@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/debugsfs: remove unnecessary inode->i_private initialization
has been removed from the -mm tree.  Its filename was
     fs-debugsfs-remove-unnecessary-inode-i_private-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yan Hong <clouds.yan@gmail.com>
Subject: fs/debugsfs: remove unnecessary inode->i_private initialization

inode->i_private is promised to be NULL on allocation, no need to set it
explicitly.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/debugfs/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/debugfs/inode.c~fs-debugsfs-remove-unnecessary-inode-i_private-initialization fs/debugfs/inode.c
--- a/fs/debugfs/inode.c~fs-debugsfs-remove-unnecessary-inode-i_private-initialization
+++ a/fs/debugfs/inode.c
@@ -59,7 +59,6 @@ static struct inode *debugfs_get_inode(s
 		case S_IFDIR:
 			inode->i_op = &simple_dir_inode_operations;
 			inode->i_fop = &simple_dir_operations;
-			inode->i_private = NULL;
 
 			/* directory inodes start off with i_nlink == 2
 			 * (for "." entry) */
_

Patches currently in -mm which might be from clouds.yan@gmail.com are

linux-next.patch
fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch

