From: akpm@linux-foundation.org
Subject: + unprivileged-mounts-propagate-error-values-from-clone_mnt.patch added to -mm tree
Date: Thu, 03 May 2007 23:07:52 -0700
Message-ID: <200705040607.l4467qOU030294@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581AbXEDGNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:13:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, linuxram@us.ibm.com


The patch titled
     unprivileged mounts: propagate error values from clone_mnt
has been added to the -mm tree.  Its filename is
     unprivileged-mounts-propagate-error-values-from-clone_mnt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unprivileged mounts: propagate error values from clone_mnt
From: Miklos Szeredi <mszeredi@suse.cz>

Allow clone_mnt() to return errors other than ENOMEM.  This will be used for
returning a different error value when the number of user mounts goes over the
limit.

Fix copy_tree() to return EPERM for unbindable mounts.

Don't propagate further from dup_mnt_ns() as that copy_tree() can only fail
with -ENOMEM.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   89 +++++++++++++++++++++++------------------------
 fs/pnode.c     |    5 +-
 2 files changed, 48 insertions(+), 46 deletions(-)

diff -puN fs/namespace.c~unprivileged-mounts-propagate-error-values-from-clone_mnt fs/namespace.c
--- a/fs/namespace.c~unprivileged-mounts-propagate-error-values-from-clone_mnt
+++ a/fs/namespace.c
@@ -262,41 +262,42 @@ static struct vfsmount *clone_mnt(struct
 	struct super_block *sb = old->mnt_sb;
 	struct vfsmount *mnt = alloc_vfsmnt(old->mnt_devname);
 
-	if (mnt) {
-		mnt->mnt_flags = old->mnt_flags;
-		atomic_inc(&sb->s_active);
-		mnt->mnt_sb = sb;
-		mnt->mnt_root = dget(root);
-		mnt->mnt_mountpoint = mnt->mnt_root;
-		mnt->mnt_parent = mnt;
-
-		/* don't copy the MNT_USER flag */
-		mnt->mnt_flags &= ~MNT_USER;
-		if (flag & CL_SETUSER)
-			set_mnt_user(mnt);
-
-		if (flag & CL_SLAVE) {
-			list_add(&mnt->mnt_slave, &old->mnt_slave_list);
-			mnt->mnt_master = old;
-			CLEAR_MNT_SHARED(mnt);
-		} else {
-			if ((flag & CL_PROPAGATION) || IS_MNT_SHARED(old))
-				list_add(&mnt->mnt_share, &old->mnt_share);
-			if (IS_MNT_SLAVE(old))
-				list_add(&mnt->mnt_slave, &old->mnt_slave);
-			mnt->mnt_master = old->mnt_master;
-		}
-		if (flag & CL_MAKE_SHARED)
-			set_mnt_shared(mnt);
+	if (!mnt)
+		return ERR_PTR(-ENOMEM);
 
-		/* stick the duplicate mount on the same expiry list
-		 * as the original if that was on one */
-		if (flag & CL_EXPIRE) {
-			spin_lock(&vfsmount_lock);
-			if (!list_empty(&old->mnt_expire))
-				list_add(&mnt->mnt_expire, &old->mnt_expire);
-			spin_unlock(&vfsmount_lock);
-		}
+	mnt->mnt_flags = old->mnt_flags;
+	atomic_inc(&sb->s_active);
+	mnt->mnt_sb = sb;
+	mnt->mnt_root = dget(root);
+	mnt->mnt_mountpoint = mnt->mnt_root;
+	mnt->mnt_parent = mnt;
+
+	/* don't copy the MNT_USER flag */
+	mnt->mnt_flags &= ~MNT_USER;
+	if (flag & CL_SETUSER)
+		set_mnt_user(mnt);
+
+	if (flag & CL_SLAVE) {
+		list_add(&mnt->mnt_slave, &old->mnt_slave_list);
+		mnt->mnt_master = old;
+		CLEAR_MNT_SHARED(mnt);
+	} else {
+		if ((flag & CL_PROPAGATION) || IS_MNT_SHARED(old))
+			list_add(&mnt->mnt_share, &old->mnt_share);
+		if (IS_MNT_SLAVE(old))
+			list_add(&mnt->mnt_slave, &old->mnt_slave);
+		mnt->mnt_master = old->mnt_master;
+	}
+	if (flag & CL_MAKE_SHARED)
+		set_mnt_shared(mnt);
+
+	/* stick the duplicate mount on the same expiry list
+	 * as the original if that was on one */
+	if (flag & CL_EXPIRE) {
+		spin_lock(&vfsmount_lock);
+		if (!list_empty(&old->mnt_expire))
+			list_add(&mnt->mnt_expire, &old->mnt_expire);
+		spin_unlock(&vfsmount_lock);
 	}
 	return mnt;
 }
@@ -764,11 +765,11 @@ struct vfsmount *copy_tree(struct vfsmou
 	struct nameidata nd;
 
 	if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
-		return NULL;
+		return ERR_PTR(-EPERM);
 
 	res = q = clone_mnt(mnt, dentry, flag);
-	if (!q)
-		goto Enomem;
+	if (IS_ERR(q))
+		goto error;
 	q->mnt_mountpoint = mnt->mnt_mountpoint;
 
 	p = mnt;
@@ -789,8 +790,8 @@ struct vfsmount *copy_tree(struct vfsmou
 			nd.mnt = q;
 			nd.dentry = p->mnt_mountpoint;
 			q = clone_mnt(p, p->mnt_root, flag);
-			if (!q)
-				goto Enomem;
+			if (IS_ERR(q))
+				goto error;
 			spin_lock(&vfsmount_lock);
 			list_add_tail(&q->mnt_list, &res->mnt_list);
 			attach_mnt(q, &nd);
@@ -798,7 +799,7 @@ struct vfsmount *copy_tree(struct vfsmou
 		}
 	}
 	return res;
-Enomem:
+ error:
 	if (res) {
 		LIST_HEAD(umount_list);
 		spin_lock(&vfsmount_lock);
@@ -806,7 +807,7 @@ Enomem:
 		spin_unlock(&vfsmount_lock);
 		release_mounts(&umount_list);
 	}
-	return NULL;
+	return q;
 }
 
 /*
@@ -985,13 +986,13 @@ static int do_loopback(struct nameidata 
 		goto out;
 
 	clone_flags = (flags & MS_SETUSER) ? CL_SETUSER : 0;
-	err = -ENOMEM;
 	if (flags & MS_REC)
 		mnt = copy_tree(old_nd.mnt, old_nd.dentry, clone_flags);
 	else
 		mnt = clone_mnt(old_nd.mnt, old_nd.dentry, clone_flags);
 
-	if (!mnt)
+	err = PTR_ERR(mnt);
+	if (IS_ERR(mnt))
 		goto out;
 
 	err = graft_tree(mnt, nd);
@@ -1536,7 +1537,7 @@ static struct mnt_namespace *dup_mnt_ns(
 	/* First pass: copy the tree topology */
 	new_ns->root = copy_tree(mnt_ns->root, mnt_ns->root->mnt_root,
 					CL_COPY_ALL | CL_EXPIRE);
-	if (!new_ns->root) {
+	if (IS_ERR(new_ns->root)) {
 		up_write(&namespace_sem);
 		kfree(new_ns);
 		return NULL;
diff -puN fs/pnode.c~unprivileged-mounts-propagate-error-values-from-clone_mnt fs/pnode.c
--- a/fs/pnode.c~unprivileged-mounts-propagate-error-values-from-clone_mnt
+++ a/fs/pnode.c
@@ -187,8 +187,9 @@ int propagate_mnt(struct vfsmount *dest_
 
 		source =  get_source(m, prev_dest_mnt, prev_src_mnt, &type);
 
-		if (!(child = copy_tree(source, source->mnt_root, type))) {
-			ret = -ENOMEM;
+		child = copy_tree(source, source->mnt_root, type);
+		if (IS_ERR(child)) {
+			ret = PTR_ERR(child);
 			list_splice(tree_list, tmp_list.prev);
 			goto out;
 		}
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
