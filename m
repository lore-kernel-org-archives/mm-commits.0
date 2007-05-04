From: akpm@linux-foundation.org
Subject: + unprivileged-mounts-propagation-inherit-owner-from-parent.patch added to -mm tree
Date: Thu, 03 May 2007 23:08:02 -0700
Message-ID: <200705040608.l44682kR030314@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767588AbXEDGNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:13:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, linuxram@us.ibm.com


The patch titled
     unprivileged mounts: propagation: inherit owner from parent
has been added to the -mm tree.  Its filename is
     unprivileged-mounts-propagation-inherit-owner-from-parent.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unprivileged mounts: propagation: inherit owner from parent
From: Miklos Szeredi <mszeredi@suse.cz>

On mount propagation, let the owner of the clone be inherited from the
parent into which it has been propagated.  Also if the parent has the
"nosuid" flag, set this flag for the child as well.

This makes sense for example, when propagation is set up from the
initial namespace into a per-user namespace, where some or all of the
mounts may be owned by the user.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c     |   36 ++++++++++++++++++++++--------------
 fs/pnode.c         |   19 ++++++++++++++++---
 fs/pnode.h         |    3 +++
 include/linux/fs.h |    1 -
 4 files changed, 41 insertions(+), 18 deletions(-)

diff -puN fs/namespace.c~unprivileged-mounts-propagation-inherit-owner-from-parent fs/namespace.c
--- a/fs/namespace.c~unprivileged-mounts-propagation-inherit-owner-from-parent
+++ a/fs/namespace.c
@@ -250,10 +250,10 @@ static int reserve_user_mount(void)
 	return err;
 }
 
