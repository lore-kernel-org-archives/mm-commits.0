From: akpm@osdl.org
Subject: - user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:24:56 -0800
Message-ID: <200702010125.l111PsVQ032642@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35800 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161227AbXBAB2A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:28:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, mm-commits@vger.kernel.org


The patch titled
     user ns: prepare copy_tree, copy_mnt, and their callers to handle errs
has been removed from the -mm tree.  Its filename was
     user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: user ns: prepare copy_tree, copy_mnt, and their callers to handle errs


With shareduserns and non-shareduserns mounts, it will be possible for
clone_mnt to return -EPERM if a namespace tries to bind mount a
non-shareduserns vfsmnt from another user namespace.  But currently they only
return NULL, which is interpreted as -ENOMEM.  Update the callers to handle
other errors.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/namespace.c |   92 ++++++++++++++++++++++++-----------------------
 fs/pnode.c     |    5 +-
 2 files changed, 51 insertions(+), 46 deletions(-)

diff -puN fs/namespace.c~user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs fs/namespace.c
--- a/fs/namespace.c~user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs
+++ a/fs/namespace.c
@@ -236,37 +236,39 @@ static struct vfsmount *clone_mnt(struct
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
+
 	return mnt;
 }
 
@@ -703,13 +705,15 @@ struct vfsmount *copy_tree(struct vfsmou
 {
 	struct vfsmount *res, *p, *q, *r, *s;
 	struct nameidata nd;
+	LIST_HEAD(umount_list);
 
 	if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
 		return NULL;
 
 	res = q = clone_mnt(mnt, dentry, flag);
-	if (!q)
-		goto Enomem;
+	if (IS_ERR(q))
+		return q;
+
 	q->mnt_mountpoint = mnt->mnt_mountpoint;
 
 	p = mnt;
@@ -730,8 +734,8 @@ struct vfsmount *copy_tree(struct vfsmou
 			nd.mnt = q;
 			nd.dentry = p->mnt_mountpoint;
 			q = clone_mnt(p, p->mnt_root, flag);
-			if (!q)
-				goto Enomem;
+			if (IS_ERR(q))
+				goto Error;
 			spin_lock(&vfsmount_lock);
 			list_add_tail(&q->mnt_list, &res->mnt_list);
 			attach_mnt(q, &nd);
@@ -739,15 +743,13 @@ struct vfsmount *copy_tree(struct vfsmou
 		}
 	}
 	return res;
-Enomem:
-	if (res) {
-		LIST_HEAD(umount_list);
-		spin_lock(&vfsmount_lock);
-		umount_tree(res, 0, &umount_list);
-		spin_unlock(&vfsmount_lock);
-		release_mounts(&umount_list);
-	}
-	return NULL;
+Error:
+	spin_lock(&vfsmount_lock);
+	umount_tree(res, 0, &umount_list);
+	spin_unlock(&vfsmount_lock);
+	release_mounts(&umount_list);
+
+	return q;
 }
 
 /*
@@ -927,8 +929,10 @@ static int do_loopback(struct nameidata 
 	else
 		mnt = clone_mnt(old_nd.mnt, old_nd.dentry, 0);
 
-	if (!mnt)
+	if (!mnt || IS_ERR(mnt)) {
+		err = mnt ? PTR_ERR(mnt) : -ENOMEM;
 		goto out;
+	}
 
 	err = graft_tree(mnt, nd);
 	if (err) {
@@ -1465,7 +1469,7 @@ struct mnt_namespace *dup_mnt_ns(struct 
 	/* First pass: copy the tree topology */
 	new_ns->root = copy_tree(mnt_ns->root, mnt_ns->root->mnt_root,
 					CL_COPY_ALL | CL_EXPIRE);
-	if (!new_ns->root) {
+	if (!new_ns->root || IS_ERR(new_ns->root)) {
 		up_write(&namespace_sem);
 		kfree(new_ns);
 		return NULL;
diff -puN fs/pnode.c~user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs fs/pnode.c
--- a/fs/pnode.c~user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs
+++ a/fs/pnode.c
@@ -187,8 +187,9 @@ int propagate_mnt(struct vfsmount *dest_
 
 		source =  get_source(m, prev_dest_mnt, prev_src_mnt, &type);
 
-		if (!(child = copy_tree(source, source->mnt_root, type))) {
-			ret = -ENOMEM;
+		child = copy_tree(source, source->mnt_root, type);
+		if (!child || IS_ERR(child)) {
+			ret = child ? PTR_ERR(child) : -ENOMEM;
 			list_splice(tree_list, tmp_list.prev);
 			goto out;
 		}
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user-ns-implement-user-ns-unshare.patch
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
uts-namespace-remove-config_uts_ns.patch
integrity-service-api-and-dummy-provider-fix.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
