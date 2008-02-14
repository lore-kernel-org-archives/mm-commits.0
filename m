From: akpm@linux-foundation.org
Subject: + vfs-add-ms_bind_flags-mount-flag.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:02:23 -0800
Message-ID: <200802140002.m1E02Nse021026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57324 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757999AbYBNAJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:09:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk


The patch titled
     vfs: add MS_BIND_FLAGS mount flag
has been added to the -mm tree.  Its filename is
     vfs-add-ms_bind_flags-mount-flag.patch

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
Subject: vfs: add MS_BIND_FLAGS mount flag
From: Paul Menage <menage@google.com>

Add a new mount() flag, MS_BIND_FLAGS.

MS_BIND_FLAGS indicates that a bind mount should take its per-mount flags
from the arguments passed to mount() rather than from the source
mountpoint.

This flag allows you to create a bind mount with the desired per-mount
flags in a single operation, rather than having to do a bind mount followed
by a remount, which is fiddly and can block for non-trivial periods of time
(on sb->s_umount?).

For recursive bind mounts, only the root of the tree being bound inherits
the per-mount flags from the mount() arguments; sub-mounts inherit their
per-mount flags from the source tree as usual.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c     |   37 +++++++++++++++++++++++++------------
 include/linux/fs.h |    2 ++
 2 files changed, 27 insertions(+), 12 deletions(-)

diff -puN fs/namespace.c~vfs-add-ms_bind_flags-mount-flag fs/namespace.c
--- a/fs/namespace.c~vfs-add-ms_bind_flags-mount-flag
+++ a/fs/namespace.c
@@ -512,13 +512,13 @@ static struct vfsmount *skip_mnt_tree(st
 }
 
 static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
-					int flag)
+				  int flag, int mnt_flags)
 {
 	struct super_block *sb = old->mnt_sb;
 	struct vfsmount *mnt = alloc_vfsmnt(old->mnt_devname);
 
 	if (mnt) {
-		mnt->mnt_flags = old->mnt_flags;
+		mnt->mnt_flags = mnt_flags;
 		atomic_inc(&sb->s_active);
 		mnt->mnt_sb = sb;
 		mnt->mnt_root = dget(root);
@@ -1095,8 +1095,9 @@ static int lives_below_in_same_fs(struct
 	}
 }
 
-struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
-					int flag)
+static struct vfsmount *
+__copy_tree(struct vfsmount *mnt, struct dentry *dentry,
+	    int flag, int mnt_flags)
 {
 	struct vfsmount *res, *p, *q, *r, *s;
 	struct nameidata nd;
@@ -1104,7 +1105,7 @@ struct vfsmount *copy_tree(struct vfsmou
 	if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
 		return NULL;
 
-	res = q = clone_mnt(mnt, dentry, flag);
+	res = q = clone_mnt(mnt, dentry, flag, mnt_flags);
 	if (!q)
 		goto Enomem;
 	q->mnt_mountpoint = mnt->mnt_mountpoint;
@@ -1126,7 +1127,7 @@ struct vfsmount *copy_tree(struct vfsmou
 			p = s;
 			nd.path.mnt = q;
 			nd.path.dentry = p->mnt_mountpoint;
-			q = clone_mnt(p, p->mnt_root, flag);
+			q = clone_mnt(p, p->mnt_root, flag, p->mnt_flags);
 			if (!q)
 				goto Enomem;
 			spin_lock(&vfsmount_lock);
@@ -1146,6 +1147,11 @@ Enomem:
 	}
 	return NULL;
 }
+struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
+			   int flag)
+{
+	return __copy_tree(mnt, dentry, flag, mnt->mnt_flags);
+}
 
 struct vfsmount *collect_mounts(struct vfsmount *mnt, struct dentry *dentry)
 {
@@ -1322,8 +1328,8 @@ static noinline int do_change_type(struc
  * do loopback mount.
  * noinline this do_mount helper to save do_mount stack space.
  */
-static noinline int do_loopback(struct nameidata *nd, char *old_name,
-				int recurse)
+static noinline int do_loopback(struct nameidata *nd, char *old_name, int flags,
+		       int mnt_flags)
 {
 	struct nameidata old_nd;
 	struct vfsmount *mnt = NULL;
@@ -1345,10 +1351,15 @@ static noinline int do_loopback(struct n
 		goto out;
 
 	err = -ENOMEM;
-	if (recurse)
-		mnt = copy_tree(old_nd.path.mnt, old_nd.path.dentry, 0);
+	/* Use the source mount flags unless the user passed MS_BIND_FLAGS */
+	if (!(flags & MS_BIND_FLAGS))
+		mnt_flags = old_nd.path.mnt->mnt_flags;
+	if (flags & MS_REC)
+		mnt = __copy_tree(old_nd.path.mnt, old_nd.path.dentry, 0,
+				  mnt_flags);
 	else
-		mnt = clone_mnt(old_nd.path.mnt, old_nd.path.dentry, 0);
+		mnt = clone_mnt(old_nd.path.mnt, old_nd.path.dentry, 0,
+				mnt_flags);
 
 	if (!mnt)
 		goto out;
@@ -1882,7 +1893,9 @@ long do_mount(char *dev_name, char *dir_
 		retval = do_remount(&nd, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);
 	else if (flags & MS_BIND)
-		retval = do_loopback(&nd, dev_name, flags & MS_REC);
+		retval = do_loopback(&nd, dev_name,
+				     flags & (MS_REC | MS_BIND_FLAGS),
+				     mnt_flags);
 	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
 		retval = do_change_type(&nd, flags);
 	else if (flags & MS_MOVE)
diff -puN include/linux/fs.h~vfs-add-ms_bind_flags-mount-flag include/linux/fs.h
--- a/include/linux/fs.h~vfs-add-ms_bind_flags-mount-flag
+++ a/include/linux/fs.h
@@ -125,6 +125,8 @@ extern int dir_notify_enable;
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
+#define MS_BIND_FLAGS	(1<<24) /* For MS_BIND, take mnt_flags from
+				 * args, not from source mountpoint */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
_

Patches currently in -mm which might be from menage@google.com are

vfs-add-ms_bind_flags-mount-flag.patch
add-a-refcount-check-in-dput.patch
