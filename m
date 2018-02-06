From: akpm@linux-foundation.org
Subject: [patch 103/114] pipe: simplify round_pipe_size()
Date: Tue, 06 Feb 2018 15:42:05 -0800
Message-ID: <20180206234205.wKEOxyT_E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56718 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753537AbeBFXmH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:42:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiggers@google.com, joe.lawrence@redhat.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, mpatocka@redhat.com, mtk.manpages@gmail.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, w@1wt.eu

From: Eric Biggers <ebiggers@google.com>
Subject: pipe: simplify round_pipe_size()

round_pipe_size() calculates the number of pages the requested size
corresponds to, then rounds the page count up to the next power of 2.

However, it also rounds everything < PAGE_SIZE up to PAGE_SIZE. 
Therefore, there's no need to actually translate the size into a page
count; we just need to round the size up to the next power of 2.

We do need to verify the size isn't greater than (1 << 31), since on
32-bit systems roundup_pow_of_two() would be undefined in that case.  But
that can just be combined with the UINT_MAX check which we need anyway
now.

Finally, update pipe_set_size() to not redundantly check the return value
of round_pipe_size() for the "invalid size" case twice.

Link: http://lkml.kernel.org/r/20180111052902.14409-7-ebiggers3@gmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff -puN fs/pipe.c~pipe-simplify-round_pipe_size fs/pipe.c
--- a/fs/pipe.c~pipe-simplify-round_pipe_size
+++ a/fs/pipe.c
@@ -1022,20 +1022,14 @@ const struct file_operations pipefifo_fo
  */
 unsigned int round_pipe_size(unsigned long size)
 {
-	unsigned long nr_pages;
-
-	if (size > UINT_MAX)
+	if (size > (1U << 31))
 		return 0;
 
 	/* Minimum pipe size, as required by POSIX */
 	if (size < PAGE_SIZE)
-		size = PAGE_SIZE;
