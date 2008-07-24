From: akpm@linux-foundation.org
Subject: - flag-parameters-timerfd_create.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:27:23 -0700
Message-ID: <200807242327.m6ONRNjt011160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756240AbYGXX3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, davidel@xmailserver.org, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     flag parameters: timerfd_create
has been removed from the -mm tree.  Its filename was
     flag-parameters-timerfd_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flag parameters: timerfd_create
From: Ulrich Drepper <drepper@redhat.com>

The timerfd_create syscall already has a flags parameter.  It just is
unused so far.  This patch changes this by introducing the TFD_CLOEXEC
flag to set the close-on-exec flag for the returned file descriptor.

A new name TFD_CLOEXEC is introduced which in this implementation must
have the same value as O_CLOEXEC.

The following test must be adjusted for architectures other than x86 and
x86-64 and in case the syscall numbers changed.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <sys/syscall.h>

#ifndef __NR_timerfd_create
# ifdef __x86_64__
#  define __NR_timerfd_create 283
# elif defined __i386__
#  define __NR_timerfd_create 322
# else
#  error "need __NR_timerfd_create"
# endif
#endif

#define TFD_CLOEXEC O_CLOEXEC

int
main (void)
{
  int fd = syscall (__NR_timerfd_create, CLOCK_REALTIME, 0);
  if (fd == -1)
    {
      puts ("timerfd_create(0) failed");
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
      puts ("timerfd_create(0) set close-on-exec flag");
      return 1;
    }
  close (fd);

  fd = syscall (__NR_timerfd_create, CLOCK_REALTIME, TFD_CLOEXEC);
  if (fd == -1)
    {
      puts ("timerfd_create(TFD_CLOEXEC) failed");
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
      puts ("timerfd_create(TFD_CLOEXEC) set close-on-exec flag");
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/timerfd.c            |    5 +++--
 include/linux/timerfd.h |    5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/timerfd.c~flag-parameters-timerfd_create fs/timerfd.c
--- a/fs/timerfd.c~flag-parameters-timerfd_create
+++ a/fs/timerfd.c
@@ -184,7 +184,7 @@ asmlinkage long sys_timerfd_create(int c
 	int ufd;
 	struct timerfd_ctx *ctx;
 
-	if (flags)
+	if (flags & ~TFD_CLOEXEC)
 		return -EINVAL;
 	if (clockid != CLOCK_MONOTONIC &&
 	    clockid != CLOCK_REALTIME)
@@ -198,7 +198,8 @@ asmlinkage long sys_timerfd_create(int c
 	ctx->clockid = clockid;
 	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
 
-	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx, 0);
+	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
+			       flags & O_CLOEXEC);
 	if (ufd < 0)
 		kfree(ctx);
 
diff -puN include/linux/timerfd.h~flag-parameters-timerfd_create include/linux/timerfd.h
--- a/include/linux/timerfd.h~flag-parameters-timerfd_create
+++ a/include/linux/timerfd.h
@@ -8,9 +8,14 @@
 #ifndef _LINUX_TIMERFD_H
 #define _LINUX_TIMERFD_H
 
+/* For O_CLOEXEC */
+#include <linux/fcntl.h>
 
+/* Flags for timerfd_settime.  */
 #define TFD_TIMER_ABSTIME (1 << 0)
 
+/* Flags for timerfd_create.  */
+#define TFD_CLOEXEC O_CLOEXEC
 
 
 #endif /* _LINUX_TIMERFD_H */
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
linux-next.patch

