From: akpm@linux-foundation.org
Subject: + fuse-add-list-of-writable-files-to-fuse_inode.patch added to -mm tree
Date: Thu, 04 Oct 2007 15:57:15 -0700
Message-ID: <200710042257.l94MvFma032750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41053 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760853AbXJDW5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 18:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: add list of writable files to fuse_inode
has been added to the -mm tree.  Its filename is
     fuse-add-list-of-writable-files-to-fuse_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: add list of writable files to fuse_inode
From: Miklos Szeredi <mszeredi@suse.cz>

Each WRITE request must carry a valid file descriptor.  When a page is written
back from a memory mapping, the file through which the page was dirtied is not
available, so a new mechananism is needed to find a suitable file in
->writepage(s).

A list of fuse_files is added to fuse_inode.  The file is removed from the
list in fuse_release().

This patch is in preparation for writable mmap support.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/fuse/file.c~fuse-add-list-of-writable-files-to-fuse_inode fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-add-list-of-writable-files-to-fuse_inode
+++ a/fs/fuse/file.c
@@ -56,6 +56,7 @@ struct fuse_file *fuse_file_alloc(void)
 			kfree(ff);
 			ff = NULL;
 		}
+		INIT_LIST_HEAD(&ff->write_entry);
 		atomic_set(&ff->count, 0);
 	}
 	return ff;
@@ -150,12 +151,18 @@ int fuse_release_common(struct inode *in
 {
 	struct fuse_file *ff = file->private_data;
 	if (ff) {
+		struct fuse_conn *fc = get_fuse_conn(inode);
+
 		fuse_release_fill(ff, get_node_id(inode), file->f_flags,
 				  isdir ? FUSE_RELEASEDIR : FUSE_RELEASE);
 
 		/* Hold vfsmount and dentry until release is finished */
 		ff->reserved_req->vfsmount = mntget(file->f_path.mnt);
 		ff->reserved_req->dentry = dget(file->f_path.dentry);
+
+		spin_lock(&fc->lock);
+		list_del(&ff->write_entry);
+		spin_unlock(&fc->lock);
 		/*
 		 * Normally this will send the RELEASE request,
 		 * however if some asynchronous READ or WRITE requests
diff -puN fs/fuse/fuse_i.h~fuse-add-list-of-writable-files-to-fuse_inode fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-add-list-of-writable-files-to-fuse_inode
+++ a/fs/fuse/fuse_i.h
@@ -70,6 +70,9 @@ struct fuse_inode {
 
 	/** Version of last attribute change */
 	u64 attr_version;
+
+	/** Files usable in writepage.  Protected by fc->lock */
+	struct list_head write_files;
 };
 
 /** FUSE specific file data */
@@ -82,6 +85,9 @@ struct fuse_file {
 
 	/** Refcount */
 	atomic_t count;
+
+	/** Entry on inode's write_files list */
+	struct list_head write_entry;
 };
 
 /** One input argument of a request */
diff -puN fs/fuse/inode.c~fuse-add-list-of-writable-files-to-fuse_inode fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-add-list-of-writable-files-to-fuse_inode
+++ a/fs/fuse/inode.c
@@ -56,6 +56,7 @@ static struct inode *fuse_alloc_inode(st
 	fi->i_time = 0;
 	fi->nodeid = 0;
 	fi->nlookup = 0;
+	INIT_LIST_HEAD(&fi->write_files);
 	fi->forget_req = fuse_request_alloc();
 	if (!fi->forget_req) {
 		kmem_cache_free(fuse_inode_cachep, inode);
@@ -68,6 +69,7 @@ static struct inode *fuse_alloc_inode(st
 static void fuse_destroy_inode(struct inode *inode)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
+	BUG_ON(!list_empty(&fi->write_files));
 	if (fi->forget_req)
 		fuse_request_free(fi->forget_req);
 	kmem_cache_free(fuse_inode_cachep, inode);
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
