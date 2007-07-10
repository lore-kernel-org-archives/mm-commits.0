From: akpm@linux-foundation.org
Subject: - fallocate-implementation-on-i86-x86_64-and-powerpc.patch removed from -mm tree
Date: Tue, 10 Jul 2007 02:14:36 -0700
Message-ID: <200707100914.l6A9EaWb021007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50433 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756978AbXGJJP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 05:15:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarora@linux.vnet.ibm.com, aarora@in.ibm.com, ak@suse.de, arnd@arndb.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, mark.fasheh@oracle.com, paulus@samba.org, schwidefsky@de.ibm.com, tony.luck@intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     fallocate() implementation on i86, x86_64 and powerpc
has been removed from the -mm tree.  Its filename was
     fallocate-implementation-on-i86-x86_64-and-powerpc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: fallocate() implementation on i86, x86_64 and powerpc
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>

This patch implements sys_fallocate() and adds support on i386, x86_64
and powerpc platforms.

Changelog:

Changes from Take3 to Take4:
 1) Do not update c/mtime. Let each filesystem update ctime (update of
    mtime will not be required for allocation since we touch only
    metadata/inode and not blocks), if required.
Changes from Take2 to Take3:
 1) Patches now based on 2.6.22-rc1 kernel.
Changes from Take1(initial post on 26th April, 2007) to Take2:
 1) Added description before sys_fallocate() definition.
 2) Return EINVAL for len<=0 (With new draft that Ulrich pointed to,
    posix_fallocate should return EINVAL for len <= 0.
 3) Return EOPNOTSUPP if mode is not one of FA_ALLOCATE or FA_DEALLOCATE
 4) Do not return ENODEV for dirs (let individual file systems decide if
    they want to support preallocation to directories or not.
 5) Check for wrap through zero.
 6) Update c/mtime if fallocate() succeeds.
 7) Added mode descriptions in fs.h
 8) Added variable names to function definition (fallocate inode op)

Here is the new patch:

Signed-off-by: Amit Arora <aarora@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/syscall_table.S |    1 
 arch/powerpc/kernel/sys_ppc32.c  |    7 ++
 arch/x86_64/ia32/ia32entry.S     |    1 
 fs/open.c                        |   86 +++++++++++++++++++++++++++++
 include/asm-i386/unistd.h        |    3 -
 include/asm-powerpc/systbl.h     |    1 
 include/asm-powerpc/unistd.h     |    3 -
 include/asm-x86_64/unistd.h      |    2 
 include/linux/fs.h               |   13 ++++
 include/linux/syscalls.h         |    1 
 10 files changed, 116 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/syscall_table.S~fallocate-implementation-on-i86-x86_64-and-powerpc arch/i386/kernel/syscall_table.S
--- a/arch/i386/kernel/syscall_table.S~fallocate-implementation-on-i86-x86_64-and-powerpc
+++ a/arch/i386/kernel/syscall_table.S
@@ -325,3 +325,4 @@ ENTRY(sys_call_table)
 	.long sys_eventfd
 	.long sys_revokeat
 	.long sys_frevoke		/* 325 */
+	.long sys_fallocate
diff -puN arch/powerpc/kernel/sys_ppc32.c~fallocate-implementation-on-i86-x86_64-and-powerpc arch/powerpc/kernel/sys_ppc32.c
--- a/arch/powerpc/kernel/sys_ppc32.c~fallocate-implementation-on-i86-x86_64-and-powerpc
+++ a/arch/powerpc/kernel/sys_ppc32.c
@@ -773,6 +773,13 @@ asmlinkage int compat_sys_truncate64(con
 	return sys_truncate(path, (high << 32) | low);
 }
 
