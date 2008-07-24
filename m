From: akpm@linux-foundation.org
Subject: - flag-parameters-eventfd.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:27:20 -0700
Message-ID: <200807242327.m6ONRKOP011157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756674AbYGXX3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, davidel@xmailserver.org, linux-arch@vger.kernel.org, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     flag parameters: eventfd
has been removed from the -mm tree.  Its filename was
     flag-parameters-eventfd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flag parameters: eventfd
From: Ulrich Drepper <drepper@redhat.com>

This patch adds the new eventfd2 syscall.  It extends the old eventfd
syscall by one parameter which is meant to hold a flag value.  In this
patch the only flag support is EFD_CLOEXEC which causes the close-on-exec
flag for the returned file descriptor to be set.

A new name EFD_CLOEXEC is introduced which in this implementation must
have the same value as O_CLOEXEC.

The following test must be adjusted for architectures other than x86 and
x86-64 and in case the syscall numbers changed.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>

#ifndef __NR_eventfd2
# ifdef __x86_64__
#  define __NR_eventfd2 290
# elif defined __i386__
#  define __NR_eventfd2 328
# else
#  error "need __NR_eventfd2"
# endif
#endif

#define EFD_CLOEXEC O_CLOEXEC

int
main (void)
{
  int fd = syscall (__NR_eventfd2, 1, 0);
  if (fd == -1)
    {
      puts ("eventfd2(0) failed");
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
      puts ("eventfd2(0) sets close-on-exec flag");
      return 1;
    }
  close (fd);

  fd = syscall (__NR_eventfd2, 1, EFD_CLOEXEC);
  if (fd == -1)
    {
      puts ("eventfd2(EFD_CLOEXEC) failed");
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
      puts ("eventfd2(EFD_CLOEXEC) does not set close-on-exec flag");
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
 fs/eventfd.c                       |   13 +++++++++++--
 include/asm-x86/unistd_32.h        |    1 +
 include/asm-x86/unistd_64.h        |    2 ++
 include/linux/eventfd.h            |    6 ++++++
 include/linux/syscalls.h           |    1 +
 kernel/sys_ni.c                    |    1 +
 8 files changed, 24 insertions(+), 2 deletions(-)

diff -puN arch/x86/ia32/ia32entry.S~flag-parameters-eventfd arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~flag-parameters-eventfd
+++ a/arch/x86/ia32/ia32entry.S
@@ -744,4 +744,5 @@ ia32_sys_call_table:
 	.quad compat_sys_timerfd_settime	/* 325 */
 	.quad compat_sys_timerfd_gettime
 	.quad compat_sys_signalfd4
+	.quad sys_eventfd2
 ia32_syscall_end:
diff -puN arch/x86/kernel/syscall_table_32.S~flag-parameters-eventfd arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~flag-parameters-eventfd
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -327,3 +327,4 @@ ENTRY(sys_call_table)
 	.long sys_timerfd_settime	/* 325 */
 	.long sys_timerfd_gettime
 	.long sys_signalfd4
+	.long sys_eventfd2
diff -puN fs/eventfd.c~flag-parameters-eventfd fs/eventfd.c
--- a/fs/eventfd.c~flag-parameters-eventfd
+++ a/fs/eventfd.c
@@ -198,11 +198,14 @@ struct file *eventfd_fget(int fd)
 	return file;
 }
 
-asmlinkage long sys_eventfd(unsigned int count)
+asmlinkage long sys_eventfd2(unsigned int count, int flags)
 {
 	int fd;
 	struct eventfd_ctx *ctx;
 
+	if (flags & ~EFD_CLOEXEC)
+		return -EINVAL;
+
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
@@ -214,9 +217,15 @@ asmlinkage long sys_eventfd(unsigned int
 	 * When we call this, the initialization must be complete, since
 	 * anon_inode_getfd() will install the fd.
 	 */
-	fd = anon_inode_getfd("[eventfd]", &eventfd_fops, ctx, 0);
+	fd = anon_inode_getfd("[eventfd]", &eventfd_fops, ctx,
+			      flags & O_CLOEXEC);
 	if (fd < 0)
 		kfree(ctx);
 	return fd;
 }
 
+asmlinkage long sys_eventfd(unsigned int count)
+{
+	return sys_eventfd2(count, 0);
+}
+
diff -puN include/asm-x86/unistd_32.h~flag-parameters-eventfd include/asm-x86/unistd_32.h
--- a/include/asm-x86/unistd_32.h~flag-parameters-eventfd
+++ a/include/asm-x86/unistd_32.h
@@ -333,6 +333,7 @@
 #define __NR_timerfd_settime	325
 #define __NR_timerfd_gettime	326
 #define __NR_signalfd4		327
+#define __NR_eventfd2		328
 
 #ifdef __KERNEL__
 
diff -puN include/asm-x86/unistd_64.h~flag-parameters-eventfd include/asm-x86/unistd_64.h
--- a/include/asm-x86/unistd_64.h~flag-parameters-eventfd
+++ a/include/asm-x86/unistd_64.h
@@ -643,6 +643,8 @@ __SYSCALL(__NR_timerfd_gettime, sys_time
 __SYSCALL(__NR_paccept, sys_paccept)
 #define __NR_signalfd4				289
 __SYSCALL(__NR_signalfd4, sys_signalfd4)
+#define __NR_eventfd2				290
+__SYSCALL(__NR_eventfd2, sys_eventfd2)
 
 
 #ifndef __NO_STUBS
diff -puN include/linux/eventfd.h~flag-parameters-eventfd include/linux/eventfd.h
--- a/include/linux/eventfd.h~flag-parameters-eventfd
+++ a/include/linux/eventfd.h
@@ -10,6 +10,12 @@
 
 #ifdef CONFIG_EVENTFD
 
+/* For O_CLOEXEC */
+#include <linux/fcntl.h>
+
+/* Flags for eventfd2.  */
+#define EFD_CLOEXEC O_CLOEXEC
+
 struct file *eventfd_fget(int fd);
 int eventfd_signal(struct file *file, int n);
 
diff -puN include/linux/syscalls.h~flag-parameters-eventfd include/linux/syscalls.h
--- a/include/linux/syscalls.h~flag-parameters-eventfd
+++ a/include/linux/syscalls.h
@@ -617,6 +617,7 @@ asmlinkage long sys_timerfd_settime(int 
 				    struct itimerspec __user *otmr);
 asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr);
 asmlinkage long sys_eventfd(unsigned int count);
+asmlinkage long sys_eventfd2(unsigned int count, int flags);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
diff -puN kernel/sys_ni.c~flag-parameters-eventfd kernel/sys_ni.c
--- a/kernel/sys_ni.c~flag-parameters-eventfd
+++ a/kernel/sys_ni.c
@@ -164,3 +164,4 @@ cond_syscall(sys_timerfd_gettime);
 cond_syscall(compat_sys_timerfd_settime);
 cond_syscall(compat_sys_timerfd_gettime);
 cond_syscall(sys_eventfd);
+cond_syscall(sys_eventfd2);
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
linux-next.patch

