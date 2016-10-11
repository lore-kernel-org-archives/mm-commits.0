From: akpm@linux-foundation.org
Subject: [patch 051/102] pipe: refactor argument for
 account_pipe_buffers()
Date: Tue, 11 Oct 2016 13:53:28 -0700
Message-ID: <57fd5148.SKOI8z2oQgKYGDyE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38007 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753198AbcJKUx3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mtk.manpages@gmail.com, axboe@fb.com, penguin-kernel@I-love.SAKURA.ne.jp, socketpair@gmail.com, vegard.nossum@oracle.com, viro@zeniv.linux.org.uk, w@1wt.eu

From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: pipe: refactor argument for account_pipe_buffers()

This is a preparatory patch for following work. account_pipe_buffers()
performs accounting in the 'user_struct'. There is no need to pass a
pointer to a 'pipe_inode_info' struct (which is then dereferenced to
obtain a pointer to the 'user' field). Instead, pass a pointer directly
to the 'user_struct'. This change is needed in preparation for a
subsequent patch that the fixes the limit checking in alloc_pipe_info()
(and the resulting code is a little more logical).

Link: http://lkml.kernel.org/r/7277bf8c-a6fc-4a7d-659c-f5b145c981ab@gmail.com
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Reviewed-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: <socketpair@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@fb.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/pipe.c~pipe-refactor-argument-for-account_pipe_buffers fs/pipe.c
--- a/fs/pipe.c~pipe-refactor-argument-for-account_pipe_buffers
+++ a/fs/pipe.c
@@ -601,10 +601,10 @@ pipe_fasync(int fd, struct file *filp, i
 	return retval;
 }
 
-static void account_pipe_buffers(struct pipe_inode_info *pipe,
+static void account_pipe_buffers(struct user_struct *user,
                                  unsigned long old, unsigned long new)
 {
-	atomic_long_add(new - old, &pipe->user->pipe_bufs);
+	atomic_long_add(new - old, &user->pipe_bufs);
 }
 
 static bool too_many_pipe_buffers_soft(struct user_struct *user)
@@ -641,7 +641,7 @@ struct pipe_inode_info *alloc_pipe_info(
 			pipe->r_counter = pipe->w_counter = 1;
 			pipe->buffers = pipe_bufs;
 			pipe->user = user;
-			account_pipe_buffers(pipe, 0, pipe_bufs);
+			account_pipe_buffers(user, 0, pipe_bufs);
 			mutex_init(&pipe->mutex);
 			return pipe;
 		}
@@ -656,7 +656,7 @@ void free_pipe_info(struct pipe_inode_in
 {
 	int i;
 
-	account_pipe_buffers(pipe, pipe->buffers, 0);
+	account_pipe_buffers(pipe->user, pipe->buffers, 0);
 	free_uid(pipe->user);
 	for (i = 0; i < pipe->buffers; i++) {
 		struct pipe_buffer *buf = pipe->bufs + i;
@@ -1077,7 +1077,7 @@ static long pipe_set_size(struct pipe_in
 			memcpy(bufs + head, pipe->bufs, tail * sizeof(struct pipe_buffer));
 	}
 
-	account_pipe_buffers(pipe, pipe->buffers, nr_pages);
+	account_pipe_buffers(pipe->user, pipe->buffers, nr_pages);
 	pipe->curbuf = 0;
 	kfree(pipe->bufs);
 	pipe->bufs = bufs;
_
