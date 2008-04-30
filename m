From: akpm@linux-foundation.org
Subject: - random-eliminate-redundant-new_rotate-variable.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:19 -0700
Message-ID: <200804300548.m3U5mJ9H029873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758657AbYD3Fs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: eliminate redundant new_rotate variable
has been removed from the -mm tree.  Its filename was
     random-eliminate-redundant-new_rotate-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: eliminate redundant new_rotate variable
From: Matt Mackall <mpm@selenic.com>

- eliminate new_rotate
- move input_rotate masking
- simplify input_rotate update
- move input_rotate update to end of inner loop for readability

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/char/random.c~random-eliminate-redundant-new_rotate-variable drivers/char/random.c
--- a/drivers/char/random.c~random-eliminate-redundant-new_rotate-variable
+++ a/drivers/char/random.c
@@ -455,7 +455,7 @@ static void __add_entropy_words(struct e
 		0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 		0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
 	unsigned long i, add_ptr, tap1, tap2, tap3, tap4, tap5;
-	int new_rotate, input_rotate;
+	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
 	__u32 w, next_w;
 	unsigned long flags;
@@ -474,20 +474,10 @@ static void __add_entropy_words(struct e
 	add_ptr = r->add_ptr;
 
 	while (nwords--) {
-		w = rol32(next_w, input_rotate);
+		w = rol32(next_w, input_rotate & 31);
 		if (nwords > 0)
 			next_w = *in++;
 		i = add_ptr = (add_ptr - 1) & wordmask;
-		/*
-		 * Normally, we add 7 bits of rotation to the pool.
-		 * At the beginning of the pool, add an extra 7 bits
-		 * rotation, so that successive passes spread the
-		 * input bits across the pool evenly.
-		 */
-		new_rotate = input_rotate + 14;
-		if (i)
-			new_rotate = input_rotate + 7;
-		input_rotate = new_rotate & 31;
 
 		/* XOR in the various taps */
 		w ^= r->pool[(i + tap1) & wordmask];
@@ -497,6 +487,14 @@ static void __add_entropy_words(struct e
 		w ^= r->pool[(i + tap5) & wordmask];
 		w ^= r->pool[i];
 		r->pool[i] = (w >> 3) ^ twist_table[w & 7];
+
+		/*
+		 * Normally, we add 7 bits of rotation to the pool.
+		 * At the beginning of the pool, add an extra 7 bits
+		 * rotation, so that successive passes spread the
+		 * input bits across the pool evenly.
+		 */
+		input_rotate += i ? 7 : 14;
 	}
 
 	r->input_rotate = input_rotate;
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch

