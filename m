From: akpm@linux-foundation.org
Subject: + embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:01:25 -0800
Message-ID: <200711052101.lA5L1Q1p019531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38199 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628AbXKEVBs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:01:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, agruen@suse.de, hch@lst.de, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Embed a struct path into struct nameidata instead of nd->{dentry,mnt}
has been added to the -mm tree.  Its filename is
     embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Embed a struct path into struct nameidata instead of nd->{dentry,mnt}
From: Jan Blunck <jblunck@suse.de>

Switch from nd->{dentry,mnt} to nd->path.{dentry,mnt} everywhere.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: <linux-fsdevel@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c               |    2 
 arch/mips/kernel/sysirix.c                |    6 
 arch/parisc/hpux/sys_hpux.c               |    2 
 arch/powerpc/platforms/cell/spufs/inode.c |   18 -
 arch/sparc64/solaris/fs.c                 |    8 
 arch/um/drivers/mconsole_kern.c           |    6 
 drivers/md/dm-table.c                     |    2 
 drivers/mtd/mtdsuper.c                    |   10 
 fs/afs/mntpt.c                            |   22 -
 fs/autofs4/root.c                         |    3 
 fs/block_dev.c                            |    4 
 fs/coda/pioctl.c                          |    2 
 fs/compat.c                               |    4 
 fs/configfs/symlink.c                     |    4 
 fs/dquot.c                                |    7 
 fs/ecryptfs/dentry.c                      |   12 
 fs/ecryptfs/inode.c                       |   24 -
 fs/ecryptfs/main.c                        |    4 
 fs/exec.c                                 |    4 
 fs/ext3/super.c                           |    4 
 fs/ext4/super.c                           |    4 
 fs/gfs2/ops_fstype.c                      |    5 
 fs/inotify_user.c                         |    2 
 fs/namei.c                                |  258 ++++++++++----------
 fs/namespace.c                            |  195 ++++++++-------
 fs/nfs/dir.c                              |    2 
 fs/nfs/namespace.c                        |   27 +-
 fs/nfs/nfs4proc.c                         |   15 -
 fs/nfsctl.c                               |    2 
 fs/nfsd/export.c                          |   35 +-
 fs/nfsd/nfs4recover.c                     |   36 +-
 fs/nfsd/nfs4state.c                       |    2 
 fs/open.c                                 |   51 ++-
 fs/proc/base.c                            |    3 
 fs/proc/proc_net.c                        |   10 
 fs/proc/proc_sysctl.c                     |    2 
 fs/reiserfs/super.c                       |    6 
 fs/revoke.c                               |    2 
 fs/stat.c                                 |   13 -
 fs/utimes.c                               |    4 
 fs/xattr.c                                |   24 -
 fs/xfs/linux-2.6/xfs_ioctl.c              |    6 
 include/linux/namei.h                     |    3 
 kernel/audit_tree.c                       |   16 -
 kernel/auditfilter.c                      |   11 
 net/sunrpc/rpc_pipe.c                     |    5 
 net/unix/af_unix.c                        |   30 +-
 security/selinux/hooks.c                  |    4 
 48 files changed, 472 insertions(+), 449 deletions(-)

