Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB3A35FF72
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676288; cv=none; b=Us3APdL2W30S8iImKZeKF6Tmp4N4GaaBCq/NLMgtumFuc+DCB7HVN0m458kwVU/dNw83C3iZpndzeR+kliOzPvIITRjEBTcOsm+g2VX01XjdhfVt94JbpF88GQzAlid1KZ2+Hq3K+BX0r3bnjipwJYVQ0BjSZStBmxCSwCrAYQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676288; c=relaxed/simple;
	bh=FLb8QavcwdCyGWVeMZn8Y+a2biG96ZMxW7LyRKf9k2Y=;
	h=Date:To:From:Subject:Message-Id; b=NvtO6kjBiefU38AL79VpQ3cpo6S7+inIWjQ1wI8uCflA6Z51qauPXJhyVnzwPtop5+POEWNV8Cm5/x5PAzccjt7sAYbAWfGhFAG77b/QRr7dBjGVOvv7N3VnYnyTE8Y0E6uXNFe3rorzFBg6rytzhVUADqXZV/+FFwahmbEQ5E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lZ27s5Fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lZ27s5Fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BFFC4CEF1;
	Thu, 20 Nov 2025 22:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676288;
	bh=FLb8QavcwdCyGWVeMZn8Y+a2biG96ZMxW7LyRKf9k2Y=;
	h=Date:To:From:Subject:From;
	b=lZ27s5FweQlwN8sVH8b8QrFOKdyoE/bav1RQlQryFPRg+XYr3Y+YNDQtGlVuC2dF4
	 dyuLK0j88TyNIMlqfgQii1uFnL86OtGNGjPORldyoiaopAwSFekHOXn1Okht/VBA0H
	 v7WVCBp/9NofE7P7bLOI9Gh3pUNzh4ddCQo/NzRo=
Date: Thu, 20 Nov 2025 14:04:48 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tytso@mit.edu,Slava.Dubeyko@ibm.com,sagi@grimberg.me,kbusch@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,home7438072@gmail.com,hch@lst.de,ebiggers@kernel.org,david.laight.linux@gmail.com,axboe@kernel.dk,409411716@gms.tku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-base64-optimize-base64_decode-with-reverse-lookup-tables.patch removed from -mm tree
Message-Id: <20251120220448.96BFFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/base64: optimize base64_decode() with reverse lookup tables
has been removed from the -mm tree.  Its filename was
     lib-base64-optimize-base64_decode-with-reverse-lookup-tables.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: fix kernedoc]
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

 lib/base64.c |   52 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 48 insertions(+), 4 deletions(-)

--- a/lib/base64.c~lib-base64-optimize-base64_decode-with-reverse-lookup-tables
+++ a/lib/base64.c
@@ -21,6 +21,50 @@ static const char base64_tables[][65] =
 	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
 };
 
+/*
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
+
+/*
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
 /**
  * base64_encode() - Base64-encode some binary data
  * @src: the binary data to encode
@@ -84,10 +128,9 @@ int base64_decode(const char *src, int s
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
@@ -97,9 +140,10 @@ int base64_decode(const char *src, int s
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


