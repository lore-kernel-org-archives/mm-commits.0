From: akpm@linux-foundation.org
Subject: - fuse-fix-allowing-operations.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:42 -0700
Message-ID: <200710190345.l9J3jgvL013242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbXJSDzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: fix allowing operations
has been removed from the -mm tree.  Its filename was
     fuse-fix-allowing-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: fix allowing operations
From: Miklos Szeredi <mszeredi@suse.cz>

The following operation didn't check if sending the request was allowed:

  setattr
  listxattr
  statfs

Some other operations don't explicitly do the check, but VFS calls
->permission() which checks this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c    |    8 +++++++-
 fs/fuse/fuse_i.h |    5 +++++
 fs/fuse/inode.c  |    5 +++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff -puN fs/fuse/dir.c~fuse-fix-allowing-operations fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-fix-allowing-operations
+++ a/fs/fuse/dir.c
@@ -721,7 +721,7 @@ static int fuse_refresh_attributes(struc
  * for which the owner of the mount has ptrace privilege.  This
  * excludes processes started by other users, suid or sgid processes.
  */
-static int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task)
+int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task)
 {
 	if (fc->flags & FUSE_ALLOW_OTHER)
 		return 1;
@@ -1005,6 +1005,9 @@ static int fuse_setattr(struct dentry *e
 	struct fuse_attr_out outarg;
 	int err;
 
+	if (!fuse_allow_task(fc, current))
+		return -EACCES;
+
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
 		err = inode_change_ok(inode, attr);
 		if (err)
@@ -1172,6 +1175,9 @@ static ssize_t fuse_listxattr(struct den
 	struct fuse_getxattr_out outarg;
 	ssize_t ret;
 
+	if (!fuse_allow_task(fc, current))
+		return -EACCES;
+
 	if (fc->no_listxattr)
 		return -EOPNOTSUPP;
 
diff -puN fs/fuse/fuse_i.h~fuse-fix-allowing-operations fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-fix-allowing-operations
+++ a/fs/fuse/fuse_i.h
@@ -565,3 +565,8 @@ void fuse_ctl_remove_conn(struct fuse_co
  * Is file type valid?
  */
 int fuse_valid_type(int m);
+
+/**
+ * Is task allowed to perform filesystem operation?
+ */
+int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task);
diff -puN fs/fuse/inode.c~fuse-fix-allowing-operations fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-allowing-operations
+++ a/fs/fuse/inode.c
@@ -287,6 +287,11 @@ static int fuse_statfs(struct dentry *de
 	struct fuse_statfs_out outarg;
 	int err;
 
+	if (!fuse_allow_task(fc, current)) {
+		buf->f_type = FUSE_SUPER_MAGIC;
+		return 0;
+	}
+
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
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