diff -puN arch/alpha/kernel/osf_sys.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/arch/alpha/kernel/osf_sys.c
@@ -260,7 +260,7 @@ osf_statfs(char __user *path, struct osf
 
 	retval = user_path_walk(path, &nd);
 	if (!retval) {
-		retval = do_osf_statfs(nd.dentry, buffer, bufsiz);
+		retval = do_osf_statfs(nd.path.dentry, buffer, bufsiz);
 		path_release(&nd);
 	}
 	return retval;
diff -puN arch/mips/kernel/sysirix.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt arch/mips/kernel/sysirix.c
--- a/arch/mips/kernel/sysirix.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/arch/mips/kernel/sysirix.c
@@ -694,7 +694,7 @@ asmlinkage int irix_statfs(const char __
 	if (error)
 		goto out;
 
-	error = vfs_statfs(nd.dentry, &kbuf);
+	error = vfs_statfs(nd.path.dentry, &kbuf);
 	if (error)
 		goto dput_and_out;
 
@@ -1360,7 +1360,7 @@ asmlinkage int irix_statvfs(char __user 
 	error = user_path_walk(fname, &nd);
 	if (error)
 		goto out;
-	error = vfs_statfs(nd.dentry, &kbuf);
+	error = vfs_statfs(nd.path.dentry, &kbuf);
 	if (error)
 		goto dput_and_out;
 
@@ -1611,7 +1611,7 @@ asmlinkage int irix_statvfs64(char __use
 	error = user_path_walk(fname, &nd);
 	if (error)
 		goto out;
-	error = vfs_statfs(nd.dentry, &kbuf);
+	error = vfs_statfs(nd.path.dentry, &kbuf);
 	if (error)
 		goto dput_and_out;
 
diff -puN arch/parisc/hpux/sys_hpux.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt arch/parisc/hpux/sys_hpux.c
--- a/arch/parisc/hpux/sys_hpux.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/arch/parisc/hpux/sys_hpux.c
@@ -219,7 +219,7 @@ asmlinkage long hpux_statfs(const char _
 	error = user_path_walk(path, &nd);
 	if (!error) {
 		struct hpux_statfs tmp;
-		error = vfs_statfs_hpux(nd.dentry, &tmp);
+		error = vfs_statfs_hpux(nd.path.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
 		path_release(&nd);
diff -puN arch/powerpc/platforms/cell/spufs/inode.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -1,3 +1,4 @@
+
 /*
  * SPU file system
  *
@@ -578,7 +579,7 @@ long spufs_create(struct nameidata *nd, 
 
 	ret = -EINVAL;
 	/* check if we are on spufs */
-	if (nd->dentry->d_sb->s_type != &spufs_type)
+	if (nd->path.dentry->d_sb->s_type != &spufs_type)
 		goto out;
 
 	/* don't accept undefined flags */
@@ -586,9 +587,9 @@ long spufs_create(struct nameidata *nd, 
 		goto out;
 
 	/* only threads can be underneath a gang */
-	if (nd->dentry != nd->dentry->d_sb->s_root) {
+	if (nd->path.dentry != nd->path.dentry->d_sb->s_root) {
 		if ((flags & SPU_CREATE_GANG) ||
-		    !SPUFS_I(nd->dentry->d_inode)->i_gang)
+		    !SPUFS_I(nd->path.dentry->d_inode)->i_gang)
 			goto out;
 	}
 
@@ -604,16 +605,17 @@ long spufs_create(struct nameidata *nd, 
 	mode &= ~current->fs->umask;
 
 	if (flags & SPU_CREATE_GANG)
-		return spufs_create_gang(nd->dentry->d_inode,
-					dentry, nd->mnt, mode);
+		return spufs_create_gang(nd->path.dentry->d_inode,
+					 dentry, nd->path.mnt, mode);
 	else
-		return spufs_create_context(nd->dentry->d_inode,
-					dentry, nd->mnt, flags, mode, filp);
+		return spufs_create_context(nd->path.dentry->d_inode,
+					    dentry, nd->path.mnt, flags, mode,
+					    filp);
 
 out_dput:
 	dput(dentry);
 out_dir:
-	mutex_unlock(&nd->dentry->d_inode->i_mutex);
+	mutex_unlock(&nd->path.dentry->d_inode->i_mutex);
 out:
 	return ret;
 }
diff -puN arch/sparc64/solaris/fs.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt arch/sparc64/solaris/fs.c
--- a/arch/sparc64/solaris/fs.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/arch/sparc64/solaris/fs.c
@@ -434,8 +434,8 @@ asmlinkage int solaris_statvfs(u32 path,
 
 	error = user_path_walk(A(path),&nd);
 	if (!error) {
-		struct inode * inode = nd.dentry->d_inode;
-		error = report_statvfs(nd.mnt, inode, buf);
+		struct inode *inode = nd.path.dentry->d_inode;
+		error = report_statvfs(nd.path.mnt, inode, buf);
 		path_release(&nd);
 	}
 	return error;
@@ -464,8 +464,8 @@ asmlinkage int solaris_statvfs64(u32 pat
 	lock_kernel();
 	error = user_path_walk(A(path), &nd);
 	if (!error) {
-		struct inode * inode = nd.dentry->d_inode;
-		error = report_statvfs64(nd.mnt, inode, buf);
+		struct inode *inode = nd.path.dentry->d_inode;
+		error = report_statvfs64(nd.path.mnt, inode, buf);
 		path_release(&nd);
 	}
 	unlock_kernel();
diff -puN arch/um/drivers/mconsole_kern.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/arch/um/drivers/mconsole_kern.c
@@ -143,8 +143,8 @@ void mconsole_proc(struct mc_request *re
 	}
 	up_write(&super->s_umount);
 
-	nd.dentry = super->s_root;
-	nd.mnt = NULL;
+	nd.path.dentry = super->s_root;
+	nd.path.mnt = NULL;
 	nd.flags = O_RDONLY + 1;
 	nd.last_type = LAST_ROOT;
 
@@ -157,7 +157,7 @@ void mconsole_proc(struct mc_request *re
 		goto out_kill;
 	}
 
-	file = dentry_open(nd.dentry, nd.mnt, O_RDONLY);
+	file = dentry_open(nd.path.dentry, nd.path.mnt, O_RDONLY);
 	if (IS_ERR(file)) {
 		mconsole_reply(req, "Failed to open file", 1, 0);
 		goto out_kill;
diff -puN drivers/md/dm-table.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt drivers/md/dm-table.c
--- a/drivers/md/dm-table.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/drivers/md/dm-table.c
@@ -356,7 +356,7 @@ static int lookup_device(const char *pat
 	if ((r = path_lookup(path, LOOKUP_FOLLOW, &nd)))
 		return r;
 
-	inode = nd.dentry->d_inode;
+	inode = nd.path.dentry->d_inode;
 	if (!inode) {
 		r = -ENOENT;
 		goto out;
diff -puN drivers/mtd/mtdsuper.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt drivers/mtd/mtdsuper.c
--- a/drivers/mtd/mtdsuper.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/drivers/mtd/mtdsuper.c
@@ -184,25 +184,25 @@ int get_sb_mtd(struct file_system_type *
 	ret = path_lookup(dev_name, LOOKUP_FOLLOW, &nd);
 
 	DEBUG(1, "MTDSB: path_lookup() returned %d, inode %p\n",
-	      ret, nd.dentry ? nd.dentry->d_inode : NULL);
+	      ret, nd.path.dentry ? nd.path.dentry->d_inode : NULL);
 
 	if (ret)
 		return ret;
 
 	ret = -EINVAL;
 
-	if (!S_ISBLK(nd.dentry->d_inode->i_mode))
+	if (!S_ISBLK(nd.path.dentry->d_inode->i_mode))
 		goto out;
 
-	if (nd.mnt->mnt_flags & MNT_NODEV) {
+	if (nd.path.mnt->mnt_flags & MNT_NODEV) {
 		ret = -EACCES;
 		goto out;
 	}
 
-	if (imajor(nd.dentry->d_inode) != MTD_BLOCK_MAJOR)
+	if (imajor(nd.path.dentry->d_inode) != MTD_BLOCK_MAJOR)
 		goto not_an_MTD_device;
 
-	mtdnr = iminor(nd.dentry->d_inode);
+	mtdnr = iminor(nd.path.dentry->d_inode);
 	path_release(&nd);
 
 	return get_sb_mtd_nr(fs_type, flags, dev_name, data, mtdnr, fill_super,
diff -puN fs/afs/mntpt.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/afs/mntpt.c
--- a/fs/afs/mntpt.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/afs/mntpt.c
@@ -218,14 +218,14 @@ static void *afs_mntpt_follow_link(struc
 	_enter("%p{%s},{%s:%p{%s},}",
 	       dentry,
 	       dentry->d_name.name,
-	       nd->mnt->mnt_devname,
+	       nd->path.mnt->mnt_devname,
 	       dentry,
-	       nd->dentry->d_name.name);
+	       nd->path.dentry->d_name.name);
 
-	dput(nd->dentry);
-	nd->dentry = dget(dentry);
+	dput(nd->path.dentry);
+	nd->path.dentry = dget(dentry);
 
-	newmnt = afs_mntpt_do_automount(nd->dentry);
+	newmnt = afs_mntpt_do_automount(nd->path.dentry);
 	if (IS_ERR(newmnt)) {
 		path_release(nd);
 		return (void *)newmnt;
@@ -235,17 +235,17 @@ static void *afs_mntpt_follow_link(struc
 	err = do_add_mount(newmnt, nd, MNT_SHRINKABLE, &afs_vfsmounts);
 	switch (err) {
 	case 0:
-		dput(nd->dentry);
-		mntput(nd->mnt);
-		nd->mnt = newmnt;
-		nd->dentry = dget(newmnt->mnt_root);
+		dput(nd->path.dentry);
+		mntput(nd->path.mnt);
+		nd->path.mnt = newmnt;
+		nd->path.dentry = dget(newmnt->mnt_root);
 		schedule_delayed_work(&afs_mntpt_expiry_timer,
 				      afs_mntpt_expiry_timeout * HZ);
 		break;
 	case -EBUSY:
 		/* someone else made a mount here whilst we were busy */
-		while (d_mountpoint(nd->dentry) &&
-		       follow_down(&nd->mnt, &nd->dentry))
+		while (d_mountpoint(nd->path.dentry) &&
+		       follow_down(&nd->path.mnt, &nd->path.dentry))
 			;
 		err = 0;
 	default:
diff -puN fs/autofs4/root.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/autofs4/root.c
--- a/fs/autofs4/root.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/autofs4/root.c
@@ -526,7 +526,8 @@ static void *autofs4_follow_link(struct 
 		 * so we don't need to follow the mount.
 		 */
 		if (d_mountpoint(dentry)) {
-			if (!autofs4_follow_mount(&nd->mnt, &nd->dentry)) {
+			if (!autofs4_follow_mount(&nd->path.mnt,
+						  &nd->path.dentry)) {
 				status = -ENOENT;
 				goto out_error;
 			}
diff -puN fs/block_dev.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/block_dev.c
--- a/fs/block_dev.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/block_dev.c
@@ -1398,12 +1398,12 @@ struct block_device *lookup_bdev(const c
 	if (error)
 		return ERR_PTR(error);
 
-	inode = nd.dentry->d_inode;
+	inode = nd.path.dentry->d_inode;
 	error = -ENOTBLK;
 	if (!S_ISBLK(inode->i_mode))
 		goto fail;
 	error = -EACCES;
-	if (nd.mnt->mnt_flags & MNT_NODEV)
+	if (nd.path.mnt->mnt_flags & MNT_NODEV)
 		goto fail;
 	error = -ENOMEM;
 	bdev = bd_acquire(inode);
diff -puN fs/coda/pioctl.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/coda/pioctl.c
--- a/fs/coda/pioctl.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/coda/pioctl.c
@@ -75,7 +75,7 @@ static int coda_pioctl(struct inode * in
 	if ( error ) {
 		return error;
         } else {
-	        target_inode = nd.dentry->d_inode;
+		target_inode = nd.path.dentry->d_inode;
 	}
 	
 	/* return if it is not a Coda inode */
diff -puN fs/compat.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/compat.c
--- a/fs/compat.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/compat.c
@@ -241,7 +241,7 @@ asmlinkage long compat_sys_statfs(const 
 	error = user_path_walk(path, &nd);
 	if (!error) {
 		struct kstatfs tmp;
-		error = vfs_statfs(nd.dentry, &tmp);
+		error = vfs_statfs(nd.path.dentry, &tmp);
 		if (!error)
 			error = put_compat_statfs(buf, &tmp);
 		path_release(&nd);
@@ -309,7 +309,7 @@ asmlinkage long compat_sys_statfs64(cons
 	error = user_path_walk(path, &nd);
 	if (!error) {
 		struct kstatfs tmp;
-		error = vfs_statfs(nd.dentry, &tmp);
+		error = vfs_statfs(nd.path.dentry, &tmp);
 		if (!error)
 			error = put_compat_statfs64(buf, &tmp);
 		path_release(&nd);
diff -puN fs/configfs/symlink.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/configfs/symlink.c
--- a/fs/configfs/symlink.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/configfs/symlink.c
@@ -99,8 +99,8 @@ static int get_target(const char *symnam
 
 	ret = path_lookup(symname, LOOKUP_FOLLOW|LOOKUP_DIRECTORY, nd);
 	if (!ret) {
-		if (nd->dentry->d_sb == configfs_sb) {
-			*target = configfs_get_config_item(nd->dentry);
+		if (nd->path.dentry->d_sb == configfs_sb) {
+			*target = configfs_get_config_item(nd->path.dentry);
 			if (!*target) {
 				ret = -ENOENT;
 				path_release(nd);
diff -puN fs/dquot.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/dquot.c
--- a/fs/dquot.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/dquot.c
@@ -1620,14 +1620,15 @@ int vfs_quota_on(struct super_block *sb,
 	error = path_lookup(path, LOOKUP_FOLLOW, &nd);
 	if (error < 0)
 		return error;
-	error = security_quota_on(nd.dentry);
+	error = security_quota_on(nd.path.dentry);
 	if (error)
 		goto out_path;
 	/* Quota file not on the same filesystem? */
-	if (nd.mnt->mnt_sb != sb)
+	if (nd.path.mnt->mnt_sb != sb)
 		error = -EXDEV;
 	else
-		error = vfs_quota_on_inode(nd.dentry->d_inode, type, format_id);
+		error = vfs_quota_on_inode(nd.path.dentry->d_inode, type,
+					   format_id);
 out_path:
 	path_release(&nd);
 	return error;
diff -puN fs/ecryptfs/dentry.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/ecryptfs/dentry.c
--- a/fs/ecryptfs/dentry.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/ecryptfs/dentry.c
@@ -51,13 +51,13 @@ static int ecryptfs_d_revalidate(struct 
 
 	if (!lower_dentry->d_op || !lower_dentry->d_op->d_revalidate)
 		goto out;
-	dentry_save = nd->dentry;
-	vfsmount_save = nd->mnt;
-	nd->dentry = lower_dentry;
-	nd->mnt = lower_mnt;
+	dentry_save = nd->path.dentry;
+	vfsmount_save = nd->path.mnt;
+	nd->path.dentry = lower_dentry;
+	nd->path.mnt = lower_mnt;
 	rc = lower_dentry->d_op->d_revalidate(lower_dentry, nd);
-	nd->dentry = dentry_save;
-	nd->mnt = vfsmount_save;
+	nd->path.dentry = dentry_save;
+	nd->path.mnt = vfsmount_save;
 	if (dentry->d_inode) {
 		struct inode *lower_inode =
 			ecryptfs_inode_to_lower(dentry->d_inode);
diff -puN fs/ecryptfs/inode.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/ecryptfs/inode.c
@@ -77,13 +77,13 @@ ecryptfs_create_underlying_file(struct i
 	struct vfsmount *vfsmount_save;
 	int rc;
 
-	dentry_save = nd->dentry;
-	vfsmount_save = nd->mnt;
-	nd->dentry = lower_dentry;
-	nd->mnt = lower_mnt;
+	dentry_save = nd->path.dentry;
+	vfsmount_save = nd->path.mnt;
+	nd->path.dentry = lower_dentry;
+	nd->path.mnt = lower_mnt;
 	rc = vfs_create(lower_dir_inode, lower_dentry, mode, nd);
-	nd->dentry = dentry_save;
-	nd->mnt = vfsmount_save;
+	nd->path.dentry = dentry_save;
+	nd->path.mnt = vfsmount_save;
 	return rc;
 }
 
@@ -831,14 +831,14 @@ ecryptfs_permission(struct inode *inode,
 	int rc;
 
         if (nd) {
-		struct vfsmount *vfsmnt_save = nd->mnt;
-		struct dentry *dentry_save = nd->dentry;
+		struct vfsmount *vfsmnt_save = nd->path.mnt;
+		struct dentry *dentry_save = nd->path.dentry;
 
-		nd->mnt = ecryptfs_dentry_to_lower_mnt(nd->dentry);
-		nd->dentry = ecryptfs_dentry_to_lower(nd->dentry);
+		nd->path.mnt = ecryptfs_dentry_to_lower_mnt(nd->path.dentry);
+		nd->path.dentry = ecryptfs_dentry_to_lower(nd->path.dentry);
 		rc = permission(ecryptfs_inode_to_lower(inode), mask, nd);
-		nd->mnt = vfsmnt_save;
-		nd->dentry = dentry_save;
+		nd->path.mnt = vfsmnt_save;
+		nd->path.dentry = dentry_save;
         } else
 		rc = permission(ecryptfs_inode_to_lower(inode), mask, NULL);
         return rc;
diff -puN fs/ecryptfs/main.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/ecryptfs/main.c
@@ -519,8 +519,8 @@ static int ecryptfs_read_super(struct su
 		ecryptfs_printk(KERN_WARNING, "path_lookup() failed\n");
 		goto out;
 	}
-	lower_root = nd.dentry;
-	lower_mnt = nd.mnt;
+	lower_root = nd.path.dentry;
+	lower_mnt = nd.path.mnt;
 	ecryptfs_set_superblock_lower(sb, lower_root->d_sb);
 	sb->s_maxbytes = lower_root->d_sb->s_maxbytes;
 	ecryptfs_set_dentry_lower(sb->s_root, lower_root);
diff -puN fs/exec.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/exec.c
--- a/fs/exec.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/exec.c
@@ -112,7 +112,7 @@ asmlinkage long sys_uselib(const char __
 		goto out;
 
 	error = -EINVAL;
-	if (!S_ISREG(nd.dentry->d_inode->i_mode))
+	if (!S_ISREG(nd.path.dentry->d_inode->i_mode))
 		goto exit;
 
 	error = vfs_permission(&nd, MAY_READ | MAY_EXEC);
@@ -652,7 +652,7 @@ struct file *open_exec(const char *name)
 	file = ERR_PTR(err);
 
 	if (!err) {
-		struct inode *inode = nd.dentry->d_inode;
+		struct inode *inode = nd.path.dentry->d_inode;
 		file = ERR_PTR(-EACCES);
 		if (S_ISREG(inode->i_mode)) {
 			int err = vfs_permission(&nd, MAY_EXEC);
diff -puN fs/ext3/super.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/ext3/super.c
--- a/fs/ext3/super.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/ext3/super.c
@@ -2763,12 +2763,12 @@ static int ext3_quota_on(struct super_bl
 	if (err)
 		return err;
 	/* Quotafile not on the same filesystem? */
-	if (nd.mnt->mnt_sb != sb) {
+	if (nd.path.mnt->mnt_sb != sb) {
 		path_release(&nd);
 		return -EXDEV;
 	}
 	/* Quotafile not of fs root? */
-	if (nd.dentry->d_parent->d_inode != sb->s_root->d_inode)
+	if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
 		printk(KERN_WARNING
 			"EXT3-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
diff -puN fs/ext4/super.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/ext4/super.c
--- a/fs/ext4/super.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/ext4/super.c
@@ -3061,12 +3061,12 @@ static int ext4_quota_on(struct super_bl
 	if (err)
 		return err;
 	/* Quotafile not on the same filesystem? */
-	if (nd.mnt->mnt_sb != sb) {
+	if (nd.path.mnt->mnt_sb != sb) {
 		path_release(&nd);
 		return -EXDEV;
 	}
 	/* Quotafile not of fs root? */
-	if (nd.dentry->d_parent->d_inode != sb->s_root->d_inode)
+	if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
 		printk(KERN_WARNING
 			"EXT4-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
diff -puN fs/gfs2/ops_fstype.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/gfs2/ops_fstype.c
--- a/fs/gfs2/ops_fstype.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/gfs2/ops_fstype.c
@@ -821,12 +821,13 @@ static struct super_block* get_gfs2_sb(c
 		       dev_name);
 		goto out;
 	}
-	error = vfs_getattr(nd.mnt, nd.dentry, &stat);
+	error = vfs_getattr(nd.path.mnt, nd.path.dentry, &stat);
 
 	fstype = get_fs_type("gfs2");
 	list_for_each_entry(s, &fstype->fs_supers, s_instances) {
 		if ((S_ISBLK(stat.mode) && s->s_dev == stat.rdev) ||
-		    (S_ISDIR(stat.mode) && s == nd.dentry->d_inode->i_sb)) {
+		    (S_ISDIR(stat.mode) &&
+		     s == nd.path.dentry->d_inode->i_sb)) {
 			sb = s;
 			goto free_nd;
 		}
diff -puN fs/inotify_user.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/inotify_user.c
--- a/fs/inotify_user.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/inotify_user.c
@@ -667,7 +667,7 @@ asmlinkage long sys_inotify_add_watch(in
 		goto fput_and_out;
 
 	/* inode held in place by reference to nd; dev by fget on fd */
-	inode = nd.dentry->d_inode;
+	inode = nd.path.dentry->d_inode;
 	dev = filp->private_data;
 
 	mutex_lock(&dev->up_mutex);
diff -puN fs/namei.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/namei.c
--- a/fs/namei.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/namei.c
@@ -231,7 +231,7 @@ int permission(struct inode *inode, int 
 	struct vfsmount *mnt = NULL;
 
 	if (nd)
-		mnt = nd->mnt;
+		mnt = nd->path.mnt;
 
 	if (mask & MAY_WRITE) {
 		umode_t mode = inode->i_mode;
@@ -296,7 +296,7 @@ int permission(struct inode *inode, int 
  */
 int vfs_permission(struct nameidata *nd, int mask)
 {
-	return permission(nd->dentry->d_inode, mask, nd);
+	return permission(nd->path.dentry->d_inode, mask, nd);
 }
 
 /**
@@ -364,8 +364,8 @@ int deny_write_access(struct file * file
 
 void path_release(struct nameidata *nd)
 {
-	dput(nd->dentry);
-	mntput(nd->mnt);
+	dput(nd->path.dentry);
+	mntput(nd->path.mnt);
 }
 
 /**
@@ -531,15 +531,15 @@ walk_init_root(const char *name, struct 
 
 	read_lock(&fs->lock);
 	if (fs->altroot && !(nd->flags & LOOKUP_NOALT)) {
-		nd->mnt = mntget(fs->altrootmnt);
-		nd->dentry = dget(fs->altroot);
+		nd->path.mnt = mntget(fs->altrootmnt);
+		nd->path.dentry = dget(fs->altroot);
 		read_unlock(&fs->lock);
 		if (__emul_lookup_dentry(name,nd))
 			return 0;
 		read_lock(&fs->lock);
 	}
-	nd->mnt = mntget(fs->rootmnt);
-	nd->dentry = dget(fs->root);
+	nd->path.mnt = mntget(fs->rootmnt);
+	nd->path.dentry = dget(fs->root);
 	read_unlock(&fs->lock);
 	return 1;
 }
@@ -582,17 +582,17 @@ fail:
 static inline void dput_path(struct path *path, struct nameidata *nd)
 {
 	dput(path->dentry);
-	if (path->mnt != nd->mnt)
+	if (path->mnt != nd->path.mnt)
 		mntput(path->mnt);
 }
 
 static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
 {
-	dput(nd->dentry);
-	if (nd->mnt != path->mnt)
-		mntput(nd->mnt);
-	nd->mnt = path->mnt;
-	nd->dentry = path->dentry;
+	dput(nd->path.dentry);
+	if (nd->path.mnt != path->mnt)
+		mntput(nd->path.mnt);
+	nd->path.mnt = path->mnt;
+	nd->path.dentry = path->dentry;
 }
 
 static __always_inline int __do_follow_link(struct path *path, struct nameidata *nd)
@@ -604,7 +604,7 @@ static __always_inline int __do_follow_l
 	touch_atime(path->mnt, dentry);
 	nd_set_link(nd, NULL);
 
-	if (path->mnt != nd->mnt) {
+	if (path->mnt != nd->path.mnt) {
 		path_to_nameidata(path, nd);
 		dget(dentry);
 	}
@@ -734,37 +734,37 @@ static __always_inline void follow_dotdo
 
 	while(1) {
 		struct vfsmount *parent;
-		struct dentry *old = nd->dentry;
+		struct dentry *old = nd->path.dentry;
 
                 read_lock(&fs->lock);
-		if (nd->dentry == fs->root &&
-		    nd->mnt == fs->rootmnt) {
+		if (nd->path.dentry == fs->root &&
+		    nd->path.mnt == fs->rootmnt) {
                         read_unlock(&fs->lock);
 			break;
 		}
                 read_unlock(&fs->lock);
 		spin_lock(&dcache_lock);
-		if (nd->dentry != nd->mnt->mnt_root) {
-			nd->dentry = dget(nd->dentry->d_parent);
+		if (nd->path.dentry != nd->path.mnt->mnt_root) {
+			nd->path.dentry = dget(nd->path.dentry->d_parent);
 			spin_unlock(&dcache_lock);
 			dput(old);
 			break;
 		}
 		spin_unlock(&dcache_lock);
 		spin_lock(&vfsmount_lock);
-		parent = nd->mnt->mnt_parent;
-		if (parent == nd->mnt) {
+		parent = nd->path.mnt->mnt_parent;
+		if (parent == nd->path.mnt) {
 			spin_unlock(&vfsmount_lock);
 			break;
 		}
 		mntget(parent);
-		nd->dentry = dget(nd->mnt->mnt_mountpoint);
+		nd->path.dentry = dget(nd->path.mnt->mnt_mountpoint);
 		spin_unlock(&vfsmount_lock);
 		dput(old);
-		mntput(nd->mnt);
-		nd->mnt = parent;
+		mntput(nd->path.mnt);
+		nd->path.mnt = parent;
 	}
-	follow_mount(&nd->mnt, &nd->dentry);
+	follow_mount(&nd->path.mnt, &nd->path.dentry);
 }
 
 /*
@@ -775,8 +775,8 @@ static __always_inline void follow_dotdo
 static int do_lookup(struct nameidata *nd, struct qstr *name,
 		     struct path *path)
 {
-	struct vfsmount *mnt = nd->mnt;
-	struct dentry *dentry = __d_lookup(nd->dentry, name);
+	struct vfsmount *mnt = nd->path.mnt;
+	struct dentry *dentry = __d_lookup(nd->path.dentry, name);
 
 	if (!dentry)
 		goto need_lookup;
@@ -789,7 +789,7 @@ done:
 	return 0;
 
 need_lookup:
-	dentry = real_lookup(nd->dentry, name, nd);
+	dentry = real_lookup(nd->path.dentry, name, nd);
 	if (IS_ERR(dentry))
 		goto fail;
 	goto done;
@@ -826,7 +826,7 @@ static fastcall int __link_path_walk(con
 	if (!*name)
 		goto return_reval;
 
-	inode = nd->dentry->d_inode;
+	inode = nd->path.dentry->d_inode;
 	if (nd->depth)
 		lookup_flags = LOOKUP_FOLLOW | (nd->flags & LOOKUP_CONTINUE);
 
@@ -874,7 +874,7 @@ static fastcall int __link_path_walk(con
 				if (this.name[1] != '.')
 					break;
 				follow_dotdot(nd);
-				inode = nd->dentry->d_inode;
+				inode = nd->path.dentry->d_inode;
 				/* fallthrough */
 			case 1:
 				continue;
@@ -883,8 +883,9 @@ static fastcall int __link_path_walk(con
 		 * See if the low-level filesystem might want
 		 * to use its own hash..
 		 */
-		if (nd->dentry->d_op && nd->dentry->d_op->d_hash) {
-			err = nd->dentry->d_op->d_hash(nd->dentry, &this);
+		if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash) {
+			err = nd->path.dentry->d_op->d_hash(nd->path.dentry,
+							    &this);
 			if (err < 0)
 				break;
 		}
@@ -906,7 +907,7 @@ static fastcall int __link_path_walk(con
 			if (err)
 				goto return_err;
 			err = -ENOENT;
-			inode = nd->dentry->d_inode;
+			inode = nd->path.dentry->d_inode;
 			if (!inode)
 				break;
 			err = -ENOTDIR; 
@@ -934,13 +935,14 @@ last_component:
 				if (this.name[1] != '.')
 					break;
 				follow_dotdot(nd);
-				inode = nd->dentry->d_inode;
+				inode = nd->path.dentry->d_inode;
 				/* fallthrough */
 			case 1:
 				goto return_reval;
 		}
-		if (nd->dentry->d_op && nd->dentry->d_op->d_hash) {
-			err = nd->dentry->d_op->d_hash(nd->dentry, &this);
+		if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash) {
+			err = nd->path.dentry->d_op->d_hash(nd->path.dentry,
+							    &this);
 			if (err < 0)
 				break;
 		}
@@ -953,7 +955,7 @@ last_component:
 			err = do_follow_link(&next, nd);
 			if (err)
 				goto return_err;
-			inode = nd->dentry->d_inode;
+			inode = nd->path.dentry->d_inode;
 		} else
 			path_to_nameidata(&next, nd);
 		err = -ENOENT;
@@ -981,11 +983,12 @@ return_reval:
 		 * We bypassed the ordinary revalidation routines.
 		 * We may need to check the cached dentry for staleness.
 		 */
-		if (nd->dentry && nd->dentry->d_sb &&
-		    (nd->dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT)) {
+		if (nd->path.dentry && nd->path.dentry->d_sb &&
+		    (nd->path.dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT)) {
 			err = -ESTALE;
 			/* Note: we do not d_invalidate() */
-			if (!nd->dentry->d_op->d_revalidate(nd->dentry, nd))
+			if (!nd->path.dentry->d_op->d_revalidate(
+					nd->path.dentry, nd))
 				break;
 		}
 return_base:
@@ -1012,20 +1015,20 @@ static int fastcall link_path_walk(const
 	int result;
 
 	/* make sure the stuff we saved doesn't go away */
-	dget(save.dentry);
-	mntget(save.mnt);
+	dget(save.path.dentry);
+	mntget(save.path.mnt);
 
 	result = __link_path_walk(name, nd);
 	if (result == -ESTALE) {
 		*nd = save;
-		dget(nd->dentry);
-		mntget(nd->mnt);
+		dget(nd->path.dentry);
+		mntget(nd->path.mnt);
 		nd->flags |= LOOKUP_REVAL;
 		result = __link_path_walk(name, nd);
 	}
 
-	dput(save.dentry);
-	mntput(save.mnt);
+	dput(save.path.dentry);
+	mntput(save.path.mnt);
 
 	return result;
 }
@@ -1045,9 +1048,10 @@ static int __emul_lookup_dentry(const ch
 	if (path_walk(name, nd))
 		return 0;		/* something went wrong... */
 
-	if (!nd->dentry->d_inode || S_ISDIR(nd->dentry->d_inode->i_mode)) {
-		struct dentry *old_dentry = nd->dentry;
-		struct vfsmount *old_mnt = nd->mnt;
+	if (!nd->path.dentry->d_inode ||
+	    S_ISDIR(nd->path.dentry->d_inode->i_mode)) {
+		struct dentry *old_dentry = nd->path.dentry;
+		struct vfsmount *old_mnt = nd->path.mnt;
 		struct qstr last = nd->last;
 		int last_type = nd->last_type;
 		struct fs_struct *fs = current->fs;
@@ -1058,19 +1062,19 @@ static int __emul_lookup_dentry(const ch
 		 */
 		nd->last_type = LAST_ROOT;
 		read_lock(&fs->lock);
-		nd->mnt = mntget(fs->rootmnt);
-		nd->dentry = dget(fs->root);
+		nd->path.mnt = mntget(fs->rootmnt);
+		nd->path.dentry = dget(fs->root);
 		read_unlock(&fs->lock);
 		if (path_walk(name, nd) == 0) {
-			if (nd->dentry->d_inode) {
+			if (nd->path.dentry->d_inode) {
 				dput(old_dentry);
 				mntput(old_mnt);
 				return 1;
 			}
 			path_release(nd);
 		}
-		nd->dentry = old_dentry;
-		nd->mnt = old_mnt;
+		nd->path.dentry = old_dentry;
+		nd->path.mnt = old_mnt;
 		nd->last = last;
 		nd->last_type = last_type;
 	}
@@ -1090,8 +1094,8 @@ void set_fs_altroot(void)
 		goto set_it;
 	err = path_lookup(emul, LOOKUP_FOLLOW|LOOKUP_DIRECTORY|LOOKUP_NOALT, &nd);
 	if (!err) {
-		mnt = nd.mnt;
-		dentry = nd.dentry;
+		mnt = nd.path.mnt;
+		dentry = nd.path.dentry;
 	}
 set_it:
 	write_lock(&fs->lock);
@@ -1122,20 +1126,20 @@ static int fastcall do_path_lookup(int d
 	if (*name=='/') {
 		read_lock(&fs->lock);
 		if (fs->altroot && !(nd->flags & LOOKUP_NOALT)) {
-			nd->mnt = mntget(fs->altrootmnt);
-			nd->dentry = dget(fs->altroot);
+			nd->path.mnt = mntget(fs->altrootmnt);
+			nd->path.dentry = dget(fs->altroot);
 			read_unlock(&fs->lock);
 			if (__emul_lookup_dentry(name,nd))
 				goto out; /* found in altroot */
 			read_lock(&fs->lock);
 		}
-		nd->mnt = mntget(fs->rootmnt);
-		nd->dentry = dget(fs->root);
+		nd->path.mnt = mntget(fs->rootmnt);
+		nd->path.dentry = dget(fs->root);
 		read_unlock(&fs->lock);
 	} else if (dfd == AT_FDCWD) {
 		read_lock(&fs->lock);
-		nd->mnt = mntget(fs->pwdmnt);
-		nd->dentry = dget(fs->pwd);
+		nd->path.mnt = mntget(fs->pwdmnt);
+		nd->path.dentry = dget(fs->pwd);
 		read_unlock(&fs->lock);
 	} else {
 		struct dentry *dentry;
@@ -1155,17 +1159,17 @@ static int fastcall do_path_lookup(int d
 		if (retval)
 			goto fput_fail;
 
-		nd->mnt = mntget(file->f_path.mnt);
-		nd->dentry = dget(dentry);
+		nd->path.mnt = mntget(file->f_path.mnt);
+		nd->path.dentry = dget(dentry);
 
 		fput_light(file, fput_needed);
 	}
 
 	retval = path_walk(name, nd);
 out:
-	if (unlikely(!retval && !audit_dummy_context() && nd->dentry &&
-				nd->dentry->d_inode))
-		audit_inode(name, nd->dentry);
+	if (unlikely(!retval && !audit_dummy_context() && nd->path.dentry &&
+				nd->path.dentry->d_inode))
+		audit_inode(name, nd->path.dentry);
 out_fail:
 	return retval;
 
@@ -1199,13 +1203,13 @@ int vfs_path_lookup(struct dentry *dentr
 	nd->flags = flags;
 	nd->depth = 0;
 
-	nd->mnt = mntget(mnt);
-	nd->dentry = dget(dentry);
+	nd->path.mnt = mntget(mnt);
+	nd->path.dentry = dget(dentry);
 
 	retval = path_walk(name, nd);
-	if (unlikely(!retval && !audit_dummy_context() && nd->dentry &&
-				nd->dentry->d_inode))
-		audit_inode(name, nd->dentry);
+	if (unlikely(!retval && !audit_dummy_context() && nd->path.dentry &&
+				nd->path.dentry->d_inode))
+		audit_inode(name, nd->path.dentry);
 
 	return retval;
 
@@ -1324,10 +1328,10 @@ static struct dentry *lookup_hash(struct
 {
 	int err;
 
-	err = permission(nd->dentry->d_inode, MAY_EXEC, nd);
+	err = permission(nd->path.dentry->d_inode, MAY_EXEC, nd);
 	if (err)
 		return ERR_PTR(err);
-	return __lookup_hash(&nd->last, nd->dentry, nd);
+	return __lookup_hash(&nd->last, nd->path.dentry, nd);
 }
 
 static int __lookup_one_len(const char *name, struct qstr *this,
@@ -1586,7 +1590,7 @@ int vfs_create(struct inode *dir, struct
 
 int may_open(struct nameidata *nd, int acc_mode, int flag)
 {
-	struct dentry *dentry = nd->dentry;
+	struct dentry *dentry = nd->path.dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
@@ -1607,7 +1611,7 @@ int may_open(struct nameidata *nd, int a
 	if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 	    	flag &= ~O_TRUNC;
 	} else if (S_ISBLK(inode->i_mode) || S_ISCHR(inode->i_mode)) {
-		if (nd->mnt->mnt_flags & MNT_NODEV)
+		if (nd->path.mnt->mnt_flags & MNT_NODEV)
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
@@ -1616,7 +1620,7 @@ int may_open(struct nameidata *nd, int a
 		 * effectively: !special_file()
 		 * balanced by __fput()
 		 */
-		error = mnt_want_write(nd->mnt);
+		error = mnt_want_write(nd->path.mnt);
 		if (error)
 			return error;
 	}
@@ -1676,14 +1680,14 @@ static int open_namei_create(struct name
 				int flag, int mode)
 {
 	int error;
-	struct dentry *dir = nd->dentry;
+	struct dentry *dir = nd->path.dentry;
 
 	if (!IS_POSIXACL(dir->d_inode))
 		mode &= ~current->fs->umask;
 	error = vfs_create(dir->d_inode, path->dentry, mode, nd);
 	mutex_unlock(&dir->d_inode->i_mutex);
-	dput(nd->dentry);
-	nd->dentry = path->dentry;
+	dput(nd->path.dentry);
+	nd->path.dentry = path->dentry;
 	if (error)
 		return error;
 	/* Don't check for write permission, don't truncate */
@@ -1750,11 +1754,11 @@ int open_namei(int dfd, const char *path
 	if (nd->last_type != LAST_NORM || nd->last.name[nd->last.len])
 		goto exit;
 
-	dir = nd->dentry;
+	dir = nd->path.dentry;
 	nd->flags &= ~LOOKUP_PARENT;
 	mutex_lock(&dir->d_inode->i_mutex);
 	path.dentry = lookup_hash(nd);
-	path.mnt = nd->mnt;
+	path.mnt = nd->path.mnt;
 
 do_last:
 	error = PTR_ERR(path.dentry);
@@ -1770,11 +1774,11 @@ do_last:
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode) {
-		error = mnt_want_write(nd->mnt);
+		error = mnt_want_write(nd->path.mnt);
 		if (error)
 			goto exit_mutex_unlock;
 		error = open_namei_create(nd, &path, flag, mode);
-		mnt_drop_write(nd->mnt);
+		mnt_drop_write(nd->path.mnt);
 		if (error)
 			goto exit;
 		return 0;
@@ -1864,10 +1868,10 @@ do_link:
 		__putname(nd->last.name);
 		goto exit;
 	}
-	dir = nd->dentry;
+	dir = nd->path.dentry;
 	mutex_lock(&dir->d_inode->i_mutex);
 	path.dentry = lookup_hash(nd);
-	path.mnt = nd->mnt;
+	path.mnt = nd->path.mnt;
 	__putname(nd->last.name);
 	goto do_last;
 }
@@ -1880,13 +1884,13 @@ do_link:
  * Simple function to lookup and return a dentry and create it
  * if it doesn't exist.  Is SMP-safe.
  *
- * Returns with nd->dentry->d_inode->i_mutex locked.
+ * Returns with nd->path.dentry->d_inode->i_mutex locked.
  */
 struct dentry *lookup_create(struct nameidata *nd, int is_dir)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
 
-	mutex_lock_nested(&nd->dentry->d_inode->i_mutex, I_MUTEX_PARENT);
+	mutex_lock_nested(&nd->path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	/*
 	 * Yucky last component or no last component at all?
 	 * (foo/., foo/.., /////)
@@ -1967,7 +1971,7 @@ asmlinkage long sys_mknodat(int dfd, con
 		error = PTR_ERR(dentry);
 		goto out_unlock;
 	}
-	if (!IS_POSIXACL(nd.dentry->d_inode))
+	if (!IS_POSIXACL(nd.path.dentry->d_inode))
 		mode &= ~current->fs->umask;
 	if (S_ISDIR(mode)) {
 		error = -EPERM;
@@ -1978,26 +1982,28 @@ asmlinkage long sys_mknodat(int dfd, con
 		error = -EINVAL;
 		goto out_dput;
 	}
-	error = mnt_want_write(nd.mnt);
+	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
 	switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
-			error = vfs_create(nd.dentry->d_inode,dentry,mode,&nd);
+			error = vfs_create(nd.path.dentry->d_inode, dentry,
+					   mode, &nd);
 			break;
 		case S_IFCHR: case S_IFBLK:
-			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,
-					new_decode_dev(dev));
+			error = vfs_mknod(nd.path.dentry->d_inode, dentry,
+					  mode, new_decode_dev(dev));
 			break;
 		case S_IFIFO: case S_IFSOCK:
-			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,0);
+			error = vfs_mknod(nd.path.dentry->d_inode, dentry,
+					  mode, 0);
 			break;
 	}
-	mnt_drop_write(nd.mnt);
+	mnt_drop_write(nd.path.mnt);
 out_dput:
 	dput(dentry);
 out_unlock:
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 	path_release(&nd);
 out:
 	putname(tmp);
@@ -2052,17 +2058,17 @@ asmlinkage long sys_mkdirat(int dfd, con
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
-	if (!IS_POSIXACL(nd.dentry->d_inode))
+	if (!IS_POSIXACL(nd.path.dentry->d_inode))
 		mode &= ~current->fs->umask;
-	error = mnt_want_write(nd.mnt);
+	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
-	error = vfs_mkdir(nd.dentry->d_inode, dentry, mode);
-	mnt_drop_write(nd.mnt);
+	error = vfs_mkdir(nd.path.dentry->d_inode, dentry, mode);
+	mnt_drop_write(nd.path.mnt);
 out_dput:
 	dput(dentry);
 out_unlock:
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 	path_release(&nd);
 out:
 	putname(tmp);
@@ -2161,20 +2167,20 @@ static long do_rmdir(int dfd, const char
 			error = -EBUSY;
 			goto exit1;
 	}
-	mutex_lock_nested(&nd.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
+	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	dentry = lookup_hash(&nd);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
-	error = mnt_want_write(nd.mnt);
+	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto exit3;
-	error = vfs_rmdir(nd.dentry->d_inode, dentry);
-	mnt_drop_write(nd.mnt);
+	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
+	mnt_drop_write(nd.path.mnt);
 exit3:
 	dput(dentry);
 exit2:
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 exit1:
 	path_release(&nd);
 exit:
@@ -2241,7 +2247,7 @@ static long do_unlinkat(int dfd, const c
 	error = -EISDIR;
 	if (nd.last_type != LAST_NORM)
 		goto exit1;
-	mutex_lock_nested(&nd.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
+	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	dentry = lookup_hash(&nd);
 	error = PTR_ERR(dentry);
 	if (!IS_ERR(dentry)) {
@@ -2251,15 +2257,15 @@ static long do_unlinkat(int dfd, const c
 		inode = dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
-		error = mnt_want_write(nd.mnt);
+		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
-		error = vfs_unlink(nd.dentry->d_inode, dentry);
-		mnt_drop_write(nd.mnt);
+		error = vfs_unlink(nd.path.dentry->d_inode, dentry);
+		mnt_drop_write(nd.path.mnt);
 	exit2:
 		dput(dentry);
 	}
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 	if (inode)
 		iput(inode);	/* truncate the inode here */
 exit1:
@@ -2336,15 +2342,15 @@ asmlinkage long sys_symlinkat(const char
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
-	error = mnt_want_write(nd.mnt);
+	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
-	error = vfs_symlink(nd.dentry->d_inode, dentry, from, S_IALLUGO);
-	mnt_drop_write(nd.mnt);
+	error = vfs_symlink(nd.path.dentry->d_inode, dentry, from, S_IALLUGO);
+	mnt_drop_write(nd.path.mnt);
 out_dput:
 	dput(dentry);
 out_unlock:
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 	path_release(&nd);
 out:
 	putname(to);
@@ -2430,21 +2436,21 @@ asmlinkage long sys_linkat(int olddfd, c
 	if (error)
 		goto out;
 	error = -EXDEV;
-	if (old_nd.mnt != nd.mnt)
+	if (old_nd.path.mnt != nd.path.mnt)
 		goto out_release;
 	new_dentry = lookup_create(&nd, 0);
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out_unlock;
-	error = mnt_want_write(nd.mnt);
+	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
-	error = vfs_link(old_nd.dentry, nd.dentry->d_inode, new_dentry);
-	mnt_drop_write(nd.mnt);
+	error = vfs_link(old_nd.path.dentry, nd.path.dentry->d_inode, new_dentry);
+	mnt_drop_write(nd.path.mnt);
 out_dput:
 	dput(new_dentry);
 out_unlock:
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 out_release:
 	path_release(&nd);
 out:
@@ -2624,15 +2630,15 @@ static int do_rename(int olddfd, const c
 		goto exit1;
 
 	error = -EXDEV;
-	if (oldnd.mnt != newnd.mnt)
+	if (oldnd.path.mnt != newnd.path.mnt)
 		goto exit2;
 
-	old_dir = oldnd.dentry;
+	old_dir = oldnd.path.dentry;
 	error = -EBUSY;
 	if (oldnd.last_type != LAST_NORM)
 		goto exit2;
 
-	new_dir = newnd.dentry;
+	new_dir = newnd.path.dentry;
 	if (newnd.last_type != LAST_NORM)
 		goto exit2;
 
@@ -2667,12 +2673,12 @@ static int do_rename(int olddfd, const c
 	if (new_dentry == trap)
 		goto exit5;
 
-	error = mnt_want_write(oldnd.mnt);
+	error = mnt_want_write(oldnd.path.mnt);
 	if (error)
 		goto exit5;
 	error = vfs_rename(old_dir->d_inode, old_dentry,
 				   new_dir->d_inode, new_dentry);
-	mnt_drop_write(oldnd.mnt);
+	mnt_drop_write(oldnd.path.mnt);
 exit5:
 	dput(new_dentry);
 exit4:
diff -puN fs/namespace.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/namespace.c
--- a/fs/namespace.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/namespace.c
@@ -392,13 +392,13 @@ static void __touch_mnt_namespace(struct
 
 static void detach_mnt(struct vfsmount *mnt, struct nameidata *old_nd)
 {
-	old_nd->dentry = mnt->mnt_mountpoint;
-	old_nd->mnt = mnt->mnt_parent;
+	old_nd->path.dentry = mnt->mnt_mountpoint;
+	old_nd->path.mnt = mnt->mnt_parent;
 	mnt->mnt_parent = mnt;
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	list_del_init(&mnt->mnt_child);
 	list_del_init(&mnt->mnt_hash);
-	old_nd->dentry->d_mounted--;
+	old_nd->path.dentry->d_mounted--;
 }
 
 void mnt_set_mountpoint(struct vfsmount *mnt, struct dentry *dentry,
@@ -411,10 +411,10 @@ void mnt_set_mountpoint(struct vfsmount 
 
 static void attach_mnt(struct vfsmount *mnt, struct nameidata *nd)
 {
-	mnt_set_mountpoint(nd->mnt, nd->dentry, mnt);
+	mnt_set_mountpoint(nd->path.mnt, nd->path.dentry, mnt);
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
-			hash(nd->mnt, nd->dentry));
-	list_add_tail(&mnt->mnt_child, &nd->mnt->mnt_mounts);
+			hash(nd->path.mnt, nd->path.dentry));
+	list_add_tail(&mnt->mnt_child, &nd->path.mnt->mnt_mounts);
 }
 
 /*
@@ -980,20 +980,20 @@ asmlinkage long sys_umount(char __user *
 	if (retval)
 		goto out;
 	retval = -EINVAL;
-	if (nd.dentry != nd.mnt->mnt_root)
+	if (nd.path.dentry != nd.path.mnt->mnt_root)
 		goto dput_and_out;
-	if (!check_mnt(nd.mnt))
+	if (!check_mnt(nd.path.mnt))
 		goto dput_and_out;
 
 	retval = -EPERM;
-	if (!permit_umount(nd.mnt, flags))
+	if (!permit_umount(nd.path.mnt, flags))
 		goto dput_and_out;
 
-	retval = do_umount(nd.mnt, flags);
+	retval = do_umount(nd.path.mnt, flags);
 dput_and_out:
 	/* we mustn't call path_put() as that would clear mnt_expiry_mark */
-	dput(nd.dentry);
-	mntput_no_expire(nd.mnt);
+	dput(nd.path.dentry);
+	mntput_no_expire(nd.path.mnt);
 out:
 	return retval;
 }
@@ -1018,7 +1018,7 @@ asmlinkage long sys_oldumount(char __use
 static bool permit_mount(struct nameidata *nd, struct file_system_type *type,
 			 int *flags)
 {
-	struct inode *inode = nd->dentry->d_inode;
+	struct inode *inode = nd->path.dentry->d_inode;
 
 	if (capable(CAP_SYS_ADMIN))
 		return true;
@@ -1029,10 +1029,10 @@ static bool permit_mount(struct nameidat
 	if (S_ISLNK(inode->i_mode))
 		return false;
 
-	if (nd->mnt->mnt_flags & MNT_NOMNT)
+	if (nd->path.mnt->mnt_flags & MNT_NOMNT)
 		return false;
 
-	if (!is_mount_owner(nd->mnt, current->fsuid))
+	if (!is_mount_owner(nd->path.mnt, current->fsuid))
 		return false;
 
 	*flags |= MS_SETUSER;
@@ -1079,8 +1079,8 @@ struct vfsmount *copy_tree(struct vfsmou
 				q = q->mnt_parent;
 			}
 			p = s;
-			nd.mnt = q;
-			nd.dentry = p->mnt_mountpoint;
+			nd.path.mnt = q;
+			nd.path.dentry = p->mnt_mountpoint;
 			q = clone_mnt(p, p->mnt_root, flag, owner);
 			if (IS_ERR(q))
 				goto error;
@@ -1189,8 +1189,8 @@ static int attach_recursive_mnt(struct v
 			struct nameidata *nd, struct nameidata *parent_nd)
 {
 	LIST_HEAD(tree_list);
-	struct vfsmount *dest_mnt = nd->mnt;
-	struct dentry *dest_dentry = nd->dentry;
+	struct vfsmount *dest_mnt = nd->path.mnt;
+	struct dentry *dest_dentry = nd->path.dentry;
 	struct vfsmount *child, *p;
 
 	if (propagate_mnt(dest_mnt, dest_dentry, source_mnt, &tree_list))
@@ -1225,13 +1225,13 @@ static int graft_tree(struct vfsmount *m
 	if (mnt->mnt_sb->s_flags & MS_NOUSER)
 		return -EINVAL;
 
-	if (S_ISDIR(nd->dentry->d_inode->i_mode) !=
+	if (S_ISDIR(nd->path.dentry->d_inode->i_mode) !=
 	      S_ISDIR(mnt->mnt_root->d_inode->i_mode))
 		return -ENOTDIR;
 
 	err = -ENOENT;
-	mutex_lock(&nd->dentry->d_inode->i_mutex);
-	if (IS_DEADDIR(nd->dentry->d_inode))
+	mutex_lock(&nd->path.dentry->d_inode->i_mutex);
+	if (IS_DEADDIR(nd->path.dentry->d_inode))
 		goto out_unlock;
 
 	err = security_sb_check_sb(mnt, nd);
@@ -1239,10 +1239,10 @@ static int graft_tree(struct vfsmount *m
 		goto out_unlock;
 
 	err = -ENOENT;
-	if (IS_ROOT(nd->dentry) || !d_unhashed(nd->dentry))
+	if (IS_ROOT(nd->path.dentry) || !d_unhashed(nd->path.dentry))
 		err = attach_recursive_mnt(mnt, nd, NULL);
 out_unlock:
-	mutex_unlock(&nd->dentry->d_inode->i_mutex);
+	mutex_unlock(&nd->path.dentry->d_inode->i_mutex);
 	if (!err)
 		security_sb_post_addmount(mnt, nd);
 	return err;
@@ -1253,14 +1253,14 @@ out_unlock:
  */
 static int do_change_type(struct nameidata *nd, int flag)
 {
-	struct vfsmount *m, *mnt = nd->mnt;
+	struct vfsmount *m, *mnt = nd->path.mnt;
 	int recurse = flag & MS_REC;
 	int type = flag & ~MS_REC;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (nd->dentry != nd->mnt->mnt_root)
+	if (nd->path.dentry != nd->path.mnt->mnt_root)
 		return -EINVAL;
 
 	down_write(&namespace_sem);
@@ -1293,10 +1293,10 @@ static int do_loopback(struct nameidata 
 
 	down_write(&namespace_sem);
 	err = -EINVAL;
-	if (IS_MNT_UNBINDABLE(old_nd.mnt))
- 		goto out;
+	if (IS_MNT_UNBINDABLE(old_nd.path.mnt))
+		goto out;
 
-	if (!check_mnt(nd->mnt) || !check_mnt(old_nd.mnt))
+	if (!check_mnt(nd->path.mnt) || !check_mnt(old_nd.path.mnt))
 		goto out;
 
 	if (flags & MS_SETUSER) {
@@ -1305,9 +1305,11 @@ static int do_loopback(struct nameidata 
 	}
 
 	if (flags & MS_REC)
-		mnt = copy_tree(old_nd.mnt, old_nd.dentry, clone_flags, owner);
+		mnt = copy_tree(old_nd.path.mnt, old_nd.path.dentry,
+				clone_flags, owner);
 	else
-		mnt = clone_mnt(old_nd.mnt, old_nd.dentry, clone_flags, owner);
+		mnt = clone_mnt(old_nd.path.mnt, old_nd.path.dentry,
+				clone_flags, owner);
 
 	err = PTR_ERR(mnt);
 	if (IS_ERR(mnt))
@@ -1354,31 +1356,31 @@ static int do_remount(struct nameidata *
 		      void *data)
 {
 	int err;
-	struct super_block *sb = nd->mnt->mnt_sb;
+	struct super_block *sb = nd->path.mnt->mnt_sb;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!check_mnt(nd->mnt))
+	if (!check_mnt(nd->path.mnt))
 		return -EINVAL;
 
-	if (nd->dentry != nd->mnt->mnt_root)
+	if (nd->path.dentry != nd->path.mnt->mnt_root)
 		return -EINVAL;
 
 	down_write(&sb->s_umount);
 	if (flags & MS_BIND)
-		err = change_mount_flags(nd->mnt, flags);
+		err = change_mount_flags(nd->path.mnt, flags);
 	else
 		err = do_remount_sb(sb, flags, data, 0);
 	if (!err) {
-		clear_mnt_user(nd->mnt);
-		nd->mnt->mnt_flags = mnt_flags;
+		clear_mnt_user(nd->path.mnt);
+		nd->path.mnt->mnt_flags = mnt_flags;
 		if (flags & MS_SETUSER)
-			set_mnt_user(nd->mnt);
+			set_mnt_user(nd->path.mnt);
 	}
 	up_write(&sb->s_umount);
 	if (!err)
-		security_sb_post_remount(nd->mnt, flags, data);
+		security_sb_post_remount(nd->path.mnt, flags, data);
 	return err;
 }
 
@@ -1406,56 +1408,60 @@ static int do_move_mount(struct nameidat
 		return err;
 
 	down_write(&namespace_sem);
-	while (d_mountpoint(nd->dentry) && follow_down(&nd->mnt, &nd->dentry))
+	while (d_mountpoint(nd->path.dentry) &&
+	       follow_down(&nd->path.mnt, &nd->path.dentry))
 		;
 	err = -EINVAL;
-	if (!check_mnt(nd->mnt) || !check_mnt(old_nd.mnt))
+	if (!check_mnt(nd->path.mnt) || !check_mnt(old_nd.path.mnt))
 		goto out;
 
 	err = -ENOENT;
-	mutex_lock(&nd->dentry->d_inode->i_mutex);
-	if (IS_DEADDIR(nd->dentry->d_inode))
+	mutex_lock(&nd->path.dentry->d_inode->i_mutex);
+	if (IS_DEADDIR(nd->path.dentry->d_inode))
 		goto out1;
 
-	if (!IS_ROOT(nd->dentry) && d_unhashed(nd->dentry))
+	if (!IS_ROOT(nd->path.dentry) && d_unhashed(nd->path.dentry))
 		goto out1;
 
 	err = -EINVAL;
-	if (old_nd.dentry != old_nd.mnt->mnt_root)
+	if (old_nd.path.dentry != old_nd.path.mnt->mnt_root)
 		goto out1;
 
-	if (old_nd.mnt == old_nd.mnt->mnt_parent)
+	if (old_nd.path.mnt == old_nd.path.mnt->mnt_parent)
 		goto out1;
 
-	if (S_ISDIR(nd->dentry->d_inode->i_mode) !=
-	      S_ISDIR(old_nd.dentry->d_inode->i_mode))
+	if (S_ISDIR(nd->path.dentry->d_inode->i_mode) !=
+	      S_ISDIR(old_nd.path.dentry->d_inode->i_mode))
 		goto out1;
 	/*
 	 * Don't move a mount residing in a shared parent.
 	 */
-	if (old_nd.mnt->mnt_parent && IS_MNT_SHARED(old_nd.mnt->mnt_parent))
+	if (old_nd.path.mnt->mnt_parent &&
+	    IS_MNT_SHARED(old_nd.path.mnt->mnt_parent))
 		goto out1;
 	/*
 	 * Don't move a mount tree containing unbindable mounts to a destination
 	 * mount which is shared.
 	 */
-	if (IS_MNT_SHARED(nd->mnt) && tree_contains_unbindable(old_nd.mnt))
+	if (IS_MNT_SHARED(nd->path.mnt) &&
+	    tree_contains_unbindable(old_nd.path.mnt))
 		goto out1;
 	err = -ELOOP;
-	for (p = nd->mnt; p->mnt_parent != p; p = p->mnt_parent)
-		if (p == old_nd.mnt)
+	for (p = nd->path.mnt; p->mnt_parent != p; p = p->mnt_parent)
+		if (p == old_nd.path.mnt)
 			goto out1;
 
-	if ((err = attach_recursive_mnt(old_nd.mnt, nd, &parent_nd)))
+	err = attach_recursive_mnt(old_nd.path.mnt, nd, &parent_nd);
+	if (err)
 		goto out1;
 
 	spin_lock(&vfsmount_lock);
 	/* if the mount is moved, it should no longer be expire
 	 * automatically */
-	list_del_init(&old_nd.mnt->mnt_expire);
+	list_del_init(&old_nd.path.mnt->mnt_expire);
 	spin_unlock(&vfsmount_lock);
 out1:
-	mutex_unlock(&nd->dentry->d_inode->i_mutex);
+	mutex_unlock(&nd->path.dentry->d_inode->i_mutex);
 out:
 	up_write(&namespace_sem);
 	if (!err)
@@ -1547,16 +1553,17 @@ int do_add_mount(struct vfsmount *newmnt
 
 	down_write(&namespace_sem);
 	/* Something was mounted here while we slept */
-	while (d_mountpoint(nd->dentry) && follow_down(&nd->mnt, &nd->dentry))
+	while (d_mountpoint(nd->path.dentry) &&
+	       follow_down(&nd->path.mnt, &nd->path.dentry))
 		;
 	err = -EINVAL;
-	if (!check_mnt(nd->mnt))
+	if (!check_mnt(nd->path.mnt))
 		goto unlock;
 
 	/* Refuse the same filesystem on the same mount point */
 	err = -EBUSY;
-	if (nd->mnt->mnt_sb == newmnt->mnt_sb &&
-	    nd->mnt->mnt_root == nd->dentry)
+	if (nd->path.mnt->mnt_sb == newmnt->mnt_sb &&
+	    nd->path.mnt->mnt_root == nd->path.dentry)
 		goto unlock;
 
 	err = -EINVAL;
@@ -2087,12 +2094,14 @@ static void chroot_fs_refs(struct nameid
 		if (fs) {
 			atomic_inc(&fs->count);
 			task_unlock(p);
-			if (fs->root == old_nd->dentry
-			    && fs->rootmnt == old_nd->mnt)
-				set_fs_root(fs, new_nd->mnt, new_nd->dentry);
-			if (fs->pwd == old_nd->dentry
-			    && fs->pwdmnt == old_nd->mnt)
-				set_fs_pwd(fs, new_nd->mnt, new_nd->dentry);
+			if (fs->root == old_nd->path.dentry
+			    && fs->rootmnt == old_nd->path.mnt)
+				set_fs_root(fs, new_nd->path.mnt,
+					    new_nd->path.dentry);
+			if (fs->pwd == old_nd->path.dentry
+			    && fs->pwdmnt == old_nd->path.mnt)
+				set_fs_pwd(fs, new_nd->path.mnt,
+					   new_nd->path.dentry);
 			put_fs_struct(fs);
 		} else
 			task_unlock(p);
@@ -2142,7 +2151,7 @@ asmlinkage long sys_pivot_root(const cha
 	if (error)
 		goto out0;
 	error = -EINVAL;
-	if (!check_mnt(new_nd.mnt))
+	if (!check_mnt(new_nd.path.mnt))
 		goto out1;
 
 	error = __user_walk(put_old, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &old_nd);
@@ -2156,55 +2165,59 @@ asmlinkage long sys_pivot_root(const cha
 	}
 
 	read_lock(&current->fs->lock);
-	user_nd.mnt = mntget(current->fs->rootmnt);
-	user_nd.dentry = dget(current->fs->root);
+	user_nd.path.mnt = mntget(current->fs->rootmnt);
+	user_nd.path.dentry = dget(current->fs->root);
 	read_unlock(&current->fs->lock);
 	down_write(&namespace_sem);
-	mutex_lock(&old_nd.dentry->d_inode->i_mutex);
+	mutex_lock(&old_nd.path.dentry->d_inode->i_mutex);
 	error = -EINVAL;
-	if (IS_MNT_SHARED(old_nd.mnt) ||
-		IS_MNT_SHARED(new_nd.mnt->mnt_parent) ||
-		IS_MNT_SHARED(user_nd.mnt->mnt_parent))
+	if (IS_MNT_SHARED(old_nd.path.mnt) ||
+		IS_MNT_SHARED(new_nd.path.mnt->mnt_parent) ||
+		IS_MNT_SHARED(user_nd.path.mnt->mnt_parent))
 		goto out2;
-	if (!check_mnt(user_nd.mnt))
+	if (!check_mnt(user_nd.path.mnt))
 		goto out2;
 	error = -ENOENT;
-	if (IS_DEADDIR(new_nd.dentry->d_inode))
+	if (IS_DEADDIR(new_nd.path.dentry->d_inode))
 		goto out2;
-	if (d_unhashed(new_nd.dentry) && !IS_ROOT(new_nd.dentry))
+	if (d_unhashed(new_nd.path.dentry) && !IS_ROOT(new_nd.path.dentry))
 		goto out2;
-	if (d_unhashed(old_nd.dentry) && !IS_ROOT(old_nd.dentry))
+	if (d_unhashed(old_nd.path.dentry) && !IS_ROOT(old_nd.path.dentry))
 		goto out2;
 	error = -EBUSY;
-	if (new_nd.mnt == user_nd.mnt || old_nd.mnt == user_nd.mnt)
+	if (new_nd.path.mnt == user_nd.path.mnt ||
+	    old_nd.path.mnt == user_nd.path.mnt)
 		goto out2; /* loop, on the same file system  */
 	error = -EINVAL;
-	if (user_nd.mnt->mnt_root != user_nd.dentry)
+	if (user_nd.path.mnt->mnt_root != user_nd.path.dentry)
 		goto out2; /* not a mountpoint */
-	if (user_nd.mnt->mnt_parent == user_nd.mnt)
+	if (user_nd.path.mnt->mnt_parent == user_nd.path.mnt)
 		goto out2; /* not attached */
-	if (new_nd.mnt->mnt_root != new_nd.dentry)
+	if (new_nd.path.mnt->mnt_root != new_nd.path.dentry)
 		goto out2; /* not a mountpoint */
-	if (new_nd.mnt->mnt_parent == new_nd.mnt)
+	if (new_nd.path.mnt->mnt_parent == new_nd.path.mnt)
 		goto out2; /* not attached */
-	tmp = old_nd.mnt; /* make sure we can reach put_old from new_root */
+	/* make sure we can reach put_old from new_root */
+	tmp = old_nd.path.mnt;
 	spin_lock(&vfsmount_lock);
-	if (tmp != new_nd.mnt) {
+	if (tmp != new_nd.path.mnt) {
 		for (;;) {
 			if (tmp->mnt_parent == tmp)
 				goto out3; /* already mounted on put_old */
-			if (tmp->mnt_parent == new_nd.mnt)
+			if (tmp->mnt_parent == new_nd.path.mnt)
 				break;
 			tmp = tmp->mnt_parent;
 		}
-		if (!is_subdir(tmp->mnt_mountpoint, new_nd.dentry))
+		if (!is_subdir(tmp->mnt_mountpoint, new_nd.path.dentry))
 			goto out3;
-	} else if (!is_subdir(old_nd.dentry, new_nd.dentry))
+	} else if (!is_subdir(old_nd.path.dentry, new_nd.path.dentry))
 		goto out3;
-	detach_mnt(new_nd.mnt, &parent_nd);
-	detach_mnt(user_nd.mnt, &root_parent);
-	attach_mnt(user_nd.mnt, &old_nd);     /* mount old root on put_old */
-	attach_mnt(new_nd.mnt, &root_parent); /* mount new_root on / */
+	detach_mnt(new_nd.path.mnt, &parent_nd);
+	detach_mnt(user_nd.path.mnt, &root_parent);
+	/* mount old root on put_old */
+	attach_mnt(user_nd.path.mnt, &old_nd);
+	/* mount new_root on / */
+	attach_mnt(new_nd.path.mnt, &root_parent);
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
 	spin_unlock(&vfsmount_lock);
 	chroot_fs_refs(&user_nd, &new_nd);
@@ -2213,7 +2226,7 @@ asmlinkage long sys_pivot_root(const cha
 	path_release(&root_parent);
 	path_release(&parent_nd);
 out2:
-	mutex_unlock(&old_nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&old_nd.path.dentry->d_inode->i_mutex);
 	up_write(&namespace_sem);
 	path_release(&user_nd);
 	path_release(&old_nd);
diff -puN fs/nfs/dir.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/nfs/dir.c
--- a/fs/nfs/dir.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/nfs/dir.c
@@ -949,7 +949,7 @@ static int is_atomic_open(struct inode *
 	if (nd->flags & LOOKUP_DIRECTORY)
 		return 0;
 	/* Are we trying to write to a read only partition? */
-	if (__mnt_is_readonly(nd->mnt) &&
+	if (__mnt_is_readonly(nd->path.mnt) &&
 	    (nd->intent.open.flags & (O_CREAT|O_TRUNC|FMODE_WRITE)))
 		return 0;
 	return 1;
diff -puN fs/nfs/namespace.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/nfs/namespace.c
--- a/fs/nfs/namespace.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/nfs/namespace.c
@@ -107,38 +107,40 @@ static void * nfs_follow_mountpoint(stru
 
 	BUG_ON(IS_ROOT(dentry));
 	dprintk("%s: enter\n", __FUNCTION__);
-	dput(nd->dentry);
-	nd->dentry = dget(dentry);
+	dput(nd->path.dentry);
+	nd->path.dentry = dget(dentry);
 
 	/* Look it up again */
-	parent = dget_parent(nd->dentry);
+	parent = dget_parent(nd->path.dentry);
 	err = server->nfs_client->rpc_ops->lookup(parent->d_inode,
-						  &nd->dentry->d_name,
+						  &nd->path.dentry->d_name,
 						  &fh, &fattr);
 	dput(parent);
 	if (err != 0)
 		goto out_err;
 
 	if (fattr.valid & NFS_ATTR_FATTR_V4_REFERRAL)
-		mnt = nfs_do_refmount(nd->mnt, nd->dentry);
+		mnt = nfs_do_refmount(nd->path.mnt, nd->path.dentry);
 	else
-		mnt = nfs_do_submount(nd->mnt, nd->dentry, &fh, &fattr);
+		mnt = nfs_do_submount(nd->path.mnt, nd->path.dentry, &fh,
+				      &fattr);
 	err = PTR_ERR(mnt);
 	if (IS_ERR(mnt))
 		goto out_err;
 
 	mntget(mnt);
-	err = do_add_mount(mnt, nd, nd->mnt->mnt_flags|MNT_SHRINKABLE, &nfs_automount_list);
+	err = do_add_mount(mnt, nd, nd->path.mnt->mnt_flags|MNT_SHRINKABLE,
+			   &nfs_automount_list);
 	if (err < 0) {
 		mntput(mnt);
 		if (err == -EBUSY)
 			goto out_follow;
 		goto out_err;
 	}
-	mntput(nd->mnt);
-	dput(nd->dentry);
-	nd->mnt = mnt;
-	nd->dentry = dget(mnt->mnt_root);
+	mntput(nd->path.mnt);
+	dput(nd->path.dentry);
+	nd->path.mnt = mnt;
+	nd->path.dentry = dget(mnt->mnt_root);
 	schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
 out:
 	dprintk("%s: done, returned %d\n", __FUNCTION__, err);
@@ -149,7 +151,8 @@ out_err:
 	path_release(nd);
 	goto out;
 out_follow:
-	while(d_mountpoint(nd->dentry) && follow_down(&nd->mnt, &nd->dentry))
+	while (d_mountpoint(nd->path.dentry) &&
+	       follow_down(&nd->path.mnt, &nd->path.dentry))
 		;
 	err = 0;
 	goto out;
diff -puN fs/nfs/nfs4proc.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/nfs/nfs4proc.c
@@ -1376,10 +1376,7 @@ struct dentry *
 nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	struct dentry *parent;
-	struct path path = {
-		.mnt = nd->mnt,
-		.dentry = dentry,
-	};
+	struct path path = nd->path;
 	struct iattr attr;
 	struct rpc_cred *cred;
 	struct nfs4_state *state;
@@ -1423,10 +1420,7 @@ nfs4_atomic_open(struct inode *dir, stru
 int
 nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, struct nameidata *nd)
 {
-	struct path path = {
-		.mnt = nd->mnt,
-		.dentry = dentry,
-	};
+	struct path path = nd->path;
 	struct rpc_cred *cred;
 	struct nfs4_state *state;
 
@@ -1875,10 +1869,7 @@ static int
 nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
                  int flags, struct nameidata *nd)
 {
-	struct path path = {
-		.mnt = nd->mnt,
-		.dentry = dentry,
-	};
+	struct path path = nd->path;
 	struct nfs4_state *state;
 	struct rpc_cred *cred;
 	int status = 0;
diff -puN fs/nfsctl.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/nfsctl.c
--- a/fs/nfsctl.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/nfsctl.c
@@ -41,7 +41,7 @@ static struct file *do_open(char *name, 
 		error = may_open(&nd, MAY_WRITE, FMODE_WRITE);
 
 	if (!error)
-		return dentry_open(nd.dentry, nd.mnt, flags);
+		return dentry_open(nd.path.dentry, nd.path.mnt, flags);
 
 	path_release(&nd);
 	return ERR_PTR(error);
diff -puN fs/nfsd/export.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/nfsd/export.c
--- a/fs/nfsd/export.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/nfsd/export.c
@@ -169,8 +169,8 @@ static int expkey_parse(struct cache_det
 			goto out;
 
 		dprintk("Found the path %s\n", buf);
-		key.ek_mnt = nd.mnt;
-		key.ek_dentry = nd.dentry;
+		key.ek_mnt = nd.path.mnt;
+		key.ek_dentry = nd.path.dentry;
 		
 		ek = svc_expkey_update(&key, ek);
 		if (ek)
@@ -507,7 +507,7 @@ static int svc_export_parse(struct cache
 	struct svc_export exp, *expp;
 	int an_int;
 
-	nd.dentry = NULL;
+	nd.path.dentry = NULL;
 	exp.ex_path = NULL;
 
 	/* fs locations */
@@ -547,8 +547,8 @@ static int svc_export_parse(struct cache
 
 	exp.h.flags = 0;
 	exp.ex_client = dom;
-	exp.ex_mnt = nd.mnt;
-	exp.ex_dentry = nd.dentry;
+	exp.ex_mnt = nd.path.mnt;
+	exp.ex_dentry = nd.path.dentry;
 	exp.ex_path = kstrdup(buf, GFP_KERNEL);
 	err = -ENOMEM;
 	if (!exp.ex_path)
@@ -610,7 +610,7 @@ static int svc_export_parse(struct cache
 				goto out;
 		}
 
-		err = check_export(nd.dentry->d_inode, exp.ex_flags,
+		err = check_export(nd.path.dentry->d_inode, exp.ex_flags,
 				   exp.ex_uuid);
 		if (err) goto out;
 	}
@@ -629,7 +629,7 @@ static int svc_export_parse(struct cache
 	nfsd4_fslocs_free(&exp.ex_fslocs);
 	kfree(exp.ex_uuid);
  	kfree(exp.ex_path);
-	if (nd.dentry)
+	if (nd.path.dentry)
 		path_release(&nd);
  out_no_path:
 	if (dom)
@@ -1030,7 +1030,7 @@ exp_export(struct nfsctl_export *nxp)
 		goto out_unlock;
 	err = -EINVAL;
 
-	exp = exp_get_by_name(clp, nd.mnt, nd.dentry, NULL);
+	exp = exp_get_by_name(clp, nd.path.mnt, nd.path.dentry, NULL);
 
 	memset(&new, 0, sizeof(new));
 
@@ -1038,7 +1038,8 @@ exp_export(struct nfsctl_export *nxp)
 	if ((nxp->ex_flags & NFSEXP_FSID) &&
 	    (!IS_ERR(fsid_key = exp_get_fsid_key(clp, nxp->ex_dev))) &&
 	    fsid_key->ek_mnt &&
-	    (fsid_key->ek_mnt != nd.mnt || fsid_key->ek_dentry != nd.dentry) )
+	    (fsid_key->ek_mnt != nd.path.mnt ||
+	     fsid_key->ek_dentry != nd.path.dentry))
 		goto finish;
 
 	if (!IS_ERR(exp)) {
@@ -1054,7 +1055,7 @@ exp_export(struct nfsctl_export *nxp)
 		goto finish;
 	}
 
-	err = check_export(nd.dentry->d_inode, nxp->ex_flags, NULL);
+	err = check_export(nd.path.dentry->d_inode, nxp->ex_flags, NULL);
 	if (err) goto finish;
 
 	err = -ENOMEM;
@@ -1067,8 +1068,8 @@ exp_export(struct nfsctl_export *nxp)
 	if (!new.ex_path)
 		goto finish;
 	new.ex_client = clp;
-	new.ex_mnt = nd.mnt;
-	new.ex_dentry = nd.dentry;
+	new.ex_mnt = nd.path.mnt;
+	new.ex_dentry = nd.path.dentry;
 	new.ex_flags = nxp->ex_flags;
 	new.ex_anon_uid = nxp->ex_anon_uid;
 	new.ex_anon_gid = nxp->ex_anon_gid;
@@ -1148,7 +1149,7 @@ exp_unexport(struct nfsctl_export *nxp)
 		goto out_domain;
 
 	err = -EINVAL;
-	exp = exp_get_by_name(dom, nd.mnt, nd.dentry, NULL);
+	exp = exp_get_by_name(dom, nd.path.mnt, nd.path.dentry, NULL);
 	path_release(&nd);
 	if (IS_ERR(exp))
 		goto out_domain;
@@ -1185,12 +1186,12 @@ exp_rootfh(svc_client *clp, char *path, 
 		printk("nfsd: exp_rootfh path not found %s", path);
 		return err;
 	}
-	inode = nd.dentry->d_inode;
+	inode = nd.path.dentry->d_inode;
 
 	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%ld)\n",
-		 path, nd.dentry, clp->name,
+		 path, nd.path.dentry, clp->name,
 		 inode->i_sb->s_id, inode->i_ino);
-	exp = exp_parent(clp, nd.mnt, nd.dentry, NULL);
+	exp = exp_parent(clp, nd.path.mnt, nd.path.dentry, NULL);
 	if (IS_ERR(exp)) {
 		err = PTR_ERR(exp);
 		goto out;
@@ -1200,7 +1201,7 @@ exp_rootfh(svc_client *clp, char *path, 
 	 * fh must be initialized before calling fh_compose
 	 */
 	fh_init(&fh, maxsize);
-	if (fh_compose(&fh, exp, nd.dentry, NULL))
+	if (fh_compose(&fh, exp, nd.path.dentry, NULL))
 		err = -EINVAL;
 	else
 		err = 0;
diff -puN fs/nfsd/nfs4recover.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/nfsd/nfs4recover.c
--- a/fs/nfsd/nfs4recover.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/nfsd/nfs4recover.c
@@ -120,9 +120,9 @@ out_no_tfm:
 static void
 nfsd4_sync_rec_dir(void)
 {
-	mutex_lock(&rec_dir.dentry->d_inode->i_mutex);
-	nfsd_sync_dir(rec_dir.dentry);
-	mutex_unlock(&rec_dir.dentry->d_inode->i_mutex);
+	mutex_lock(&rec_dir.path.dentry->d_inode->i_mutex);
+	nfsd_sync_dir(rec_dir.path.dentry);
+	mutex_unlock(&rec_dir.path.dentry->d_inode->i_mutex);
 }
 
 int
@@ -142,9 +142,9 @@ nfsd4_create_clid_dir(struct nfs4_client
 	nfs4_save_user(&uid, &gid);
 
 	/* lock the parent */
-	mutex_lock(&rec_dir.dentry->d_inode->i_mutex);
+	mutex_lock(&rec_dir.path.dentry->d_inode->i_mutex);
 
-	dentry = lookup_one_len(dname, rec_dir.dentry, HEXDIR_LEN-1);
+	dentry = lookup_one_len(dname, rec_dir.path.dentry, HEXDIR_LEN-1);
 	if (IS_ERR(dentry)) {
 		status = PTR_ERR(dentry);
 		goto out_unlock;
@@ -154,15 +154,15 @@ nfsd4_create_clid_dir(struct nfs4_client
 		dprintk("NFSD: nfsd4_create_clid_dir: DIRECTORY EXISTS\n");
 		goto out_put;
 	}
-	status = mnt_want_write(rec_dir.mnt);
+	status = mnt_want_write(rec_dir.path.mnt);
 	if (status)
 		goto out_put;
-	status = vfs_mkdir(rec_dir.dentry->d_inode, dentry, S_IRWXU);
-	mnt_drop_write(rec_dir.mnt);
+	status = vfs_mkdir(rec_dir.path.dentry->d_inode, dentry, S_IRWXU);
+	mnt_drop_write(rec_dir.path.mnt);
 out_put:
 	dput(dentry);
 out_unlock:
-	mutex_unlock(&rec_dir.dentry->d_inode->i_mutex);
+	mutex_unlock(&rec_dir.path.dentry->d_inode->i_mutex);
 	if (status == 0) {
 		clp->cl_firststate = 1;
 		nfsd4_sync_rec_dir();
@@ -225,7 +225,7 @@ nfsd4_list_rec_dir(struct dentry *dir, r
 
 	nfs4_save_user(&uid, &gid);
 
-	filp = dentry_open(dget(dir), mntget(rec_dir.mnt), O_RDONLY);
+	filp = dentry_open(dget(dir), mntget(rec_dir.path.mnt), O_RDONLY);
 	status = PTR_ERR(filp);
 	if (IS_ERR(filp))
 		goto out;
@@ -290,9 +290,9 @@ nfsd4_unlink_clid_dir(char *name, int na
 
 	dprintk("NFSD: nfsd4_unlink_clid_dir. name %.*s\n", namlen, name);
 
-	mutex_lock(&rec_dir.dentry->d_inode->i_mutex);
-	dentry = lookup_one_len(name, rec_dir.dentry, namlen);
-	mutex_unlock(&rec_dir.dentry->d_inode->i_mutex);
+	mutex_lock(&rec_dir.path.dentry->d_inode->i_mutex);
+	dentry = lookup_one_len(name, rec_dir.path.dentry, namlen);
+	mutex_unlock(&rec_dir.path.dentry->d_inode->i_mutex);
 	if (IS_ERR(dentry)) {
 		status = PTR_ERR(dentry);
 		return status;
@@ -301,7 +301,7 @@ nfsd4_unlink_clid_dir(char *name, int na
 	if (!dentry->d_inode)
 		goto out;
 
-	status = nfsd4_clear_clid_dir(rec_dir.dentry, dentry);
+	status = nfsd4_clear_clid_dir(rec_dir.path.dentry, dentry);
 out:
 	dput(dentry);
 	return status;
@@ -351,12 +351,12 @@ nfsd4_recdir_purge_old(void) {
 
 	if (!rec_dir_init)
 		return;
-	status = nfsd4_list_rec_dir(rec_dir.dentry, purge_old);
+	status = nfsd4_list_rec_dir(rec_dir.path.dentry, purge_old);
 	if (status == 0)
 		nfsd4_sync_rec_dir();
 	if (status)
 		printk("nfsd4: failed to purge old clients from recovery"
-			" directory %s\n", rec_dir.dentry->d_name.name);
+			" directory %s\n", rec_dir.path.dentry->d_name.name);
 	return;
 }
 
@@ -377,10 +377,10 @@ int
 nfsd4_recdir_load(void) {
 	int status;
 
-	status = nfsd4_list_rec_dir(rec_dir.dentry, load_recdir);
+	status = nfsd4_list_rec_dir(rec_dir.path.dentry, load_recdir);
 	if (status)
 		printk("nfsd4: failed loading clients from recovery"
-			" directory %s\n", rec_dir.dentry->d_name.name);
+			" directory %s\n", rec_dir.path.dentry->d_name.name);
 	return status;
 }
 
diff -puN fs/nfsd/nfs4state.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/nfsd/nfs4state.c
@@ -3326,7 +3326,7 @@ nfs4_reset_recoverydir(char *recdir)
 	if (status)
 		return status;
 	status = -ENOTDIR;
-	if (S_ISDIR(nd.dentry->d_inode->i_mode)) {
+	if (S_ISDIR(nd.path.dentry->d_inode->i_mode)) {
 		nfs4_set_recdir(recdir);
 		status = 0;
 	}
diff -puN fs/open.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/open.c
--- a/fs/open.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/open.c
@@ -127,7 +127,7 @@ asmlinkage long sys_statfs(const char __
 	error = user_path_walk(path, &nd);
 	if (!error) {
 		struct statfs tmp;
-		error = vfs_statfs_native(nd.dentry, &tmp);
+		error = vfs_statfs_native(nd.path.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
 		path_release(&nd);
@@ -146,7 +146,7 @@ asmlinkage long sys_statfs64(const char 
 	error = user_path_walk(path, &nd);
 	if (!error) {
 		struct statfs64 tmp;
-		error = vfs_statfs64(nd.dentry, &tmp);
+		error = vfs_statfs64(nd.path.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
 		path_release(&nd);
@@ -233,7 +233,7 @@ static long do_sys_truncate(const char _
 	error = user_path_walk(path, &nd);
 	if (error)
 		goto out;
-	inode = nd.dentry->d_inode;
+	inode = nd.path.dentry->d_inode;
 
 	/* For directories it's -EISDIR, for other non-regulars - -EINVAL */
 	error = -EISDIR;
@@ -244,7 +244,7 @@ static long do_sys_truncate(const char _
 	if (!S_ISREG(inode->i_mode))
 		goto dput_and_out;
 
-	error = mnt_want_write(nd.mnt);
+	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto dput_and_out;
 
@@ -271,13 +271,13 @@ static long do_sys_truncate(const char _
 	error = locks_verify_truncate(inode, NULL, length);
 	if (!error) {
 		DQUOT_INIT(inode);
-		error = do_truncate(nd.dentry, length, 0, NULL);
+		error = do_truncate(nd.path.dentry, length, 0, NULL);
 	}
 
 put_write_and_out:
 	put_write_access(inode);
 mnt_drop_write_and_out:
-	mnt_drop_write(nd.mnt);
+	mnt_drop_write(nd.path.mnt);
 dput_and_out:
 	path_release(&nd);
 out:
@@ -457,7 +457,7 @@ asmlinkage long sys_faccessat(int dfd, c
 	res = vfs_permission(&nd, mode);
 	/* SuS v2 requires we report a read only fs too */
 	if(res || !(mode & S_IWOTH) ||
-	   special_file(nd.dentry->d_inode->i_mode))
+	   special_file(nd.path.dentry->d_inode->i_mode))
 		goto out_path_release;
 	/*
 	 * This is a rare case where using __mnt_is_readonly()
@@ -469,7 +469,7 @@ asmlinkage long sys_faccessat(int dfd, c
 	 * inherently racy and know that the fs may change
 	 * state before we even see this result.
 	 */
-	if (__mnt_is_readonly(nd.mnt))
+	if (__mnt_is_readonly(nd.path.mnt))
 		res = -EROFS;
 
 out_path_release:
@@ -501,7 +501,7 @@ asmlinkage long sys_chdir(const char __u
 	if (error)
 		goto dput_and_out;
 
-	set_fs_pwd(current->fs, nd.mnt, nd.dentry);
+	set_fs_pwd(current->fs, nd.path.mnt, nd.path.dentry);
 
 dput_and_out:
 	path_release(&nd);
@@ -556,7 +556,7 @@ asmlinkage long sys_chroot(const char __
 	if (!capable(CAP_SYS_CHROOT))
 		goto dput_and_out;
 
-	set_fs_root(current->fs, nd.mnt, nd.dentry);
+	set_fs_root(current->fs, nd.path.mnt, nd.path.dentry);
 	set_fs_altroot();
 	error = 0;
 dput_and_out:
@@ -615,9 +615,9 @@ asmlinkage long sys_fchmodat(int dfd, co
 	error = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW, &nd);
 	if (error)
 		goto out;
-	inode = nd.dentry->d_inode;
+	inode = nd.path.dentry->d_inode;
 
-	error = mnt_want_write(nd.mnt);
+	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto dput_and_out;
 
@@ -630,11 +630,11 @@ asmlinkage long sys_fchmodat(int dfd, co
 		mode = inode->i_mode;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	error = notify_change(nd.dentry, &newattrs);
+	error = notify_change(nd.path.dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
 out_drop_write:
-	mnt_drop_write(nd.mnt);
+	mnt_drop_write(nd.path.mnt);
 dput_and_out:
 	path_release(&nd);
 out:
@@ -687,11 +687,11 @@ asmlinkage long sys_chown(const char __u
 	error = user_path_walk(filename, &nd);
 	if (error)
 		goto out;
-	error = mnt_want_write(nd.mnt);
+	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(nd.dentry, user, group);
-	mnt_drop_write(nd.mnt);
+	error = chown_common(nd.path.dentry, user, group);
+	mnt_drop_write(nd.path.mnt);
 out_release:
 	path_release(&nd);
 out:
@@ -712,11 +712,11 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = __user_walk_fd(dfd, filename, follow, &nd);
 	if (error)
 		goto out;
-	error = mnt_want_write(nd.mnt);
+	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(nd.dentry, user, group);
-	mnt_drop_write(nd.mnt);
+	error = chown_common(nd.path.dentry, user, group);
+	mnt_drop_write(nd.path.mnt);
 out_release:
 	path_release(&nd);
 out:
@@ -731,11 +731,11 @@ asmlinkage long sys_lchown(const char __
 	error = user_path_walk_link(filename, &nd);
 	if (error)
 		goto out;
-	error = mnt_want_write(nd.mnt);
+	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(nd.dentry, user, group);
-	mnt_drop_write(nd.mnt);
+	error = chown_common(nd.path.dentry, user, group);
+	mnt_drop_write(nd.path.mnt);
 out_release:
 	path_release(&nd);
 out:
@@ -895,7 +895,7 @@ struct file *lookup_instantiate_filp(str
 		goto out;
 	if (IS_ERR(dentry))
 		goto out_err;
-	nd->intent.open.file = __dentry_open(dget(dentry), mntget(nd->mnt),
+	nd->intent.open.file = __dentry_open(dget(dentry), mntget(nd->path.mnt),
 					     nd->intent.open.flags - 1,
 					     nd->intent.open.file,
 					     open);
@@ -923,7 +923,8 @@ struct file *nameidata_to_filp(struct na
 	filp = nd->intent.open.file;
 	/* Has the filesystem initialised the file for us? */
 	if (filp->f_path.dentry == NULL)
-		filp = __dentry_open(nd->dentry, nd->mnt, flags, filp, NULL);
+		filp = __dentry_open(nd->path.dentry, nd->path.mnt, flags, filp,
+				     NULL);
 	else
 		path_release(nd);
 	return filp;
diff -puN fs/proc/base.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/proc/base.c
--- a/fs/proc/base.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/proc/base.c
@@ -1035,7 +1035,8 @@ static void *proc_pid_follow_link(struct
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(inode, &nd->dentry, &nd->mnt);
+	error = PROC_I(inode)->op.proc_get_link(inode, &nd->path.dentry,
+						&nd->path.mnt);
 	nd->last_type = LAST_BIND;
 out:
 	return ERR_PTR(error);
diff -puN fs/proc/proc_net.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/proc/proc_net.c
--- a/fs/proc/proc_net.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/proc/proc_net.c
@@ -92,11 +92,11 @@ static void *proc_net_follow_link(struct
 	if (!shadow)
 		return ERR_PTR(-ENOENT);
 
-	dput(nd->dentry);
+	dput(nd->path.dentry);
 	/* My dentry count is 1 and that should be enough as the
 	 * shadow dentry is thrown away immediately.
 	 */
-	nd->dentry = shadow;
+	nd->path.dentry = shadow;
 	return NULL;
 }
 
@@ -106,12 +106,12 @@ static struct dentry *proc_net_lookup(st
 	struct net *net = current->nsproxy->net_ns;
 	struct dentry *shadow;
 
-	shadow = proc_net_shadow_dentry(nd->dentry, net->proc_net);
+	shadow = proc_net_shadow_dentry(nd->path.dentry, net->proc_net);
 	if (!shadow)
 		return ERR_PTR(-ENOENT);
 
-	dput(nd->dentry);
-	nd->dentry = shadow;
+	dput(nd->path.dentry);
+	nd->path.dentry = shadow;
 
 	return shadow->d_inode->i_op->lookup(shadow->d_inode, dentry, nd);
 }
diff -puN fs/proc/proc_sysctl.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/proc/proc_sysctl.c
@@ -407,7 +407,7 @@ static int proc_sys_permission(struct in
 	if (!nd || !depth)
 		goto out;
 
-	dentry = nd->dentry;
+	dentry = nd->path.dentry;
 	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
 
 	/* If the entry does not exist deny permission */
diff -puN fs/reiserfs/super.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/reiserfs/super.c
@@ -2012,12 +2012,12 @@ static int reiserfs_quota_on(struct supe
 	if (err)
 		return err;
 	/* Quotafile not on the same filesystem? */
-	if (nd.mnt->mnt_sb != sb) {
+	if (nd.path.mnt->mnt_sb != sb) {
 		path_release(&nd);
 		return -EXDEV;
 	}
 	/* We must not pack tails for quota files on reiserfs for quota IO to work */
-	if (!REISERFS_I(nd.dentry->d_inode)->i_flags & i_nopack_mask) {
+	if (!REISERFS_I(nd.path.dentry->d_inode)->i_flags & i_nopack_mask) {
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file must have tail packing disabled.");
 		path_release(&nd);
@@ -2030,7 +2030,7 @@ static int reiserfs_quota_on(struct supe
 		return vfs_quota_on(sb, type, format_id, path);
 	}
 	/* Quotafile not of fs root? */
-	if (nd.dentry->d_parent->d_inode != sb->s_root->d_inode)
+	if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file not on filesystem root. "
 				 "Journalled quota will not work.");
diff -puN fs/revoke.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/revoke.c
--- a/fs/revoke.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/revoke.c
@@ -649,7 +649,7 @@ asmlinkage long sys_revokeat(int dfd, co
 
 	err = __user_walk_fd(dfd, filename, 0, &nd);
 	if (!err) {
-		err = do_revoke(nd.dentry->d_inode, NULL);
+		err = do_revoke(nd.path.dentry->d_inode, NULL);
 		path_release(&nd);
 	}
 	return err;
diff -puN fs/stat.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/stat.c
--- a/fs/stat.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/stat.c
@@ -62,7 +62,7 @@ int vfs_stat_fd(int dfd, char __user *na
 
 	error = __user_walk_fd(dfd, name, LOOKUP_FOLLOW, &nd);
 	if (!error) {
-		error = vfs_getattr(nd.mnt, nd.dentry, stat);
+		error = vfs_getattr(nd.path.mnt, nd.path.dentry, stat);
 		path_release(&nd);
 	}
 	return error;
@@ -82,7 +82,7 @@ int vfs_lstat_fd(int dfd, char __user *n
 
 	error = __user_walk_fd(dfd, name, 0, &nd);
 	if (!error) {
-		error = vfs_getattr(nd.mnt, nd.dentry, stat);
+		error = vfs_getattr(nd.path.mnt, nd.path.dentry, stat);
 		path_release(&nd);
 	}
 	return error;
@@ -302,14 +302,15 @@ asmlinkage long sys_readlinkat(int dfd, 
 
 	error = __user_walk_fd(dfd, path, 0, &nd);
 	if (!error) {
-		struct inode * inode = nd.dentry->d_inode;
+		struct inode *inode = nd.path.dentry->d_inode;
 
 		error = -EINVAL;
 		if (inode->i_op && inode->i_op->readlink) {
-			error = security_inode_readlink(nd.dentry);
+			error = security_inode_readlink(nd.path.dentry);
 			if (!error) {
-				touch_atime(nd.mnt, nd.dentry);
-				error = inode->i_op->readlink(nd.dentry, buf, bufsiz);
+				touch_atime(nd.path.mnt, nd.path.dentry);
+				error = inode->i_op->readlink(nd.path.dentry,
+							      buf, bufsiz);
 			}
 		}
 		path_release(&nd);
diff -puN fs/utimes.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/utimes.c
--- a/fs/utimes.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/utimes.c
@@ -86,8 +86,8 @@ long do_utimes(int dfd, char __user *fil
 		if (error)
 			goto out;
 
-		dentry = nd.dentry;
-		mnt = nd.mnt;
+		dentry = nd.path.dentry;
+		mnt = nd.path.mnt;
 	}
 
 	inode = dentry->d_inode;
diff -puN fs/xattr.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/xattr.c
--- a/fs/xattr.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/xattr.c
@@ -261,11 +261,11 @@ sys_setxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = mnt_want_write(nd.mnt);
+	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		return error;
-	error = setxattr(nd.dentry, name, value, size, flags);
-	mnt_drop_write(nd.mnt);
+	error = setxattr(nd.path.dentry, name, value, size, flags);
+	mnt_drop_write(nd.path.mnt);
 	path_release(&nd);
 	return error;
 }
@@ -280,11 +280,11 @@ sys_lsetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = mnt_want_write(nd.mnt);
+	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		return error;
-	error = setxattr(nd.dentry, name, value, size, flags);
-	mnt_drop_write(nd.mnt);
+	error = setxattr(nd.path.dentry, name, value, size, flags);
+	mnt_drop_write(nd.path.mnt);
 	path_release(&nd);
 	return error;
 }
@@ -359,7 +359,7 @@ sys_getxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.dentry, name, value, size);
+	error = getxattr(nd.path.dentry, name, value, size);
 	path_release(&nd);
 	return error;
 }
@@ -374,7 +374,7 @@ sys_lgetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.dentry, name, value, size);
+	error = getxattr(nd.path.dentry, name, value, size);
 	path_release(&nd);
 	return error;
 }
@@ -433,7 +433,7 @@ sys_listxattr(char __user *path, char __
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.dentry, list, size);
+	error = listxattr(nd.path.dentry, list, size);
 	path_release(&nd);
 	return error;
 }
@@ -447,7 +447,7 @@ sys_llistxattr(char __user *path, char _
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.dentry, list, size);
+	error = listxattr(nd.path.dentry, list, size);
 	path_release(&nd);
 	return error;
 }
@@ -494,7 +494,7 @@ sys_removexattr(char __user *path, char 
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.dentry, name);
+	error = removexattr(nd.path.dentry, name);
 	path_release(&nd);
 	return error;
 }
@@ -508,7 +508,7 @@ sys_lremovexattr(char __user *path, char
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.dentry, name);
+	error = removexattr(nd.path.dentry, name);
 	path_release(&nd);
 	return error;
 }
diff -puN fs/xfs/linux-2.6/xfs_ioctl.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt fs/xfs/linux-2.6/xfs_ioctl.c
--- a/fs/xfs/linux-2.6/xfs_ioctl.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -91,9 +91,9 @@ xfs_find_handle(
 		if (error)
 			return error;
 
-		ASSERT(nd.dentry);
-		ASSERT(nd.dentry->d_inode);
-		inode = igrab(nd.dentry->d_inode);
+		ASSERT(nd.path.dentry);
+		ASSERT(nd.path.dentry->d_inode);
+		inode = igrab(nd.path.dentry->d_inode);
 		path_release(&nd);
 		break;
 	}
diff -puN include/linux/namei.h~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt include/linux/namei.h
--- a/include/linux/namei.h~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/include/linux/namei.h
@@ -17,8 +17,7 @@ struct open_intent {
 enum { MAX_NESTED_LINKS = 8 };
 
 struct nameidata {
-	struct dentry	*dentry;
-	struct vfsmount *mnt;
+	struct path	path;
 	struct qstr	last;
 	unsigned int	flags;
 	int		last_type;
diff -puN kernel/audit_tree.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt kernel/audit_tree.c
--- a/kernel/audit_tree.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/kernel/audit_tree.c
@@ -549,7 +549,7 @@ void audit_trim_trees(void)
 		if (err)
 			goto skip_it;
 
-		root_mnt = collect_mounts(nd.mnt, nd.dentry);
+		root_mnt = collect_mounts(nd.path.mnt, nd.path.dentry);
 		path_release(&nd);
 		if (!root_mnt)
 			goto skip_it;
@@ -583,17 +583,17 @@ skip_it:
 static int is_under(struct vfsmount *mnt, struct dentry *dentry,
 		    struct nameidata *nd)
 {
-	if (mnt != nd->mnt) {
+	if (mnt != nd->path.mnt) {
 		for (;;) {
 			if (mnt->mnt_parent == mnt)
 				return 0;
-			if (mnt->mnt_parent == nd->mnt)
+			if (mnt->mnt_parent == nd->path.mnt)
 					break;
 			mnt = mnt->mnt_parent;
 		}
 		dentry = mnt->mnt_mountpoint;
 	}
-	return is_subdir(dentry, nd->dentry);
+	return is_subdir(dentry, nd->path.dentry);
 }
 
 int audit_make_tree(struct audit_krule *rule, char *pathname, u32 op)
@@ -641,7 +641,7 @@ int audit_add_tree_rule(struct audit_kru
 	err = path_lookup(tree->pathname, 0, &nd);
 	if (err)
 		goto Err;
-	mnt = collect_mounts(nd.mnt, nd.dentry);
+	mnt = collect_mounts(nd.path.mnt, nd.path.dentry);
 	path_release(&nd);
 	if (!mnt) {
 		err = -ENOMEM;
@@ -701,7 +701,7 @@ int audit_tag_tree(char *old, char *new)
 	err = path_lookup(new, 0, &nd);
 	if (err)
 		return err;
-	tagged = collect_mounts(nd.mnt, nd.dentry);
+	tagged = collect_mounts(nd.path.mnt, nd.path.dentry);
 	path_release(&nd);
 	if (!tagged)
 		return -ENOMEM;
@@ -711,8 +711,8 @@ int audit_tag_tree(char *old, char *new)
 		drop_collected_mounts(tagged);
 		return err;
 	}
-	mnt = mntget(nd.mnt);
-	dentry = dget(nd.dentry);
+	mnt = mntget(nd.path.mnt);
+	dentry = dget(nd.path.dentry);
 	path_release(&nd);
 
 	if (dentry == tagged->mnt_root && dentry == mnt->mnt_root)
diff -puN kernel/auditfilter.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt kernel/auditfilter.c
--- a/kernel/auditfilter.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/kernel/auditfilter.c
@@ -167,8 +167,8 @@ static struct audit_parent *audit_init_p
 	inotify_init_watch(&parent->wdata);
 	/* grab a ref so inotify watch hangs around until we take audit_filter_mutex */
 	get_inotify_watch(&parent->wdata);
-	wd = inotify_add_watch(audit_ih, &parent->wdata, ndp->dentry->d_inode,
-			       AUDIT_IN_WATCH);
+	wd = inotify_add_watch(audit_ih, &parent->wdata,
+			       ndp->path.dentry->d_inode, AUDIT_IN_WATCH);
 	if (wd < 0) {
 		audit_free_parent(&parent->wdata);
 		return ERR_PTR(wd);
@@ -1205,8 +1205,8 @@ static int audit_add_watch(struct audit_
 
 	/* update watch filter fields */
 	if (ndw) {
-		watch->dev = ndw->dentry->d_inode->i_sb->s_dev;
-		watch->ino = ndw->dentry->d_inode->i_ino;
+		watch->dev = ndw->path.dentry->d_inode->i_sb->s_dev;
+		watch->ino = ndw->path.dentry->d_inode->i_ino;
 	}
 
 	/* The audit_filter_mutex must not be held during inotify calls because
@@ -1216,7 +1216,8 @@ static int audit_add_watch(struct audit_
 	 */
 	mutex_unlock(&audit_filter_mutex);
 
-	if (inotify_find_watch(audit_ih, ndp->dentry->d_inode, &i_watch) < 0) {
+	if (inotify_find_watch(audit_ih, ndp->path.dentry->d_inode,
+			       &i_watch) < 0) {
 		parent = audit_init_parent(ndp);
 		if (IS_ERR(parent)) {
 			/* caller expects mutex locked */
diff -puN net/sunrpc/rpc_pipe.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/net/sunrpc/rpc_pipe.c
@@ -657,7 +657,8 @@ rpc_lookup_negative(char *path, struct n
 
 	if ((error = rpc_lookup_parent(path, nd)) != 0)
 		return ERR_PTR(error);
-	dentry = rpc_lookup_create(nd->dentry, nd->last.name, nd->last.len, 1);
+	dentry = rpc_lookup_create(nd->path.dentry, nd->last.name, nd->last.len,
+				   1);
 	if (IS_ERR(dentry))
 		rpc_release_path(nd);
 	return dentry;
@@ -675,7 +676,7 @@ rpc_mkdir(char *path, struct rpc_clnt *r
 	dentry = rpc_lookup_negative(path, &nd);
 	if (IS_ERR(dentry))
 		return dentry;
-	dir = nd.dentry->d_inode;
+	dir = nd.path.dentry->d_inode;
 	if ((error = __rpc_mkdir(dir, dentry)) != 0)
 		goto err_dput;
 	RPC_I(dentry->d_inode)->private = rpc_client;
diff -puN net/unix/af_unix.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt net/unix/af_unix.c
--- a/net/unix/af_unix.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/net/unix/af_unix.c
@@ -734,7 +734,7 @@ static struct sock *unix_find_other(stru
 		if (err)
 			goto fail;
 
-		err = mnt_want_write(nd.mnt);
+		err = mnt_want_write(nd.path.mnt);
 		if (err)
 			goto put_path_fail;
 
@@ -743,16 +743,16 @@ static struct sock *unix_find_other(stru
 			goto mnt_drop_write_fail;
 
 		err = -ECONNREFUSED;
-		if (!S_ISSOCK(nd.dentry->d_inode->i_mode))
+		if (!S_ISSOCK(nd.path.dentry->d_inode->i_mode))
 			goto mnt_drop_write_fail;
-		u=unix_find_socket_byinode(nd.dentry->d_inode);
+		u=unix_find_socket_byinode(nd.path.dentry->d_inode);
 		if (!u)
 			goto mnt_drop_write_fail;
 
 		if (u->sk_type == type)
-			touch_atime(nd.mnt, nd.dentry);
+			touch_atime(nd.path.mnt, nd.path.dentry);
 
-		mnt_drop_write(nd.mnt);
+		mnt_drop_write(nd.path.mnt);
 		path_release(&nd);
 
 		err=-EPROTOTYPE;
@@ -774,7 +774,7 @@ static struct sock *unix_find_other(stru
 	return u;
 
 mnt_drop_write_fail:
-	mnt_drop_write(nd.mnt);
+	mnt_drop_write(nd.path.mnt);
 put_path_fail:
 	path_release(&nd);
 fail:
@@ -846,16 +846,16 @@ static int unix_bind(struct socket *sock
 		 */
 		mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current->fs->umask);
-		err = mnt_want_write(nd.mnt);
+		err = mnt_want_write(nd.path.mnt);
 		if (err)
 			goto out_mknod_dput;
-		err = vfs_mknod(nd.dentry->d_inode, dentry, mode, 0);
-		mnt_drop_write(nd.mnt);
+		err = vfs_mknod(nd.path.dentry->d_inode, dentry, mode, 0);
+		mnt_drop_write(nd.path.mnt);
 		if (err)
 			goto out_mknod_dput;
-		mutex_unlock(&nd.dentry->d_inode->i_mutex);
-		dput(nd.dentry);
-		nd.dentry = dentry;
+		mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+		dput(nd.path.dentry);
+		nd.path.dentry = dentry;
 
 		addr->hash = UNIX_HASH_SIZE;
 	}
@@ -873,8 +873,8 @@ static int unix_bind(struct socket *sock
 		list = &unix_socket_table[addr->hash];
 	} else {
 		list = &unix_socket_table[dentry->d_inode->i_ino & (UNIX_HASH_SIZE-1)];
-		u->dentry = nd.dentry;
-		u->mnt    = nd.mnt;
+		u->dentry = nd.path.dentry;
+		u->mnt    = nd.path.mnt;
 	}
 
 	err = 0;
@@ -892,7 +892,7 @@ out:
 out_mknod_dput:
 	dput(dentry);
 out_mknod_unlock:
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 	path_release(&nd);
 out_mknod_parent:
 	if (err==-EEXIST)
diff -puN security/selinux/hooks.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt security/selinux/hooks.c
--- a/security/selinux/hooks.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
+++ a/security/selinux/hooks.c
@@ -2065,10 +2065,10 @@ static int selinux_mount(char * dev_name
 		return rc;
 
 	if (flags & MS_REMOUNT)
-		return superblock_has_perm(current, nd->mnt->mnt_sb,
+		return superblock_has_perm(current, nd->path.mnt->mnt_sb,
 		                           FILESYSTEM__REMOUNT, NULL);
 	else
-		return dentry_has_perm(current, nd->mnt, nd->dentry,
+		return dentry_has_perm(current, nd->path.mnt, nd->path.dentry,
 		                       FILE__MOUNTON);
 }
 
_

Patches currently in -mm which might be from jblunck@suse.de are

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
