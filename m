From: akpm@linux-foundation.org
Subject: - crypto-rmd160c-rmd256c-rmd320c-sparse-annotations.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:52:01 -0700
Message-ID: <200807112352.m6BNq1Bs011091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755656AbYGKXwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     crypto: rmd160.c rmd256.c rmd320.c sparse annotations
has been removed from the -mm tree.  Its filename was
     crypto-rmd160c-rmd256c-rmd320c-sparse-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crypto: rmd160.c rmd256.c rmd320.c sparse annotations
From: Harvey Harrison <harvey.harrison@gmail.com>

Similar to the rmd128.c annotations, significantly cuts down on the noise.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/rmd160.c |    8 ++++----
 crypto/rmd256.c |    8 ++++----
 crypto/rmd320.c |    8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff -puN crypto/rmd160.c~crypto-rmd160c-rmd256c-rmd320c-sparse-annotations crypto/rmd160.c
--- a/crypto/rmd160.c~crypto-rmd160c-rmd256c-rmd320c-sparse-annotations
+++ a/crypto/rmd160.c
@@ -26,7 +26,7 @@
 struct rmd160_ctx {
 	u64 byte_count;
 	u32 state[5];
-	u32 buffer[16];
+	__le32 buffer[16];
 };
 
 #define K1  RMD_K1
@@ -52,7 +52,7 @@ struct rmd160_ctx {
 	(c) = rol32((c), 10); \
 }
 
-static void rmd160_transform(u32 *state, u32 const *in)
+static void rmd160_transform(u32 *state, const __le32 *in)
 {
 	u32 aa, bb, cc, dd, ee, aaa, bbb, ccc, ddd, eee;
 
@@ -313,8 +313,8 @@ static void rmd160_final(struct crypto_t
 {
 	struct rmd160_ctx *rctx = crypto_tfm_ctx(tfm);
 	u32 i, index, padlen;
-	u64 bits;
-	u32 *dst = (u32 *)out;
+	__le64 bits;
+	__le32 *dst = (__le32 *)out;
 	static const u8 padding[64] = { 0x80, };
 
 	bits = cpu_to_le64(rctx->byte_count << 3);
diff -puN crypto/rmd256.c~crypto-rmd160c-rmd256c-rmd320c-sparse-annotations crypto/rmd256.c
--- a/crypto/rmd256.c~crypto-rmd160c-rmd256c-rmd320c-sparse-annotations
+++ a/crypto/rmd256.c
@@ -26,7 +26,7 @@
 struct rmd256_ctx {
 	u64 byte_count;
 	u32 state[8];
-	u32 buffer[16];
+	__le32 buffer[16];
 };
 
 #define K1  RMD_K1
@@ -48,7 +48,7 @@ struct rmd256_ctx {
 	(a) = rol32((a), (s)); \
 }
 
-static void rmd256_transform(u32 *state, u32 const *in)
+static void rmd256_transform(u32 *state, const __le32 *in)
 {
 	u32 aa, bb, cc, dd, aaa, bbb, ccc, ddd, tmp;
 
@@ -288,8 +288,8 @@ static void rmd256_final(struct crypto_t
 {
 	struct rmd256_ctx *rctx = crypto_tfm_ctx(tfm);
 	u32 i, index, padlen;
-	u64 bits;
-	u32 *dst = (u32 *)out;
+	__le64 bits;
+	__le32 *dst = (__le32 *)out;
 	static const u8 padding[64] = { 0x80, };
 
 	bits = cpu_to_le64(rctx->byte_count << 3);
diff -puN crypto/rmd320.c~crypto-rmd160c-rmd256c-rmd320c-sparse-annotations crypto/rmd320.c
--- a/crypto/rmd320.c~crypto-rmd160c-rmd256c-rmd320c-sparse-annotations
+++ a/crypto/rmd320.c
@@ -26,7 +26,7 @@
 struct rmd320_ctx {
 	u64 byte_count;
 	u32 state[10];
-	u32 buffer[16];
+	__le32 buffer[16];
 };
 
 #define K1  RMD_K1
@@ -52,7 +52,7 @@ struct rmd320_ctx {
 	(c) = rol32((c), 10); \
 }
 
-static void rmd320_transform(u32 *state, u32 const *in)
+static void rmd320_transform(u32 *state, const __le32 *in)
 {
 	u32 aa, bb, cc, dd, ee, aaa, bbb, ccc, ddd, eee, tmp;
 
@@ -337,8 +337,8 @@ static void rmd320_final(struct crypto_t
 {
 	struct rmd320_ctx *rctx = crypto_tfm_ctx(tfm);
 	u32 i, index, padlen;
-	u64 bits;
-	u32 *dst = (u32 *)out;
+	__le64 bits;
+	__le32 *dst = (__le32 *)out;
 	static const u8 padding[64] = { 0x80, };
 
 	bits = cpu_to_le64(rctx->byte_count << 3);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
cifs-remove-global_extern-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
ecryptfs-cryptoc-use-unaligned-byteorder-helpers.patch
ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

