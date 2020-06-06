From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 exec-change-uselib2-is_sreg-failure-to-eacces.patch removed from -mm tree
Date: Fri, 05 Jun 2020 17:35:05 -0700
Message-ID: <20200606003505.gZWmjF9BS%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728426AbgFFAfH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 20:35:07 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christian.brauner@ubuntu.com, dvyukov@google.com, ebiggers3@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, viro@zeniv.linux.org.uk


The patch titled
     Subject: exec: change uselib(2) IS_SREG() failure to EACCES
has been removed from the -mm tree.  Its filename was
     exec-change-uselib2-is_sreg-failure-to-eacces.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: exec: change uselib(2) IS_SREG() failure to EACCES

Patch series "Relocate execve() sanity checks".

While looking at the code paths for the proposed O_MAYEXEC flag, I saw
some things that looked like they should be fixed up.

  exec: Change uselib(2) IS_SREG() failure to EACCES
	This just regularizes the return code on uselib(2).

  exec: Relocate S_ISREG() check
	This moves the S_ISREG() check even earlier than it was already.

  exec: Relocate path_noexec() check
	This adds the path_noexec() check to the same place as the
	S_ISREG() check.

  fs: Include FMODE_EXEC when converting flags to f_mode
	This seemed like an oversight, but I suspect there is some
	reason I couldn't find for why FMODE_EXEC doesn't get set in
	f_mode and just stays in f_flags.


This patch (of 4):

Change uselib(2)' S_ISREG() error return to EACCES instead of EINVAL so
the behavior matches execve(2), and the seemingly documented value.  The
"not a regular file" failure mode of execve(2) is explicitly
documented[1], but it is not mentioned in uselib(2)[2] which does,
however, say that open(2) and mmap(2) errors may apply.  The documentation
for open(2) does not include a "not a regular file" error[3], but mmap(2)
does[4], and it is EACCES.

[1] http://man7.org/linux/man-pages/man2/execve.2.html#ERRORS
[2] http://man7.org/linux/man-pages/man2/uselib.2.html#ERRORS
[3] http://man7.org/linux/man-pages/man2/open.2.html#ERRORS
[4] http://man7.org/linux/man-pages/man2/mmap.2.html#ERRORS

Link: http://lkml.kernel.org/r/20200518055457.12302-1-keescook@chromium.org
Link: http://lkml.kernel.org/r/20200518055457.12302-2-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/exec.c~exec-change-uselib2-is_sreg-failure-to-eacces
+++ a/fs/exec.c
@@ -141,11 +141,10 @@ SYSCALL_DEFINE1(uselib, const char __use
 	if (IS_ERR(file))
 		goto out;
 
-	error = -EINVAL;
+	error = -EACCES;
 	if (!S_ISREG(file_inode(file)->i_mode))
 		goto exit;
 
-	error = -EACCES;
 	if (path_noexec(&file->f_path))
 		goto exit;
 
_

Patches currently in -mm which might be from keescook@chromium.org are

exec-relocate-s_isreg-check.patch
exec-relocate-path_noexec-check.patch
fs-include-fmode_exec-when-converting-flags-to-f_mode.patch
