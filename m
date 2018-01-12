From: akpm@linux-foundation.org
Subject: + pipe-fix-off-by-one-error-when-checking-buffer-limits.patch
 added to -mm tree
Date: Thu, 11 Jan 2018 16:16:21 -0800
Message-ID: <5a57fe55.F5arspfriPxjdSXG%akpm__28465.2817449116$1515716077$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43758 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754006AbeALAQX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jan 2018 19:16:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers@google.com, joe.lawrence@redhat.com, keescook@chromium.org, mcgrof@kernel.org, mpatocka@redhat.com, mtk.manpages@gmail.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: fix off-by-one error when checking buffer limits
has been added to the -mm tree.  Its filename is
     pipe-fix-off-by-one-error-when-checking-buffer-limits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pipe-fix-off-by-one-error-when-checking-buffer-limits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pipe-fix-off-by-one-error-when-checking-buffer-limits.patch

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
Subject: pipe: fix off-by-one error when checking buffer limits

With pipe-user-pages-hard set to 'N', users were actually only allowed up
to 'N - 1' buffers; and likewise for pipe-user-pages-soft.

Fix this to allow up to 'N' buffers, as would be expected.

Link: http://lkml.kernel.org/r/20180111052902.14409-5-ebiggers3@gmail.com
Fixes: b0b91d18e2e9 ("pipe: fix limit checking in pipe_set_size()")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Willy Tarreau <w@1wt.eu>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/pipe.c~pipe-fix-off-by-one-error-when-checking-buffer-limits fs/pipe.c
--- a/fs/pipe.c~pipe-fix-off-by-one-error-when-checking-buffer-limits
+++ a/fs/pipe.c
@@ -605,12 +605,12 @@ static unsigned long account_pipe_buffer
 
 static bool too_many_pipe_buffers_soft(unsigned long user_bufs)
 {
-	return pipe_user_pages_soft && user_bufs >= pipe_user_pages_soft;
+	return pipe_user_pages_soft && user_bufs > pipe_user_pages_soft;
 }
 
 static bool too_many_pipe_buffers_hard(unsigned long user_bufs)
 {
-	return pipe_user_pages_hard && user_bufs >= pipe_user_pages_hard;
+	return pipe_user_pages_hard && user_bufs > pipe_user_pages_hard;
 }
 
 static bool is_unprivileged_user(void)
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

