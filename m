From: akpm@linux-foundation.org
Subject: + random-dont-try-to-look-at-entropy_count-outside-the-lock.patch added to -mm tree
Date: Sun, 07 Dec 2008 00:07:30 -0800
Message-ID: <200812070807.mB787Uwc017424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbYLGIHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 03:07:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com


The patch titled
     random: don't try to look at entropy_count outside the lock
has been added to the -mm tree.  Its filename is
     random-dont-try-to-look-at-entropy_count-outside-the-lock.patch

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
Subject: random: don't try to look at entropy_count outside the lock
From: Matt Mackall <mpm@selenic.com>

As a non-atomic value, it's only safe to look at entropy_count when the
pool lock is held, so we move the BUG_ON inside the lock for correctness.

Also remove the spurious comment.  It's ok for entropy_count to
temporarily exceed POOLBITS so long as it's left in a consistent state
when the lock is released.

This is a more correct, simple, and idiomatic fix for the bug in
8b76f46a2db.  I've left the reorderings introduced by that patch in place
as they're harmless, even though they don't properly deal with potential
atomicity issues.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/char/random.c~random-dont-try-to-look-at-entropy_count-outside-the-lock drivers/char/random.c
--- a/drivers/char/random.c~random-dont-try-to-look-at-entropy_count-outside-the-lock
+++ a/drivers/char/random.c
@@ -407,7 +407,7 @@ struct entropy_store {
 	/* read-write data: */
 	spinlock_t lock;
 	unsigned add_ptr;
-	int entropy_count;	/* Must at no time exceed ->POOLBITS! */
+	int entropy_count;
 	int input_rotate;
 };
 
@@ -748,11 +748,10 @@ static size_t account(struct entropy_sto
 {
 	unsigned long flags;
 
-	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
