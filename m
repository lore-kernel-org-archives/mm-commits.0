From: akpm@linux-foundation.org
Subject: [merged] pipe-fix-limit-checking-in-alloc_pipe_info.patch removed from -mm tree
Date: Wed, 12 Oct 2016 12:24:32 -0700
Message-ID: <57fe8df0.ZatyPK45S3YiTqhk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756040AbcJLTYm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@gmail.com, axboe@fb.com, penguin-kernel@I-love.SAKURA.ne.jp, socketpair@gmail.com, vegard.nossum@oracle.com, viro@zeniv.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: fix limit checking in alloc_pipe_info()
has been removed from the -mm tree.  Its filename was
     pipe-fix-limit-checking-in-alloc_pipe_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: pipe: fix limit checking in alloc_pipe_info()

The limit checking in alloc_pipe_info() (used by pipe(2) and when
opening a FIFO) has the following problems:

(1) When checking capacity required for the new pipe, the checks against
    the limit in /proc/sys/fs/pipe-user-pages-{soft,hard} are made
    against existing consumption, and exclude the memory required for
    the new pipe capacity. As a consequence: (1) the memory allocation
    throttling provided by the soft limit does not kick in quite as
    early as it should, and (2) the user can overrun the hard limit.

(2) As currently implemented, accounting and checking against the limits
    is done as follows:

    (a) Test whether the user has exceeded the limit.
    (b) Make new pipe buffer allocation.
    (c) Account new allocation against the limits.

    This is racey. Multiple processes may pass point (a) simultaneously,
    and then allocate pipe buffers that are accounted for only in step
    (c).  The race means that the user's pipe buffer allocation could be
    pushed over the limit (by an arbitrary amount, depending on how
    unlucky we were in the race). [Thanks to Vegard Nossum for spotting
    this point, which I had missed.]

This patch addresses the above problems as follows:

* Alter the checks against limits to include the memory required for the
  new pipe.
* Re-order the accounting step so that it precedes the buffer allocation.
  If the accounting step determines that a limit has been reached, revert
  the accounting and cause the operation to fail.

Link: http://lkml.kernel.org/r/8ff3e9f9-23f6-510c-644f-8e70cd1c0bd9@gmail.com
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Reviewed-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: <socketpair@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@fb.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN fs/pipe.c~pipe-fix-limit-checking-in-alloc_pipe_info fs/pipe.c
--- a/fs/pipe.c~pipe-fix-limit-checking-in-alloc_pipe_info
+++ a/fs/pipe.c
@@ -629,24 +629,30 @@ struct pipe_inode_info *alloc_pipe_info(
 	if (pipe == NULL)
 		goto out_free_uid;
 
-	if (!too_many_pipe_buffers_hard(user)) {
-		if (too_many_pipe_buffers_soft(user))
-			pipe_bufs = 1;
-		pipe->bufs = kcalloc(pipe_bufs,
-				     sizeof(struct pipe_buffer),
-				     GFP_KERNEL_ACCOUNT);
+	account_pipe_buffers(user, 0, pipe_bufs);
+
+	if (too_many_pipe_buffers_soft(user)) {
+		account_pipe_buffers(user, pipe_bufs, 1);
+		pipe_bufs = 1;
 	}
 
+	if (too_many_pipe_buffers_hard(user))
+		goto out_revert_acct;
+
+	pipe->bufs = kcalloc(pipe_bufs, sizeof(struct pipe_buffer),
+			     GFP_KERNEL_ACCOUNT);
+
 	if (pipe->bufs) {
 		init_waitqueue_head(&pipe->wait);
 		pipe->r_counter = pipe->w_counter = 1;
 		pipe->buffers = pipe_bufs;
 		pipe->user = user;
-		account_pipe_buffers(user, 0, pipe_bufs);
 		mutex_init(&pipe->mutex);
 		return pipe;
 	}
 
+out_revert_acct:
+	account_pipe_buffers(user, pipe_bufs, 0);
 	kfree(pipe);
 out_free_uid:
 	free_uid(user);
_

Patches currently in -mm which might be from mtk.manpages@gmail.com are


