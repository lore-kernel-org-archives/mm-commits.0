From: akpm@linux-foundation.org
Subject: + userfaultfd-convert-to-use-anon_inode_getfd.patch added to -mm
 tree
Date: Tue, 02 Jan 2018 15:40:56 -0800
Message-ID: <5a4c1888.G7Pt0GX+7oL3g69D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60736 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751188AbeABXk7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jan 2018 18:40:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers@google.com, aarcange@redhat.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: convert to use anon_inode_getfd()
has been added to the -mm tree.  Its filename is
     userfaultfd-convert-to-use-anon_inode_getfd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-convert-to-use-anon_inode_getfd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-convert-to-use-anon_inode_getfd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: userfaultfd: convert to use anon_inode_getfd()

Nothing actually calls userfaultfd_file_create() besides the userfaultfd()
system call itself.  So simplify things by folding it into the system call
and using anon_inode_getfd() instead of anon_inode_getfile().  Do the same
in resolve_userfault_fork() as well.  This removes over 50 lines with no
change in functionality.

Link: http://lkml.kernel.org/r/20171229212403.22800-1-ebiggers3@gmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   70 +++++----------------------------------------
 1 file changed, 9 insertions(+), 61 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-convert-to-use-anon_inode_getfd fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-convert-to-use-anon_inode_getfd
+++ a/fs/userfaultfd.c
@@ -988,24 +988,14 @@ static int resolve_userfault_fork(struct
 				  struct uffd_msg *msg)
 {
 	int fd;
-	struct file *file;
-	unsigned int flags = new->flags & UFFD_SHARED_FCNTL_FLAGS;
 
-	fd = get_unused_fd_flags(flags);
+	fd = anon_inode_getfd("[userfaultfd]", &userfaultfd_fops, new,
+			      O_RDWR | (new->flags & UFFD_SHARED_FCNTL_FLAGS));
 	if (fd < 0)
 		return fd;
 
-	file = anon_inode_getfile("[userfaultfd]", &userfaultfd_fops, new,
-				  O_RDWR | flags);
-	if (IS_ERR(file)) {
-		put_unused_fd(fd);
-		return PTR_ERR(file);
-	}
-
-	fd_install(fd, file);
 	msg->arg.reserved.reserved1 = 0;
 	msg->arg.fork.ufd = fd;
-
 	return 0;
 }
 
@@ -1887,24 +1877,10 @@ static void init_once_userfaultfd_ctx(vo
 	seqcount_init(&ctx->refile_seq);
 }
 
-/**
- * userfaultfd_file_create - Creates a userfaultfd file pointer.
- * @flags: Flags for the userfaultfd file.
- *
- * This function creates a userfaultfd file pointer, w/out installing
- * it into the fd table. This is useful when the userfaultfd file is
- * used during the initialization of data structures that require
- * extra setup after the userfaultfd creation. So the userfaultfd
- * creation is split into the file pointer creation phase, and the
- * file descriptor installation phase.  In this way races with
- * userspace closing the newly installed file descriptor can be
- * avoided.  Returns a userfaultfd file pointer, or a proper error
- * pointer.
- */
-static struct file *userfaultfd_file_create(int flags)
+SYSCALL_DEFINE1(userfaultfd, int, flags)
 {
-	struct file *file;
 	struct userfaultfd_ctx *ctx;
+	int fd;
 
 	BUG_ON(!current->mm);
 
@@ -1912,14 +1888,12 @@ static struct file *userfaultfd_file_cre
 	BUILD_BUG_ON(UFFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(UFFD_NONBLOCK != O_NONBLOCK);
 
-	file = ERR_PTR(-EINVAL);
 	if (flags & ~UFFD_SHARED_FCNTL_FLAGS)
-		goto out;
+		return -EINVAL;
 
-	file = ERR_PTR(-ENOMEM);
 	ctx = kmem_cache_alloc(userfaultfd_ctx_cachep, GFP_KERNEL);
 	if (!ctx)
-		goto out;
+		return -ENOMEM;
 
 	atomic_set(&ctx->refcount, 1);
 	ctx->flags = flags;
@@ -1930,39 +1904,13 @@ static struct file *userfaultfd_file_cre
 	/* prevent the mm struct to be freed */
 	mmgrab(ctx->mm);
 
-	file = anon_inode_getfile("[userfaultfd]", &userfaultfd_fops, ctx,
-				  O_RDWR | (flags & UFFD_SHARED_FCNTL_FLAGS));
-	if (IS_ERR(file)) {
+	fd = anon_inode_getfd("[userfaultfd]", &userfaultfd_fops, ctx,
+			      O_RDWR | (flags & UFFD_SHARED_FCNTL_FLAGS));
+	if (fd < 0) {
 		mmdrop(ctx->mm);
 		kmem_cache_free(userfaultfd_ctx_cachep, ctx);
 	}
-out:
-	return file;
-}
-
-SYSCALL_DEFINE1(userfaultfd, int, flags)
-{
-	int fd, error;
-	struct file *file;
-
-	error = get_unused_fd_flags(flags & UFFD_SHARED_FCNTL_FLAGS);
-	if (error < 0)
-		return error;
-	fd = error;
-
-	file = userfaultfd_file_create(flags);
-	if (IS_ERR(file)) {
-		error = PTR_ERR(file);
-		goto err_put_unused_fd;
-	}
-	fd_install(fd, file);
-
 	return fd;
-
-err_put_unused_fd:
-	put_unused_fd(fd);
