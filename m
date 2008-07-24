From: akpm@linux-foundation.org
Subject: - flag-parameters-nonblock-in-inotify_init.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:27:57 -0700
Message-ID: <200807242327.m6ONRvX2011204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756236AbYGXX3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, davidel@xmailserver.org, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     flag parameters: NONBLOCK in inotify_init
has been removed from the -mm tree.  Its filename was
     flag-parameters-nonblock-in-inotify_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

