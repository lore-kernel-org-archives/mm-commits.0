From: akpm@linux-foundation.org
Subject: [obsolete] fsh-whitespace-neatening.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:35:30 -0700
Message-ID: <53ea6c82.i7hRel5vfd+zaobs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:50512 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbaHLTfc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:35:32 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1921074obb.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:35:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bfields@fieldses.org, ccaulfie@redhat.com, jlayton@poochiereds.net, teigland@redhat.com, trond.myklebust@primarydata.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs.h: whitespace neatening
has been removed from the -mm tree.  Its filename was
     fsh-whitespace-neatening.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: fs.h: whitespace neatening

Make the whitespace a lot more kernel style conformant.

git diff -w shows no differences.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Teigland <teigland@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |  500 +++++++++++++++++++++----------------------
 1 file changed, 250 insertions(+), 250 deletions(-)

diff -puN include/linux/fs.h~fsh-whitespace-neatening include/linux/fs.h
--- a/include/linux/fs.h~fsh-whitespace-neatening
+++ a/include/linux/fs.h
@@ -64,9 +64,9 @@ extern int sysctl_protected_hardlinks;
 
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
-			struct buffer_head *bh_result, int create);
+			  struct buffer_head *bh_result, int create);
 typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
-			ssize_t bytes, void *private);
+			    ssize_t bytes, void *private);
 
 #define MAY_EXEC		0x00000001
 #define MAY_WRITE		0x00000002
@@ -192,8 +192,8 @@ typedef void (dio_iodone_t)(struct kiocb
 #define READ			0
 #define WRITE			RW_MASK
 #define READA			RWA_MASK
-#define KERNEL_READ		(READ|REQ_KERNEL)
-#define KERNEL_WRITE		(WRITE|REQ_KERNEL)
+#define KERNEL_READ		(READ | REQ_KERNEL)
+#define KERNEL_WRITE		(WRITE | REQ_KERNEL)
 
 #define READ_SYNC		(READ | REQ_SYNC)
 #define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE)
@@ -256,25 +256,25 @@ struct iattr {
  */
 #include <linux/quota.h>
 
-/** 
+/**
  * enum positive_aop_returns - aop return codes with specific semantics
  *
  * @AOP_WRITEPAGE_ACTIVATE: Informs the caller that page writeback has
- * 			    completed, that the page is still locked, and
- * 			    should be considered active.  The VM uses this hint
- * 			    to return the page to the active list -- it won't
- * 			    be a candidate for writeback again in the near
- * 			    future.  Other callers must be careful to unlock
- * 			    the page if they get this return.  Returned by
- * 			    writepage(); 
+ *			    completed, that the page is still locked, and
+ *			    should be considered active.  The VM uses this hint
+ *			    to return the page to the active list -- it won't
+ *			    be a candidate for writeback again in the near
+ *			    future.  Other callers must be careful to unlock
+ *			    the page if they get this return.  Returned by
+ *			    writepage();
  *
  * @AOP_TRUNCATED_PAGE: The AOP method that was handed a locked page has
- *  			unlocked it and the page might have been truncated.
- *  			The caller should back up to acquiring a new page and
- *  			trying again.  The aop will be taking reasonable
- *  			precautions not to livelock.  If the caller held a page
- *  			reference, it should drop it before retrying.  Returned
- *  			by readpage().
+ *			unlocked it and the page might have been truncated.
+ *			The caller should back up to acquiring a new page and
+ *			trying again.  The aop will be taking reasonable
+ *			precautions not to livelock.  If the caller held a page
+ *			reference, it should drop it before retrying.  Returned
+ *			by readpage().
  *
  * address_space_operation functions return these large constants to indicate
  * special semantics to the caller.  These are much larger than the bytes in a
@@ -320,7 +320,7 @@ typedef struct {
 } read_descriptor_t;
 
 typedef int (*read_actor_t)(read_descriptor_t *, struct page *,
-		unsigned long, unsigned long);
+			    unsigned long, unsigned long);
 
 struct address_space_operations {
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
@@ -333,38 +333,38 @@ struct address_space_operations {
 	int (*set_page_dirty)(struct page *page);
 
 	int (*readpages)(struct file *filp, struct address_space *mapping,
-			struct list_head *pages, unsigned nr_pages);
+			 struct list_head *pages, unsigned nr_pages);
 
 	int (*write_begin)(struct file *, struct address_space *mapping,
-				loff_t pos, unsigned len, unsigned flags,
-				struct page **pagep, void **fsdata);
+			   loff_t pos, unsigned len, unsigned flags,
+			   struct page **pagep, void **fsdata);
 	int (*write_end)(struct file *, struct address_space *mapping,
-				loff_t pos, unsigned len, unsigned copied,
-				struct page *page, void *fsdata);
+			 loff_t pos, unsigned len, unsigned copied,
+			 struct page *page, void *fsdata);
 
 	/* Unfortunately this kludge is needed for FIBMAP. Don't use it */
 	sector_t (*bmap)(struct address_space *, sector_t);
-	void (*invalidatepage) (struct page *, unsigned int, unsigned int);
-	int (*releasepage) (struct page *, gfp_t);
+	void (*invalidatepage)(struct page *, unsigned int, unsigned int);
+	int (*releasepage)(struct page *, gfp_t);
 	void (*freepage)(struct page *);
 	ssize_t (*direct_IO)(int, struct kiocb *, struct iov_iter *iter, loff_t offset);
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
-						void **, unsigned long *);
+			   void **, unsigned long *);
 	/*
 	 * migrate the contents of a page to the specified target. If
 	 * migrate_mode is MIGRATE_ASYNC, it must not block.
 	 */
-	int (*migratepage) (struct address_space *,
-			struct page *, struct page *, enum migrate_mode);
-	int (*launder_page) (struct page *);
-	int (*is_partially_uptodate) (struct page *, unsigned long,
-					unsigned long);
-	void (*is_dirty_writeback) (struct page *, bool *, bool *);
+	int (*migratepage)(struct address_space *,
+			   struct page *, struct page *, enum migrate_mode);
+	int (*launder_page)(struct page *);
+	int (*is_partially_uptodate)(struct page *, unsigned long,
+				     unsigned long);
+	void (*is_dirty_writeback)(struct page *, bool *, bool *);
 	int (*error_remove_page)(struct address_space *, struct page *);
 
 	/* swapfile support */
 	int (*swap_activate)(struct swap_info_struct *sis, struct file *file,
-				sector_t *span);
+			     sector_t *span);
 	void (*swap_deactivate)(struct file *file);
 };
 
