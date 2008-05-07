From: akpm@linux-foundation.org
Subject: + flag-parameters-nonblock-in-timerfd_create.patch added to -mm tree
Date: Wed, 07 May 2008 15:06:09 -0700
Message-ID: <200805072206.m47M69UD018884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761073AbYEGWG3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 18:06:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, davidel@xmailserver.org, mtk.manpages@googlemail.com


The patch titled
     flag parameters: NONBLOCK in timerfd_create
has been added to the -mm tree.  Its filename is
     flag-parameters-nonblock-in-timerfd_create.patch

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
flag-parameters-add-on-remove-epoll_create-size-param.patch

