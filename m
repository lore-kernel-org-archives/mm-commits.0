From: akpm@linux-foundation.org
Subject: [obsolete] fsh-remove-unnecessary-extern-prototypes.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:35:28 -0700
Message-ID: <53ea6c80.NcGl/1n13lsoiOaF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:44357 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaHLTfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:35:30 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so1307978yhl.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:35:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bfields@fieldses.org, ccaulfie@redhat.com, jlayton@poochiereds.net, teigland@redhat.com, trond.myklebust@primarydata.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs.h: remove unnecessary extern prototypes
has been removed from the -mm tree.  Its filename was
     fsh-remove-unnecessary-extern-prototypes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: fs.h: remove unnecessary extern prototypes

This file has a mixture of prototypes with and without extern.  Remove the
extern uses.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Teigland <teigland@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |  640 +++++++++++++++++++++----------------------
 1 file changed, 320 insertions(+), 320 deletions(-)

diff -puN include/linux/fs.h~fsh-remove-unnecessary-extern-prototypes include/linux/fs.h
--- a/include/linux/fs.h~fsh-remove-unnecessary-extern-prototypes
+++ a/include/linux/fs.h
@@ -50,12 +50,12 @@ struct seq_file;
 struct workqueue_struct;
 struct iov_iter;
 
-extern void __init inode_init(void);
-extern void __init inode_init_early(void);
-extern void __init files_init(unsigned long);
+void __init inode_init(void);
+void __init inode_init_early(void);
+void __init files_init(unsigned long);
 
 extern struct files_stat_struct files_stat;
-extern unsigned long get_max_files(void);
+unsigned long get_max_files(void);
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
@@ -736,7 +736,7 @@ static inline unsigned imajor(const stru
 	return MAJOR(inode->i_rdev);
 }
 
