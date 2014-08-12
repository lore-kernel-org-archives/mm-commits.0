From: akpm@linux-foundation.org
Subject: [merged] shm-add-memfd_create-syscall.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:33 -0700
Message-ID: <53ea6e65.iJxROeQnDD/ywWG+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:33335 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbaHLTne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:34 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1923368obb.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dh.herrmann@gmail.com, desrt@desrt.ca, hughd@google.com, lennart@poettering.net, luto@amacapital.net, mtk.manpages@gmail.com, zonque@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shm: add memfd_create() syscall
has been removed from the -mm tree.  Its filename was
     shm-add-memfd_create-syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Herrmann <dh.herrmann@gmail.com>
Subject: shm: add memfd_create() syscall

memfd_create() is similar to mmap(MAP_ANON), but returns a file-descriptor
that you can pass to mmap().  It can support sealing and avoids any
connection to user-visible mount-points.  Thus, it's not subject to quotas
on mounted file-systems, but can be used like malloc()'ed memory, but with
a file-descriptor to it.

memfd_create() returns the raw shmem file, so calls like ftruncate() can
be used to modify the underlying inode.  Also calls like fstat() will
return proper information and mark the file as regular file.  If you want
sealing, you can specify MFD_ALLOW_SEALING.  Otherwise, sealing is not
supported (like on all other regular files).

Compared to O_TMPFILE, it does not require a tmpfs mount-point and is not
subject to a filesystem size limit.  It is still properly accounted to
memcg limits, though, and to the same overcommit or no-overcommit
accounting as all user memory.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ryan Lortie <desrt@desrt.ca>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Daniel Mack <zonque@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/syscalls/syscall_32.tbl |    1 
 arch/x86/syscalls/syscall_64.tbl |    1 
 include/linux/syscalls.h         |    1 
 include/uapi/linux/memfd.h       |    8 +++
 kernel/sys_ni.c                  |    1 
 mm/shmem.c                       |   73 +++++++++++++++++++++++++++++
 6 files changed, 85 insertions(+)

diff -puN arch/x86/syscalls/syscall_32.tbl~shm-add-memfd_create-syscall arch/x86/syscalls/syscall_32.tbl
--- a/arch/x86/syscalls/syscall_32.tbl~shm-add-memfd_create-syscall
+++ a/arch/x86/syscalls/syscall_32.tbl
@@ -362,3 +362,4 @@
 353	i386	renameat2		sys_renameat2
 354	i386	seccomp			sys_seccomp
 355	i386	getrandom		sys_getrandom
+356	i386	memfd_create		sys_memfd_create
diff -puN arch/x86/syscalls/syscall_64.tbl~shm-add-memfd_create-syscall arch/x86/syscalls/syscall_64.tbl
--- a/arch/x86/syscalls/syscall_64.tbl~shm-add-memfd_create-syscall
+++ a/arch/x86/syscalls/syscall_64.tbl
@@ -325,6 +325,7 @@
 316	common	renameat2		sys_renameat2
 317	common	seccomp			sys_seccomp
 318	common	getrandom		sys_getrandom
+319	common	memfd_create		sys_memfd_create
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff -puN include/linux/syscalls.h~shm-add-memfd_create-syscall include/linux/syscalls.h
--- a/include/linux/syscalls.h~shm-add-memfd_create-syscall
+++ a/include/linux/syscalls.h
@@ -802,6 +802,7 @@ asmlinkage long sys_timerfd_settime(int
 asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr);
 asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_eventfd2(unsigned int count, int flags);
+asmlinkage long sys_memfd_create(const char __user *uname_ptr, unsigned int flags);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 asmlinkage long sys_old_readdir(unsigned int, struct old_linux_dirent __user *, unsigned int);
 asmlinkage long sys_pselect6(int, fd_set __user *, fd_set __user *,
diff -puN /dev/null include/uapi/linux/memfd.h
--- /dev/null
+++ a/include/uapi/linux/memfd.h
@@ -0,0 +1,8 @@
+#ifndef _UAPI_LINUX_MEMFD_H
+#define _UAPI_LINUX_MEMFD_H
+
+/* flags for memfd_create(2) (unsigned int) */
+#define MFD_CLOEXEC		0x0001U
+#define MFD_ALLOW_SEALING	0x0002U
+
+#endif /* _UAPI_LINUX_MEMFD_H */
diff -puN kernel/sys_ni.c~shm-add-memfd_create-syscall kernel/sys_ni.c
--- a/kernel/sys_ni.c~shm-add-memfd_create-syscall
+++ a/kernel/sys_ni.c
@@ -197,6 +197,7 @@ cond_syscall(compat_sys_timerfd_settime)
 cond_syscall(compat_sys_timerfd_gettime);
 cond_syscall(sys_eventfd);
 cond_syscall(sys_eventfd2);
+cond_syscall(sys_memfd_create);
 
 /* performance counters: */
 cond_syscall(sys_perf_event_open);
diff -puN mm/shmem.c~shm-add-memfd_create-syscall mm/shmem.c
--- a/mm/shmem.c~shm-add-memfd_create-syscall
+++ a/mm/shmem.c
@@ -66,7 +66,9 @@ static struct vfsmount *shm_mnt;
 #include <linux/highmem.h>
 #include <linux/seq_file.h>
 #include <linux/magic.h>
+#include <linux/syscalls.h>
 #include <linux/fcntl.h>
+#include <uapi/linux/memfd.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -2732,6 +2734,77 @@ static int shmem_show_options(struct seq
 	shmem_show_mpol(seq, sbinfo->mpol);
 	return 0;
 }
+
+#define MFD_NAME_PREFIX "memfd:"
+#define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
+#define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
+
+#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING)
+
+SYSCALL_DEFINE2(memfd_create,
+		const char __user *, uname,
+		unsigned int, flags)
+{
+	struct shmem_inode_info *info;
+	struct file *file;
+	int fd, error;
+	char *name;
+	long len;
+
+	if (flags & ~(unsigned int)MFD_ALL_FLAGS)
+		return -EINVAL;
+
+	/* length includes terminating zero */
+	len = strnlen_user(uname, MFD_NAME_MAX_LEN + 1);
+	if (len <= 0)
+		return -EFAULT;
+	if (len > MFD_NAME_MAX_LEN + 1)
+		return -EINVAL;
+
+	name = kmalloc(len + MFD_NAME_PREFIX_LEN, GFP_TEMPORARY);
+	if (!name)
+		return -ENOMEM;
+
+	strcpy(name, MFD_NAME_PREFIX);
+	if (copy_from_user(&name[MFD_NAME_PREFIX_LEN], uname, len)) {
+		error = -EFAULT;
+		goto err_name;
+	}
+
+	/* terminating-zero may have changed after strnlen_user() returned */
+	if (name[len + MFD_NAME_PREFIX_LEN - 1]) {
+		error = -EFAULT;
+		goto err_name;
+	}
+
+	fd = get_unused_fd_flags((flags & MFD_CLOEXEC) ? O_CLOEXEC : 0);
+	if (fd < 0) {
+		error = fd;
+		goto err_name;
+	}
+
+	file = shmem_file_setup(name, 0, VM_NORESERVE);
+	if (IS_ERR(file)) {
+		error = PTR_ERR(file);
+		goto err_fd;
+	}
+	info = SHMEM_I(file_inode(file));
+	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
+	file->f_flags |= O_RDWR | O_LARGEFILE;
+	if (flags & MFD_ALLOW_SEALING)
+		info->seals &= ~F_SEAL_SEAL;
+
+	fd_install(fd, file);
+	kfree(name);
+	return fd;
+
+err_fd:
+	put_unused_fd(fd);
+err_name:
+	kfree(name);
+	return error;
+}
+
 #endif /* CONFIG_TMPFS */
 
 static void shmem_put_super(struct super_block *sb)
_

Patches currently in -mm which might be from dh.herrmann@gmail.com are

origin.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch

