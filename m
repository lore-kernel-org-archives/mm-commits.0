From: akpm@linux-foundation.org
Subject: - hpfs-dont-call-notify_change.patch removed from -mm tree
Date: Sat, 31 May 2008 00:42:31 -0700
Message-ID: <200805310742.m4V7gViN000916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbYEaHnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 31 May 2008 03:43:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     hpfs: dont call notify_change
has been removed from the -mm tree.  Its filename was
     hpfs-dont-call-notify_change.patch

This patch was dropped because it's more controversial than was first thought, and it was sent off-list

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpfs: dont call notify_change
From: Miklos Szeredi <mszeredi@suse.cz>

hpfs_unlink() calls notify_change() to truncate the file before
deleting.  Replace with explicit call to hpfs_notify_change().

This is equivalent, except that:
 - security_inode_setattr() is not called before hpfs_notify_change()
 - fsnotify_change() is not called after hpfs_notify_change()

The truncation is just an implementation detail, so both the security
check and the notification are unnecessary.

Possibly even the ctime modification is wrong?

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/hpfs/namei.c~hpfs-dont-call-notify_change fs/hpfs/namei.c
--- a/fs/hpfs/namei.c~hpfs-dont-call-notify_change
+++ a/fs/hpfs/namei.c
@@ -426,7 +426,8 @@ again:
 			/*printk("HPFS: truncating file before delete.\n");*/
 			newattrs.ia_size = 0;
 			newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
-			err = notify_change(dentry, &newattrs);
+			newattrs.ia_ctime = current_fs_time(inode->i_sb);
+			err = hpfs_notify_change(dentry, &newattrs);
 			put_write_access(inode);
 			if (!err)
 				goto again;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

gfs2-dont-call-permission.patch
vfs-immutable-inode-checking-cleanup.patch
vfs-truncate-dont-check-immutable-twice.patch
vfs-create-file_truncate-helper.patch
vfs-utimes-immutable-fix.patch
vfs-utimes-cleanup.patch
vfs-dcache-cleanups.patch
vfs-fix-sys_getcwd-for-detached-mounts.patch
git-unprivileged-mounts.patch
hpfs-dont-call-notify_change.patch
hpfs-dont-call-permission.patch
hppfs-remove-hppfs_permission.patch
fat-dont-call-notify_change.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

