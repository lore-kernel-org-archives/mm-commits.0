From: akpm@linux-foundation.org
Subject: - random-make-mixing-interface-byte-oriented.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:25 -0700
Message-ID: <200804300548.m3U5mPwv029882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755452AbYD3FtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: make mixing interface byte-oriented
has been removed from the -mm tree.  Its filename was
     random-make-mixing-interface-byte-oriented.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: make mixing interface byte-oriented
From: Matt Mackall <mpm@selenic.com>

Switch add_entropy_words to a byte-oriented interface, eliminating numerous
casts and byte/word size rounding issues.  This also reduces the overall
bit/byte/word confusion in this code.

We now mix a byte at a time into the word-based pool.  This takes four times
as many iterations, but should be negligible compared to hashing overhead. 
This also increases our pool churn, which adds some depth against some
theoretical failure modes.

The function name is changed to emphasize pool mixing and deemphasize entropy
(the samples mixed in may not contain any).  extract is added to the core
function to make it clear that it extracts from the pool.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff -puN drivers/char/random.c~random-make-mixing-interface-byte-oriented drivers/char/random.c
--- a/drivers/char/random.c~random-make-mixing-interface-byte-oriented
+++ a/drivers/char/random.c
@@ -439,7 +439,7 @@ static struct entropy_store nonblocking_
 };
 
 /*
- * This function adds a byte into the entropy "pool".  It does not
+ * This function adds bytes into the entropy "pool".  It does not
  * update the entropy estimate.  The caller should call
  * credit_entropy_store if this is appropriate.
  *
@@ -448,8 +448,8 @@ static struct entropy_store nonblocking_
  * it's cheap to do so and helps slightly in the expected case where
  * the entropy is concentrated in the low-order bits.
  */
-static void __add_entropy_words(struct entropy_store *r, const __u32 *in,
-				int nwords, __u32 out[16])
+static void mix_pool_bytes_extract(struct entropy_store *r, const void *in,
+				   int nbytes, __u8 out[64])
 {
 	static __u32 const twist_table[8] = {
 		0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
@@ -457,6 +457,7 @@ static void __add_entropy_words(struct e
 	unsigned long i, j, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
+	const char *bytes = in;
 	__u32 w;
 	unsigned long flags;
 
@@ -471,8 +472,9 @@ static void __add_entropy_words(struct e
 	input_rotate = r->input_rotate;
 	i = r->add_ptr;
 
-	while (nwords--) {
-		w = rol32(*in++, input_rotate & 31);
+	/* mix one byte at a time to simplify size handling and churn faster */
+	while (nbytes--) {
+		w = rol32(*bytes++, input_rotate & 31);
 		i = (i - 1) & wordmask;
 
 		/* XOR in the various taps */
@@ -500,15 +502,14 @@ static void __add_entropy_words(struct e
 
 	if (out)
 		for (j = 0; j < 16; j++)
-			out[j] = r->pool[(i - j) & wordmask];
+			((__u32 *)out)[j] = r->pool[(i - j) & wordmask];
 
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
-static inline void add_entropy_words(struct entropy_store *r, const __u32 *in,
-				     int nwords)
+static void mix_pool_bytes(struct entropy_store *r, const void *in, int bytes)
 {
-	__add_entropy_words(r, in, nwords, NULL);
+       mix_pool_bytes_extract(r, in, bytes, NULL);
 }
 
 /*
@@ -584,7 +585,7 @@ static void add_timer_randomness(struct 
 	sample.jiffies = jiffies;
 	sample.cycles = get_cycles();
 	sample.num = num;
-	add_entropy_words(&input_pool, (u32 *)&sample, sizeof(sample)/4);
+	mix_pool_bytes(&input_pool, &sample, sizeof(sample));
 
 	/*
 	 * Calculate number of bits of randomness we probably added.
@@ -700,7 +701,7 @@ static void xfer_secondary_pool(struct e
 
 		bytes = extract_entropy(r->pull, tmp, bytes,
 					random_read_wakeup_thresh / 8, rsvd);
-		add_entropy_words(r, tmp, (bytes + 3) / 4);
+		mix_pool_bytes(r, tmp, bytes);
 		credit_entropy_store(r, bytes*8);
 	}
 }
@@ -758,7 +759,8 @@ static size_t account(struct entropy_sto
 static void extract_buf(struct entropy_store *r, __u8 *out)
 {
 	int i;
-	__u32 extract[16], hash[5], workspace[SHA_WORKSPACE_WORDS];
+	__u32 hash[5], workspace[SHA_WORKSPACE_WORDS];
+	__u8 extract[64];
 
 	/* Generate a hash across the pool, 16 words (512 bits) at a time */
 	sha_init(hash);
@@ -774,13 +776,13 @@ static void extract_buf(struct entropy_s
 	 * brute-forcing the feedback as hard as brute-forcing the
 	 * hash.
 	 */
-	__add_entropy_words(r, hash, 5, extract);
+	mix_pool_bytes_extract(r, hash, sizeof(hash), extract);
 
 	/*
 	 * To avoid duplicates, we atomically extract a portion of the
 	 * pool while mixing, and hash one final time.
 	 */
-	sha_transform(hash, (__u8 *)extract, workspace);
+	sha_transform(hash, extract, workspace);
 	memset(extract, 0, sizeof(extract));
 	memset(workspace, 0, sizeof(workspace));
 
@@ -887,9 +889,8 @@ static void init_std_data(struct entropy
 	spin_unlock_irqrestore(&r->lock, flags);
 
 	now = ktime_get_real();
-	add_entropy_words(r, (__u32 *)&now, sizeof(now)/4);
-	add_entropy_words(r, (__u32 *)utsname(),
-			  sizeof(*(utsname()))/4);
+	mix_pool_bytes(r, &now, sizeof(now));
+	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
 }
 
 static int rand_initialize(void)
@@ -1030,7 +1031,7 @@ write_pool(struct entropy_store *r, cons
 		count -= bytes;
 		p += bytes;
 
-		add_entropy_words(r, buf, (bytes + 3) / 4);
+		mix_pool_bytes(r, buf, bytes);
 		cond_resched();
 	}
 
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch

