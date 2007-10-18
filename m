From: akpm@linux-foundation.org
Subject: - f_dupfd_cloexec-implementation.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:50 -0700
Message-ID: <200710180701.l9I71oQX031209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49950 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756117AbXJRHpQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:45:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, hch@lst.de, kyle@mcmartin.ca, linux-arch@vger.kernel.org, sfr@canb.auug.org.au, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     F_DUPFD_CLOEXEC implementation
has been removed from the -mm tree.  Its filename was
     f_dupfd_cloexec-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: F_DUPFD_CLOEXEC implementation
From: Ulrich Drepper <drepper@redhat.com>

One more small change to extend the availability of creation of file
descriptors with FD_CLOEXEC set.  Adding a new command to fcntl() requires
no new system call and the overall impact on code size if minimal.

If this patch gets accepted we will also add this change to the next
revision of the POSIX spec.

To test the patch, use the following little program.  Adjust the value of
F_DUPFD_CLOEXEC appropriately.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#ifndef F_DUPFD_CLOEXEC
# define F_DUPFD_CLOEXEC 12
#endif

int
main (int argc, char *argv[])
{
  if  (argc > 1)
    {
      if (fcntl (3, F_GETFD) == 0)
	{
	  puts ("descriptor not closed");
	  exit (1);
	}
      if (errno != EBADF)
	{
	  puts ("error not EBADF");
	  exit (1);
	}

      exit (0);
    }
  int fd = fcntl (STDOUT_FILENO, F_DUPFD_CLOEXEC, 0);
  if (fd == -1 && errno == EINVAL)
    {
      puts ("F_DUPFD_CLOEXEC not supported");
      return 0;
    }
  if (fd != 3)
    {
      puts ("program called with descriptors other than 0,1,2");
      return 1;
    }

  execl ("/proc/self/exe", "/proc/self/exe", "1", NULL);
  puts ("execl failed");
  return 1;
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <linux-arch@vger.kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c            |   12 ++++++++----
 include/linux/fcntl.h |   15 ++++++++++-----
 2 files changed, 18 insertions(+), 9 deletions(-)

diff -puN fs/fcntl.c~f_dupfd_cloexec-implementation fs/fcntl.c
--- a/fs/fcntl.c~f_dupfd_cloexec-implementation
+++ a/fs/fcntl.c
@@ -110,7 +110,7 @@ out:
 	return error;
 }
 
-static int dupfd(struct file *file, unsigned int start)
+static int dupfd(struct file *file, unsigned int start, int cloexec)
 {
 	struct files_struct * files = current->files;
 	struct fdtable *fdt;
@@ -122,7 +122,10 @@ static int dupfd(struct file *file, unsi
 		/* locate_fd() may have expanded fdtable, load the ptr */
 		fdt = files_fdtable(files);
 		FD_SET(fd, fdt->open_fds);
-		FD_CLR(fd, fdt->close_on_exec);
+		if (cloexec)
+			FD_SET(fd, fdt->close_on_exec);
+		else
+			FD_CLR(fd, fdt->close_on_exec);
 		spin_unlock(&files->file_lock);
 		fd_install(fd, file);
 	} else {
@@ -195,7 +198,7 @@ asmlinkage long sys_dup(unsigned int fil
 	struct file * file = fget(fildes);
 
 	if (file)
-		ret = dupfd(file, 0);
+		ret = dupfd(file, 0, 0);
 	return ret;
 }
 
@@ -319,8 +322,9 @@ static long do_fcntl(int fd, unsigned in
 
 	switch (cmd) {
 	case F_DUPFD:
+	case F_DUPFD_CLOEXEC:
 		get_file(filp);
-		err = dupfd(filp, arg);
+		err = dupfd(filp, arg, cmd == F_DUPFD_CLOEXEC);
 		break;
 	case F_GETFD:
 		err = get_close_on_exec(fd) ? FD_CLOEXEC : 0;
diff -puN include/linux/fcntl.h~f_dupfd_cloexec-implementation include/linux/fcntl.h
--- a/include/linux/fcntl.h~f_dupfd_cloexec-implementation
+++ a/include/linux/fcntl.h
@@ -3,12 +3,17 @@
 
 #include <asm/fcntl.h>
 
-/* Cancel a blocking posix lock; internal use only until we expose an
- * asynchronous lock api to userspace: */
-#define F_CANCELLK	(F_LINUX_SPECIFIC_BASE+5)
+#define F_SETLEASE	(F_LINUX_SPECIFIC_BASE + 0)
+#define F_GETLEASE	(F_LINUX_SPECIFIC_BASE + 1)
 
-#define F_SETLEASE	(F_LINUX_SPECIFIC_BASE+0)
-#define F_GETLEASE	(F_LINUX_SPECIFIC_BASE+1)
+/*
+ * Cancel a blocking posix lock; internal use only until we expose an
+ * asynchronous lock api to userspace:
+ */
+#define F_CANCELLK	(F_LINUX_SPECIFIC_BASE + 5)
+
+/* Create a file descriptor with FD_CLOEXEC set. */
+#define F_DUPFD_CLOEXEC	(F_LINUX_SPECIFIC_BASE + 6)
 
 /*
  * Request nofications on a directory.
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
