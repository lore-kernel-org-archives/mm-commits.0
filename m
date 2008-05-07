From: akpm@linux-foundation.org
Subject: + flag-parameters-anon_inode_getfd-extension.patch added to -mm tree
Date: Wed, 07 May 2008 15:05:36 -0700
Message-ID: <200805072205.m47M5aKx018833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759127AbYEGWGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 18:06:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, davidel@xmailserver.org, mtk.manpages@googlemail.com


The patch titled
     flag parameters: anon_inode_getfd extension
has been added to the -mm tree.  Its filename is
     flag-parameters-anon_inode_getfd-extension.patch

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
Subject: flag parameters: anon_inode_getfd extension
From: Ulrich Drepper <drepper@redhat.com>

This patch just extends the anon_inode_getfd interface to take an additional
parameter with a flag value.  The flag value is passed on to
get_unused_fd_flags in anticipation for a use with the O_CLOEXEC flag.

No actual semantic changes here, the changed callers all pass 0 for now.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c            |    9 +++++----
 fs/eventfd.c                |    2 +-
 fs/eventpoll.c              |    2 +-
 fs/signalfd.c               |    3 ++-
 fs/timerfd.c                |    2 +-
 include/linux/anon_inodes.h |    2 +-
 6 files changed, 11 insertions(+), 9 deletions(-)

diff -puN fs/anon_inodes.c~flag-parameters-anon_inode_getfd-extension fs/anon_inodes.c
--- a/fs/anon_inodes.c~flag-parameters-anon_inode_getfd-extension
+++ a/fs/anon_inodes.c
@@ -58,8 +58,9 @@ static struct dentry_operations anon_ino
  *                    of the file
  *
  * @name:    [in]    name of the "class" of the new file
- * @fops     [in]    file operations for the new file
- * @priv     [in]    private data for the new file (will be file's private_data)
+ * @fops:    [in]    file operations for the new file
+ * @priv:    [in]    private data for the new file (will be file's private_data)
+ * @flags:   [in]    flags
  *
  * Creates a new file by hooking it on a single inode. This is useful for files
  * that do not need to have a full-fledged inode in order to operate correctly.
@@ -68,7 +69,7 @@ static struct dentry_operations anon_ino
  * setup.  Returns new descriptor or -error.
  */
 int anon_inode_getfd(const char *name, const struct file_operations *fops,
-		     void *priv)
+		     void *priv, int flags)
 {
 	struct qstr this;
 	struct dentry *dentry;
@@ -78,7 +79,7 @@ int anon_inode_getfd(const char *name, c
 	if (IS_ERR(anon_inode_inode))
 		return -ENODEV;
 
-	error = get_unused_fd();
+	error = get_unused_fd_flags(flags);
 	if (error < 0)
 		return error;
 	fd = error;
diff -puN fs/eventfd.c~flag-parameters-anon_inode_getfd-extension fs/eventfd.c
--- a/fs/eventfd.c~flag-parameters-anon_inode_getfd-extension
+++ a/fs/eventfd.c
@@ -214,7 +214,7 @@ asmlinkage long sys_eventfd(unsigned int
 	 * When we call this, the initialization must be complete, since
 	 * anon_inode_getfd() will install the fd.
 	 */
-	fd = anon_inode_getfd("[eventfd]", &eventfd_fops, ctx);
+	fd = anon_inode_getfd("[eventfd]", &eventfd_fops, ctx, 0);
 	if (fd < 0)
 		kfree(ctx);
 	return fd;
diff -puN fs/eventpoll.c~flag-parameters-anon_inode_getfd-extension fs/eventpoll.c
--- a/fs/eventpoll.c~flag-parameters-anon_inode_getfd-extension
+++ a/fs/eventpoll.c
@@ -1068,7 +1068,7 @@ asmlinkage long sys_epoll_create(int siz
 	 * Creates all the items needed to setup an eventpoll file. That is,
 	 * a file structure and a free file descriptor.
 	 */
-	fd = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep);
+	fd = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep, 0);
 	if (fd < 0)
 		ep_free(ep);
 
diff -puN fs/signalfd.c~flag-parameters-anon_inode_getfd-extension fs/signalfd.c
--- a/fs/signalfd.c~flag-parameters-anon_inode_getfd-extension
+++ a/fs/signalfd.c
@@ -227,7 +227,8 @@ asmlinkage long sys_signalfd(int ufd, si
 		 * When we call this, the initialization must be complete, since
 		 * anon_inode_getfd() will install the fd.
 		 */
-		ufd = anon_inode_getfd("[signalfd]", &signalfd_fops, ctx);
+		ufd = anon_inode_getfd("[signalfd]", &signalfd_fops, ctx,
+				       0);
 		if (ufd < 0)
 			kfree(ctx);
 	} else {
diff -puN fs/timerfd.c~flag-parameters-anon_inode_getfd-extension fs/timerfd.c
--- a/fs/timerfd.c~flag-parameters-anon_inode_getfd-extension
+++ a/fs/timerfd.c
@@ -198,7 +198,7 @@ asmlinkage long sys_timerfd_create(int c
 	ctx->clockid = clockid;
 	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
 
-	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx);
+	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx, 0);
 	if (ufd < 0)
 		kfree(ctx);
 
diff -puN include/linux/anon_inodes.h~flag-parameters-anon_inode_getfd-extension include/linux/anon_inodes.h
--- a/include/linux/anon_inodes.h~flag-parameters-anon_inode_getfd-extension
+++ a/include/linux/anon_inodes.h
@@ -9,7 +9,7 @@
 #define _LINUX_ANON_INODES_H
 
 int anon_inode_getfd(const char *name, const struct file_operations *fops,
-		     void *priv);
+		     void *priv, int flags);
 
 #endif /* _LINUX_ANON_INODES_H */
 
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

