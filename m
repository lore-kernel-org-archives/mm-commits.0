From: akpm@linux-foundation.org
Subject: + flag-parameters-nonblock-in-inotify_init.patch added to -mm tree
Date: Wed, 07 May 2008 15:06:13 -0700
Message-ID: <200805072206.m47M6EpH018890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761586AbYEGWGw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 18:06:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, davidel@xmailserver.org, mtk.manpages@googlemail.com


The patch titled
     flag parameters: NONBLOCK in inotify_init
has been added to the -mm tree.  Its filename is
     flag-parameters-nonblock-in-inotify_init.patch

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
Subject: flag parameters: NONBLOCK in inotify_init
From: Ulrich Drepper <drepper@redhat.com>

This patch adds non-blocking support for inotify_init1.  The
additional changes needed are minimal.

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

#define IN_NONBLOCK O_NONBLOCK

int
main (void)
{
  int fd = syscall (__NR_inotify_init1, 0);
  if (fd == -1)
    {
      puts ("inotify_init1(0) failed");
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
      puts ("inotify_init1(0) set non-blocking mode");
      return 1;
    }
  close (fd);

  fd = syscall (__NR_inotify_init1, IN_NONBLOCK);
  if (fd == -1)
    {
      puts ("inotify_init1(IN_NONBLOCK) failed");
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
      puts ("inotify_init1(IN_NONBLOCK) set non-blocking mode");
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

 fs/inotify_user.c       |    4 ++--
 include/linux/inotify.h |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/inotify_user.c~flag-parameters-nonblock-in-inotify_init fs/inotify_user.c
--- a/fs/inotify_user.c~flag-parameters-nonblock-in-inotify_init
+++ a/fs/inotify_user.c
@@ -574,7 +574,7 @@ asmlinkage long sys_inotify_init1(int fl
 	struct file *filp;
 	int fd, ret;
 
-	if (flags & ~IN_CLOEXEC)
+	if (flags & ~(IN_CLOEXEC | IN_NONBLOCK))
 		return -EINVAL;
 
 	fd = get_unused_fd_flags(flags & O_CLOEXEC);
@@ -613,7 +613,7 @@ asmlinkage long sys_inotify_init1(int fl
 	filp->f_path.dentry = dget(inotify_mnt->mnt_root);
 	filp->f_mapping = filp->f_path.dentry->d_inode->i_mapping;
 	filp->f_mode = FMODE_READ;
-	filp->f_flags = O_RDONLY;
+	filp->f_flags = O_RDONLY | (flags & O_NONBLOCK);
 	filp->private_data = dev;
 
 	INIT_LIST_HEAD(&dev->events);
diff -puN include/linux/inotify.h~flag-parameters-nonblock-in-inotify_init include/linux/inotify.h
--- a/include/linux/inotify.h~flag-parameters-nonblock-in-inotify_init
+++ a/include/linux/inotify.h
@@ -7,7 +7,7 @@
 #ifndef _LINUX_INOTIFY_H
 #define _LINUX_INOTIFY_H
 
-/* For O_CLOEXEC */
+/* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 #include <linux/types.h>
 
@@ -67,6 +67,7 @@ struct inotify_event {
 
 /* Flags for sys_inotify_init1.  */
 #define IN_CLOEXEC O_CLOEXEC
+#define IN_NONBLOCK O_NONBLOCK
 
 #ifdef __KERNEL__
 
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

