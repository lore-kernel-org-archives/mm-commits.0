From: akpm@linux-foundation.org
Subject: - partially-fix-up-the-lookup_one_noperm-mess.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:50:58 -0700
Message-ID: <200710180650.l9I6owph030130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33016 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757180AbXJRGvx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:51:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, jsipek@cs.sunysb.edu, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     partially fix up the lookup_one_noperm mess
has been removed from the -mm tree.  Its filename was
     partially-fix-up-the-lookup_one_noperm-mess.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: partially fix up the lookup_one_noperm mess
From: Christoph Hellwig <hch@lst.de>

Try to fix the mess created by sysfs braindamage.

 - refactor code internal to fs/namei.c a little to avoid too much
   duplication:
	o __lookup_hash_kern is renamed back to __lookup_hash
	o the old __lookup_hash goes away, permission checks moves to
	  the two callers
	o useless inline qualifiers on above functions go away
 - lookup_one_len_kern loses it's last argument and is renamed to
   lookup_one_noperm to make it's useage a little more clear
 - added kerneldoc comments to describe lookup_one_len aswell as
   lookup_one_noperm and make it very clear that no one should use
   the latter ever.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c            |   58 ++++++++++++++++++++++++----------------
 fs/sysfs/dir.c        |    3 --
 include/linux/namei.h |    4 +-
 3 files changed, 39 insertions(+), 26 deletions(-)

diff -puN fs/namei.c~partially-fix-up-the-lookup_one_noperm-mess fs/namei.c
--- a/fs/namei.c~partially-fix-up-the-lookup_one_noperm-mess
+++ a/fs/namei.c
@@ -1273,7 +1273,8 @@ int __user_path_lookup_open(const char _
 	return err;
 }
 
-static inline struct dentry *__lookup_hash_kern(struct qstr *name, struct dentry *base, struct nameidata *nd)
+static struct dentry *__lookup_hash(struct qstr *name,
+		struct dentry *base, struct nameidata *nd)
 {
 	struct dentry *dentry;
 	struct inode *inode;
@@ -1313,31 +1314,18 @@ out:
  * needs parent already locked. Doesn't follow mounts.
  * SMP-safe.
  */
-static inline struct dentry * __lookup_hash(struct qstr *name, struct dentry *base, struct nameidata *nd)
+static struct dentry *lookup_hash(struct nameidata *nd)
 {
-	struct dentry *dentry;
-	struct inode *inode;
 	int err;
 
-	inode = base->d_inode;
-
-	err = permission(inode, MAY_EXEC, nd);
-	dentry = ERR_PTR(err);
+	err = permission(nd->dentry->d_inode, MAY_EXEC, nd);
 	if (err)
-		goto out;
-
-	dentry = __lookup_hash_kern(name, base, nd);
-out:
-	return dentry;
-}
-
-static struct dentry *lookup_hash(struct nameidata *nd)
-{
+		return ERR_PTR(err);
 	return __lookup_hash(&nd->last, nd->dentry, nd);
 }
 
-/* SMP-safe */
-static inline int __lookup_one_len(const char *name, struct qstr *this, struct dentry *base, int len)
+static int __lookup_one_len(const char *name, struct qstr *this,
+		struct dentry *base, int len)
 {
 	unsigned long hash;
 	unsigned int c;
@@ -1358,6 +1346,17 @@ static inline int __lookup_one_len(const
 	return 0;
 }
 
+/**
+ * lookup_one_len:  filesystem helper to lookup single pathname component
+ * @name:	pathname component to lookup
+ * @base:	base directory to lookup from
+ * @len:	maximum length @len should be interpreted to
+ *
+ * Note that this routine is purely a helper for filesystem useage and should
+ * not be called by generic code.  Also note that by using this function to
+ * nameidata argument is passed to the filesystem methods and a filesystem
+ * using this helper needs to be prepared for that.
+ */
 struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
 {
 	int err;
@@ -1366,18 +1365,33 @@ struct dentry *lookup_one_len(const char
 	err = __lookup_one_len(name, &this, base, len);
 	if (err)
 		return ERR_PTR(err);
+
+	err = permission(base->d_inode, MAY_EXEC, NULL);
+	if (err)
+		return ERR_PTR(err);
 	return __lookup_hash(&this, base, NULL);
 }
 
-struct dentry *lookup_one_len_kern(const char *name, struct dentry *base, int len)
+/**
+ * lookup_one_noperm - bad hack for sysfs
+ * @name:	pathname component to lookup
+ * @base:	base directory to lookup from
+ *
+ * This is a variant of lookup_one_len that doesn't perform any permission
+ * checks.   It's a horrible hack to work around the braindead sysfs
+ * architecture and should not be used anywhere else.
+ *
+ * DON'T USE THIS FUNCTION EVER, thanks.
+ */
+struct dentry *lookup_one_noperm(const char *name, struct dentry *base)
 {
 	int err;
 	struct qstr this;
 
-	err = __lookup_one_len(name, &this, base, len);
+	err = __lookup_one_len(name, &this, base, strlen(name));
 	if (err)
 		return ERR_PTR(err);
-	return __lookup_hash_kern(&this, base, NULL);
+	return __lookup_hash(&this, base, NULL);
 }
 
 int fastcall __user_walk_fd(int dfd, const char __user *name, unsigned flags,
diff -puN fs/sysfs/dir.c~partially-fix-up-the-lookup_one_noperm-mess fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~partially-fix-up-the-lookup_one_noperm-mess
+++ a/fs/sysfs/dir.c
@@ -112,8 +112,7 @@ struct dentry *sysfs_get_dentry(struct s
 		/* look it up */
 		parent = dentry;
 		mutex_lock(&parent->d_inode->i_mutex);
-		dentry = lookup_one_len_kern(cur->s_name, parent,
-					     strlen(cur->s_name));
+		dentry = lookup_one_noperm(cur->s_name, parent);
 		mutex_unlock(&parent->d_inode->i_mutex);
 		dput(parent);
 
diff -puN include/linux/namei.h~partially-fix-up-the-lookup_one_noperm-mess include/linux/namei.h
--- a/include/linux/namei.h~partially-fix-up-the-lookup_one_noperm-mess
+++ a/include/linux/namei.h
@@ -81,8 +81,8 @@ extern struct file *lookup_instantiate_f
 extern struct file *nameidata_to_filp(struct nameidata *nd, int flags);
 extern void release_open_intent(struct nameidata *);
 
-extern struct dentry * lookup_one_len(const char *, struct dentry *, int);
-extern struct dentry *lookup_one_len_kern(const char *, struct dentry *, int);
+extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
+extern struct dentry *lookup_one_noperm(const char *, struct dentry *);
 
 extern int follow_down(struct vfsmount **, struct dentry **);
 extern int follow_up(struct vfsmount **, struct dentry **);
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
dcache-dont-expose-uninitialized-memory-in.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
reiserfs-fix-up-lockdep-warnings.patch
reiserfs-fix-up-lockdep-warnings-checkpatch-fixes.patch
reiserfs-dont-use-bug-when-panicking.patch
reiserfs-use-is_reusable-to-catch-corruption.patch
reiserfs-use-is_reusable-to-catch-corruption-checkpatch-fixes.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes.patch
reiserfs-fix-memset-byte-count-during-resize.patch
reiserfs-remove-first_zero_hint.patch
reiserfs-remove-first_zero_hint-checkpatch-fixes.patch
reiserfs-ignore-on-disk-s_bmap_nr-value.patch
reiserfs-ignore-on-disk-s_bmap_nr-value-checkpatch-fixes.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set.patch
reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change.patch
cifs-ignore-mode-change-if-its-just-for-clearing-setuid-setgid-bits.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes-touch-command-causes-oops.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
ext2-new-export-ops.patch
ext3-new-export-ops.patch
ext4-new-export-ops.patch
efs-new-export-ops.patch
jfs-new-export-ops.patch
ntfs-new-export-ops.patch
fat-new-export-ops.patch
isofs-new-export-ops.patch
shmem-new-export-ops.patch
reiserfs-new-export-ops.patch
gfs2-new-export-ops.patch
ocfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
vfs-allow-filesystems-to-implement-atomic-opentruncate.patch
