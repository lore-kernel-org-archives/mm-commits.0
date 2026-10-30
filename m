Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793328363;
	b=pbiyLNb4WKiHqqoF6VFevqmGCd3KuwB+KfPkcf2sBDCMIXlPZFgQfiybY0s73mGB44nr
	 iJPjoohe/zMpI9Ll+hYLqvn/Ts3rcFipP30Idb2os4rLhxBA1XnOKhIAfP+WlNMRH0Gk3
	 VTitRMTTEVTKSoXnUCuKaGjQzsLjD5ZPR4eMtAiHzPBqEu12lTRZZ6ZVIxIvYzfRD4KyN
	 7iqzQlsNuFmRG0YkCVvL9x4+tEn2AO5qimPIo6d7i6qmVOBTuxp8zlv9w2ey5B1tenBxq
	 TW27L4/A5rOf3zhY/Ry6Ohx4ZcSPAkbTY913gKWx154S9BuoHAG/7C3vqHJ9IM9J0og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793328363;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Z2KjRcGqGbR5ldtycJfArdhUlDbl2kGFma6lCnh5hIE=;
	b=uOC7Hz+ShoLkwTXLVfNTYVLSyHgRuuWYrH3u2Rp3+OeRktCE+fV8SGkX/XEy0j3jAHj4
	 2AmDOl1sbf4/bcChXQpbE0fuVILKju/kafQ1H1ZwWRCny77YPaRBkWwZgAr46Mv/CctoX
	 fH1wBuixzpeqLjz8YE7Wsy1NkTPdp0tGbnHSLwMUc2ASoRjeH226VYRGA1U9yws2lb/T7
	 P0ypcxIMgz0FlgofDSDw2cuxXphmXXBSjmXa+px6G5SmKiVVsg5apv+o7Tp5N+bJukG5b
	 wreqIYXoQSob/rBwgFjCCCXitAHrAtMz2A3WBy6B7bgJwndM2leItTPC1JOFrDNjT1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gjNKRAAK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C3C606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 02:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gjNKRAAK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991E01F000C1;
	Fri, 30 Oct 2026 02:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793328362;
	bh=Z2KjRcGqGbR5ldtycJfArdhUlDbl2kGFma6lCnh5hIE=;
	h=Date:To:From:Subject;
	b=gjNKRAAKhC3T2SHkZ0/rZp19vjMSWPnjNX7kOfwGVUxFxC+qC6yjwrcGXYI06KTY8
	 rag76WCs5mPOmu25iLKiHtuoq3id1znQAojVjRMuLB3Ye4e8QB8HEpaoZCBA1KyBZO
	 7eoMX02xd00ehSGyE4VMsmrSgH0RlW8OVSInLg2k=
Date: Thu, 29 Oct 2026 19:46:02 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,david.laight.linux@gmail.com,
	ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-simplify-cpu-feature-checks.patch added to mm-nonmm-unstable branch
Message-Id: <20261030024602.991E01F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: raid6: simplify CPU feature checks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-simplify-cpu-feature-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-simplify-cpu-feature-checks.patch

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
From: Eric Biggers <ebiggers@kernel.org>
Subject: raid6: simplify CPU feature checks
Date: Sun, 25 Oct 2026 12:12:07 -0700

Remove unnecessary checks for features that are prerequisites for other
features, such as AVX which is a prerequisite for AVX2.

(Note: in most cases arch/x86/kernel/cpu/cpuid-deps.c warns about
missing prerequisites rather than enforcing them.  This is intentional,
and it does not mean the prerequisites should be checked elsewhere.)

Then, move the raid6_recov_algo_add() lines into the appropriate places
just above so that the same CPU features aren't checked multiple times.

Link: https://lore.kernel.org/20261025191207.86590-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Laight <david.laight.linux@gmail.com>
---

 lib/raid/raid6/x86/pq_arch.h |   51 +++++++--------------------------
 1 file changed, 11 insertions(+), 40 deletions(-)

