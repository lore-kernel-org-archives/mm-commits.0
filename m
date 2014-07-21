From: akpm@linux-foundation.org
Subject: + fsh-a-few-more-whitespace-neatenings.patch added to -mm tree
Date: Mon, 21 Jul 2014 15:23:56 -0700
Message-ID: <53cd92fc.wdy1Rsanq75Un8qz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:65474 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaGUWX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 18:23:57 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so1101259qap.0
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 15:23:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bfields@fieldses.org, ccaulfie@redhat.com, jlayton@poochiereds.net, teigland@redhat.com, trond.myklebust@primarydata.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs.h: a few more whitespace neatenings
has been added to the -mm tree.  Its filename is
     fsh-a-few-more-whitespace-neatenings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsh-a-few-more-whitespace-neatenings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsh-a-few-more-whitespace-neatenings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: fs.h: a few more whitespace neatenings

Some line removals and line wrapping to 80 columns along
with few trivial other whitespace changes.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Teigland <teigland@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |  187 ++++++++++++++++++++++---------------------
 1 file changed, 98 insertions(+), 89 deletions(-)

diff -puN include/linux/fs.h~fsh-a-few-more-whitespace-neatenings include/linux/fs.h
--- a/include/linux/fs.h~fsh-a-few-more-whitespace-neatenings
+++ a/include/linux/fs.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_FS_H
 #define _LINUX_FS_H
 
-
 #include <linux/linkage.h>
 #include <linux/wait.h>
 #include <linux/kdev_t.h>
@@ -461,8 +460,8 @@ int mapping_tagged(struct address_space
  */
 static inline int mapping_mapped(struct address_space *mapping)
 {
-	return	!RB_EMPTY_ROOT(&mapping->i_mmap) ||
-		!list_empty(&mapping->i_mmap_nonlinear);
+	return !RB_EMPTY_ROOT(&mapping->i_mmap) ||
+	       !list_empty(&mapping->i_mmap_nonlinear);
 }
 
 /*
@@ -609,8 +608,7 @@ static inline int inode_unhashed(struct
  * The locking order between these classes is
  * parent -> child -> normal -> xattr -> second non-directory
  */
-enum inode_i_mutex_lock_class
-{
+enum inode_i_mutex_lock_class {
 	I_MUTEX_NORMAL,
 	I_MUTEX_PARENT,
 	I_MUTEX_CHILD,
@@ -803,7 +801,7 @@ static inline struct file *get_file(stru
 /* Page cache limit. The filesystems should put that into their s_maxbytes
    limits, otherwise bad things can happen in VM. */
 #if BITS_PER_LONG == 32
-#define MAX_LFS_FILESIZE	(((loff_t)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1)
+#define MAX_LFS_FILESIZE	(((loff_t)PAGE_CACHE_SIZE << (BITS_PER_LONG - 1)) - 1)
 #elif BITS_PER_LONG == 64
 #define MAX_LFS_FILESIZE	((loff_t)0x7fffffffffffffffLL)
 #endif
@@ -950,7 +948,8 @@ int posix_lock_file(struct file *, struc
 int posix_lock_file_wait(struct file *, struct file_lock *);
 int posix_unblock_lock(struct file_lock *);
 int vfs_test_lock(struct file *, struct file_lock *);
-int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
+int vfs_lock_file(struct file *, unsigned int, struct file_lock *,
+		  struct file_lock *);
 int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
 int flock_lock_file_wait(struct file *filp, struct file_lock *fl);
 int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
@@ -998,32 +997,26 @@ static inline int fcntl_getlease(struct
 
 static inline void locks_init_lock(struct file_lock *fl)
 {
-	return;
 }
 
 static inline void __locks_copy_lock(struct file_lock *new, struct file_lock *fl)
 {
-	return;
 }
 
 static inline void locks_copy_lock(struct file_lock *new, struct file_lock *fl)
 {
-	return;
 }
 
 static inline void locks_remove_posix(struct file *filp, fl_owner_t owner)
 {
-	return;
 }
 
 static inline void locks_remove_file(struct file *filp)
 {
-	return;
 }
 
 static inline void posix_test_lock(struct file *filp, struct file_lock *fl)
 {
-	return;
 }
 
 static inline int posix_lock_file(struct file *filp, struct file_lock *fl,
@@ -1064,14 +1057,14 @@ static inline int flock_lock_file_wait(s
 	return -ENOLCK;
 }
 
-static inline int __break_lease(struct inode *inode, unsigned int mode, unsigned int type)
+static inline int __break_lease(struct inode *inode, unsigned int mode,
+				unsigned int type)
 {
 	return 0;
 }
 
 static inline void lease_get_mtime(struct inode *inode, struct timespec *time)
 {
-	return;
 }
 
 static inline int generic_setlease(struct file *filp, long arg,
@@ -1104,7 +1097,6 @@ static inline int lock_may_write(struct
 }
 #endif /* !CONFIG_FILE_LOCKING */
 
-
 struct fasync_struct {
 	spinlock_t		fa_lock;
 	int			magic;
@@ -1118,7 +1110,9 @@ struct fasync_struct {
 
 /* SMP safe fasync helpers: */
 int fasync_helper(int, struct file *, int, struct fasync_struct **);
-struct fasync_struct *fasync_insert_entry(int, struct file *, struct fasync_struct **, struct fasync_struct *);
+struct fasync_struct *fasync_insert_entry(int, struct file *,
+					  struct fasync_struct **,
+					  struct fasync_struct *);
 int fasync_remove_entry(struct file *, struct fasync_struct **);
 struct fasync_struct *fasync_alloc(void);
 void fasync_free(struct fasync_struct *);
@@ -1376,7 +1370,6 @@ static inline void sb_start_intwrite(str
 	__sb_start_write(sb, SB_FREEZE_FS, true);
 }
 
-
 bool inode_owner_or_capable(const struct inode *inode);
 
 /*
@@ -1389,7 +1382,8 @@ int vfs_symlink(struct inode *, struct d
 int vfs_link(struct dentry *, struct inode *, struct dentry *, struct inode **);
 int vfs_rmdir(struct inode *, struct dentry *);
 int vfs_unlink(struct inode *, struct dentry *, struct inode **);
-int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
+int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *,
+	       struct inode **, unsigned int);
 
 /*
  * VFS dentry helper functions.
@@ -1458,8 +1452,10 @@ struct file_operations {
 	loff_t (*llseek)(struct file *, loff_t, int);
 	ssize_t (*read)(struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*write)(struct file *, const char __user *, size_t, loff_t *);
-	ssize_t (*aio_read)(struct kiocb *, const struct iovec *, unsigned long, loff_t);
-	ssize_t (*aio_write)(struct kiocb *, const struct iovec *, unsigned long, loff_t);
+	ssize_t (*aio_read)(struct kiocb *, const struct iovec *,
+			    unsigned long, loff_t);
+	ssize_t (*aio_write)(struct kiocb *, const struct iovec *,
+			     unsigned long, loff_t);
 	ssize_t (*read_iter)(struct kiocb *, struct iov_iter *);
 	ssize_t (*write_iter)(struct kiocb *, struct iov_iter *);
 	int (*iterate)(struct file *, struct dir_context *);
@@ -1474,12 +1470,17 @@ struct file_operations {
 	int (*aio_fsync)(struct kiocb *, int datasync);
 	int (*fasync)(int, struct file *, int);
 	int (*lock)(struct file *, int, struct file_lock *);
-	ssize_t (*sendpage)(struct file *, struct page *, int, size_t, loff_t *, int);
-	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+	ssize_t (*sendpage)(struct file *, struct page *, int, size_t,
+			    loff_t *, int);
+	unsigned long (*get_unmapped_area)(struct file *, unsigned long,
+					   unsigned long, unsigned long,
+					   unsigned long);
 	int (*check_flags)(int);
 	int (*flock)(struct file *, int, struct file_lock *);
-	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
-	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
+	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *,
+				loff_t *, size_t, unsigned int);
+	ssize_t (*splice_read)(struct file *, loff_t *,
+			       struct pipe_inode_info *, size_t, unsigned int);
 	int (*setlease)(struct file *, long, struct file_lock **);
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
@@ -1487,10 +1488,10 @@ struct file_operations {
 };
 
 struct inode_operations {
-	struct dentry * (*lookup)(struct inode *, struct dentry *, unsigned int);
-	void * (*follow_link)(struct dentry *, struct nameidata *);
+	struct dentry *(*lookup)(struct inode *, struct dentry *, unsigned int);
+	void *(*follow_link)(struct dentry *, struct nameidata *);
 	int (*permission)(struct inode *, int);
-	struct posix_acl *(*get_acl)(struct inode *, int);
+	struct posix_acl * (*get_acl)(struct inode *, int);
 
 	int (*readlink)(struct dentry *, char __user *, int);
 	void (*put_link)(struct dentry *, struct nameidata *, void *);
@@ -1508,7 +1509,8 @@ struct inode_operations {
 		       struct inode *, struct dentry *, unsigned int);
 	int (*setattr)(struct dentry *, struct iattr *);
 	int (*getattr)(struct vfsmount *mnt, struct dentry *, struct kstat *);
-	int (*setxattr)(struct dentry *, const char *, const void *, size_t, int);
+	int (*setxattr)(struct dentry *, const char *, const void *, size_t,
+			int);
 	ssize_t (*getxattr)(struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr)(struct dentry *, char *, size_t);
 	int (*removexattr)(struct dentry *, const char *);
@@ -1529,10 +1531,10 @@ ssize_t rw_copy_check_uvector(int type,
 
 ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
-ssize_t vfs_readv(struct file *, const struct iovec __user *,
-		  unsigned long, loff_t *);
-ssize_t vfs_writev(struct file *, const struct iovec __user *,
-		   unsigned long, loff_t *);
+ssize_t vfs_readv(struct file *, const struct iovec __user *, unsigned long,
+		  loff_t *);
+ssize_t vfs_writev(struct file *, const struct iovec __user *, unsigned long,
+		   loff_t *);
 
 struct super_operations {
 	struct inode *(*alloc_inode)(struct super_block *sb);
@@ -1555,8 +1557,10 @@ struct super_operations {
 	int (*show_path)(struct seq_file *, struct dentry *);
 	int (*show_stats)(struct seq_file *, struct dentry *);
 #ifdef CONFIG_QUOTA
-	ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
-	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
+	ssize_t (*quota_read)(struct super_block *, int, char *, size_t,
+			      loff_t);
+	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t,
+			       loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
 	long (*nr_cached_objects)(struct super_block *, int);
@@ -1776,7 +1780,8 @@ struct file_system_type {
 #define MODULE_ALIAS_FS(NAME) MODULE_ALIAS("fs-" NAME)
 
 struct dentry *mount_ns(struct file_system_type *fs_type, int flags,
-			void *data, int (*fill_super)(struct super_block *, void *, int));
+			void *data,
+			int (*fill_super)(struct super_block *, void *, int));
 struct dentry *mount_bdev(struct file_system_type *fs_type,
 			  int flags, const char *dev_name, void *data,
 			  int (*fill_super)(struct super_block *, void *, int));
@@ -1808,7 +1813,7 @@ struct dentry *mount_pseudo(struct file_
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops)							\
 	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
-#define fops_put(fops)						\
+#define fops_put(fops)							\
 	do { if (fops) module_put((fops)->owner); } while (0)
 /*
  * This one is to be used *ONLY* from ->open() instances.
@@ -1932,7 +1937,8 @@ static inline int break_deleg(struct ino
 	return 0;
 }
 
-static inline int try_break_deleg(struct inode *inode, struct inode **delegated_inode)
+static inline int try_break_deleg(struct inode *inode,
+				  struct inode **delegated_inode)
 {
 	int ret;
 
@@ -1998,7 +2004,8 @@ static inline int break_deleg(struct ino
 	return 0;
 }
 
-static inline int try_break_deleg(struct inode *inode, struct inode **delegated_inode)
+static inline int try_break_deleg(struct inode *inode,
+				  struct inode **delegated_inode)
 {
 	return 0;
 }
@@ -2023,10 +2030,8 @@ struct filename {
 long vfs_truncate(struct path *, loff_t);
 int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		struct file *filp);
-int do_fallocate(struct file *file, int mode, loff_t offset,
-		 loff_t len);
-long do_sys_open(int dfd, const char __user *filename, int flags,
-		 umode_t mode);
+int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len);
+long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode);
 struct file *file_open_name(struct filename *, int, umode_t);
 struct file *filp_open(const char *, int, umode_t);
 struct file *file_open_root(struct dentry *, struct vfsmount *,
@@ -2042,8 +2047,7 @@ enum {
 	FILE_OPENED = 2
 };
 int finish_open(struct file *file, struct dentry *dentry,
-		int (*open)(struct inode *, struct file *),
-		int *opened);
+		int (*open)(struct inode *, struct file *), int *opened);
 int finish_no_open(struct file *file, struct dentry *dentry);
 
 /* fs/ioctl.c */
@@ -2124,8 +2128,7 @@ struct block_device *blkdev_get_by_dev(d
 void blkdev_put(struct block_device *bdev, fmode_t mode);
 #ifdef CONFIG_SYSFS
 int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
-void bd_unlink_disk_holder(struct block_device *bdev,
-			   struct gendisk *disk);
+void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk);
 #else
 static inline int bd_link_disk_holder(struct block_device *bdev,
 				      struct gendisk *disk)
@@ -2194,8 +2197,7 @@ int is_bad_inode(struct inode *);
  */
 #define bio_data_dir(bio)	((bio)->bi_rw & 1)
 
-void check_disk_size_change(struct gendisk *disk,
-			    struct block_device *bdev);
+void check_disk_size_change(struct gendisk *disk, struct block_device *bdev);
 int revalidate_disk(struct gendisk *);
 int check_disk_change(struct block_device *);
 int __invalidate_device(struct block_device *, bool);
@@ -2217,8 +2219,7 @@ int write_inode_now(struct inode *, int)
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
 int filemap_fdatawait(struct address_space *);
-int filemap_fdatawait_range(struct address_space *, loff_t lstart,
-			    loff_t lend);
+int filemap_fdatawait_range(struct address_space *, loff_t lstart, loff_t lend);
 int filemap_write_and_wait(struct address_space *mapping);
 int filemap_write_and_wait_range(struct address_space *mapping,
 				 loff_t lstart, loff_t lend);
@@ -2227,8 +2228,7 @@ int __filemap_fdatawrite_range(struct ad
 int filemap_fdatawrite_range(struct address_space *mapping,
 			     loff_t start, loff_t end);
 
-int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
-		    int datasync);
+int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync);
 int vfs_fsync(struct file *file, int datasync);
 static inline int generic_write_sync(struct file *file, loff_t pos, loff_t count)
 {
@@ -2324,11 +2324,9 @@ static inline void i_readcount_inc(struc
 #else
 static inline void i_readcount_dec(struct inode *inode)
 {
-	return;
 }
 static inline void i_readcount_inc(struct inode *inode)
 {
-	return;
 }
 #endif
 int do_pipe_flags(int *, int);
@@ -2360,16 +2358,18 @@ static inline int generic_drop_inode(str
 	return !inode->i_nlink || inode_unhashed(inode);
 }
 
-struct inode *ilookup5_nowait(struct super_block *sb,
-			      unsigned long hashval, int (*test)(struct inode *, void *),
-			      void *data);
+struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
+			      int (*test)(struct inode *, void *), void *data);
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		       int (*test)(struct inode *, void *), void *data);
 struct inode *ilookup(struct super_block *sb, unsigned long ino);
 
-struct inode *iget5_locked(struct super_block *, unsigned long, int (*test)(struct inode *, void *), int (*set)(struct inode *, void *), void *);
+struct inode *iget5_locked(struct super_block *, unsigned long,
+			   int (*test)(struct inode *, void *),
+			   int (*set)(struct inode *, void *), void *);
 struct inode *iget_locked(struct super_block *, unsigned long);
-int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
+int insert_inode_locked4(struct inode *, unsigned long,
+			 int (*test)(struct inode *, void *), void *);
 int insert_inode_locked(struct inode *);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 void lockdep_annotate_inode_mutex_key(struct inode *inode);
@@ -2416,32 +2416,39 @@ int generic_file_mmap(struct file *, str
 int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 int generic_file_remap_pages(struct vm_area_struct *, unsigned long addr,
 			     unsigned long size, pgoff_t pgoff);
-int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk);
+int generic_write_checks(struct file *file, loff_t *pos, size_t *count,
+			 int isblk);
 ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
 ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
 ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *, loff_t);
 ssize_t generic_perform_write(struct file *, struct iov_iter *, loff_t);
-ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
-ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
-ssize_t new_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
-ssize_t new_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
+ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len,
+		     loff_t *ppos);
+ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len,
+		     loff_t *ppos);
+ssize_t new_sync_read(struct file *filp, char __user *buf, size_t len,
+		     loff_t *ppos);
+ssize_t new_sync_write(struct file *filp, const char __user *buf, size_t len,
+		     loff_t *ppos);
 
 /* fs/block_dev.c */
 ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from);
-int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
-		 int datasync);
+int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync);
 void block_sync_page(struct page *page);
 
 /* fs/splice.c */
 ssize_t generic_file_splice_read(struct file *, loff_t *,
-				 struct pipe_inode_info *, size_t, unsigned int);
+				 struct pipe_inode_info *, size_t,
+				 unsigned int);
 ssize_t default_file_splice_read(struct file *, loff_t *,
-				 struct pipe_inode_info *, size_t, unsigned int);
+				 struct pipe_inode_info *, size_t,
+				 unsigned int);
 ssize_t iter_file_splice_write(struct pipe_inode_info *,
 			       struct file *, loff_t *, size_t, unsigned int);
 ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
-				struct file *out, loff_t *, size_t len, unsigned int flags);
+				struct file *out, loff_t *, size_t len,
+				unsigned int flags);
 
 void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