-extern struct block_device *I_BDEV(struct inode *inode);
+struct block_device *I_BDEV(struct inode *inode);
 
 struct fown_struct {
 	rwlock_t lock;          /* protects pid, uid, euid fields */
@@ -945,46 +945,46 @@ struct file_lock {
 
 #include <linux/fcntl.h>
 
-extern void send_sigio(struct fown_struct *fown, int fd, int band);
+void send_sigio(struct fown_struct *fown, int fd, int band);
 
 #ifdef CONFIG_FILE_LOCKING
-extern int fcntl_getlk(struct file *, unsigned int, struct flock __user *);
-extern int fcntl_setlk(unsigned int, struct file *, unsigned int,
+int fcntl_getlk(struct file *, unsigned int, struct flock __user *);
+int fcntl_setlk(unsigned int, struct file *, unsigned int,
 			struct flock __user *);
 
 #if BITS_PER_LONG == 32
-extern int fcntl_getlk64(struct file *, unsigned int, struct flock64 __user *);
-extern int fcntl_setlk64(unsigned int, struct file *, unsigned int,
+int fcntl_getlk64(struct file *, unsigned int, struct flock64 __user *);
+int fcntl_setlk64(unsigned int, struct file *, unsigned int,
 			struct flock64 __user *);
 #endif
 
-extern int fcntl_setlease(unsigned int fd, struct file *filp, long arg);
-extern int fcntl_getlease(struct file *filp);
+int fcntl_setlease(unsigned int fd, struct file *filp, long arg);
+int fcntl_getlease(struct file *filp);
 
 /* fs/locks.c */
 void locks_free_lock(struct file_lock *fl);
-extern void locks_init_lock(struct file_lock *);
-extern struct file_lock * locks_alloc_lock(void);
-extern void locks_copy_lock(struct file_lock *, struct file_lock *);
-extern void __locks_copy_lock(struct file_lock *, const struct file_lock *);
-extern void locks_remove_posix(struct file *, fl_owner_t);
-extern void locks_remove_file(struct file *);
-extern void locks_release_private(struct file_lock *);
-extern void posix_test_lock(struct file *, struct file_lock *);
-extern int posix_lock_file(struct file *, struct file_lock *, struct file_lock *);
-extern int posix_lock_file_wait(struct file *, struct file_lock *);
-extern int posix_unblock_lock(struct file_lock *);
-extern int vfs_test_lock(struct file *, struct file_lock *);
-extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
-extern int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
-extern int flock_lock_file_wait(struct file *filp, struct file_lock *fl);
-extern int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
-extern void lease_get_mtime(struct inode *, struct timespec *time);
-extern int generic_setlease(struct file *, long, struct file_lock **);
-extern int vfs_setlease(struct file *, long, struct file_lock **);
-extern int lease_modify(struct file_lock **, int);
-extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
-extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
+void locks_init_lock(struct file_lock *);
+struct file_lock * locks_alloc_lock(void);
+void locks_copy_lock(struct file_lock *, struct file_lock *);
+void __locks_copy_lock(struct file_lock *, const struct file_lock *);
+void locks_remove_posix(struct file *, fl_owner_t);
+void locks_remove_file(struct file *);
+void locks_release_private(struct file_lock *);
+void posix_test_lock(struct file *, struct file_lock *);
+int posix_lock_file(struct file *, struct file_lock *, struct file_lock *);
+int posix_lock_file_wait(struct file *, struct file_lock *);
+int posix_unblock_lock(struct file_lock *);
+int vfs_test_lock(struct file *, struct file_lock *);
+int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
+int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
+int flock_lock_file_wait(struct file *filp, struct file_lock *fl);
+int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
+void lease_get_mtime(struct inode *, struct timespec *time);
+int generic_setlease(struct file *, long, struct file_lock **);
+int vfs_setlease(struct file *, long, struct file_lock **);
+int lease_modify(struct file_lock **, int);
+int lock_may_read(struct inode *, loff_t start, unsigned long count);
+int lock_may_write(struct inode *, loff_t start, unsigned long count);
 #else /* !CONFIG_FILE_LOCKING */
 static inline int fcntl_getlk(struct file *file, unsigned int cmd,
 			      struct flock __user *user)
@@ -1142,20 +1142,20 @@ struct fasync_struct {
 #define FASYNC_MAGIC 0x4601
 
 /* SMP safe fasync helpers: */
-extern int fasync_helper(int, struct file *, int, struct fasync_struct **);
-extern struct fasync_struct *fasync_insert_entry(int, struct file *, struct fasync_struct **, struct fasync_struct *);
-extern int fasync_remove_entry(struct file *, struct fasync_struct **);
-extern struct fasync_struct *fasync_alloc(void);
-extern void fasync_free(struct fasync_struct *);
+int fasync_helper(int, struct file *, int, struct fasync_struct **);
+struct fasync_struct *fasync_insert_entry(int, struct file *, struct fasync_struct **, struct fasync_struct *);
+int fasync_remove_entry(struct file *, struct fasync_struct **);
+struct fasync_struct *fasync_alloc(void);
+void fasync_free(struct fasync_struct *);
 
 /* can be called from interrupts */
-extern void kill_fasync(struct fasync_struct **, int, int);
+void kill_fasync(struct fasync_struct **, int, int);
 
-extern int __f_setown(struct file *filp, struct pid *, enum pid_type, int force);
-extern int f_setown(struct file *filp, unsigned long arg, int force);
-extern void f_delown(struct file *filp);
-extern pid_t f_getown(struct file *filp);
-extern int send_sigurg(struct fown_struct *fown);
+int __f_setown(struct file *filp, struct pid *, enum pid_type, int force);
+int f_setown(struct file *filp, unsigned long arg, int force);
+void f_delown(struct file *filp);
+pid_t f_getown(struct file *filp);
+int send_sigurg(struct fown_struct *fown);
 
 struct mm_struct;
 
@@ -1285,7 +1285,7 @@ struct super_block {
 	struct rcu_head		rcu;
 };
 
-extern struct timespec current_fs_time(struct super_block *sb);
+struct timespec current_fs_time(struct super_block *sb);
 
 /*
  * Snapshotting support.
@@ -1402,29 +1402,29 @@ static inline void sb_start_intwrite(str
 }
 
 
-extern bool inode_owner_or_capable(const struct inode *inode);
+bool inode_owner_or_capable(const struct inode *inode);
 
 /*
  * VFS helper functions..
  */
-extern int vfs_create(struct inode *, struct dentry *, umode_t, bool);
-extern int vfs_mkdir(struct inode *, struct dentry *, umode_t);
-extern int vfs_mknod(struct inode *, struct dentry *, umode_t, dev_t);
-extern int vfs_symlink(struct inode *, struct dentry *, const char *);
-extern int vfs_link(struct dentry *, struct inode *, struct dentry *, struct inode **);
-extern int vfs_rmdir(struct inode *, struct dentry *);
-extern int vfs_unlink(struct inode *, struct dentry *, struct inode **);
-extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
+int vfs_create(struct inode *, struct dentry *, umode_t, bool);
+int vfs_mkdir(struct inode *, struct dentry *, umode_t);
+int vfs_mknod(struct inode *, struct dentry *, umode_t, dev_t);
+int vfs_symlink(struct inode *, struct dentry *, const char *);
+int vfs_link(struct dentry *, struct inode *, struct dentry *, struct inode **);
+int vfs_rmdir(struct inode *, struct dentry *);
+int vfs_unlink(struct inode *, struct dentry *, struct inode **);
+int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
 
 /*
  * VFS dentry helper functions.
  */
-extern void dentry_unhash(struct dentry *dentry);
+void dentry_unhash(struct dentry *dentry);
 
 /*
  * VFS file helper functions.
  */
-extern void inode_init_owner(struct inode *inode, const struct inode *dir,
+void inode_init_owner(struct inode *inode, const struct inode *dir,
 			umode_t mode);
 /*
  * VFS FS_IOC_FIEMAP helper definitions.
@@ -1552,11 +1552,11 @@ ssize_t rw_copy_check_uvector(int type,
 			      struct iovec *fast_pointer,
 			      struct iovec **ret_pointer);
 
-extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
-extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
-extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
+ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
+ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
+ssize_t vfs_readv(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *);
-extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
+ssize_t vfs_writev(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *);
 
 struct super_operations {
@@ -1712,7 +1712,7 @@ struct super_operations {
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
-extern void __mark_inode_dirty(struct inode *, int);
+void __mark_inode_dirty(struct inode *, int);
 static inline void mark_inode_dirty(struct inode *inode)
 {
 	__mark_inode_dirty(inode, I_DIRTY);
@@ -1723,10 +1723,10 @@ static inline void mark_inode_dirty_sync
 	__mark_inode_dirty(inode, I_DIRTY_SYNC);
 }
 
-extern void inc_nlink(struct inode *inode);
-extern void drop_nlink(struct inode *inode);
-extern void clear_nlink(struct inode *inode);
-extern void set_nlink(struct inode *inode, unsigned int nlink);
+void inc_nlink(struct inode *inode);
+void drop_nlink(struct inode *inode);
+void clear_nlink(struct inode *inode);
+void set_nlink(struct inode *inode, unsigned int nlink);
 
 static inline void inode_inc_link_count(struct inode *inode)
 {
@@ -1762,7 +1762,7 @@ enum file_time_flags {
 	S_VERSION = 8,
 };
 
-extern void touch_atime(const struct path *);
+void touch_atime(const struct path *);
 static inline void file_accessed(struct file *file)
 {
 	if (!(file->f_flags & O_NOATIME))
@@ -1800,18 +1800,18 @@ struct file_system_type {
 
 #define MODULE_ALIAS_FS(NAME) MODULE_ALIAS("fs-" NAME)
 
-extern struct dentry *mount_ns(struct file_system_type *fs_type, int flags,
+struct dentry *mount_ns(struct file_system_type *fs_type, int flags,
 	void *data, int (*fill_super)(struct super_block *, void *, int));
-extern struct dentry *mount_bdev(struct file_system_type *fs_type,
+struct dentry *mount_bdev(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data,
 	int (*fill_super)(struct super_block *, void *, int));
-extern struct dentry *mount_single(struct file_system_type *fs_type,
+struct dentry *mount_single(struct file_system_type *fs_type,
 	int flags, void *data,
 	int (*fill_super)(struct super_block *, void *, int));
-extern struct dentry *mount_nodev(struct file_system_type *fs_type,
+struct dentry *mount_nodev(struct file_system_type *fs_type,
 	int flags, void *data,
 	int (*fill_super)(struct super_block *, void *, int));
-extern struct dentry *mount_subtree(struct vfsmount *mnt, const char *path);
+struct dentry *mount_subtree(struct vfsmount *mnt, const char *path);
 void generic_shutdown_super(struct super_block *sb);
 void kill_block_super(struct super_block *sb);
 void kill_anon_super(struct super_block *sb);
@@ -1825,7 +1825,7 @@ struct super_block *sget(struct file_sys
 			int (*test)(struct super_block *,void *),
 			int (*set)(struct super_block *,void *),
 			int flags, void *data);
-extern struct dentry *mount_pseudo(struct file_system_type *, char *,
+struct dentry *mount_pseudo(struct file_system_type *, char *,
 	const struct super_operations *ops,
 	const struct dentry_operations *dops,
 	unsigned long);
@@ -1847,31 +1847,31 @@ extern struct dentry *mount_pseudo(struc
 		BUG_ON(!(__file->f_op = (fops))); \
 	} while(0)
 
-extern int register_filesystem(struct file_system_type *);
-extern int unregister_filesystem(struct file_system_type *);
-extern struct vfsmount *kern_mount_data(struct file_system_type *, void *data);
+int register_filesystem(struct file_system_type *);
+int unregister_filesystem(struct file_system_type *);
+struct vfsmount *kern_mount_data(struct file_system_type *, void *data);
 #define kern_mount(type) kern_mount_data(type, NULL)
-extern void kern_unmount(struct vfsmount *mnt);
-extern int may_umount_tree(struct vfsmount *);
-extern int may_umount(struct vfsmount *);
-extern long do_mount(const char *, const char *, const char *, unsigned long, void *);
-extern struct vfsmount *collect_mounts(struct path *);
-extern void drop_collected_mounts(struct vfsmount *);
-extern int iterate_mounts(int (*)(struct vfsmount *, void *), void *,
+void kern_unmount(struct vfsmount *mnt);
+int may_umount_tree(struct vfsmount *);
+int may_umount(struct vfsmount *);
+long do_mount(const char *, const char *, const char *, unsigned long, void *);
+struct vfsmount *collect_mounts(struct path *);
+void drop_collected_mounts(struct vfsmount *);
+int iterate_mounts(int (*)(struct vfsmount *, void *), void *,
 			  struct vfsmount *);
-extern int vfs_statfs(struct path *, struct kstatfs *);
-extern int user_statfs(const char __user *, struct kstatfs *);
-extern int fd_statfs(int, struct kstatfs *);
-extern int vfs_ustat(dev_t, struct kstatfs *);
-extern int freeze_super(struct super_block *super);
-extern int thaw_super(struct super_block *super);
-extern bool our_mnt(struct vfsmount *mnt);
-extern bool fs_fully_visible(struct file_system_type *);
+int vfs_statfs(struct path *, struct kstatfs *);
+int user_statfs(const char __user *, struct kstatfs *);
+int fd_statfs(int, struct kstatfs *);
+int vfs_ustat(dev_t, struct kstatfs *);
+int freeze_super(struct super_block *super);
+int thaw_super(struct super_block *super);
+bool our_mnt(struct vfsmount *mnt);
+bool fs_fully_visible(struct file_system_type *);
 
-extern int current_umask(void);
+int current_umask(void);
 
-extern void ihold(struct inode * inode);
-extern void iput(struct inode *);
+void ihold(struct inode * inode);
+void iput(struct inode *);
 
 static inline struct inode *file_inode(struct file *f)
 {
@@ -1887,8 +1887,8 @@ extern struct kobject *fs_kobj;
 #define FLOCK_VERIFY_WRITE 2
 
 #ifdef CONFIG_FILE_LOCKING
-extern int locks_mandatory_locked(struct file *);
-extern int locks_mandatory_area(int, struct inode *, struct file *, loff_t, size_t);
+int locks_mandatory_locked(struct file *);
+int locks_mandatory_area(int, struct inode *, struct file *, loff_t, size_t);
 
 /*
  * Candidates for mandatory locking have the setgid bit set
@@ -2045,69 +2045,69 @@ struct filename {
 	bool			separate; /* should "name" be freed? */
 };
 
-extern long vfs_truncate(struct path *, loff_t);
-extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
+long vfs_truncate(struct path *, loff_t);
+int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
-extern int do_fallocate(struct file *file, int mode, loff_t offset,
+int do_fallocate(struct file *file, int mode, loff_t offset,
 			loff_t len);
-extern long do_sys_open(int dfd, const char __user *filename, int flags,
+long do_sys_open(int dfd, const char __user *filename, int flags,
 			umode_t mode);
-extern struct file *file_open_name(struct filename *, int, umode_t);
-extern struct file *filp_open(const char *, int, umode_t);
-extern struct file *file_open_root(struct dentry *, struct vfsmount *,
+struct file *file_open_name(struct filename *, int, umode_t);
+struct file *filp_open(const char *, int, umode_t);
+struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int);
-extern struct file * dentry_open(const struct path *, int, const struct cred *);
-extern int filp_close(struct file *, fl_owner_t id);
+struct file * dentry_open(const struct path *, int, const struct cred *);
+int filp_close(struct file *, fl_owner_t id);
 
-extern struct filename *getname(const char __user *);
-extern struct filename *getname_kernel(const char *);
+struct filename *getname(const char __user *);
+struct filename *getname_kernel(const char *);
 
 enum {
 	FILE_CREATED = 1,
 	FILE_OPENED = 2
 };
-extern int finish_open(struct file *file, struct dentry *dentry,
+int finish_open(struct file *file, struct dentry *dentry,
 			int (*open)(struct inode *, struct file *),
 			int *opened);
-extern int finish_no_open(struct file *file, struct dentry *dentry);
+int finish_no_open(struct file *file, struct dentry *dentry);
 
 /* fs/ioctl.c */
 
-extern int ioctl_preallocate(struct file *filp, void __user *argp);
+int ioctl_preallocate(struct file *filp, void __user *argp);
 
 /* fs/dcache.c */
-extern void __init vfs_caches_init_early(void);
-extern void __init vfs_caches_init(unsigned long);
+void __init vfs_caches_init_early(void);
+void __init vfs_caches_init(unsigned long);
 
 extern struct kmem_cache *names_cachep;
 
-extern void final_putname(struct filename *name);
+void final_putname(struct filename *name);
 
 #define __getname()		kmem_cache_alloc(names_cachep, GFP_KERNEL)
 #define __putname(name)		kmem_cache_free(names_cachep, (void *)(name))
 #ifndef CONFIG_AUDITSYSCALL
 #define putname(name)		final_putname(name)
 #else
-extern void putname(struct filename *name);
+void putname(struct filename *name);
 #endif
 
 #ifdef CONFIG_BLOCK
-extern int register_blkdev(unsigned int, const char *);
-extern void unregister_blkdev(unsigned int, const char *);
-extern struct block_device *bdget(dev_t);
-extern struct block_device *bdgrab(struct block_device *bdev);
-extern void bd_set_size(struct block_device *, loff_t size);
-extern void bd_forget(struct inode *inode);
-extern void bdput(struct block_device *);
-extern void invalidate_bdev(struct block_device *);
-extern void iterate_bdevs(void (*)(struct block_device *, void *), void *);
-extern int sync_blockdev(struct block_device *bdev);
-extern void kill_bdev(struct block_device *);
-extern struct super_block *freeze_bdev(struct block_device *);
-extern void emergency_thaw_all(void);
-extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
-extern int fsync_bdev(struct block_device *);
-extern int sb_is_blkdev_sb(struct super_block *sb);
+int register_blkdev(unsigned int, const char *);
+void unregister_blkdev(unsigned int, const char *);
+struct block_device *bdget(dev_t);
+struct block_device *bdgrab(struct block_device *bdev);
+void bd_set_size(struct block_device *, loff_t size);
+void bd_forget(struct inode *inode);
+void bdput(struct block_device *);
+void invalidate_bdev(struct block_device *);
+void iterate_bdevs(void (*)(struct block_device *, void *), void *);
+int sync_blockdev(struct block_device *bdev);
+void kill_bdev(struct block_device *);
+struct super_block *freeze_bdev(struct block_device *);
+void emergency_thaw_all(void);
+int thaw_bdev(struct block_device *bdev, struct super_block *sb);
+int fsync_bdev(struct block_device *);
+int sb_is_blkdev_sb(struct super_block *sb);
 #else
 static inline void bd_forget(struct inode *inode) {}
 static inline int sync_blockdev(struct block_device *bdev) { return 0; }
@@ -2133,23 +2133,23 @@ static inline int sb_is_blkdev_sb(struct
 	return 0;
 }
 #endif
-extern int sync_filesystem(struct super_block *);
+int sync_filesystem(struct super_block *);
 extern const struct file_operations def_blk_fops;
 extern const struct file_operations def_chr_fops;
 extern const struct file_operations bad_sock_fops;
 #ifdef CONFIG_BLOCK
-extern int ioctl_by_bdev(struct block_device *, unsigned, unsigned long);
-extern int blkdev_ioctl(struct block_device *, fmode_t, unsigned, unsigned long);
-extern long compat_blkdev_ioctl(struct file *, unsigned, unsigned long);
-extern int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder);
-extern struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
+int ioctl_by_bdev(struct block_device *, unsigned, unsigned long);
+int blkdev_ioctl(struct block_device *, fmode_t, unsigned, unsigned long);
+long compat_blkdev_ioctl(struct file *, unsigned, unsigned long);
+int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder);
+struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
 					       void *holder);
-extern struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode,
+struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode,
 					      void *holder);
-extern void blkdev_put(struct block_device *bdev, fmode_t mode);
+void blkdev_put(struct block_device *bdev, fmode_t mode);
 #ifdef CONFIG_SYSFS
-extern int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
-extern void bd_unlink_disk_holder(struct block_device *bdev,
+int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
+void bd_unlink_disk_holder(struct block_device *bdev,
 				  struct gendisk *disk);
 #else
 static inline int bd_link_disk_holder(struct block_device *bdev,
@@ -2166,15 +2166,15 @@ static inline void bd_unlink_disk_holder
 
 /* fs/char_dev.c */
 #define CHRDEV_MAJOR_HASH_SIZE	255
-extern int alloc_chrdev_region(dev_t *, unsigned, unsigned, const char *);
-extern int register_chrdev_region(dev_t, unsigned, const char *);
-extern int __register_chrdev(unsigned int major, unsigned int baseminor,
+int alloc_chrdev_region(dev_t *, unsigned, unsigned, const char *);
+int register_chrdev_region(dev_t, unsigned, const char *);
+int __register_chrdev(unsigned int major, unsigned int baseminor,
 			     unsigned int count, const char *name,
 			     const struct file_operations *fops);
-extern void __unregister_chrdev(unsigned int major, unsigned int baseminor,
+void __unregister_chrdev(unsigned int major, unsigned int baseminor,
 				unsigned int count, const char *name);
-extern void unregister_chrdev_region(dev_t, unsigned);
-extern void chrdev_show(struct seq_file *,off_t);
+void unregister_chrdev_region(dev_t, unsigned);
+void chrdev_show(struct seq_file *,off_t);
 
 static inline int register_chrdev(unsigned int major, const char *name,
 				  const struct file_operations *fops)
@@ -2193,20 +2193,20 @@ static inline void unregister_chrdev(uns
 
 #ifdef CONFIG_BLOCK
 #define BLKDEV_MAJOR_HASH_SIZE	255
-extern const char *__bdevname(dev_t, char *buffer);
-extern const char *bdevname(struct block_device *bdev, char *buffer);
-extern struct block_device *lookup_bdev(const char *);
-extern void blkdev_show(struct seq_file *,off_t);
+const char *__bdevname(dev_t, char *buffer);
+const char *bdevname(struct block_device *bdev, char *buffer);
+struct block_device *lookup_bdev(const char *);
+void blkdev_show(struct seq_file *,off_t);
 
 #else
 #define BLKDEV_MAJOR_HASH_SIZE	0
 #endif
 
-extern void init_special_inode(struct inode *, umode_t, dev_t);
+void init_special_inode(struct inode *, umode_t, dev_t);
 
 /* Invalid inode operations -- fs/bad_inode.c */
-extern void make_bad_inode(struct inode *);
-extern int is_bad_inode(struct inode *);
+void make_bad_inode(struct inode *);
+int is_bad_inode(struct inode *);
 
 #ifdef CONFIG_BLOCK
 /*
@@ -2219,12 +2219,12 @@ extern int is_bad_inode(struct inode *);
  */
 #define bio_data_dir(bio)	((bio)->bi_rw & 1)
 
-extern void check_disk_size_change(struct gendisk *disk,
+void check_disk_size_change(struct gendisk *disk,
 				   struct block_device *bdev);
-extern int revalidate_disk(struct gendisk *);
-extern int check_disk_change(struct block_device *);
-extern int __invalidate_device(struct block_device *, bool);
-extern int invalidate_partition(struct gendisk *, int);
+int revalidate_disk(struct gendisk *);
+int check_disk_change(struct block_device *);
+int __invalidate_device(struct block_device *, bool);
+int invalidate_partition(struct gendisk *, int);
 #endif
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
@@ -2235,26 +2235,26 @@ static inline void invalidate_remote_ino
 	    S_ISLNK(inode->i_mode))
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 }
-extern int invalidate_inode_pages2(struct address_space *mapping);
-extern int invalidate_inode_pages2_range(struct address_space *mapping,
+int invalidate_inode_pages2(struct address_space *mapping);
+int invalidate_inode_pages2_range(struct address_space *mapping,
 					 pgoff_t start, pgoff_t end);
-extern int write_inode_now(struct inode *, int);
-extern int filemap_fdatawrite(struct address_space *);
-extern int filemap_flush(struct address_space *);
-extern int filemap_fdatawait(struct address_space *);
-extern int filemap_fdatawait_range(struct address_space *, loff_t lstart,
+int write_inode_now(struct inode *, int);
+int filemap_fdatawrite(struct address_space *);
+int filemap_flush(struct address_space *);
+int filemap_fdatawait(struct address_space *);
+int filemap_fdatawait_range(struct address_space *, loff_t lstart,
 				   loff_t lend);
-extern int filemap_write_and_wait(struct address_space *mapping);
-extern int filemap_write_and_wait_range(struct address_space *mapping,
+int filemap_write_and_wait(struct address_space *mapping);
+int filemap_write_and_wait_range(struct address_space *mapping,
 				        loff_t lstart, loff_t lend);
-extern int __filemap_fdatawrite_range(struct address_space *mapping,
+int __filemap_fdatawrite_range(struct address_space *mapping,
 				loff_t start, loff_t end, int sync_mode);
-extern int filemap_fdatawrite_range(struct address_space *mapping,
+int filemap_fdatawrite_range(struct address_space *mapping,
 				loff_t start, loff_t end);
 
-extern int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
+int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
 			   int datasync);
-extern int vfs_fsync(struct file *file, int datasync);
+int vfs_fsync(struct file *file, int datasync);
 static inline int generic_write_sync(struct file *file, loff_t pos, loff_t count)
 {
 	if (!(file->f_flags & O_DSYNC) && !IS_SYNC(file->f_mapping->host))
@@ -2262,14 +2262,14 @@ static inline int generic_write_sync(str
 	return vfs_fsync_range(file, pos, pos + count - 1,
 			       (file->f_flags & __O_SYNC) ? 0 : 1);
 }
-extern void emergency_sync(void);
-extern void emergency_remount(void);
+void emergency_sync(void);
+void emergency_remount(void);
 #ifdef CONFIG_BLOCK
-extern sector_t bmap(struct inode *, sector_t);
+sector_t bmap(struct inode *, sector_t);
 #endif
-extern int notify_change(struct dentry *, struct iattr *, struct inode **);
-extern int inode_permission(struct inode *, int);
-extern int generic_permission(struct inode *, int);
+int notify_change(struct dentry *, struct iattr *, struct inode **);
+int inode_permission(struct inode *, int);
+int generic_permission(struct inode *, int);
 
 static inline bool execute_ok(struct inode *inode)
 {
@@ -2356,138 +2356,138 @@ static inline void i_readcount_inc(struc
 	return;
 }
 #endif
-extern int do_pipe_flags(int *, int);
+int do_pipe_flags(int *, int);
 
-extern int kernel_read(struct file *, loff_t, char *, unsigned long);
-extern ssize_t kernel_write(struct file *, const char *, size_t, loff_t);
-extern struct file * open_exec(const char *);
+int kernel_read(struct file *, loff_t, char *, unsigned long);
+ssize_t kernel_write(struct file *, const char *, size_t, loff_t);
+struct file * open_exec(const char *);
  
 /* fs/dcache.c -- generic fs support functions */
-extern int is_subdir(struct dentry *, struct dentry *);
-extern int path_is_under(struct path *, struct path *);
+int is_subdir(struct dentry *, struct dentry *);
+int path_is_under(struct path *, struct path *);
 
 #include <linux/err.h>
 
 /* needed for stackable file system support */
-extern loff_t default_llseek(struct file *file, loff_t offset, int whence);
+loff_t default_llseek(struct file *file, loff_t offset, int whence);
 
-extern loff_t vfs_llseek(struct file *file, loff_t offset, int whence);
+loff_t vfs_llseek(struct file *file, loff_t offset, int whence);
 
-extern int inode_init_always(struct super_block *, struct inode *);
-extern void inode_init_once(struct inode *);
-extern void address_space_init_once(struct address_space *mapping);
-extern struct inode * igrab(struct inode *);
-extern ino_t iunique(struct super_block *, ino_t);
-extern int inode_needs_sync(struct inode *inode);
-extern int generic_delete_inode(struct inode *inode);
+int inode_init_always(struct super_block *, struct inode *);
+void inode_init_once(struct inode *);
+void address_space_init_once(struct address_space *mapping);
+struct inode * igrab(struct inode *);
+ino_t iunique(struct super_block *, ino_t);
+int inode_needs_sync(struct inode *inode);
+int generic_delete_inode(struct inode *inode);
 static inline int generic_drop_inode(struct inode *inode)
 {
 	return !inode->i_nlink || inode_unhashed(inode);
 }
 
-extern struct inode *ilookup5_nowait(struct super_block *sb,
+struct inode *ilookup5_nowait(struct super_block *sb,
 		unsigned long hashval, int (*test)(struct inode *, void *),
 		void *data);
-extern struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
+struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data);
-extern struct inode *ilookup(struct super_block *sb, unsigned long ino);
+struct inode *ilookup(struct super_block *sb, unsigned long ino);
 
-extern struct inode * iget5_locked(struct super_block *, unsigned long, int (*test)(struct inode *, void *), int (*set)(struct inode *, void *), void *);
-extern struct inode * iget_locked(struct super_block *, unsigned long);
-extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
-extern int insert_inode_locked(struct inode *);
+struct inode * iget5_locked(struct super_block *, unsigned long, int (*test)(struct inode *, void *), int (*set)(struct inode *, void *), void *);
+struct inode * iget_locked(struct super_block *, unsigned long);
+int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
+int insert_inode_locked(struct inode *);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern void lockdep_annotate_inode_mutex_key(struct inode *inode);
+void lockdep_annotate_inode_mutex_key(struct inode *inode);
 #else
 static inline void lockdep_annotate_inode_mutex_key(struct inode *inode) { };
 #endif
-extern void unlock_new_inode(struct inode *);
-extern unsigned int get_next_ino(void);
+void unlock_new_inode(struct inode *);
+unsigned int get_next_ino(void);
 
-extern void __iget(struct inode * inode);
-extern void iget_failed(struct inode *);
-extern void clear_inode(struct inode *);
-extern void __destroy_inode(struct inode *);
-extern struct inode *new_inode_pseudo(struct super_block *sb);
-extern struct inode *new_inode(struct super_block *sb);
-extern void free_inode_nonrcu(struct inode *inode);
-extern int should_remove_suid(struct dentry *);
-extern int file_remove_suid(struct file *);
+void __iget(struct inode * inode);
+void iget_failed(struct inode *);
+void clear_inode(struct inode *);
+void __destroy_inode(struct inode *);
+struct inode *new_inode_pseudo(struct super_block *sb);
+struct inode *new_inode(struct super_block *sb);
+void free_inode_nonrcu(struct inode *inode);
+int should_remove_suid(struct dentry *);
+int file_remove_suid(struct file *);
 
-extern void __insert_inode_hash(struct inode *, unsigned long hashval);
+void __insert_inode_hash(struct inode *, unsigned long hashval);
 static inline void insert_inode_hash(struct inode *inode)
 {
 	__insert_inode_hash(inode, inode->i_ino);
 }
 
-extern void __remove_inode_hash(struct inode *);
+void __remove_inode_hash(struct inode *);
 static inline void remove_inode_hash(struct inode *inode)
 {
 	if (!inode_unhashed(inode))
 		__remove_inode_hash(inode);
 }
 
-extern void inode_sb_list_add(struct inode *inode);
+void inode_sb_list_add(struct inode *inode);
 
 #ifdef CONFIG_BLOCK
-extern void submit_bio(int, struct bio *);
-extern int bdev_read_only(struct block_device *);
+void submit_bio(int, struct bio *);
+int bdev_read_only(struct block_device *);
 #endif
-extern int set_blocksize(struct block_device *, int);
-extern int sb_set_blocksize(struct super_block *, int);
-extern int sb_min_blocksize(struct super_block *, int);
-
-extern int generic_file_mmap(struct file *, struct vm_area_struct *);
-extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
-extern int generic_file_remap_pages(struct vm_area_struct *, unsigned long addr,
+int set_blocksize(struct block_device *, int);
+int sb_set_blocksize(struct super_block *, int);
+int sb_min_blocksize(struct super_block *, int);
+
+int generic_file_mmap(struct file *, struct vm_area_struct *);
+int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
+int generic_file_remap_pages(struct vm_area_struct *, unsigned long addr,
 		unsigned long size, pgoff_t pgoff);
 int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk);
-extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
-extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
-extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
-extern ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *, loff_t);
-extern ssize_t generic_perform_write(struct file *, struct iov_iter *, loff_t);
-extern ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
-extern ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
-extern ssize_t new_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
-extern ssize_t new_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
+ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
+ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
+ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
+ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *, loff_t);
+ssize_t generic_perform_write(struct file *, struct iov_iter *, loff_t);
+ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
+ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
+ssize_t new_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
+ssize_t new_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
 
 /* fs/block_dev.c */
-extern ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from);
-extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
+ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from);
+int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
 			int datasync);
-extern void block_sync_page(struct page *page);
+void block_sync_page(struct page *page);
 
 /* fs/splice.c */
-extern ssize_t generic_file_splice_read(struct file *, loff_t *,
+ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
-extern ssize_t default_file_splice_read(struct file *, loff_t *,
+ssize_t default_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
-extern ssize_t iter_file_splice_write(struct pipe_inode_info *,
+ssize_t iter_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
-extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
+ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
 		struct file *out, loff_t *, size_t len, unsigned int flags);
 
-extern void
+void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
-extern loff_t noop_llseek(struct file *file, loff_t offset, int whence);
-extern loff_t no_llseek(struct file *file, loff_t offset, int whence);
-extern loff_t vfs_setpos(struct file *file, loff_t offset, loff_t maxsize);
-extern loff_t generic_file_llseek(struct file *file, loff_t offset, int whence);
-extern loff_t generic_file_llseek_size(struct file *file, loff_t offset,
+loff_t noop_llseek(struct file *file, loff_t offset, int whence);
+loff_t no_llseek(struct file *file, loff_t offset, int whence);
+loff_t vfs_setpos(struct file *file, loff_t offset, loff_t maxsize);
+loff_t generic_file_llseek(struct file *file, loff_t offset, int whence);
+loff_t generic_file_llseek_size(struct file *file, loff_t offset,
 		int whence, loff_t maxsize, loff_t eof);
-extern loff_t fixed_size_llseek(struct file *file, loff_t offset,
+loff_t fixed_size_llseek(struct file *file, loff_t offset,
 		int whence, loff_t size);
-extern int generic_file_open(struct inode * inode, struct file * filp);
-extern int nonseekable_open(struct inode * inode, struct file * filp);
+int generic_file_open(struct inode * inode, struct file * filp);
+int nonseekable_open(struct inode * inode, struct file * filp);
 
 #ifdef CONFIG_FS_XIP
-extern ssize_t xip_file_read(struct file *filp, char __user *buf, size_t len,
+ssize_t xip_file_read(struct file *filp, char __user *buf, size_t len,
 			     loff_t *ppos);
-extern int xip_file_mmap(struct file * file, struct vm_area_struct * vma);
-extern ssize_t xip_file_write(struct file *filp, const char __user *buf,
+int xip_file_mmap(struct file * file, struct vm_area_struct * vma);
+ssize_t xip_file_write(struct file *filp, const char __user *buf,
 			      size_t len, loff_t *ppos);
-extern int xip_truncate_page(struct address_space *mapping, loff_t from);
+int xip_truncate_page(struct address_space *mapping, loff_t from);
 #else
 static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
 {
@@ -2530,26 +2530,26 @@ static inline ssize_t blockdev_direct_IO
 void inode_dio_wait(struct inode *inode);
 void inode_dio_done(struct inode *inode);
 
-extern void inode_set_flags(struct inode *inode, unsigned int flags,
+void inode_set_flags(struct inode *inode, unsigned int flags,
 			    unsigned int mask);
 
 extern const struct file_operations generic_ro_fops;
 
 #define special_file(m) (S_ISCHR(m)||S_ISBLK(m)||S_ISFIFO(m)||S_ISSOCK(m))
 
-extern int readlink_copy(char __user *, int, const char *);
-extern int page_readlink(struct dentry *, char __user *, int);
-extern void *page_follow_link_light(struct dentry *, struct nameidata *);
-extern void page_put_link(struct dentry *, struct nameidata *, void *);
-extern int __page_symlink(struct inode *inode, const char *symname, int len,
+int readlink_copy(char __user *, int, const char *);
+int page_readlink(struct dentry *, char __user *, int);
+void *page_follow_link_light(struct dentry *, struct nameidata *);
+void page_put_link(struct dentry *, struct nameidata *, void *);
+int __page_symlink(struct inode *inode, const char *symname, int len,
 		int nofs);
-extern int page_symlink(struct inode *inode, const char *symname, int len);
+int page_symlink(struct inode *inode, const char *symname, int len);
 extern const struct inode_operations page_symlink_inode_operations;
-extern void kfree_put_link(struct dentry *, struct nameidata *, void *);
-extern int generic_readlink(struct dentry *, char __user *, int);
-extern void generic_fillattr(struct inode *, struct kstat *);
+void kfree_put_link(struct dentry *, struct nameidata *, void *);
+int generic_readlink(struct dentry *, char __user *, int);
+void generic_fillattr(struct inode *, struct kstat *);
 int vfs_getattr_nosec(struct path *path, struct kstat *stat);
-extern int vfs_getattr(struct path *, struct kstat *);
+int vfs_getattr(struct path *, struct kstat *);
 void __inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
 void __inode_sub_bytes(struct inode *inode, loff_t bytes);
@@ -2557,97 +2557,97 @@ void inode_sub_bytes(struct inode *inode
 loff_t inode_get_bytes(struct inode *inode);
 void inode_set_bytes(struct inode *inode, loff_t bytes);
 
-extern int vfs_readdir(struct file *, filldir_t, void *);
-extern int iterate_dir(struct file *, struct dir_context *);
+int vfs_readdir(struct file *, filldir_t, void *);
+int iterate_dir(struct file *, struct dir_context *);
 
-extern int vfs_stat(const char __user *, struct kstat *);
-extern int vfs_lstat(const char __user *, struct kstat *);
-extern int vfs_fstat(unsigned int, struct kstat *);
-extern int vfs_fstatat(int , const char __user *, struct kstat *, int);
+int vfs_stat(const char __user *, struct kstat *);
+int vfs_lstat(const char __user *, struct kstat *);
+int vfs_fstat(unsigned int, struct kstat *);
+int vfs_fstatat(int , const char __user *, struct kstat *, int);
 
-extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
+int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
-extern int __generic_block_fiemap(struct inode *inode,
+int __generic_block_fiemap(struct inode *inode,
 				  struct fiemap_extent_info *fieinfo,
 				  loff_t start, loff_t len,
 				  get_block_t *get_block);
-extern int generic_block_fiemap(struct inode *inode,
+int generic_block_fiemap(struct inode *inode,
 				struct fiemap_extent_info *fieinfo, u64 start,
 				u64 len, get_block_t *get_block);
 
-extern void get_filesystem(struct file_system_type *fs);
-extern void put_filesystem(struct file_system_type *fs);
-extern struct file_system_type *get_fs_type(const char *name);
-extern struct super_block *get_super(struct block_device *);
-extern struct super_block *get_super_thawed(struct block_device *);
-extern struct super_block *get_active_super(struct block_device *bdev);
-extern void drop_super(struct super_block *sb);
-extern void iterate_supers(void (*)(struct super_block *, void *), void *);
-extern void iterate_supers_type(struct file_system_type *,
+void get_filesystem(struct file_system_type *fs);
+void put_filesystem(struct file_system_type *fs);
+struct file_system_type *get_fs_type(const char *name);
+struct super_block *get_super(struct block_device *);
+struct super_block *get_super_thawed(struct block_device *);
+struct super_block *get_active_super(struct block_device *bdev);
+void drop_super(struct super_block *sb);
+void iterate_supers(void (*)(struct super_block *, void *), void *);
+void iterate_supers_type(struct file_system_type *,
 			        void (*)(struct super_block *, void *), void *);
 
-extern int dcache_dir_open(struct inode *, struct file *);
-extern int dcache_dir_close(struct inode *, struct file *);
-extern loff_t dcache_dir_lseek(struct file *, loff_t, int);
-extern int dcache_readdir(struct file *, struct dir_context *);
-extern int simple_setattr(struct dentry *, struct iattr *);
-extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
-extern int simple_statfs(struct dentry *, struct kstatfs *);
-extern int simple_open(struct inode *inode, struct file *file);
-extern int simple_link(struct dentry *, struct inode *, struct dentry *);
-extern int simple_unlink(struct inode *, struct dentry *);
-extern int simple_rmdir(struct inode *, struct dentry *);
-extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
-extern int noop_fsync(struct file *, loff_t, loff_t, int);
-extern int simple_empty(struct dentry *);
-extern int simple_readpage(struct file *file, struct page *page);
-extern int simple_write_begin(struct file *file, struct address_space *mapping,
+int dcache_dir_open(struct inode *, struct file *);
+int dcache_dir_close(struct inode *, struct file *);
+loff_t dcache_dir_lseek(struct file *, loff_t, int);
+int dcache_readdir(struct file *, struct dir_context *);
+int simple_setattr(struct dentry *, struct iattr *);
+int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+int simple_statfs(struct dentry *, struct kstatfs *);
+int simple_open(struct inode *inode, struct file *file);
+int simple_link(struct dentry *, struct inode *, struct dentry *);
+int simple_unlink(struct inode *, struct dentry *);
+int simple_rmdir(struct inode *, struct dentry *);
+int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+int noop_fsync(struct file *, loff_t, loff_t, int);
+int simple_empty(struct dentry *);
+int simple_readpage(struct file *file, struct page *page);
+int simple_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata);
-extern int simple_write_end(struct file *file, struct address_space *mapping,
+int simple_write_end(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata);
-extern int always_delete_dentry(const struct dentry *);
-extern struct inode *alloc_anon_inode(struct super_block *);
+int always_delete_dentry(const struct dentry *);
+struct inode *alloc_anon_inode(struct super_block *);
 extern const struct dentry_operations simple_dentry_operations;
 
-extern struct dentry *simple_lookup(struct inode *, struct dentry *, unsigned int flags);
-extern ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
+struct dentry *simple_lookup(struct inode *, struct dentry *, unsigned int flags);
+ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
 extern const struct file_operations simple_dir_operations;
 extern const struct inode_operations simple_dir_inode_operations;
 struct tree_descr { char *name; const struct file_operations *ops; int mode; };
 struct dentry *d_alloc_name(struct dentry *, const char *);
-extern int simple_fill_super(struct super_block *, unsigned long, struct tree_descr *);
-extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
-extern void simple_release_fs(struct vfsmount **mount, int *count);
+int simple_fill_super(struct super_block *, unsigned long, struct tree_descr *);
+int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
+void simple_release_fs(struct vfsmount **mount, int *count);
 
-extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
+ssize_t simple_read_from_buffer(void __user *to, size_t count,
 			loff_t *ppos, const void *from, size_t available);
-extern ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
+ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
 		const void __user *from, size_t count);
 
-extern int __generic_file_fsync(struct file *, loff_t, loff_t, int);
-extern int generic_file_fsync(struct file *, loff_t, loff_t, int);
+int __generic_file_fsync(struct file *, loff_t, loff_t, int);
+int generic_file_fsync(struct file *, loff_t, loff_t, int);
 
-extern int generic_check_addressable(unsigned, u64);
+int generic_check_addressable(unsigned, u64);
 
 #ifdef CONFIG_MIGRATION
-extern int buffer_migrate_page(struct address_space *,
+int buffer_migrate_page(struct address_space *,
 				struct page *, struct page *,
 				enum migrate_mode);
 #else
 #define buffer_migrate_page NULL
 #endif
 
-extern int inode_change_ok(const struct inode *, struct iattr *);
-extern int inode_newsize_ok(const struct inode *, loff_t offset);
-extern void setattr_copy(struct inode *inode, const struct iattr *attr);
-
-extern int file_update_time(struct file *file);
-
-extern int generic_show_options(struct seq_file *m, struct dentry *root);
-extern void save_mount_options(struct super_block *sb, char *options);
-extern void replace_mount_options(struct super_block *sb, char *options);
+int inode_change_ok(const struct inode *, struct iattr *);
+int inode_newsize_ok(const struct inode *, loff_t offset);
+void setattr_copy(struct inode *inode, const struct iattr *attr);
+
+int file_update_time(struct file *file);
+
+int generic_show_options(struct seq_file *m, struct dentry *root);
+void save_mount_options(struct super_block *sb, char *options);
+void replace_mount_options(struct super_block *sb, char *options);
 
 static inline ino_t parent_ino(struct dentry *dentry)
 {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
fsh-whitespace-neatening.patch
fsh-a-few-more-whitespace-neatenings.patch
fsh-add-argument-names-to-struct-file_lock_operations-funcs.patch
fsh-add-member-argument-descriptions-to-lock_manager_operations.patch
dlm-plock-add-argument-descriptions-to-notify.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch

