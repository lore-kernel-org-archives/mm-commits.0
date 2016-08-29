From: akpm@linux-foundation.org
Subject: +
 pipe-cap-initial-pipe-capacity-according-to-pipe-max-size-limit.patch added to -mm tree
Date: Mon, 29 Aug 2016 15:13:28 -0700
Message-ID: <57c4b388.TagrTT20PQy04VMs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38538 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756440AbcH2WNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 18:13:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@gmail.com, axboe@fb.com, penguin-kernel@I-love.SAKURA.ne.jp, socketpair@gmail.com, vegard.nossum@oracle.com, viro@zeniv.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: cap initial pipe capacity according to pipe-max-size limit
has been added to the -mm tree.  Its filename is
     pipe-cap-initial-pipe-capacity-according-to-pipe-max-size-limit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pipe-cap-initial-pipe-capacity-according-to-pipe-max-size-limit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pipe-cap-initial-pipe-capacity-according-to-pipe-max-size-limit.patch

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
Subject: pipe: cap initial pipe capacity according to pipe-max-size limit

This is a patch that provides behavior that is more consistent, and
probably less surprising to users. I consider the change optional, and
welcome opinions about whether it should be applied.

By default, pipes are created with a capacity of 64 kiB.  However,
/proc/sys/fs/pipe-max-size may be set smaller than this value.  In this
scenario, an unprivileged user could thus create a pipe whose initial
capacity exceeds the limit. Therefore, it seems logical to cap the
initial pipe capacity according to the value of pipe-max-size.

The test program shown earlier in this patch series can be used to
demonstrate the effect of the change brought about with this patch:

    # cat /proc/sys/fs/pipe-max-size
    1048576
    # sudo -u mtk ./test_F_SETPIPE_SZ 1
    Initial pipe capacity: 65536
    # echo 10000 > /proc/sys/fs/pipe-max-size
    # cat /proc/sys/fs/pipe-max-size
    16384
    # sudo -u mtk ./test_F_SETPIPE_SZ 1
    Initial pipe capacity: 16384
    # ./test_F_SETPIPE_SZ 1
    Initial pipe capacity: 65536

The last two executions of 'test_F_SETPIPE_SZ' show that pipe-max-size
caps the initial allocation for a new pipe for unprivileged users, but
not for privileged users.

Patch history:

v2
   * Switch order of tests in an 'if' statement to avoid a function
     call (to capability()) in normal path. [Thanks to Willy Tarreau]

Link: http://lkml.kernel.org/r/31dc7064-2a17-9c5b-1df1-4e3012ee992c@gmail.com
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: <socketpair@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@fb.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/pipe.c~pipe-cap-initial-pipe-capacity-according-to-pipe-max-size-limit fs/pipe.c
--- a/fs/pipe.c~pipe-cap-initial-pipe-capacity-according-to-pipe-max-size-limit
+++ a/fs/pipe.c
@@ -631,6 +631,9 @@ struct pipe_inode_info *alloc_pipe_info(
 	if (pipe == NULL)
 		goto out_free_uid;
 
+	if (pipe_bufs * PAGE_SIZE > pipe_max_size && !capable(CAP_SYS_RESOURCE))
+		pipe_bufs = pipe_max_size >> PAGE_SHIFT;
+
 	user_bufs = account_pipe_buffers(user, 0, pipe_bufs);
 
 	if (too_many_pipe_buffers_soft(user_bufs)) {
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