@@ -2460,8 +2467,8 @@ int nonseekable_open(struct inode *inode
 ssize_t xip_file_read(struct file *filp, char __user *buf, size_t len,
 		      loff_t *ppos);
 int xip_file_mmap(struct file *file, struct vm_area_struct *vma);
-ssize_t xip_file_write(struct file *filp, const char __user *buf,
-		       size_t len, loff_t *ppos);
+ssize_t xip_file_write(struct file *filp, const char __user *buf, size_t len,
+		       loff_t *ppos);
 int xip_truncate_page(struct address_space *mapping, loff_t from);
 #else
 static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
@@ -2488,12 +2495,14 @@ enum {
 void dio_end_io(struct bio *bio, int error);
 
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-			     struct block_device *bdev, struct iov_iter *iter, loff_t offset,
-			     get_block_t get_block, dio_iodone_t end_io,
-			     dio_submit_t submit_io,	int flags);
+			     struct block_device *bdev, struct iov_iter *iter,
+			     loff_t offset, get_block_t get_block,
+			     dio_iodone_t end_io, dio_submit_t submit_io,
+			     int flags);
 
 static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
-					 struct inode *inode, struct iov_iter *iter, loff_t offset,
+					 struct inode *inode,
+					 struct iov_iter *iter, loff_t offset,
 					 get_block_t get_block)
 {
 	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iter,
@@ -2516,8 +2525,7 @@ int readlink_copy(char __user *, int, co
 int page_readlink(struct dentry *, char __user *, int);
 void *page_follow_link_light(struct dentry *, struct nameidata *);
 void page_put_link(struct dentry *, struct nameidata *, void *);
-int __page_symlink(struct inode *inode, const char *symname, int len,
-		   int nofs);
+int __page_symlink(struct inode *inode, const char *symname, int len, int nofs);
 int page_symlink(struct inode *inode, const char *symname, int len);
 extern const struct inode_operations page_symlink_inode_operations;
 void kfree_put_link(struct dentry *, struct nameidata *, void *);
@@ -2544,11 +2552,10 @@ int do_vfs_ioctl(struct file *filp, unsi
 		 unsigned long arg);
 int __generic_block_fiemap(struct inode *inode,
 			   struct fiemap_extent_info *fieinfo,
-			   loff_t start, loff_t len,
-			   get_block_t *get_block);
+			   loff_t start, loff_t len, get_block_t *get_block);
 int generic_block_fiemap(struct inode *inode,
-			 struct fiemap_extent_info *fieinfo, u64 start,
-			 u64 len, get_block_t *get_block);
+			 struct fiemap_extent_info *fieinfo,
+			 u64 start, u64 len, get_block_t *get_block);
 
 void get_filesystem(struct file_system_type *fs);
 void put_filesystem(struct file_system_type *fs);
