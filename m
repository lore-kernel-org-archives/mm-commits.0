Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDF92727FE
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 04:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761970226; cv=none; b=RjSwiCjBgzjch3OMCrUl56AJftbfrNKTB0CrC1M2xRhFwHTNjLoKw8FVypwmgnLIycI91yaWo0vm5N7d1tP5Sx0I4OfvCUQbXJ3xn3z9OIGK+WUIRPeJWWyse94971kndFXwZhUUjFnFo0q2i1t6SZpsO8ZXJmVqM+EgiglnTQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761970226; c=relaxed/simple;
	bh=CPi4v26nCyLhLn0SljfbCpwWSe4ziviUsOkwcNInVJI=;
	h=Date:To:From:Subject:Message-Id; b=bnL3Hf5uJiVJndAGUGooReO/mQ02B4WwkR8XP8QP7g4C06KAhY7bChef1F8VpUfUF+NYoK9jo1CtbkKxv7MM6jh1KaLqhXSXxQ5VmIlhaRuArwOWJtBoBV7nrJRcJFPSEfVi/rji/UyxAo4g1H2R9j5Q4CZwqcd2NmiENcgcpQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RMbbHWVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RMbbHWVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA06BC4CEF1;
	Sat,  1 Nov 2025 04:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761970225;
	bh=CPi4v26nCyLhLn0SljfbCpwWSe4ziviUsOkwcNInVJI=;
	h=Date:To:From:Subject:From;
	b=RMbbHWVRFoTnilLGTPNuHJkcJCrralk670LoT1CN7xfThBrE3k2e+Pn/YNNeOi0+K
	 u2DKl7Chz7JX2Gt2qahOzQHRXg/z/zeddFPcjFb8xmTNeqrXSK3OkzuJE7Gk2wMhm0
	 QatyJDhqyXwMh7ayJXEwg/Ym4dBAglnEXqupzgek=
Date: Fri, 31 Oct 2025 21:10:25 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tytso@mit.edu,sagi@grimberg.me,kbusch@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,home7438072@gmail.com,hch@lst.de,ebiggers@kernel.org,axboe@kernel.dk,409411716@gms.tku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-base64-optimize-base64_decode-with-reverse-lookup-tables.patch added to mm-nonmm-unstable branch
Message-Id: <20251101041025.DA06BC4CEF1@smtp.kernel.org>
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
Date: Wed, 29 Oct 2025 18:20:36 +0800

Replace the use of strchr() in base64_decode() with precomputed reverse
lookup tables for each variant.  This avoids repeated string scans and
improves performance.  Use -1 in the tables to mark invalid characters.

Decode:
  64B   ~1530ns  ->  ~80ns    (~19.1x)
  1KB  ~27726ns  -> ~1239ns   (~22.4x)

Link: https://lkml.kernel.org/r/20251029102036.543227-1-409411716@gms.tku.edu.tw
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

 lib/base64.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/lib/base64.c~lib-base64-optimize-base64_decode-with-reverse-lookup-tables
+++ a/lib/base64.c
@@ -21,6 +21,21 @@ static const char base64_tables[][65] =
 	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
 };
 
+#define BASE64_REV_INIT(ch_62, ch_63) { \
+	[0 ... 255] = -1, \
+	['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, \
+		13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, \
+	['a'] = 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, \
+		39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, \
+	['0'] = 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
+	[ch_62] = 62, [ch_63] = 63, \
+}
+
+static const s8 base64_rev_maps[][256] = {
+	[BASE64_STD] = BASE64_REV_INIT('+', '/'),
+	[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),
+	[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
+};
 /**
  * base64_encode() - Base64-encode some binary data
  * @src: the binary data to encode
@@ -84,10 +99,9 @@ int base64_decode(const char *src, int s
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
@@ -97,9 +111,10 @@ int base64_decode(const char *src, int s
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

lib-base64-add-support-for-multiple-variants.patch
lib-base64-optimize-base64_decode-with-reverse-lookup-tables.patch

