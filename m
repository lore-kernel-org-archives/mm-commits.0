From: akpm@linux-foundation.org
Subject: - fuse-add-blksize-field-to-fuse_attr.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:46:05 -0700
Message-ID: <200710190346.l9J3k5FV013281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49047 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763967AbXJSDzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: add blksize field to fuse_attr
has been removed from the -mm tree.  Its filename was
     fuse-add-blksize-field-to-fuse_attr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: add blksize field to fuse_attr
From: Miklos Szeredi <mszeredi@suse.cz>

There are cases when the filesystem will be passed the buffer from a single
read or write call, namely:

 1) in 'direct-io' mode (not O_DIRECT), read/write requests don't go
    through the page cache, but go directly to the userspace fs

 2) currently buffered writes are done with single page requests, but
    if Nick's ->perform_write() patch goes it, it will be possible to
    do larger write requests.  But only if the original write() was
    also bigger than a page.

In these cases the filesystem might want to give a hint to the app
about the optimal I/O size.

Allow the userspace filesystem to supply a blksize value to be returned by
stat() and friends.  If the field is zero, it defaults to the old
PAGE_CACHE_SIZE value.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c        |   32 +++++++++++++++++++++++++++-----
 fs/fuse/inode.c      |    5 +++++
 include/linux/fuse.h |    7 +++++++
 3 files changed, 39 insertions(+), 5 deletions(-)

diff -puN fs/fuse/dir.c~fuse-add-blksize-field-to-fuse_attr fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-add-blksize-field-to-fuse_attr
+++ a/fs/fuse/dir.c
@@ -116,13 +116,19 @@ static void fuse_lookup_init(struct fuse
 			     struct dentry *entry,
 			     struct fuse_entry_out *outarg)
 {
+	struct fuse_conn *fc = get_fuse_conn(dir);
+
+	memset(outarg, 0, sizeof(struct fuse_entry_out));
 	req->in.h.opcode = FUSE_LOOKUP;
 	req->in.h.nodeid = get_node_id(dir);
 	req->in.numargs = 1;
 	req->in.args[0].size = entry->d_name.len + 1;
 	req->in.args[0].value = entry->d_name.name;
 	req->out.numargs = 1;
-	req->out.args[0].size = sizeof(struct fuse_entry_out);
+	if (fc->minor < 9)
+		req->out.args[0].size = FUSE_COMPAT_ENTRY_OUT_SIZE;
+	else
+		req->out.args[0].size = sizeof(struct fuse_entry_out);
 	req->out.args[0].value = outarg;
 }
 
@@ -356,6 +362,7 @@ static int fuse_create_open(struct inode
 
 	flags &= ~O_NOCTTY;
 	memset(&inarg, 0, sizeof(inarg));
+	memset(&outentry, 0, sizeof(outentry));
 	inarg.flags = flags;
 	inarg.mode = mode;
 	req->in.h.opcode = FUSE_CREATE;
@@ -366,7 +373,10 @@ static int fuse_create_open(struct inode
 	req->in.args[1].size = entry->d_name.len + 1;
 	req->in.args[1].value = entry->d_name.name;
 	req->out.numargs = 2;
-	req->out.args[0].size = sizeof(outentry);
+	if (fc->minor < 9)
+		req->out.args[0].size = FUSE_COMPAT_ENTRY_OUT_SIZE;
+	else
+		req->out.args[0].size = sizeof(outentry);
 	req->out.args[0].value = &outentry;
 	req->out.args[1].size = sizeof(outopen);
 	req->out.args[1].value = &outopen;
@@ -431,9 +441,13 @@ static int create_new_entry(struct fuse_
 		return PTR_ERR(forget_req);
 	}
 
+	memset(&outarg, 0, sizeof(outarg));
 	req->in.h.nodeid = get_node_id(dir);
 	req->out.numargs = 1;
-	req->out.args[0].size = sizeof(outarg);
+	if (fc->minor < 9)
+		req->out.args[0].size = FUSE_COMPAT_ENTRY_OUT_SIZE;
+	else
+		req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
 	request_send(fc, req);
 	err = req->out.h.error;
@@ -724,6 +738,7 @@ static int fuse_do_getattr(struct inode 
 	spin_unlock(&fc->lock);
 
 	memset(&inarg, 0, sizeof(inarg));
+	memset(&outarg, 0, sizeof(outarg));
 	/* Directories have separate file-handle space */
 	if (file && S_ISREG(inode->i_mode)) {
 		struct fuse_file *ff = file->private_data;
@@ -737,7 +752,10 @@ static int fuse_do_getattr(struct inode 
 	req->in.args[0].size = sizeof(inarg);
 	req->in.args[0].value = &inarg;
 	req->out.numargs = 1;
-	req->out.args[0].size = sizeof(outarg);
+	if (fc->minor < 9)
+		req->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
+	else
+		req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
 	request_send(fc, req);
 	err = req->out.h.error;
@@ -1102,6 +1120,7 @@ static int fuse_do_setattr(struct dentry
 		return PTR_ERR(req);
 
 	memset(&inarg, 0, sizeof(inarg));
+	memset(&outarg, 0, sizeof(outarg));
 	iattr_to_fattr(attr, &inarg);
 	if (file) {
 		struct fuse_file *ff = file->private_data;
@@ -1119,7 +1138,10 @@ static int fuse_do_setattr(struct dentry
 	req->in.args[0].size = sizeof(inarg);
 	req->in.args[0].value = &inarg;
 	req->out.numargs = 1;
-	req->out.args[0].size = sizeof(outarg);
+	if (fc->minor < 9)
+		req->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
+	else
+		req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
 	request_send(fc, req);
 	err = req->out.h.error;
diff -puN fs/fuse/inode.c~fuse-add-blksize-field-to-fuse_attr fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-add-blksize-field-to-fuse_attr
+++ a/fs/fuse/inode.c
@@ -148,6 +148,11 @@ void fuse_change_attributes(struct inode
 	inode->i_ctime.tv_sec   = attr->ctime;
 	inode->i_ctime.tv_nsec  = attr->ctimensec;
 
+	if (attr->blksize != 0)
+		inode->i_blkbits = ilog2(attr->blksize);
+	else
+		inode->i_blkbits = inode->i_sb->s_blocksize_bits;
+
 	/*
 	 * Don't set the sticky bit in i_mode, unless we want the VFS
 	 * to check permissions.  This prevents failures due to the
diff -puN include/linux/fuse.h~fuse-add-blksize-field-to-fuse_attr include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-add-blksize-field-to-fuse_attr
+++ a/include/linux/fuse.h
@@ -15,6 +15,7 @@
  *  - new fuse_getattr_in input argument of GETATTR
  *  - add lk_flags in fuse_lk_in
  *  - add lock_owner field to fuse_setattr_in, fuse_read_in and fuse_write_in
+ *  - add blksize field to fuse_attr
  */
 
 #include <asm/types.h>
@@ -53,6 +54,8 @@ struct fuse_attr {
 	__u32	uid;
 	__u32	gid;
 	__u32	rdev;
+	__u32	blksize;
+	__u32	padding;
 };
 
 struct fuse_kstatfs {
@@ -177,6 +180,8 @@ enum fuse_opcode {
 /* The read buffer is required to be at least 8k, but may be much larger */
 #define FUSE_MIN_READ_BUFFER 8192
 
+#define FUSE_COMPAT_ENTRY_OUT_SIZE 120
+
 struct fuse_entry_out {
 	__u64	nodeid;		/* Inode ID */
 	__u64	generation;	/* Inode generation: nodeid:gen must
@@ -198,6 +203,8 @@ struct fuse_getattr_in {
 	__u64	fh;
 };
 
+#define FUSE_COMPAT_ATTR_OUT_SIZE 96
+
 struct fuse_attr_out {
 	__u64	attr_valid;	/* Cache timeout for the attributes */
 	__u32	attr_valid_nsec;
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
