From: akpm@linux-foundation.org
Subject: - flag-parameters-epoll_create.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:27:26 -0700
Message-ID: <200807242327.m6ONRQNE011163__12157.5687466704$1216942252$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756673AbYGXX3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, davidel@xmailserver.org, linux-arch@vger.kernel.org, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     flag parameters: epoll_create
has been removed from the -mm tree.  Its filename was
     flag-parameters-epoll_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flag parameters: epoll_create
From: Ulrich Drepper <drepper@redhat.com>

This patch adds the new epoll_create2 syscall.  It extends the old epoll_create
syscall by one parameter which is meant to hold a flag value.  In this
patch the only flag support is EPOLL_CLOEXEC which causes the close-on-exec
flag for the returned file descriptor to be set.

A new name EPOLL_CLOEXEC is introduced which in this implementation must
have the same value as O_CLOEXEC.

The following test must be adjusted for architectures other than x86 and
x86-64 and in case the syscall numbers changed.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <sys/syscall.h>

#ifndef __NR_epoll_create2
# ifdef __x86_64__
#  define __NR_epoll_create2 291
# elif defined __i386__
#  define __NR_epoll_create2 329
# else
#  error "need __NR_epoll_create2"
# endif
#endif

#define EPOLL_CLOEXEC O_CLOEXEC

int
main (void)
{
  int fd = syscall (__NR_epoll_create2, 1, 0);
  if (fd == -1)
    {
      puts ("epoll_create2(0) failed");
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
      puts ("epoll_create2(0) set close-on-exec flag");
      return 1;
    }
  close (fd);

  fd = syscall (__NR_epoll_create2, 1, EPOLL_CLOEXEC);
  if (fd == -1)
    {
      puts ("epoll_create2(EPOLL_CLOEXEC) failed");
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
      puts ("epoll_create2(EPOLL_CLOEXEC) set close-on-exec flag");
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
 fs/eventpoll.c                     |   13 +++++++++++--
 include/asm-x86/unistd_32.h        |    1 +
 include/asm-x86/unistd_64.h        |    2 ++
 include/linux/eventpoll.h          |    4 ++++
 include/linux/syscalls.h           |    1 +
 7 files changed, 21 insertions(+), 2 deletions(-)

diff -puN arch/x86/ia32/ia32entry.S~flag-parameters-epoll_create arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~flag-parameters-epoll_create
+++ a/arch/x86/ia32/ia32entry.S
@@ -745,4 +745,5 @@ ia32_sys_call_table:
 	.quad compat_sys_timerfd_gettime
 	.quad compat_sys_signalfd4
 	.quad sys_eventfd2
+	.quad sys_epoll_create2
 ia32_syscall_end:
diff -puN arch/x86/kernel/syscall_table_32.S~flag-parameters-epoll_create arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~flag-parameters-epoll_create
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -328,3 +328,4 @@ ENTRY(sys_call_table)
 	.long sys_timerfd_gettime
 	.long sys_signalfd4
 	.long sys_eventfd2
+	.long sys_epoll_create2
diff -puN fs/eventpoll.c~flag-parameters-epoll_create fs/eventpoll.c
--- a/fs/eventpoll.c~flag-parameters-epoll_create
+++ a/fs/eventpoll.c
@@ -1046,11 +1046,14 @@ retry:
  * RB tree. With the current implementation, the "size" parameter is ignored
  * (besides sanity checks).
  */
-asmlinkage long sys_epoll_create(int size)
+asmlinkage long sys_epoll_create2(int size, int flags)
 {
 	int error, fd = -1;
 	struct eventpoll *ep;
 
+	if (flags & ~EPOLL_CLOEXEC)
+		return -EINVAL;
+
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d)\n",
 		     current, size));
 
@@ -1068,7 +1071,8 @@ asmlinkage long sys_epoll_create(int siz
 	 * Creates all the items needed to setup an eventpoll file. That is,
 	 * a file structure and a free file descriptor.
 	 */
-	fd = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep, 0);
+	fd = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
+			      flags & O_CLOEXEC);
 	if (fd < 0)
 		ep_free(ep);
 
@@ -1079,6 +1083,11 @@ error_return:
 	return fd;
 }
 
+asmlinkage long sys_epoll_create(int size)
+{
+	return sys_epoll_create2(size, 0);
+}
+
 /*
  * The following function implements the controller interface for
  * the eventpoll file that enables the insertion/removal/change of
diff -puN include/asm-x86/unistd_32.h~flag-parameters-epoll_create include/asm-x86/unistd_32.h
--- a/include/asm-x86/unistd_32.h~flag-parameters-epoll_create
+++ a/include/asm-x86/unistd_32.h
@@ -334,6 +334,7 @@
 #define __NR_timerfd_gettime	326
 #define __NR_signalfd4		327
 #define __NR_eventfd2		328
+#define __NR_epoll_create2	329
 
 #ifdef __KERNEL__
 
diff -puN include/asm-x86/unistd_64.h~flag-parameters-epoll_create include/asm-x86/unistd_64.h
--- a/include/asm-x86/unistd_64.h~flag-parameters-epoll_create
+++ a/include/asm-x86/unistd_64.h
@@ -645,6 +645,8 @@ __SYSCALL(__NR_paccept, sys_paccept)
 __SYSCALL(__NR_signalfd4, sys_signalfd4)
 #define __NR_eventfd2				290
 __SYSCALL(__NR_eventfd2, sys_eventfd2)
+#define __NR_epoll_create2			291
+__SYSCALL(__NR_epoll_create2, sys_epoll_create2)
 
 
 #ifndef __NO_STUBS
diff -puN include/linux/eventpoll.h~flag-parameters-epoll_create include/linux/eventpoll.h
--- a/include/linux/eventpoll.h~flag-parameters-epoll_create
+++ a/include/linux/eventpoll.h
@@ -14,8 +14,12 @@
 #ifndef _LINUX_EVENTPOLL_H
 #define _LINUX_EVENTPOLL_H
 
+/* For O_CLOEXEC */
+#include <linux/fcntl.h>
 #include <linux/types.h>
 
+/* Flags for epoll_create2.  */
+#define EPOLL_CLOEXEC O_CLOEXEC
 
 /* Valid opcodes to issue to sys_epoll_ctl() */
 #define EPOLL_CTL_ADD 1
diff -puN include/linux/syscalls.h~flag-parameters-epoll_create include/linux/syscalls.h
--- a/include/linux/syscalls.h~flag-parameters-epoll_create
+++ a/include/linux/syscalls.h
@@ -430,6 +430,7 @@ asmlinkage long sys_poll(struct pollfd _
 asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			fd_set __user *exp, struct timeval __user *tvp);
 asmlinkage long sys_epoll_create(int size);
+asmlinkage long sys_epoll_create2(int size, int flags);
 asmlinkage long sys_epoll_ctl(int epfd, int op, int fd,
 				struct epoll_event __user *event);
 asmlinkage long sys_epoll_wait(int epfd, struct epoll_event __user *events,
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
linux-next.patch

