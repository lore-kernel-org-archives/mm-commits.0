From: akpm@linux-foundation.org
Subject: + fuse-add-atomic-opentruncate-support.patch added to -mm tree
Date: Thu, 04 Oct 2007 15:57:10 -0700
Message-ID: <200710042257.l94MvAw4032744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39516 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760765AbXJDW5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 18:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: add atomic open+truncate support
has been added to the -mm tree.  Its filename is
     fuse-add-atomic-opentruncate-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: add atomic open+truncate support
From: Miklos Szeredi <mszeredi@suse.cz>

This patch allows fuse filesystems to implement open(..., O_TRUNC) as a single
request, instead of separate truncate and open requests.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
@@ -548,6 +548,8 @@ static void process_init_reply(struct fu
 				fc->async_read = 1;
 			if (!(arg->flags & FUSE_POSIX_LOCKS))
 				fc->no_lock = 1;
+			if (arg->flags & FUSE_ATOMIC_O_TRUNC)
+				fc->atomic_o_trunc = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;
@@ -570,7 +572,8 @@ static void fuse_send_init(struct fuse_c
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

fuse-convert-to-new-aops.patch
uml-remove-unnecessary-hostfs_getattr.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
vfs-check-nanoseconds-in-utimensat.patch
fix-execute-checking-in-permission.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
clean-out-unused-code-in-dentry-pruning.patch
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
fuse-update-backing_dev_info-congestion-state.patch
fuse-fix-reserved-request-wake-up.patch
fuse-add-reference-counting-to-fuse_file.patch
fuse-truncate-on-spontaneous-size-change.patch
fuse-fix-page-invalidation.patch
fuse-set-i_nlink-to-sane-value-after-mount.patch
fuse-refresh-stale-attributes-in-fuse_permission.patch
fuse-fix-permission-checking-on-sticky-directories.patch
fuse-fix-permission-checking-on-sticky-directories-fix.patch
fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-bits.patch
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
fuse-clean-up-execute-permission-checking.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
fuse-fix-allowing-operations.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
fuse-clean-up-open-file-passing-in-setattr.patch
vfs-allow-filesystems-to-implement-atomic-opentruncate.patch
fuse-improve-utimes-support.patch
fuse-add-atomic-opentruncate-support.patch
fuse-support-bsd-locking-semantics.patch
fuse-add-list-of-writable-files-to-fuse_inode.patch
fuse-add-helper-for-asynchronous-writes.patch
fuse-add-support-for-mandatory-locking.patch
fuse-add-blksize-field-to-fuse_attr.patch
