From: akpm@linux-foundation.org
Subject: - introduce-path_put.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:43 -0500
Message-ID: <200802150720.m1F7K6Wq025786__47542.4988814213$1203060643$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52985 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763951AbYBOH3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:29:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, agruen@suse.de, hch@lst.de, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Introduce path_put()
has been removed from the -mm tree.  Its filename was
     introduce-path_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Introduce path_put()
From: Jan Blunck <jblunck@suse.de>

* Add path_put() functions for releasing a reference to the dentry and
  vfsmount of a struct path in the right order

* Switch from path_release(nd) to path_put(&nd->path)

* Rename dput_path() to path_put_conditional()

[akpm@linux-foundation.org: fix cifs]
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c                  |    2 
 arch/mips/kernel/sysirix.c                   |    6 -
 arch/parisc/hpux/sys_hpux.c                  |    2 
 arch/powerpc/platforms/cell/spufs/syscalls.c |    2 
 arch/sparc64/solaris/fs.c                    |    4 -
 drivers/md/dm-table.c                        |    2 
 drivers/mtd/mtdsuper.c                       |    4 -
 fs/afs/mntpt.c                               |    2 
 fs/autofs4/root.c                            |    2 
 fs/block_dev.c                               |    2 
 fs/cifs/cifs_dfs_ref.c                       |    2 
 fs/coda/pioctl.c                             |    4 -
 fs/compat.c                                  |    4 -
 fs/configfs/symlink.c                        |    4 -
 fs/dquot.c                                   |    2 
 fs/ecryptfs/main.c                           |    2 
 fs/exec.c                                    |    4 -
 fs/ext3/super.c                              |    4 -
 fs/ext4/super.c                              |    4 -
 fs/gfs2/ops_fstype.c                         |    2 
 fs/inotify_user.c                            |    4 -
 fs/namei.c                                   |   56 +++++++++--------
 fs/namespace.c                               |   20 +++---
 fs/nfs/namespace.c                           |    2 
 fs/nfsctl.c                                  |    2 
 fs/nfsd/export.c                             |   10 +--
 fs/nfsd/nfs4recover.c                        |    2 
 fs/nfsd/nfs4state.c                          |    2 
 fs/open.c                                    |   22 +++---
 fs/proc/base.c                               |    2 
 fs/reiserfs/super.c                          |    8 +-
 fs/stat.c                                    |    6 -
 fs/utimes.c                                  |    2 
 fs/xattr.c                                   |   16 ++--
 fs/xfs/linux-2.6/xfs_ioctl.c                 |    2 
 include/linux/namei.h                        |    1 
 include/linux/path.h                         |    2 
 kernel/audit_tree.c                          |   12 +--
 kernel/auditfilter.c                         |    4 -
 net/sunrpc/rpc_pipe.c                        |    2 
 net/unix/af_unix.c                           |    6 -
 41 files changed, 125 insertions(+), 118 deletions(-)

