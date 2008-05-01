From: akpm@linux-foundation.org
Subject: - fs-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:15 -0700
Message-ID: <200805010933.m419XFND031125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754891AbYEAJdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     fs-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/adfs.h              |    2 +-
 fs/autofs4/autofs_i.h       |    2 +-
 fs/bfs/bfs.h                |    2 +-
 fs/buffer.c                 |    2 +-
 fs/configfs/file.c          |    2 +-
 fs/configfs/mount.c         |    2 +-
 fs/configfs/symlink.c       |    4 ++--
 fs/dlm/lockspace.c          |    2 +-
 fs/exportfs/expfs.c         |   10 +++++-----
 fs/fat/cache.c              |    6 +++---
 fs/fat/fatent.c             |    2 +-
 fs/fat/file.c               |    2 +-
 fs/gfs2/locking/dlm/sysfs.c |    2 +-
 fs/gfs2/util.h              |   18 +++++++++---------
 fs/jffs2/debug.h            |    8 ++++----
 fs/jffs2/xattr.c            |    4 ++--
 fs/lockd/clntproc.c         |    2 +-
 fs/lockd/svclock.c          |    2 +-
 fs/msdos/namei.c            |    2 +-
 fs/namespace.c              |    4 ++--
 fs/nfsd/nfs4callback.c      |    4 ++--
 fs/ntfs/debug.h             |    6 +++---
 fs/partitions/ldm.c         |    8 ++++----
 fs/smbfs/smb_debug.h        |    6 +++---
 fs/sysfs/file.c             |    2 +-
 fs/sysfs/mount.c            |    2 +-
 fs/udf/super.c              |    4 ++--
 fs/vfat/namei.c             |    2 +-
 28 files changed, 57 insertions(+), 57 deletions(-)

diff -puN fs/adfs/adfs.h~fs-replace-remaining-__function__-occurrences fs/adfs/adfs.h
--- a/fs/adfs/adfs.h~fs-replace-remaining-__function__-occurrences
+++ a/fs/adfs/adfs.h
@@ -75,7 +75,7 @@ extern unsigned int adfs_map_free(struct
 /* Misc */
 void __adfs_error(struct super_block *sb, const char *function,
 		  const char *fmt, ...);
-#define adfs_error(sb, fmt...) __adfs_error(sb, __FUNCTION__, fmt)
+#define adfs_error(sb, fmt...) __adfs_error(sb, __func__, fmt)
 
 /* super.c */
 
diff -puN fs/autofs4/autofs_i.h~fs-replace-remaining-__function__-occurrences fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~fs-replace-remaining-__function__-occurrences
+++ a/fs/autofs4/autofs_i.h
@@ -35,7 +35,7 @@
 /* #define DEBUG */
 
 #ifdef DEBUG
-#define DPRINTK(fmt,args...) do { printk(KERN_DEBUG "pid %d: %s: " fmt "\n" , current->pid , __FUNCTION__ , ##args); } while(0)
+#define DPRINTK(fmt,args...) do { printk(KERN_DEBUG "pid %d: %s: " fmt "\n" , current->pid , __func__ , ##args); } while(0)
 #else
 #define DPRINTK(fmt,args...) do {} while(0)
 #endif
diff -puN fs/bfs/bfs.h~fs-replace-remaining-__function__-occurrences fs/bfs/bfs.h
--- a/fs/bfs/bfs.h~fs-replace-remaining-__function__-occurrences
+++ a/fs/bfs/bfs.h
@@ -42,7 +42,7 @@ static inline struct bfs_inode_info *BFS
 
 
 #define printf(format, args...) \
-	printk(KERN_ERR "BFS-fs: %s(): " format, __FUNCTION__, ## args)
+	printk(KERN_ERR "BFS-fs: %s(): " format, __func__, ## args)
 
 /* inode.c */
 extern struct inode *bfs_iget(struct super_block *sb, unsigned long ino);
diff -puN fs/buffer.c~fs-replace-remaining-__function__-occurrences fs/buffer.c
--- a/fs/buffer.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/buffer.c
@@ -1101,7 +1101,7 @@ grow_buffers(struct block_device *bdev, 
 
 		printk(KERN_ERR "%s: requested out-of-range block %llu for "
 			"device %s\n",
-			__FUNCTION__, (unsigned long long)block,
+			__func__, (unsigned long long)block,
 			bdevname(bdev, b));
 		return -EIO;
 	}
diff -puN fs/configfs/file.c~fs-replace-remaining-__function__-occurrences fs/configfs/file.c
--- a/fs/configfs/file.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/configfs/file.c
@@ -115,7 +115,7 @@ configfs_read_file(struct file *file, ch
 			goto out;
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
-		 __FUNCTION__, count, *ppos, buffer->page);
+		 __func__, count, *ppos, buffer->page);
 	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
 					 buffer->count);
 out:
diff -puN fs/configfs/mount.c~fs-replace-remaining-__function__-occurrences fs/configfs/mount.c
--- a/fs/configfs/mount.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/configfs/mount.c
@@ -92,7 +92,7 @@ static int configfs_fill_super(struct su
 
 	root = d_alloc_root(inode);
 	if (!root) {
-		pr_debug("%s: could not get root dentry!\n",__FUNCTION__);
+		pr_debug("%s: could not get root dentry!\n",__func__);
 		iput(inode);
 		return -ENOMEM;
 	}
diff -puN fs/configfs/symlink.c~fs-replace-remaining-__function__-occurrences fs/configfs/symlink.c
--- a/fs/configfs/symlink.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/configfs/symlink.c
@@ -210,13 +210,13 @@ static int configfs_get_target_path(stru
 	if (size > PATH_MAX)
 		return -ENAMETOOLONG;
 
-	pr_debug("%s: depth = %d, size = %d\n", __FUNCTION__, depth, size);
+	pr_debug("%s: depth = %d, size = %d\n", __func__, depth, size);
 
 	for (s = path; depth--; s += 3)
 		strcpy(s,"../");
 
 	fill_item_path(target, path, size);
-	pr_debug("%s: path = '%s'\n", __FUNCTION__, path);
+	pr_debug("%s: path = '%s'\n", __func__, path);
 
 	return 0;
 }
diff -puN fs/dlm/lockspace.c~fs-replace-remaining-__function__-occurrences fs/dlm/lockspace.c
--- a/fs/dlm/lockspace.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/dlm/lockspace.c
@@ -200,7 +200,7 @@ int __init dlm_lockspace_init(void)
 
 	dlm_kset = kset_create_and_add("dlm", NULL, kernel_kobj);
 	if (!dlm_kset) {
-		printk(KERN_WARNING "%s: can not create kset\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: can not create kset\n", __func__);
 		return -ENOMEM;
 	}
 	return 0;
diff -puN fs/exportfs/expfs.c~fs-replace-remaining-__function__-occurrences fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/exportfs/expfs.c
@@ -150,12 +150,12 @@ reconnect_path(struct vfsmount *mnt, str
 			if (IS_ERR(ppd)) {
 				err = PTR_ERR(ppd);
 				dprintk("%s: get_parent of %ld failed, err %d\n",
-					__FUNCTION__, pd->d_inode->i_ino, err);
+					__func__, pd->d_inode->i_ino, err);
 				dput(pd);
 				break;
 			}
 
-			dprintk("%s: find name of %lu in %lu\n", __FUNCTION__,
+			dprintk("%s: find name of %lu in %lu\n", __func__,
 				pd->d_inode->i_ino, ppd->d_inode->i_ino);
 			err = exportfs_get_name(mnt, ppd, nbuf, pd);
 			if (err) {
@@ -168,14 +168,14 @@ reconnect_path(struct vfsmount *mnt, str
 					continue;
 				break;
 			}
-			dprintk("%s: found name: %s\n", __FUNCTION__, nbuf);
+			dprintk("%s: found name: %s\n", __func__, nbuf);
 			mutex_lock(&ppd->d_inode->i_mutex);
 			npd = lookup_one_len(nbuf, ppd, strlen(nbuf));
 			mutex_unlock(&ppd->d_inode->i_mutex);
 			if (IS_ERR(npd)) {
 				err = PTR_ERR(npd);
 				dprintk("%s: lookup failed: %d\n",
-					__FUNCTION__, err);
+					__func__, err);
 				dput(ppd);
 				dput(pd);
 				break;
@@ -188,7 +188,7 @@ reconnect_path(struct vfsmount *mnt, str
 			if (npd == pd)
 				noprogress = 0;
 			else
-				printk("%s: npd != pd\n", __FUNCTION__);
+				printk("%s: npd != pd\n", __func__);
 			dput(npd);
 			dput(ppd);
 			if (IS_ROOT(pd)) {
diff -puN fs/fat/cache.c~fs-replace-remaining-__function__-occurrences fs/fat/cache.c
--- a/fs/fat/cache.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/fat/cache.c
@@ -242,7 +242,7 @@ int fat_get_cluster(struct inode *inode,
 		/* prevent the infinite loop of cluster chain */
 		if (*fclus > limit) {
 			fat_fs_panic(sb, "%s: detected the cluster chain loop"
-				     " (i_pos %lld)", __FUNCTION__,
+				     " (i_pos %lld)", __func__,
 				     MSDOS_I(inode)->i_pos);
 			nr = -EIO;
 			goto out;
@@ -253,7 +253,7 @@ int fat_get_cluster(struct inode *inode,
 			goto out;
 		else if (nr == FAT_ENT_FREE) {
 			fat_fs_panic(sb, "%s: invalid cluster chain"
-				     " (i_pos %lld)", __FUNCTION__,
+				     " (i_pos %lld)", __func__,
 				     MSDOS_I(inode)->i_pos);
 			nr = -EIO;
 			goto out;
@@ -286,7 +286,7 @@ static int fat_bmap_cluster(struct inode
 		return ret;
 	else if (ret == FAT_ENT_EOF) {
 		fat_fs_panic(sb, "%s: request beyond EOF (i_pos %lld)",
-			     __FUNCTION__, MSDOS_I(inode)->i_pos);
+			     __func__, MSDOS_I(inode)->i_pos);
 		return -EIO;
 	}
 	return dclus;
diff -puN fs/fat/fatent.c~fs-replace-remaining-__function__-occurrences fs/fat/fatent.c
--- a/fs/fat/fatent.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/fat/fatent.c
@@ -546,7 +546,7 @@ int fat_free_clusters(struct inode *inod
 			goto error;
 		} else if (cluster == FAT_ENT_FREE) {
 			fat_fs_panic(sb, "%s: deleting FAT entry beyond EOF",
-				     __FUNCTION__);
+				     __func__);
 			err = -EIO;
 			goto error;
 		}
diff -puN fs/fat/file.c~fs-replace-remaining-__function__-occurrences fs/fat/file.c
--- a/fs/fat/file.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/fat/file.c
@@ -208,7 +208,7 @@ static int fat_free(struct inode *inode,
 		} else if (ret == FAT_ENT_FREE) {
 			fat_fs_panic(sb,
 				     "%s: invalid cluster chain (i_pos %lld)",
-				     __FUNCTION__, MSDOS_I(inode)->i_pos);
+				     __func__, MSDOS_I(inode)->i_pos);
 			ret = -EIO;
 		} else if (ret > 0) {
 			err = fat_ent_write(inode, &fatent, FAT_ENT_EOF, wait);
diff -puN fs/gfs2/locking/dlm/sysfs.c~fs-replace-remaining-__function__-occurrences fs/gfs2/locking/dlm/sysfs.c
--- a/fs/gfs2/locking/dlm/sysfs.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/gfs2/locking/dlm/sysfs.c
@@ -212,7 +212,7 @@ int gdlm_sysfs_init(void)
 {
 	gdlm_kset = kset_create_and_add("lock_dlm", NULL, kernel_kobj);
 	if (!gdlm_kset) {
-		printk(KERN_WARNING "%s: can not create kset\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: can not create kset\n", __func__);
 		return -ENOMEM;
 	}
 	return 0;
diff -puN fs/gfs2/util.h~fs-replace-remaining-__function__-occurrences fs/gfs2/util.h
--- a/fs/gfs2/util.h~fs-replace-remaining-__function__-occurrences
+++ a/fs/gfs2/util.h
@@ -41,7 +41,7 @@ int gfs2_assert_withdraw_i(struct gfs2_s
 
 #define gfs2_assert_withdraw(sdp, assertion) \
 ((likely(assertion)) ? 0 : gfs2_assert_withdraw_i((sdp), #assertion, \
-					__FUNCTION__, __FILE__, __LINE__))
+					__func__, __FILE__, __LINE__))
 
 
 int gfs2_assert_warn_i(struct gfs2_sbd *sdp, char *assertion,
@@ -49,28 +49,28 @@ int gfs2_assert_warn_i(struct gfs2_sbd *
 
 #define gfs2_assert_warn(sdp, assertion) \
 ((likely(assertion)) ? 0 : gfs2_assert_warn_i((sdp), #assertion, \
-					__FUNCTION__, __FILE__, __LINE__))
+					__func__, __FILE__, __LINE__))
 
 
 int gfs2_consist_i(struct gfs2_sbd *sdp, int cluster_wide,
 		   const char *function, char *file, unsigned int line);
 
 #define gfs2_consist(sdp) \
-gfs2_consist_i((sdp), 0, __FUNCTION__, __FILE__, __LINE__)
+gfs2_consist_i((sdp), 0, __func__, __FILE__, __LINE__)
 
 
 int gfs2_consist_inode_i(struct gfs2_inode *ip, int cluster_wide,
 			 const char *function, char *file, unsigned int line);
 
 #define gfs2_consist_inode(ip) \
-gfs2_consist_inode_i((ip), 0, __FUNCTION__, __FILE__, __LINE__)
+gfs2_consist_inode_i((ip), 0, __func__, __FILE__, __LINE__)
 
 
 int gfs2_consist_rgrpd_i(struct gfs2_rgrpd *rgd, int cluster_wide,
 			 const char *function, char *file, unsigned int line);
 
 #define gfs2_consist_rgrpd(rgd) \
-gfs2_consist_rgrpd_i((rgd), 0, __FUNCTION__, __FILE__, __LINE__)
+gfs2_consist_rgrpd_i((rgd), 0, __func__, __FILE__, __LINE__)
 
 
 int gfs2_meta_check_ii(struct gfs2_sbd *sdp, struct buffer_head *bh,
@@ -91,7 +91,7 @@ static inline int gfs2_meta_check_i(stru
 }
 
 #define gfs2_meta_check(sdp, bh) \
-gfs2_meta_check_i((sdp), (bh), __FUNCTION__, __FILE__, __LINE__)
+gfs2_meta_check_i((sdp), (bh), __func__, __FILE__, __LINE__)
 
 
 int gfs2_metatype_check_ii(struct gfs2_sbd *sdp, struct buffer_head *bh,
@@ -118,7 +118,7 @@ static inline int gfs2_metatype_check_i(
 }
 
 #define gfs2_metatype_check(sdp, bh, type) \
-gfs2_metatype_check_i((sdp), (bh), (type), __FUNCTION__, __FILE__, __LINE__)
+gfs2_metatype_check_i((sdp), (bh), (type), __func__, __FILE__, __LINE__)
 
 static inline void gfs2_metatype_set(struct buffer_head *bh, u16 type,
 				     u16 format)
@@ -134,14 +134,14 @@ int gfs2_io_error_i(struct gfs2_sbd *sdp
 		    char *file, unsigned int line);
 
 #define gfs2_io_error(sdp) \
-gfs2_io_error_i((sdp), __FUNCTION__, __FILE__, __LINE__);
+gfs2_io_error_i((sdp), __func__, __FILE__, __LINE__);
 
 
 int gfs2_io_error_bh_i(struct gfs2_sbd *sdp, struct buffer_head *bh,
 		       const char *function, char *file, unsigned int line);
 
 #define gfs2_io_error_bh(sdp, bh) \
-gfs2_io_error_bh_i((sdp), (bh), __FUNCTION__, __FILE__, __LINE__);
+gfs2_io_error_bh_i((sdp), (bh), __func__, __FILE__, __LINE__);
 
 
 extern struct kmem_cache *gfs2_glock_cachep;
diff -puN fs/jffs2/debug.h~fs-replace-remaining-__function__-occurrences fs/jffs2/debug.h
--- a/fs/jffs2/debug.h~fs-replace-remaining-__function__-occurrences
+++ a/fs/jffs2/debug.h
@@ -82,28 +82,28 @@
 	do {								\
 		printk(JFFS2_ERR_MSG_PREFIX				\
 			" (%d) %s: " fmt, task_pid_nr(current),		\
-			__FUNCTION__ , ##__VA_ARGS__);			\
+			__func__ , ##__VA_ARGS__);			\
 	} while(0)
 
 #define JFFS2_WARNING(fmt, ...)						\
 	do {								\
 		printk(JFFS2_WARN_MSG_PREFIX				\
 			" (%d) %s: " fmt, task_pid_nr(current),		\
-			__FUNCTION__ , ##__VA_ARGS__);			\
+			__func__ , ##__VA_ARGS__);			\
 	} while(0)
 
 #define JFFS2_NOTICE(fmt, ...)						\
 	do {								\
 		printk(JFFS2_NOTICE_MSG_PREFIX				\
 			" (%d) %s: " fmt, task_pid_nr(current),		\
-			__FUNCTION__ , ##__VA_ARGS__);			\
+			__func__ , ##__VA_ARGS__);			\
 	} while(0)
 
 #define JFFS2_DEBUG(fmt, ...)						\
 	do {								\
 		printk(JFFS2_DBG_MSG_PREFIX				\
 			" (%d) %s: " fmt, task_pid_nr(current),		\
-			__FUNCTION__ , ##__VA_ARGS__);			\
+			__func__ , ##__VA_ARGS__);			\
 	} while(0)
 
 /*
diff -puN fs/jffs2/xattr.c~fs-replace-remaining-__function__-occurrences fs/jffs2/xattr.c
--- a/fs/jffs2/xattr.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/jffs2/xattr.c
@@ -82,7 +82,7 @@ static int is_xattr_datum_unchecked(stru
 static void unload_xattr_datum(struct jffs2_sb_info *c, struct jffs2_xattr_datum *xd)
 {
 	/* must be called under down_write(xattr_sem) */
-	D1(dbg_xattr("%s: xid=%u, version=%u\n", __FUNCTION__, xd->xid, xd->version));
+	D1(dbg_xattr("%s: xid=%u, version=%u\n", __func__, xd->xid, xd->version));
 	if (xd->xname) {
 		c->xdatum_mem_usage -= (xd->name_len + 1 + xd->value_len);
 		kfree(xd->xname);
@@ -1252,7 +1252,7 @@ int jffs2_garbage_collect_xattr_ref(stru
 	rc = jffs2_reserve_space_gc(c, totlen, &length, JFFS2_SUMMARY_XREF_SIZE);
 	if (rc) {
 		JFFS2_WARNING("%s: jffs2_reserve_space_gc() = %d, request = %u\n",
-			      __FUNCTION__, rc, totlen);
+			      __func__, rc, totlen);
 		rc = rc ? rc : -EBADFD;
 		goto out;
 	}
diff -puN fs/lockd/clntproc.c~fs-replace-remaining-__function__-occurrences fs/lockd/clntproc.c
--- a/fs/lockd/clntproc.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/lockd/clntproc.c
@@ -573,7 +573,7 @@ again:
 		/* Ensure the resulting lock will get added to granted list */
 		fl->fl_flags |= FL_SLEEP;
 		if (do_vfs_lock(fl) < 0)
-			printk(KERN_WARNING "%s: VFS is out of sync with lock manager!\n", __FUNCTION__);
+			printk(KERN_WARNING "%s: VFS is out of sync with lock manager!\n", __func__);
 		up_read(&host->h_rwsem);
 		fl->fl_flags = fl_flags;
 		status = 0;
diff -puN fs/lockd/svclock.c~fs-replace-remaining-__function__-occurrences fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/lockd/svclock.c
@@ -752,7 +752,7 @@ nlmsvc_grant_blocked(struct nlm_block *b
 		return;
 	default:
 		printk(KERN_WARNING "lockd: unexpected error %d in %s!\n",
-				-error, __FUNCTION__);
+				-error, __func__);
 		nlmsvc_insert_block(block, 10 * HZ);
 		nlmsvc_release_block(block);
 		return;
diff -puN fs/msdos/namei.c~fs-replace-remaining-__function__-occurrences fs/msdos/namei.c
--- a/fs/msdos/namei.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/msdos/namei.c
@@ -609,7 +609,7 @@ error_inode:
 	if (corrupt < 0) {
 		fat_fs_panic(new_dir->i_sb,
 			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __FUNCTION__, sinfo.i_pos);
+			     __func__, sinfo.i_pos);
 	}
 	goto out;
 }
diff -puN fs/namespace.c~fs-replace-remaining-__function__-occurrences fs/namespace.c
--- a/fs/namespace.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/namespace.c
@@ -2329,10 +2329,10 @@ void __init mnt_init(void)
 	err = sysfs_init();
 	if (err)
 		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
-			__FUNCTION__, err);
+			__func__, err);
 	fs_kobj = kobject_create_and_add("fs", NULL);
 	if (!fs_kobj)
-		printk(KERN_WARNING "%s: kobj create error\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: kobj create error\n", __func__);
 	init_rootfs();
 	init_mount_tree();
 }
diff -puN fs/nfsd/nfs4callback.c~fs-replace-remaining-__function__-occurrences fs/nfsd/nfs4callback.c
--- a/fs/nfsd/nfs4callback.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/nfsd/nfs4callback.c
@@ -104,7 +104,7 @@ xdr_writemem(__be32 *p, const void *ptr,
 } while (0)
 #define RESERVE_SPACE(nbytes)   do {                            \
 	p = xdr_reserve_space(xdr, nbytes);                     \
-	if (!p) dprintk("NFSD: RESERVE_SPACE(%d) failed in function %s\n", (int) (nbytes), __FUNCTION__); \
+	if (!p) dprintk("NFSD: RESERVE_SPACE(%d) failed in function %s\n", (int) (nbytes), __func__); \
 	BUG_ON(!p);                                             \
 } while (0)
 
@@ -134,7 +134,7 @@ xdr_error:                              
 	p = xdr_inline_decode(xdr, nbytes); \
 	if (!p) { \
 		dprintk("NFSD: %s: reply buffer overflowed in line %d.\n", \
-			__FUNCTION__, __LINE__); \
+			__func__, __LINE__); \
 		return -EIO; \
 	} \
 } while (0)
diff -puN fs/ntfs/debug.h~fs-replace-remaining-__function__-occurrences fs/ntfs/debug.h
--- a/fs/ntfs/debug.h~fs-replace-remaining-__function__-occurrences
+++ a/fs/ntfs/debug.h
@@ -45,7 +45,7 @@ static void ntfs_debug(const char *f, ..
 extern void __ntfs_debug (const char *file, int line, const char *function,
 	const char *format, ...) __attribute__ ((format (printf, 4, 5)));
 #define ntfs_debug(f, a...)						\
-	__ntfs_debug(__FILE__, __LINE__, __FUNCTION__, f, ##a)
+	__ntfs_debug(__FILE__, __LINE__, __func__, f, ##a)
 
 extern void ntfs_debug_dump_runlist(const runlist_element *rl);
 
@@ -58,10 +58,10 @@ extern void ntfs_debug_dump_runlist(cons
 
 extern void __ntfs_warning(const char *function, const struct super_block *sb,
 		const char *fmt, ...) __attribute__ ((format (printf, 3, 4)));
-#define ntfs_warning(sb, f, a...)	__ntfs_warning(__FUNCTION__, sb, f, ##a)
+#define ntfs_warning(sb, f, a...)	__ntfs_warning(__func__, sb, f, ##a)
 
 extern void __ntfs_error(const char *function, const struct super_block *sb,
 		const char *fmt, ...) __attribute__ ((format (printf, 3, 4)));
-#define ntfs_error(sb, f, a...)		__ntfs_error(__FUNCTION__, sb, f, ##a)
+#define ntfs_error(sb, f, a...)		__ntfs_error(__func__, sb, f, ##a)
 
 #endif /* _LINUX_NTFS_DEBUG_H */
diff -puN fs/partitions/ldm.c~fs-replace-remaining-__function__-occurrences fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/partitions/ldm.c
@@ -41,12 +41,12 @@
 #ifndef CONFIG_LDM_DEBUG
 #define ldm_debug(...)	do {} while (0)
 #else
-#define ldm_debug(f, a...) _ldm_printk (KERN_DEBUG, __FUNCTION__, f, ##a)
+#define ldm_debug(f, a...) _ldm_printk (KERN_DEBUG, __func__, f, ##a)
 #endif
 
-#define ldm_crit(f, a...)  _ldm_printk (KERN_CRIT,  __FUNCTION__, f, ##a)
-#define ldm_error(f, a...) _ldm_printk (KERN_ERR,   __FUNCTION__, f, ##a)
-#define ldm_info(f, a...)  _ldm_printk (KERN_INFO,  __FUNCTION__, f, ##a)
+#define ldm_crit(f, a...)  _ldm_printk (KERN_CRIT,  __func__, f, ##a)
+#define ldm_error(f, a...) _ldm_printk (KERN_ERR,   __func__, f, ##a)
+#define ldm_info(f, a...)  _ldm_printk (KERN_INFO,  __func__, f, ##a)
 
 __attribute__ ((format (printf, 3, 4)))
 static void _ldm_printk (const char *level, const char *function,
diff -puN fs/smbfs/smb_debug.h~fs-replace-remaining-__function__-occurrences fs/smbfs/smb_debug.h
--- a/fs/smbfs/smb_debug.h~fs-replace-remaining-__function__-occurrences
+++ a/fs/smbfs/smb_debug.h
@@ -11,14 +11,14 @@
  * these are normally enabled.
  */
 #ifdef SMBFS_PARANOIA
-# define PARANOIA(f, a...) printk(KERN_NOTICE "%s: " f, __FUNCTION__ , ## a)
+# define PARANOIA(f, a...) printk(KERN_NOTICE "%s: " f, __func__ , ## a)
 #else
 # define PARANOIA(f, a...) do { ; } while(0)
 #endif
 
 /* lots of debug messages */
 #ifdef SMBFS_DEBUG_VERBOSE
-# define VERBOSE(f, a...) printk(KERN_DEBUG "%s: " f, __FUNCTION__ , ## a)
+# define VERBOSE(f, a...) printk(KERN_DEBUG "%s: " f, __func__ , ## a)
 #else
 # define VERBOSE(f, a...) do { ; } while(0)
 #endif
@@ -28,7 +28,7 @@
  * too common name.
  */
 #ifdef SMBFS_DEBUG
-#define DEBUG1(f, a...) printk(KERN_DEBUG "%s: " f, __FUNCTION__ , ## a)
+#define DEBUG1(f, a...) printk(KERN_DEBUG "%s: " f, __func__ , ## a)
 #else
 #define DEBUG1(f, a...) do { ; } while(0)
 #endif
diff -puN fs/sysfs/file.c~fs-replace-remaining-__function__-occurrences fs/sysfs/file.c
--- a/fs/sysfs/file.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/sysfs/file.c
@@ -135,7 +135,7 @@ sysfs_read_file(struct file *file, char 
 			goto out;
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
-		 __FUNCTION__, count, *ppos, buffer->page);
+		 __func__, count, *ppos, buffer->page);
 	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
 					 buffer->count);
 out:
diff -puN fs/sysfs/mount.c~fs-replace-remaining-__function__-occurrences fs/sysfs/mount.c
--- a/fs/sysfs/mount.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/sysfs/mount.c
@@ -61,7 +61,7 @@ static int sysfs_fill_super(struct super
 	/* instantiate and link root dentry */
 	root = d_alloc_root(inode);
 	if (!root) {
-		pr_debug("%s: could not get root dentry!\n",__FUNCTION__);
+		pr_debug("%s: could not get root dentry!\n",__func__);
 		iput(inode);
 		return -ENOMEM;
 	}
diff -puN fs/udf/super.c~fs-replace-remaining-__function__-occurrences fs/udf/super.c
--- a/fs/udf/super.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/udf/super.c
@@ -240,7 +240,7 @@ static int udf_sb_alloc_partition_maps(s
 	sbi->s_partmaps = kcalloc(count, sizeof(struct udf_part_map),
 				  GFP_KERNEL);
 	if (!sbi->s_partmaps) {
-		udf_error(sb, __FUNCTION__,
+		udf_error(sb, __func__,
 			  "Unable to allocate space for %d partition maps",
 			  count);
 		sbi->s_partitions = 0;
@@ -1086,7 +1086,7 @@ static struct udf_bitmap *udf_sb_alloc_b
 		bitmap = vmalloc(size); /* TODO: get rid of vmalloc */
 
 	if (bitmap == NULL) {
-		udf_error(sb, __FUNCTION__,
+		udf_error(sb, __func__,
 			  "Unable to allocate space for bitmap "
 			  "and %d buffer_head pointers", nr_groups);
 		return NULL;
diff -puN fs/vfat/namei.c~fs-replace-remaining-__function__-occurrences fs/vfat/namei.c
--- a/fs/vfat/namei.c~fs-replace-remaining-__function__-occurrences
+++ a/fs/vfat/namei.c
@@ -986,7 +986,7 @@ error_inode:
 	if (corrupt < 0) {
 		fat_fs_panic(new_dir->i_sb,
 			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __FUNCTION__, sinfo.i_pos);
+			     __func__, sinfo.i_pos);
 	}
 	goto out;
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-unbreak-misalignment-handling-changes.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch

