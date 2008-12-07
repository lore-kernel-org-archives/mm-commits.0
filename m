From: akpm@linux-foundation.org
Subject: + crypto-replace-private-helper-with-common-unaligned-endian-helper.patch added to -mm tree
Date: Sat, 06 Dec 2008 19:33:16 -0800
Message-ID: <200812070333.mB73XGNb015754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753388AbYLGDdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 22:33:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     crypto: replace private helper with common unaligned endian helper
has been added to the -mm tree.  Its filename is
     crypto-replace-private-helper-with-common-unaligned-endian-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crypto: replace private helper with common unaligned endian helper
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/salsa20_generic.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff -puN crypto/salsa20_generic.c~crypto-replace-private-helper-with-common-unaligned-endian-helper crypto/salsa20_generic.c
--- a/crypto/salsa20_generic.c~crypto-replace-private-helper-with-common-unaligned-endian-helper
+++ a/crypto/salsa20_generic.c
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <crypto/algapi.h>
 #include <asm/byteorder.h>
+#include <asm/unaligned.h>
 
 #define SALSA20_IV_SIZE        8U
 #define SALSA20_MIN_KEY_SIZE  16U
@@ -46,12 +47,6 @@ Public domain.
 #define XOR(v,w) ((v) ^ (w))
 #define PLUS(v,w) (((v) + (w)))
 #define PLUSONE(v) (PLUS((v),1))
-#define U32TO8_LITTLE(p, v) \
-	{ (p)[0] = (v >>  0) & 0xff; (p)[1] = (v >>  8) & 0xff; \
-	  (p)[2] = (v >> 16) & 0xff; (p)[3] = (v >> 24) & 0xff; }
-#define U8TO32_LITTLE(p)   \
-	(((u32)((p)[0])      ) | ((u32)((p)[1]) <<  8) | \
-	 ((u32)((p)[2]) << 16) | ((u32)((p)[3]) << 24)   )
 
 struct salsa20_ctx
 {
@@ -101,7 +96,7 @@ static void salsa20_wordtobyte(u8 output
 	for (i = 0; i < 16; ++i)
 		x[i] = PLUS(x[i],input[i]);
 	for (i = 0; i < 16; ++i)
-		U32TO8_LITTLE(output + 4 * i,x[i]);
+		store_le32_noalign((__le32 *)(output + 4 * i), x[i]);
 }
 
 static const char sigma[16] = "expand 32-byte k";
@@ -111,30 +106,30 @@ static void salsa20_keysetup(struct sals
 {
 	const char *constants;
 
-	ctx->input[1] = U8TO32_LITTLE(k + 0);
-	ctx->input[2] = U8TO32_LITTLE(k + 4);
-	ctx->input[3] = U8TO32_LITTLE(k + 8);
-	ctx->input[4] = U8TO32_LITTLE(k + 12);
+	ctx->input[1] = load_le32_noalign((__le32 *)(k + 0));
+	ctx->input[2] = load_le32_noalign((__le32 *)(k + 4));
+	ctx->input[3] = load_le32_noalign((__le32 *)(k + 8));
+	ctx->input[4] = load_le32_noalign((__le32 *)(k + 12));
 	if (kbytes == 32) { /* recommended */
 		k += 16;
 		constants = sigma;
 	} else { /* kbytes == 16 */
 		constants = tau;
 	}
-	ctx->input[11] = U8TO32_LITTLE(k + 0);
-	ctx->input[12] = U8TO32_LITTLE(k + 4);
-	ctx->input[13] = U8TO32_LITTLE(k + 8);
-	ctx->input[14] = U8TO32_LITTLE(k + 12);
-	ctx->input[0] = U8TO32_LITTLE(constants + 0);
-	ctx->input[5] = U8TO32_LITTLE(constants + 4);
-	ctx->input[10] = U8TO32_LITTLE(constants + 8);
-	ctx->input[15] = U8TO32_LITTLE(constants + 12);
+	ctx->input[11] = load_le32_noalign((__le32 *)(k + 0));
+	ctx->input[12] = load_le32_noalign((__le32 *)(k + 4));
+	ctx->input[13] = load_le32_noalign((__le32 *)(k + 8));
+	ctx->input[14] = load_le32_noalign((__le32 *)(k + 12));
+	ctx->input[0] = load_le32_noalign((__le32 *)(constants + 0));
+	ctx->input[5] = load_le32_noalign((__le32 *)(constants + 4));
+	ctx->input[10] = load_le32_noalign((__le32 *)(constants + 8));
+	ctx->input[15] = load_le32_noalign((__le32 *)(constants + 12));
 }
 
 static void salsa20_ivsetup(struct salsa20_ctx *ctx, const u8 *iv)
 {
-	ctx->input[6] = U8TO32_LITTLE(iv + 0);
-	ctx->input[7] = U8TO32_LITTLE(iv + 4);
+	ctx->input[6] = load_le32_noalign((__le32 *)(iv + 0));
+	ctx->input[7] = load_le32_noalign((__le32 *)(iv + 4));
 	ctx->input[8] = 0;
 	ctx->input[9] = 0;
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
arm-use-the-new-byteorder-headers.patch
i2c-misannotation-in-i2c-pmcmspc.patch
i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
input-strict_strtoul-takes-unsigned-long.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
frv-use-the-new-byteorder-headers.patch
m68knommu-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
lib-fix-sparse-shadowed-variable-warning.patch
lib-radix_treec-make-percpu-variable-static.patch
lib-proportionsc-trivial-sparse-lock-annotation.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
memstick-annotate-endianness-of-attribute-structs.patch
byteorder-add-load_-store_endian-api.patch
unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch
unaligned-wire-up-h8300-and-m32r-arches.patch
unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch
unaligned-remove-the-old-implementation.patch
ata-replace-byteshifting-with-unaligned-endian-helpers.patch
crypto-replace-private-helper-with-common-unaligned-endian-helper.patch

