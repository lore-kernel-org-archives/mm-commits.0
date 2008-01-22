From: akpm@linux-foundation.org
Subject: + random-improve-variable-naming-clear-extract-buffer.patch added to -mm tree
Date: Tue, 22 Jan 2008 01:33:17 -0800
Message-ID: <200801220932.m0M9Wwh1014427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35011 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942AbYAVJdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 04:33:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, tytso@mit.edu


The patch titled
     random: improve variable naming, clear extract buffer
has been added to the -mm tree.  Its filename is
     random-improve-variable-naming-clear-extract-buffer.patch

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
Subject: random: improve variable naming, clear extract buffer
From: Matt Mackall <mpm@selenic.com>

- split the SHA variables apart into hash and workspace
- rename data to extract
- wipe extract and workspace after hashing

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN drivers/char/random.c~random-improve-variable-naming-clear-extract-buffer drivers/char/random.c
--- a/drivers/char/random.c~random-improve-variable-naming-clear-extract-buffer
+++ a/drivers/char/random.c
@@ -766,9 +766,9 @@ static size_t account(struct entropy_sto
 static void extract_buf(struct entropy_store *r, __u8 *out)
 {
 	int i;
-	__u32 data[16], buf[5 + SHA_WORKSPACE_WORDS];
+	__u32 extract[16], hash[5], workspace[SHA_WORKSPACE_WORDS];
 
-	sha_init(buf);
+	sha_init(hash);
 	/*
 	 * As we hash the pool, we mix intermediate values of
 	 * the hash back into the pool.  This eliminates
@@ -779,9 +779,9 @@ static void extract_buf(struct entropy_s
 	 */
 	for (i = 0; i < r->poolinfo->poolwords; i += 16) {
 		/* hash blocks of 16 words = 512 bits */
-		sha_transform(buf, (__u8 *)(r->pool + i), buf + 5);
+		sha_transform(hash, (__u8 *)(r->pool + i), workspace);
 		/* feed back portion of the resulting hash */
-		add_entropy_words(r, &buf[i % 5], 1);
+		add_entropy_words(r, &hash[i % 5], 1);
 	}
 
 	/*
@@ -789,19 +789,21 @@ static void extract_buf(struct entropy_s
 	 * portion of the pool while mixing, and hash one
 	 * final time.
 	 */
-	__add_entropy_words(r, &buf[i % 5], 1, data);
-	sha_transform(buf, (__u8 *)data, buf + 5);
+	__add_entropy_words(r, &hash[i % 5], 1, extract);
+	sha_transform(hash, (__u8 *)extract, workspace);
+	memset(extract, 0, sizeof(extract));
+	memset(workspace, 0, sizeof(workspace));
 
 	/*
 	 * In case the hash function has some recognizable
 	 * output pattern, we fold it in half.
 	 */
 
-	buf[0] ^= buf[3];
-	buf[1] ^= buf[4];
-	buf[2] ^= rol32(buf[2], 16);
-	memcpy(out, buf, EXTRACT_SIZE);
-	memset(buf, 0, sizeof(buf));
+	hash[0] ^= hash[3];
+	hash[1] ^= hash[4];
+	hash[2] ^= rol32(hash[2], 16);
+	memcpy(out, hash, EXTRACT_SIZE);
+	memset(hash, 0, sizeof(hash));
 }
 
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
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
