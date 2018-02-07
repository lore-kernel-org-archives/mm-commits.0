From: akpm@linux-foundation.org
Subject: [merged]
 pipe-fix-off-by-one-error-when-checking-buffer-limits.patch removed from
 -mm tree
Date: Wed, 07 Feb 2018 12:00:18 -0800
Message-ID: <20180207200018.FWxzd6bIG%akpm__30740.5282896527$1518033537$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60586 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbeBGUAU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 15:00:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers@google.com, joe.lawrence@redhat.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, mpatocka@redhat.com, mtk.manpages@gmail.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, w@1wt.eu


The patch titled
     Subject: pipe: fix off-by-one error when checking buffer limits
has been removed from the -mm tree.  Its filename was
     pipe-fix-off-by-one-error-when-checking-buffer-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


