From: Andrew Morton <akpm@linux-foundation.org>
Subject: + exec-relocate-path_noexec-check.patch added to -mm tree
Date: Mon, 18 May 2020 13:42:05 -0700
Message-ID: <20200518204205.Z4MykSDv2%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgERUmH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 16:42:07 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christian.brauner@ubuntu.com, dvyukov@google.com, ebiggers3@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, viro@zeniv.linux.org.uk


The patch titled
     Subject: exec: relocate path_noexec() check
has been added to the -mm tree.  Its filename is
     exec-relocate-path_noexec-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-relocate-path_noexec-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-relocate-path_noexec-check.patch

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
Subject: exec: relocate path_noexec() check

The path_noexec() check, like the regular file check, was happening too
late, letting LSMs see impossible execve()s.  Check it earlier as well and
collect the redundant fs/exec.c path_noexec() test under the same
robustness comment as the S_ISREG() check.

My notes on the call path, and related arguments, checks, etc:

do_open_execat()
    struct open_flags open_exec_flags = {
        .open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC, ...
    do_filp_open(dfd, filename, open_flags)
        path_openat(nameidata, open_flags, flags)
            /* f_mode populated from open_flags in alloc_empty_file() */
            file = alloc_empty_file(open_flags, current_cred());
            do_open(nameidata, file, open_flags)
                /* new location of FMODE_EXEC vs path_noexec() test */
                may_open(path, acc_mode, open_flag)
                    inode_permission(inode, MAY_OPEN | acc_mode)
                        security_inode_permission(inode, acc_mode)
                vfs_open(path, file)
                    do_dentry_open(file, path->dentry->d_inode, open)
                        security_file_open(f)
                        open()
    /* old location of path_noexec() test */

Link: http://lkml.kernel.org/r/20200518055457.12302-4-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c  |    6 ++----
 fs/namei.c |    5 +++--
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/fs/exec.c~exec-relocate-path_noexec-check
+++ a/fs/exec.c
@@ -140,13 +140,12 @@ SYSCALL_DEFINE1(uselib, const char __use
 		goto out;
 
 	/*
-	 * do_open() has already checked for this, but we can be extra
+	 * do_open() has already checked for these, but we can be extra
 	 * cautious and check again at the very end too.
 	 */
 	error = -EACCES;
 	if (!S_ISREG(file_inode(file)->i_mode))
 		goto exit;
-
 	if (path_noexec(&file->f_path))
 		goto exit;
 
@@ -889,13 +888,12 @@ static struct file *do_open_execat(int f
 		goto out;
 
 	/*
-	 * do_open() has already checked for this, but we can be extra
+	 * do_open() has already checked for these, but we can be extra
 	 * cautious and check again at the very end too.
 	 */
 	err = -EACCES;
 	if (!S_ISREG(file_inode(file)->i_mode))
 		goto exit;
