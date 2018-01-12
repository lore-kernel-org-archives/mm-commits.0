From: akpm@linux-foundation.org
Subject: + pipe-simplify-round_pipe_size.patch added to -mm tree
Date: Thu, 11 Jan 2018 16:16:27 -0800
Message-ID: <5a57fe5b.Plenl7bgFlM4fOse%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43806 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932074AbeALAQ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jan 2018 19:16:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers@google.com, joe.lawrence@redhat.com, keescook@chromium.org, mcgrof@kernel.org, mpatocka@redhat.com, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: simplify round_pipe_size()
has been added to the -mm tree.  Its filename is
     pipe-simplify-round_pipe_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pipe-simplify-round_pipe_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pipe-simplify-round_pipe_size.patch

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
-
-	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (nr_pages == 0)
-		return 0;
+		return PAGE_SIZE;
 
-	return roundup_pow_of_two(nr_pages) << PAGE_SHIFT;
+	return roundup_pow_of_two(size);
 }
 
 /*
@@ -1050,8 +1044,6 @@ static long pipe_set_size(struct pipe_in
 	long ret = 0;
 
 	size = round_pipe_size(arg);
-	if (size == 0)
-		return -EINVAL;
 	nr_pages = size >> PAGE_SHIFT;
 
 	if (!nr_pages)
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

