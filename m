From: akpm@osdl.org
Subject: + 9p-fix-segfault-caused-by-race-condition-in-meta-data-operations.patch added to -mm tree
Date: Tue, 23 Jan 2007 23:15:52 -0800
Message-ID: <200701240715.l0O7FqQ4011375@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55733 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104AbXAXHP4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 02:15:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ericvh@gmail.com


The patch titled
     9p: fix segfault caused by race condition in meta-data operations
has been added to the -mm tree.  Its filename is
     9p-fix-segfault-caused-by-race-condition-in-meta-data-operations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 9p: fix segfault caused by race condition in meta-data operations
From: Eric Van Hensbergen <ericvh@gmail.com>

Running dbench multithreaded exposed a race condition where fid structures
were removed while in use.  This patch adds semaphores to meta-data operations
to protect the fid structure.  Some cleanup of error-case handling in the
inode operations is also included.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/9p/fid.c       |   69 ++++++++++++++
 fs/9p/fid.h       |    5 +
 fs/9p/vfs_file.c  |   47 +---------
 fs/9p/vfs_inode.c |  204 +++++++++++++++++++++++++-------------------
 4 files changed, 196 insertions(+), 129 deletions(-)

diff -puN fs/9p/fid.c~9p-fix-segfault-caused-by-race-condition-in-meta-data-operations fs/9p/fid.c
--- a/fs/9p/fid.c~9p-fix-segfault-caused-by-race-condition-in-meta-data-operations
+++ a/fs/9p/fid.c
@@ -25,6 +25,7 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/idr.h>
+#include <asm/semaphore.h>
 
 #include "debug.h"
 #include "v9fs.h"
@@ -84,6 +85,7 @@ struct v9fs_fid *v9fs_fid_create(struct 
 	new->iounit = 0;
 	new->rdir_pos = 0;
 	new->rdir_fcall = NULL;
+	init_MUTEX(&new->lock);
 	INIT_LIST_HEAD(&new->list);
 
 	return new;
@@ -102,11 +104,11 @@ void v9fs_fid_destroy(struct v9fs_fid *f
 }
 
 /**
- * v9fs_fid_lookup - retrieve the right fid from a  particular dentry
+ * v9fs_fid_lookup - return a locked fid from a dentry
  * @dentry: dentry to look for fid in
- * @type: intent of lookup (operation or traversal)
  *
- * find a fid in the dentry
+ * find a fid in the dentry, obtain its semaphore and return a reference to it.
+ * code calling lookup is responsible for releasing lock
  *
  * TODO: only match fids that have the same uid as current user
  *
@@ -124,7 +126,68 @@ struct v9fs_fid *v9fs_fid_lookup(struct 
 
 	if (!return_fid) {
 		dprintk(DEBUG_ERROR, "Couldn't find a fid in dentry\n");
+		return_fid = ERR_PTR(-EBADF);
 	}
 
+	if(down_interruptible(&return_fid->lock))
+		return ERR_PTR(-EINTR);
+
 	return return_fid;
 }
+
+/**
+ * v9fs_fid_clone - lookup the fid for a dentry, clone a private copy and release it
+ * @dentry: dentry to look for fid in
+ *
+ * find a fid in the dentry and then clone to a new private fid
+ *
+ * TODO: only match fids that have the same uid as current user
+ *
+ */
+
+struct v9fs_fid *v9fs_fid_clone(struct dentry *dentry)
+{
+	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	struct v9fs_fid *base_fid, *new_fid = ERR_PTR(-EBADF);
+	struct v9fs_fcall *fcall = NULL;
+	int fid, err;
+
+	base_fid = v9fs_fid_lookup(dentry);
+
+	if(IS_ERR(base_fid))
+		return base_fid;
+
+	if(base_fid) {  /* clone fid */
+		fid = v9fs_get_idpool(&v9ses->fidpool);
+		if (fid < 0) {
+			eprintk(KERN_WARNING, "newfid fails!\n");
+			new_fid = ERR_PTR(-ENOSPC);
+			goto Release_Fid;
+		}
+
+		err = v9fs_t_walk(v9ses, base_fid->fid, fid, NULL, &fcall);
+		if (err < 0) {
+			dprintk(DEBUG_ERROR, "clone walk didn't work\n");
+			v9fs_put_idpool(fid, &v9ses->fidpool);
+			new_fid = ERR_PTR(err);
+			goto Free_Fcall;
+		}
+		new_fid = v9fs_fid_create(v9ses, fid);
+		if (new_fid == NULL) {
+			dprintk(DEBUG_ERROR, "out of memory\n");
+			new_fid = ERR_PTR(-ENOMEM);
+		}
+Free_Fcall:
+		kfree(fcall);
+	}
+
+Release_Fid:
+	up(&base_fid->lock);
+	return new_fid;
+}
+
+void v9fs_fid_clunk(struct v9fs_session_info *v9ses, struct v9fs_fid *fid)
+{
+	v9fs_t_clunk(v9ses, fid->fid);
+	v9fs_fid_destroy(fid);
+}
diff -puN fs/9p/fid.h~9p-fix-segfault-caused-by-race-condition-in-meta-data-operations fs/9p/fid.h
--- a/fs/9p/fid.h~9p-fix-segfault-caused-by-race-condition-in-meta-data-operations
+++ a/fs/9p/fid.h
@@ -30,6 +30,8 @@ struct v9fs_fid {
 	struct list_head list;	 /* list of fids associated with a dentry */
 	struct list_head active; /* XXX - debug */
 
+	struct semaphore lock;
+
 	u32 fid;
 	unsigned char fidopen;	  /* set when fid is opened */
 	unsigned char fidclunked; /* set when fid has already been clunked */
@@ -55,3 +57,6 @@ struct v9fs_fid *v9fs_fid_get_created(st
 void v9fs_fid_destroy(struct v9fs_fid *fid);
 struct v9fs_fid *v9fs_fid_create(struct v9fs_session_info *, int fid);
 int v9fs_fid_insert(struct v9fs_fid *fid, struct dentry *dentry);
+struct v9fs_fid *v9fs_fid_clone(struct dentry *dentry);
+void v9fs_fid_clunk(struct v9fs_session_info *v9ses, struct v9fs_fid *fid);
+
diff -puN fs/9p/vfs_file.c~9p-fix-segfault-caused-by-race-condition-in-meta-data-operations fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~9p-fix-segfault-caused-by-race-condition-in-meta-data-operations
+++ a/fs/9p/vfs_file.c
@@ -55,53 +55,22 @@ int v9fs_file_open(struct inode *inode, 
 	struct v9fs_fid *vfid;
 	struct v9fs_fcall *fcall = NULL;
 	int omode;
-	int fid = V9FS_NOFID;
 	int err;
 
 	dprintk(DEBUG_VFS, "inode: %p file: %p \n", inode, file);
 
-	vfid = v9fs_fid_lookup(file->f_path.dentry);
-	if (!vfid) {
-		dprintk(DEBUG_ERROR, "Couldn't resolve fid from dentry\n");
-		return -EBADF;
-	}
-
-	fid = v9fs_get_idpool(&v9ses->fidpool);
-	if (fid < 0) {
-		eprintk(KERN_WARNING, "newfid fails!\n");
-		return -ENOSPC;
-	}
+	vfid = v9fs_fid_clone(file->f_path.dentry);
+	if (IS_ERR(vfid))
+		return PTR_ERR(vfid);
 
-	err = v9fs_t_walk(v9ses, vfid->fid, fid, NULL, &fcall);
-	if (err < 0) {
-		dprintk(DEBUG_ERROR, "rewalk didn't work\n");
-		if (fcall && fcall->id == RWALK)
-			goto clunk_fid;
-		else {
-			v9fs_put_idpool(fid, &v9ses->fidpool);
-			goto free_fcall;
-		}
-	}
-	kfree(fcall);
-
-	/* TODO: do special things for O_EXCL, O_NOFOLLOW, O_SYNC */
-	/* translate open mode appropriately */
 	omode = v9fs_uflags2omode(file->f_flags);
-	err = v9fs_t_open(v9ses, fid, omode, &fcall);
+	err = v9fs_t_open(v9ses, vfid->fid, omode, &fcall);
 	if (err < 0) {
 		PRINT_FCALL_ERROR("open failed", fcall);
-		goto clunk_fid;
-	}
-
-	vfid = kmalloc(sizeof(struct v9fs_fid), GFP_KERNEL);
-	if (vfid == NULL) {
-		dprintk(DEBUG_ERROR, "out of memory\n");
-		err = -ENOMEM;
-		goto clunk_fid;
+		goto Clunk_Fid;
 	}
 
 	file->private_data = vfid;
-	vfid->fid = fid;
 	vfid->fidopen = 1;
 	vfid->fidclunked = 0;
 	vfid->iounit = fcall->params.ropen.iounit;
@@ -112,10 +81,8 @@ int v9fs_file_open(struct inode *inode, 
 
 	return 0;
 
-clunk_fid:
-	v9fs_t_clunk(v9ses, fid);
-
-free_fcall:
+Clunk_Fid:
+	v9fs_fid_clunk(v9ses, vfid);
 	kfree(fcall);
 
 	return err;
diff -puN fs/9p/vfs_inode.c~9p-fix-segfault-caused-by-race-condition-in-meta-data-operations fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c~9p-fix-segfault-caused-by-race-condition-in-meta-data-operations
+++ a/fs/9p/vfs_inode.c
@@ -416,12 +416,8 @@ static int v9fs_remove(struct inode *dir
 	sb = file_inode->i_sb;
 	v9ses = v9fs_inode2v9ses(file_inode);
 	v9fid = v9fs_fid_lookup(file);
-
-	if (!v9fid) {
-		dprintk(DEBUG_ERROR,
-			"no v9fs_fid\n");
-		return -EBADF;
-	}
+	if(IS_ERR(v9fid))
+		return PTR_ERR(v9fid);
 
 	fid = v9fid->fid;
 	if (fid < 0) {
@@ -433,11 +429,13 @@ static int v9fs_remove(struct inode *dir
 	result = v9fs_t_remove(v9ses, fid, &fcall);
 	if (result < 0) {
 		PRINT_FCALL_ERROR("remove fails", fcall);
+		goto Error;
 	}
 
 	v9fs_put_idpool(fid, &v9ses->fidpool);
 	v9fs_fid_destroy(v9fid);
 
+Error:
 	kfree(fcall);
 	return result;
 }
@@ -473,9 +471,13 @@ v9fs_vfs_create(struct inode *dir, struc
 	inode = NULL;
 	vfid = NULL;
 	v9ses = v9fs_inode2v9ses(dir);
-	dfid = v9fs_fid_lookup(dentry->d_parent);
-	perm = unixmode2p9mode(v9ses, mode);
+	dfid = v9fs_fid_clone(dentry->d_parent);
+	if(IS_ERR(dfid)) {
+		err = PTR_ERR(dfid);
+		goto error;
+	}
 
+	perm = unixmode2p9mode(v9ses, mode);
 	if (nd && nd->flags & LOOKUP_OPEN)
 		flags = nd->intent.open.flags - 1;
 	else
@@ -485,9 +487,10 @@ v9fs_vfs_create(struct inode *dir, struc
 		perm, v9fs_uflags2omode(flags), NULL, &fid, &qid, &iounit);
 
 	if (err)
-		goto error;
+		goto clunk_dfid;
 
 	vfid = v9fs_clone_walk(v9ses, dfid->fid, dentry);
+	v9fs_fid_clunk(v9ses, dfid);
 	if (IS_ERR(vfid)) {
 		err = PTR_ERR(vfid);
 		vfid = NULL;
@@ -525,6 +528,9 @@ v9fs_vfs_create(struct inode *dir, struc
 
 	return 0;
 
+clunk_dfid:
+	v9fs_fid_clunk(v9ses, dfid);
+
 error:
 	if (vfid)
 		v9fs_fid_destroy(vfid);
@@ -551,7 +557,12 @@ static int v9fs_vfs_mkdir(struct inode *
 	inode = NULL;
 	vfid = NULL;
 	v9ses = v9fs_inode2v9ses(dir);
-	dfid = v9fs_fid_lookup(dentry->d_parent);
+	dfid = v9fs_fid_clone(dentry->d_parent);
+	if(IS_ERR(dfid)) {
+		err = PTR_ERR(dfid);
+		goto error;
+	}
+
 	perm = unixmode2p9mode(v9ses, mode | S_IFDIR);
 
 	err = v9fs_create(v9ses, dfid->fid, (char *) dentry->d_name.name,
@@ -559,37 +570,36 @@ static int v9fs_vfs_mkdir(struct inode *
 
 	if (err) {
 		dprintk(DEBUG_ERROR, "create error %d\n", err);
-		goto error;
-	}
-
-	err = v9fs_t_clunk(v9ses, fid);
-	if (err) {
-		dprintk(DEBUG_ERROR, "clunk error %d\n", err);
-		goto error;
+		goto clean_up_dfid;
 	}
 
 	vfid = v9fs_clone_walk(v9ses, dfid->fid, dentry);
 	if (IS_ERR(vfid)) {
 		err = PTR_ERR(vfid);
 		vfid = NULL;
-		goto error;
+		goto clean_up_dfid;
 	}
 
+	v9fs_fid_clunk(v9ses, dfid);
 	inode = v9fs_inode_from_fid(v9ses, vfid->fid, dir->i_sb);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		inode = NULL;
-		goto error;
+		goto clean_up_fids;
 	}
 
 	dentry->d_op = &v9fs_dentry_operations;
 	d_instantiate(dentry, inode);
 	return 0;
 
-error:
+clean_up_fids:
 	if (vfid)
 		v9fs_fid_destroy(vfid);
 
+clean_up_dfid:
+	v9fs_fid_clunk(v9ses, dfid);
+
+error:
 	return err;
 }
 
@@ -622,28 +632,23 @@ static struct dentry *v9fs_vfs_lookup(st
 	dentry->d_op = &v9fs_dentry_operations;
 	dirfid = v9fs_fid_lookup(dentry->d_parent);
 
-	if (!dirfid) {
-		dprintk(DEBUG_ERROR, "no dirfid\n");
-		return ERR_PTR(-EINVAL);
-	}
+	if(IS_ERR(dirfid))
+		return ERR_PTR(PTR_ERR(dirfid));
 
 	dirfidnum = dirfid->fid;
 
-	if (dirfidnum < 0) {
-		dprintk(DEBUG_ERROR, "no dirfid for inode %p, #%lu\n",
-			dir, dir->i_ino);
-		return ERR_PTR(-EBADF);
-	}
-
 	newfid = v9fs_get_idpool(&v9ses->fidpool);
 	if (newfid < 0) {
 		eprintk(KERN_WARNING, "newfid fails!\n");
-		return ERR_PTR(-ENOSPC);
+		result = -ENOSPC;
+		goto Release_Dirfid;
 	}
 
 	result = v9fs_t_walk(v9ses, dirfidnum, newfid,
 		(char *)dentry->d_name.name, &fcall);
 
+	up(&dirfid->lock);
+
 	if (result < 0) {
 		if (fcall && fcall->id == RWALK)
 			v9fs_t_clunk(v9ses, newfid);
@@ -701,8 +706,12 @@ static struct dentry *v9fs_vfs_lookup(st
 
 	return NULL;
 
-      FreeFcall:
+Release_Dirfid:
+	up(&dirfid->lock);
+
+FreeFcall:
 	kfree(fcall);
+
 	return ERR_PTR(result);
 }
 
@@ -746,10 +755,8 @@ v9fs_vfs_rename(struct inode *old_dir, s
 	struct inode *old_inode = old_dentry->d_inode;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(old_inode);
 	struct v9fs_fid *oldfid = v9fs_fid_lookup(old_dentry);
-	struct v9fs_fid *olddirfid =
-	    v9fs_fid_lookup(old_dentry->d_parent);
-	struct v9fs_fid *newdirfid =
-	    v9fs_fid_lookup(new_dentry->d_parent);
+	struct v9fs_fid *olddirfid;
+	struct v9fs_fid *newdirfid;
 	struct v9fs_wstat wstat;
 	struct v9fs_fcall *fcall = NULL;
 	int fid = -1;
@@ -759,16 +766,26 @@ v9fs_vfs_rename(struct inode *old_dir, s
 
 	dprintk(DEBUG_VFS, "\n");
 
-	if ((!oldfid) || (!olddirfid) || (!newdirfid)) {
-		dprintk(DEBUG_ERROR, "problem with arguments\n");
-		return -EBADF;
+	if(IS_ERR(oldfid))
+		return PTR_ERR(oldfid);
+
+	olddirfid = v9fs_fid_clone(old_dentry->d_parent);
+	if(IS_ERR(olddirfid)) {
+		retval = PTR_ERR(olddirfid);
+		goto Release_lock;
+	}
+
+	newdirfid = v9fs_fid_clone(new_dentry->d_parent);
+	if(IS_ERR(newdirfid)) {
+		retval = PTR_ERR(newdirfid);
+		goto Clunk_olddir;
 	}
 
 	/* 9P can only handle file rename in the same directory */
 	if (memcmp(&olddirfid->qid, &newdirfid->qid, sizeof(newdirfid->qid))) {
 		dprintk(DEBUG_ERROR, "old dir and new dir are different\n");
 		retval = -EXDEV;
-		goto FreeFcallnBail;
+		goto Clunk_newdir;
 	}
 
 	fid = oldfid->fid;
@@ -779,7 +796,7 @@ v9fs_vfs_rename(struct inode *old_dir, s
 		dprintk(DEBUG_ERROR, "no fid for old file #%lu\n",
 			old_inode->i_ino);
 		retval = -EBADF;
-		goto FreeFcallnBail;
+		goto Clunk_newdir;
 	}
 
 	v9fs_blank_wstat(&wstat);
@@ -788,11 +805,20 @@ v9fs_vfs_rename(struct inode *old_dir, s
 
 	retval = v9fs_t_wstat(v9ses, fid, &wstat, &fcall);
 
-      FreeFcallnBail:
 	if (retval < 0)
 		PRINT_FCALL_ERROR("wstat error", fcall);
 
 	kfree(fcall);
+
+Clunk_newdir:
+	v9fs_fid_clunk(v9ses, newdirfid);
+
+Clunk_olddir:
+	v9fs_fid_clunk(v9ses, olddirfid);
+
+Release_lock:
+	up(&oldfid->lock);
+
 	return retval;
 }
 
@@ -810,15 +836,12 @@ v9fs_vfs_getattr(struct vfsmount *mnt, s
 {
 	struct v9fs_fcall *fcall = NULL;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	struct v9fs_fid *fid = v9fs_fid_lookup(dentry);
+	struct v9fs_fid *fid = v9fs_fid_clone(dentry);
 	int err = -EPERM;
 
 	dprintk(DEBUG_VFS, "dentry: %p\n", dentry);
-	if (!fid) {
-		dprintk(DEBUG_ERROR,
-			"couldn't find fid associated with dentry\n");
-		return -EBADF;
-	}
+	if(IS_ERR(fid))
+		return PTR_ERR(fid);
 
 	err = v9fs_t_stat(v9ses, fid->fid, &fcall);
 
@@ -831,6 +854,7 @@ v9fs_vfs_getattr(struct vfsmount *mnt, s
 	}
 
 	kfree(fcall);
+	v9fs_fid_clunk(v9ses, fid);
 	return err;
 }
 
@@ -844,18 +868,14 @@ v9fs_vfs_getattr(struct vfsmount *mnt, s
 static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 {
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	struct v9fs_fid *fid = v9fs_fid_lookup(dentry);
+	struct v9fs_fid *fid = v9fs_fid_clone(dentry);
 	struct v9fs_fcall *fcall = NULL;
 	struct v9fs_wstat wstat;
 	int res = -EPERM;
 
 	dprintk(DEBUG_VFS, "\n");
-
-	if (!fid) {
-		dprintk(DEBUG_ERROR,
-			"Couldn't find fid associated with dentry\n");
-		return -EBADF;
-	}
+	if(IS_ERR(fid))
+		return PTR_ERR(fid);
 
 	v9fs_blank_wstat(&wstat);
 	if (iattr->ia_valid & ATTR_MODE)
@@ -887,6 +907,7 @@ static int v9fs_vfs_setattr(struct dentr
 	if (res >= 0)
 		res = inode_setattr(dentry->d_inode, iattr);
 
+	v9fs_fid_clunk(v9ses, fid);
 	return res;
 }
 
@@ -987,18 +1008,15 @@ static int v9fs_readlink(struct dentry *
 
 	struct v9fs_fcall *fcall = NULL;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	struct v9fs_fid *fid = v9fs_fid_lookup(dentry);
+	struct v9fs_fid *fid = v9fs_fid_clone(dentry);
 
-	if (!fid) {
-		dprintk(DEBUG_ERROR, "could not resolve fid from dentry\n");
-		retval = -EBADF;
-		goto FreeFcall;
-	}
+	if(IS_ERR(fid))
+		return PTR_ERR(fid);
 
 	if (!v9ses->extended) {
 		retval = -EBADF;
 		dprintk(DEBUG_ERROR, "not extended\n");
-		goto FreeFcall;
+		goto ClunkFid;
 	}
 
 	dprintk(DEBUG_VFS, " %s\n", dentry->d_name.name);
@@ -1009,8 +1027,10 @@ static int v9fs_readlink(struct dentry *
 		goto FreeFcall;
 	}
 
-	if (!fcall)
-		return -EIO;
+	if (!fcall) {
+		retval = -EIO;
+		goto ClunkFid;
+	}
 
 	if (!(fcall->params.rstat.stat.mode & V9FS_DMSYMLINK)) {
 		retval = -EINVAL;
@@ -1028,9 +1048,12 @@ static int v9fs_readlink(struct dentry *
 		fcall->params.rstat.stat.extension.str, buffer);
 	retval = buflen;
 
-      FreeFcall:
+FreeFcall:
 	kfree(fcall);
 
+ClunkFid:
+	v9fs_fid_clunk(v9ses, fid);
+
 	return retval;
 }
 
@@ -1123,52 +1146,58 @@ static int v9fs_vfs_mkspecial(struct ino
 	int err;
 	u32 fid, perm;
 	struct v9fs_session_info *v9ses;
-	struct v9fs_fid *dfid, *vfid;
-	struct inode *inode;
+	struct v9fs_fid *dfid, *vfid = NULL;
+	struct inode *inode = NULL;
 
-	inode = NULL;
-	vfid = NULL;
 	v9ses = v9fs_inode2v9ses(dir);
-	dfid = v9fs_fid_lookup(dentry->d_parent);
-	perm = unixmode2p9mode(v9ses, mode);
-
 	if (!v9ses->extended) {
 		dprintk(DEBUG_ERROR, "not extended\n");
 		return -EPERM;
 	}
 
+	dfid = v9fs_fid_clone(dentry->d_parent);
+	if(IS_ERR(dfid)) {
+		err = PTR_ERR(dfid);
+		goto error;
+	}
+
+	perm = unixmode2p9mode(v9ses, mode);
+
 	err = v9fs_create(v9ses, dfid->fid, (char *) dentry->d_name.name,
 		perm, V9FS_OREAD, (char *) extension, &fid, NULL, NULL);
 
 	if (err)
-		goto error;
+		goto clunk_dfid;
 
 	err = v9fs_t_clunk(v9ses, fid);
 	if (err)
-		goto error;
+		goto clunk_dfid;
 
 	vfid = v9fs_clone_walk(v9ses, dfid->fid, dentry);
 	if (IS_ERR(vfid)) {
 		err = PTR_ERR(vfid);
 		vfid = NULL;
-		goto error;
+		goto clunk_dfid;
 	}
 
 	inode = v9fs_inode_from_fid(v9ses, vfid->fid, dir->i_sb);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		inode = NULL;
-		goto error;
+		goto free_vfid;
 	}
 
 	dentry->d_op = &v9fs_dentry_operations;
 	d_instantiate(dentry, inode);
 	return 0;
 
-error:
-	if (vfid)
-		v9fs_fid_destroy(vfid);
+free_vfid:
+	v9fs_fid_destroy(vfid);
 
+clunk_dfid:
+	v9fs_fid_clunk(v9ses, dfid);
+
+error:
 	return err;
 
 }
@@ -1209,26 +1238,29 @@ v9fs_vfs_link(struct dentry *old_dentry,
 	      struct dentry *dentry)
 {
 	int retval;
+	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dir);
 	struct v9fs_fid *oldfid;
 	char *name;
 
 	dprintk(DEBUG_VFS, " %lu,%s,%s\n", dir->i_ino, dentry->d_name.name,
 		old_dentry->d_name.name);
 
-	oldfid = v9fs_fid_lookup(old_dentry);
-	if (!oldfid) {
-		dprintk(DEBUG_ERROR, "can't find oldfid\n");
-		return -EPERM;
-	}
+	oldfid = v9fs_fid_clone(old_dentry);
+	if(IS_ERR(oldfid))
+		return PTR_ERR(oldfid);
 
 	name = __getname();
-	if (unlikely(!name))
-		return -ENOMEM;
+	if (unlikely(!name)) {
+		retval = -ENOMEM;
+		goto clunk_fid;
+	}
 
 	sprintf(name, "%d\n", oldfid->fid);
 	retval = v9fs_vfs_mkspecial(dir, dentry, V9FS_DMLINK, name);
 	__putname(name);
 
+clunk_fid:
+	v9fs_fid_clunk(v9ses, oldfid);
 	return retval;
 }
 
_

Patches currently in -mm which might be from ericvh@gmail.com are

9p-fix-bogus-return-code-checks-during-initialization.patch
9p-fix-rename-return-code.patch
9p-update-documentation-regarding-server-applications.patch
9p-fix-segfault-caused-by-race-condition-in-meta-data-operations.patch
9p-null-terminate-error-strings-for-debug-print.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
