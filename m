From: akpm@linux-foundation.org
Subject: + buffer_head-remove-redundant-test-from-wait_on_buffer.patch added to -mm tree
Date: Fri, 16 Apr 2010 14:52:02 -0700
Message-ID: <201004162152.o3GLq3ld028760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932490Ab0DPVwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, jeffm@suse.com, jens.axboe@oracle.com, nickpiggin@yahoo.com.au


The patch titled
     buffer_head: remove redundant test from wait_on_buffer
has been added to the -mm tree.  Its filename is
     buffer_head-remove-redundant-test-from-wait_on_buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: buffer_head: remove redundant test from wait_on_buffer
From: Richard Kennedy <richard@rsk.demon.co.uk>

The comment suggests that when b_count equals zero it is calling
__wait_no_buffer to trigger some debug, but as there is no debug in
__wait_on_buffer the whole thing is redundant.

AFAICT from the git log this has been the case for at least 5 years, so
it seems safe just to remove this.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/buffer_head.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN include/linux/buffer_head.h~buffer_head-remove-redundant-test-from-wait_on_buffer include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~buffer_head-remove-redundant-test-from-wait_on_buffer
+++ a/include/linux/buffer_head.h
@@ -305,15 +305,10 @@ map_bh(struct buffer_head *bh, struct su
 	bh->b_size = sb->s_blocksize;
 }
 
-/*
- * Calling wait_on_buffer() for a zero-ref buffer is illegal, so we call into
- * __wait_on_buffer() just to trip a debug check.  Because debug code in inline
- * functions is bloaty.
- */
 static inline void wait_on_buffer(struct buffer_head *bh)
 {
 	might_sleep();
-	if (buffer_locked(bh) || atomic_read(&bh->b_count) == 0)
+	if (buffer_locked(bh))
 		__wait_on_buffer(bh);
 }
 
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

linux-next.patch
buffer_head-remove-redundant-test-from-wait_on_buffer.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch

