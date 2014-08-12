From: akpm@linux-foundation.org
Subject: [obsolete] fsh-a-few-more-whitespace-neatenings.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:35:32 -0700
Message-ID: <53ea6c84.hNvbjyWHfN1E1zIG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:37139 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaHLTfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:35:33 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2672016pde.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:35:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bfields@fieldses.org, ccaulfie@redhat.com, jlayton@poochiereds.net, teigland@redhat.com, trond.myklebust@primarydata.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs.h: a few more whitespace neatenings
has been removed from the -mm tree.  Its filename was
     fsh-a-few-more-whitespace-neatenings.patch

This patch was dropped because it is obsolete

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
@@ -634,8 +633,7 @@ static inline int inode_unhashed(struct
  * The locking order between these classes is
  * parent -> child -> normal -> xattr -> second non-directory
  */
-enum inode_i_mutex_lock_class
-{
+enum inode_i_mutex_lock_class {
 	I_MUTEX_NORMAL,
 	I_MUTEX_PARENT,
 	I_MUTEX_CHILD,
@@ -828,7 +826,7 @@ static inline struct file *get_file(stru
 /* Page cache limit. The filesystems should put that into their s_maxbytes
    limits, otherwise bad things can happen in VM. */
 #if BITS_PER_LONG == 32
-#define MAX_LFS_FILESIZE	(((loff_t)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1)
+#define MAX_LFS_FILESIZE	(((loff_t)PAGE_CACHE_SIZE << (BITS_PER_LONG - 1)) - 1)
 #elif BITS_PER_LONG == 64
 #define MAX_LFS_FILESIZE	((loff_t)0x7fffffffffffffffLL)
 #endif
@@ -975,7 +973,8 @@ int posix_lock_file(struct file *, struc
 int posix_lock_file_wait(struct file *, struct file_lock *);
 int posix_unblock_lock(struct file_lock *);
 int vfs_test_lock(struct file *, struct file_lock *);
-int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
+int vfs_lock_file(struct file *, unsigned int, struct file_lock *,
+		  struct file_lock *);
 int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
 int flock_lock_file_wait(struct file *filp, struct file_lock *fl);
 int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
@@ -1023,32 +1022,26 @@ static inline int fcntl_getlease(struct
 
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
@@ -1089,14 +1082,14 @@ static inline int flock_lock_file_wait(s
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
@@ -1129,7 +1122,6 @@ static inline int lock_may_write(struct
 }
 #endif /* !CONFIG_FILE_LOCKING */
 
-
 struct fasync_struct {
 	spinlock_t		fa_lock;
 	int			magic;
@@ -1143,7 +1135,9 @@ struct fasync_struct {
 
 /* SMP safe fasync helpers: */
 int fasync_helper(int, struct file *, int, struct fasync_struct **);
-struct fasync_struct *fasync_insert_entry(int, struct file *, struct fasync_struct **, struct fasync_struct *);
+struct fasync_struct *fasync_insert_entry(int, struct file *,
+					  struct fasync_struct **,
+					  struct fasync_struct *);
 int fasync_remove_entry(struct file *, struct fasync_struct **);
 struct fasync_struct *fasync_alloc(void);
 void fasync_free(struct fasync_struct *);
@@ -1401,7 +1395,6 @@ static inline void sb_start_intwrite(str
 	__sb_start_write(sb, SB_FREEZE_FS, true);
 }
 
-
 bool inode_owner_or_capable(const struct inode *inode);
 
 /*
@@ -1414,7 +1407,8 @@ int vfs_symlink(struct inode *, struct d
 int vfs_link(struct dentry *, struct inode *, struct dentry *, struct inode **);
 int vfs_rmdir(struct inode *, struct dentry *);
 int vfs_unlink(struct inode *, struct dentry *, struct inode **);
-int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
+int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *,
+	       struct inode **, unsigned int);
 
 /*
  * VFS dentry helper functions.
@@ -1483,8 +1477,10 @@ struct file_operations {
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
@@ -1499,12 +1495,17 @@ struct file_operations {
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
@@ -1512,10 +1513,10 @@ struct file_operations {
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
@@ -1533,7 +1534,8 @@ struct inode_operations {
 		       struct inode *, struct dentry *, unsigned int);
 	int (*setattr)(struct dentry *, struct iattr *);
 	int (*getattr)(struct vfsmount *mnt, struct dentry *, struct kstat *);
-	int (*setxattr)(struct dentry *, const char *, const void *, size_t, int);
+	int (*setxattr)(struct dentry *, const char *, const void *, size_t,
+			int);
 	ssize_t (*getxattr)(struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr)(struct dentry *, char *, size_t);
 	int (*removexattr)(struct dentry *, const char *);
@@ -1554,10 +1556,10 @@ ssize_t rw_copy_check_uvector(int type,
 
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
@@ -1580,8 +1582,10 @@ struct super_operations {
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
@@ -1801,7 +1805,8 @@ struct file_system_type {
 #define MODULE_ALIAS_FS(NAME) MODULE_ALIAS("fs-" NAME)
 
 struct dentry *mount_ns(struct file_system_type *fs_type, int flags,
-			void *data, int (*fill_super)(struct super_block *, void *, int));
+			void *data,
+			int (*fill_super)(struct super_block *, void *, int));
 struct dentry *mount_bdev(struct file_system_type *fs_type,
 			  int flags, const char *dev_name, void *data,
 			  int (*fill_super)(struct super_block *, void *, int));
@@ -1833,7 +1838,7 @@ struct dentry *mount_pseudo(struct file_
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops)							\
 	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
-#define fops_put(fops)						\
+#define fops_put(fops)							\
 	do { if (fops) module_put((fops)->owner); } while (0)
 /*
  * This one is to be used *ONLY* from ->open() instances.
@@ -1957,7 +1962,8 @@ static inline int break_deleg(struct ino
 	return 0;
 }
 
-static inline int try_break_deleg(struct inode *inode, struct inode **delegated_inode)
+static inline int try_break_deleg(struct inode *inode,
+				  struct inode **delegated_inode)
 {
 	int ret;
 
@@ -2023,7 +2029,8 @@ static inline int break_deleg(struct ino
 	return 0;
 }
 
-static inline int try_break_deleg(struct inode *inode, struct inode **delegated_inode)
+static inline int try_break_deleg(struct inode *inode,
+				  struct inode **delegated_inode)
 {
 	return 0;
 }
@@ -2048,10 +2055,8 @@ struct filename {
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
@@ -2067,8 +2072,7 @@ enum {
 	FILE_OPENED = 2
 };
 int finish_open(struct file *file, struct dentry *dentry,
-		int (*open)(struct inode *, struct file *),
-		int *opened);
+		int (*open)(struct inode *, struct file *), int *opened);
 int finish_no_open(struct file *file, struct dentry *dentry);
 
 /* fs/ioctl.c */
@@ -2149,8 +2153,7 @@ struct block_device *blkdev_get_by_dev(d
 void blkdev_put(struct block_device *bdev, fmode_t mode);
 #ifdef CONFIG_SYSFS
 int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
-void bd_unlink_disk_holder(struct block_device *bdev,
-			   struct gendisk *disk);
+void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk);
 #else
 static inline int bd_link_disk_holder(struct block_device *bdev,
 				      struct gendisk *disk)
@@ -2219,8 +2222,7 @@ int is_bad_inode(struct inode *);
  */
 #define bio_data_dir(bio)	((bio)->bi_rw & 1)
 
-void check_disk_size_change(struct gendisk *disk,
-			    struct block_device *bdev);
+void check_disk_size_change(struct gendisk *disk, struct block_device *bdev);
 int revalidate_disk(struct gendisk *);
 int check_disk_change(struct block_device *);
 int __invalidate_device(struct block_device *, bool);
@@ -2242,8 +2244,7 @@ int write_inode_now(struct inode *, int)
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
 int filemap_fdatawait(struct address_space *);
-int filemap_fdatawait_range(struct address_space *, loff_t lstart,
-			    loff_t lend);
+int filemap_fdatawait_range(struct address_space *, loff_t lstart, loff_t lend);
 int filemap_write_and_wait(struct address_space *mapping);
 int filemap_write_and_wait_range(struct address_space *mapping,
 				 loff_t lstart, loff_t lend);
@@ -2252,8 +2253,7 @@ int __filemap_fdatawrite_range(struct ad
 int filemap_fdatawrite_range(struct address_space *mapping,
 			     loff_t start, loff_t end);
 
-int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
-		    int datasync);
+int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync);
 int vfs_fsync(struct file *file, int datasync);
 static inline int generic_write_sync(struct file *file, loff_t pos, loff_t count)
 {
@@ -2349,11 +2349,9 @@ static inline void i_readcount_inc(struc
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
@@ -2385,16 +2383,18 @@ static inline int generic_drop_inode(str
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
@@ -2441,32 +2441,39 @@ int generic_file_mmap(struct file *, str
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
@@ -2485,8 +2492,8 @@ int nonseekable_open(struct inode *inode
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
@@ -2513,12 +2520,14 @@ enum {
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
@@ -2541,8 +2550,7 @@ int readlink_copy(char __user *, int, co
 int page_readlink(struct dentry *, char __user *, int);
 void *page_follow_link_light(struct dentry *, struct nameidata *);
 void page_put_link(struct dentry *, struct nameidata *, void *);
-int __page_symlink(struct inode *inode, const char *symname, int len,
-		   int nofs);
+int __page_symlink(struct inode *inode, const char *symname, int len, int nofs);
 int page_symlink(struct inode *inode, const char *symname, int len);
 extern const struct inode_operations page_symlink_inode_operations;
 void kfree_put_link(struct dentry *, struct nameidata *, void *);
@@ -2569,11 +2577,10 @@ int do_vfs_ioctl(struct file *filp, unsi
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
@@ -2597,7 +2604,8 @@ int simple_open(struct inode *inode, str
 int simple_link(struct dentry *, struct inode *, struct dentry *);
 int simple_unlink(struct inode *, struct dentry *);
 int simple_rmdir(struct inode *, struct dentry *);
-int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+int simple_rename(struct inode *, struct dentry *, struct inode *,
+		  struct dentry *);
 int noop_fsync(struct file *, loff_t, loff_t, int);
 int simple_empty(struct dentry *);
 int simple_readpage(struct file *file, struct page *page);
@@ -2611,18 +2619,20 @@ int always_delete_dentry(const struct de
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
 
@@ -2632,8 +2642,7 @@ int generic_file_fsync(struct file *, lo
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

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
fsh-add-argument-names-to-struct-file_lock_operations-funcs.patch
fsh-add-member-argument-descriptions-to-lock_manager_operations.patch
dlm-plock-add-argument-descriptions-to-notify.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch

