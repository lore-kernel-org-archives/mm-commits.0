From: akpm@linux-foundation.org
Subject: [patch 055/102] pipe: make account_pipe_buffers() return a value, and use it
Date: Tue, 11 Oct 2016 13:53:40 -0700
Message-ID: <57fd5154.u3s1NsSj4hoQrDtw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38035 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751993AbcJKUxm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mtk.manpages@gmail.com, axboe@fb.com, penguin-kernel@I-love.SAKURA.ne.jp, socketpair@gmail.com, vegard.nossum@oracle.com, viro@zeniv.linux.org.uk, w@1wt.eu

From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: pipe: make account_pipe_buffers() return a value, and use it

This is an optional patch, to provide a small performance
improvement.  Alter account_pipe_buffers() so that it returns the
new value in user->pipe_bufs. This means that we can refactor
too_many_pipe_buffers_soft() and too_many_pipe_buffers_hard() to
avoid the costs of repeated use of atomic_long_read() to get the
value user->pipe_bufs.

Link: http://lkml.kernel.org/r/93e5f193-1e5e-3e1f-3a20-eae79b7e1310@gmail.com
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Reviewed-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: <socketpair@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@fb.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN fs/pipe.c~pipe-make-account_pipe_buffers-return-a-value-and-use-it fs/pipe.c
--- a/fs/pipe.c~pipe-make-account_pipe_buffers-return-a-value-and-use-it
+++ a/fs/pipe.c
@@ -601,22 +601,20 @@ pipe_fasync(int fd, struct file *filp, i
 	return retval;
 }
 
-static void account_pipe_buffers(struct user_struct *user,
+static unsigned long account_pipe_buffers(struct user_struct *user,
                                  unsigned long old, unsigned long new)
 {
-	atomic_long_add(new - old, &user->pipe_bufs);
+	return atomic_long_add_return(new - old, &user->pipe_bufs);
 }
 
-static bool too_many_pipe_buffers_soft(struct user_struct *user)
+static bool too_many_pipe_buffers_soft(unsigned long user_bufs)
 {
-	return pipe_user_pages_soft &&
-	       atomic_long_read(&user->pipe_bufs) >= pipe_user_pages_soft;
+	return pipe_user_pages_soft && user_bufs >= pipe_user_pages_soft;
 }
 
-static bool too_many_pipe_buffers_hard(struct user_struct *user)
+static bool too_many_pipe_buffers_hard(unsigned long user_bufs)
 {
-	return pipe_user_pages_hard &&
-	       atomic_long_read(&user->pipe_bufs) >= pipe_user_pages_hard;
+	return pipe_user_pages_hard && user_bufs >= pipe_user_pages_hard;
 }
 
 struct pipe_inode_info *alloc_pipe_info(void)
@@ -624,19 +622,20 @@ struct pipe_inode_info *alloc_pipe_info(
 	struct pipe_inode_info *pipe;
 	unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
 	struct user_struct *user = get_current_user();
+	unsigned long user_bufs;
 
 	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL_ACCOUNT);
 	if (pipe == NULL)
 		goto out_free_uid;
 
-	account_pipe_buffers(user, 0, pipe_bufs);
+	user_bufs = account_pipe_buffers(user, 0, pipe_bufs);
 
-	if (too_many_pipe_buffers_soft(user)) {
-		account_pipe_buffers(user, pipe_bufs, 1);
+	if (too_many_pipe_buffers_soft(user_bufs)) {
+		user_bufs = account_pipe_buffers(user, pipe_bufs, 1);
 		pipe_bufs = 1;
 	}
 
-	if (too_many_pipe_buffers_hard(user))
+	if (too_many_pipe_buffers_hard(user_bufs))
 		goto out_revert_acct;
 
 	pipe->bufs = kcalloc(pipe_bufs, sizeof(struct pipe_buffer),
@@ -652,7 +651,7 @@ struct pipe_inode_info *alloc_pipe_info(
 	}
 
 out_revert_acct:
-	account_pipe_buffers(user, pipe_bufs, 0);
+	(void) account_pipe_buffers(user, pipe_bufs, 0);
 	kfree(pipe);
 out_free_uid:
 	free_uid(user);
@@ -663,7 +662,7 @@ void free_pipe_info(struct pipe_inode_in
 {
 	int i;
 
-	account_pipe_buffers(pipe->user, pipe->buffers, 0);
+	(void) account_pipe_buffers(pipe->user, pipe->buffers, 0);
 	free_uid(pipe->user);
 	for (i = 0; i < pipe->buffers; i++) {
 		struct pipe_buffer *buf = pipe->bufs + i;
@@ -1034,6 +1033,7 @@ static long pipe_set_size(struct pipe_in
 {
 	struct pipe_buffer *bufs;
 	unsigned int size, nr_pages;
+	unsigned long user_bufs;
 	long ret = 0;
 
 	size = round_pipe_size(arg);
@@ -1053,11 +1053,11 @@ static long pipe_set_size(struct pipe_in
 			size > pipe_max_size && !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
-	account_pipe_buffers(pipe->user, pipe->buffers, nr_pages);
+	user_bufs = account_pipe_buffers(pipe->user, pipe->buffers, nr_pages);
 
 	if (nr_pages > pipe->buffers &&
-			(too_many_pipe_buffers_hard(pipe->user) ||
-			 too_many_pipe_buffers_soft(pipe->user)) &&
+			(too_many_pipe_buffers_hard(user_bufs) ||
+			 too_many_pipe_buffers_soft(user_bufs)) &&
 			!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
 		ret = -EPERM;
 		goto out_revert_acct;
@@ -1109,7 +1109,7 @@ static long pipe_set_size(struct pipe_in
 	return nr_pages * PAGE_SIZE;
 
 out_revert_acct:
-	account_pipe_buffers(pipe->user, nr_pages, pipe->buffers);
+	(void) account_pipe_buffers(pipe->user, nr_pages, pipe->buffers);
 	return ret;
 }
 
_
