From: akpm@linux-foundation.org
Subject: + init-add-sys-wrapperh.patch added to -mm tree
Date: Fri, 17 Sep 2010 14:40:33 -0700
Message-ID: <201009172140.o8HLeXux011486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946Ab0IQVlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 17:41:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, arnd@arndb.de, phillip@lougher.demon.co.uk, sam@ravnborg.org, viro@zeniv.linux.org.uk


The patch titled
     init: add sys-wrapper.h
has been added to the -mm tree.  Its filename is
     init-add-sys-wrapperh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init: add sys-wrapper.h
From: Namhyung Kim <namhyung@gmail.com>

This patchset tries to cleanup init/initramfs code especially for syscall
invocation which produces many warnings from sparse because of address
space change. This can be done by wrapping each syscall invocation and
doing such conversions in it using kernel_sys_call() macro suggested by
Arnd Bergmann.


This patch:

sys-wrapper.h contains wrapper functions for various syscalls used in init
code.  These wrappers handle proper address space conversion so that we
can remove a lot of warnings from sparse.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/sys-wrapper.h |  216 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 216 insertions(+)

diff -puN /dev/null init/sys-wrapper.h
--- /dev/null
+++ a/init/sys-wrapper.h
@@ -0,0 +1,216 @@
+/*
+ * wrappers for various syscalls for use in the init code
+ *
+ * Copyright (C) 2010  Namhyung Kim <namhyung@gmail.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <linux/dirent.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+
+
+#define kernel_sys_call(call, ...)		\
+({						\
+	long result;				\
+	mm_segment_t old_fs = get_fs();		\
+	set_fs(KERNEL_DS);			\
+	result = call(__VA_ARGS__);		\
+	set_fs(old_fs);				\
+	result;					\
+})
+
+static inline int kernel_sys_mount(char *dev_name, char *dir_name, char *type,
+				   unsigned long flags, void *data)
+{
+	return kernel_sys_call(sys_mount,
+			       (char __user __force *) dev_name,
+			       (char __user __force *) dir_name,
+			       (char __user __force *) type,
+			       flags,
+			       (void __user __force *) data);
+}
+
+static inline int kernel_sys_umount(char *name, int flags)
+{
+	return kernel_sys_call(sys_umount,
+			       (char __user __force *) name, flags);
+}
+
+static inline int kernel_sys_chroot(const char *pathname)
+{
+	return kernel_sys_call(sys_chroot,
+			       (const char __user __force *) pathname);
+}
+
+static inline int kernel_sys_link(const char *oldname, const char *newname)
+{
+	return kernel_sys_call(sys_link,
+			       (const char __user __force *) oldname,
+			       (const char __user __force *) newname);
+}
+
+static inline int kernel_sys_unlink(const char *pathname)
+{
+	return kernel_sys_call(sys_unlink,
+			       (const char __user __force *) pathname);
+}
+
+static inline int kernel_sys_newlstat(const char *filename,
+				      struct stat *statbuf)
+{
+	return kernel_sys_call(sys_newlstat,
+			       (const char __user __force *) filename,
+			       (struct stat __user __force *) statbuf);
+}
+
+static inline int kernel_sys_mkdir(const char *pathname, int mode)
+{
+	return kernel_sys_call(sys_mkdir,
+			       (const char __user __force *) pathname, mode);
+}
+
+static inline int kernel_sys_rmdir(const char *pathname)
+{
+	return kernel_sys_call(sys_rmdir,
+			       (const char __user __force *) pathname);
+}
+
+static inline int kernel_sys_chdir(const char *pathname)
+{
+	return kernel_sys_call(sys_chdir,
+			       (const char __user __force *) pathname);
+}
+
+static inline int kernel_sys_mknod(const char *filename,
+				   int mode, unsigned dev)
+{
+	return kernel_sys_call(sys_mknod,
+			       (const char __user __force *) filename,
+			       mode, dev);
+}
+
+static inline int kernel_sys_chown(const char *filename,
+				   uid_t user, gid_t group)
+{
+	return kernel_sys_call(sys_chown,
+			       (const char __user __force *) filename,
+			       user, group);
+}
+
+static inline int kernel_sys_chmod(const char *filename, mode_t mode)
+{
+	return kernel_sys_call(sys_chmod,
+			       (const char __user __force *) filename, mode);
+}
+
+static inline int kernel_sys_open(const char *filename, int flags, int mode)
+{
+	return kernel_sys_call(sys_open,
+			       (const char __user __force *) filename,
+			       flags, mode);
+}
+
+static inline int kernel_sys_fchown(unsigned int fd, uid_t user, gid_t group)
+{
+	return sys_fchown(fd, user, group);
+}
+
+static inline int kernel_sys_fchmod(unsigned int fd, mode_t mode)
+{
+	return sys_fchmod(fd, mode);
+}
+
+static inline int kernel_sys_fchdir(unsigned int fd)
+{
+	return sys_fchdir(fd);
+}
+
+static inline int kernel_sys_ftruncate(unsigned int fd, unsigned long length)
+{
+	return sys_ftruncate(fd, length);
+}
+
+static inline int kernel_sys_read(unsigned int fd, char *buf, size_t count)
+{
+	return kernel_sys_call(sys_read,
+			       fd, (char __user __force *) buf, count);
+}
+
+static inline int kernel_sys_write(unsigned int fd, const char *buf,
+				   size_t count)
+{
+	return kernel_sys_call(sys_write,
+			       fd, (const char __user __force *) buf, count);
+}
+
+static inline int kernel_sys_lseek(unsigned int fd, off_t offset,
+				   unsigned int origin)
+{
+	return sys_lseek(fd, offset, origin);
+}
+
+static inline int kernel_sys_ioctl(unsigned int fd, unsigned int cmd,
+				   unsigned long arg)
+{
+	return sys_ioctl(fd, cmd, arg);
+}
+
+static inline int kernel_sys_dup(unsigned int fd)
+{
+	return sys_dup(fd);
+}
+
+static inline int kernel_sys_close(unsigned int fd)
+{
+	return sys_close(fd);
+}
+
+static inline int kernel_sys_symlink(const char *oldname, const char *newname)
+{
+	return kernel_sys_call(sys_symlink,
+			       (const char __user __force *) oldname,
+			       (const char __user __force *) newname);
+}
+
+static inline int kernel_sys_lchown(const char *filename, uid_t user,
+				    gid_t group)
+{
+	return kernel_sys_call(sys_lchown,
+			       (const char __user __force *) filename,
+			       user, group);
+}
+
+static inline int kernel_sys_getdents64(unsigned int fd,
+					struct linux_dirent64 *dirent,
+					unsigned int count)
+{
+	return kernel_sys_call(sys_getdents64,
+			       fd,
+			       (struct linux_dirent64 __user __force *) dirent,
+			       count);
+}
+
+static inline int kernel_sys_access(const char *filename, int mode)
+{
+	return kernel_sys_call(sys_access,
+			       (const char __user __force *) filename, mode);
+}
+
+static inline int kernel_sys_setsid(void)
+{
+	return sys_setsid();
+}
+
+static inline int kernel_sys_wait4(pid_t upid, int *stat_addr, int options,
+				   struct rusage *ru)
+{
+	return kernel_sys_call(sys_wait4,
+			       upid,
+			       (int __user __force *) stat_addr,
+			       options,
+			       (struct rusage __user __force *) ru);
+}
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
init-mark-__user-address-space-on-string-literals.patch
init-add-sys-wrapperh.patch
init-use-kernel_sys_-wrappers-instead-of-syscall.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

