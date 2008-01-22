From: akpm@linux-foundation.org
Subject: + random-make-backtracking-attacks-harder.patch added to -mm tree
Date: Tue, 22 Jan 2008 01:33:19 -0800
Message-ID: <200801220933.m0M9X02Y014430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51753 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756222AbYAVJdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 04:33:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, tytso@mit.edu


The patch titled
     random: make backtracking attacks harder
has been added to the -mm tree.  Its filename is
     random-make-backtracking-attacks-harder.patch

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
@@ -768,37 +768,35 @@ static void extract_buf(struct entropy_s
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
-
 	hash[0] ^= hash[3];
 	hash[1] ^= hash[4];
 	hash[2] ^= rol32(hash[2], 16);
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
