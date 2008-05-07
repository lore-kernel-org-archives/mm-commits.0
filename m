From: akpm@linux-foundation.org
Subject: + flag-parameters-signalfd.patch added to -mm tree
Date: Wed, 07 May 2008 15:05:39 -0700
Message-ID: <200805072205.m47M5dh3018837__4602.39088065482$1210198072$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760423AbYEGWGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 18:06:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, davidel@xmailserver.org, linux-arch@vger.kernel.org, mtk.manpages@googlemail.com


The patch titled
     flag parameters: signalfd
has been added to the -mm tree.  Its filename is
     flag-parameters-signalfd.patch

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
Subject: flag parameters: signalfd
From: Ulrich Drepper <drepper@redhat.com>

This patch adds the new signalfd4 syscall.  It extends the old signalfd
syscall by one parameter which is meant to hold a flag value.  In this
patch the only flag support is SFD_CLOEXEC which causes the close-on-exec
flag for the returned file descriptor to be set.

A new name SFD_CLOEXEC is introduced which in this implementation must
have the same value as O_CLOEXEC.

The following test must be adjusted for architectures other than x86 and
x86-64 and in case the syscall numbers changed.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>

#ifndef __NR_signalfd4
# ifdef __x86_64__
#  define __NR_signalfd4 289
# elif defined __i386__
#  define __NR_signalfd4 327
# else
#  error "need __NR_signalfd4"
# endif
#endif

#define SFD_CLOEXEC O_CLOEXEC

