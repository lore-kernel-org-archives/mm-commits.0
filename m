From: akpm@linux-foundation.org
Subject: + reiserfs-dont-call-vfs_rmdir.patch added to -mm tree
Date: Fri, 30 May 2008 17:13:05 -0700
Message-ID: <200805310013.m4V0D678018550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753434AbYEaANZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:13:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, jeffm@suse.de, viro@zeniv.linux.org.uk


The patch titled
     reiserfs: dont call vfs_rmdir
has been added to the -mm tree.  Its filename is
     reiserfs-dont-call-vfs_rmdir.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: dont call vfs_rmdir
From: Miklos Szeredi <mszeredi@suse.cz>

reiserfs_delete_xattrs() calls vfs_rmdir() to remove the private
directory associated with the extended attributes for an inode.
Replace with explicit call to reiserfs_rmdir().

The extended attribute files reside in a private directory, completely
inaccessible from userspace.  This means, that checking against mounts
on the dentry is not necessary.

The calls to may_delete() and security_inode_rmdir(), as performed by
vfs_rmdir() are also unecessary for this case.

Based on patch by Jeff Mahoney.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Jeff Mahoney <jeffm@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/namei.c         |    2 +-
 fs/reiserfs/xattr.c         |   22 +++++++++++++++++++++-
 include/linux/reiserfs_fs.h |    1 +
 3 files changed, 23 insertions(+), 2 deletions(-)

diff -puN fs/reiserfs/namei.c~reiserfs-dont-call-vfs_rmdir fs/reiserfs/namei.c
--- a/fs/reiserfs/namei.c~reiserfs-dont-call-vfs_rmdir
+++ a/fs/reiserfs/namei.c
@@ -850,7 +850,7 @@ static inline int reiserfs_empty_dir(str
 	return 1;
 }
 
-static int reiserfs_rmdir(struct inode *dir, struct dentry *dentry)
+int reiserfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int retval, err;
 	struct inode *inode;
diff -puN fs/reiserfs/xattr.c~reiserfs-dont-call-vfs_rmdir fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~reiserfs-dont-call-vfs_rmdir
+++ a/fs/reiserfs/xattr.c
@@ -35,6 +35,7 @@
 #include <linux/namei.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/quotaops.h>
 #include <linux/file.h>
 #include <linux/pagemap.h>
 #include <linux/xattr.h>
@@ -712,6 +713,25 @@ reiserfs_delete_xattrs_filler(void *buf,
 
 }
 
+static int xattr_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	int error;
+
+	DQUOT_INIT(dir);
+
+	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
+	dentry_unhash(dentry);
+	error = reiserfs_rmdir(dir, dentry);
+	if (!error)
+		dentry->d_inode->i_flags |= S_DEAD;
+	mutex_unlock(&dentry->d_inode->i_mutex);
+	if (!error)
+		d_delete(dentry);
+	dput(dentry);
+
+	return error;
+}
+
 /* This is called w/ inode->i_mutex downed */
 int reiserfs_delete_xattrs(struct inode *inode)
 {
@@ -746,7 +766,7 @@ int reiserfs_delete_xattrs(struct inode 
 	if (dir->d_inode->i_nlink <= 2) {
 		root = get_xa_root(inode->i_sb, XATTR_REPLACE);
 		reiserfs_write_lock_xattrs(inode->i_sb);
-		err = vfs_rmdir(root->d_inode, dir);
+		err = xattr_rmdir(root->d_inode, dir);
 		reiserfs_write_unlock_xattrs(inode->i_sb);
 		dput(root);
 	} else {
diff -puN include/linux/reiserfs_fs.h~reiserfs-dont-call-vfs_rmdir include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~reiserfs-dont-call-vfs_rmdir
+++ a/include/linux/reiserfs_fs.h
@@ -1911,6 +1911,7 @@ static inline void reiserfs_update_sd(st
 void sd_attrs_to_i_attrs(__u16 sd_attrs, struct inode *inode);
 void i_attrs_to_sd_attrs(struct inode *inode, __u16 * sd_attrs);
 int reiserfs_setattr(struct dentry *dentry, struct iattr *attr);
+int reiserfs_rmdir(struct inode *dir, struct dentry *dentry);
 
 /* namei.c */
 void set_de_name_and_namelen(struct reiserfs_dir_entry *de);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

git-unprivileged-mounts.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch
nfsd-clean-up-mnt_want_write-calls.patch
cgroup-dont-call-vfs_mkdir.patch
reiserfs-dont-call-vfs_rmdir.patch
reiserfs-dont-call-notify_change.patch
sysfs-dont-call-notify_change.patch
hpfs-dont-call-notify_change.patch
fat-dont-call-notify_change.patch
hpfs-dont-call-permission.patch
hppfs-remove-hppfs_permission.patch
gfs2-dont-call-permission.patch
vfs-immutable-inode-checking-cleanup.patch
vfs-truncate-dont-check-immutable-twice.patch
vfs-create-file_truncate-helper.patch
vfs-utimes-immutable-fix.patch
vfs-utimes-cleanup.patch
vfs-dcache-cleanups.patch
vfs-fix-sys_getcwd-for-detached-mounts.patch

