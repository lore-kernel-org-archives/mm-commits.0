From: akpm@linux-foundation.org
Subject: + pipe-simplify-logic-in-alloc_pipe_info.patch added to -mm tree
Date: Mon, 29 Aug 2016 15:13:22 -0700
Message-ID: <57c4b382.HmYJx7U8mpOFVNxT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38545 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756322AbcH2WNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 18:13:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@gmail.com, axboe@fb.com, penguin-kernel@I-love.SAKURA.ne.jp, socketpair@gmail.com, vegard.nossum@oracle.com, viro@zeniv.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: simplify logic in alloc_pipe_info()
has been added to the -mm tree.  Its filename is
     pipe-simplify-logic-in-alloc_pipe_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pipe-simplify-logic-in-alloc_pipe_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pipe-simplify-logic-in-alloc_pipe_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: pipe: simplify logic in alloc_pipe_info()

Replace an 'if' block that covers most of the code in this function
with a 'goto'. This makes the code a little simpler to read, and also
simplifies the next patch (fix limit checking in alloc_pipe_info())

Link: http://lkml.kernel.org/r/aef030c1-0257-98a9-4988-186efa48530c@gmail.com
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
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
@@ -625,33 +625,34 @@ static bool too_many_pipe_buffers_hard(s
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

pipe-relocate-round_pipe_size-above-pipe_set_size.patch
pipe-move-limit-checking-logic-into-pipe_set_size.patch
pipe-refactor-argument-for-account_pipe_buffers.patch
pipe-fix-limit-checking-in-pipe_set_size.patch
pipe-simplify-logic-in-alloc_pipe_info.patch
pipe-fix-limit-checking-in-alloc_pipe_info.patch
pipe-make-account_pipe_buffers-return-a-value-and-use-it.patch
pipe-cap-initial-pipe-capacity-according-to-pipe-max-size-limit.patch

