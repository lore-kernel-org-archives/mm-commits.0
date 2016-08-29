From: akpm@linux-foundation.org
Subject: + pipe-fix-limit-checking-in-alloc_pipe_info.patch added to -mm
 tree
Date: Mon, 29 Aug 2016 15:13:24 -0700
Message-ID: <57c4b384.c5zW6TI2CEFtndcQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38538 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755086AbcH2WN0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 18:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@gmail.com, axboe@fb.com, penguin-kernel@I-love.SAKURA.ne.jp, socketpair@gmail.com, vegard.nossum@oracle.com, viro@zeniv.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: fix limit checking in alloc_pipe_info()
has been added to the -mm tree.  Its filename is
     pipe-fix-limit-checking-in-alloc_pipe_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pipe-fix-limit-checking-in-alloc_pipe_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pipe-fix-limit-checking-in-alloc_pipe_info.patch

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

Patch history:

v2
   * Rework accounting checks to ensure that user cant get past
     too_many_pipe_buffers_soft() before the accounting is done.
     [Thanks to Vegard Nossum]

Link: http://lkml.kernel.org/r/8ff3e9f9-23f6-510c-644f-8e70cd1c0bd9@gmail.com
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
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
@@ -632,24 +632,30 @@ struct pipe_inode_info *alloc_pipe_info(
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

pipe-relocate-round_pipe_size-above-pipe_set_size.patch
pipe-move-limit-checking-logic-into-pipe_set_size.patch
pipe-refactor-argument-for-account_pipe_buffers.patch
pipe-fix-limit-checking-in-pipe_set_size.patch
pipe-simplify-logic-in-alloc_pipe_info.patch
pipe-fix-limit-checking-in-alloc_pipe_info.patch
pipe-make-account_pipe_buffers-return-a-value-and-use-it.patch
pipe-cap-initial-pipe-capacity-according-to-pipe-max-size-limit.patch

