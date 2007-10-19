From: akpm@linux-foundation.org
Subject: - vfs-allow-filesystems-to-implement-atomic-opentruncate.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:51 -0700
Message-ID: <200710190345.l9J3jpxx013254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36470 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966184AbXJSDzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, adilger@clusterfs.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     VFS: allow filesystems to implement atomic open+truncate
has been removed from the -mm tree.  Its filename was
     vfs-allow-filesystems-to-implement-atomic-opentruncate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: VFS: allow filesystems to implement atomic open+truncate
From: Miklos Szeredi <mszeredi@suse.cz>

Add a new attribute flag ATTR_OPEN, with the meaning: "truncation was
initiated by open() due to the O_TRUNC flag".

This way filesystems wanting to implement truncation within their ->open()
method can ignore such truncate requests.

This is a quick & dirty hack, but it comes for free.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c         |    6 ++++--
 include/linux/fs.h |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/namei.c~vfs-allow-filesystems-to-implement-atomic-opentruncate fs/namei.c
--- a/fs/namei.c~vfs-allow-filesystems-to-implement-atomic-opentruncate
+++ a/fs/namei.c
@@ -1659,8 +1659,10 @@ int may_open(struct nameidata *nd, int a
 		error = locks_verify_locked(inode);
 		if (!error) {
 			DQUOT_INIT(inode);
-			
-			error = do_truncate(dentry, 0, ATTR_MTIME|ATTR_CTIME, NULL);
+
+			error = do_truncate(dentry, 0,
+					    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN,
+					    NULL);
 		}
 		put_write_access(inode);
 		if (error)
diff -puN include/linux/fs.h~vfs-allow-filesystems-to-implement-atomic-opentruncate include/linux/fs.h
--- a/include/linux/fs.h~vfs-allow-filesystems-to-implement-atomic-opentruncate
+++ a/include/linux/fs.h
@@ -330,6 +330,7 @@ typedef void (dio_iodone_t)(struct kiocb
 #define ATTR_KILL_SGID	4096
 #define ATTR_FILE	8192
 #define ATTR_KILL_PRIV	16384
+#define ATTR_OPEN	32768	/* Truncating from open(O_TRUNC) */
 
 /*
  * This is the Inode Attributes structure, used for notify_change().  It
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch
unprivileged-mounts-add-no-submounts-flag.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