+asmlinkage long compat_sys_fallocate(int fd, int mode, u32 offhi, u32 offlo,
+				     u32 lenhi, u32 lenlo)
+{
+	return sys_fallocate(fd, mode, ((loff_t)offhi << 32) | offlo,
+			     ((loff_t)lenhi << 32) | lenlo);
+}
+
 asmlinkage int compat_sys_ftruncate64(unsigned int fd, u32 reg4, unsigned long high,
 				 unsigned long low)
 {
diff -puN arch/x86_64/ia32/ia32entry.S~fallocate-implementation-on-i86-x86_64-and-powerpc arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~fallocate-implementation-on-i86-x86_64-and-powerpc
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -721,4 +721,5 @@ ia32_sys_call_table:
 	.quad sys_eventfd
 	.quad sys_revokeat
 	.quad sys_frevoke		/* 325 */
+	.quad sys_fallocate
 ia32_syscall_end:
diff -puN fs/open.c~fallocate-implementation-on-i86-x86_64-and-powerpc fs/open.c
--- a/fs/open.c~fallocate-implementation-on-i86-x86_64-and-powerpc
+++ a/fs/open.c
@@ -353,6 +353,92 @@ asmlinkage long sys_ftruncate64(unsigned
 #endif
 
 /*
+ * sys_fallocate - preallocate blocks or free preallocated blocks
+ * @fd: the file descriptor
+ * @mode: mode specifies if fallocate should preallocate blocks OR free
+ *	  (unallocate) preallocated blocks. Currently only FA_ALLOCATE and
+ *	  FA_DEALLOCATE modes are supported.
+ * @offset: The offset within file, from where (un)allocation is being
+ *	    requested. It should not have a negative value.
+ * @len: The amount (in bytes) of space to be (un)allocated, from the offset.
+ *
+ * This system call, depending on the mode, preallocates or unallocates blocks
+ * for a file. The range of blocks depends on the value of offset and len
+ * arguments provided by the user/application. For FA_ALLOCATE mode, if this
+ * system call succeeds, subsequent writes to the file in the given range
+ * (specified by offset & len) should not fail - even if the file system
+ * later becomes full. Hence the preallocation done is persistent (valid
+ * even after reopen of the file and remount/reboot).
+ *
+ * It is expected that the ->fallocate() inode operation implemented by the
+ * individual file systems will update the file size and/or ctime/mtime
+ * depending on the mode and also on the success of the operation.
+ *
+ * Note: Incase the file system does not support preallocation,
+ * posix_fallocate() should fall back to the library implementation (i.e.
+ * allocating zero-filled new blocks to the file).
+ *
+ * Return Values
+ *	0	: On SUCCESS a value of zero is returned.
+ *	error	: On Failure, an error code will be returned.
+ * An error code of -ENOSYS or -EOPNOTSUPP should make posix_fallocate()
+ * fall back on library implementation of fallocate.
+ *
+ * <TBD> Generic fallocate to be added for file systems that do not
+ *	 support fallocate it.
+ */
+asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
+{
+	struct file *file;
+	struct inode *inode;
+	long ret = -EINVAL;
+
+	if (offset < 0 || len <= 0)
+		goto out;
+
+	/* Return error if mode is not supported */
+	ret = -EOPNOTSUPP;
+	if (mode != FA_ALLOCATE && mode !=FA_DEALLOCATE)
+		goto out;
+
+	ret = -EBADF;
+	file = fget(fd);
+	if (!file)
+		goto out;
+	if (!(file->f_mode & FMODE_WRITE))
+		goto out_fput;
+
+	inode = file->f_path.dentry->d_inode;
+
+	ret = -ESPIPE;
+	if (S_ISFIFO(inode->i_mode))
+		goto out_fput;
+
+	ret = -ENODEV;
+	/*
+	 * Let individual file system decide if it supports preallocation
+	 * for directories or not.
+	 */
+	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
+		goto out_fput;
+
+	ret = -EFBIG;
+	/* Check for wrap through zero too */
+	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
+		goto out_fput;
+
+	if (inode->i_op && inode->i_op->fallocate)
+		ret = inode->i_op->fallocate(inode, mode, offset, len);
+	else
+		ret = -ENOSYS;
+
+out_fput:
+	fput(file);
+out:
+	return ret;
+}
+
+/*
  * access() needs to use the real uid/gid, not the effective uid/gid.
  * We do this by temporarily clearing all FS-related capabilities and
  * switching the fsuid/fsgid around to the real ones.
diff -puN include/asm-i386/unistd.h~fallocate-implementation-on-i86-x86_64-and-powerpc include/asm-i386/unistd.h
--- a/include/asm-i386/unistd.h~fallocate-implementation-on-i86-x86_64-and-powerpc
+++ a/include/asm-i386/unistd.h
@@ -331,10 +331,11 @@
 #define __NR_eventfd		323
 #define __NR_revokeat		324
 #define __NR_frevoke		325
+#define __NR_fallocate		326
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 326
+#define NR_syscalls 327
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff -puN include/asm-powerpc/systbl.h~fallocate-implementation-on-i86-x86_64-and-powerpc include/asm-powerpc/systbl.h
--- a/include/asm-powerpc/systbl.h~fallocate-implementation-on-i86-x86_64-and-powerpc
+++ a/include/asm-powerpc/systbl.h
@@ -312,3 +312,4 @@ COMPAT_SYS_SPU(signalfd)
 COMPAT_SYS_SPU(timerfd)
 SYSCALL_SPU(eventfd)
 COMPAT_SYS_SPU(sync_file_range2)
+COMPAT_SYS(fallocate)
diff -puN include/asm-powerpc/unistd.h~fallocate-implementation-on-i86-x86_64-and-powerpc include/asm-powerpc/unistd.h
--- a/include/asm-powerpc/unistd.h~fallocate-implementation-on-i86-x86_64-and-powerpc
+++ a/include/asm-powerpc/unistd.h
@@ -331,10 +331,11 @@
 #define __NR_timerfd		306
 #define __NR_eventfd		307
 #define __NR_sync_file_range2	308
+#define __NR_fallocate		309
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		309
+#define __NR_syscalls		310
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff -puN include/asm-x86_64/unistd.h~fallocate-implementation-on-i86-x86_64-and-powerpc include/asm-x86_64/unistd.h
--- a/include/asm-x86_64/unistd.h~fallocate-implementation-on-i86-x86_64-and-powerpc
+++ a/include/asm-x86_64/unistd.h
@@ -630,6 +630,8 @@ __SYSCALL(__NR_signalfd, sys_signalfd)
 __SYSCALL(__NR_timerfd, sys_timerfd)
 #define __NR_eventfd		284
 __SYSCALL(__NR_eventfd, sys_eventfd)
+#define __NR_fallocate		284
+__SYSCALL(__NR_fallocate, sys_fallocate)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff -puN include/linux/fs.h~fallocate-implementation-on-i86-x86_64-and-powerpc include/linux/fs.h
--- a/include/linux/fs.h~fallocate-implementation-on-i86-x86_64-and-powerpc
+++ a/include/linux/fs.h
@@ -274,6 +274,17 @@ extern int dir_notify_enable;
 #define SYNC_FILE_RANGE_WRITE		2
 #define SYNC_FILE_RANGE_WAIT_AFTER	4
 
+/*
+ * sys_fallocate modes
+ * Currently sys_fallocate supports two modes:
+ * FA_ALLOCATE  : This is the preallocate mode, using which an application/user
+ *		  may request (pre)allocation of blocks.
+ * FA_DEALLOCATE: This is the deallocate mode, which can be used to free
+ *		  the preallocated blocks.
+ */
+#define FA_ALLOCATE	0x1
+#define FA_DEALLOCATE	0x2
+
 #ifdef __KERNEL__
 
 #include <linux/linkage.h>
@@ -1214,6 +1225,8 @@ struct inode_operations {
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
+	long (*fallocate)(struct inode *inode, int mode, loff_t offset,
+			  loff_t len);
 };
 
 struct seq_file;
diff -puN include/linux/syscalls.h~fallocate-implementation-on-i86-x86_64-and-powerpc include/linux/syscalls.h
--- a/include/linux/syscalls.h~fallocate-implementation-on-i86-x86_64-and-powerpc
+++ a/include/linux/syscalls.h
@@ -610,6 +610,7 @@ asmlinkage long sys_signalfd(int ufd, si
 asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
 			    const struct itimerspec __user *utmr);
 asmlinkage long sys_eventfd(unsigned int count);
+asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
_

Patches currently in -mm which might be from aarora@linux.vnet.ibm.com are

fallocate-implementation-on-i86-x86_64-and-powerpc.patch
