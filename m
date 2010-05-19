From: akpm@linux-foundation.org
Subject: [merged] vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch removed from -mm tree
Date: Wed, 19 May 2010 10:31:19 -0400
Message-ID: <201005191732.o4JHWjuB025754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354Ab0ESRdI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:33:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, mark.fasheh@oracle.com, sage@newdream.net, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     vfs: fix vfs_rename_dir for FS_RENAME_DOES_D_MOVE filesystems
has been removed from the -mm tree.  Its filename was
     vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: fix vfs_rename_dir for FS_RENAME_DOES_D_MOVE filesystems
From: Miklos Szeredi <mszeredi@suse.cz>

vfs_rename_dir() doesn't properly account for filesystems with
FS_RENAME_DOES_D_MOVE.  If new_dentry has a target inode attached, it
unhashes the new_dentry prior to the rename() iop and rehashes it after,
but doesn't account for the possibility that rename() may have swapped
{old,new}_dentry.  For FS_RENAME_DOES_D_MOVE filesystems, it rehashes
new_dentry (now the old renamed-from name, which d_move() expected to go
away), such that a subsequent lookup will find it.

This was caught by the recently posted POSIX fstest suite, rename/10.t
test 62 (and others) on ceph.

The bug was introduced by: commit 349457ccf2592c14bdf13b6706170ae2e94931b1
"[PATCH] Allow file systems to manually d_move() inside of ->rename()"

Fix by not rehashing the new dentry.  Rehashing used to be needed by
d_move() but isn't anymore.

Reported-by: Sage Weil <sage@newdream.net>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/namei.c~vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems fs/namei.c
--- a/fs/namei.c~vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems
+++ a/fs/namei.c
@@ -2583,8 +2583,6 @@ static int vfs_rename_dir(struct inode *
 		if (!error)
 			target->i_flags |= S_DEAD;
 		mutex_unlock(&target->i_mutex);
-		if (d_unhashed(new_dentry))
-			d_rehash(new_dentry);
 		dput(new_dentry);
 	}
 	if (!error)
_

Patches currently in -mm which might be from mszeredi@suse.cz are


