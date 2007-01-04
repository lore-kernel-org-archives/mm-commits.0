From: akpm@osdl.org
Subject: + user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch added to -mm tree
Date: Thu, 04 Jan 2007 14:10:32 -0800
Message-ID: <200701042210.l04MAW4Y000442@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:59565 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965118AbXADW03 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 17:26:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at


The patch titled
     user ns: prepare copy_tree, copy_mnt, and their callers to handle errs fix
has been added to the -mm tree.  Its filename is
     user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: user ns: prepare copy_tree, copy_mnt, and their callers to handle errs fix
From: "Serge E. Hallyn" <serue@us.ibm.com>

Quoting Frederik Deweerdt (deweerdt@free.fr):
> On Thu, Jan 04, 2007 at 12:12:15PM -0600, Serge E. Hallyn wrote:
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index 5da87e2..a4039a3 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -708,8 +708,9 @@ struct vfsmount *copy_tree(struct vfsmou
> >  		return NULL;
> >
> >  	res = q = clone_mnt(mnt, dentry, flag);
> > -	if (!q)
> > -		goto Enomem;
> > +	if (!q || IS_ERR(q)) {
> > +		return q;
> > +	}
> >  	q->mnt_mountpoint = mnt->mnt_mountpoint;
> >
> >  	p = mnt;
> > @@ -730,8 +731,9 @@ struct vfsmount *copy_tree(struct vfsmou
> >  			nd.mnt = q;
> >  			nd.dentry = p->mnt_mountpoint;
> >  			q = clone_mnt(p, p->mnt_root, flag);
> > -			if (!q)
> > -				goto Enomem;
> > +			if (!q || IS_ERR(q)) {
> > +				goto Error;
> > +			}
> >  			spin_lock(&vfsmount_lock);
> >  			list_add_tail(&q->mnt_list, &res->mnt_list);
> >  			attach_mnt(q, &nd);
> > @@ -739,7 +741,7 @@ struct vfsmount *copy_tree(struct vfsmou
> >  		}
> >  	}
> >  	return res;
> > -Enomem:
> > +Error:
> >  	if (res) {
>         ^^^^^^^^^^
> I think that this check can be safely skiped, as res is always non-NULL
> when Error: is now reached, isn't it?

Good point.  In addition, we can clean the code up a little by not
letting clone_mnt return NULL.  Compile-tested patch follows.  Though
really it starts to look like clone_mnt should be split into two
parts, with the original clone_mnt static inline, and the new clone_mnt
doing the permission check and return value conversion...

Subject: [PATCH 1/1] userns: cleanups with clone_mnt

As Frederik Deweerdt points out, the Error: case in copy_tree()
can no longer have res==NULL, so remove that check.

Also make clone_mnt always return -ENOMEM in place of NULL.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/namespace.c |   80 +++++++++++++++++++++++------------------------
 1 files changed, 40 insertions(+), 40 deletions(-)

diff -puN fs/namespace.c~user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix fs/namespace.c
--- a/fs/namespace.c~user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix
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
 
@@ -703,14 +705,15 @@ struct vfsmount *copy_tree(struct vfsmou
 {
 	struct vfsmount *res, *p, *q, *r, *s;
 	struct nameidata nd;
+	LIST_HEAD(umount_list);
 
 	if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
 		return NULL;
 
 	res = q = clone_mnt(mnt, dentry, flag);
-	if (!q || IS_ERR(q)) {
+	if (IS_ERR(q))
 		return q;
-	}
+
 	q->mnt_mountpoint = mnt->mnt_mountpoint;
 
 	p = mnt;
@@ -731,9 +734,8 @@ struct vfsmount *copy_tree(struct vfsmou
 			nd.mnt = q;
 			nd.dentry = p->mnt_mountpoint;
 			q = clone_mnt(p, p->mnt_root, flag);
-			if (!q || IS_ERR(q)) {
+			if (IS_ERR(q))
 				goto Error;
-			}
 			spin_lock(&vfsmount_lock);
 			list_add_tail(&q->mnt_list, &res->mnt_list);
 			attach_mnt(q, &nd);
@@ -742,13 +744,11 @@ struct vfsmount *copy_tree(struct vfsmou
 	}
 	return res;
 Error:
-	if (res) {
-		LIST_HEAD(umount_list);
-		spin_lock(&vfsmount_lock);
-		umount_tree(res, 0, &umount_list);
-		spin_unlock(&vfsmount_lock);
-		release_mounts(&umount_list);
-	}
+	spin_lock(&vfsmount_lock);
+	umount_tree(res, 0, &umount_list);
+	spin_unlock(&vfsmount_lock);
+	release_mounts(&umount_list);
+
 	return q;
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
