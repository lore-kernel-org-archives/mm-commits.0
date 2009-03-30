From: akpm@linux-foundation.org
Subject: [merged] vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:30 -0700
Message-ID: <200903301906.n2UJ6Ua4019063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759359AbZC3TKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:10:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: swhiteho@redhat.com, randy.dunlap@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: update fs.h to use inline functions when no file locking set
has been removed from the -mm tree.  Its filename was
     vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: update fs.h to use inline functions when no file locking set
From: Steven Whitehouse <swhiteho@redhat.com>

This avoids various issues which might give rise to compiler warnings
about missing functions and/or unused variable with the previous macros. 
This also fixes a bug where one of the macros was returning 0, but it
should have been void.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |  165 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 139 insertions(+), 26 deletions(-)

diff -puN include/linux/fs.h~vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set include/linux/fs.h
--- a/include/linux/fs.h~vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set
+++ a/include/linux/fs.h
@@ -1068,34 +1068,147 @@ extern int lease_modify(struct file_lock
 extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
 extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
 #else /* !CONFIG_FILE_LOCKING */
-#define fcntl_getlk(a, b) ({ -EINVAL; })
-#define fcntl_setlk(a, b, c, d) ({ -EACCES; })
+static inline int fcntl_getlk(struct file *file, struct flock __user *user)
+{
+	return -EINVAL;
+}
+
+static inline int fcntl_setlk(unsigned int fd, struct file *file,
+			      unsigned int cmd, struct flock __user *user)
+{
+	return -EACCES;
+}
+
 #if BITS_PER_LONG == 32
-#define fcntl_getlk64(a, b) ({ -EINVAL; })
-#define fcntl_setlk64(a, b, c, d) ({ -EACCES; })
+static inline int fcntl_getlk64(struct file *file, struct flock64 __user *user)
+{
+	return -EINVAL;
+}
+
+static inline int fcntl_setlk64(unsigned int fd, struct file *file,
+				unsigned int cmd, struct flock64 __user *user)
+{
+	return -EACCES;
+}
 #endif
-#define fcntl_setlease(a, b, c) ({ 0; })
-#define fcntl_getlease(a) ({ 0; })
-#define locks_init_lock(a) ({ })
-#define __locks_copy_lock(a, b) ({ })
-#define locks_copy_lock(a, b) ({ })
-#define locks_remove_posix(a, b) ({ })
-#define locks_remove_flock(a) ({ })
-#define posix_test_lock(a, b) ({ 0; })
-#define posix_lock_file(a, b, c) ({ -ENOLCK; })
-#define posix_lock_file_wait(a, b) ({ -ENOLCK; })
-#define posix_unblock_lock(a, b) (-ENOENT)
-#define vfs_test_lock(a, b) ({ 0; })
-#define vfs_lock_file(a, b, c, d) (-ENOLCK)
-#define vfs_cancel_lock(a, b) ({ 0; })
-#define flock_lock_file_wait(a, b) ({ -ENOLCK; })
-#define __break_lease(a, b) ({ 0; })
-#define lease_get_mtime(a, b) ({ })
-#define generic_setlease(a, b, c) ({ -EINVAL; })
-#define vfs_setlease(a, b, c) ({ -EINVAL; })
-#define lease_modify(a, b) ({ -EINVAL; })
-#define lock_may_read(a, b, c) ({ 1; })
-#define lock_may_write(a, b, c) ({ 1; })
+static inline int fcntl_setlease(unsigned int fd, struct file *filp, long arg)
+{
+	return 0;
+}
+
+static inline int fcntl_getlease(struct file *filp)
+{
+	return 0;
+}
+
+static inline void locks_init_lock(struct file_lock *fl)
+{
+	return;
+}
+
+static inline void __locks_copy_lock(struct file_lock *new, struct file_lock *fl)
+{
+	return;
+}
+
+static inline void locks_copy_lock(struct file_lock *new, struct file_lock *fl)
+{
+	return;
+}
+
+static inline void locks_remove_posix(struct file *filp, fl_owner_t owner)
+{
+	return;
+}
+
+static inline void locks_remove_flock(struct file *filp)
+{
+	return;
+}
+
+static inline void posix_test_lock(struct file *filp, struct file_lock *fl)
+{
+	return;
+}
+
+static inline int posix_lock_file(struct file *filp, struct file_lock *fl,
+				  struct file_lock *conflock)
+{
+	return -ENOLCK;
+}
+
+static inline int posix_lock_file_wait(struct file *filp, struct file_lock *fl)
+{
+	return -ENOLCK;
+}
+
+static inline int posix_unblock_lock(struct file *filp,
+				     struct file_lock *waiter)
+{
+	return -ENOENT;
+}
+
+static inline int vfs_test_lock(struct file *filp, struct file_lock *fl)
+{
+	return 0;
+}
+
+static inline int vfs_lock_file(struct file *filp, unsigned int cmd,
+				struct file_lock *fl, struct file_lock *conf)
+{
+	return -ENOLCK;
+}
+
+static inline int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
+{
+	return 0;
+}
+
+static inline int flock_lock_file_wait(struct file *filp,
+				       struct file_lock *request)
+{
+	return -ENOLCK;
+}
+
+static inline int __break_lease(struct inode *inode, unsigned int mode)
+{
+	return 0;
+}
+
+static inline void lease_get_mtime(struct inode *inode, struct timespec *time)
+{
+	return;
+}
+
+static inline int generic_setlease(struct file *filp, long arg,
+				    struct file_lock **flp)
+{
+	return -EINVAL;
+}
+
+static inline int vfs_setlease(struct file *filp, long arg,
+			       struct file_lock **lease)
+{
+	return -EINVAL;
+}
+
+static inline int lease_modify(struct file_lock **before, int arg)
+{
+	return -EINVAL;
+}
+
+static inline int lock_may_read(struct inode *inode, loff_t start,
+				unsigned long len)
+{
+	return 1;
+}
+
+static inline int lock_may_write(struct inode *inode, loff_t start,
+				 unsigned long len)
+{
+	return 1;
+}
+
 #endif /* !CONFIG_FILE_LOCKING */
 
 
_

Patches currently in -mm which might be from swhiteho@redhat.com are

origin.patch
mm-page_mkwrite-change-prototype-to-match-fault.patch

