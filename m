From: akpm@linux-foundation.org
Subject: [merged]
 fs-affs-bugfix-make-symbolic-links-work-again.patch removed from -mm tree
Date: Mon, 01 May 2017 12:20:54 -0700
Message-ID: <20170501192054.b64iQOsii%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54312 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbdEATU4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 1 May 2017 15:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: duaneg@dghda.com, fabf@skynet.be, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/affs: bugfix: make symbolic links work again
has been removed from the -mm tree.  Its filename was
     fs-affs-bugfix-make-symbolic-links-work-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: bugfix: make symbolic links work again

AFFS symbolic links were broken since kernel 2.6.29

Problem was bisected to the following

commit ebd09abbd969 ("vfs: ensure page symlinks are NUL-terminated")
commit 035146851cfa ("vfs: introduce helper function to safely NUL-terminate symlinks")

AFFS wasn't setting inode size when reading symbolic link from disk or
creating a new one. Result was zero allocation in pagecache.

ln -s file symlink

ls -lrt

file
symlink ->

This patch adds inode isize information on inode get and symbolic link
addition.

Link: http://lkml.kernel.org/r/20170415065436.13518-1-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Duane Griffin <duaneg@dghda.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/inode.c |    1 +
 fs/affs/namei.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN fs/affs/inode.c~fs-affs-bugfix-make-symbolic-links-work-again fs/affs/inode.c
--- a/fs/affs/inode.c~fs-affs-bugfix-make-symbolic-links-work-again
+++ a/fs/affs/inode.c
@@ -140,6 +140,7 @@ struct inode *affs_iget(struct super_blo
 		inode->i_fop = &affs_file_operations;
 		break;
 	case ST_SOFTLINK:
+		inode->i_size = strlen((char *)AFFS_HEAD(bh)->table);
 		inode->i_mode |= S_IFLNK;
 		inode_nohighmem(inode);
 		inode->i_op = &affs_symlink_inode_operations;
diff -puN fs/affs/namei.c~fs-affs-bugfix-make-symbolic-links-work-again fs/affs/namei.c
--- a/fs/affs/namei.c~fs-affs-bugfix-make-symbolic-links-work-again
+++ a/fs/affs/namei.c
@@ -365,6 +365,7 @@ affs_symlink(struct inode *dir, struct d
 				symname++;
 	}
 	*p = 0;
+	inode->i_size = i + 1;
 	mark_buffer_dirty_inode(bh, inode);
 	affs_brelse(bh);
 	mark_inode_dirty(inode);
_

Patches currently in -mm which might be from fabf@skynet.be are


