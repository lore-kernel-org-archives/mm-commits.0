From: akpm@linux-foundation.org
Subject: + crypto-use-kernel-provided-bitops-unaligned-access-helpers.patch added to -mm tree
Date: Thu, 03 Jul 2008 16:03:12 -0700
Message-ID: <200807032303.m63N3CcA031946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755770AbYGCXET (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jul 2008 19:04:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, herbert@gondor.apana.org.au


The patch titled
     crypto: use kernel-provided bitops, unaligned access helpers
has been added to the -mm tree.  Its filename is
     crypto-use-kernel-provided-bitops-unaligned-access-helpers.patch

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
Subject: crypto: use kernel-provided bitops, unaligned access helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Remove the private implementation of 32-bit rotation and unaligned access
with byteswapping.

As a bonus, fixes sparse warnings:
crypto/camellia.c:602:2: warning: cast to restricted __be32
crypto/camellia.c:603:2: warning: cast to restricted __be32
crypto/camellia.c:604:2: warning: cast to restricted __be32
crypto/camellia.c:605:2: warning: cast to restricted __be32
crypto/camellia.c:710:2: warning: cast to restricted __be32
crypto/camellia.c:711:2: warning: cast to restricted __be32
crypto/camellia.c:712:2: warning: cast to restricted __be32
crypto/camellia.c:713:2: warning: cast to restricted __be32
crypto/camellia.c:714:2: warning: cast to restricted __be32
crypto/camellia.c:715:2: warning: cast to restricted __be32
crypto/camellia.c:716:2: warning: cast to restricted __be32
crypto/camellia.c:717:2: warning: cast to restricted __be32

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/camellia.c |   84 ++++++++++++++++++--------------------------
 1 file changed, 36 insertions(+), 48 deletions(-)

diff -puN crypto/camellia.c~crypto-use-kernel-provided-bitops-unaligned-access-helpers crypto/camellia.c
--- a/crypto/camellia.c~crypto-use-kernel-provided-bitops-unaligned-access-helpers
+++ a/crypto/camellia.c
@@ -35,6 +35,8 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/bitops.h>
+#include <asm/unaligned.h>
 
 static const u32 camellia_sp1110[256] = {
 	0x70707000,0x82828200,0x2c2c2c00,0xececec00,
@@ -335,20 +337,6 @@ static const u32 camellia_sp4404[256] = 
 /*
  *  macros
  */
-#define GETU32(v, pt) \
-    do { \
-	/* latest breed of gcc is clever enough to use move */ \
-	memcpy(&(v), (pt), 4); \
-	(v) = be32_to_cpu(v); \
-    } while(0)
-
-/* rotation right shift 1byte */
-#define ROR8(x) (((x) >> 8) + ((x) << 24))
-/* rotation left shift 1bit */
-#define ROL1(x) (((x) << 1) + ((x) >> 31))
-/* rotation left shift 1byte */
-#define ROL8(x) (((x) << 8) + ((x) >> 24))
-
 #define ROLDQ(ll, lr, rl, rr, w0, w1, bits)		\
     do {						\
 	w0 = ll;					\
@@ -383,7 +371,7 @@ static const u32 camellia_sp4404[256] = 
 	   ^ camellia_sp3033[(u8)(il >> 8)]			\
 	   ^ camellia_sp4404[(u8)(il     )];			\
 	yl ^= yr;						\
-	yr = ROR8(yr);						\
+	yr = ror32(yr, 8);					\
 	yr ^= yl;						\
     } while(0)
 
@@ -405,7 +393,7 @@ static void camellia_setup_tail(u32 *sub
 	subL[7] ^= subL[1]; subR[7] ^= subR[1];
 	subL[1] ^= subR[1] & ~subR[9];
 	dw = subL[1] & subL[9],
-		subR[1] ^= ROL1(dw); /* modified for FLinv(kl2) */
+		subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl2) */
 	/* round 8 */
 	subL[11] ^= subL[1]; subR[11] ^= subR[1];
 	/* round 10 */
@@ -414,7 +402,7 @@ static void camellia_setup_tail(u32 *sub
 	subL[15] ^= subL[1]; subR[15] ^= subR[1];
 	subL[1] ^= subR[1] & ~subR[17];
 	dw = subL[1] & subL[17],
-		subR[1] ^= ROL1(dw); /* modified for FLinv(kl4) */
+		subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl4) */
 	/* round 14 */
 	subL[19] ^= subL[1]; subR[19] ^= subR[1];
 	/* round 16 */
@@ -430,7 +418,7 @@ static void camellia_setup_tail(u32 *sub
 	} else {
 		subL[1] ^= subR[1] & ~subR[25];
 		dw = subL[1] & subL[25],
-			subR[1] ^= ROL1(dw); /* modified for FLinv(kl6) */
+			subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl6) */
 		/* round 20 */
 		subL[27] ^= subL[1]; subR[27] ^= subR[1];
 		/* round 22 */
@@ -450,7 +438,7 @@ static void camellia_setup_tail(u32 *sub
 		subL[26] ^= kw4l; subR[26] ^= kw4r;
 		kw4l ^= kw4r & ~subR[24];
 		dw = kw4l & subL[24],
-			kw4r ^= ROL1(dw); /* modified for FL(kl5) */
+			kw4r ^= rol32(dw, 1); /* modified for FL(kl5) */
 	}
 	/* round 17 */
 	subL[22] ^= kw4l; subR[22] ^= kw4r;
@@ -460,7 +448,7 @@ static void camellia_setup_tail(u32 *sub
 	subL[18] ^= kw4l; subR[18] ^= kw4r;
 	kw4l ^= kw4r & ~subR[16];
 	dw = kw4l & subL[16],
-		kw4r ^= ROL1(dw); /* modified for FL(kl3) */
+		kw4r ^= rol32(dw, 1); /* modified for FL(kl3) */
 	/* round 11 */
 	subL[14] ^= kw4l; subR[14] ^= kw4r;
 	/* round 9 */
@@ -469,7 +457,7 @@ static void camellia_setup_tail(u32 *sub
 	subL[10] ^= kw4l; subR[10] ^= kw4r;
 	kw4l ^= kw4r & ~subR[8];
 	dw = kw4l & subL[8],
-		kw4r ^= ROL1(dw); /* modified for FL(kl1) */
+		kw4r ^= rol32(dw, 1); /* modified for FL(kl1) */
 	/* round 5 */
 	subL[6] ^= kw4l; subR[6] ^= kw4r;
 	/* round 3 */
@@ -494,7 +482,7 @@ static void camellia_setup_tail(u32 *sub
 	SUBKEY_R(6) = subR[5] ^ subR[7];
 	tl = subL[10] ^ (subR[10] & ~subR[8]);
 	dw = tl & subL[8],  /* FL(kl1) */
-		tr = subR[10] ^ ROL1(dw);
+		tr = subR[10] ^ rol32(dw, 1);
 	SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
 	SUBKEY_R(7) = subR[6] ^ tr;
 	SUBKEY_L(8) = subL[8];       /* FL(kl1) */
@@ -503,7 +491,7 @@ static void camellia_setup_tail(u32 *sub
 	SUBKEY_R(9) = subR[9];
 	tl = subL[7] ^ (subR[7] & ~subR[9]);
 	dw = tl & subL[9],  /* FLinv(kl2) */
-		tr = subR[7] ^ ROL1(dw);
+		tr = subR[7] ^ rol32(dw, 1);
 	SUBKEY_L(10) = tl ^ subL[11]; /* round 7 */
 	SUBKEY_R(10) = tr ^ subR[11];
 	SUBKEY_L(11) = subL[10] ^ subL[12]; /* round 8 */
@@ -516,7 +504,7 @@ static void camellia_setup_tail(u32 *sub
 	SUBKEY_R(14) = subR[13] ^ subR[15];
 	tl = subL[18] ^ (subR[18] & ~subR[16]);
 	dw = tl & subL[16], /* FL(kl3) */
-		tr = subR[18] ^ ROL1(dw);
+		tr = subR[18] ^ rol32(dw, 1);
 	SUBKEY_L(15) = subL[14] ^ tl; /* round 12 */
 	SUBKEY_R(15) = subR[14] ^ tr;
 	SUBKEY_L(16) = subL[16];     /* FL(kl3) */
@@ -525,7 +513,7 @@ static void camellia_setup_tail(u32 *sub
 	SUBKEY_R(17) = subR[17];
 	tl = subL[15] ^ (subR[15] & ~subR[17]);
 	dw = tl & subL[17], /* FLinv(kl4) */
-		tr = subR[15] ^ ROL1(dw);
+		tr = subR[15] ^ rol32(dw, 1);
 	SUBKEY_L(18) = tl ^ subL[19]; /* round 13 */
 	SUBKEY_R(18) = tr ^ subR[19];
 	SUBKEY_L(19) = subL[18] ^ subL[20]; /* round 14 */
@@ -544,7 +532,7 @@ static void camellia_setup_tail(u32 *sub
 	} else {
 		tl = subL[26] ^ (subR[26] & ~subR[24]);
 		dw = tl & subL[24], /* FL(kl5) */
-			tr = subR[26] ^ ROL1(dw);
+			tr = subR[26] ^ rol32(dw, 1);
 		SUBKEY_L(23) = subL[22] ^ tl; /* round 18 */
 		SUBKEY_R(23) = subR[22] ^ tr;
 		SUBKEY_L(24) = subL[24];     /* FL(kl5) */
@@ -553,7 +541,7 @@ static void camellia_setup_tail(u32 *sub
 		SUBKEY_R(25) = subR[25];
 		tl = subL[23] ^ (subR[23] & ~subR[25]);
 		dw = tl & subL[25], /* FLinv(kl6) */
-			tr = subR[23] ^ ROL1(dw);
+			tr = subR[23] ^ rol32(dw, 1);
 		SUBKEY_L(26) = tl ^ subL[27]; /* round 19 */
 		SUBKEY_R(26) = tr ^ subR[27];
 		SUBKEY_L(27) = subL[26] ^ subL[28]; /* round 20 */
@@ -573,17 +561,17 @@ static void camellia_setup_tail(u32 *sub
 	/* apply the inverse of the last half of P-function */
 	i = 2;
 	do {
-		dw = SUBKEY_L(i + 0) ^ SUBKEY_R(i + 0); dw = ROL8(dw);/* round 1 */
+		dw = SUBKEY_L(i + 0) ^ SUBKEY_R(i + 0); dw = rol32(dw, 8);/* round 1 */
 		SUBKEY_R(i + 0) = SUBKEY_L(i + 0) ^ dw; SUBKEY_L(i + 0) = dw;
-		dw = SUBKEY_L(i + 1) ^ SUBKEY_R(i + 1); dw = ROL8(dw);/* round 2 */
+		dw = SUBKEY_L(i + 1) ^ SUBKEY_R(i + 1); dw = rol32(dw, 8);/* round 2 */
 		SUBKEY_R(i + 1) = SUBKEY_L(i + 1) ^ dw; SUBKEY_L(i + 1) = dw;
-		dw = SUBKEY_L(i + 2) ^ SUBKEY_R(i + 2); dw = ROL8(dw);/* round 3 */
+		dw = SUBKEY_L(i + 2) ^ SUBKEY_R(i + 2); dw = rol32(dw, 8);/* round 3 */
 		SUBKEY_R(i + 2) = SUBKEY_L(i + 2) ^ dw; SUBKEY_L(i + 2) = dw;
-		dw = SUBKEY_L(i + 3) ^ SUBKEY_R(i + 3); dw = ROL8(dw);/* round 4 */
+		dw = SUBKEY_L(i + 3) ^ SUBKEY_R(i + 3); dw = rol32(dw, 8);/* round 4 */
 		SUBKEY_R(i + 3) = SUBKEY_L(i + 3) ^ dw; SUBKEY_L(i + 3) = dw;
-		dw = SUBKEY_L(i + 4) ^ SUBKEY_R(i + 4); dw = ROL8(dw);/* round 5 */
+		dw = SUBKEY_L(i + 4) ^ SUBKEY_R(i + 4); dw = rol32(dw, 9);/* round 5 */
 		SUBKEY_R(i + 4) = SUBKEY_L(i + 4) ^ dw; SUBKEY_L(i + 4) = dw;
-		dw = SUBKEY_L(i + 5) ^ SUBKEY_R(i + 5); dw = ROL8(dw);/* round 6 */
+		dw = SUBKEY_L(i + 5) ^ SUBKEY_R(i + 5); dw = rol32(dw, 8);/* round 6 */
 		SUBKEY_R(i + 5) = SUBKEY_L(i + 5) ^ dw; SUBKEY_L(i + 5) = dw;
 		i += 8;
 	} while (i < max);
@@ -599,10 +587,10 @@ static void camellia_setup128(const unsi
 	/**
 	 *  k == kll || klr || krl || krr (|| is concatenation)
 	 */
-	GETU32(kll, key     );
-	GETU32(klr, key +  4);
-	GETU32(krl, key +  8);
-	GETU32(krr, key + 12);
+	kll = get_unaligned_be32(key);
+	klr = get_unaligned_be32(key + 4);
+	krl = get_unaligned_be32(key + 8);
+	krr = get_unaligned_be32(key + 12);
 
 	/* generate KL dependent subkeys */
 	/* kw1 */
@@ -707,14 +695,14 @@ static void camellia_setup256(const unsi
 	 *  key = (kll || klr || krl || krr || krll || krlr || krrl || krrr)
 	 *  (|| is concatenation)
 	 */
-	GETU32(kll,  key     );
-	GETU32(klr,  key +  4);
-	GETU32(krl,  key +  8);
-	GETU32(krr,  key + 12);
-	GETU32(krll, key + 16);
-	GETU32(krlr, key + 20);
-	GETU32(krrl, key + 24);
-	GETU32(krrr, key + 28);
+	kll = get_unaligned_be32(key);
+	klr = get_unaligned_be32(key + 4);
+	krl = get_unaligned_be32(key + 8);
+	krr = get_unaligned_be32(key + 12);
+	krll = get_unaligned_be32(key + 16);
+	krlr = get_unaligned_be32(key + 20);
+	krrl = get_unaligned_be32(key + 24);
+	krrr = get_unaligned_be32(key + 28);
 
 	/* generate KL dependent subkeys */
 	/* kw1 */
@@ -870,13 +858,13 @@ static void camellia_setup192(const unsi
 	t0 &= ll;							\
 	t2 |= rr;							\
 	rl ^= t2;							\
-	lr ^= ROL1(t0);							\
+	lr ^= rol32(t0, 1);						\
 	t3 = krl;							\
 	t1 = klr;							\
 	t3 &= rl;							\
 	t1 |= lr;							\
 	ll ^= t1;							\
-	rr ^= ROL1(t3);							\
+	rr ^= rol32(t3, 1);						\
     } while(0)
 
 #define CAMELLIA_ROUNDSM(xl, xr, kl, kr, yl, yr, il, ir)		\
@@ -892,7 +880,7 @@ static void camellia_setup192(const unsi
 	il ^= kl;							\
 	ir ^= il ^ kr;							\
 	yl ^= ir;							\
-	yr ^= ROR8(il) ^ ir;						\
+	yr ^= ror32(il, 8) ^ ir;						\
     } while(0)
 
 /* max = 24: 128bit encrypt, max = 32: 256bit encrypt */
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

