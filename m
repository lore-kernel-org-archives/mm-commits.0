From: akpm@linux-foundation.org
Subject: - random-improve-variable-naming-clear-extract-buffer.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:13 -0700
Message-ID: <200804300548.m3U5mDd2029864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760625AbYD3GMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: improve variable naming, clear extract buffer
has been removed from the -mm tree.  Its filename was
     random-improve-variable-naming-clear-extract-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -765,9 +765,9 @@ static size_t account(struct entropy_sto
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
@@ -778,9 +778,9 @@ static void extract_buf(struct entropy_s
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
@@ -788,19 +788,21 @@ static void extract_buf(struct entropy_s
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

origin.patch

