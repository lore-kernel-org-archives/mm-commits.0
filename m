From: akpm@linux-foundation.org
Subject: + flag-parameters-dup2.patch added to -mm tree
Date: Wed, 07 May 2008 15:05:50 -0700
Message-ID: <200805072205.m47M5oR8018849__16608.8147474968$1210198054$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759257AbYEGWGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 18:06:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, davidel@xmailserver.org, linux-arch@vger.kernel.org, mtk.manpages@googlemail.com


The patch titled
     flag parameters: dup2
has been added to the -mm tree.  Its filename is
     flag-parameters-dup2.patch

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
Subject: flag parameters: dup2
From: Ulrich Drepper <drepper@redhat.com>

This patch adds the new dup3 syscall.  It extends the old dup2 syscall by one
parameter which is meant to hold a flag value.  Support for the O_CLOEXEC flag
is added in this patch.

The following test must be adjusted for architectures other than x86 and
x86-64 and in case the syscall numbers changed.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <sys/syscall.h>

#ifndef __NR_dup3
# ifdef __x86_64__
#  define __NR_dup3 292
# elif defined __i386__
#  define __NR_dup3 330
# else
#  error "need __NR_dup3"
# endif
#endif

int
main (void)
{
  int fd = syscall (__NR_dup3, 1, 4, 0);
  if (fd == -1)
    {
      puts ("dup3(0) failed");
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
      puts ("dup3(0) set close-on-exec flag");
      return 1;
    }
  close (fd);

  fd = syscall (__NR_dup3, 1, 4, O_CLOEXEC);
  if (fd == -1)
    {
      puts ("dup3(O_CLOEXEC) failed");
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
      puts ("dup3(O_CLOEXEC) set close-on-exec flag");
      return 1;
    }
  close (fd);

  puts ("OK");

  return 0;
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/kernel/syscall_table_32.S |    1 +
 fs/fcntl.c                         |   15 +++++++++++++--
 include/asm-x86/unistd_32.h        |    1 +
 include/asm-x86/unistd_64.h        |    2 ++
 include/linux/syscalls.h           |    1 +
 6 files changed, 19 insertions(+), 2 deletions(-)

diff -puN arch/x86/ia32/ia32entry.S~flag-parameters-dup2 arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~flag-parameters-dup2
+++ a/arch/x86/ia32/ia32entry.S
@@ -734,4 +734,5 @@ ia32_sys_call_table:
 	.quad compat_sys_signalfd4
 	.quad sys_eventfd2
 	.quad sys_epoll_create2
+	.quad sys_dup3			/* 330 */
 ia32_syscall_end:
diff -puN arch/x86/kernel/syscall_table_32.S~flag-parameters-dup2 arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~flag-parameters-dup2
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -329,3 +329,4 @@ ENTRY(sys_call_table)
 	.long sys_signalfd4
 	.long sys_eventfd2
 	.long sys_epoll_create2
+	.long sys_dup3			/* 330 */
diff -puN fs/fcntl.c~flag-parameters-dup2 fs/fcntl.c
--- a/fs/fcntl.c~flag-parameters-dup2
+++ a/fs/fcntl.c
@@ -126,13 +126,16 @@ static int dupfd(struct file *file, unsi
 	return fd;
 }
 
-asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd)
+asmlinkage long sys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 {
 	int err = -EBADF;
 	struct file * file, *tofree;
 	struct files_struct * files = current->files;
 	struct fdtable *fdt;
 
+	if ((flags & ~O_CLOEXEC) != 0)
+		return -EINVAL;
+
 	spin_lock(&files->file_lock);
 	if (!(file = fcheck(oldfd)))
 		goto out_unlock;
@@ -164,7 +167,10 @@ asmlinkage long sys_dup2(unsigned int ol
 
 	rcu_assign_pointer(fdt->fd[newfd], file);
 	FD_SET(newfd, fdt->open_fds);
-	FD_CLR(newfd, fdt->close_on_exec);
+	if (flags & O_CLOEXEC)
+		FD_SET(newfd, fdt->close_on_exec);
+	else
+		FD_CLR(newfd, fdt->close_on_exec);
 	spin_unlock(&files->file_lock);
 
 	if (tofree)
@@ -182,6 +188,11 @@ out_fput:
 	goto out;
 }
 
+asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd)
+{
+	return sys_dup3(oldfd, newfd, 0);
+}
+
 asmlinkage long sys_dup(unsigned int fildes)
 {
 	int ret = -EBADF;
diff -puN include/asm-x86/unistd_32.h~flag-parameters-dup2 include/asm-x86/unistd_32.h
--- a/include/asm-x86/unistd_32.h~flag-parameters-dup2
+++ a/include/asm-x86/unistd_32.h
@@ -335,6 +335,7 @@
 #define __NR_signalfd4		327
 #define __NR_eventfd2		328
 #define __NR_epoll_create2	329
+#define __NR_dup3		330
 
 #ifdef __KERNEL__
 
diff -puN include/asm-x86/unistd_64.h~flag-parameters-dup2 include/asm-x86/unistd_64.h
--- a/include/asm-x86/unistd_64.h~flag-parameters-dup2
+++ a/include/asm-x86/unistd_64.h
@@ -647,6 +647,8 @@ __SYSCALL(__NR_signalfd4, sys_signalfd4)
 __SYSCALL(__NR_eventfd2, sys_eventfd2)
 #define __NR_epoll_create2			291
 __SYSCALL(__NR_epoll_create2, sys_epoll_create2)
+#define __NR_dup3				292
+__SYSCALL(__NR_dup3, sys_dup3)
 
 
 #ifndef __NO_STUBS
diff -puN include/linux/syscalls.h~flag-parameters-dup2 include/linux/syscalls.h
--- a/include/linux/syscalls.h~flag-parameters-dup2
+++ a/include/linux/syscalls.h
@@ -305,6 +305,7 @@ asmlinkage long sys_fcntl64(unsigned int
 #endif
 asmlinkage long sys_dup(unsigned int fildes);
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd);
+asmlinkage long sys_dup3(unsigned int oldfd, unsigned int newfd, int flags);
 asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int on);
 asmlinkage long sys_ioctl(unsigned int fd, unsigned int cmd,
 				unsigned long arg);
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
sys_pipe-fix-file-descriptor-leaks.patch
execve-filename-document-and-export-via-auxiliary-vector.patch
flag-parameters-socket-and-socketpair.patch
flag-parameters-paccept.patch
flag-parameters-anon_inode_getfd-extension.patch
flag-parameters-signalfd.patch
flag-parameters-eventfd.patch
flag-parameters-timerfd_create.patch
flag-parameters-epoll_create.patch
flag-parameters-dup2.patch
flag-parameters-pipe.patch
flag-parameters-inotify_init.patch
flag-parametersi-nonblock-in-anon_inode_getfd.patch
flag-parameters-nonblock-in-socket-and-socketpair.patch
flag-parameters-nonblock-in-signalfd.patch
flag-parameters-nonblock-in-eventfd.patch
flag-parameters-nonblock-in-timerfd_create.patch
flag-parameters-nonblock-in-pipe.patch
flag-parameters-nonblock-in-inotify_init.patch
flag-parameters-check-magic-constants.patch

