From: akpm@linux-foundation.org
Subject: + fuse-add-support-for-mandatory-locking.patch added to -mm tree
Date: Thu, 04 Oct 2007 15:57:21 -0700
Message-ID: <200710042257.l94MvLlR032756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49577 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760854AbXJDW52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 18:57:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: add support for mandatory locking
has been added to the -mm tree.  Its filename is
     fuse-add-support-for-mandatory-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: add support for mandatory locking
From: Miklos Szeredi <mszeredi@suse.cz>

For mandatory locking the userspace filesystem needs to know the lock
ownership for read, write and truncate operations.

This patch adds the necessary fields to the protocol.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/fuse/dir.c~fuse-add-support-for-mandatory-locking fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-add-support-for-mandatory-locking
+++ a/fs/fuse/dir.c
@@ -1108,6 +1108,11 @@ static int fuse_do_setattr(struct dentry
 		inarg.valid |= FATTR_FH;
 		inarg.fh = ff->fh;
 	}
+	if (attr->ia_valid & ATTR_SIZE) {
+		/* For mandatory locking in truncate */
+		inarg.valid |= FATTR_LOCKOWNER;
+		inarg.lock_owner = fuse_lock_owner_id(fc, current->files);
+	}
 	req->in.h.opcode = FUSE_SETATTR;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.numargs = 1;
diff -puN fs/fuse/file.c~fuse-add-support-for-mandatory-locking fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-add-support-for-mandatory-locking
+++ a/fs/fuse/file.c
@@ -189,7 +189,7 @@ static int fuse_release(struct inode *in
  * Scramble the ID space with XTEA, so that the value of the files_struct
  * pointer is not exposed to userspace.
  */
-static u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id)
+u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id)
 {
 	u32 *k = fc->scramble_key;
 	u64 v = (unsigned long) id;
@@ -308,11 +308,19 @@ void fuse_read_fill(struct fuse_req *req
 }
 
 static size_t fuse_send_read(struct fuse_req *req, struct file *file,
-			     struct inode *inode, loff_t pos, size_t count)
+			     struct inode *inode, loff_t pos, size_t count,
+			     fl_owner_t owner)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_file *ff = file->private_data;
+
 	fuse_read_fill(req, ff, inode, pos, count, FUSE_READ);
+	if (owner != NULL) {
+		struct fuse_read_in *inarg = &req->misc.read_in;
+
+		inarg->read_flags |= FUSE_READ_LOCKOWNER;
+		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
+	}
 	request_send(fc, req);
 	return req->out.args[0].size;
 }
@@ -336,7 +344,8 @@ static int fuse_readpage(struct file *fi
 	req->out.page_zeroing = 1;
 	req->num_pages = 1;
 	req->pages[0] = page;
-	fuse_send_read(req, file, inode, page_offset(page), PAGE_CACHE_SIZE);
+	fuse_send_read(req, file, inode, page_offset(page), PAGE_CACHE_SIZE,
+		       NULL);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err)
@@ -447,6 +456,7 @@ static void fuse_write_fill(struct fuse_
 			    struct inode *inode, loff_t pos, size_t count,
 			    int writepage)
 {
+	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_write_in *inarg = &req->misc.write.in;
 	struct fuse_write_out *outarg = &req->misc.write.out;
 
@@ -459,7 +469,10 @@ static void fuse_write_fill(struct fuse_
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.argpages = 1;
 	req->in.numargs = 2;
-	req->in.args[0].size = sizeof(struct fuse_write_in);
+	if (fc->minor < 9)
+		req->in.args[0].size = FUSE_COMPAT_WRITE_IN_SIZE;
+	else
+		req->in.args[0].size = sizeof(struct fuse_write_in);
 	req->in.args[0].value = inarg;
 	req->in.args[1].size = count;
 	req->out.numargs = 1;
@@ -468,10 +481,16 @@ static void fuse_write_fill(struct fuse_
 }
 
 static size_t fuse_send_write(struct fuse_req *req, struct file *file,
-			      struct inode *inode, loff_t pos, size_t count)
+			      struct inode *inode, loff_t pos, size_t count,
+			      fl_owner_t owner)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	fuse_write_fill(req, file->private_data, inode, pos, count, 0);
+	if (owner != NULL) {
+		struct fuse_write_in *inarg = &req->misc.write.in;
+		inarg->write_flags |= FUSE_WRITE_LOCKOWNER;
+		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
+	}
 	request_send(fc, req);
 	return req->misc.write.out.size;
 }
