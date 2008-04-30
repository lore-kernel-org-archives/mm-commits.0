From: akpm@linux-foundation.org
Subject: - random-make-backtracking-attacks-harder.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:15 -0700
Message-ID: <200804300548.m3U5mFts029867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760667AbYD3GMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: make backtracking attacks harder
has been removed from the -mm tree.  Its filename was
     random-make-backtracking-attacks-harder.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: make backtracking attacks harder
From: Matt Mackall <mpm@selenic.com>

At each extraction, we change (poolbits / 16) + 32 bits in the pool,
or 96 bits in the case of the secondary pools. Thus, a brute-force
backtracking attack on the pool state is less difficult than breaking
the hash. In certain cases, this difficulty may be is reduced to 2^64
iterations.

Instead, hash the entire pool in one go, then feedback the whole hash
(160 bits) in one go. This will make backtracking at least as hard as
inverting the hash.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff -puN drivers/char/random.c~random-make-backtracking-attacks-harder drivers/char/random.c
--- a/drivers/char/random.c~random-make-backtracking-attacks-harder
+++ a/drivers/char/random.c
@@ -767,37 +767,35 @@ static void extract_buf(struct entropy_s
 	int i;
 	__u32 extract[16], hash[5], workspace[SHA_WORKSPACE_WORDS];
 
+	/* Generate a hash across the pool, 16 words (512 bits) at a time */
 	sha_init(hash);
+	for (i = 0; i < r->poolinfo->poolwords; i += 16)
+		sha_transform(hash, (__u8 *)(r->pool + i), workspace);
+
 	/*
-	 * As we hash the pool, we mix intermediate values of
-	 * the hash back into the pool.  This eliminates
-	 * backtracking attacks (where the attacker knows
-	 * the state of the pool plus the current outputs, and
-	 * attempts to find previous ouputs), unless the hash
-	 * function can be inverted.
+	 * We mix the hash back into the pool to prevent backtracking
+	 * attacks (where the attacker knows the state of the pool
+	 * plus the current outputs, and attempts to find previous
+	 * ouputs), unless the hash function can be inverted. By
+	 * mixing at least a SHA1 worth of hash data back, we make
+	 * brute-forcing the feedback as hard as brute-forcing the
+	 * hash.
 	 */
-	for (i = 0; i < r->poolinfo->poolwords; i += 16) {
-		/* hash blocks of 16 words = 512 bits */
-		sha_transform(hash, (__u8 *)(r->pool + i), workspace);
-		/* feed back portion of the resulting hash */
-		add_entropy_words(r, &hash[i % 5], 1);
-	}
+	__add_entropy_words(r, hash, 5, extract);
 
 	/*
-	 * To avoid duplicates, we atomically extract a
-	 * portion of the pool while mixing, and hash one
-	 * final time.
+	 * To avoid duplicates, we atomically extract a portion of the
+	 * pool while mixing, and hash one final time.
 	 */
-	__add_entropy_words(r, &hash[i % 5], 1, extract);
 	sha_transform(hash, (__u8 *)extract, workspace);
 	memset(extract, 0, sizeof(extract));
 	memset(workspace, 0, sizeof(workspace));
 
 	/*
-	 * In case the hash function has some recognizable
-	 * output pattern, we fold it in half.
+	 * In case the hash function has some recognizable output
+	 * pattern, we fold it in half. Thus, we always feed back
+	 * twice as much data as we output.
 	 */
