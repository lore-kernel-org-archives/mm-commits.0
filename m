From: akpm@linux-foundation.org
Subject: + random-make-mixing-interface-byte-oriented.patch added to -mm tree
Date: Tue, 22 Jan 2008 01:33:26 -0800
Message-ID: <200801220933.m0M9X7NH014459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756288AbYAVJdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 04:33:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, tytso@mit.edu


The patch titled
     random: make mixing interface byte-oriented
has been added to the -mm tree.  Its filename is
     random-make-mixing-interface-byte-oriented.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -701,7 +702,7 @@ static void xfer_secondary_pool(struct e
 
 		bytes = extract_entropy(r->pull, tmp, bytes,
 					random_read_wakeup_thresh / 8, rsvd);
-		add_entropy_words(r, tmp, (bytes + 3) / 4);
+		mix_pool_bytes(r, tmp, bytes);
 		credit_entropy_store(r, bytes*8);
 	}
 }
@@ -759,7 +760,8 @@ static size_t account(struct entropy_sto
 static void extract_buf(struct entropy_store *r, __u8 *out)
 {
 	int i;
-	__u32 extract[16], hash[5], workspace[SHA_WORKSPACE_WORDS];
+	__u32 hash[5], workspace[SHA_WORKSPACE_WORDS];
+	__u8 extract[64];
 
 	/* Generate a hash across the pool, 16 words (512 bits) at a time */
 	sha_init(hash);
@@ -775,13 +777,13 @@ static void extract_buf(struct entropy_s
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
 
@@ -888,9 +890,8 @@ static void init_std_data(struct entropy
 	spin_unlock_irqrestore(&r->lock, flags);
 
 	now = ktime_get_real();
-	add_entropy_words(r, (__u32 *)&now, sizeof(now)/4);
-	add_entropy_words(r, (__u32 *)utsname(),
-			  sizeof(*(utsname()))/4);
+	mix_pool_bytes(r, &now, sizeof(now));
+	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
 }
 
 static int rand_initialize(void)
@@ -1031,7 +1032,7 @@ write_pool(struct entropy_store *r, cons
 		count -= bytes;
 		p += bytes;
 
-		add_entropy_words(r, buf, (bytes + 3) / 4);
+		mix_pool_bytes(r, buf, bytes);
 		cond_resched();
 	}
 
_

Patches currently in -mm which might be from mpm@selenic.com are

git-x86.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-pid-pagemap-interface-fix.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpagecount-interface-fix.patch
maps4-add-proc-kpageflags-interface.patch
maps4-add-proc-kpageflags-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix-2.patch
maps4-add-proc-kpageflags-interface-fix-2-fix.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
remove-unused-code-from-mm-tiny-shmemc.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
random-clean-up-checkpatch-complaints.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
