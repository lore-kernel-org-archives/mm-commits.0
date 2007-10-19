From: akpm@linux-foundation.org
Subject: - fuse-add-atomic-opentruncate-support.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:55 -0700
Message-ID: <200710190345.l9J3jtlZ013260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762259AbXJSDzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: add atomic open+truncate support
has been removed from the -mm tree.  Its filename was
     fuse-add-atomic-opentruncate-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: add atomic open+truncate support
From: Miklos Szeredi <mszeredi@suse.cz>

This patch allows fuse filesystems to implement open(..., O_TRUNC) as a single
request, instead of separate truncate and open requests.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c        |    3 +++
 fs/fuse/file.c       |    4 +++-
 fs/fuse/fuse_i.h     |    3 +++
 fs/fuse/inode.c      |    5 ++++-
 include/linux/fuse.h |    1 +
 5 files changed, 14 insertions(+), 2 deletions(-)

diff -puN fs/fuse/dir.c~fuse-add-atomic-opentruncate-support fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-add-atomic-opentruncate-support
+++ a/fs/fuse/dir.c
@@ -1083,6 +1083,9 @@ static int fuse_do_setattr(struct dentry
 			return err;
 	}
 
+	if ((attr->ia_valid & ATTR_OPEN) && fc->atomic_o_trunc)
+		return 0;
+
 	if (attr->ia_valid & ATTR_SIZE) {
 		unsigned long limit;
 		if (IS_SWAPFILE(inode))
diff -puN fs/fuse/file.c~fuse-add-atomic-opentruncate-support fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-add-atomic-opentruncate-support
+++ a/fs/fuse/file.c
@@ -28,7 +28,9 @@ static int fuse_send_open(struct inode *
 		return PTR_ERR(req);
 
 	memset(&inarg, 0, sizeof(inarg));
-	inarg.flags = file->f_flags & ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
+	inarg.flags = file->f_flags & ~(O_CREAT | O_EXCL | O_NOCTTY);
+	if (!fc->atomic_o_trunc)
+		inarg.flags &= ~O_TRUNC;
 	req->in.h.opcode = isdir ? FUSE_OPENDIR : FUSE_OPEN;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.numargs = 1;
diff -puN fs/fuse/fuse_i.h~fuse-add-atomic-opentruncate-support fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-add-atomic-opentruncate-support
+++ a/fs/fuse/fuse_i.h
@@ -320,6 +320,9 @@ struct fuse_conn {
 	/** Do readpages asynchronously?  Only set in INIT */
 	unsigned async_read : 1;
 
+	/** Do not send separate SETATTR request before open(O_TRUNC)  */
+	unsigned atomic_o_trunc : 1;
+
 	/*
 	 * The following bitfields are only for optimization purposes
 	 * and hence races in setting them will not cause malfunction
diff -puN fs/fuse/inode.c~fuse-add-atomic-opentruncate-support fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-add-atomic-opentruncate-support
+++ a/fs/fuse/inode.c
@@ -531,6 +531,8 @@ static void process_init_reply(struct fu
 				fc->async_read = 1;
 			if (!(arg->flags & FUSE_POSIX_LOCKS))
 				fc->no_lock = 1;
+			if (arg->flags & FUSE_ATOMIC_O_TRUNC)
+				fc->atomic_o_trunc = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;
@@ -553,7 +555,8 @@ static void fuse_send_init(struct fuse_c
 	arg->major = FUSE_KERNEL_VERSION;
 	arg->minor = FUSE_KERNEL_MINOR_VERSION;
 	arg->max_readahead = fc->bdi.ra_pages * PAGE_CACHE_SIZE;
-	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_FILE_OPS;
+	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_FILE_OPS |
+		FUSE_ATOMIC_O_TRUNC;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
diff -puN include/linux/fuse.h~fuse-add-atomic-opentruncate-support include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-add-atomic-opentruncate-support
+++ a/include/linux/fuse.h
@@ -101,6 +101,7 @@ struct fuse_file_lock {
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
 #define FUSE_FILE_OPS		(1 << 2)
+#define FUSE_ATOMIC_O_TRUNC	(1 << 3)
 
 /**
  * Release flags
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
