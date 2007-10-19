From: akpm@linux-foundation.org
Subject: - fuse-support-bsd-locking-semantics.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:57 -0700
Message-ID: <200710190345.l9J3jvQh013263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59648 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763948AbXJSDzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: support BSD locking semantics
has been removed from the -mm tree.  Its filename was
     fuse-support-bsd-locking-semantics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: support BSD locking semantics
From: Miklos Szeredi <mszeredi@suse.cz>

It is trivial to add support for flock(2) semantics to the existing protocol,
by setting the lock owner field to the file pointer, and passing a new
FUSE_LK_FLOCK flag with the locking request.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c       |   32 +++++++++++++++++++++++++++-----
 include/linux/fuse.h |    8 ++++++++
 2 files changed, 35 insertions(+), 5 deletions(-)

diff -puN fs/fuse/file.c~fuse-support-bsd-locking-semantics fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-support-bsd-locking-semantics
+++ a/fs/fuse/file.c
@@ -699,7 +699,8 @@ static int convert_fuse_file_lock(const 
 }
 
 static void fuse_lk_fill(struct fuse_req *req, struct file *file,
-			 const struct file_lock *fl, int opcode, pid_t pid)
+			 const struct file_lock *fl, int opcode, pid_t pid,
+			 int flock)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -712,6 +713,8 @@ static void fuse_lk_fill(struct fuse_req
 	arg->lk.end = fl->fl_end;
 	arg->lk.type = fl->fl_type;
 	arg->lk.pid = pid;
+	if (flock)
+		arg->lk_flags |= FUSE_LK_FLOCK;
 	req->in.h.opcode = opcode;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.numargs = 1;
@@ -731,7 +734,7 @@ static int fuse_getlk(struct file *file,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	fuse_lk_fill(req, file, fl, FUSE_GETLK, 0);
+	fuse_lk_fill(req, file, fl, FUSE_GETLK, 0, 0);
 	req->out.numargs = 1;
 	req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
@@ -744,7 +747,7 @@ static int fuse_getlk(struct file *file,
 	return err;
 }
 
-static int fuse_setlk(struct file *file, struct file_lock *fl)
+static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -761,7 +764,7 @@ static int fuse_setlk(struct file *file,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	fuse_lk_fill(req, file, fl, opcode, pid);
+	fuse_lk_fill(req, file, fl, opcode, pid, flock);
 	request_send(fc, req);
 	err = req->out.h.error;
 	/* locking is restartable */
@@ -787,11 +790,28 @@ static int fuse_file_lock(struct file *f
 		if (fc->no_lock)
 			err = posix_lock_file_wait(file, fl);
 		else
-			err = fuse_setlk(file, fl);
+			err = fuse_setlk(file, fl, 0);
 	}
 	return err;
 }
 
+static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	int err;
+
+	if (fc->no_lock) {
+		err = flock_lock_file_wait(file, fl);
+	} else {
+		/* emulate flock with POSIX locks */
+		fl->fl_owner = (fl_owner_t) file;
+		err = fuse_setlk(file, fl, 1);
+	}
+
+	return err;
+}
+
 static sector_t fuse_bmap(struct address_space *mapping, sector_t block)
 {
 	struct inode *inode = mapping->host;
@@ -840,6 +860,7 @@ static const struct file_operations fuse
 	.release	= fuse_release,
 	.fsync		= fuse_fsync,
 	.lock		= fuse_file_lock,
+	.flock		= fuse_file_flock,
 	.splice_read	= generic_file_splice_read,
 };
 
@@ -852,6 +873,7 @@ static const struct file_operations fuse
 	.release	= fuse_release,
 	.fsync		= fuse_fsync,
 	.lock		= fuse_file_lock,
+	.flock		= fuse_file_flock,
 	/* no mmap and splice_read */
 };
 
diff -puN include/linux/fuse.h~fuse-support-bsd-locking-semantics include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-support-bsd-locking-semantics
+++ a/include/linux/fuse.h
@@ -13,6 +13,7 @@
  *
  * 7.9:
  *  - new fuse_getattr_in input argument of GETATTR
+ *  - add lk_flags in fuse_lk_in
  */
 
 #include <asm/types.h>
@@ -113,6 +114,11 @@ struct fuse_file_lock {
  */
 #define FUSE_GETATTR_FH		(1 << 0)
 
+/**
+ * Lock flags
+ */
+#define FUSE_LK_FLOCK		(1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
 	FUSE_FORGET	   = 2,  /* no reply */
@@ -295,6 +301,8 @@ struct fuse_lk_in {
 	__u64	fh;
 	__u64	owner;
 	struct fuse_file_lock lk;
+	__u32	lk_flags;
+	__u32	padding;
 };
 
 struct fuse_lk_out {
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
