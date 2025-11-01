Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986602727FE
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 04:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761970223; cv=none; b=Yhzy9F5/uwfzZr+uku3rQ9hbg9md9uXQhRZWpzNZXQvhaVNGH7rKd+XFA4swBR0RTRuG1zMsnhLgwdQgnIkvfl9go2MnIdqXrrD9Xq7vb416wEV5qrFfTEPaqSKcncIaz33pe8PBti6LdmOAKEiUFaA65PL1OmKRgLO7PgZz6TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761970223; c=relaxed/simple;
	bh=bpKYTPEU/yxrj+o6M2O1sO3IGPIgcsi2g7qtF6SGieA=;
	h=Date:To:From:Subject:Message-Id; b=QdMrl/sQzyQv1hcZoeANpKY3wqliVed47sCocP230W7Vtn8PRYB6Bj6iVD7C9zGHs4c0IY4RRozS86XCBMDr9SZLS/nCMJ/0iTzqTFgre4WRgF8qn5L62gRa9z32jPDEK8IZz3rTzk61DYp00fdnCYDalSWGJ4uHMM9s7u8C0V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hrPAy5Ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hrPAy5Ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041F0C4CEF1;
	Sat,  1 Nov 2025 04:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761970223;
	bh=bpKYTPEU/yxrj+o6M2O1sO3IGPIgcsi2g7qtF6SGieA=;
	h=Date:To:From:Subject:From;
	b=hrPAy5OkErOnCzOS8NnAzHfFHdUs0yIIqC4q3aVizL540Pway+PVPIvY32wQZ7YZn
	 Z+mOVWPMWY442WSkxglbJAQ+a/hHCKrCdqKl6acviw4IxJSp46hbjLQsPUxq101Obu
	 cUqswBaoALrjIFnqFbfWxix9IC4vgs6rlwuRX75M=
Date: Fri, 31 Oct 2025 21:10:22 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tytso@mit.edu,sagi@grimberg.me,kbusch@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,home7438072@gmail.com,hch@lst.de,ebiggers@kernel.org,axboe@kernel.dk,409411716@gms.tku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-base64-add-support-for-multiple-variants.patch added to mm-nonmm-unstable branch
Message-Id: <20251101041023.041F0C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/base64: add support for multiple variants
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-base64-add-support-for-multiple-variants.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-base64-add-support-for-multiple-variants.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/base64: add support for multiple variants
Date: Wed, 29 Oct 2025 18:20:12 +0800

Patch series "lib/base64: add generic encoder/decoder, migrate users", v4.

This series introduces a generic Base64 encoder/decoder to the kernel
library, eliminating duplicated implementations and delivering significant
performance improvements.

The Base64 API has been extended to support multiple variants (Standard,
URL-safe, and IMAP) as defined in RFC 4648 and RFC 3501.  The API now
takes a variant parameter and an option to control padding.  As part of
this series, users are migrated to the new interface while preserving
their specific formats: fscrypt now uses BASE64_URLSAFE, Ceph uses
BASE64_IMAP, and NVMe is updated to BASE64_STD.

On the encoder side, the implementation processes input in 3-byte blocks,
mapping 24 bits directly to 4 output symbols.  This avoids bit-by-bit
streaming and reduces loop overhead, achieving about a 2.7x speedup
compared to previous implementations.

On the decoder side, replace strchr() lookups with per-variant reverse
tables and process input in 4-character groups.  Each group is mapped to
numeric values and combined into 3 bytes.  Padded and unpadded forms are
validated explicitly, rejecting invalid '=' usage and enforcing tail
rules.  This improves throughput by ~43-52x.


This patch (of 6):

Extend the base64 API to support multiple variants (standard, URL-safe,
and IMAP) as defined in RFC 4648 and RFC 3501.  The API now takes a
variant parameter and an option to control padding.  Update NVMe auth code
to use the new interface with BASE64_STD.

Link: https://lkml.kernel.org/r/20251029102012.542970-1-409411716@gms.tku.edu.tw
Link: https://lore.kernel.org/lkml/20250926065235.13623-1-409411716@gms.tku.edu.tw/
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Yu-Sheng Huang <home7438072@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvme/common/auth.c |    4 +-
 include/linux/base64.h     |   10 ++++-
 lib/base64.c               |   62 ++++++++++++++++++++---------------
 3 files changed, 46 insertions(+), 30 deletions(-)

--- a/drivers/nvme/common/auth.c~lib-base64-add-support-for-multiple-variants
+++ a/drivers/nvme/common/auth.c
@@ -178,7 +178,7 @@ struct nvme_dhchap_key *nvme_auth_extrac
 	if (!key)
 		return ERR_PTR(-ENOMEM);
 
-	key_len = base64_decode(secret, allocated_len, key->key);
+	key_len = base64_decode(secret, allocated_len, key->key, true, BASE64_STD);
 	if (key_len < 0) {
 		pr_debug("base64 key decoding error %d\n",
 			 key_len);
@@ -663,7 +663,7 @@ int nvme_auth_generate_digest(u8 hmac_id
 	if (ret)
 		goto out_free_digest;
 
-	ret = base64_encode(digest, digest_len, enc);
+	ret = base64_encode(digest, digest_len, enc, true, BASE64_STD);
 	if (ret < hmac_len) {
 		ret = -ENOKEY;
 		goto out_free_digest;
--- a/include/linux/base64.h~lib-base64-add-support-for-multiple-variants
+++ a/include/linux/base64.h
@@ -8,9 +8,15 @@
 
 #include <linux/types.h>
 
+enum base64_variant {
+	BASE64_STD,       /* RFC 4648 (standard) */
+	BASE64_URLSAFE,   /* RFC 4648 (base64url) */
+	BASE64_IMAP,      /* RFC 3501 */
+};
+
 #define BASE64_CHARS(nbytes)   DIV_ROUND_UP((nbytes) * 4, 3)
 
-int base64_encode(const u8 *src, int len, char *dst);
-int base64_decode(const char *src, int len, u8 *dst);
+int base64_encode(const u8 *src, int len, char *dst, bool padding, enum base64_variant variant);
+int base64_decode(const char *src, int len, u8 *dst, bool padding, enum base64_variant variant);
 
 #endif /* _LINUX_BASE64_H */
--- a/lib/base64.c~lib-base64-add-support-for-multiple-variants
+++ a/lib/base64.c
@@ -1,12 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * base64.c - RFC4648-compliant base64 encoding
+ * base64.c - Base64 with support for multiple variants
  *
  * Copyright (c) 2020 Hannes Reinecke, SUSE
  *
  * Based on the base64url routines from fs/crypto/fname.c
- * (which are using the URL-safe base64 encoding),
- * modified to use the standard coding table from RFC4648 section 4.
+ * (which are using the URL-safe Base64 encoding),
+ * modified to support multiple Base64 variants.
  */
 
 #include <linux/kernel.h>
@@ -15,26 +15,31 @@
 #include <linux/string.h>
 #include <linux/base64.h>
 
-static const char base64_table[65] =
-	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+static const char base64_tables[][65] = {
+	[BASE64_STD] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
+	[BASE64_URLSAFE] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_",
+	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
+};
 
 /**
- * base64_encode() - base64-encode some binary data
+ * base64_encode() - Base64-encode some binary data
  * @src: the binary data to encode
  * @srclen: the length of @src in bytes
- * @dst: (output) the base64-encoded string.  Not NUL-terminated.
+ * @dst: (output) the Base64-encoded string.  Not NUL-terminated.
+ * @padding: whether to append '=' padding characters
+ * @variant: which base64 variant to use
  *
- * Encodes data using base64 encoding, i.e. the "Base 64 Encoding" specified
- * by RFC 4648, including the  '='-padding.
+ * Encodes data using the selected Base64 variant.
  *
- * Return: the length of the resulting base64-encoded string in bytes.
+ * Return: the length of the resulting Base64-encoded string in bytes.
  */
-int base64_encode(const u8 *src, int srclen, char *dst)
+int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
 {
 	u32 ac = 0;
 	int bits = 0;
 	int i;
 	char *cp = dst;
+	const char *base64_table = base64_tables[variant];
 
 	for (i = 0; i < srclen; i++) {
 		ac = (ac << 8) | src[i];
@@ -48,44 +53,49 @@ int base64_encode(const u8 *src, int src
 		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
 		bits -= 6;
 	}
-	while (bits < 0) {
-		*cp++ = '=';
-		bits += 2;
+	if (padding) {
+		while (bits < 0) {
+			*cp++ = '=';
+			bits += 2;
+		}
 	}
 	return cp - dst;
 }
 EXPORT_SYMBOL_GPL(base64_encode);
 
 /**
- * base64_decode() - base64-decode a string
+ * base64_decode() - Base64-decode a string
  * @src: the string to decode.  Doesn't need to be NUL-terminated.
  * @srclen: the length of @src in bytes
  * @dst: (output) the decoded binary data
+ * @padding: whether to append '=' padding characters
+ * @variant: which base64 variant to use
  *
- * Decodes a string using base64 encoding, i.e. the "Base 64 Encoding"
- * specified by RFC 4648, including the  '='-padding.
+ * Decodes a string using the selected Base64 variant.
  *
  * This implementation hasn't been optimized for performance.
  *
  * Return: the length of the resulting decoded binary data in bytes,
- *	   or -1 if the string isn't a valid base64 string.
+ *	   or -1 if the string isn't a valid Base64 string.
  */
-int base64_decode(const char *src, int srclen, u8 *dst)
+int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base64_variant variant)
 {
 	u32 ac = 0;
 	int bits = 0;
 	int i;
 	u8 *bp = dst;
+	const char *base64_table = base64_tables[variant];
 
 	for (i = 0; i < srclen; i++) {
 		const char *p = strchr(base64_table, src[i]);
-
-		if (src[i] == '=') {
-			ac = (ac << 6);
-			bits += 6;
-			if (bits >= 8)
-				bits -= 8;
-			continue;
+		if (padding) {
+			if (src[i] == '=') {
+				ac = (ac << 6);
+				bits += 6;
+				if (bits >= 8)
+					bits -= 8;
+				continue;
+			}
 		}
 		if (p == NULL || src[i] == 0)
 			return -1;
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-base64-add-support-for-multiple-variants.patch
lib-base64-optimize-base64_decode-with-reverse-lookup-tables.patch

