From: akpm@linux-foundation.org
Subject: - unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:49:52 -0700
Message-ID: <200710212349.l9LNnqo6000778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60687 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbXJUXuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     unprivileged mounts: fix subtype handling
has been removed from the -mm tree.  Its filename was
     unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling.patch

This patch was dropped because it was folded into unprivileged-mounts-allow-unprivileged-mounts.patch

------------------------------------------------------
Subject: unprivileged mounts: fix subtype handling
From: Miklos Szeredi <mszeredi@suse.cz>

Subtype handling was done in do_kern_mount(), but "unprivileged mounts: allow
unprivileged mounts" patch made do_new_mount() use vfs_kern_mount().  This
broke the filesystem subtype handling.

Fix this by moving the subtype handling from do_kern_mount() into
do_new_mount().  All other callers are kernel-internal and do not need subtype
support.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   26 ++++++++++++++++++++++++++
 fs/super.c     |   26 --------------------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff -puN fs/namespace.c~unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling fs/namespace.c
--- a/fs/namespace.c~unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling
+++ a/fs/namespace.c
@@ -1186,6 +1186,29 @@ out:
 	return err;
 }
 
+static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
+{
+	int err;
+	const char *subtype = strchr(fstype, '.');
+	if (subtype) {
+		subtype++;
+		err = -EINVAL;
+		if (!subtype[0])
+			goto err;
+	} else
+		subtype = "";
+
+	mnt->mnt_sb->s_subtype = kstrdup(subtype, GFP_KERNEL);
+	err = -ENOMEM;
+	if (!mnt->mnt_sb->s_subtype)
+		goto err;
+	return mnt;
+
+ err:
+	mntput(mnt);
+	return ERR_PTR(err);
+}
+
 /*
  * create a new mount for userspace and request it to be added into the
  * namespace's tree
@@ -1215,6 +1238,9 @@ static int do_new_mount(struct nameidata
 	}
 
 	mnt = vfs_kern_mount(type, flags & ~MS_SETUSER, name, data);
+	if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE) &&
+	    !mnt->mnt_sb->s_subtype)
+		mnt = fs_set_subtype(mnt, fstype);
 	put_filesystem(type);
 	if (IS_ERR(mnt)) {
 		if (flags & MS_SETUSER)
diff -puN fs/super.c~unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling fs/super.c
--- a/fs/super.c~unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling
+++ a/fs/super.c
@@ -906,29 +906,6 @@ out:
 
 EXPORT_SYMBOL_GPL(vfs_kern_mount);
 
-static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
-{
-	int err;
-	const char *subtype = strchr(fstype, '.');
-	if (subtype) {
-		subtype++;
-		err = -EINVAL;
-		if (!subtype[0])
-			goto err;
-	} else
-		subtype = "";
-
-	mnt->mnt_sb->s_subtype = kstrdup(subtype, GFP_KERNEL);
-	err = -ENOMEM;
-	if (!mnt->mnt_sb->s_subtype)
-		goto err;
-	return mnt;
-
- err:
-	mntput(mnt);
-	return ERR_PTR(err);
-}
-
 struct vfsmount *
 do_kern_mount(const char *fstype, int flags, const char *name, void *data)
 {
@@ -937,9 +914,6 @@ do_kern_mount(const char *fstype, int fl
 	if (!type)
 		return ERR_PTR(-ENODEV);
 	mnt = vfs_kern_mount(type, flags, name, data);
-	if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE) &&
-	    !mnt->mnt_sb->s_subtype)
-		mnt = fs_set_subtype(mnt, fstype);
 	put_filesystem(type);
 	return mnt;
 }
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch
unprivileged-mounts-add-no-submounts-flag.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
