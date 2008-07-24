From: akpm@linux-foundation.org
Subject: - flag-parameters-nonblock-in-eventfd.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:27:48 -0700
Message-ID: <200807242327.m6ONRmus011189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756679AbYGXX3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, davidel@xmailserver.org, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     flag parameters: NONBLOCK in eventfd
has been removed from the -mm tree.  Its filename was
     flag-parameters-nonblock-in-eventfd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flag parameters: NONBLOCK in eventfd
From: Ulrich Drepper <drepper@redhat.com>

This patch adds support for the EFD_NONBLOCK flag to eventfd2.  The
additional changes needed are minimal.

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

#define EFD_NONBLOCK O_NONBLOCK

int
main (void)
{
  int fd = syscall (__NR_eventfd2, 1, 0);
  if (fd == -1)
    {
      puts ("eventfd2(0) failed");
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
      puts ("eventfd2(0) sets non-blocking mode");
      return 1;
    }
  close (fd);

  fd = syscall (__NR_eventfd2, 1, EFD_NONBLOCK);
  if (fd == -1)
    {
      puts ("eventfd2(EFD_NONBLOCK) failed");
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
      puts ("eventfd2(EFD_NONBLOCK) does not set non-blocking mode");
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

 fs/eventfd.c            |    4 ++--
 include/linux/eventfd.h |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/eventfd.c~flag-parameters-nonblock-in-eventfd fs/eventfd.c
--- a/fs/eventfd.c~flag-parameters-nonblock-in-eventfd
+++ a/fs/eventfd.c
@@ -203,7 +203,7 @@ asmlinkage long sys_eventfd2(unsigned in
 	int fd;
 	struct eventfd_ctx *ctx;
 
-	if (flags & ~EFD_CLOEXEC)
+	if (flags & ~(EFD_CLOEXEC | EFD_NONBLOCK))
 		return -EINVAL;
 
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
@@ -218,7 +218,7 @@ asmlinkage long sys_eventfd2(unsigned in
 	 * anon_inode_getfd() will install the fd.
 	 */
 	fd = anon_inode_getfd("[eventfd]", &eventfd_fops, ctx,
-			      flags & O_CLOEXEC);
+			      flags & (O_CLOEXEC | O_NONBLOCK));
 	if (fd < 0)
 		kfree(ctx);
 	return fd;
diff -puN include/linux/eventfd.h~flag-parameters-nonblock-in-eventfd include/linux/eventfd.h
--- a/include/linux/eventfd.h~flag-parameters-nonblock-in-eventfd
+++ a/include/linux/eventfd.h
@@ -10,11 +10,12 @@
 
 #ifdef CONFIG_EVENTFD
 
-/* For O_CLOEXEC */
+/* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 
 /* Flags for eventfd2.  */
 #define EFD_CLOEXEC O_CLOEXEC
+#define EFD_NONBLOCK O_NONBLOCK
 
 struct file *eventfd_fget(int fd);
 int eventfd_signal(struct file *file, int n);
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
linux-next.patch