--- a/lib/raid/raid6/x86/pq_arch.h~raid6-simplify-cpu-feature-checks
+++ a/lib/raid/raid6/x86/pq_arch.h
@@ -16,63 +16,34 @@ extern const struct raid6_recov_calls ra
 extern const struct raid6_recov_calls raid6_recov_avx2;
 extern const struct raid6_recov_calls raid6_recov_avx512;
 
-static inline int raid6_has_avx512(void)
-{
-	return boot_cpu_has(X86_FEATURE_AVX2) &&
-		boot_cpu_has(X86_FEATURE_AVX) &&
-		boot_cpu_has(X86_FEATURE_AVX512F) &&
-		boot_cpu_has(X86_FEATURE_AVX512BW) &&
-		boot_cpu_has(X86_FEATURE_AVX512VL) &&
-		boot_cpu_has(X86_FEATURE_AVX512DQ);
-}
-
-static inline bool raid6_has_avx2(void)
-{
-	return boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX);
-}
-
-static inline bool raid6_has_ssse3(void)
-{
-	return boot_cpu_has(X86_FEATURE_XMM) &&
-		boot_cpu_has(X86_FEATURE_XMM2) &&
-		boot_cpu_has(X86_FEATURE_SSSE3);
-}
-
-static inline bool raid6_has_sse2(void)
-{
-	return boot_cpu_has(X86_FEATURE_MMX) &&
-		    boot_cpu_has(X86_FEATURE_FXSR) &&
-		    boot_cpu_has(X86_FEATURE_XMM) &&
-		    boot_cpu_has(X86_FEATURE_XMM2);
-}
-
 static __always_inline void __init arch_raid6_init(void)
 {
-	if (raid6_has_avx2()) {
+	if (boot_cpu_has(X86_FEATURE_AVX2)) {
 		raid6_algo_add(&raid6_avx2x1);
 		raid6_algo_add(&raid6_avx2x2);
 		if (IS_ENABLED(CONFIG_X86_64))
 			raid6_algo_add(&raid6_avx2x4);
-		if (raid6_has_avx512()) {
+		if (boot_cpu_has(X86_FEATURE_AVX512BW) &&
+		    boot_cpu_has(X86_FEATURE_AVX512VL) &&
+		    boot_cpu_has(X86_FEATURE_AVX512DQ)) {
 			raid6_algo_add(&raid6_avx512x1);
 			raid6_algo_add(&raid6_avx512x2);
 			if (IS_ENABLED(CONFIG_X86_64))
 				raid6_algo_add(&raid6_avx512x4);
+			raid6_recov_algo_add(&raid6_recov_avx512);
+		} else {
+			raid6_recov_algo_add(&raid6_recov_avx2);
 		}
-	} else if (IS_ENABLED(CONFIG_X86_64) || raid6_has_sse2()) {
+	} else if (IS_ENABLED(CONFIG_X86_64) ||
+		   boot_cpu_has(X86_FEATURE_XMM2)) {
 		/* x86_64 can assume SSE2 as baseline */
 		raid6_algo_add(&raid6_sse2x1);
 		raid6_algo_add(&raid6_sse2x2);
 		if (IS_ENABLED(CONFIG_X86_64))
 			raid6_algo_add(&raid6_sse2x4);
+		if (boot_cpu_has(X86_FEATURE_SSSE3))
+			raid6_recov_algo_add(&raid6_recov_ssse3);
 	} else {
 		raid6_algo_add_default();
 	}
-
-	if (raid6_has_avx512())
-		raid6_recov_algo_add(&raid6_recov_avx512);
-	else if (raid6_has_avx2())
-		raid6_recov_algo_add(&raid6_recov_avx2);
-	else if (raid6_has_ssse3())
-		raid6_recov_algo_add(&raid6_recov_ssse3);
 }
_

Patches currently in -mm which might be from ebiggers@kernel.org are

xor-remove-obsolete-mmx-optimized-code.patch
raid6-remove-obsolete-mmx-optimized-code.patch
raid6-simplify-cpu-feature-checks.patch

