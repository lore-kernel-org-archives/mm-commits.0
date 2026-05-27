Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584573BC69C
	for <mm-commits@vger.kernel.org>; Wed, 27 May 2026 20:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779913428; cv=none; b=gTjFNM1MbeJYuhj/yqpppowICPKDLF/D2BNxJ7DfxevyggNiRlZsDu+cjYcpzDAwaJXaUQELMcwpyKENQl+NA5xKQOmn3jpM/QxGiUH4spNnJrjgLeQz7hcmjEFK2E9fWmKZe3EzZwalUk0+xbPbSEP0Zn75yHYSHVfcJePgthw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779913428; c=relaxed/simple;
	bh=AFDS64tIg+UP4dxlFCae7PnQkdb86NNoqNQKN3y1Qtk=;
	h=Date:To:From:Subject:Message-Id; b=uicxlHXxOxhzFUljI0JeW1sEq/QuPLt8YjPOf8w6qb8oStDjsdCjIfN0Mv5CbsmY8bqkqoh99CbOoDcPmAv8KZSU2MU5tSBKMYG7FthSCQY9ilTY1haTQ77aKM7M2jhRNDBvwGr7G/zkoJNbm6FGReSJOcPeq6/caQ/b+awWZAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xobqrkXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xobqrkXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0F61F000E9;
	Wed, 27 May 2026 20:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779913427;
	bh=9y9JQO+HvPOwhdiLMd1Sj+YtPv/G99vtKoozt9IJPbA=;
	h=Date:To:From:Subject;
	b=xobqrkXDNIdfxoz6PvPk+N88Iw05CzCtSBmn/qrbiy58j3Qs11CX4pWcFxiDEDFiz
	 PylWPRMo8fQY5AhPEM8kCjF1eucjtmJRVIYcm9ZQm9AkFa8LEUUR487rAwnkWjuGjc
	 ITLo9kissx91QCw/06wCUk9XQ0hGRd1lstusWaFE=
Date: Wed, 27 May 2026 13:23:46 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-rework-registration-of-optimized-algorithms-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260527202346.DD0F61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6/x86: register avx512 after avx2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-rework-registration-of-optimized-algorithms-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-rework-registration-of-optimized-algorithms-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: raid6/x86: register avx512 after avx2
Date: Wed, 27 May 2026 09:45:26 +0200

This way non-benchmarks configs still get avx512 if supported.

Link: https://lore.kernel.org/20260527074539.2292913-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/x86/pq_arch.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/raid/raid6/x86/pq_arch.h~raid6-rework-registration-of-optimized-algorithms-fix
+++ a/lib/raid/raid6/x86/pq_arch.h
@@ -60,16 +60,16 @@ static inline bool raid6_has_sse1_or_mmx
 static __always_inline void __init arch_raid6_init(void)
 {
 	if (raid6_has_avx2()) {
+		raid6_algo_add(&raid6_avx2x1);
+		raid6_algo_add(&raid6_avx2x2);
+		if (IS_ENABLED(CONFIG_X86_64))
+			raid6_algo_add(&raid6_avx2x4);
 		if (raid6_has_avx512()) {
 			raid6_algo_add(&raid6_avx512x1);
 			raid6_algo_add(&raid6_avx512x2);
 			if (IS_ENABLED(CONFIG_X86_64))
 				raid6_algo_add(&raid6_avx512x4);
 		}
-		raid6_algo_add(&raid6_avx2x1);
-		raid6_algo_add(&raid6_avx2x2);
-		if (IS_ENABLED(CONFIG_X86_64))
-			raid6_algo_add(&raid6_avx2x4);
 	} else if (IS_ENABLED(CONFIG_X86_64) || raid6_has_sse2()) {
 		/* x86_64 can assume SSE2 as baseline */
 		raid6_algo_add(&raid6_sse2x1);
_

Patches currently in -mm which might be from hch@lst.de are

raid6-turn-the-userspace-test-harness-into-a-kunit-test.patch
raid6-remove-__kernel__-ifdefs.patch
raid6-move-to-lib-raid.patch
raid6-remove-unused-defines-in-pqh.patch
raid6-remove-raid6_get_zero_page.patch
raid6-use-named-initializers-for-struct-raid6_calls.patch
raid6-improve-the-public-interface.patch
raid6-warn-when-using-less-than-four-devices.patch
raid6-hide-internals.patch
raid6-hide-internals-fix.patch
raid6-rework-registration-of-optimized-algorithms.patch
raid6-rework-registration-of-optimized-algorithms-fix.patch
raid6-use-static_call-for-gen_syndrom-and-xor_syndrom.patch
raid6-use-static_call-for-raid6_recov_2data-and-raid6_recov_datap.patch
raid6-update-top-of-file-comments.patch
raid6_kunit-use-kunit_case_param.patch
raid6_kunit-dynamically-allocate-data-buffers-using-vmalloc.patch
raid6_kunit-cleanup-dataptr-handling.patch
raid6_kunit-randomize-parameters-and-increase-limits.patch
raid6_kunit-randomize-buffer-alignment.patch

