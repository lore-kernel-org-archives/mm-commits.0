From: akpm@linux-foundation.org
Subject: + fs-affs-bugfix-make-symbolic-links-work-again.patch added to
 -mm tree
Date: Tue, 18 Apr 2017 15:08:24 -0700
Message-ID: <58f68e58.8LNQBXPNJmtWcCSb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40388 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752695AbdDRWIZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2017 18:08:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, duaneg@dghda.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: bugfix: make symbolic links work again
has been added to the -mm tree.  Its filename is
     fs-affs-bugfix-make-symbolic-links-work-again.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-bugfix-make-symbolic-links-work-again.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-bugfix-make-symbolic-links-work-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-affs-bugfix-make-symbolic-links-work-again.patch

