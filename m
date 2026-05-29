Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D292E4257
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028329; cv=none; b=ppTnoiYYSKdvaX0nRfU4QO5D5YqZc/VC+PPERzD6D4GhebnnjEZd3LoFYASke9um1ngc/3pASCh6dUDTqwJZ2aKObfonRDQbBRrIMpkvGbFnP628pNJ4UGqK4brNUWUJ6O9EjizzvETZsR/Yo0CNxpQsdhGUFnBPUm48sHQ1lr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028329; c=relaxed/simple;
	bh=9ZFv71Fi5HUdUlCUexg1YeZDAcPPQ9EeY3GbGKor5Zg=;
	h=Date:To:From:Subject:Message-Id; b=Dqa4TBfdd0ATY6cgMtNV59SVEDZ6oNNQuKoBPbl20sKGw2aVOe5zTSZN13iRXAGF3pghLUm2cdcF/QKcp8lvAhOos4yqW901ZofZHXmuP/MUz2hr1uo+s0mczIswPgUig4qUgB3jqJWpH4CHYHo43R4bozwBR+TItdEQ7OprPDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YbUbgqrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YbUbgqrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFC71F00893;
	Fri, 29 May 2026 04:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028327;
	bh=XtWs/R30BpIzaAMQcKHfPVXqS+OyHyW0iALab2YVyKw=;
	h=Date:To:From:Subject;
	b=YbUbgqrKflD9s95RNOVR7XnCsN/yZXpFhDk3liD/bYQuAXZyNEdbj19b6gHUmkFpY
	 3EWHpTP8zJXWW1XNs+P7QiC3He6WCrbCdK8/v+mKsG1eu3HAg5H9COnbLEX+Z+7QMW
	 iGKnktB69dZ0mjYrZP6BpRMRuwV4m8Dgvj3OaAu8=
Date: Thu, 28 May 2026 21:18:47 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] raid6-rework-registration-of-optimized-algorithms-fix.patch removed from -mm tree
Message-Id: <20260529041847.CBFC71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: raid6/x86: register avx512 after avx2
has been removed from the -mm tree.  Its filename was
     raid6-rework-registration-of-optimized-algorithms-fix.patch

This patch was dropped because it was folded into raid6-rework-registration-of-optimized-algorithms.patch

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
raid6-rework-registration-of-optimized-algorithms.patch
raid6-use-static_call-for-gen_syndrom-and-xor_syndrom.patch
raid6-use-static_call-for-raid6_recov_2data-and-raid6_recov_datap.patch
raid6-update-top-of-file-comments.patch
raid6_kunit-use-kunit_case_param.patch
raid6_kunit-dynamically-allocate-data-buffers-using-vmalloc.patch
raid6_kunit-cleanup-dataptr-handling.patch
raid6_kunit-randomize-parameters-and-increase-limits.patch
raid6_kunit-randomize-buffer-alignment.patch

