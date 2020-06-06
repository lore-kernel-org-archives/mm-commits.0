From: Andrew Morton <akpm@linux-foundation.org>
Subject: + exec-move-s_isreg-check-earlier.patch added to -mm tree
Date: Fri, 05 Jun 2020 17:40:00 -0700
Message-ID: <20200606004000.I5f6_mQnW%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFFAkB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 20:40:01 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christian.brauner@ubuntu.com, cyphar@cyphar.com, dvyukov@google.com, ebiggers3@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, viro@zeniv.linux.org.uk


The patch titled
     Subject: exec: move S_ISREG() check earlier
has been added to the -mm tree.  Its filename is
     exec-move-s_isreg-check-earlier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-move-s_isreg-check-earlier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-move-s_isreg-check-earlier.patch

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
Subject: exec: move S_ISREG() check earlier

The execve(2)/uselib(2) syscalls have always rejected non-regular files. 
Recently, it was noticed that a deadlock was introduced when trying to
execute pipes, as the S_ISREG() test was happening too late.  This was
fixed in commit 73601ea5b7b1 ("fs/open.c: allow opening only regular files
during execve()"), but it was added after inode_permission() had already
run, which meant LSMs could see bogus attempts to execute non-regular
files.

Move the test into the other inode type checks (which already look for
other pathological conditions[1]).  Since there is no need to use
FMODE_EXEC while we still have access to "acc_mode", also switch the test
to MAY_EXEC.

Also include a comment with the redundant S_ISREG() checks at the end of
execve(2)/uselib(2) to note that they are present to avoid any mistakes.

My notes on the call path, and related arguments, checks, etc:

do_open_execat()
    struct open_flags open_exec_flags = {
        .open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
        .acc_mode = MAY_EXEC,
        ...
    do_filp_open(dfd, filename, open_flags)
        path_openat(nameidata, open_flags, flags)
            file = alloc_empty_file(open_flags, current_cred());
            do_open(nameidata, file, open_flags)
                may_open(path, acc_mode, open_flag)
		    /* new location of MAY_EXEC vs S_ISREG() test */
                    inode_permission(inode, MAY_OPEN | acc_mode)
                        security_inode_permission(inode, acc_mode)
                vfs_open(path, file)
                    do_dentry_open(file, path->dentry->d_inode, open)
                        /* old location of FMODE_EXEC vs S_ISREG() test */
                        security_file_open(f)
                        open()

[1] https://lore.kernel.org/lkml/202006041910.9EF0C602@keescook/

Link: http://lkml.kernel.org/r/20200605160013.3954297-3-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c  |   14 ++++++++++++--
 fs/namei.c |    6 ++++--
 fs/open.c  |    6 ------
 3 files changed, 16 insertions(+), 10 deletions(-)

--- a/fs/exec.c~exec-move-s_isreg-check-earlier
+++ a/fs/exec.c
@@ -141,8 +141,13 @@ SYSCALL_DEFINE1(uselib, const char __use
 	if (IS_ERR(file))
 		goto out;
 
+	/*
+	 * may_open() has already checked for this, so it should be
+	 * impossible to trip now. But we need to be extra cautious
+	 * and check again at the very end too.
+	 */
 	error = -EACCES;
-	if (!S_ISREG(file_inode(file)->i_mode))
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
 		goto exit;
 
 	if (path_noexec(&file->f_path))
@@ -886,8 +891,13 @@ static struct file *do_open_execat(int f
 	if (IS_ERR(file))
 		goto out;
 
+	/*
+	 * may_open() has already checked for this, so it should be
+	 * impossible to trip now. But we need to be extra cautious
+	 * and check again at the very end too.
+	 */
 	err = -EACCES;
-	if (!S_ISREG(file_inode(file)->i_mode))
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
 		goto exit;
 
 	if (path_noexec(&file->f_path))
--- a/fs/namei.c~exec-move-s_isreg-check-earlier
+++ a/fs/namei.c
@@ -2835,16 +2835,18 @@ static int may_open(const struct path *p
 	case S_IFLNK:
 		return -ELOOP;
 	case S_IFDIR:
-		if (acc_mode & MAY_WRITE)
+		if (acc_mode & (MAY_WRITE | MAY_EXEC))
 			return -EISDIR;
 		break;
 	case S_IFBLK:
 	case S_IFCHR:
 		if (!may_open_dev(path))
 			return -EACCES;
-		/*FALLTHRU*/
+		fallthrough;
 	case S_IFIFO:
 	case S_IFSOCK:
+		if (acc_mode & MAY_EXEC)
+			return -EACCES;
 		flag &= ~O_TRUNC;
 		break;
 	}
--- a/fs/open.c~exec-move-s_isreg-check-earlier
+++ a/fs/open.c
@@ -784,12 +784,6 @@ static int do_dentry_open(struct file *f
 		return 0;
 	}
 
-	/* Any file opened for execve()/uselib() has to be a regular file. */
-	if (unlikely(f->f_flags & FMODE_EXEC && !S_ISREG(inode->i_mode))) {
-		error = -EACCES;
-		goto cleanup_file;
-	}