@@ -375,12 +375,12 @@ extern const struct address_space_operat
  * to write into the pagecache.
  */
 int pagecache_write_begin(struct file *, struct address_space *mapping,
-				loff_t pos, unsigned len, unsigned flags,
-				struct page **pagep, void **fsdata);
+			  loff_t pos, unsigned len, unsigned flags,
+			  struct page **pagep, void **fsdata);
 
 int pagecache_write_end(struct file *, struct address_space *mapping,
-				loff_t pos, unsigned len, unsigned copied,
-				struct page *page, void *fsdata);
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata);
 
 struct backing_dev_info;
 struct address_space {
@@ -402,35 +402,35 @@ struct address_space {
 	struct list_head	private_list;	/* ditto */
 	void			*private_data;	/* ditto */
 } __attribute__((aligned(sizeof(long))));
-	/*
-	 * On most architectures that alignment is already the case; but
-	 * must be enforced here for CRIS, to let the least significant bit
-	 * of struct page's "mapping" pointer be used for PAGE_MAPPING_ANON.
-	 */
+/*
+ * On most architectures that alignment is already the case; but
+ * must be enforced here for CRIS, to let the least significant bit
+ * of struct page's "mapping" pointer be used for PAGE_MAPPING_ANON.
+ */
 struct request_queue;
 
 struct block_device {
 	dev_t			bd_dev;  /* not a kdev_t - it's a search key */
 	int			bd_openers;
-	struct inode *		bd_inode;	/* will die */
-	struct super_block *	bd_super;
+	struct inode		*bd_inode;	/* will die */
+	struct super_block	*bd_super;
 	struct mutex		bd_mutex;	/* open/close mutex */
 	struct list_head	bd_inodes;
-	void *			bd_claiming;
-	void *			bd_holder;
+	void			*bd_claiming;
+	void			*bd_holder;
 	int			bd_holders;
 	bool			bd_write_holder;
 #ifdef CONFIG_SYSFS
 	struct list_head	bd_holder_disks;
 #endif
-	struct block_device *	bd_contains;
+	struct block_device	*bd_contains;
 	unsigned		bd_block_size;
-	struct hd_struct *	bd_part;
+	struct hd_struct	*bd_part;
 	/* number of times partitions within this device have been opened. */
 	unsigned		bd_part_count;
 	int			bd_invalidated;
-	struct gendisk *	bd_disk;
-	struct request_queue *  bd_queue;
+	struct gendisk		*bd_disk;
+	struct request_queue	*bd_queue;
 	struct list_head	bd_list;
 	/*
 	 * Private data.  You must have bd_claim'ed the block_device
@@ -504,7 +504,7 @@ static inline void mapping_allow_writabl
 /*
  * Use sequence counter to get consistent i_size on 32-bit processors.
  */
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
 #include <linux/seqlock.h>
 #define __NEED_I_SIZE_ORDERED
 #define i_size_ordered_init(inode) seqcount_init(&inode->i_size_seqcount)
@@ -658,7 +658,7 @@ void unlock_two_nondirectories(struct in
  */
 static inline loff_t i_size_read(const struct inode *inode)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
 	loff_t i_size;
 	unsigned int seq;
 
@@ -667,7 +667,7 @@ static inline loff_t i_size_read(const s
 		i_size = inode->i_size;
 	} while (read_seqcount_retry(&inode->i_size_seqcount, seq));
 	return i_size;
-#elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPT)
+#elif BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT)
 	loff_t i_size;
 
 	preempt_disable();
@@ -686,13 +686,13 @@ static inline loff_t i_size_read(const s
  */
 static inline void i_size_write(struct inode *inode, loff_t i_size)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
 	preempt_disable();
 	write_seqcount_begin(&inode->i_size_seqcount);
 	inode->i_size = i_size;
 	write_seqcount_end(&inode->i_size_seqcount);
 	preempt_enable();
-#elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPT)
+#elif BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT)
 	preempt_disable();
 	inode->i_size = i_size;
 	preempt_enable();
@@ -772,7 +772,7 @@ static inline int ra_has_index(struct fi
 struct file {
 	union {
 		struct llist_node	fu_llist;
-		struct rcu_head 	fu_rcuhead;
+		struct rcu_head		fu_rcuhead;
 	} f_u;
 	struct path		f_path;
 #define f_dentry	f_path.dentry
@@ -785,7 +785,7 @@ struct file {
 	 */
 	spinlock_t		f_lock;
 	atomic_long_t		f_count;
-	unsigned int 		f_flags;
+	unsigned int		f_flags;
 	fmode_t			f_mode;
 	struct mutex		f_pos_lock;
 	loff_t			f_pos;
@@ -825,12 +825,12 @@ static inline struct file *get_file(stru
 
 #define	MAX_NON_LFS	((1UL<<31) - 1)
 
-/* Page cache limit. The filesystems should put that into their s_maxbytes 
-   limits, otherwise bad things can happen in VM. */ 
-#if BITS_PER_LONG==32
-#define MAX_LFS_FILESIZE	(((loff_t)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1) 
-#elif BITS_PER_LONG==64
-#define MAX_LFS_FILESIZE 	((loff_t)0x7fffffffffffffffLL)
+/* Page cache limit. The filesystems should put that into their s_maxbytes
+   limits, otherwise bad things can happen in VM. */
+#if BITS_PER_LONG == 32
+#define MAX_LFS_FILESIZE	(((loff_t)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1)
+#elif BITS_PER_LONG == 64
+#define MAX_LFS_FILESIZE	((loff_t)0x7fffffffffffffffLL)
 #endif
 
 #define FL_POSIX	1
@@ -919,7 +919,7 @@ struct file_lock {
 	loff_t fl_start;
 	loff_t fl_end;
 
-	struct fasync_struct *	fl_fasync; /* for lease break notifications */
+	struct fasync_struct *fl_fasync; /* for lease break notifications */
 	/* for lease breaks: */
 	unsigned long fl_break_time;
 	unsigned long fl_downgrade_time;
@@ -950,12 +950,12 @@ void send_sigio(struct fown_struct *fown
 #ifdef CONFIG_FILE_LOCKING
 int fcntl_getlk(struct file *, unsigned int, struct flock __user *);
 int fcntl_setlk(unsigned int, struct file *, unsigned int,
-			struct flock __user *);
+		struct flock __user *);
 
 #if BITS_PER_LONG == 32
 int fcntl_getlk64(struct file *, unsigned int, struct flock64 __user *);
 int fcntl_setlk64(unsigned int, struct file *, unsigned int,
-			struct flock64 __user *);
+		  struct flock64 __user *);
 #endif
 
 int fcntl_setlease(unsigned int fd, struct file *filp, long arg);
@@ -964,7 +964,7 @@ int fcntl_getlease(struct file *filp);
 /* fs/locks.c */
 void locks_free_lock(struct file_lock *fl);
 void locks_init_lock(struct file_lock *);
-struct file_lock * locks_alloc_lock(void);
+struct file_lock *locks_alloc_lock(void);
 void locks_copy_lock(struct file_lock *, struct file_lock *);
 void __locks_copy_lock(struct file_lock *, const struct file_lock *);
 void locks_remove_posix(struct file *, fl_owner_t);
@@ -1100,7 +1100,7 @@ static inline void lease_get_mtime(struc
 }
 
 static inline int generic_setlease(struct file *filp, long arg,
-				    struct file_lock **flp)
+				   struct file_lock **flp)
 {
 	return -EINVAL;
 }
@@ -1233,7 +1233,7 @@ struct super_block {
 	char s_id[32];				/* Informational name */
 	u8 s_uuid[16];				/* UUID */
 
-	void 			*s_fs_info;	/* Filesystem private info */
+	void			*s_fs_info;	/* Filesystem private info */
 	unsigned int		s_max_links;
 	fmode_t			s_mode;
 
@@ -1425,7 +1425,7 @@ void dentry_unhash(struct dentry *dentry
  * VFS file helper functions.
  */
 void inode_init_owner(struct inode *inode, const struct inode *dir,
-			umode_t mode);
+		      umode_t mode);
 /*
  * VFS FS_IOC_FIEMAP helper definitions.
  */
@@ -1434,7 +1434,7 @@ struct fiemap_extent_info {
 	unsigned int fi_extents_mapped;	/* Number of mapped extents */
 	unsigned int fi_extents_max;	/* Size of fiemap_extent array */
 	struct fiemap_extent __user *fi_extents_start; /* Start of
-							fiemap_extent array */
+							  fiemap_extent array */
 };
 int fiemap_fill_next_extent(struct fiemap_extent_info *info, u64 logical,
 			    u64 phys, u64 len, u32 flags);
@@ -1480,29 +1480,29 @@ struct iov_iter;
 
 struct file_operations {
 	struct module *owner;
-	loff_t (*llseek) (struct file *, loff_t, int);
-	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
-	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
-	ssize_t (*aio_read) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
-	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
-	ssize_t (*read_iter) (struct kiocb *, struct iov_iter *);
-	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
-	int (*iterate) (struct file *, struct dir_context *);
-	unsigned int (*poll) (struct file *, struct poll_table_struct *);
-	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
-	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
-	int (*mmap) (struct file *, struct vm_area_struct *);
-	int (*open) (struct inode *, struct file *);
-	int (*flush) (struct file *, fl_owner_t id);
-	int (*release) (struct inode *, struct file *);
-	int (*fsync) (struct file *, loff_t, loff_t, int datasync);
-	int (*aio_fsync) (struct kiocb *, int datasync);
-	int (*fasync) (int, struct file *, int);
-	int (*lock) (struct file *, int, struct file_lock *);
-	ssize_t (*sendpage) (struct file *, struct page *, int, size_t, loff_t *, int);
+	loff_t (*llseek)(struct file *, loff_t, int);
+	ssize_t (*read)(struct file *, char __user *, size_t, loff_t *);
+	ssize_t (*write)(struct file *, const char __user *, size_t, loff_t *);
+	ssize_t (*aio_read)(struct kiocb *, const struct iovec *, unsigned long, loff_t);
+	ssize_t (*aio_write)(struct kiocb *, const struct iovec *, unsigned long, loff_t);
+	ssize_t (*read_iter)(struct kiocb *, struct iov_iter *);
+	ssize_t (*write_iter)(struct kiocb *, struct iov_iter *);
+	int (*iterate)(struct file *, struct dir_context *);
+	unsigned int (*poll)(struct file *, struct poll_table_struct *);
+	long (*unlocked_ioctl)(struct file *, unsigned int, unsigned long);
+	long (*compat_ioctl)(struct file *, unsigned int, unsigned long);
+	int (*mmap)(struct file *, struct vm_area_struct *);
+	int (*open)(struct inode *, struct file *);
+	int (*flush)(struct file *, fl_owner_t id);
+	int (*release)(struct inode *, struct file *);
+	int (*fsync)(struct file *, loff_t, loff_t, int datasync);
+	int (*aio_fsync)(struct kiocb *, int datasync);
+	int (*fasync)(int, struct file *, int);
+	int (*lock)(struct file *, int, struct file_lock *);
+	ssize_t (*sendpage)(struct file *, struct page *, int, size_t, loff_t *, int);
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 	int (*check_flags)(int);
-	int (*flock) (struct file *, int, struct file_lock *);
+	int (*flock)(struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
 	int (*setlease)(struct file *, long, struct file_lock **);
@@ -1512,42 +1512,42 @@ struct file_operations {
 };
 
 struct inode_operations {
-	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
-	void * (*follow_link) (struct dentry *, struct nameidata *);
-	int (*permission) (struct inode *, int);
-	struct posix_acl * (*get_acl)(struct inode *, int);
-
-	int (*readlink) (struct dentry *, char __user *,int);
-	void (*put_link) (struct dentry *, struct nameidata *, void *);
-
-	int (*create) (struct inode *,struct dentry *, umode_t, bool);
-	int (*link) (struct dentry *,struct inode *,struct dentry *);
-	int (*unlink) (struct inode *,struct dentry *);
-	int (*symlink) (struct inode *,struct dentry *,const char *);
-	int (*mkdir) (struct inode *,struct dentry *,umode_t);
-	int (*rmdir) (struct inode *,struct dentry *);
-	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
-	int (*rename) (struct inode *, struct dentry *,
-			struct inode *, struct dentry *);
-	int (*rename2) (struct inode *, struct dentry *,
-			struct inode *, struct dentry *, unsigned int);
-	int (*setattr) (struct dentry *, struct iattr *);
-	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
-	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
-	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
-	ssize_t (*listxattr) (struct dentry *, char *, size_t);
-	int (*removexattr) (struct dentry *, const char *);
+	struct dentry * (*lookup)(struct inode *, struct dentry *, unsigned int);
+	void * (*follow_link)(struct dentry *, struct nameidata *);
+	int (*permission)(struct inode *, int);
+	struct posix_acl *(*get_acl)(struct inode *, int);
+
+	int (*readlink)(struct dentry *, char __user *, int);
+	void (*put_link)(struct dentry *, struct nameidata *, void *);
+
+	int (*create)(struct inode *, struct dentry *, umode_t, bool);
+	int (*link)(struct dentry *, struct inode *, struct dentry *);
+	int (*unlink)(struct inode *, struct dentry *);
+	int (*symlink)(struct inode *, struct dentry *, const char *);
+	int (*mkdir)(struct inode *, struct dentry *, umode_t);
+	int (*rmdir)(struct inode *, struct dentry *);
+	int (*mknod)(struct inode *, struct dentry *, umode_t, dev_t);
+	int (*rename)(struct inode *, struct dentry *,
+		      struct inode *, struct dentry *);
+	int (*rename2)(struct inode *, struct dentry *,
+		       struct inode *, struct dentry *, unsigned int);
+	int (*setattr)(struct dentry *, struct iattr *);
+	int (*getattr)(struct vfsmount *mnt, struct dentry *, struct kstat *);
+	int (*setxattr)(struct dentry *, const char *, const void *, size_t, int);
+	ssize_t (*getxattr)(struct dentry *, const char *, void *, size_t);
+	ssize_t (*listxattr)(struct dentry *, char *, size_t);
+	int (*removexattr)(struct dentry *, const char *);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
 	int (*update_time)(struct inode *, struct timespec *, int);
 	int (*atomic_open)(struct inode *, struct dentry *,
 			   struct file *, unsigned open_flag,
 			   umode_t create_mode, int *opened);
-	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
+	int (*tmpfile)(struct inode *, struct dentry *, umode_t);
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
 } ____cacheline_aligned;
 
-ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
+ssize_t rw_copy_check_uvector(int type, const struct iovec __user *uvector,
 			      unsigned long nr_segs, unsigned long fast_segs,
 			      struct iovec *fast_pointer,
 			      struct iovec **ret_pointer);
@@ -1555,25 +1555,25 @@ ssize_t rw_copy_check_uvector(int type,
 ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
 ssize_t vfs_readv(struct file *, const struct iovec __user *,
-		unsigned long, loff_t *);
+		  unsigned long, loff_t *);
 ssize_t vfs_writev(struct file *, const struct iovec __user *,
-		unsigned long, loff_t *);
+		   unsigned long, loff_t *);
 
 struct super_operations {
-   	struct inode *(*alloc_inode)(struct super_block *sb);
+	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
 
-   	void (*dirty_inode) (struct inode *, int flags);
-	int (*write_inode) (struct inode *, struct writeback_control *wbc);
-	int (*drop_inode) (struct inode *);
-	void (*evict_inode) (struct inode *);
-	void (*put_super) (struct super_block *);
+	void (*dirty_inode)(struct inode *, int flags);
+	int (*write_inode)(struct inode *, struct writeback_control *wbc);
+	int (*drop_inode)(struct inode *);
+	void (*evict_inode)(struct inode *);
+	void (*put_super)(struct super_block *);
 	int (*sync_fs)(struct super_block *sb, int wait);
-	int (*freeze_fs) (struct super_block *);
-	int (*unfreeze_fs) (struct super_block *);
-	int (*statfs) (struct dentry *, struct kstatfs *);
-	int (*remount_fs) (struct super_block *, int *, char *);
-	void (*umount_begin) (struct super_block *);
+	int (*freeze_fs)(struct super_block *);
+	int (*unfreeze_fs)(struct super_block *);
+	int (*statfs)(struct dentry *, struct kstatfs *);
+	int (*remount_fs)(struct super_block *, int *, char *);
+	void (*umount_begin)(struct super_block *);
 
 	int (*show_options)(struct seq_file *, struct dentry *);
 	int (*show_devname)(struct seq_file *, struct dentry *);
@@ -1621,12 +1621,12 @@ struct super_operations {
 #define __IS_FLG(inode, flg)	((inode)->i_sb->s_flags & (flg))
 
 #define IS_RDONLY(inode)	((inode)->i_sb->s_flags & MS_RDONLY)
-#define IS_SYNC(inode)		(__IS_FLG(inode, MS_SYNCHRONOUS) || \
-					((inode)->i_flags & S_SYNC))
-#define IS_DIRSYNC(inode)	(__IS_FLG(inode, MS_SYNCHRONOUS|MS_DIRSYNC) || \
-					((inode)->i_flags & (S_SYNC|S_DIRSYNC)))
+#define IS_SYNC(inode)		(__IS_FLG(inode, MS_SYNCHRONOUS) ||	\
+				 ((inode)->i_flags & S_SYNC))
+#define IS_DIRSYNC(inode)	(__IS_FLG(inode, MS_SYNCHRONOUS | MS_DIRSYNC) || \
+				 ((inode)->i_flags & (S_SYNC | S_DIRSYNC)))
 #define IS_MANDLOCK(inode)	__IS_FLG(inode, MS_MANDLOCK)
-#define IS_NOATIME(inode)	__IS_FLG(inode, MS_RDONLY|MS_NOATIME)
+#define IS_NOATIME(inode)	__IS_FLG(inode, MS_RDONLY | MS_NOATIME)
 #define IS_I_VERSION(inode)	__IS_FLG(inode, MS_I_VERSION)
 
 #define IS_NOQUOTA(inode)	((inode)->i_flags & S_NOQUOTA)
@@ -1750,9 +1750,9 @@ static inline void inode_dec_link_count(
 
 static inline void inode_inc_iversion(struct inode *inode)
 {
-       spin_lock(&inode->i_lock);
-       inode->i_version++;
-       spin_unlock(&inode->i_lock);
+	spin_lock(&inode->i_lock);
+	inode->i_version++;
+	spin_unlock(&inode->i_lock);
 }
 
 enum file_time_flags {
@@ -1775,17 +1775,17 @@ int sync_inode_metadata(struct inode *in
 struct file_system_type {
 	const char *name;
 	int fs_flags;
-#define FS_REQUIRES_DEV		1 
+#define FS_REQUIRES_DEV		1
 #define FS_BINARY_MOUNTDATA	2
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
 #define FS_USERNS_DEV_MOUNT	16 /* A userns mount does not imply MNT_NODEV */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
-	struct dentry *(*mount) (struct file_system_type *, int,
-		       const char *, void *);
-	void (*kill_sb) (struct super_block *);
+	struct dentry *(*mount)(struct file_system_type *, int,
+				const char *, void *);
+	void (*kill_sb)(struct super_block *);
 	struct module *owner;
-	struct file_system_type * next;
+	struct file_system_type *next;
 	struct hlist_head fs_supers;
 
 	struct lock_class_key s_lock_key;
@@ -1801,16 +1801,16 @@ struct file_system_type {
 #define MODULE_ALIAS_FS(NAME) MODULE_ALIAS("fs-" NAME)
 
 struct dentry *mount_ns(struct file_system_type *fs_type, int flags,
-	void *data, int (*fill_super)(struct super_block *, void *, int));
+			void *data, int (*fill_super)(struct super_block *, void *, int));
 struct dentry *mount_bdev(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data,
-	int (*fill_super)(struct super_block *, void *, int));
+			  int flags, const char *dev_name, void *data,
+			  int (*fill_super)(struct super_block *, void *, int));
 struct dentry *mount_single(struct file_system_type *fs_type,
-	int flags, void *data,
-	int (*fill_super)(struct super_block *, void *, int));
+			    int flags, void *data,
+			    int (*fill_super)(struct super_block *, void *, int));
 struct dentry *mount_nodev(struct file_system_type *fs_type,
-	int flags, void *data,
-	int (*fill_super)(struct super_block *, void *, int));
+			   int flags, void *data,
+			   int (*fill_super)(struct super_block *, void *, int));
 struct dentry *mount_subtree(struct vfsmount *mnt, const char *path);
 void generic_shutdown_super(struct super_block *sb);
 void kill_block_super(struct super_block *sb);
@@ -1822,30 +1822,30 @@ int set_anon_super(struct super_block *s
 int get_anon_bdev(dev_t *);
 void free_anon_bdev(dev_t);
 struct super_block *sget(struct file_system_type *type,
-			int (*test)(struct super_block *,void *),
-			int (*set)(struct super_block *,void *),
-			int flags, void *data);
+			 int (*test)(struct super_block *, void *),
+			 int (*set)(struct super_block *, void *),
+			 int flags, void *data);
 struct dentry *mount_pseudo(struct file_system_type *, char *,
-	const struct super_operations *ops,
-	const struct dentry_operations *dops,
-	unsigned long);
+			    const struct super_operations *ops,
+			    const struct dentry_operations *dops,
+			    unsigned long);
 
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
-#define fops_get(fops) \
+#define fops_get(fops)							\
 	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
-#define fops_put(fops) \
-	do { if (fops) module_put((fops)->owner); } while(0)
+#define fops_put(fops)						\
+	do { if (fops) module_put((fops)->owner); } while (0)
 /*
  * This one is to be used *ONLY* from ->open() instances.
  * fops must be non-NULL, pinned down *and* module dependencies
  * should be sufficient to pin the caller down as well.
  */
-#define replace_fops(f, fops) \
-	do {	\
-		struct file *__file = (f); \
-		fops_put(__file->f_op); \
-		BUG_ON(!(__file->f_op = (fops))); \
-	} while(0)
+#define replace_fops(f, fops)				\
+	do {						\
+		struct file *__file = (f);		\
+		fops_put(__file->f_op);			\
+		BUG_ON(!(__file->f_op = (fops)));	\
+	} while (0)
 
 int register_filesystem(struct file_system_type *);
 int unregister_filesystem(struct file_system_type *);
@@ -1858,7 +1858,7 @@ long do_mount(const char *, const char *
 struct vfsmount *collect_mounts(struct path *);
 void drop_collected_mounts(struct vfsmount *);
 int iterate_mounts(int (*)(struct vfsmount *, void *), void *,
-			  struct vfsmount *);
+		   struct vfsmount *);
 int vfs_statfs(struct path *, struct kstatfs *);
 int user_statfs(const char __user *, struct kstatfs *);
 int fd_statfs(int, struct kstatfs *);
@@ -1870,7 +1870,7 @@ bool fs_fully_visible(struct file_system
 
 int current_umask(void);
 
-void ihold(struct inode * inode);
+void ihold(struct inode *inode);
 void iput(struct inode *);
 
 static inline struct inode *file_inode(struct file *f)
@@ -1918,8 +1918,8 @@ static inline int locks_verify_locked(st
 }
 
 static inline int locks_verify_truncate(struct inode *inode,
-				    struct file *filp,
-				    loff_t size)
+					struct file *filp,
+					loff_t size)
 {
 	if (inode->i_flock && mandatory_lock(inode))
 		return locks_mandatory_area(
@@ -1927,7 +1927,7 @@ static inline int locks_verify_truncate(
 			size < inode->i_size ? size : inode->i_size,
 			(size < inode->i_size ? inode->i_size - size
 			 : size - inode->i_size)
-		);
+			);
 	return 0;
 }
 
@@ -1961,7 +1961,7 @@ static inline int try_break_deleg(struct
 {
 	int ret;
 
-	ret = break_deleg(inode, O_WRONLY|O_NONBLOCK);
+	ret = break_deleg(inode, O_WRONLY | O_NONBLOCK);
 	if (ret == -EWOULDBLOCK && delegated_inode) {
 		*delegated_inode = inode;
 		ihold(inode);
@@ -2047,16 +2047,16 @@ struct filename {
 
 long vfs_truncate(struct path *, loff_t);
 int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
-		       struct file *filp);
+		struct file *filp);
 int do_fallocate(struct file *file, int mode, loff_t offset,
-			loff_t len);
+		 loff_t len);
 long do_sys_open(int dfd, const char __user *filename, int flags,
-			umode_t mode);
+		 umode_t mode);
 struct file *file_open_name(struct filename *, int, umode_t);
 struct file *filp_open(const char *, int, umode_t);
 struct file *file_open_root(struct dentry *, struct vfsmount *,
-				   const char *, int);
-struct file * dentry_open(const struct path *, int, const struct cred *);
+			    const char *, int);
+struct file *dentry_open(const struct path *, int, const struct cred *);
 int filp_close(struct file *, fl_owner_t id);
 
 struct filename *getname(const char __user *);
@@ -2067,8 +2067,8 @@ enum {
 	FILE_OPENED = 2
 };
 int finish_open(struct file *file, struct dentry *dentry,
-			int (*open)(struct inode *, struct file *),
-			int *opened);
+		int (*open)(struct inode *, struct file *),
+		int *opened);
 int finish_no_open(struct file *file, struct dentry *dentry);
 
 /* fs/ioctl.c */
@@ -2143,14 +2143,14 @@ int blkdev_ioctl(struct block_device *,
 long compat_blkdev_ioctl(struct file *, unsigned, unsigned long);
 int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder);
 struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
-					       void *holder);
+					void *holder);
 struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode,
-					      void *holder);
+				       void *holder);
 void blkdev_put(struct block_device *bdev, fmode_t mode);
 #ifdef CONFIG_SYSFS
 int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
 void bd_unlink_disk_holder(struct block_device *bdev,
-				  struct gendisk *disk);
+			   struct gendisk *disk);
 #else
 static inline int bd_link_disk_holder(struct block_device *bdev,
 				      struct gendisk *disk)
