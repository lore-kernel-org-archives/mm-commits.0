From: akpm@linux-foundation.org
Subject: + crypto-rmd128c-sparse-annotations.patch added to -mm tree
Date: Thu, 03 Jul 2008 16:03:14 -0700
Message-ID: <200807032303.m63N3EKn031949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693AbYGCXET (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jul 2008 19:04:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, herbert@gondor.apana.org.au


The patch titled
     crypto: rmd128.c sparse annotations
has been added to the -mm tree.  Its filename is
     crypto-rmd128c-sparse-annotations.patch

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
Subject: crypto: rmd128.c sparse annotations
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/rmd128.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN crypto/rmd128.c~crypto-rmd128c-sparse-annotations crypto/rmd128.c
--- a/crypto/rmd128.c~crypto-rmd128c-sparse-annotations
+++ a/crypto/rmd128.c
@@ -26,7 +26,7 @@
 struct rmd128_ctx {
 	u64 byte_count;
 	u32 state[4];
-	u32 buffer[16];
+	__le32 buffer[16];
 };
 
 #define K1  RMD_K1
@@ -48,7 +48,7 @@ struct rmd128_ctx {
 	(a) = rol32((a), (s)); \
 }
 
-static void rmd128_transform(u32 *state, u32 const *in)
+static void rmd128_transform(u32 *state, const __le32 *in)
 {
 	u32 aa, bb, cc, dd, aaa, bbb, ccc, ddd;
 
@@ -269,8 +269,8 @@ static void rmd128_final(struct crypto_t
 {
 	struct rmd128_ctx *rctx = crypto_tfm_ctx(tfm);
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
block-use-get_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
crypto-use-kernel-provided-bitops-unaligned-access-helpers.patch
crypto-rmd128c-sparse-annotations.patch
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

