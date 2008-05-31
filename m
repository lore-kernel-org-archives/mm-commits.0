From: akpm@linux-foundation.org
Subject: - vfs-truncate-dont-check-immutable-twice.patch removed from -mm tree
Date: Sat, 31 May 2008 00:42:47 -0700
Message-ID: <200805310742.m4V7glNV000934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337AbYEaHp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 31 May 2008 03:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: truncate: dont check immutable twice
has been removed from the -mm tree.  Its filename was
     vfs-truncate-dont-check-immutable-twice.patch

This patch was dropped because it's more controversial than was first thought, and it was sent off-list

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: truncate: dont check immutable twice
From: Miklos Szeredi <mszeredi@suse.cz>

vfs_permission(MAY_WRITE) already checked for the inode being
immutable, so no need to repeat it.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/open.c~vfs-truncate-dont-check-immutable-twice fs/open.c
--- a/fs/open.c~vfs-truncate-dont-check-immutable-twice
+++ a/fs/open.c
@@ -254,7 +254,7 @@ static long do_sys_truncate(const char _
 		goto mnt_drop_write_and_out;
 
 	error = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+	if (IS_APPEND(inode))
 		goto mnt_drop_write_and_out;
 
 	error = get_write_access(inode);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

vfs-truncate-dont-check-immutable-twice.patch
vfs-create-file_truncate-helper.patch
vfs-utimes-immutable-fix.patch
vfs-utimes-cleanup.patch
vfs-dcache-cleanups.patch
vfs-fix-sys_getcwd-for-detached-mounts.patch
git-unprivileged-mounts.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