@@ -2572,7 +2579,8 @@ int simple_open(struct inode *inode, str
 int simple_link(struct dentry *, struct inode *, struct dentry *);
 int simple_unlink(struct inode *, struct dentry *);
 int simple_rmdir(struct inode *, struct dentry *);
-int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+int simple_rename(struct inode *, struct dentry *, struct inode *,
+		  struct dentry *);
 int noop_fsync(struct file *, loff_t, loff_t, int);
 int simple_empty(struct dentry *);
 int simple_readpage(struct file *file, struct page *page);
@@ -2586,18 +2594,20 @@ int always_delete_dentry(const struct de
 struct inode *alloc_anon_inode(struct super_block *);
 extern const struct dentry_operations simple_dentry_operations;
 
-struct dentry *simple_lookup(struct inode *, struct dentry *, unsigned int flags);
+struct dentry *simple_lookup(struct inode *, struct dentry *,
+			     unsigned int flags);
 ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
 extern const struct file_operations simple_dir_operations;
 extern const struct inode_operations simple_dir_inode_operations;
 struct tree_descr { char *name; const struct file_operations *ops; int mode; };
 struct dentry *d_alloc_name(struct dentry *, const char *);
 int simple_fill_super(struct super_block *, unsigned long, struct tree_descr *);
-int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
+int simple_pin_fs(struct file_system_type *, struct vfsmount **mount,
+		  int *count);
 void simple_release_fs(struct vfsmount **mount, int *count);
 
-ssize_t simple_read_from_buffer(void __user *to, size_t count,
-				loff_t *ppos, const void *from, size_t available);
+ssize_t simple_read_from_buffer(void __user *to, size_t count, loff_t *ppos,
+				const void *from, size_t available);
 ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
 			       const void __user *from, size_t count);
 
@@ -2607,8 +2617,7 @@ int generic_file_fsync(struct file *, lo
 int generic_check_addressable(unsigned, u64);
 
 #ifdef CONFIG_MIGRATION
-int buffer_migrate_page(struct address_space *,
-			struct page *, struct page *,
+int buffer_migrate_page(struct address_space *, struct page *, struct page *,
 			enum migrate_mode);
 #else
 #define buffer_migrate_page NULL
_

Patches currently in -mm which might be from joe@perches.com are

fs-fscache-make-ctl_table-static.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
printk-tweak-do_syslog-to-match-comments.patch
kernelh-remove-deprecated-pack_hex_byte.patch
mm-utilc-add-kstrimdup.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum-declarations.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
checkpatch-warn-on-unnecessary-parentheses-around-references-of-foo-bar.patch
checkpatch-allow-multiple-const-types.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
checkpatch-emit-a-warning-on-file-add-move-delete.patch
checkpatch-warn-on-break-after-goto-or-return-with-same-tab-indentation.patch
checkpatch-add-an-index-variable-for-fixed-lines.patch
checkpatch-add-ability-to-insert-and-delete-lines-to-patch-file.patch
checkpatch-add-fix_insert_line-and-fix_delete_line-helpers.patch
checkpatch-use-the-correct-indentation-for-which.patch
checkpatch-add-fix-option-for-a-couple-open_brace-misuses.patch
checkpatch-fix-brace-style-misuses-of-else-and-while.patch
checkpatch-add-for_each-tests-to-indentation-and-brace-tests.patch
checkpatch-add-short-int-to-c-variable-types.patch
checkpatch-add-signed-generic-types.patch
checkpatch-add-test-for-native-c90-types-in-unusual-order.patch
fs-isofs-logging-clean-up.patch
proc-constify-seq_operations.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
adfs-add-__printf-verification-fix-format-argument-mismatches.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
linux-next.patch
maintainers-remove-two-ancient-eata-sections.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch
maintainers-update-microcode-patterns.patch
maintainers-update-cifs-location.patch
maintainers-use-the-correct-efi-stub-location.patch
maintainers-update-clk-sirf-patterns.patch
maintainers-fix-ssbi-pattern.patch
maintainers-use-correct-filename-for-sdhci-bcm-kona.patch
maintainers-fix-pxa3xx-nand-flash-driver-pattern.patch
maintainers-update-picoxcell-patterns.patch
maintainers-remove-section-cirrus-logic-ep93xx-ohci-usb-host-driver.patch
maintainers-remove-metag-imgdafs-pattern.patch
maintainers-remove-unused-radeon-drm-pattern.patch
maintainers-remove-unusd-arm-qualcomm-msm-pattern.patch
maintainers-remove-unused-nfsd-pattern.patch
fsh-remove-unnecessary-extern-prototypes.patch
fsh-whitespace-neatening.patch
fsh-a-few-more-whitespace-neatenings.patch
fsh-add-argument-names-to-struct-file_lock_operations-funcs.patch
fsh-add-member-argument-descriptions-to-lock_manager_operations.patch
dlm-plock-add-argument-descriptions-to-notify.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch
fs-dlm-lockd-convert-int-result-to-unsigned-char-type.patch

