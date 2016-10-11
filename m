From: akpm@linux-foundation.org
Subject: [patch 049/102] pipe: relocate round_pipe_size() above
 pipe_set_size()
Date: Tue, 11 Oct 2016 13:53:22 -0700
Message-ID: <57fd5142.e9yI7W3ZYxq9PzR4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37989 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753971AbcJKUxX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mtk.manpages@gmail.com, axboe@fb.com, penguin-kernel@I-love.SAKURA.ne.jp, socketpair@gmail.com, vegard.nossum@oracle.com, viro@zeniv.linux.org.uk, w@1wt.eu

From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: pipe: relocate round_pipe_size() above pipe_set_size()

Patch series "pipe: fix limit handling", v2.


When changing a pipe's capacity with fcntl(F_SETPIPE_SZ), various limits
defined by /proc/sys/fs/pipe-* files are checked to see if unprivileged
users are exceeding limits on memory consumption.

While documenting and testing the operation of these limits I noticed
that, as currently implemented, these checks have a number of problems:

(1) When increasing the pipe capacity, the checks against the limits
    in /proc/sys/fs/pipe-user-pages-{soft,hard} are made against
    existing consumption, and exclude the memory required for the
    increased pipe capacity. The new increase in pipe capacity can then
    push the total memory used by the user for pipes (possibly far) over
    a limit. This can also trigger the problem described next.

(2) The limit checks are performed even when the new pipe capacity
    is less than the existing pipe capacity. This can lead to problems
    if a user sets a large pipe capacity, and then the limits are
    lowered, with the result that the user will no longer be able to
    decrease the pipe capacity.

(3) As currently implemented, accounting and checking against the
    limits is done as follows:

    (a) Test whether the user has exceeded the limit.
    (b) Make new pipe buffer allocation.
    (c) Account new allocation against the limits.

    This is racey. Multiple processes may pass point (a) simultaneously,
    and then allocate pipe buffers that are accounted for only in step
    (c).  The race means that the user's pipe buffer allocation could be
    pushed over the limit (by an arbitrary amount, depending on how
    unlucky we were in the race). [Thanks to Vegard Nossum for spotting
    this point, which I had missed.]

This patch series addresses these three problems.


This patch (of 8):

This is a minor preparatory patch.  After subsequent patches,
round_pipe_size() will be called from pipe_set_size(), so place
round_pipe_size() above pipe_set_size().

Link: http://lkml.kernel.org/r/91a91fdb-a959-ba7f-b551-b62477cc98a1@gmail.com
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Reviewed-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: <socketpair@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@fb.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/pipe.c~pipe-relocate-round_pipe_size-above-pipe_set_size fs/pipe.c
--- a/fs/pipe.c~pipe-relocate-round_pipe_size-above-pipe_set_size
+++ a/fs/pipe.c
@@ -1008,6 +1008,18 @@ const struct file_operations pipefifo_fo
 };
 
 /*
+ * Currently we rely on the pipe array holding a power-of-2 number
+ * of pages.
+ */
+static inline unsigned int round_pipe_size(unsigned int size)
+{
+	unsigned long nr_pages;
+
+	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	return roundup_pow_of_two(nr_pages) << PAGE_SHIFT;
+}
+
+/*
  * Allocate a new array of pipe buffers and copy the info over. Returns the
  * pipe size if successful, or return -ERROR on error.
  */
@@ -1059,18 +1071,6 @@ static long pipe_set_size(struct pipe_in
 }
 
 /*
- * Currently we rely on the pipe array holding a power-of-2 number
- * of pages.
- */
-static inline unsigned int round_pipe_size(unsigned int size)
-{
-	unsigned long nr_pages;
-
-	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	return roundup_pow_of_two(nr_pages) << PAGE_SHIFT;
-}