int
main (void)
{
  sigset_t ss;
  sigemptyset (&ss);
  sigaddset (&ss, SIGUSR1);
  int fd = syscall (__NR_signalfd4, -1, &ss, 8, 0);
  if (fd == -1)
    {
      puts ("signalfd4(0) failed");
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
      puts ("signalfd4(0) set close-on-exec flag");
      return 1;
    }
  close (fd);

  fd = syscall (__NR_signalfd4, -1, &ss, 8, SFD_CLOEXEC);
  if (fd == -1)
    {
      puts ("signalfd4(SFD_CLOEXEC) failed");
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
      puts ("signalfd4(SFD_CLOEXEC) does not set close-on-exec flag");
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
 fs/compat.c                        |   14 ++++++++++----
 fs/signalfd.c                      |   14 ++++++++++++--
 include/asm-x86/unistd_32.h        |    1 +
 include/asm-x86/unistd_64.h        |    2 ++
 include/linux/signalfd.h           |    5 +++++
 include/linux/syscalls.h           |    1 +
 8 files changed, 33 insertions(+), 6 deletions(-)

diff -puN arch/x86/ia32/ia32entry.S~flag-parameters-signalfd arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~flag-parameters-signalfd
+++ a/arch/x86/ia32/ia32entry.S
@@ -731,4 +731,5 @@ ia32_sys_call_table:
 	.quad sys32_fallocate
 	.quad compat_sys_timerfd_settime	/* 325 */
 	.quad compat_sys_timerfd_gettime
+	.quad compat_sys_signalfd4
 ia32_syscall_end:
diff -puN arch/x86/kernel/syscall_table_32.S~flag-parameters-signalfd arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~flag-parameters-signalfd
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -326,3 +326,4 @@ ENTRY(sys_call_table)
 	.long sys_fallocate
 	.long sys_timerfd_settime	/* 325 */
 	.long sys_timerfd_gettime
+	.long sys_signalfd4
diff -puN fs/compat.c~flag-parameters-signalfd fs/compat.c
--- a/fs/compat.c~flag-parameters-signalfd
+++ a/fs/compat.c
@@ -2133,9 +2133,9 @@ asmlinkage long compat_sys_epoll_pwait(i
 
 #ifdef CONFIG_SIGNALFD
 
-asmlinkage long compat_sys_signalfd(int ufd,
-				    const compat_sigset_t __user *sigmask,
-				    compat_size_t sigsetsize)
+asmlinkage long compat_sys_signalfd4(int ufd,
+				     const compat_sigset_t __user *sigmask,
+				     compat_size_t sigsetsize, int flags)
 {
 	compat_sigset_t ss32;
 	sigset_t tmp;
@@ -2150,9 +2150,15 @@ asmlinkage long compat_sys_signalfd(int 
 	if (copy_to_user(ksigmask, &tmp, sizeof(sigset_t)))
 		return -EFAULT;
 
-	return sys_signalfd(ufd, ksigmask, sizeof(sigset_t));
+	return sys_signalfd4(ufd, ksigmask, sizeof(sigset_t), flags);
 }
 
+asmlinkage long compat_sys_signalfd(int ufd,
+				    const compat_sigset_t __user *sigmask,
+				    compat_size_t sigsetsize)
+{
+	return compat_sys_signalfd4(ufd, sigmask, sigsetsize, 0);
+}
 #endif /* CONFIG_SIGNALFD */
 
 #ifdef CONFIG_TIMERFD
diff -puN fs/signalfd.c~flag-parameters-signalfd fs/signalfd.c
--- a/fs/signalfd.c~flag-parameters-signalfd
+++ a/fs/signalfd.c
@@ -205,11 +205,15 @@ static const struct file_operations sign
 	.read		= signalfd_read,
 };
 
-asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask)
+asmlinkage long sys_signalfd4(int ufd, sigset_t __user *user_mask,
+			      size_t sizemask, int flags)
 {
 	sigset_t sigmask;
 	struct signalfd_ctx *ctx;
 
+	if (flags & ~SFD_CLOEXEC)
+		return -EINVAL;
+
 	if (sizemask != sizeof(sigset_t) ||
 	    copy_from_user(&sigmask, user_mask, sizeof(sigmask)))
 		return -EINVAL;
@@ -228,7 +232,7 @@ asmlinkage long sys_signalfd(int ufd, si
 		 * anon_inode_getfd() will install the fd.
 		 */
 		ufd = anon_inode_getfd("[signalfd]", &signalfd_fops, ctx,
-				       0);
+				       flags & O_CLOEXEC);
 		if (ufd < 0)
 			kfree(ctx);
 	} else {
@@ -250,3 +254,9 @@ asmlinkage long sys_signalfd(int ufd, si
 
 	return ufd;
 }
+
+asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask,
+			     size_t sizemask)
+{
+	return sys_signalfd4(ufd, user_mask, sizemask, 0);
+}
diff -puN include/asm-x86/unistd_32.h~flag-parameters-signalfd include/asm-x86/unistd_32.h
--- a/include/asm-x86/unistd_32.h~flag-parameters-signalfd
+++ a/include/asm-x86/unistd_32.h
@@ -332,6 +332,7 @@
 #define __NR_fallocate		324
 #define __NR_timerfd_settime	325
 #define __NR_timerfd_gettime	326
+#define __NR_signalfd4		327
 
 #ifdef __KERNEL__
 
diff -puN include/asm-x86/unistd_64.h~flag-parameters-signalfd include/asm-x86/unistd_64.h
--- a/include/asm-x86/unistd_64.h~flag-parameters-signalfd
+++ a/include/asm-x86/unistd_64.h
@@ -641,6 +641,8 @@ __SYSCALL(__NR_timerfd_settime, sys_time
 __SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
 #define __NR_paccept				288
 __SYSCALL(__NR_paccept, sys_paccept)
+#define __NR_signalfd4				289
+__SYSCALL(__NR_signalfd4, sys_signalfd4)
 
 
 #ifndef __NO_STUBS
diff -puN include/linux/signalfd.h~flag-parameters-signalfd include/linux/signalfd.h
--- a/include/linux/signalfd.h~flag-parameters-signalfd
+++ a/include/linux/signalfd.h
@@ -8,6 +8,11 @@
 #ifndef _LINUX_SIGNALFD_H
 #define _LINUX_SIGNALFD_H
 
+/* For O_CLOEXEC */
+#include <linux/fcntl.h>
+
+/* Flags for signalfd4.  */
+#define SFD_CLOEXEC O_CLOEXEC
 
 struct signalfd_siginfo {
 	__u32 ssi_signo;
diff -puN include/linux/syscalls.h~flag-parameters-signalfd include/linux/syscalls.h
--- a/include/linux/syscalls.h~flag-parameters-signalfd
+++ a/include/linux/syscalls.h
@@ -610,6 +610,7 @@ asmlinkage long sys_set_robust_list(stru
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
 asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask);
+asmlinkage long sys_signalfd4(int ufd, sigset_t __user *user_mask, size_t sizemask, int flags);
 asmlinkage long sys_timerfd_create(int clockid, int flags);
 asmlinkage long sys_timerfd_settime(int ufd, int flags,
 				    const struct itimerspec __user *utmr,
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

