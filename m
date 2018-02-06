From: akpm@linux-foundation.org
Subject: [patch 100/114] pipe: actually allow root to exceed the
 pipe buffer limits
Date: Tue, 06 Feb 2018 15:41:53 -0800
Message-ID: <20180206234153.xdv1K6K62%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753537AbeBFXly (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:41:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiggers@google.com, joe.lawrence@redhat.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, mpatocka@redhat.com, mtk.manpages@gmail.com, stable@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, w@1wt.eu

From: Eric Biggers <ebiggers@google.com>
Subject: pipe: actually allow root to exceed the pipe buffer limits

pipe-user-pages-hard and pipe-user-pages-soft are only supposed to apply
to unprivileged users, as documented in both Documentation/sysctl/fs.txt
and the pipe(7) man page.

However, the capabilities are actually only checked when increasing a
pipe's size using F_SETPIPE_SZ, not when creating a new pipe.  Therefore,
if pipe-user-pages-hard has been set, the root user can run into it and be
unable to create pipes.  Similarly, if pipe-user-pages-soft has been set,
the root user can run into it and have their pipes limited to 1 page each.

Fix this by allowing the privileged override in both cases.

Link: http://lkml.kernel.org/r/20180111052902.14409-4-ebiggers3@gmail.com
Fixes: 759c01142a5d ("pipe: limit the per-user amount of pages allocated in pipes")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/pipe.c~pipe-actually-allow-root-to-exceed-the-pipe-buffer-limits fs/pipe.c
--- a/fs/pipe.c~pipe-actually-allow-root-to-exceed-the-pipe-buffer-limits
+++ a/fs/pipe.c
@@ -613,6 +613,11 @@ static bool too_many_pipe_buffers_hard(u
 	return pipe_user_pages_hard && user_bufs >= pipe_user_pages_hard;
 }
 
+static bool is_unprivileged_user(void)
+{
+	return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
+}
+
 struct pipe_inode_info *alloc_pipe_info(void)
 {
 	struct pipe_inode_info *pipe;
@@ -629,12 +634,12 @@ struct pipe_inode_info *alloc_pipe_info(
 
 	user_bufs = account_pipe_buffers(user, 0, pipe_bufs);
 
-	if (too_many_pipe_buffers_soft(user_bufs)) {
+	if (too_many_pipe_buffers_soft(user_bufs) && is_unprivileged_user()) {
 		user_bufs = account_pipe_buffers(user, pipe_bufs, 1);
 		pipe_bufs = 1;
 	}
 
-	if (too_many_pipe_buffers_hard(user_bufs))
+	if (too_many_pipe_buffers_hard(user_bufs) && is_unprivileged_user())
 		goto out_revert_acct;
 
 	pipe->bufs = kcalloc(pipe_bufs, sizeof(struct pipe_buffer),
@@ -1065,7 +1070,7 @@ static long pipe_set_size(struct pipe_in
 	if (nr_pages > pipe->buffers &&
 			(too_many_pipe_buffers_hard(user_bufs) ||
 			 too_many_pipe_buffers_soft(user_bufs)) &&
-			!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
+			is_unprivileged_user()) {
 		ret = -EPERM;
 		goto out_revert_acct;
 	}
_
