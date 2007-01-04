From: akpm@osdl.org
Subject: + user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch added to -mm tree
Date: Thu, 04 Jan 2007 14:10:30 -0800
Message-ID: <200701042210.l04MAUcd000439@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:58241 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965084AbXADWLp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 17:11:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at


The patch titled
     user ns: prepare copy_tree, copy_mnt, and their callers to handle errs
has been added to the -mm tree.  Its filename is
     user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 fs/namespace.c |   20 ++++++++++++--------
 fs/pnode.c     |    5 +++--
 2 files changed, 15 insertions(+), 10 deletions(-)

diff -puN fs/namespace.c~user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs fs/namespace.c
--- a/fs/namespace.c~user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs
+++ a/fs/namespace.c
@@ -708,8 +708,9 @@ struct vfsmount *copy_tree(struct vfsmou
 		return NULL;
 
 	res = q = clone_mnt(mnt, dentry, flag);
-	if (!q)
-		goto Enomem;
+	if (!q || IS_ERR(q)) {
+		return q;
+	}
 	q->mnt_mountpoint = mnt->mnt_mountpoint;
 
 	p = mnt;
@@ -730,8 +731,9 @@ struct vfsmount *copy_tree(struct vfsmou
 			nd.mnt = q;
 			nd.dentry = p->mnt_mountpoint;
 			q = clone_mnt(p, p->mnt_root, flag);
-			if (!q)
-				goto Enomem;
+			if (!q || IS_ERR(q)) {
+				goto Error;
+			}
 			spin_lock(&vfsmount_lock);
 			list_add_tail(&q->mnt_list, &res->mnt_list);
 			attach_mnt(q, &nd);
@@ -739,7 +741,7 @@ struct vfsmount *copy_tree(struct vfsmou
 		}
 	}
 	return res;
-Enomem:
+Error:
 	if (res) {
 		LIST_HEAD(umount_list);
 		spin_lock(&vfsmount_lock);
@@ -747,7 +749,7 @@ Enomem:
 		spin_unlock(&vfsmount_lock);
 		release_mounts(&umount_list);
 	}
-	return NULL;
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
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