-static void __set_mnt_user(struct vfsmount *mnt)
+static void __set_mnt_user(struct vfsmount *mnt, uid_t owner)
 {
 	BUG_ON(mnt->mnt_flags & MNT_USER);
-	mnt->mnt_uid = current->fsuid;
+	mnt->mnt_uid = owner;
 	mnt->mnt_flags |= MNT_USER;
 
 	if (!capable(CAP_SETUID))
@@ -264,7 +264,7 @@ static void __set_mnt_user(struct vfsmou
 
 static void set_mnt_user(struct vfsmount *mnt)
 {
-	__set_mnt_user(mnt);
+	__set_mnt_user(mnt, current->fsuid);
 	spin_lock(&vfsmount_lock);
 	nr_user_mounts++;
 	spin_unlock(&vfsmount_lock);
@@ -280,7 +280,7 @@ static void clear_mnt_user(struct vfsmou
 }
 
 static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
-					int flag)
+					int flag, uid_t owner)
 {
 	struct super_block *sb = old->mnt_sb;
 	struct vfsmount *mnt;
@@ -304,7 +304,10 @@ static struct vfsmount *clone_mnt(struct
 	/* don't copy the MNT_USER flag */
 	mnt->mnt_flags &= ~MNT_USER;
 	if (flag & CL_SETUSER)
-		__set_mnt_user(mnt);
+		__set_mnt_user(mnt, owner);
+
+	if (flag & CL_NOSUID)
+		mnt->mnt_flags |= MNT_NOSUID;
 
 	if (flag & CL_SLAVE) {
 		list_add(&mnt->mnt_slave, &old->mnt_slave_list);
@@ -803,7 +806,7 @@ static int lives_below_in_same_fs(struct
 }
 
 struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
-					int flag)
+					int flag, uid_t owner)
 {
 	struct vfsmount *res, *p, *q, *r, *s;
 	struct nameidata nd;
@@ -811,7 +814,7 @@ struct vfsmount *copy_tree(struct vfsmou
 	if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
 		return ERR_PTR(-EPERM);
 
-	res = q = clone_mnt(mnt, dentry, flag);
+	res = q = clone_mnt(mnt, dentry, flag, owner);
 	if (IS_ERR(q))
 		goto error;
 	q->mnt_mountpoint = mnt->mnt_mountpoint;
@@ -833,7 +836,7 @@ struct vfsmount *copy_tree(struct vfsmou
 			p = s;
 			nd.mnt = q;
 			nd.dentry = p->mnt_mountpoint;
-			q = clone_mnt(p, p->mnt_root, flag);
+			q = clone_mnt(p, p->mnt_root, flag, owner);
 			if (IS_ERR(q))
 				goto error;
 			spin_lock(&vfsmount_lock);
@@ -1009,7 +1012,8 @@ static int do_change_type(struct nameida
  */
 static int do_loopback(struct nameidata *nd, char *old_name, int flags)
 {
-	int clone_flags;
+	int clone_flags = 0;
+	uid_t owner = 0;
 	struct nameidata old_nd;
 	struct vfsmount *mnt = NULL;
 	int err;
@@ -1030,11 +1034,15 @@ static int do_loopback(struct nameidata 
 	if (!check_mnt(nd->mnt) || !check_mnt(old_nd.mnt))
 		goto out;
 
-	clone_flags = (flags & MS_SETUSER) ? CL_SETUSER : 0;
+	if (flags & MS_SETUSER) {
+		clone_flags |= CL_SETUSER;
+		owner = current->fsuid;
+	}
+
 	if (flags & MS_REC)
-		mnt = copy_tree(old_nd.mnt, old_nd.dentry, clone_flags);
+		mnt = copy_tree(old_nd.mnt, old_nd.dentry, clone_flags, owner);
 	else
-		mnt = clone_mnt(old_nd.mnt, old_nd.dentry, clone_flags);
+		mnt = clone_mnt(old_nd.mnt, old_nd.dentry, clone_flags, owner);
 
 	err = PTR_ERR(mnt);
 	if (IS_ERR(mnt))
@@ -1208,7 +1216,7 @@ static int do_new_mount(struct nameidata
 	}
 
 	if (flags & MS_SETUSER)
-		__set_mnt_user(mnt);
+		__set_mnt_user(mnt, current->fsuid);
 
 	return do_add_mount(mnt, nd, mnt_flags, NULL);
 
@@ -1601,7 +1609,7 @@ static struct mnt_namespace *dup_mnt_ns(
 	down_write(&namespace_sem);
 	/* First pass: copy the tree topology */
 	new_ns->root = copy_tree(mnt_ns->root, mnt_ns->root->mnt_root,
-					CL_COPY_ALL | CL_EXPIRE);
+					CL_COPY_ALL | CL_EXPIRE, 0);
 	if (IS_ERR(new_ns->root)) {
 		up_write(&namespace_sem);
 		kfree(new_ns);
diff -puN fs/pnode.c~unprivileged-mounts-propagation-inherit-owner-from-parent fs/pnode.c
--- a/fs/pnode.c~unprivileged-mounts-propagation-inherit-owner-from-parent
+++ a/fs/pnode.c
@@ -179,15 +179,28 @@ int propagate_mnt(struct vfsmount *dest_
 
 	for (m = propagation_next(dest_mnt, dest_mnt); m;
 			m = propagation_next(m, dest_mnt)) {
-		int type;
+		int clflags;
+		uid_t owner = 0;
 		struct vfsmount *source;
 
 		if (IS_MNT_NEW(m))
 			continue;
 
-		source =  get_source(m, prev_dest_mnt, prev_src_mnt, &type);
+		source =  get_source(m, prev_dest_mnt, prev_src_mnt, &clflags);
 
-		child = copy_tree(source, source->mnt_root, type);
+		if (m->mnt_flags & MNT_USER) {
+			clflags |= CL_SETUSER;
+			owner = m->mnt_uid;
+
+			/*
+			 * If propagating into a user mount which doesn't
+			 * allow suid, then make sure, the child(ren) won't
+			 * allow suid either
+			 */
+			if (m->mnt_flags & MNT_NOSUID)
+				clflags |= CL_NOSUID;
+		}
+		child = copy_tree(source, source->mnt_root, clflags, owner);
 		if (IS_ERR(child)) {
 			ret = PTR_ERR(child);
 			list_splice(tree_list, tmp_list.prev);
diff -puN fs/pnode.h~unprivileged-mounts-propagation-inherit-owner-from-parent fs/pnode.h
--- a/fs/pnode.h~unprivileged-mounts-propagation-inherit-owner-from-parent
+++ a/fs/pnode.h
@@ -23,6 +23,7 @@
 #define CL_MAKE_SHARED 		0x08
 #define CL_PROPAGATION 		0x10
 #define CL_SETUSER		0x20
+#define CL_NOSUID		0x40
 
 static inline void set_mnt_shared(struct vfsmount *mnt)
 {
@@ -35,4 +36,6 @@ int propagate_mnt(struct vfsmount *, str
 		struct list_head *);
 int propagate_umount(struct list_head *);
 int propagate_mount_busy(struct vfsmount *, int);
+struct vfsmount *copy_tree(struct vfsmount *, struct dentry *, int, uid_t);
+
 #endif /* _LINUX_PNODE_H */
diff -puN include/linux/fs.h~unprivileged-mounts-propagation-inherit-owner-from-parent include/linux/fs.h
--- a/include/linux/fs.h~unprivileged-mounts-propagation-inherit-owner-from-parent
+++ a/include/linux/fs.h
@@ -1423,7 +1423,6 @@ extern int may_umount(struct vfsmount *)
 extern void umount_tree(struct vfsmount *, int, struct list_head *);
 extern void release_mounts(struct list_head *);
 extern long do_mount(char *, char *, char *, unsigned long, void *);
-extern struct vfsmount *copy_tree(struct vfsmount *, struct dentry *, int);
 extern void mnt_set_mountpoint(struct vfsmount *, struct dentry *,
 				  struct vfsmount *);
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-filesystem-subtype-support.patch
add-file-position-info-to-proc.patch
check-privileges-before-setting-mount-propagation.patch
consolidate-generic_writepages-and-mpage_writepages.patch
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