@@ -2169,12 +2169,12 @@ static inline void bd_unlink_disk_holder
 int alloc_chrdev_region(dev_t *, unsigned, unsigned, const char *);
 int register_chrdev_region(dev_t, unsigned, const char *);
 int __register_chrdev(unsigned int major, unsigned int baseminor,
-			     unsigned int count, const char *name,
-			     const struct file_operations *fops);
+		      unsigned int count, const char *name,
+		      const struct file_operations *fops);
 void __unregister_chrdev(unsigned int major, unsigned int baseminor,
-				unsigned int count, const char *name);
+			 unsigned int count, const char *name);
 void unregister_chrdev_region(dev_t, unsigned);
-void chrdev_show(struct seq_file *,off_t);
+void chrdev_show(struct seq_file *, off_t);
 
 static inline int register_chrdev(unsigned int major, const char *name,
 				  const struct file_operations *fops)
@@ -2196,7 +2196,7 @@ static inline void unregister_chrdev(uns
 const char *__bdevname(dev_t, char *buffer);
 const char *bdevname(struct block_device *bdev, char *buffer);
 struct block_device *lookup_bdev(const char *);
-void blkdev_show(struct seq_file *,off_t);
+void blkdev_show(struct seq_file *, off_t);
 
 #else
 #define BLKDEV_MAJOR_HASH_SIZE	0
@@ -2220,14 +2220,14 @@ int is_bad_inode(struct inode *);
 #define bio_data_dir(bio)	((bio)->bi_rw & 1)
 
 void check_disk_size_change(struct gendisk *disk,
-				   struct block_device *bdev);
+			    struct block_device *bdev);
 int revalidate_disk(struct gendisk *);
 int check_disk_change(struct block_device *);
 int __invalidate_device(struct block_device *, bool);
 int invalidate_partition(struct gendisk *, int);
 #endif
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
-					pgoff_t start, pgoff_t end);
+				       pgoff_t start, pgoff_t end);
 
 static inline void invalidate_remote_inode(struct inode *inode)
 {
@@ -2237,23 +2237,23 @@ static inline void invalidate_remote_ino
 }
 int invalidate_inode_pages2(struct address_space *mapping);
 int invalidate_inode_pages2_range(struct address_space *mapping,
-					 pgoff_t start, pgoff_t end);
+				  pgoff_t start, pgoff_t end);
 int write_inode_now(struct inode *, int);
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
 int filemap_fdatawait(struct address_space *);
 int filemap_fdatawait_range(struct address_space *, loff_t lstart,
-				   loff_t lend);
+			    loff_t lend);
 int filemap_write_and_wait(struct address_space *mapping);
 int filemap_write_and_wait_range(struct address_space *mapping,
-				        loff_t lstart, loff_t lend);
+				 loff_t lstart, loff_t lend);
 int __filemap_fdatawrite_range(struct address_space *mapping,
-				loff_t start, loff_t end, int sync_mode);
+			       loff_t start, loff_t end, int sync_mode);
 int filemap_fdatawrite_range(struct address_space *mapping,
-				loff_t start, loff_t end);
+			     loff_t start, loff_t end);
 
 int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
-			   int datasync);
+		    int datasync);
 int vfs_fsync(struct file *file, int datasync);
 static inline int generic_write_sync(struct file *file, loff_t pos, loff_t count)
 {
@@ -2322,7 +2322,7 @@ static inline int deny_write_access(stru
 	struct inode *inode = file_inode(file);
 	return atomic_dec_unless_positive(&inode->i_writecount) ? 0 : -ETXTBSY;
 }
-static inline void put_write_access(struct inode * inode)
+static inline void put_write_access(struct inode *inode)
 {
 	atomic_dec(&inode->i_writecount);
 }
@@ -2360,8 +2360,8 @@ int do_pipe_flags(int *, int);
 
 int kernel_read(struct file *, loff_t, char *, unsigned long);
 ssize_t kernel_write(struct file *, const char *, size_t, loff_t);
-struct file * open_exec(const char *);
- 
+struct file *open_exec(const char *);
+
 /* fs/dcache.c -- generic fs support functions */
 int is_subdir(struct dentry *, struct dentry *);
 int path_is_under(struct path *, struct path *);
@@ -2376,7 +2376,7 @@ loff_t vfs_llseek(struct file *file, lof
 int inode_init_always(struct super_block *, struct inode *);
 void inode_init_once(struct inode *);
 void address_space_init_once(struct address_space *mapping);
-struct inode * igrab(struct inode *);
+struct inode *igrab(struct inode *);
 ino_t iunique(struct super_block *, ino_t);
 int inode_needs_sync(struct inode *inode);
 int generic_delete_inode(struct inode *inode);
@@ -2386,14 +2386,14 @@ static inline int generic_drop_inode(str
 }
 
 struct inode *ilookup5_nowait(struct super_block *sb,
-		unsigned long hashval, int (*test)(struct inode *, void *),
-		void *data);
+			      unsigned long hashval, int (*test)(struct inode *, void *),
+			      void *data);
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
-		int (*test)(struct inode *, void *), void *data);
+		       int (*test)(struct inode *, void *), void *data);
 struct inode *ilookup(struct super_block *sb, unsigned long ino);
 
-struct inode * iget5_locked(struct super_block *, unsigned long, int (*test)(struct inode *, void *), int (*set)(struct inode *, void *), void *);
-struct inode * iget_locked(struct super_block *, unsigned long);
+struct inode *iget5_locked(struct super_block *, unsigned long, int (*test)(struct inode *, void *), int (*set)(struct inode *, void *), void *);
+struct inode *iget_locked(struct super_block *, unsigned long);
 int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
 int insert_inode_locked(struct inode *);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -2404,7 +2404,7 @@ static inline void lockdep_annotate_inod
 void unlock_new_inode(struct inode *);
 unsigned int get_next_ino(void);
 
-void __iget(struct inode * inode);
+void __iget(struct inode *inode);
 void iget_failed(struct inode *);
 void clear_inode(struct inode *);
 void __destroy_inode(struct inode *);
@@ -2440,7 +2440,7 @@ int sb_min_blocksize(struct super_block
 int generic_file_mmap(struct file *, struct vm_area_struct *);
 int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 int generic_file_remap_pages(struct vm_area_struct *, unsigned long addr,
-		unsigned long size, pgoff_t pgoff);
+			     unsigned long size, pgoff_t pgoff);
 int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk);
 ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
@@ -2455,18 +2455,18 @@ ssize_t new_sync_write(struct file *filp
 /* fs/block_dev.c */
 ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from);
 int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
-			int datasync);
+		 int datasync);
 void block_sync_page(struct page *page);
 
 /* fs/splice.c */
 ssize_t generic_file_splice_read(struct file *, loff_t *,
-		struct pipe_inode_info *, size_t, unsigned int);
+				 struct pipe_inode_info *, size_t, unsigned int);
 ssize_t default_file_splice_read(struct file *, loff_t *,
-		struct pipe_inode_info *, size_t, unsigned int);
+				 struct pipe_inode_info *, size_t, unsigned int);
 ssize_t iter_file_splice_write(struct pipe_inode_info *,
-		struct file *, loff_t *, size_t, unsigned int);
+			       struct file *, loff_t *, size_t, unsigned int);
 ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
-		struct file *out, loff_t *, size_t len, unsigned int flags);
+				struct file *out, loff_t *, size_t len, unsigned int flags);
 
 void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
@@ -2475,18 +2475,18 @@ loff_t no_llseek(struct file *file, loff
 loff_t vfs_setpos(struct file *file, loff_t offset, loff_t maxsize);
 loff_t generic_file_llseek(struct file *file, loff_t offset, int whence);
 loff_t generic_file_llseek_size(struct file *file, loff_t offset,
-		int whence, loff_t maxsize, loff_t eof);
+				int whence, loff_t maxsize, loff_t eof);
 loff_t fixed_size_llseek(struct file *file, loff_t offset,
-		int whence, loff_t size);
-int generic_file_open(struct inode * inode, struct file * filp);
-int nonseekable_open(struct inode * inode, struct file * filp);
+			 int whence, loff_t size);
+int generic_file_open(struct inode *inode, struct file *filp);
+int nonseekable_open(struct inode *inode, struct file *filp);
 
 #ifdef CONFIG_FS_XIP
 ssize_t xip_file_read(struct file *filp, char __user *buf, size_t len,
-			     loff_t *ppos);
-int xip_file_mmap(struct file * file, struct vm_area_struct * vma);
+		      loff_t *ppos);
+int xip_file_mmap(struct file *file, struct vm_area_struct *vma);
 ssize_t xip_file_write(struct file *filp, const char __user *buf,
-			      size_t len, loff_t *ppos);
+		       size_t len, loff_t *ppos);
 int xip_truncate_page(struct address_space *mapping, loff_t from);
 #else
 static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
@@ -2513,13 +2513,13 @@ enum {
 void dio_end_io(struct bio *bio, int error);
 
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, struct iov_iter *iter, loff_t offset,
-	get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags);
+			     struct block_device *bdev, struct iov_iter *iter, loff_t offset,
+			     get_block_t get_block, dio_iodone_t end_io,
+			     dio_submit_t submit_io,	int flags);
 
 static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
-		struct inode *inode, struct iov_iter *iter, loff_t offset,
-		get_block_t get_block)
+					 struct inode *inode, struct iov_iter *iter, loff_t offset,
+					 get_block_t get_block)
 {
 	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iter,
 				    offset, get_block, NULL, NULL,
@@ -2531,18 +2531,18 @@ void inode_dio_wait(struct inode *inode)
 void inode_dio_done(struct inode *inode);
 
 void inode_set_flags(struct inode *inode, unsigned int flags,
-			    unsigned int mask);
+		     unsigned int mask);
 
 extern const struct file_operations generic_ro_fops;
 
-#define special_file(m) (S_ISCHR(m)||S_ISBLK(m)||S_ISFIFO(m)||S_ISSOCK(m))
+#define special_file(m) (S_ISCHR(m) || S_ISBLK(m) || S_ISFIFO(m) || S_ISSOCK(m))
 
 int readlink_copy(char __user *, int, const char *);
 int page_readlink(struct dentry *, char __user *, int);
 void *page_follow_link_light(struct dentry *, struct nameidata *);
 void page_put_link(struct dentry *, struct nameidata *, void *);
 int __page_symlink(struct inode *inode, const char *symname, int len,
-		int nofs);
+		   int nofs);
 int page_symlink(struct inode *inode, const char *symname, int len);
 extern const struct inode_operations page_symlink_inode_operations;
 void kfree_put_link(struct dentry *, struct nameidata *, void *);
@@ -2566,14 +2566,14 @@ int vfs_fstat(unsigned int, struct kstat
 int vfs_fstatat(int , const char __user *, struct kstat *, int);
 
 int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
-		    unsigned long arg);
+		 unsigned long arg);
 int __generic_block_fiemap(struct inode *inode,
-				  struct fiemap_extent_info *fieinfo,
-				  loff_t start, loff_t len,
-				  get_block_t *get_block);
+			   struct fiemap_extent_info *fieinfo,
+			   loff_t start, loff_t len,
+			   get_block_t *get_block);
 int generic_block_fiemap(struct inode *inode,
-				struct fiemap_extent_info *fieinfo, u64 start,
-				u64 len, get_block_t *get_block);
+			 struct fiemap_extent_info *fieinfo, u64 start,
+			 u64 len, get_block_t *get_block);
 
 void get_filesystem(struct file_system_type *fs);
 void put_filesystem(struct file_system_type *fs);
@@ -2584,7 +2584,7 @@ struct super_block *get_active_super(str
 void drop_super(struct super_block *sb);
 void iterate_supers(void (*)(struct super_block *, void *), void *);
 void iterate_supers_type(struct file_system_type *,
-			        void (*)(struct super_block *, void *), void *);
+			 void (*)(struct super_block *, void *), void *);
 
 int dcache_dir_open(struct inode *, struct file *);
 int dcache_dir_close(struct inode *, struct file *);
@@ -2602,11 +2602,11 @@ int noop_fsync(struct file *, loff_t, lo
 int simple_empty(struct dentry *);
 int simple_readpage(struct file *file, struct page *page);
 int simple_write_begin(struct file *file, struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned flags,
-			struct page **pagep, void **fsdata);
+		       loff_t pos, unsigned len, unsigned flags,
+		       struct page **pagep, void **fsdata);
 int simple_write_end(struct file *file, struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned copied,
-			struct page *page, void *fsdata);
+		     loff_t pos, unsigned len, unsigned copied,
+		     struct page *page, void *fsdata);
 int always_delete_dentry(const struct dentry *);
 struct inode *alloc_anon_inode(struct super_block *);
 extern const struct dentry_operations simple_dentry_operations;
@@ -2622,9 +2622,9 @@ int simple_pin_fs(struct file_system_typ
 void simple_release_fs(struct vfsmount **mount, int *count);
 
 ssize_t simple_read_from_buffer(void __user *to, size_t count,
-			loff_t *ppos, const void *from, size_t available);
+				loff_t *ppos, const void *from, size_t available);
 ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
-		const void __user *from, size_t count);
+			       const void __user *from, size_t count);
 
 int __generic_file_fsync(struct file *, loff_t, loff_t, int);
 int generic_file_fsync(struct file *, loff_t, loff_t, int);
@@ -2633,8 +2633,8 @@ int generic_check_addressable(unsigned,
 
 #ifdef CONFIG_MIGRATION
 int buffer_migrate_page(struct address_space *,
-				struct page *, struct page *,
-				enum migrate_mode);
+			struct page *, struct page *,
+			enum migrate_mode);
 #else
 #define buffer_migrate_page NULL
 #endif
@@ -2677,7 +2677,7 @@ struct simple_transaction_argresp {
 #define SIMPLE_TRANSACTION_LIMIT (PAGE_SIZE - sizeof(struct simple_transaction_argresp))
 
 char *simple_transaction_get(struct file *file, const char __user *buf,
-				size_t size);
+			     size_t size);
 ssize_t simple_transaction_read(struct file *file, char __user *buf,
 				size_t size, loff_t *pos);
 int simple_transaction_release(struct inode *inode, struct file *file);
@@ -2718,7 +2718,7 @@ static const struct file_operations __fo
 static inline __printf(1, 2)
 void __simple_attr_check_format(const char *fmt, ...)
 {
-	/* don't do anything, just let the compiler check the arguments; */
+/* don't do anything, just let the compiler check the arguments; */
 }
 
 int simple_attr_open(struct inode *inode, struct file *file,
@@ -2734,16 +2734,16 @@ struct ctl_table;
 int proc_nr_files(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
 int proc_nr_dentry(struct ctl_table *table, int write,
-		  void __user *buffer, size_t *lenp, loff_t *ppos);
+		   void __user *buffer, size_t *lenp, loff_t *ppos);
 int proc_nr_inodes(struct ctl_table *table, int write,
 		   void __user *buffer, size_t *lenp, loff_t *ppos);
 int __init get_filesystem_list(char *buf);
 
-#define __FMODE_EXEC		((__force int) FMODE_EXEC)
-#define __FMODE_NONOTIFY	((__force int) FMODE_NONOTIFY)
+#define __FMODE_EXEC		((__force int)FMODE_EXEC)
+#define __FMODE_NONOTIFY	((__force int)FMODE_NONOTIFY)
 
-#define ACC_MODE(x) ("\004\002\006\006"[(x)&O_ACCMODE])
-#define OPEN_FMODE(flag) ((__force fmode_t)(((flag + 1) & O_ACCMODE) | \
+#define ACC_MODE(x) ("\004\002\006\006"[(x) & O_ACCMODE])
+#define OPEN_FMODE(flag) ((__force fmode_t)(((flag + 1) & O_ACCMODE) |	\
 					    (flag & __FMODE_NONOTIFY)))
 
 static inline int is_sxid(umode_t mode)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
fsh-a-few-more-whitespace-neatenings.patch
fsh-add-argument-names-to-struct-file_lock_operations-funcs.patch
fsh-add-member-argument-descriptions-to-lock_manager_operations.patch
dlm-plock-add-argument-descriptions-to-notify.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch

