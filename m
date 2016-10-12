From: akpm@linux-foundation.org
Subject: [merged] pipe-move-limit-checking-logic-into-pipe_set_size.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:24:20 -0700
Message-ID: <57fe8de4.Vss+n/40z+TEiTvg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33193 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756036AbcJLTYm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@gmail.com, axboe@fb.com, penguin-kernel@I-love.SAKURA.ne.jp, socketpair@gmail.com, vegard.nossum@oracle.com, viro@zeniv.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: move limit checking logic into pipe_set_size()
has been removed from the -mm tree.  Its filename was
     pipe-move-limit-checking-logic-into-pipe_set_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: pipe: move limit checking logic into pipe_set_size()

This is a preparatory patch for following work. Move the F_SETPIPE_SZ
limit-checking logic from pipe_fcntl() into pipe_set_size().  This
simplifies the code a little, and allows for reworking required in
a later patch that fixes the limit checking in pipe_set_size()

Link: http://lkml.kernel.org/r/3701b2c5-2c52-2c3e-226d-29b9deb29b50@gmail.com
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Reviewed-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: <socketpair@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@fb.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff -puN fs/pipe.c~pipe-move-limit-checking-logic-into-pipe_set_size fs/pipe.c
--- a/fs/pipe.c~pipe-move-limit-checking-logic-into-pipe_set_size
+++ a/fs/pipe.c
@@ -1023,9 +1023,24 @@ static inline unsigned int round_pipe_si
  * Allocate a new array of pipe buffers and copy the info over. Returns the
  * pipe size if successful, or return -ERROR on error.
  */
-static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long nr_pages)
+static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 {
 	struct pipe_buffer *bufs;
+	unsigned int size, nr_pages;
+
+	size = round_pipe_size(arg);
+	nr_pages = size >> PAGE_SHIFT;
+
+	if (!nr_pages)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size)
+		return -EPERM;
+
+	if ((too_many_pipe_buffers_hard(pipe->user) ||
+			too_many_pipe_buffers_soft(pipe->user)) &&
+			!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
 
 	/*
 	 * We can shrink the pipe, if arg >= pipe->nrbufs. Since we don't
@@ -1109,28 +1124,9 @@ long pipe_fcntl(struct file *file, unsig
 	__pipe_lock(pipe);
 
 	switch (cmd) {
-	case F_SETPIPE_SZ: {
-		unsigned int size, nr_pages;
-
-		size = round_pipe_size(arg);
-		nr_pages = size >> PAGE_SHIFT;
-
-		ret = -EINVAL;
-		if (!nr_pages)
-			goto out;
-
-		if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
-			ret = -EPERM;
-			goto out;
-		} else if ((too_many_pipe_buffers_hard(pipe->user) ||
-			    too_many_pipe_buffers_soft(pipe->user)) &&
-		           !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
-			ret = -EPERM;
-			goto out;
-		}
-		ret = pipe_set_size(pipe, nr_pages);
+	case F_SETPIPE_SZ:
+		ret = pipe_set_size(pipe, arg);
 		break;
-		}
 	case F_GETPIPE_SZ:
 		ret = pipe->buffers * PAGE_SIZE;
 		break;
@@ -1139,7 +1135,6 @@ long pipe_fcntl(struct file *file, unsig
 		break;
 	}
 
-out:
 	__pipe_unlock(pipe);
 	return ret;
 }
_

Patches currently in -mm which might be from mtk.manpages@gmail.com are


