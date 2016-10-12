From: akpm@linux-foundation.org
Subject: [merged] pipe-simplify-logic-in-alloc_pipe_info.patch removed
 from -mm tree
Date: Wed, 12 Oct 2016 12:24:29 -0700
Message-ID: <57fe8ded.UIDdVOcqFuqc9mq5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33185 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756039AbcJLTYm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@gmail.com, axboe@fb.com, penguin-kernel@I-love.SAKURA.ne.jp, socketpair@gmail.com, vegard.nossum@oracle.com, viro@zeniv.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: simplify logic in alloc_pipe_info()
has been removed from the -mm tree.  Its filename was
     pipe-simplify-logic-in-alloc_pipe_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: pipe: simplify logic in alloc_pipe_info()

Replace an 'if' block that covers most of the code in this function
with a 'goto'. This makes the code a little simpler to read, and also
simplifies the next patch (fix limit checking in alloc_pipe_info())

Link: http://lkml.kernel.org/r/aef030c1-0257-98a9-4988-186efa48530c@gmail.com
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Reviewed-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: <socketpair@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@fb.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff -puN fs/pipe.c~pipe-simplify-logic-in-alloc_pipe_info fs/pipe.c
--- a/fs/pipe.c~pipe-simplify-logic-in-alloc_pipe_info
+++ a/fs/pipe.c
@@ -622,33 +622,34 @@ static bool too_many_pipe_buffers_hard(s
 struct pipe_inode_info *alloc_pipe_info(void)
 {
 	struct pipe_inode_info *pipe;
+	unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
+	struct user_struct *user = get_current_user();
 
 	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL_ACCOUNT);
-	if (pipe) {
-		unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
-		struct user_struct *user = get_current_user();
+	if (pipe == NULL)
+		goto out_free_uid;
 
-		if (!too_many_pipe_buffers_hard(user)) {
-			if (too_many_pipe_buffers_soft(user))
-				pipe_bufs = 1;
-			pipe->bufs = kcalloc(pipe_bufs,
-					     sizeof(struct pipe_buffer),
-					     GFP_KERNEL_ACCOUNT);
-		}
+	if (!too_many_pipe_buffers_hard(user)) {
+		if (too_many_pipe_buffers_soft(user))
+			pipe_bufs = 1;
+		pipe->bufs = kcalloc(pipe_bufs,
+				     sizeof(struct pipe_buffer),
+				     GFP_KERNEL_ACCOUNT);
+	}
 
-		if (pipe->bufs) {
-			init_waitqueue_head(&pipe->wait);
-			pipe->r_counter = pipe->w_counter = 1;
-			pipe->buffers = pipe_bufs;
-			pipe->user = user;
-			account_pipe_buffers(user, 0, pipe_bufs);
-			mutex_init(&pipe->mutex);
-			return pipe;
-		}
-		free_uid(user);
-		kfree(pipe);
+	if (pipe->bufs) {
+		init_waitqueue_head(&pipe->wait);
+		pipe->r_counter = pipe->w_counter = 1;
+		pipe->buffers = pipe_bufs;
+		pipe->user = user;
+		account_pipe_buffers(user, 0, pipe_bufs);
+		mutex_init(&pipe->mutex);
+		return pipe;
 	}
 
+	kfree(pipe);
+out_free_uid:
+	free_uid(user);
 	return NULL;
 }
 
_

Patches currently in -mm which might be from mtk.manpages@gmail.com are


