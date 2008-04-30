From: akpm@linux-foundation.org
Subject: - random-remove-some-prefetch-logic.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:21 -0700
Message-ID: <200804300548.m3U5mLSI029876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758789AbYD3FtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: remove some prefetch logic
has been removed from the -mm tree.  Its filename was
     random-remove-some-prefetch-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: remove some prefetch logic
From: Matt Mackall <mpm@selenic.com>

The urandom output pool (ie the fast path) fits in one cacheline, so
this is pretty unnecessary. Further, the output path has already
fetched the entire pool to hash it before calling in here.

(This was the only user of prefetch_range in the kernel, and it passed
in words rather than bytes!)

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/char/random.c~random-remove-some-prefetch-logic drivers/char/random.c
--- a/drivers/char/random.c~random-remove-some-prefetch-logic
+++ a/drivers/char/random.c
@@ -457,7 +457,7 @@ static void __add_entropy_words(struct e
 	unsigned long i, add_ptr, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
-	__u32 w, next_w;
+	__u32 w;
 	unsigned long flags;
 
 	/* Taps are constant, so we can load them without holding r->lock.  */
@@ -466,17 +466,13 @@ static void __add_entropy_words(struct e
 	tap3 = r->poolinfo->tap3;
 	tap4 = r->poolinfo->tap4;
 	tap5 = r->poolinfo->tap5;
-	next_w = *in++;
 
 	spin_lock_irqsave(&r->lock, flags);
-	prefetch_range(r->pool, wordmask);
 	input_rotate = r->input_rotate;
 	add_ptr = r->add_ptr;
 
 	while (nwords--) {
-		w = rol32(next_w, input_rotate & 31);
-		if (nwords > 0)
-			next_w = *in++;
+		w = rol32(*in++, input_rotate & 31);
 		i = add_ptr = (add_ptr - 1) & wordmask;
 
 		/* XOR in the various taps */
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch

