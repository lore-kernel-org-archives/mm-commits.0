From: akpm@linux-foundation.org
Subject: + pipe-read-buffer-limits-atomically.patch added to -mm tree
Date: Thu, 11 Jan 2018 16:16:30 -0800
Message-ID: <5a57fe5e.cmip87uJiczbQf0H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43840 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932074AbeALAQb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jan 2018 19:16:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers@google.com, joe.lawrence@redhat.com, keescook@chromium.org, mcgrof@kernel.org, mpatocka@redhat.com, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: read buffer limits atomically
has been added to the -mm tree.  Its filename is
     pipe-read-buffer-limits-atomically.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pipe-read-buffer-limits-atomically.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pipe-read-buffer-limits-atomically.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: pipe: read buffer limits atomically

The pipe buffer limits are accessed without any locking, and may be
changed at any time by the sysctl handlers.  In theory this could cause
problems for expressions like the following:

    pipe_user_pages_hard && user_bufs > pipe_user_pages_hard

...  since the assembly code might reference the 'pipe_user_pages_hard'
memory location multiple times, and if the admin removes the limit by
setting it to 0, there is a very brief window where processes could
incorrectly observe the limit to be exceeded.

Fix this by loading the limits with READ_ONCE() prior to use.

Link: http://lkml.kernel.org/r/20180111052902.14409-8-ebiggers3@gmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN fs/pipe.c~pipe-read-buffer-limits-atomically fs/pipe.c
--- a/fs/pipe.c~pipe-read-buffer-limits-atomically
+++ a/fs/pipe.c
@@ -605,12 +605,16 @@ static unsigned long account_pipe_buffer
 
 static bool too_many_pipe_buffers_soft(unsigned long user_bufs)
 {
-	return pipe_user_pages_soft && user_bufs > pipe_user_pages_soft;
+	unsigned long soft_limit = READ_ONCE(pipe_user_pages_soft);
+
+	return soft_limit && user_bufs > soft_limit;
 }
 
 static bool too_many_pipe_buffers_hard(unsigned long user_bufs)
 {
-	return pipe_user_pages_hard && user_bufs > pipe_user_pages_hard;
+	unsigned long hard_limit = READ_ONCE(pipe_user_pages_hard);
+
+	return hard_limit && user_bufs > hard_limit;
 }
 
 static bool is_unprivileged_user(void)
@@ -624,13 +628,14 @@ struct pipe_inode_info *alloc_pipe_info(
 	unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
 	struct user_struct *user = get_current_user();
 	unsigned long user_bufs;
+	unsigned int max_size = READ_ONCE(pipe_max_size);
 
 	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL_ACCOUNT);
 	if (pipe == NULL)
 		goto out_free_uid;
 
-	if (pipe_bufs * PAGE_SIZE > pipe_max_size && !capable(CAP_SYS_RESOURCE))
-		pipe_bufs = pipe_max_size >> PAGE_SHIFT;
+	if (pipe_bufs * PAGE_SIZE > max_size && !capable(CAP_SYS_RESOURCE))
+		pipe_bufs = max_size >> PAGE_SHIFT;
 
 	user_bufs = account_pipe_buffers(user, 0, pipe_bufs);
 
_

Patches currently in -mm which might be from ebiggers@google.com are

userfaultfd-convert-to-use-anon_inode_getfd.patch
pipe-sysctl-drop-min-parameter-from-pipe-max-size-converter.patch
pipe-sysctl-remove-pipe_proc_fn.patch
pipe-actually-allow-root-to-exceed-the-pipe-buffer-limits.patch
pipe-fix-off-by-one-error-when-checking-buffer-limits.patch
pipe-reject-f_setpipe_sz-with-size-over-uint_max.patch
pipe-simplify-round_pipe_size.patch
pipe-read-buffer-limits-atomically.patch