@@ -508,7 +527,7 @@ static int fuse_buffered_write(struct fi
 	req->num_pages = 1;
 	req->pages[0] = page;
 	req->page_offset = offset;
-	nres = fuse_send_write(req, file, inode, pos, count);
+	nres = fuse_send_write(req, file, inode, pos, count, NULL);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err && !nres)
@@ -609,9 +628,11 @@ static ssize_t fuse_direct_io(struct fil
 		nbytes = (req->num_pages << PAGE_SHIFT) - req->page_offset;
 		nbytes = min(count, nbytes);
 		if (write)
-			nres = fuse_send_write(req, file, inode, pos, nbytes);
+			nres = fuse_send_write(req, file, inode, pos, nbytes,
+					       current->files);
 		else
-			nres = fuse_send_read(req, file, inode, pos, nbytes);
+			nres = fuse_send_read(req, file, inode, pos, nbytes,
+					      current->files);
 		fuse_release_user_pages(req, !write);
 		if (req->out.h.error) {
 			if (!res)
diff -puN fs/fuse/fuse_i.h~fuse-add-support-for-mandatory-locking fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-add-support-for-mandatory-locking
+++ a/fs/fuse/fuse_i.h
@@ -591,3 +591,5 @@ int fuse_valid_type(int m);
  * Is task allowed to perform filesystem operation?
  */
 int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task);
+
+u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id);
diff -puN include/linux/fuse.h~fuse-add-support-for-mandatory-locking include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-add-support-for-mandatory-locking
+++ a/include/linux/fuse.h
@@ -14,6 +14,7 @@
  * 7.9:
  *  - new fuse_getattr_in input argument of GETATTR
  *  - add lk_flags in fuse_lk_in
+ *  - add lock_owner field to fuse_setattr_in, fuse_read_in and fuse_write_in
  */
 
 #include <asm/types.h>
@@ -86,6 +87,7 @@ struct fuse_file_lock {
 #define FATTR_FH	(1 << 6)
 #define FATTR_ATIME_NOW	(1 << 7)
 #define FATTR_MTIME_NOW	(1 << 8)
+#define FATTR_LOCKOWNER	(1 << 9)
 
 /**
  * Flags returned by the OPEN request
@@ -123,8 +125,15 @@ struct fuse_file_lock {
  * WRITE flags
  *
  * FUSE_WRITE_CACHE: delayed write from page cache, file handle is guessed
+ * FUSE_WRITE_LOCKOWNER: lock_owner field is valid
  */
 #define FUSE_WRITE_CACHE	(1 << 0)
+#define FUSE_WRITE_LOCKOWNER	(1 << 1)
+
+/**
+ * Read flags
+ */
+#define FUSE_READ_LOCKOWNER	(1 << 1)
 
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
@@ -219,7 +228,7 @@ struct fuse_setattr_in {
 	__u32	padding;
 	__u64	fh;
 	__u64	size;
-	__u64	unused1;
+	__u64	lock_owner;
 	__u64	atime;
 	__u64	mtime;
 	__u64	unused2;
@@ -262,14 +271,18 @@ struct fuse_read_in {
 	__u64	fh;
 	__u64	offset;
 	__u32	size;
-	__u32	padding;
+	__u32	read_flags;
+	__u64	lock_owner;
 };
 
+#define FUSE_COMPAT_WRITE_IN_SIZE 24
+
 struct fuse_write_in {
 	__u64	fh;
 	__u64	offset;
 	__u32	size;
 	__u32	write_flags;
+	__u64	lock_owner;
 };
 
 struct fuse_write_out {
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
