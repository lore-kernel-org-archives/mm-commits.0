From: akpm@linux-foundation.org
Subject: - fuse-clean-up-open-file-passing-in-setattr.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:49 -0700
Message-ID: <200710190345.l9J3jnb9013251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34385 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763907AbXJSDzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: clean up open file passing in setattr
has been removed from the -mm tree.  Its filename was
     fuse-clean-up-open-file-passing-in-setattr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: clean up open file passing in setattr
From: Miklos Szeredi <mszeredi@suse.cz>

Clean up supplying open file to the setattr operation.  In addition to being a
cleanup it prepares for the changes in the way the open file is passed to the
setattr method.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN fs/fuse/dir.c~fuse-clean-up-open-file-passing-in-setattr fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-clean-up-open-file-passing-in-setattr
+++ a/fs/fuse/dir.c
@@ -1032,11 +1032,6 @@ static void iattr_to_fattr(struct iattr 
 		arg->atime = iattr->ia_atime.tv_sec;
 		arg->mtime = iattr->ia_mtime.tv_sec;
 	}
-	if (ivalid & ATTR_FILE) {
-		struct fuse_file *ff = iattr->ia_file->private_data;
-		arg->valid |= FATTR_FH;
-		arg->fh = ff->fh;
-	}
 }
 
 /*
@@ -1047,7 +1042,8 @@ static void iattr_to_fattr(struct iattr 
  * vmtruncate() doesn't allow for this case, so do the rlimit checking
  * and the actual truncation by hand.
  */
-static int fuse_setattr(struct dentry *entry, struct iattr *attr)
+static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
+			   struct file *file)
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1082,6 +1078,11 @@ static int fuse_setattr(struct dentry *e
 
 	memset(&inarg, 0, sizeof(inarg));
 	iattr_to_fattr(attr, &inarg);
+	if (file) {
+		struct fuse_file *ff = file->private_data;
+		inarg.valid |= FATTR_FH;
+		inarg.fh = ff->fh;
+	}
 	req->in.h.opcode = FUSE_SETATTR;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.numargs = 1;
@@ -1108,6 +1109,14 @@ static int fuse_setattr(struct dentry *e
 	return 0;
 }
 
+static int fuse_setattr(struct dentry *entry, struct iattr *attr)
+{
+	if (attr->ia_valid & ATTR_FILE)
+		return fuse_do_setattr(entry, attr, attr->ia_file);
+	else
+		return fuse_do_setattr(entry, attr, NULL);
+}
+
 static int fuse_getattr(struct vfsmount *mnt, struct dentry *entry,
 			struct kstat *stat)
 {
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
