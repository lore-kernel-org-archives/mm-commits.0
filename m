From: akpm@linux-foundation.org
Subject: - random-dont-try-to-look-at-entropy_count-outside-the-lock.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:45 -0800
Message-ID: <200901072220.n07MKjxp019968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763132AbZAGWcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:32:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     random: don't try to look at entropy_count outside the lock
has been removed from the -mm tree.  Its filename was
     random-dont-try-to-look-at-entropy_count-outside-the-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
@@ -767,11 +767,10 @@ static size_t account(struct entropy_sto
 {
 	unsigned long flags;
 
-	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
