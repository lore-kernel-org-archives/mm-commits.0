From: akpm@linux-foundation.org
Subject: - random-simplify-add_ptr-logic.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:23 -0700
Message-ID: <200804300548.m3U5mNl4029879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757570AbYD3GLy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:11:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: simplify add_ptr logic
has been removed from the -mm tree.  Its filename was
     random-simplify-add_ptr-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: simplify add_ptr logic
From: Matt Mackall <mpm@selenic.com>

The add_ptr variable wasn't used in a sensible way, use only i instead.
i got reused later for a different purpose, use j instead.

While we're here, put tap0 first in the tap list and add a comment.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/char/random.c~random-simplify-add_ptr-logic drivers/char/random.c
--- a/drivers/char/random.c~random-simplify-add_ptr-logic
+++ a/drivers/char/random.c
@@ -454,7 +454,7 @@ static void __add_entropy_words(struct e
 	static __u32 const twist_table[8] = {
 		0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 		0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
-	unsigned long i, add_ptr, tap1, tap2, tap3, tap4, tap5;
+	unsigned long i, j, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
 	__u32 w;
@@ -469,19 +469,21 @@ static void __add_entropy_words(struct e
 
 	spin_lock_irqsave(&r->lock, flags);
 	input_rotate = r->input_rotate;
-	add_ptr = r->add_ptr;
+	i = r->add_ptr;
 
 	while (nwords--) {
 		w = rol32(*in++, input_rotate & 31);
-		i = add_ptr = (add_ptr - 1) & wordmask;
+		i = (i - 1) & wordmask;
 
 		/* XOR in the various taps */
+		w ^= r->pool[i];
 		w ^= r->pool[(i + tap1) & wordmask];
 		w ^= r->pool[(i + tap2) & wordmask];
 		w ^= r->pool[(i + tap3) & wordmask];
 		w ^= r->pool[(i + tap4) & wordmask];
 		w ^= r->pool[(i + tap5) & wordmask];
-		w ^= r->pool[i];
+
+		/* Mix the result back in with a twist */
 		r->pool[i] = (w >> 3) ^ twist_table[w & 7];
 
 		/*
@@ -494,14 +496,11 @@ static void __add_entropy_words(struct e
 	}
 
 	r->input_rotate = input_rotate;
-	r->add_ptr = add_ptr;
+	r->add_ptr = i;
 
-	if (out) {
-		for (i = 0; i < 16; i++) {
-			out[i] = r->pool[add_ptr];
-			add_ptr = (add_ptr - 1) & wordmask;
-		}
-	}
+	if (out)
+		for (j = 0; j < 16; j++)
+			out[j] = r->pool[(i - j) & wordmask];
 
 	spin_unlock_irqrestore(&r->lock, flags);
 }
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch

