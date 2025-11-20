Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95792E2F1F
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675601; cv=none; b=WK9j/1/61HU4IRD4ZvsRV/m5BRf8iy2a2fYmf/0bkUtdWiNk7pm5vgCrSvT8W6QAPMAqZ94oaTUYOZgYNQAF/Sil414jIruT5mhMESo7KmDueB+EtxAZ+YMYp5tpL8vXFGGzz7J4oGBs6NSfAHzYZpOMqGxgqE1eRbX1x2rXtio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675601; c=relaxed/simple;
	bh=cATPqZlM085DFTfZcpNTFsDW+3hJhcKQWZpEV32nJ80=;
	h=Date:To:From:Subject:Message-Id; b=oNTW06Up9fEWtkAT/Oj3hHRtNJ6xfdt/3JyxWZWi75gZxyhKFQc8TIm6uwnbRAiuikTun8ikx6YGAZZrs9x+VXT3/20K5LchO1nDtUPRIe5Fpcds2CLZvAgZmgQRmx0c/KB3hslCCMpVzAnZeY9vJ+5i2oRusLdYV5Zf69JfZ+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MgdBHo55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MgdBHo55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D64BC4CEF1;
	Thu, 20 Nov 2025 21:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675601;
	bh=cATPqZlM085DFTfZcpNTFsDW+3hJhcKQWZpEV32nJ80=;
	h=Date:To:From:Subject:From;
	b=MgdBHo55+F26Q06ohpXcEbIinK83Weu4534tFgouyRkHcSwT2FDVAd/iVVoLs0N7t
	 HnanXKgPvWmx2ItDoudAihKfzaD1um/33h+VsKrGqKPprcOV0Q9+r0vEKLK2PeMYmt
	 o7lFgb3AaqFX1BtBBJGGquRi8bXnjmWt6t6XTwnQ=
Date: Thu, 20 Nov 2025 13:53:20 -0800
To: mm-commits@vger.kernel.org,david.laight.linux@gmail.com,409411716@gms.tku.edu.tw,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch removed from -mm tree
Message-Id: <20251120215321.4D64BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix
has been removed from the -mm tree.  Its filename was
     lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch

This patch was dropped because it was folded into lib-base64-rework-encode-decode-for-speed-and-stricter-validation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix
Date: Mon Nov 17 09:44:57 AM PST 2025

remove u32 casts, per David and Guan-Chun

Cc: David Laight <david.laight.linux@gmail.com>
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/base64.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/base64.c~lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix
+++ a/lib/base64.c
@@ -84,7 +84,7 @@ int base64_encode(const u8 *src, int src
 	const char *base64_table = base64_tables[variant];
 
 	while (srclen >= 3) {
-		ac = (u32)src[0] << 16 | (u32)src[1] << 8 | (u32)src[2];
+		ac = src[0] << 16 | src[1] << 8 | src[2];
 		*cp++ = base64_table[ac >> 18];
 		*cp++ = base64_table[(ac >> 12) & 0x3f];
 		*cp++ = base64_table[(ac >> 6) & 0x3f];
@@ -96,7 +96,7 @@ int base64_encode(const u8 *src, int src
 
 	switch (srclen) {
 	case 2:
-		ac = (u32)src[0] << 16 | (u32)src[1] << 8;
+		ac = src[0] << 16 | src[1] << 8;
 		*cp++ = base64_table[ac >> 18];
 		*cp++ = base64_table[(ac >> 12) & 0x3f];
 		*cp++ = base64_table[(ac >> 6) & 0x3f];
@@ -104,7 +104,7 @@ int base64_encode(const u8 *src, int src
 			*cp++ = '=';
 		break;
 	case 1:
-		ac = (u32)src[0] << 16;
+		ac = src[0] << 16;
 		*cp++ = base64_table[ac >> 18];
 		*cp++ = base64_table[(ac >> 12) & 0x3f];
 		if (padding) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-correctly-handle-uffd-pte-markers-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
lib-base64-rework-encode-decode-for-speed-and-stricter-validation.patch
uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch

