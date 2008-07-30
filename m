From: akpm@linux-foundation.org
Subject: + configure-out-file-locking-features.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:02:46 -0700
Message-ID: <200807300002.m6U02kf8029107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbYG3ADY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:03:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas.petazzoni@free-electrons.com, bfields@fieldses.org, mpm@selenic.com, willy@debian.org


The patch titled
     Configure out file locking features
has been added to the -mm tree.  Its filename is
     configure-out-file-locking-features.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Configure out file locking features
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Add the CONFIG_FILE_LOCKING option which allows to remove support for
advisory locks.  With this patch enabled, the flock() system call, the
F_GETLK, F_SETLK and F_SETLKW operations of fcntl() and NFS support are
disabled.  These features are not necessarly needed on embedded systems. 
It allows to save ~11 Kb of kernel code and data:

   text	   data	    bss	    dec	    hex	filename
1125436	 118764	 212992	1457192	 163c28	vmlinux.old
1114299	 118564	 212992	1445855	 160fdf	vmlinux
 -11137    -200       0  -11337   -2C49 +/-

This patch has originally been written by Matt Mackall <mpm@selenic.com>,
and is part of the Linux Tiny project.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig          |    2 -
 fs/Makefile         |    3 +-
 fs/proc/proc_misc.c |    4 +++
 include/linux/fs.h  |   52 ++++++++++++++++++++++++++++++++++++------
 init/Kconfig        |    8 ++++++
 kernel/sys_ni.c     |    1 
 kernel/sysctl.c     |    6 ++++
 7 files changed, 66 insertions(+), 10 deletions(-)

diff -puN fs/Kconfig~configure-out-file-locking-features fs/Kconfig
--- a/fs/Kconfig~configure-out-file-locking-features
+++ a/fs/Kconfig
@@ -1559,7 +1559,7 @@ if NETWORK_FILESYSTEMS
 
 config NFS_FS
 	tristate "NFS client support"
-	depends on INET
+	depends on INET && FILE_LOCKING
 	select LOCKD
 	select SUNRPC
 	select NFS_ACL_SUPPORT if NFS_V3_ACL
diff -puN fs/Makefile~configure-out-file-locking-features fs/Makefile
--- a/fs/Makefile~configure-out-file-locking-features
+++ a/fs/Makefile
@@ -7,7 +7,7 @@
 
 obj-y :=	open.o read_write.o file_table.o super.o \
 		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
-		ioctl.o readdir.o select.o fifo.o locks.o dcache.o inode.o \
+		ioctl.o readdir.o select.o fifo.o dcache.o inode.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
@@ -27,6 +27,7 @@ obj-$(CONFIG_ANON_INODES)	+= anon_inodes
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
 obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
+obj-$(CONFIG_FILE_LOCKING)      += locks.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
 
 nfsd-$(CONFIG_NFSD)		:= nfsctl.o
diff -puN fs/proc/proc_misc.c~configure-out-file-locking-features fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~configure-out-file-locking-features
+++ a/fs/proc/proc_misc.c
@@ -677,6 +677,7 @@ static int cmdline_read_proc(char *page,
 	return proc_calc_metrics(page, start, off, count, eof, len);
 }
 
+#ifdef CONFIG_FILE_LOCKING
 static int locks_open(struct inode *inode, struct file *filp)
 {
 	return seq_open(filp, &locks_seq_operations);
@@ -688,6 +689,7 @@ static const struct file_operations proc
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
+#endif /* CONFIG_FILE_LOCKING */
 
 static int execdomains_read_proc(char *page, char **start, off_t off,
 				 int count, int *eof, void *data)
@@ -881,7 +883,9 @@ void __init proc_misc_init(void)
 #ifdef CONFIG_PRINTK
 	proc_create("kmsg", S_IRUSR, NULL, &proc_kmsg_operations);
 #endif
+#ifdef CONFIG_FILE_LOCKING
 	proc_create("locks", 0, NULL, &proc_locks_operations);
+#endif
 	proc_create("devices", 0, NULL, &proc_devinfo_operations);
 	proc_create("cpuinfo", 0, NULL, &proc_cpuinfo_operations);
 #ifdef CONFIG_BLOCK
diff -puN include/linux/fs.h~configure-out-file-locking-features include/linux/fs.h
--- a/include/linux/fs.h~configure-out-file-locking-features
+++ a/include/linux/fs.h
@@ -983,6 +983,13 @@ struct file_lock {
 
 #include <linux/fcntl.h>
 
+extern void send_sigio(struct fown_struct *fown, int fd, int band);
+
+/* fs/sync.c */
+extern int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
+			loff_t endbyte, unsigned int flags);
+
+#ifdef CONFIG_FILE_LOCKING
 extern int fcntl_getlk(struct file *, struct flock __user *);
 extern int fcntl_setlk(unsigned int, struct file *, unsigned int,
 			struct flock __user *);
@@ -993,14 +1000,9 @@ extern int fcntl_setlk64(unsigned int, s
 			struct flock64 __user *);
 #endif
 
-extern void send_sigio(struct fown_struct *fown, int fd, int band);
 extern int fcntl_setlease(unsigned int fd, struct file *filp, long arg);
 extern int fcntl_getlease(struct file *filp);
 
-/* fs/sync.c */
-extern int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
-			loff_t endbyte, unsigned int flags);
-
 /* fs/locks.c */
 extern void locks_init_lock(struct file_lock *);
 extern void locks_copy_lock(struct file_lock *, struct file_lock *);
@@ -1023,6 +1025,33 @@ extern int lease_modify(struct file_lock
 extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
 extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
 extern struct seq_operations locks_seq_operations;
+#else /* !CONFIG_FILE_LOCKING */
+#define fcntl_getlk(a, b) (-EINVAL)
+#define fcntl_setlk(a, b, c, d) (-EACCES)
+#if BITS_PER_LONG == 32
+#define fcntl_getlk64(a, b) (-EINVAL)
+#define fcntl_setlk64(a, b, c, d) (-EACCES)
+#endif
+#define fcntl_setlease(a, b, c) (0)
+#define fcntl_getlease(a) (0)
+#define locks_init_lock(a)
+#define locks_copy_lock(a, b)
+#define locks_remove_posix(a, b)
+#define locks_remove_flock(a)
+#define posix_test_lock(a, b) (0)
+#define posix_lock_file(a, b) (-ENOLCK)
+#define posix_lock_file_wait(a, b) (-ENOLCK)
+#define posix_unblock_lock(a, b) (-ENOENT)
+#define vfs_test_lock(a, b) (0)
+#define vfs_lock_file(a, b, c, d) (-ENOLCK)
+#define vfs_cancel_lock(a, b) (0)
+#define flock_lock_file_wait(a, b) (-ENOLCK)
+#define __break_lease(a, b) (0)
+#define lease_get_mtime(a, b)
+#define lock_may_read(a, b, c) (1)
+#define lock_may_write(a, b, c) (1)
+#endif /* !CONFIG_FILE_LOCKING */
+
 
 struct fasync_struct {
 	int	magic;
@@ -1554,9 +1583,12 @@ extern int vfs_statfs(struct dentry *, s
 /* /sys/fs */
 extern struct kobject *fs_kobj;
 
+extern int rw_verify_area(int, struct file *, loff_t *, size_t);
+
 #define FLOCK_VERIFY_READ  1
 #define FLOCK_VERIFY_WRITE 2
 
+#ifdef CONFIG_FILE_LOCKING
 extern int locks_mandatory_locked(struct inode *);
 extern int locks_mandatory_area(int, struct inode *, struct file *, loff_t, size_t);
 
@@ -1587,8 +1619,6 @@ static inline int locks_verify_locked(st
 	return 0;
 }
 
-extern int rw_verify_area(int, struct file *, loff_t *, size_t);
-
 static inline int locks_verify_truncate(struct inode *inode,
 				    struct file *filp,
 				    loff_t size)
@@ -1609,6 +1639,14 @@ static inline int break_lease(struct ino
 		return __break_lease(inode, mode);
 	return 0;
 }
+#else /* !CONFIG_FILE_LOCKING */
+#define locks_mandatory_locked(a) (0)
+#define locks_mandatory_area(a, b, c, d, e) (0)
+#define mandatory_lock(a) (0)
+#define locks_verify_locked(a) (0)
+#define locks_verify_truncate(a, b, c) (0)
+#define break_lease(a, b) (0)
+#endif /* CONFIG_FILE_LOCKING */
 
 /* fs/open.c */
 
diff -puN init/Kconfig~configure-out-file-locking-features init/Kconfig
--- a/init/Kconfig~configure-out-file-locking-features
+++ a/init/Kconfig
@@ -724,6 +724,14 @@ config SHMEM
 	  option replaces shmem and tmpfs with the much simpler ramfs code,
 	  which may be appropriate on small systems without swap.
 
+config FILE_LOCKING
+	bool "Enable POSIX file locking API" if EMBEDDED
+	default y
+	help
+	  This option enables standard file locking support, required
+          for filesystems like NFS and for the flock() system
+          call. Disabling this option saves about 11k.
+
 config VM_EVENT_COUNTERS
 	default y
 	bool "Enable VM event counters for /proc/vmstat" if EMBEDDED
diff -puN kernel/sys_ni.c~configure-out-file-locking-features kernel/sys_ni.c
--- a/kernel/sys_ni.c~configure-out-file-locking-features
+++ a/kernel/sys_ni.c
@@ -94,6 +94,7 @@ cond_syscall(compat_sys_set_mempolicy);
 cond_syscall(sys_add_key);
 cond_syscall(sys_request_key);
 cond_syscall(sys_keyctl);
+cond_syscall(sys_flock);
 cond_syscall(compat_sys_keyctl);
 cond_syscall(compat_sys_socketcall);
 cond_syscall(sys_inotify_init);
diff -puN kernel/sysctl.c~configure-out-file-locking-features kernel/sysctl.c
--- a/kernel/sysctl.c~configure-out-file-locking-features
+++ a/kernel/sysctl.c
@@ -98,7 +98,7 @@ static int sixty = 60;
 static int neg_one = -1;
 #endif
 
-#ifdef CONFIG_MMU
+#if defined(CONFIG_MMU) && defined(CONFIG_FILE_LOCKING)
 static int two = 2;
 #endif
 
@@ -1272,6 +1272,7 @@ static struct ctl_table fs_table[] = {
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
+#ifdef CONFIG_FILE_LOCKING
 	{
 		.ctl_name	= FS_LEASES,
 		.procname	= "leases-enable",
@@ -1280,6 +1281,7 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#endif
 #ifdef CONFIG_DNOTIFY
 	{
 		.ctl_name	= FS_DIR_NOTIFY,
@@ -1291,6 +1293,7 @@ static struct ctl_table fs_table[] = {
 	},
 #endif
 #ifdef CONFIG_MMU
+#ifdef CONFIG_FILE_LOCKING
 	{
 		.ctl_name	= FS_LEASE_TIME,
 		.procname	= "lease-break-time",
@@ -1302,6 +1305,7 @@ static struct ctl_table fs_table[] = {
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
+#endif /* CONFIG_FILE_LOCKING */
 	{
 		.procname	= "aio-nr",
 		.data		= &aio_nr,
_

Patches currently in -mm which might be from thomas.petazzoni@free-electrons.com are

configure-out-file-locking-features.patch
configure-out-aio-support.patch
configure-out-ethtool-support.patch
configure-out-igmp-support.patch

