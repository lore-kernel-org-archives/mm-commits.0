Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B8019F127
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 22:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763161126; cv=none; b=a3MMFa4rK0lm4AA4dsa8Z+P95X1SfVj0ZGwm+TX0IGQlZ8SCSQlXtAcSpl5LJTVX4TF3CSoIluhRxrHld8rrTt9G5TRFC1a8+zVJeiRrNGi1jo4wKmtfKL/cVY32rRJK/laMowTa0LfhUsLdWKbiUauifVbERRwxXqkRGO79kkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763161126; c=relaxed/simple;
	bh=LPgniQ3EzrJ4C7C1t/bvOeVKUY9Jc5+ArxU9E0TOBKQ=;
	h=Date:To:From:Subject:Message-Id; b=mp1WmlQMm/tAiOFBHueWCD0kNqROIXjndWuEtTYXAgz4hMnzfpYd+3awBQNYRuZWneQoOHSltrGH0iDUcnecdsuYQtwI9ViYWKfIHABSFwuHchPyLckuIAKM+wpS/tJUr4vmqQ9909+iGskD75E59DcF08BxHgusLkXEXSbAXLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NkhBV+6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NkhBV+6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE46C4CEF8;
	Fri, 14 Nov 2025 22:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763161125;
	bh=LPgniQ3EzrJ4C7C1t/bvOeVKUY9Jc5+ArxU9E0TOBKQ=;
	h=Date:To:From:Subject:From;
	b=NkhBV+6t1tN5lhgfxLFeW1eX3pxZATkUxoHeZeZfZaGYxVFV74GLZezbpI69PzkOx
	 KZ2CbqrIEM6lkzY4ntmcmOAybocLjm1bLKbxrENMiekyVVL9+yh3Fj2d7esewJJOur
	 6d2Wy39kz2VsDyQjT4G0kOzdI8m7P7jL7ffc7hy8=
Date: Fri, 14 Nov 2025 14:58:44 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tytso@mit.edu,Slava.Dubeyko@ibm.com,sagi@grimberg.me,kbusch@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,home7438072@gmail.com,hch@lst.de,ebiggers@kernel.org,david.laight.linux@gmail.com,axboe@kernel.dk,409411716@gms.tku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-base64-optimize-base64_decode-with-reverse-lookup-tables.patch added to mm-nonmm-unstable branch
Message-Id: <20251114225845.7DE46C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/base64: optimize base64_decode() with reverse lookup tables
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-base64-optimize-base64_decode-with-reverse-lookup-tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-base64-optimize-base64_decode-with-reverse-lookup-tables.patch

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
Subject: lib/base64: optimize base64_decode() with reverse lookup tables
Date: Fri, 14 Nov 2025 14:01:07 +0800

Replace the use of strchr() in base64_decode() with precomputed reverse
lookup tables for each variant. This avoids repeated string scans and
improves performance. Use -1 in the tables to mark invalid characters.

Decode:
  64B   ~1530ns  ->  ~80ns    (~19.1x)
  1KB  ~27726ns  -> ~1239ns   (~22.4x)

Link: https://lkml.kernel.org/r/20251114060107.89026-1-409411716@gms.tku.edu.tw
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
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
Cc: Yu-Sheng Huang <home7438072@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/base64.c |   51 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

--- a/lib/base64.c~lib-base64-optimize-base64_decode-with-reverse-lookup-tables
+++ a/lib/base64.c
@@ -22,6 +22,49 @@ static const char base64_tables[][65] =
 };
 
 /**
+ * Initialize the base64 reverse mapping for a single character
+ * This macro maps a character to its corresponding base64 value,
+ * returning -1 if the character is invalid.
+ * char 'A'-'Z' maps to 0-25, 'a'-'z' maps to 26-51, '0'-'9' maps to 52-61,
+ * ch_62 maps to 62, ch_63 maps to 63, and other characters return -1
+ */
+#define INIT_1(v, ch_62, ch_63) \
+	[v] = (v) >= 'A' && (v) <= 'Z' ? (v) - 'A' \
+		: (v) >= 'a' && (v) <= 'z' ? (v) - 'a' + 26 \
+		: (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
+		: (v) == (ch_62) ? 62 : (v) == (ch_63) ? 63 : -1
+/**
+ * Recursive macros to generate multiple Base64 reverse mapping table entries.
+ * Each macro generates a sequence of entries in the lookup table:
+ * INIT_2 generates 2 entries, INIT_4 generates 4, INIT_8 generates 8, and so on up to INIT_32.
+ */
+#define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
+#define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
+#define INIT_8(v, ...) INIT_4(v, __VA_ARGS__), INIT_4((v) + 4, __VA_ARGS__)
+#define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
+#define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
+
+#define BASE64_REV_INIT(ch_62, ch_63) { \
+	[0 ... 0x1f] = -1, \
+	INIT_32(0x20, ch_62, ch_63), \
+	INIT_32(0x40, ch_62, ch_63), \
+	INIT_32(0x60, ch_62, ch_63), \
+	[0x80 ... 0xff] = -1 }
+
+static const s8 base64_rev_maps[][256] = {
+	[BASE64_STD] = BASE64_REV_INIT('+', '/'),
+	[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),
+	[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
+};
+
+#undef BASE64_REV_INIT
+#undef INIT_32
+#undef INIT_16
+#undef INIT_8
+#undef INIT_4
+#undef INIT_2
+#undef INIT_1
+/**
  * base64_encode() - Base64-encode some binary data
  * @src: the binary data to encode
  * @srclen: the length of @src in bytes
@@ -84,10 +127,9 @@ int base64_decode(const char *src, int s
 	int bits = 0;
 	int i;
 	u8 *bp = dst;
-	const char *base64_table = base64_tables[variant];
+	s8 ch;
 
 	for (i = 0; i < srclen; i++) {
-		const char *p = strchr(base64_table, src[i]);
 		if (padding) {
 			if (src[i] == '=') {
 				ac = (ac << 6);
@@ -97,9 +139,10 @@ int base64_decode(const char *src, int s
 				continue;
 			}
 		}
-		if (p == NULL || src[i] == 0)
+		ch = base64_rev_maps[variant][(u8)src[i]];
+		if (ch == -1)
 			return -1;
-		ac = (ac << 6) | (p - base64_table);
+		ac = (ac << 6) | ch;
 		bits += 6;
 		if (bits >= 8) {
 			bits -= 8;
_

Patches currently in -mm which might be from visitorckw@gmail.com are

revert-lib-plistc-enforce-memory-ordering-in-plist_check_list.patch
lib-base64-add-support-for-multiple-variants.patch
lib-base64-optimize-base64_decode-with-reverse-lookup-tables.patch

