From: akpm@linux-foundation.org
Subject: + reiserfs-make-sure-va_end-is-always-called-after-va_start.patch added to -mm tree
Date: Mon, 03 Jan 2011 13:12:16 -0800
Message-ID: <201101032112.p03LCGml028802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155Ab1ACVMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 16:12:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jj@chaosbits.net, edward.shishkin@gmail.com, jeffm@suse.com


The patch titled
     reiserfs: make sure va_end() is always called after va_start().
has been added to the -mm tree.  Its filename is
     reiserfs-make-sure-va_end-is-always-called-after-va_start.patch

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
Subject: reiserfs: make sure va_end() is always called after va_start().
From: Jesper Juhl <jj@chaosbits.net>

A call to va_start() must always be followed by a call to va_end() in the
same function.  In fs/reiserfs/prints.c::print_block() this is not always
the case.  If 'bh' is NULL we'll return without calling va_end().

One could add a call to va_end() before the 'return' statement, but it's
nicer to just move the call to va_start() after the test for 'bh' being
NULL.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/prints.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/reiserfs/prints.c~reiserfs-make-sure-va_end-is-always-called-after-va_start fs/reiserfs/prints.c
--- a/fs/reiserfs/prints.c~reiserfs-make-sure-va_end-is-always-called-after-va_start
+++ a/fs/reiserfs/prints.c
@@ -586,13 +586,13 @@ void print_block(struct buffer_head *bh,
 	va_list args;
 	int mode, first, last;
 
-	va_start(args, bh);
