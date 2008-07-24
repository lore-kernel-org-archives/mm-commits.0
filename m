From: akpm@linux-foundation.org
Subject: - flag-parameters-nonblock-in-timerfd_create.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:27:51 -0700
Message-ID: <200807242327.m6ONRp2j011192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756769AbYGXX3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, davidel@xmailserver.org, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     flag parameters: NONBLOCK in timerfd_create
has been removed from the -mm tree.  Its filename was
     flag-parameters-nonblock-in-timerfd_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flag parameters: NONBLOCK in timerfd_create
From: Ulrich Drepper <drepper@redhat.com>

This patch adds support for the TFD_NONBLOCK flag to timerfd_create.  The
additional changes needed are minimal.

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

#define TFD_NONBLOCK O_NONBLOCK

int
main (void)
{
  int fd = syscall (__NR_timerfd_create, CLOCK_REALTIME, 0);
  if (fd == -1)
    {
      puts ("timerfd_create(0) failed");
      return 1;
    }
  int fl = fcntl (fd, F_GETFL);
  if (fl == -1)
    {
      puts ("fcntl failed");
      return 1;
    }
  if (fl & O_NONBLOCK)
    {
      puts ("timerfd_create(0) set non-blocking mode");
      return 1;
    }
  close (fd);

  fd = syscall (__NR_timerfd_create, CLOCK_REALTIME, TFD_NONBLOCK);
  if (fd == -1)
    {
      puts ("timerfd_create(TFD_NONBLOCK) failed");
      return 1;
    }
  fl = fcntl (fd, F_GETFL);
  if (fl == -1)
    {
      puts ("fcntl failed");
      return 1;
    }
  if ((fl & O_NONBLOCK) == 0)
    {
      puts ("timerfd_create(TFD_NONBLOCK) set non-blocking mode");
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

 fs/timerfd.c            |    4 ++--
 include/linux/timerfd.h |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/timerfd.c~flag-parameters-nonblock-in-timerfd_create fs/timerfd.c
--- a/fs/timerfd.c~flag-parameters-nonblock-in-timerfd_create
+++ a/fs/timerfd.c
@@ -184,7 +184,7 @@ asmlinkage long sys_timerfd_create(int c
 	int ufd;
 	struct timerfd_ctx *ctx;
 
-	if (flags & ~TFD_CLOEXEC)
+	if (flags & ~(TFD_CLOEXEC | TFD_NONBLOCK))
 		return -EINVAL;
 	if (clockid != CLOCK_MONOTONIC &&
 	    clockid != CLOCK_REALTIME)
@@ -199,7 +199,7 @@ asmlinkage long sys_timerfd_create(int c
 	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
 
 	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
-			       flags & O_CLOEXEC);
+			       flags & (O_CLOEXEC | O_NONBLOCK));
 	if (ufd < 0)
 		kfree(ctx);
 
diff -puN include/linux/timerfd.h~flag-parameters-nonblock-in-timerfd_create include/linux/timerfd.h
--- a/include/linux/timerfd.h~flag-parameters-nonblock-in-timerfd_create
+++ a/include/linux/timerfd.h
@@ -8,7 +8,7 @@
 #ifndef _LINUX_TIMERFD_H
 #define _LINUX_TIMERFD_H
 
-/* For O_CLOEXEC */
+/* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 
 /* Flags for timerfd_settime.  */
@@ -16,6 +16,7 @@
 
 /* Flags for timerfd_create.  */
 #define TFD_CLOEXEC O_CLOEXEC
+#define TFD_NONBLOCK O_NONBLOCK
 
 
 #endif /* _LINUX_TIMERFD_H */
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
linux-next.patch

