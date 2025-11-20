Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E546D364047
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676291; cv=none; b=jgZOCN0lDzeTqTMCrqerE2zzCyZexR1fsXkuYmwM8OtaMcUIxwzSv2T6oS5+b2e6VHzK02QcxpJorVNbgqzVmiar6AP1SaZrr8/uSlL3zNBlGeN7b4G0eqaRNwrhfbQ+m7VI1yeR7BPyvn8+IGw3SqqNoVudhvtzI8cEdtF/mhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676291; c=relaxed/simple;
	bh=C8lxG3dMqPiCvYAsyxGOu/1lKNTneRCIWs+ZaBUgpck=;
	h=Date:To:From:Subject:Message-Id; b=Gz0XcMaDyVSgkCtF2UIH0W4W33vIXNpctQAnVKrhU61q8beDSiPEavknR9U9EqtUEYR+PCBcyKu4HUjk4YndV59SWI00nhVrs4E5b7chf0KePSMH0ODySjIIY5BhQ2H2YrYA9r1b4xBZO6eAxFtyP0QLHNOSXm1KUgFpeG0AEoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v3Bf0vDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v3Bf0vDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C254C113D0;
	Thu, 20 Nov 2025 22:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676290;
	bh=C8lxG3dMqPiCvYAsyxGOu/1lKNTneRCIWs+ZaBUgpck=;
	h=Date:To:From:Subject:From;
	b=v3Bf0vDtePuGubvh6AA8o/Uz+U6TyJ51nP/HhsKajNm6/8HOW0prihmjvCoKzCP3i
	 Fxwek9fhMo9tetsoZgVxdHyF9jTbJbR0jTi0lkfBhGjh1xfcZ53B/T2VfR+VXZwk4+
	 Wnkap5e3++6VVDITS+rKL4ZDfb3A1RHNUmZv2wg4=
Date: Thu, 20 Nov 2025 14:04:49 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,visitorckw@gmail.com,tytso@mit.edu,Slava.Dubeyko@ibm.com,sagi@grimberg.me,kbusch@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,home7438072@gmail.com,hch@lst.de,ebiggers@kernel.org,david.laight.linux@gmail.com,axboe@kernel.dk,409411716@gms.tku.edu.tw,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-base64-rework-encode-decode-for-speed-and-stricter-validation.patch removed from -mm tree
Message-Id: <20251120220450.7C254C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/base64: rework encode/decode for speed and stricter validation
has been removed from the -mm tree.  Its filename was
     lib-base64-rework-encode-decode-for-speed-and-stricter-validation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Subject: lib/base64: rework encode/decode for speed and stricter validation
Date: Fri, 14 Nov 2025 14:01:32 +0800

The old base64 implementation relied on a bit-accumulator loop, which was
slow for larger inputs and too permissive in validation.  It would accept
extra '=', missing '=', or even '=' appearing in the middle of the input,
allowing malformed strings to pass.  This patch reworks the internals to
improve performance and enforce stricter validation.

Changes:
 - Encoder:
   * Process input in 3-byte blocks, mapping 24 bits into four 6-bit
     symbols, avoiding bit-by-bit shifting and reducing loop iterations.
   * Handle the final 1-2 leftover bytes explicitly and emit '=' only when
     requested.
 - Decoder:
   * Based on the reverse lookup tables from the previous patch, decode
     input in 4-character groups.
   * Each group is looked up directly, converted into numeric values, and
     combined into 3 output bytes.
   * Explicitly handle padded and unpadded forms:
      - With padding: input length must be a multiple of 4, and '=' is
        allowed only in the last two positions. Reject stray or early '='.
      - Without padding: validate tail lengths (2 or 3 chars) and require
        unused low bits to be zero.
   * Removed the bit-accumulator style loop to reduce loop iterations.

Performance (x86_64, Intel Core i7-10700 @ 2.90GHz, avg over 1000 runs,
KUnit):

Encode:
  64B   ~90ns   -> ~32ns   (~2.8x)
  1KB  ~1332ns  -> ~510ns  (~2.6x)

Decode:
  64B  ~1530ns  -> ~35ns   (~43.7x)
  1KB ~27726ns  -> ~530ns  (~52.3x)

[akpm@linux-foundation.org: remove u32 casts, per David and Guan-Chun]
Link: https://lkml.kernel.org/r/20251114060132.89279-1-409411716@gms.tku.edu.tw
Co-developed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Co-developed-by: Yu-Sheng Huang <home7438072@gmail.com>
Signed-off-by: Yu-Sheng Huang <home7438072@gmail.com>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Reviewed-by: David Laight <david.laight.linux@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/base64.c |  109 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 68 insertions(+), 41 deletions(-)

--- a/lib/base64.c~lib-base64-rework-encode-decode-for-speed-and-stricter-validation
+++ a/lib/base64.c
@@ -80,28 +80,38 @@ static const s8 base64_rev_maps[][256] =
 int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
 {
 	u32 ac = 0;
-	int bits = 0;
-	int i;
 	char *cp = dst;
 	const char *base64_table = base64_tables[variant];
 
-	for (i = 0; i < srclen; i++) {
-		ac = (ac << 8) | src[i];
-		bits += 8;
-		do {
-			bits -= 6;
-			*cp++ = base64_table[(ac >> bits) & 0x3f];
-		} while (bits >= 6);
-	}
-	if (bits) {
-		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
-		bits -= 6;
+	while (srclen >= 3) {
+		ac = src[0] << 16 | src[1] << 8 | src[2];
+		*cp++ = base64_table[ac >> 18];
+		*cp++ = base64_table[(ac >> 12) & 0x3f];
+		*cp++ = base64_table[(ac >> 6) & 0x3f];
+		*cp++ = base64_table[ac & 0x3f];
+
+		src += 3;
+		srclen -= 3;
 	}
-	if (padding) {
-		while (bits < 0) {
+
+	switch (srclen) {
+	case 2:
+		ac = src[0] << 16 | src[1] << 8;
+		*cp++ = base64_table[ac >> 18];
+		*cp++ = base64_table[(ac >> 12) & 0x3f];
+		*cp++ = base64_table[(ac >> 6) & 0x3f];
+		if (padding)
+			*cp++ = '=';
+		break;
+	case 1:
+		ac = src[0] << 16;
+		*cp++ = base64_table[ac >> 18];
+		*cp++ = base64_table[(ac >> 12) & 0x3f];
+		if (padding) {
+			*cp++ = '=';
 			*cp++ = '=';
-			bits += 2;
 		}
+		break;
 	}
 	return cp - dst;
 }
@@ -117,41 +127,58 @@ EXPORT_SYMBOL_GPL(base64_encode);
  *
  * Decodes a string using the selected Base64 variant.
  *
- * This implementation hasn't been optimized for performance.
- *
  * Return: the length of the resulting decoded binary data in bytes,
  *	   or -1 if the string isn't a valid Base64 string.
  */
 int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base64_variant variant)
 {
-	u32 ac = 0;
-	int bits = 0;
-	int i;
 	u8 *bp = dst;
-	s8 ch;
+	s8 input[4];
+	s32 val;
+	const u8 *s = (const u8 *)src;
+	const s8 *base64_rev_tables = base64_rev_maps[variant];
 
-	for (i = 0; i < srclen; i++) {
-		if (padding) {
-			if (src[i] == '=') {
-				ac = (ac << 6);
-				bits += 6;
-				if (bits >= 8)
-					bits -= 8;
-				continue;
-			}
-		}
-		ch = base64_rev_maps[variant][(u8)src[i]];
-		if (ch == -1)
-			return -1;
-		ac = (ac << 6) | ch;
-		bits += 6;
-		if (bits >= 8) {
-			bits -= 8;
-			*bp++ = (u8)(ac >> bits);
+	while (srclen >= 4) {
+		input[0] = base64_rev_tables[s[0]];
+		input[1] = base64_rev_tables[s[1]];
+		input[2] = base64_rev_tables[s[2]];
+		input[3] = base64_rev_tables[s[3]];
+
+		val = input[0] << 18 | input[1] << 12 | input[2] << 6 | input[3];
+
+		if (unlikely(val < 0)) {
+			if (!padding || srclen != 4 || s[3] != '=')
+				return -1;
+			padding = 0;
+			srclen = s[2] == '=' ? 2 : 3;
+			break;
 		}
+
+		*bp++ = val >> 16;
+		*bp++ = val >> 8;
+		*bp++ = val;
+
+		s += 4;
+		srclen -= 4;
 	}
-	if (ac & ((1 << bits) - 1))
+
+	if (likely(!srclen))
+		return bp - dst;
+	if (padding || srclen == 1)
 		return -1;
+
+	val = (base64_rev_tables[s[0]] << 12) | (base64_rev_tables[s[1]] << 6);
+	*bp++ = val >> 10;
+
+	if (srclen == 2) {
+		if (val & 0x800003ff)
+			return -1;
+	} else {
+		val |= base64_rev_tables[s[2]];
+		if (val & 0x80000003)
+			return -1;
+		*bp++ = val >> 2;
+	}
 	return bp - dst;
 }
 EXPORT_SYMBOL_GPL(base64_decode);
_

Patches currently in -mm which might be from 409411716@gms.tku.edu.tw are


