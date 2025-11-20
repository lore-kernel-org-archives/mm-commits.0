Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254DD275844
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675580; cv=none; b=XijCc3No+A/iALeDry2baIxo2UrlwHka/knpBUk1uJa8sUe69VgKmh3mEcxqFhNiVuuR8K3s27gsUUkExNLIexf88KNy1jf/dX5YXHlUQxoBc1JiNhTl9veBhViBzJ2kz12OFm8s0y7WLNdp0N4QBJD1n+23mSactSuBM2Df4YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675580; c=relaxed/simple;
	bh=uBir9EDO8H7xkzrgbqhWAtnFEV4FYdrhp5lTK+LWVME=;
	h=Date:To:From:Subject:Message-Id; b=r0l21LzQZoLUjStt2q9zgh9ddsFMX8Fqs498+zcA8dh5znYNCUtujwDF2LRsa+kDdTJEv468M3xjIrlTU+L5YH/SOm73bsV7Go3Rcwb7+4nZSr8/OSnz82TN1bLYjna4HT2xTqsCr6Fk9bze2O39FeEBEOSMibXtvizLj1tGHVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SnI1B260; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SnI1B260"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C306C4CEF1;
	Thu, 20 Nov 2025 21:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675579;
	bh=uBir9EDO8H7xkzrgbqhWAtnFEV4FYdrhp5lTK+LWVME=;
	h=Date:To:From:Subject:From;
	b=SnI1B260RJmfttdp74HEBdUltd82VGk1ReXH3mhdEnHdtvaIKkI+YGaRGxt3cTpJz
	 4Ah2We3Aqe5IhkPnL3oNjpJLPwt+MVZoR/+Ro4Se4Q4V5jKEVH8J/xRQ8ccZ2Xp64y
	 meMsmwwXF2xL5wmeH0g8DFmFErBUcouHFcL3GAIM=
Date: Thu, 20 Nov 2025 13:52:59 -0800
To: mm-commits@vger.kernel.org,andriy.shevchenko@intel.com,409411716@gms.tku.edu.tw,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix.patch removed from -mm tree
Message-Id: <20251120215259.9C306C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix
has been removed from the -mm tree.  Its filename was
     lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix.patch

This patch was dropped because it was folded into lib-base64-optimize-base64_decode-with-reverse-lookup-tables.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix
Date: Tue Nov 18 09:22:32 AM PST 2025

fix kernedoc

Reported-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Closes: https://lkml.kernel.org/r/aRxMtmatG7wbqJKL@black.igk.intel.com
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/base64.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/base64.c~lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix
+++ a/lib/base64.c
@@ -21,7 +21,7 @@ static const char base64_tables[][65] =
 	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
 };
 
-/**
+/*
  * Initialize the base64 reverse mapping for a single character
  * This macro maps a character to its corresponding base64 value,
  * returning -1 if the character is invalid.
@@ -33,7 +33,8 @@ static const char base64_tables[][65] =
 		: (v) >= 'a' && (v) <= 'z' ? (v) - 'a' + 26 \
 		: (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
 		: (v) == (ch_62) ? 62 : (v) == (ch_63) ? 63 : -1
-/**
+
+/*
  * Recursive macros to generate multiple Base64 reverse mapping table entries.
  * Each macro generates a sequence of entries in the lookup table:
  * INIT_2 generates 2 entries, INIT_4 generates 4, INIT_8 generates 8, and so on up to INIT_32.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-correctly-handle-uffd-pte-markers-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
lib-base64-optimize-base64_decode-with-reverse-lookup-tables.patch
lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch
uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch

