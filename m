From: Andrew Morton <akpm@linux-foundation.org>
Subject: + exec-relocate-s_isreg-check.patch added to -mm tree
Date: Mon, 18 May 2020 13:42:02 -0700
Message-ID: <20200518204202.cSUbmOirI%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgERUmD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 16:42:03 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christian.brauner@ubuntu.com, dvyukov@google.com, ebiggers3@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, viro@zeniv.linux.org.uk


The patch titled
     Subject: exec: relocate S_ISREG() check
has been added to the -mm tree.  Its filename is
     exec-relocate-s_isreg-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-relocate-s_isreg-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-relocate-s_isreg-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: exec: relocate S_ISREG() check

The execve(2)/uselib(2) syscalls have always rejected non-regular files. 
Recently, it was noticed that a deadlock was introduced when trying to
execute pipes, as the S_ISREG() test was happening too late.  This was
fixed in commit 73601ea5b7b1 ("fs/open.c: allow opening only regular files
during execve()"), but it was added after inode_permission() had already
run, which meant LSMs could see bogus attempts to execute non-regular
files.  Move the test earlier.

Also include a comment with the redundant S_ISREG() checks at the end of
execve(2)/uselib(2) to note that they are present to avoid any mistakes.

Finally, instead of dereferencing the inode, use dcache for S_ISREG()
test.

My notes on the call path, and related arguments, checks, etc:

do_open_execat()
    struct open_flags open_exec_flags = {
        .open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC, ...
    do_filp_open(dfd, filename, open_flags)
        path_openat(nameidata, open_flags, flags)
            /* f_mode populated from open_flags in alloc_empty_file() */
            file = alloc_empty_file(open_flags, current_cred());
            do_open(nameidata, file, open_flags)
		/* new location of FMODE_EXEC vs S_ISREG() test */
                may_open(path, acc_mode, open_flag)
                    inode_permission(inode, MAY_OPEN | acc_mode)
                        security_inode_permission(inode, acc_mode)
                vfs_open(path, file)
                    do_dentry_open(file, path->dentry->d_inode, open)
                        /* old location of FMODE_EXEC vs S_ISREG() test */
                        security_file_open(f)
                        open()

Link: http://lkml.kernel.org/r/20200518055457.12302-3-keescook@chromium.org
Fixes: 73601ea5b7b1 ("fs/open.c: allow opening only regular files during execve()")
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c  |    8 ++++++++
 fs/namei.c |    4 ++++
 fs/open.c  |    6 ------
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/fs/exec.c~exec-relocate-s_isreg-check
+++ a/fs/exec.c
@@ -139,6 +139,10 @@ SYSCALL_DEFINE1(uselib, const char __use
 	if (IS_ERR(file))
 		goto out;
 
+	/*
+	 * do_open() has already checked for this, but we can be extra
+	 * cautious and check again at the very end too.
+	 */
 	error = -EACCES;
 	if (!S_ISREG(file_inode(file)->i_mode))
 		goto exit;
@@ -884,6 +888,10 @@ static struct file *do_open_execat(int f
 	if (IS_ERR(file))
 		goto out;
 
+	/*
+	 * do_open() has already checked for this, but we can be extra
+	 * cautious and check again at the very end too.
+	 */
 	err = -EACCES;
 	if (!S_ISREG(file_inode(file)->i_mode))
 		goto exit;
--- a/fs/namei.c~exec-relocate-s_isreg-check
+++ a/fs/namei.c
@@ -3212,6 +3212,10 @@ static int do_open(struct nameidata *nd,
 	if ((nd->flags & LOOKUP_DIRECTORY) && !d_can_lookup(nd->path.dentry))
 		return -ENOTDIR;
 
+	/* Any file opened for execution has to be a regular file. */
+	if ((file->f_flags & FMODE_EXEC) && !d_is_reg(nd->path.dentry))
+		return -EACCES;
+
 	do_truncate = false;
 	acc_mode = op->acc_mode;
 	if (file->f_mode & FMODE_CREATED) {
--- a/fs/open.c~exec-relocate-s_isreg-check
+++ a/fs/open.c
@@ -752,12 +752,6 @@ static int do_dentry_open(struct file *f
 		return 0;
 	}
 
-	/* Any file opened for execve()/uselib() has to be a regular file. */
-	if (unlikely(f->f_flags & FMODE_EXEC && !S_ISREG(inode->i_mode))) {
-		error = -EACCES;
-		goto cleanup_file;
-	}
