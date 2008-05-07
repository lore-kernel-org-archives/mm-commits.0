From: akpm@linux-foundation.org
Subject: + flag-parameters-nonblock-in-pipe.patch added to -mm tree
Date: Wed, 07 May 2008 15:06:11 -0700
Message-ID: <200805072206.m47M6BYq018887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760919AbYEGWGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 18:06:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, davidel@xmailserver.org, mtk.manpages@googlemail.com


The patch titled
     flag parameters: NONBLOCK in pipe
has been added to the -mm tree.  Its filename is
     flag-parameters-nonblock-in-pipe.patch

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
Subject: flag parameters: NONBLOCK in pipe
From: Ulrich Drepper <drepper@redhat.com>

This patch adds O_NONBLOCK support to pipe2.  It is minimally more involved
than the patches for eventfd et.al but still trivial.  The interfaces of the
create_write_pipe and create_read_pipe helper functions were changed and the
one other caller as well.

The following test must be adjusted for architectures other than x86 and
x86-64 and in case the syscall numbers changed.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>

#ifndef __NR_pipe2
# ifdef __x86_64__
#  define __NR_pipe2 293
# elif defined __i386__
#  define __NR_pipe2 331
# else
#  error "need __NR_pipe2"
# endif
#endif

int
main (void)
{
  int fds[2];
  if (syscall (__NR_pipe2, fds, 0) == -1)
    {
      puts ("pipe2(0) failed");
      return 1;
    }
  for (int i = 0; i < 2; ++i)
    {
      int fl = fcntl (fds[i], F_GETFL);
      if (fl == -1)
        {
          puts ("fcntl failed");
          return 1;
        }
      if (fl & O_NONBLOCK)
        {
          printf ("pipe2(0) set non-blocking mode for fds[%d]\n", i);
          return 1;
        }
      close (fds[i]);
    }

  if (syscall (__NR_pipe2, fds, O_NONBLOCK) == -1)
    {
      puts ("pipe2(O_NONBLOCK) failed");
      return 1;
    }
  for (int i = 0; i < 2; ++i)
    {
      int fl = fcntl (fds[i], F_GETFL);
      if (fl == -1)
        {
          puts ("fcntl failed");
          return 1;
        }
      if ((fl & O_NONBLOCK) == 0)
        {
          printf ("pipe2(O_NONBLOCK) does not set non-blocking mode for fds[%d]\n", i);
          return 1;
        }
      close (fds[i]);
    }

  puts ("OK");

  return 0;
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c          |   14 +++++++-------
 include/linux/fs.h |    4 ++--
 kernel/kmod.c      |    4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/pipe.c~flag-parameters-nonblock-in-pipe fs/pipe.c
--- a/fs/pipe.c~flag-parameters-nonblock-in-pipe
+++ a/fs/pipe.c
@@ -950,7 +950,7 @@ fail_inode:
 	return NULL;
 }
 
-struct file *create_write_pipe(void)
+struct file *create_write_pipe(int flags)
 {
 	int err;
 	struct inode *inode;
@@ -983,7 +983,7 @@ struct file *create_write_pipe(void)
 		goto err_dentry;
 	f->f_mapping = inode->i_mapping;
 
-	f->f_flags = O_WRONLY;
+	f->f_flags = O_WRONLY | (flags & O_NONBLOCK);
 	f->f_version = 0;
 
 	return f;
@@ -1007,7 +1007,7 @@ void free_write_pipe(struct file *f)
 	put_filp(f);
 }
 
-struct file *create_read_pipe(struct file *wrf)
+struct file *create_read_pipe(struct file *wrf, int flags)
 {
 	struct file *f = get_empty_filp();
 	if (!f)
@@ -1019,7 +1019,7 @@ struct file *create_read_pipe(struct fil
 	f->f_mapping = wrf->f_path.dentry->d_inode->i_mapping;
 
 	f->f_pos = 0;
-	f->f_flags = O_RDONLY;
+	f->f_flags = O_RDONLY | (flags & O_NONBLOCK);
 	f->f_op = &read_pipe_fops;
 	f->f_mode = FMODE_READ;
 	f->f_version = 0;
@@ -1033,13 +1033,13 @@ int do_pipe_flags(int *fd, int flags)
 	int error;
 	int fdw, fdr;
 
-	if (flags & ~O_CLOEXEC)
+	if (flags & ~(O_CLOEXEC | O_NONBLOCK))
 		return -EINVAL;
 
-	fw = create_write_pipe();
+	fw = create_write_pipe(flags);
 	if (IS_ERR(fw))
 		return PTR_ERR(fw);
-	fr = create_read_pipe(fw);
+	fr = create_read_pipe(fw, flags);
 	error = PTR_ERR(fr);
 	if (IS_ERR(fr))
 		goto err_write_pipe;
diff -puN include/linux/fs.h~flag-parameters-nonblock-in-pipe include/linux/fs.h
--- a/include/linux/fs.h~flag-parameters-nonblock-in-pipe
+++ a/include/linux/fs.h
@@ -1771,8 +1771,8 @@ static inline void allow_write_access(st
 }
 extern int do_pipe(int *);
 extern int do_pipe_flags(int *, int);
-extern struct file *create_read_pipe(struct file *f);
-extern struct file *create_write_pipe(void);
+extern struct file *create_read_pipe(struct file *f, int flags);
+extern struct file *create_write_pipe(int flags);
 extern void free_write_pipe(struct file *);
 
 extern struct file *do_filp_open(int dfd, const char *pathname,
diff -puN kernel/kmod.c~flag-parameters-nonblock-in-pipe kernel/kmod.c
--- a/kernel/kmod.c~flag-parameters-nonblock-in-pipe
+++ a/kernel/kmod.c
@@ -417,12 +417,12 @@ int call_usermodehelper_stdinpipe(struct
 {
 	struct file *f;
 
-	f = create_write_pipe();
+	f = create_write_pipe(0);
 	if (IS_ERR(f))
 		return PTR_ERR(f);
 	*filp = f;
 
-	f = create_read_pipe(f);
+	f = create_read_pipe(f, 0);
 	if (IS_ERR(f)) {
 		free_write_pipe(*filp);
 		return PTR_ERR(f);
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

