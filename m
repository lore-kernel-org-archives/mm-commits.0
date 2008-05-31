From: akpm@linux-foundation.org
Subject: - hpfs-dont-call-permission.patch removed from -mm tree
Date: Sat, 31 May 2008 00:42:37 -0700
Message-ID: <200805310742.m4V7gbWh000922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbYEaHnW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 31 May 2008 03:43:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     hpfs: dont call permission()
has been removed from the -mm tree.  Its filename was
     hpfs-dont-call-permission.patch

This patch was dropped because it's more controversial than was first thought, and it was sent off-list

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpfs: dont call permission()
From: Miklos Szeredi <mszeredi@suse.cz>

hpfs_unlink() calls permission() prior to truncating the file.  HPFS
doesn't define a .permission method, so replace with explicit call to
generic_permission().

This is equivalent, except that devcgroup_inode_permission() and
security_inode_permission() are not called.

The truncation is just an implementation detail of the unlink, so
these security checks are unnecessary.

I suspect that even calling generic_permission() is unnecessary, since
we shouldn't mind if the file isn't writable.  But I leave that to the
maintainer to decide.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hpfs/namei.c~hpfs-dont-call-permission fs/hpfs/namei.c
--- a/fs/hpfs/namei.c~hpfs-dont-call-permission
+++ a/fs/hpfs/namei.c
@@ -415,7 +415,7 @@ again:
 		d_drop(dentry);
 		spin_lock(&dentry->d_lock);
 		if (atomic_read(&dentry->d_count) > 1 ||
-		    permission(inode, MAY_WRITE, NULL) ||
+		    generic_permission(inode, MAY_WRITE, NULL) ||
 		    !S_ISREG(inode->i_mode) ||
 		    get_write_access(inode)) {
 			spin_unlock(&dentry->d_lock);
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
hpfs-dont-call-permission.patch
hppfs-remove-hppfs_permission.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

