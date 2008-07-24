From: akpm@linux-foundation.org
Subject: - flag-parameters-inotify_init.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:27:35 -0700
Message-ID: <200807242327.m6ONRZ9M011172__42680.4562951022$1216942453$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756734AbYGXX3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, davidel@xmailserver.org, linux-arch@vger.kernel.org, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     flag parameters: inotify_init
has been removed from the -mm tree.  Its filename was
     flag-parameters-inotify_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flag parameters: inotify_init
From: Ulrich Drepper <drepper@redhat.com>

This patch introduces the new syscall inotify_init1 (note: the 1 stands for
the one parameter the syscall takes, as opposed to no parameter before).  The
values accepted for this parameter are function-specific and defined in the
inotify.h header.  Here the values must match the O_* flags, though.  In this
patch CLOEXEC support is introduced.

The following test must be adjusted for architectures other than x86 and
x86-64 and in case the syscall numbers changed.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>

#ifndef __NR_inotify_init1
# ifdef __x86_64__
#  define __NR_inotify_init1 294
# elif defined __i386__
#  define __NR_inotify_init1 332
# else
#  error "need __NR_inotify_init1"
# endif
#endif

#define IN_CLOEXEC O_CLOEXEC

int
main (void)
{
  int fd;
  fd = syscall (__NR_inotify_init1, 0);
  if (fd == -1)
    {
      puts ("inotify_init1(0) failed");
      return 1;
    }
  int coe = fcntl (fd, F_GETFD);
  if (coe == -1)
    {
      puts ("fcntl failed");
      return 1;
    }
  if (coe & FD_CLOEXEC)
    {
      puts ("inotify_init1(0) set close-on-exit");
      return 1;
    }
  close (fd);

  fd = syscall (__NR_inotify_init1, IN_CLOEXEC);
  if (fd == -1)
    {
      puts ("inotify_init1(IN_CLOEXEC) failed");
      return 1;
    }
  coe = fcntl (fd, F_GETFD);
  if (coe == -1)
    {
      puts ("fcntl failed");
      return 1;
    }
  if ((coe & FD_CLOEXEC) == 0)
    {
      puts ("inotify_init1(O_CLOEXEC) does not set close-on-exit");
      return 1;
    }
  close (fd);

  puts ("OK");

  return 0;
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[akpm@linux-foundation.org: add sys_ni stub]
Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/kernel/syscall_table_32.S |    1 +
 fs/inotify_user.c                  |   12 ++++++++++--
 include/asm-x86/unistd_32.h        |    1 +
 include/asm-x86/unistd_64.h        |    2 ++
 include/linux/inotify.h            |    5 +++++
 include/linux/syscalls.h           |    1 +
 kernel/sys_ni.c                    |    1 +
 8 files changed, 22 insertions(+), 2 deletions(-)

diff -puN arch/x86/ia32/ia32entry.S~flag-parameters-inotify_init arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~flag-parameters-inotify_init
+++ a/arch/x86/ia32/ia32entry.S
@@ -748,4 +748,5 @@ ia32_sys_call_table:
 	.quad sys_epoll_create2
 	.quad sys_dup3			/* 330 */
 	.quad sys_pipe2
+	.quad sys_inotify_init1
 ia32_syscall_end:
diff -puN arch/x86/kernel/syscall_table_32.S~flag-parameters-inotify_init arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~flag-parameters-inotify_init
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -331,3 +331,4 @@ ENTRY(sys_call_table)
 	.long sys_epoll_create2
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
+	.long sys_inotify_init1
diff -puN fs/inotify_user.c~flag-parameters-inotify_init fs/inotify_user.c
--- a/fs/inotify_user.c~flag-parameters-inotify_init
+++ a/fs/inotify_user.c
@@ -566,7 +566,7 @@ static const struct inotify_operations i
 	.destroy_watch	= free_inotify_user_watch,
 };
 
-asmlinkage long sys_inotify_init(void)
+asmlinkage long sys_inotify_init1(int flags)
 {
 	struct inotify_device *dev;
 	struct inotify_handle *ih;
@@ -574,7 +574,10 @@ asmlinkage long sys_inotify_init(void)
 	struct file *filp;
 	int fd, ret;
 
-	fd = get_unused_fd();
+	if (flags & ~IN_CLOEXEC)
+		return -EINVAL;
+
+	fd = get_unused_fd_flags(flags & O_CLOEXEC);
 	if (fd < 0)
 		return fd;
 
@@ -638,6 +641,11 @@ out_put_fd:
 	return ret;
 }
 
+asmlinkage long sys_inotify_init(void)
+{
+	return sys_inotify_init1(0);
+}
+
 asmlinkage long sys_inotify_add_watch(int fd, const char __user *path, u32 mask)
 {
 	struct inode *inode;
diff -puN include/asm-x86/unistd_32.h~flag-parameters-inotify_init include/asm-x86/unistd_32.h
--- a/include/asm-x86/unistd_32.h~flag-parameters-inotify_init
+++ a/include/asm-x86/unistd_32.h
@@ -337,6 +337,7 @@
 #define __NR_epoll_create2	329
 #define __NR_dup3		330
 #define __NR_pipe2		331
+#define __NR_inotify_init1	332
 
 #ifdef __KERNEL__
 
diff -puN include/asm-x86/unistd_64.h~flag-parameters-inotify_init include/asm-x86/unistd_64.h
--- a/include/asm-x86/unistd_64.h~flag-parameters-inotify_init
+++ a/include/asm-x86/unistd_64.h
@@ -651,6 +651,8 @@ __SYSCALL(__NR_epoll_create2, sys_epoll_
 __SYSCALL(__NR_dup3, sys_dup3)
 #define __NR_pipe2				293
 __SYSCALL(__NR_pipe2, sys_pipe2)
+#define __NR_inotify_init1			294
+__SYSCALL(__NR_inotify_init1, sys_inotify_init1)
 
 
 #ifndef __NO_STUBS
diff -puN include/linux/inotify.h~flag-parameters-inotify_init include/linux/inotify.h
--- a/include/linux/inotify.h~flag-parameters-inotify_init
+++ a/include/linux/inotify.h
@@ -7,6 +7,8 @@
 #ifndef _LINUX_INOTIFY_H
 #define _LINUX_INOTIFY_H
 
+/* For O_CLOEXEC */
+#include <linux/fcntl.h>
 #include <linux/types.h>
 
 /*
@@ -63,6 +65,9 @@ struct inotify_event {
 			 IN_MOVED_TO | IN_DELETE | IN_CREATE | IN_DELETE_SELF | \
 			 IN_MOVE_SELF)
 
+/* Flags for sys_inotify_init1.  */
+#define IN_CLOEXEC O_CLOEXEC
+
 #ifdef __KERNEL__
 
 #include <linux/dcache.h>
diff -puN include/linux/syscalls.h~flag-parameters-inotify_init include/linux/syscalls.h
--- a/include/linux/syscalls.h~flag-parameters-inotify_init
+++ a/include/linux/syscalls.h
@@ -547,6 +547,7 @@ asmlinkage long sys_get_mempolicy(int __
 				unsigned long addr, unsigned long flags);
 
 asmlinkage long sys_inotify_init(void);
+asmlinkage long sys_inotify_init1(int flags);
 asmlinkage long sys_inotify_add_watch(int fd, const char __user *path,
 					u32 mask);
 asmlinkage long sys_inotify_rm_watch(int fd, u32 wd);
diff -puN kernel/sys_ni.c~flag-parameters-inotify_init kernel/sys_ni.c
--- a/kernel/sys_ni.c~flag-parameters-inotify_init
+++ a/kernel/sys_ni.c
@@ -96,6 +96,7 @@ cond_syscall(sys_keyctl);
 cond_syscall(compat_sys_keyctl);
 cond_syscall(compat_sys_socketcall);
 cond_syscall(sys_inotify_init);
+cond_syscall(sys_inotify_init1);
 cond_syscall(sys_inotify_add_watch);
 cond_syscall(sys_inotify_rm_watch);
 cond_syscall(sys_migrate_pages);
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
linux-next.patch

