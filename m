From: akpm@linux-foundation.org
Subject: + gfs2-dont-call-permission.patch added to -mm tree
Date: Fri, 30 May 2008 17:13:20 -0700
Message-ID: <200805310013.m4V0DLFm018616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756583AbYEaANw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:13:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, swhiteho@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     gfs2: dont call permission()
has been added to the -mm tree.  Its filename is
     gfs2-dont-call-permission.patch

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
Subject: gfs2: dont call permission()
From: Miklos Szeredi <mszeredi@suse.cz>

GFS2 calls permission() to verify permissions after locks on the files
have been taken.

For this it's sufficient to call gfs2_permission() instead.  This
results in the following changes:

  - IS_RDONLY() check is not performed
  - IS_IMMUTABLE() check is not performed
  - devcgroup_inode_permission() is not called
  - security_inode_permission() is not called

IS_RDONLY() should be unnecessary anyway, as the per-mount read-only
flag should provide protection against read-only remounts during
operations.  do_gfs2_set_flags() has been fixed to perform
mnt_want_write()/mnt_drop_write() to protect against remounting
read-only.

IS_IMMUTABLE has beed added to gfs2_do_permission()

Repeating the security checks seems to be pointless, as they don't
normally change, and if they do, it's independent of the filesystem
state.

I also suspect the conditional locking in gfs2_do_permission() could
be cleaned up, due to the removal of the implicit recursion.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/inode.c     |    6 +++---
 fs/gfs2/inode.h     |    1 +
 fs/gfs2/ops_file.c  |   11 +++++++++--
 fs/gfs2/ops_inode.c |   18 +++++++++++++-----
 4 files changed, 26 insertions(+), 10 deletions(-)

diff -puN fs/gfs2/inode.c~gfs2-dont-call-permission fs/gfs2/inode.c
--- a/fs/gfs2/inode.c~gfs2-dont-call-permission
+++ a/fs/gfs2/inode.c
@@ -504,7 +504,7 @@ struct inode *gfs2_lookupi(struct inode 
 	}
 
 	if (!is_root) {
-		error = permission(dir, MAY_EXEC, NULL);
+		error = gfs2_do_permission(dir, MAY_EXEC);
 		if (error)
 			goto out;
 	}
@@ -667,7 +667,7 @@ static int create_ok(struct gfs2_inode *
 {
 	int error;
 
-	error = permission(&dip->i_inode, MAY_WRITE | MAY_EXEC, NULL);
+	error = gfs2_do_permission(&dip->i_inode, MAY_WRITE | MAY_EXEC);
 	if (error)
 		return error;
 
@@ -1134,7 +1134,7 @@ int gfs2_unlink_ok(struct gfs2_inode *di
 	if (IS_APPEND(&dip->i_inode))
 		return -EPERM;
 
-	error = permission(&dip->i_inode, MAY_WRITE | MAY_EXEC, NULL);
+	error = gfs2_do_permission(&dip->i_inode, MAY_WRITE | MAY_EXEC);
 	if (error)
 		return error;
 
diff -puN fs/gfs2/inode.h~gfs2-dont-call-permission fs/gfs2/inode.h
--- a/fs/gfs2/inode.h~gfs2-dont-call-permission
+++ a/fs/gfs2/inode.h
@@ -91,6 +91,7 @@ int gfs2_rmdiri(struct gfs2_inode *dip, 
 		struct gfs2_inode *ip);
 int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 		   const struct gfs2_inode *ip);
+int gfs2_do_permission(struct inode *inode, int mask);
 int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to);
 int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len);
 int gfs2_glock_nq_atime(struct gfs2_holder *gh);
diff -puN fs/gfs2/ops_file.c~gfs2-dont-call-permission fs/gfs2/ops_file.c
--- a/fs/gfs2/ops_file.c~gfs2-dont-call-permission
+++ a/fs/gfs2/ops_file.c
@@ -15,6 +15,7 @@
 #include <linux/uio.h>
 #include <linux/blkdev.h>
 #include <linux/mm.h>
+#include <linux/mount.h>
 #include <linux/fs.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/ext2_fs.h>
@@ -220,10 +221,14 @@ static int do_gfs2_set_flags(struct file
 	int error;
 	u32 new_flags, flags;
 
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	error = mnt_want_write(filp->f_path.mnt);
 	if (error)
 		return error;
 
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	if (error)
+		goto out_drop_write;
+
 	flags = ip->i_di.di_flags;
 	new_flags = (flags & ~mask) | (reqflags & mask);
 	if ((new_flags ^ flags) == 0)
@@ -242,7 +247,7 @@ static int do_gfs2_set_flags(struct file
 	    !capable(CAP_LINUX_IMMUTABLE))
 		goto out;
 	if (!IS_IMMUTABLE(inode)) {
-		error = permission(inode, MAY_WRITE, NULL);
+		error = gfs2_do_permission(inode, MAY_WRITE);
 		if (error)
 			goto out;
 	}
@@ -272,6 +277,8 @@ out_trans_end:
 	gfs2_trans_end(sdp);
 out:
 	gfs2_glock_dq_uninit(&gh);
+out_drop_write:
+	mnt_drop_write(filp->f_path.mnt);
 	return error;
 }
 
diff -puN fs/gfs2/ops_inode.c~gfs2-dont-call-permission fs/gfs2/ops_inode.c
--- a/fs/gfs2/ops_inode.c~gfs2-dont-call-permission
+++ a/fs/gfs2/ops_inode.c
@@ -163,7 +163,7 @@ static int gfs2_link(struct dentry *old_
 	if (error)
 		goto out;
 
-	error = permission(dir, MAY_WRITE | MAY_EXEC, NULL);
+	error = gfs2_do_permission(dir, MAY_WRITE | MAY_EXEC);
 	if (error)
 		goto out_gunlock;
 
@@ -669,7 +669,7 @@ static int gfs2_rename(struct inode *odi
 			}
 		}
 	} else {
-		error = permission(ndir, MAY_WRITE | MAY_EXEC, NULL);
+		error = gfs2_do_permission(ndir, MAY_WRITE | MAY_EXEC);
 		if (error)
 			goto out_gunlock;
 
@@ -704,7 +704,7 @@ static int gfs2_rename(struct inode *odi
 	/* Check out the dir to be renamed */
 
 	if (dir_rename) {
-		error = permission(odentry->d_inode, MAY_WRITE, NULL);
+		error = gfs2_do_permission(odentry->d_inode, MAY_WRITE);
 		if (error)
 			goto out_gunlock;
 	}
@@ -891,7 +891,7 @@ static void *gfs2_follow_link(struct den
  * Returns: errno
  */
 
-static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+int gfs2_do_permission(struct inode *inode, int mask)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder i_gh;
@@ -905,13 +905,21 @@ static int gfs2_permission(struct inode 
 		unlock = 1;
 	}
 
-	error = generic_permission(inode, mask, gfs2_check_acl);
+	if ((mask & MAY_WRITE) && IS_IMMUTABLE(inode))
+		error = -EACCES;
+	else
+		error = generic_permission(inode, mask, gfs2_check_acl);
 	if (unlock)
 		gfs2_glock_dq_uninit(&i_gh);
 
 	return error;
 }
 
+static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+{
+	return gfs2_do_permission(inode, mask);
+}
+
 static int setattr_size(struct inode *inode, struct iattr *attr)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
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