diff -puN arch/alpha/kernel/osf_sys.c~introduce-path_put arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~introduce-path_put
+++ a/arch/alpha/kernel/osf_sys.c
@@ -260,7 +260,7 @@ osf_statfs(char __user *path, struct osf
 	retval = user_path_walk(path, &nd);
 	if (!retval) {
 		retval = do_osf_statfs(nd.path.dentry, buffer, bufsiz);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return retval;
 }
diff -puN arch/mips/kernel/sysirix.c~introduce-path_put arch/mips/kernel/sysirix.c
--- a/arch/mips/kernel/sysirix.c~introduce-path_put
+++ a/arch/mips/kernel/sysirix.c
@@ -711,7 +711,7 @@ asmlinkage int irix_statfs(const char __
 	}
 
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -1385,7 +1385,7 @@ asmlinkage int irix_statvfs(char __user 
 		error |= __put_user(0, &buf->f_fstr[i]);
 
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -1636,7 +1636,7 @@ asmlinkage int irix_statvfs64(char __use
 		error |= __put_user(0, &buf->f_fstr[i]);
 
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
diff -puN arch/parisc/hpux/sys_hpux.c~introduce-path_put arch/parisc/hpux/sys_hpux.c
--- a/arch/parisc/hpux/sys_hpux.c~introduce-path_put
+++ a/arch/parisc/hpux/sys_hpux.c
@@ -222,7 +222,7 @@ asmlinkage long hpux_statfs(const char _
 		error = vfs_statfs_hpux(nd.path.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
diff -puN arch/powerpc/platforms/cell/spufs/syscalls.c~introduce-path_put arch/powerpc/platforms/cell/spufs/syscalls.c
--- a/arch/powerpc/platforms/cell/spufs/syscalls.c~introduce-path_put
+++ a/arch/powerpc/platforms/cell/spufs/syscalls.c
@@ -73,7 +73,7 @@ static long do_spu_create(const char __u
 				LOOKUP_OPEN|LOOKUP_CREATE, &nd);
 		if (!ret) {
 			ret = spufs_create(&nd, flags, mode, neighbor);
-			path_release(&nd);
+			path_put(&nd.path);
 		}
 		putname(tmp);
 	}
diff -puN arch/sparc64/solaris/fs.c~introduce-path_put arch/sparc64/solaris/fs.c
--- a/arch/sparc64/solaris/fs.c~introduce-path_put
+++ a/arch/sparc64/solaris/fs.c
@@ -436,7 +436,7 @@ asmlinkage int solaris_statvfs(u32 path,
 	if (!error) {
 		struct inode *inode = nd.path.dentry->d_inode;
 		error = report_statvfs(nd.path.mnt, inode, buf);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
@@ -466,7 +466,7 @@ asmlinkage int solaris_statvfs64(u32 pat
 	if (!error) {
 		struct inode *inode = nd.path.dentry->d_inode;
 		error = report_statvfs64(nd.path.mnt, inode, buf);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	unlock_kernel();
 	return error;
diff -puN drivers/md/dm-table.c~introduce-path_put drivers/md/dm-table.c
--- a/drivers/md/dm-table.c~introduce-path_put
+++ a/drivers/md/dm-table.c
@@ -375,7 +375,7 @@ static int lookup_device(const char *pat
 	*dev = inode->i_rdev;
 
  out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return r;
 }
 
diff -puN drivers/mtd/mtdsuper.c~introduce-path_put drivers/mtd/mtdsuper.c
--- a/drivers/mtd/mtdsuper.c~introduce-path_put
+++ a/drivers/mtd/mtdsuper.c
@@ -203,7 +203,7 @@ int get_sb_mtd(struct file_system_type *
 		goto not_an_MTD_device;
 
 	mtdnr = iminor(nd.path.dentry->d_inode);
-	path_release(&nd);
+	path_put(&nd.path);
 
 	return get_sb_mtd_nr(fs_type, flags, dev_name, data, mtdnr, fill_super,
 			     mnt);
@@ -214,7 +214,7 @@ not_an_MTD_device:
 		       "MTD: Attempt to mount non-MTD device \"%s\"\n",
 		       dev_name);
 out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return ret;
 
 }
diff -puN fs/afs/mntpt.c~introduce-path_put fs/afs/mntpt.c
--- a/fs/afs/mntpt.c~introduce-path_put
+++ a/fs/afs/mntpt.c
@@ -227,7 +227,7 @@ static void *afs_mntpt_follow_link(struc
 
 	newmnt = afs_mntpt_do_automount(nd->path.dentry);
 	if (IS_ERR(newmnt)) {
-		path_release(nd);
+		path_put(&nd->path);
 		return (void *)newmnt;
 	}
 
diff -puN fs/autofs4/root.c~introduce-path_put fs/autofs4/root.c
--- a/fs/autofs4/root.c~introduce-path_put
+++ a/fs/autofs4/root.c
@@ -383,7 +383,7 @@ done:
 	return NULL;
 
 out_error:
-	path_release(nd);
+	path_put(&nd->path);
 	return ERR_PTR(status);
 }
 
diff -puN fs/block_dev.c~introduce-path_put fs/block_dev.c
--- a/fs/block_dev.c~introduce-path_put
+++ a/fs/block_dev.c
@@ -1409,7 +1409,7 @@ struct block_device *lookup_bdev(const c
 	if (!bdev)
 		goto fail;
 out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return bdev;
 fail:
 	bdev = ERR_PTR(error);
diff -puN fs/cifs/cifs_dfs_ref.c~introduce-path_put fs/cifs/cifs_dfs_ref.c
--- a/fs/cifs/cifs_dfs_ref.c~introduce-path_put
+++ a/fs/cifs/cifs_dfs_ref.c
@@ -368,7 +368,7 @@ out:
 	cFYI(1, ("leaving %s" , __FUNCTION__));
 	return ERR_PTR(rc);
 out_err:
-	path_release(nd);
+	path_put(&nd->path);
 	goto out;
 }
 
diff -puN fs/coda/pioctl.c~introduce-path_put fs/coda/pioctl.c
--- a/fs/coda/pioctl.c~introduce-path_put
+++ a/fs/coda/pioctl.c
@@ -80,7 +80,7 @@ static int coda_pioctl(struct inode * in
 	
 	/* return if it is not a Coda inode */
 	if ( target_inode->i_sb != inode->i_sb ) {
-		path_release(&nd);
+		path_put(&nd.path);
 	        return  -EINVAL;
 	}
 
@@ -89,7 +89,7 @@ static int coda_pioctl(struct inode * in
 
 	error = venus_pioctl(inode->i_sb, &(cnp->c_fid), cmd, &data);
 
-	path_release(&nd);
+	path_put(&nd.path);
         return error;
 }
 
diff -puN fs/compat.c~introduce-path_put fs/compat.c
--- a/fs/compat.c~introduce-path_put
+++ a/fs/compat.c
@@ -244,7 +244,7 @@ asmlinkage long compat_sys_statfs(const 
 		error = vfs_statfs(nd.path.dentry, &tmp);
 		if (!error)
 			error = put_compat_statfs(buf, &tmp);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
@@ -312,7 +312,7 @@ asmlinkage long compat_sys_statfs64(cons
 		error = vfs_statfs(nd.path.dentry, &tmp);
 		if (!error)
 			error = put_compat_statfs64(buf, &tmp);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
diff -puN fs/configfs/symlink.c~introduce-path_put fs/configfs/symlink.c
--- a/fs/configfs/symlink.c~introduce-path_put
+++ a/fs/configfs/symlink.c
@@ -103,7 +103,7 @@ static int get_target(const char *symnam
 			*target = configfs_get_config_item(nd->path.dentry);
 			if (!*target) {
 				ret = -ENOENT;
-				path_release(nd);
+				path_put(&nd->path);
 			}
 		} else
 			ret = -EPERM;
@@ -141,7 +141,7 @@ int configfs_symlink(struct inode *dir, 
 		ret = create_link(parent_item, target_item, dentry);
 
 	config_item_put(target_item);
-	path_release(&nd);
+	path_put(&nd.path);
 
 out_put:
 	config_item_put(parent_item);
diff -puN fs/dquot.c~introduce-path_put fs/dquot.c
--- a/fs/dquot.c~introduce-path_put
+++ a/fs/dquot.c
@@ -1643,7 +1643,7 @@ int vfs_quota_on(struct super_block *sb,
 		error = vfs_quota_on_inode(nd.path.dentry->d_inode, type,
 					   format_id);
 out_path:
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
diff -puN fs/ecryptfs/main.c~introduce-path_put fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~introduce-path_put
+++ a/fs/ecryptfs/main.c
@@ -526,7 +526,7 @@ static int ecryptfs_read_super(struct su
 	rc = 0;
 	goto out;
 out_free:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return rc;
 }
diff -puN fs/exec.c~introduce-path_put fs/exec.c
--- a/fs/exec.c~introduce-path_put
+++ a/fs/exec.c
@@ -148,7 +148,7 @@ out:
   	return error;
 exit:
 	release_open_intent(&nd);
-	path_release(&nd);
+	path_put(&nd.path);
 	goto out;
 }
 
@@ -672,7 +672,7 @@ out:
 			}
 		}
 		release_open_intent(&nd);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	goto out;
 }
diff -puN fs/ext3/super.c~introduce-path_put fs/ext3/super.c
--- a/fs/ext3/super.c~introduce-path_put
+++ a/fs/ext3/super.c
@@ -2759,7 +2759,7 @@ static int ext3_quota_on(struct super_bl
 		return err;
 	/* Quotafile not on the same filesystem? */
 	if (nd.path.mnt->mnt_sb != sb) {
-		path_release(&nd);
+		path_put(&nd.path);
 		return -EXDEV;
 	}
 	/* Quotafile not of fs root? */
@@ -2767,7 +2767,7 @@ static int ext3_quota_on(struct super_bl
 		printk(KERN_WARNING
 			"EXT3-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
-	path_release(&nd);
+	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
 
diff -puN fs/ext4/super.c~introduce-path_put fs/ext4/super.c
--- a/fs/ext4/super.c~introduce-path_put
+++ a/fs/ext4/super.c
@@ -3159,7 +3159,7 @@ static int ext4_quota_on(struct super_bl
 		return err;
 	/* Quotafile not on the same filesystem? */
 	if (nd.path.mnt->mnt_sb != sb) {
-		path_release(&nd);
+		path_put(&nd.path);
 		return -EXDEV;
 	}
 	/* Quotafile not of fs root? */
@@ -3167,7 +3167,7 @@ static int ext4_quota_on(struct super_bl
 		printk(KERN_WARNING
 			"EXT4-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
-	path_release(&nd);
+	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
 
diff -puN fs/gfs2/ops_fstype.c~introduce-path_put fs/gfs2/ops_fstype.c
--- a/fs/gfs2/ops_fstype.c~introduce-path_put
+++ a/fs/gfs2/ops_fstype.c
@@ -900,7 +900,7 @@ static struct super_block* get_gfs2_sb(c
 	       "mount point %s\n", dev_name);
 
 free_nd:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return sb;
 }
diff -puN fs/inotify_user.c~introduce-path_put fs/inotify_user.c
--- a/fs/inotify_user.c~introduce-path_put
+++ a/fs/inotify_user.c
@@ -367,7 +367,7 @@ static int find_inode(const char __user 
 	/* you can only watch an inode if you have read permissions on it */
 	error = vfs_permission(nd, MAY_READ);
 	if (error)
-		path_release(nd);
+		path_put(&nd->path);
 	return error;
 }
 
@@ -676,7 +676,7 @@ asmlinkage long sys_inotify_add_watch(in
 		ret = create_watch(dev, inode, mask);
 	mutex_unlock(&dev->up_mutex);
 
-	path_release(&nd);
+	path_put(&nd.path);
 fput_and_out:
 	fput_light(filp, fput_needed);
 	return ret;
diff -puN fs/namei.c~introduce-path_put fs/namei.c
--- a/fs/namei.c~introduce-path_put
+++ a/fs/namei.c
@@ -362,11 +362,18 @@ int deny_write_access(struct file * file
 	return 0;
 }
 
-void path_release(struct nameidata *nd)
+/**
+ * path_put - put a reference to a path
+ * @path: path to put the reference to
+ *
+ * Given a path decrement the reference count to the dentry and the vfsmount.
+ */
+void path_put(struct path *path)
 {
-	dput(nd->path.dentry);
-	mntput(nd->path.mnt);
+	dput(path->dentry);
+	mntput(path->mnt);
 }
+EXPORT_SYMBOL(path_put);
 
 /**
  * release_open_intent - free up open intent resources
@@ -551,7 +558,7 @@ static __always_inline int __vfs_follow_
 		goto fail;
 
 	if (*link == '/') {
-		path_release(nd);
+		path_put(&nd->path);
 		if (!walk_init_root(link, nd))
 			/* weird __emul_prefix() stuff did it */
 			goto out;
@@ -567,18 +574,18 @@ out:
 	 */
 	name = __getname();
 	if (unlikely(!name)) {
-		path_release(nd);
+		path_put(&nd->path);
 		return -ENOMEM;
 	}
 	strcpy(name, nd->last.name);
 	nd->last.name = name;
 	return 0;
 fail:
-	path_release(nd);
+	path_put(&nd->path);
 	return PTR_ERR(link);
 }
 
-static inline void dput_path(struct path *path, struct nameidata *nd)
+static void path_put_conditional(struct path *path, struct nameidata *nd)
 {
 	dput(path->dentry);
 	if (path->mnt != nd->path.mnt)
@@ -651,8 +658,8 @@ static inline int do_follow_link(struct 
 	nd->depth--;
 	return err;
 loop:
-	dput_path(path, nd);
-	path_release(nd);
+	path_put_conditional(path, nd);
+	path_put(&nd->path);
 	return err;
 }
 
@@ -993,10 +1000,10 @@ return_reval:
 return_base:
 		return 0;
 out_dput:
-		dput_path(&next, nd);
+		path_put_conditional(&next, nd);
 		break;
 	}
-	path_release(nd);
+	path_put(&nd->path);
 return_err:
 	return err;
 }
@@ -1070,7 +1077,7 @@ static int __emul_lookup_dentry(const ch
 				mntput(old_mnt);
 				return 1;
 			}
-			path_release(nd);
+			path_put(&nd->path);
 		}
 		nd->path.dentry = old_dentry;
 		nd->path.mnt = old_mnt;
@@ -1230,7 +1237,7 @@ static int __path_lookup_intent_open(int
 	if (IS_ERR(nd->intent.open.file)) {
 		if (err == 0) {
 			err = PTR_ERR(nd->intent.open.file);
-			path_release(nd);
+			path_put(&nd->path);
 		}
 	} else if (err != 0)
 		release_open_intent(nd);
@@ -1806,11 +1813,11 @@ ok:
 	return 0;
 
 exit_dput:
-	dput_path(&path, nd);
+	path_put_conditional(&path, nd);
 exit:
 	if (!IS_ERR(nd->intent.open.file))
 		release_open_intent(nd);
-	path_release(nd);
+	path_put(&nd->path);
 	return error;
 
 do_link:
@@ -1979,7 +1986,7 @@ asmlinkage long sys_mknodat(int dfd, con
 		dput(dentry);
 	}
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	putname(tmp);
 
@@ -2039,7 +2046,7 @@ asmlinkage long sys_mkdirat(int dfd, con
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	putname(tmp);
 out_err:
@@ -2147,7 +2154,7 @@ static long do_rmdir(int dfd, const char
 exit2:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 exit1:
-	path_release(&nd);
+	path_put(&nd.path);
 exit:
 	putname(name);
 	return error;
@@ -2231,7 +2238,7 @@ static long do_unlinkat(int dfd, const c
 	if (inode)
 		iput(inode);	/* truncate the inode here */
 exit1:
-	path_release(&nd);
+	path_put(&nd.path);
 exit:
 	putname(name);
 	return error;
@@ -2308,7 +2315,7 @@ asmlinkage long sys_symlinkat(const char
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	putname(to);
 out_putname:
@@ -2404,9 +2411,9 @@ asmlinkage long sys_linkat(int olddfd, c
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 out_release:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
-	path_release(&old_nd);
+	path_put(&old_nd.path);
 exit:
 	putname(to);
 
@@ -2634,9 +2641,9 @@ exit4:
 exit3:
 	unlock_rename(new_dir, old_dir);
 exit2:
-	path_release(&newnd);
+	path_put(&newnd.path);
 exit1:
-	path_release(&oldnd);
+	path_put(&oldnd.path);
 exit:
 	return error;
 }
@@ -2810,7 +2817,6 @@ EXPORT_SYMBOL(page_symlink);
 EXPORT_SYMBOL(page_symlink_inode_operations);
 EXPORT_SYMBOL(path_lookup);
 EXPORT_SYMBOL(vfs_path_lookup);
-EXPORT_SYMBOL(path_release);
 EXPORT_SYMBOL(permission);
 EXPORT_SYMBOL(vfs_permission);
 EXPORT_SYMBOL(file_permission);
diff -puN fs/namespace.c~introduce-path_put fs/namespace.c
--- a/fs/namespace.c~introduce-path_put
+++ a/fs/namespace.c
@@ -1007,7 +1007,7 @@ static noinline int do_loopback(struct n
 
 out:
 	up_write(&namespace_sem);
-	path_release(&old_nd);
+	path_put(&old_nd.path);
 	return err;
 }
 
@@ -1126,8 +1126,8 @@ out1:
 out:
 	up_write(&namespace_sem);
 	if (!err)
-		path_release(&parent_nd);
-	path_release(&old_nd);
+		path_put(&parent_nd.path);
+	path_put(&old_nd.path);
 	return err;
 }
 
@@ -1512,7 +1512,7 @@ long do_mount(char *dev_name, char *dir_
 		retval = do_new_mount(&nd, type_page, flags, mnt_flags,
 				      dev_name, data_page);
 dput_out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return retval;
 }
 
@@ -1768,7 +1768,7 @@ asmlinkage long sys_pivot_root(const cha
 
 	error = security_sb_pivotroot(&old_nd, &new_nd);
 	if (error) {
-		path_release(&old_nd);
+		path_put(&old_nd.path);
 		goto out1;
 	}
 
@@ -1831,15 +1831,15 @@ asmlinkage long sys_pivot_root(const cha
 	chroot_fs_refs(&user_nd, &new_nd);
 	security_sb_post_pivotroot(&user_nd, &new_nd);
 	error = 0;
-	path_release(&root_parent);
-	path_release(&parent_nd);
+	path_put(&root_parent.path);
+	path_put(&parent_nd.path);
 out2:
 	mutex_unlock(&old_nd.path.dentry->d_inode->i_mutex);
 	up_write(&namespace_sem);
-	path_release(&user_nd);
-	path_release(&old_nd);
+	path_put(&user_nd.path);
+	path_put(&old_nd.path);
 out1:
-	path_release(&new_nd);
+	path_put(&new_nd.path);
 out0:
 	unlock_kernel();
 	return error;
diff -puN fs/nfs/namespace.c~introduce-path_put fs/nfs/namespace.c
--- a/fs/nfs/namespace.c~introduce-path_put
+++ a/fs/nfs/namespace.c
@@ -148,7 +148,7 @@ out:
 	dprintk("<-- nfs_follow_mountpoint() = %d\n", err);
 	return ERR_PTR(err);
 out_err:
-	path_release(nd);
+	path_put(&nd->path);
 	goto out;
 out_follow:
 	while (d_mountpoint(nd->path.dentry) &&
diff -puN fs/nfsctl.c~introduce-path_put fs/nfsctl.c
--- a/fs/nfsctl.c~introduce-path_put
+++ a/fs/nfsctl.c
@@ -43,7 +43,7 @@ static struct file *do_open(char *name, 
 	if (!error)
 		return dentry_open(nd.path.dentry, nd.path.mnt, flags);
 
-	path_release(&nd);
+	path_put(&nd.path);
 	return ERR_PTR(error);
 }
 
diff -puN fs/nfsd/export.c~introduce-path_put fs/nfsd/export.c
--- a/fs/nfsd/export.c~introduce-path_put
+++ a/fs/nfsd/export.c
@@ -177,7 +177,7 @@ static int expkey_parse(struct cache_det
 			cache_put(&ek->h, &svc_expkey_cache);
 		else
 			err = -ENOMEM;
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	cache_flush();
  out:
@@ -630,7 +630,7 @@ static int svc_export_parse(struct cache
 	kfree(exp.ex_uuid);
  	kfree(exp.ex_path);
 	if (nd.path.dentry)
-		path_release(&nd);
+		path_put(&nd.path);
  out_no_path:
 	if (dom)
 		auth_domain_put(dom);
@@ -1098,7 +1098,7 @@ finish:
 		cache_put(&fsid_key->h, &svc_expkey_cache);
 	if (clp)
 		auth_domain_put(clp);
-	path_release(&nd);
+	path_put(&nd.path);
 out_unlock:
 	exp_writeunlock();
 out:
@@ -1150,7 +1150,7 @@ exp_unexport(struct nfsctl_export *nxp)
 
 	err = -EINVAL;
 	exp = exp_get_by_name(dom, nd.path.mnt, nd.path.dentry, NULL);
-	path_release(&nd);
+	path_put(&nd.path);
 	if (IS_ERR(exp))
 		goto out_domain;
 
@@ -1209,7 +1209,7 @@ exp_rootfh(svc_client *clp, char *path, 
 	fh_put(&fh);
 	exp_put(exp);
 out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return err;
 }
 
diff -puN fs/nfsd/nfs4recover.c~introduce-path_put fs/nfsd/nfs4recover.c
--- a/fs/nfsd/nfs4recover.c~introduce-path_put
+++ a/fs/nfsd/nfs4recover.c
@@ -415,5 +415,5 @@ nfsd4_shutdown_recdir(void)
 	if (!rec_dir_init)
 		return;
 	rec_dir_init = 0;
-	path_release(&rec_dir);
+	path_put(&rec_dir.path);
 }
diff -puN fs/nfsd/nfs4state.c~introduce-path_put fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~introduce-path_put
+++ a/fs/nfsd/nfs4state.c
@@ -3265,7 +3265,7 @@ nfs4_reset_recoverydir(char *recdir)
 		nfs4_set_recdir(recdir);
 		status = 0;
 	}
-	path_release(&nd);
+	path_put(&nd.path);
 	return status;
 }
 
diff -puN fs/open.c~introduce-path_put fs/open.c
--- a/fs/open.c~introduce-path_put
+++ a/fs/open.c
@@ -130,7 +130,7 @@ asmlinkage long sys_statfs(const char __
 		error = vfs_statfs_native(nd.path.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
@@ -149,7 +149,7 @@ asmlinkage long sys_statfs64(const char 
 		error = vfs_statfs64(nd.path.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
@@ -277,7 +277,7 @@ static long do_sys_truncate(const char _
 put_write_and_out:
 	put_write_access(inode);
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -462,7 +462,7 @@ asmlinkage long sys_faccessat(int dfd, c
 		res = -EROFS;
 
 out_path_release:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	current->fsuid = old_fsuid;
 	current->fsgid = old_fsgid;
@@ -493,7 +493,7 @@ asmlinkage long sys_chdir(const char __u
 	set_fs_pwd(current->fs, nd.path.mnt, nd.path.dentry);
 
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -549,7 +549,7 @@ asmlinkage long sys_chroot(const char __
 	set_fs_altroot();
 	error = 0;
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -621,7 +621,7 @@ asmlinkage long sys_fchmodat(int dfd, co
 	mutex_unlock(&inode->i_mutex);
 
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -676,7 +676,7 @@ asmlinkage long sys_chown(const char __u
 	if (error)
 		goto out;
 	error = chown_common(nd.path.dentry, user, group);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -696,7 +696,7 @@ asmlinkage long sys_fchownat(int dfd, co
 	if (error)
 		goto out;
 	error = chown_common(nd.path.dentry, user, group);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -710,7 +710,7 @@ asmlinkage long sys_lchown(const char __
 	if (error)
 		goto out;
 	error = chown_common(nd.path.dentry, user, group);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -894,7 +894,7 @@ struct file *nameidata_to_filp(struct na
 		filp = __dentry_open(nd->path.dentry, nd->path.mnt, flags, filp,
 				     NULL);
 	else
-		path_release(nd);
+		path_put(&nd->path);
 	return filp;
 }
 
diff -puN fs/proc/base.c~introduce-path_put fs/proc/base.c
--- a/fs/proc/base.c~introduce-path_put
+++ a/fs/proc/base.c
@@ -1164,7 +1164,7 @@ static void *proc_pid_follow_link(struct
 	int error = -EACCES;
 
 	/* We don't need a base pointer in the /proc filesystem */
-	path_release(nd);
+	path_put(&nd->path);
 
 	/* Are we allowed to snoop on the tasks file descriptors? */
 	if (!proc_fd_access_allowed(inode))
diff -puN fs/reiserfs/super.c~introduce-path_put fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~introduce-path_put
+++ a/fs/reiserfs/super.c
@@ -2027,20 +2027,20 @@ static int reiserfs_quota_on(struct supe
 		return err;
 	/* Quotafile not on the same filesystem? */
 	if (nd.path.mnt->mnt_sb != sb) {
-		path_release(&nd);
+		path_put(&nd.path);
 		return -EXDEV;
 	}
 	/* We must not pack tails for quota files on reiserfs for quota IO to work */
 	if (!REISERFS_I(nd.path.dentry->d_inode)->i_flags & i_nopack_mask) {
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file must have tail packing disabled.");
-		path_release(&nd);
+		path_put(&nd.path);
 		return -EINVAL;
 	}
 	/* Not journalling quota? No more tests needed... */
 	if (!REISERFS_SB(sb)->s_qf_names[USRQUOTA] &&
 	    !REISERFS_SB(sb)->s_qf_names[GRPQUOTA]) {
-		path_release(&nd);
+		path_put(&nd.path);
 		return vfs_quota_on(sb, type, format_id, path);
 	}
 	/* Quotafile not of fs root? */
@@ -2048,7 +2048,7 @@ static int reiserfs_quota_on(struct supe
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file not on filesystem root. "
 				 "Journalled quota will not work.");
-	path_release(&nd);
+	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
 
diff -puN fs/stat.c~introduce-path_put fs/stat.c
--- a/fs/stat.c~introduce-path_put
+++ a/fs/stat.c
@@ -63,7 +63,7 @@ int vfs_stat_fd(int dfd, char __user *na
 	error = __user_walk_fd(dfd, name, LOOKUP_FOLLOW, &nd);
 	if (!error) {
 		error = vfs_getattr(nd.path.mnt, nd.path.dentry, stat);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
@@ -83,7 +83,7 @@ int vfs_lstat_fd(int dfd, char __user *n
 	error = __user_walk_fd(dfd, name, 0, &nd);
 	if (!error) {
 		error = vfs_getattr(nd.path.mnt, nd.path.dentry, stat);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
@@ -313,7 +313,7 @@ asmlinkage long sys_readlinkat(int dfd, 
 							      buf, bufsiz);
 			}
 		}
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
diff -puN fs/utimes.c~introduce-path_put fs/utimes.c
--- a/fs/utimes.c~introduce-path_put
+++ a/fs/utimes.c
@@ -138,7 +138,7 @@ dput_and_out:
 	if (f)
 		fput(f);
 	else
-		path_release(&nd);
+		path_put(&nd.path);
 out:
 	return error;
 }
diff -puN fs/xattr.c~introduce-path_put fs/xattr.c
--- a/fs/xattr.c~introduce-path_put
+++ a/fs/xattr.c
@@ -263,7 +263,7 @@ sys_setxattr(char __user *path, char __u
 	if (error)
 		return error;
 	error = setxattr(nd.path.dentry, name, value, size, flags);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -278,7 +278,7 @@ sys_lsetxattr(char __user *path, char __
 	if (error)
 		return error;
 	error = setxattr(nd.path.dentry, name, value, size, flags);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -348,7 +348,7 @@ sys_getxattr(char __user *path, char __u
 	if (error)
 		return error;
 	error = getxattr(nd.path.dentry, name, value, size);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -363,7 +363,7 @@ sys_lgetxattr(char __user *path, char __
 	if (error)
 		return error;
 	error = getxattr(nd.path.dentry, name, value, size);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -422,7 +422,7 @@ sys_listxattr(char __user *path, char __
 	if (error)
 		return error;
 	error = listxattr(nd.path.dentry, list, size);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -436,7 +436,7 @@ sys_llistxattr(char __user *path, char _
 	if (error)
 		return error;
 	error = listxattr(nd.path.dentry, list, size);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -483,7 +483,7 @@ sys_removexattr(char __user *path, char 
 	if (error)
 		return error;
 	error = removexattr(nd.path.dentry, name);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -497,7 +497,7 @@ sys_lremovexattr(char __user *path, char
 	if (error)
 		return error;
 	error = removexattr(nd.path.dentry, name);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
diff -puN fs/xfs/linux-2.6/xfs_ioctl.c~introduce-path_put fs/xfs/linux-2.6/xfs_ioctl.c
--- a/fs/xfs/linux-2.6/xfs_ioctl.c~introduce-path_put
+++ a/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -94,7 +94,7 @@ xfs_find_handle(
 		ASSERT(nd.path.dentry);
 		ASSERT(nd.path.dentry->d_inode);
 		inode = igrab(nd.path.dentry->d_inode);
-		path_release(&nd);
+		path_put(&nd.path);
 		break;
 	}
 
diff -puN include/linux/namei.h~introduce-path_put include/linux/namei.h
--- a/include/linux/namei.h~introduce-path_put
+++ a/include/linux/namei.h
@@ -66,7 +66,6 @@ extern int __user_walk_fd(int dfd, const
 extern int path_lookup(const char *, unsigned, struct nameidata *);
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
-extern void path_release(struct nameidata *);
 
 extern int __user_path_lookup_open(const char __user *, unsigned lookup_flags, struct nameidata *nd, int open_flags);
 extern int path_lookup_open(int dfd, const char *name, unsigned lookup_flags, struct nameidata *, int open_flags);
diff -puN include/linux/path.h~introduce-path_put include/linux/path.h
--- a/include/linux/path.h~introduce-path_put
+++ a/include/linux/path.h
@@ -9,4 +9,6 @@ struct path {
 	struct dentry *dentry;
 };
 
+extern void path_put(struct path *);
+
 #endif  /* _LINUX_PATH_H */
diff -puN kernel/audit_tree.c~introduce-path_put kernel/audit_tree.c
--- a/kernel/audit_tree.c~introduce-path_put
+++ a/kernel/audit_tree.c
@@ -550,7 +550,7 @@ void audit_trim_trees(void)
 			goto skip_it;
 
 		root_mnt = collect_mounts(nd.path.mnt, nd.path.dentry);
-		path_release(&nd);
+		path_put(&nd.path);
 		if (!root_mnt)
 			goto skip_it;
 
@@ -642,7 +642,7 @@ int audit_add_tree_rule(struct audit_kru
 	if (err)
 		goto Err;
 	mnt = collect_mounts(nd.path.mnt, nd.path.dentry);
-	path_release(&nd);
+	path_put(&nd.path);
 	if (!mnt) {
 		err = -ENOMEM;
 		goto Err;
@@ -702,7 +702,7 @@ int audit_tag_tree(char *old, char *new)
 	if (err)
 		return err;
 	tagged = collect_mounts(nd.path.mnt, nd.path.dentry);
-	path_release(&nd);
+	path_put(&nd.path);
 	if (!tagged)
 		return -ENOMEM;
 
@@ -713,7 +713,7 @@ int audit_tag_tree(char *old, char *new)
 	}
 	mnt = mntget(nd.path.mnt);
 	dentry = dget(nd.path.dentry);
-	path_release(&nd);
+	path_put(&nd.path);
 
 	if (dentry == tagged->mnt_root && dentry == mnt->mnt_root)
 		follow_up(&mnt, &dentry);
@@ -744,13 +744,13 @@ int audit_tag_tree(char *old, char *new)
 		spin_lock(&vfsmount_lock);
 		if (!is_under(mnt, dentry, &nd)) {
 			spin_unlock(&vfsmount_lock);
-			path_release(&nd);
+			path_put(&nd.path);
 			put_tree(tree);
 			mutex_lock(&audit_filter_mutex);
 			continue;
 		}
 		spin_unlock(&vfsmount_lock);
-		path_release(&nd);
+		path_put(&nd.path);
 
 		list_for_each_entry(p, &list, mnt_list) {
 			failed = tag_chunk(p->mnt_root->d_inode, tree);
diff -puN kernel/auditfilter.c~introduce-path_put kernel/auditfilter.c
--- a/kernel/auditfilter.c~introduce-path_put
+++ a/kernel/auditfilter.c
@@ -1161,11 +1161,11 @@ static int audit_get_nd(char *path, stru
 static void audit_put_nd(struct nameidata *ndp, struct nameidata *ndw)
 {
 	if (ndp) {
-		path_release(ndp);
+		path_put(&ndp->path);
 		kfree(ndp);
 	}
 	if (ndw) {
-		path_release(ndw);
+		path_put(&ndw->path);
 		kfree(ndw);
 	}
 }
diff -puN net/sunrpc/rpc_pipe.c~introduce-path_put net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~introduce-path_put
+++ a/net/sunrpc/rpc_pipe.c
@@ -495,7 +495,7 @@ rpc_lookup_parent(char *path, struct nam
 static void
 rpc_release_path(struct nameidata *nd)
 {
-	path_release(nd);
+	path_put(&nd->path);
 	rpc_put_mount();
 }
 
diff -puN net/unix/af_unix.c~introduce-path_put net/unix/af_unix.c
--- a/net/unix/af_unix.c~introduce-path_put
+++ a/net/unix/af_unix.c
@@ -727,7 +727,7 @@ static struct sock *unix_find_other(stru
 		if (u->sk_type == type)
 			touch_atime(nd.path.mnt, nd.path.dentry);
 
-		path_release(&nd);
+		path_put(&nd.path);
 
 		err=-EPROTOTYPE;
 		if (u->sk_type != type) {
@@ -748,7 +748,7 @@ static struct sock *unix_find_other(stru
 	return u;
 
 put_fail:
-	path_release(&nd);
+	path_put(&nd.path);
 fail:
 	*error=err;
 	return NULL;
@@ -862,7 +862,7 @@ out_mknod_dput:
 	dput(dentry);
 out_mknod_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	path_put(&nd.path);
 out_mknod_parent:
 	if (err==-EEXIST)
 		err=-EADDRINUSE;
_

Patches currently in -mm which might be from jblunck@suse.de are

origin.patch
introduce-path_put-unionfs.patch
