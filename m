From: akpm@linux-foundation.org
Subject: + introduce-o_cloexec-take-2.patch added to -mm tree
Date: Thu, 31 May 2007 16:20:28 -0700
Message-ID: <200705312320.l4VNKS44030545@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755524AbXEaXVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 19:21:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, chris@zankel.net, davidel@xmailserver.org, mingo@elte.hu, mtk-manpages@gmx.net


The patch titled
     Introduce O_CLOEXEC
has been added to the -mm tree.  Its filename is
     introduce-o_cloexec-take-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Introduce O_CLOEXEC
From: Ulrich Drepper <drepper@redhat.com>

The problem is as follows: in multi-threaded code (or more correctly: all
code using clone() with CLONE_FILES) we have a race when exec'ing.

   thread #1                       thread #2

   fd=open()

                                   fork + exec

  fcntl(fd,F_SETFD,FD_CLOEXEC)

In some applications this can happen frequently.  Take a web browser.  One
thread opens a file and another thread starts, say, an external PDF viewer.
 The result can even be a security issue if that open file descriptor
refers to a sensitive file and the external program can somehow be tricked
into using that descriptor.

Just adding O_CLOEXEC support to open() doesn't solve the whole set of
problems.  There are other ways to create file descriptors (socket,
epoll_create, Unix domain socket transfer, etc).  These can and should be
addressed separately though.  open() is such an easy case that it makes not
much sense putting the fix off.

The test program:

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

#ifndef O_CLOEXEC
# define O_CLOEXEC 02000000
#endif

int
main (int argc, char *argv[])
{
  int fd;
  if (argc > 1)
    {
      fd = atol (argv[1]);
      printf ("child: fd = %d\n", fd);
      if (fcntl (fd, F_GETFD) == 0 || errno != EBADF)
        {
          puts ("file descriptor valid in child");
          return 1;
        }
      return 0;
    }

  fd = open ("/proc/self/exe", O_RDONLY | O_CLOEXEC);
  printf ("in parent: new fd = %d\n", fd);
  char buf[20];
  snprintf (buf, sizeof (buf), "%d", fd);
  execl ("/proc/self/exe", argv[0], buf, NULL);
  puts ("execl failed");
  return 1;
}

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c                   |   14 +++++++++++---
 include/asm-generic/fcntl.h |    3 +++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff -puN fs/open.c~introduce-o_cloexec-take-2 fs/open.c
--- a/fs/open.c~introduce-o_cloexec-take-2
+++ a/fs/open.c
@@ -855,7 +855,7 @@ EXPORT_SYMBOL(dentry_open);
 /*
  * Find an empty file descriptor entry, and mark it busy.
  */
-int get_unused_fd(void)
+static int get_unused_fd_flags(int flags)
 {
 	struct files_struct * files = current->files;
 	int fd, error;
@@ -891,7 +891,10 @@ repeat:
 	}
 
 	FD_SET(fd, fdt->open_fds);
-	FD_CLR(fd, fdt->close_on_exec);
+	if (flags & O_CLOEXEC)
+		FD_SET(fd, fdt->close_on_exec);
+	else
+		FD_CLR(fd, fdt->close_on_exec);
 	files->next_fd = fd + 1;
 #if 1
 	/* Sanity check */
@@ -907,6 +910,11 @@ out:
 	return error;
 }
 
+int get_unused_fd(void)
+{
+	return get_unused_fd_flags(0);
+}
+
 EXPORT_SYMBOL(get_unused_fd);
 
 static void __put_unused_fd(struct files_struct *files, unsigned int fd)
@@ -959,7 +967,7 @@ long do_sys_open(int dfd, const char __u
 	int fd = PTR_ERR(tmp);
 
 	if (!IS_ERR(tmp)) {
-		fd = get_unused_fd();
+		fd = get_unused_fd_flags(flags);
 		if (fd >= 0) {
 			struct file *f = do_filp_open(dfd, tmp, flags, mode);
 			if (IS_ERR(f)) {
diff -puN include/asm-generic/fcntl.h~introduce-o_cloexec-take-2 include/asm-generic/fcntl.h
--- a/include/asm-generic/fcntl.h~introduce-o_cloexec-take-2
+++ a/include/asm-generic/fcntl.h
@@ -48,6 +48,9 @@
 #ifndef O_NOATIME
 #define O_NOATIME	01000000
 #endif
+#ifndef O_CLOEXEC
+#define O_CLOEXEC	02000000	/* set close_on_exec */
+#endif
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
_

Patches currently in -mm which might be from drepper@redhat.com are

fix-compat-futex-code-for-private-futexes.patch
introduce-o_cloexec-take-2.patch
