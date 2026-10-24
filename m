Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792830017;
	b=uMC1Uf0MU9rLvFSLOluhu4Iky7qaLV0r+sNK8yjHpQXB67zXCj01RUPBwybWvleSR1Pq
	 huswM83+RWDCqkvuuy4LYbRrg2qUOtdUTHkIDvz6YLBsZZCJPkHeOJ7bmpIgR7mbyZe2W
	 SPQMxhmD6Uy0ZVKju/BXyWPP81vEZu1Q9rZcINvGiMhr1EfXTuPsaYNowPDEk34oqczo8
	 yHYqucS2SQ3fwllUoHTIB7qr/DNr9oXGJ7VCLOKXF4AQH+KLKyd+8LpQJ8zLmpxFARh4D
	 FFUTnknhL8JWq+dBEwIYb3hrNEKj11UoFa8gpISGwpkJPi0sojNfns2nXBV1H2HtMVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792830017;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=eF5n1VtYV7LXlXMUbEni695151OYxaSW+Dr3Z0PHbWo=;
	b=QW5acJXItN1Rel5JBc5eBf/XqVoxMs0ozCpVv8vYoag5gMbYUBGiu/1Vpxxz/uKCO2jC
	 PkiIT9pdc2Zw/JszMFxBxN0ZQl6plO4LUhnOkgsYK4tJpe75VVmeMbMJjV8co6ahvFexS
	 OXZg4ztLumOr+H0chhTqK9mIH77V8QnOHlqEbCVgv+UzJPmwuDvF3btUcP9NNn2smaXyX
	 29AIQXRuDDjFQNXCeZ8Yk5jTpFDJBIsl/SDdzTT96ECWj5Xzor1k0db/ro1caffhOAdWH
	 ukxxepo1ge6xPjqlFV5dOu2Oqt0oXNAe6BaM++NxXgKcw9g1ZeFP0RmQwNOlyTN9/mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DHyFhfqJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61294606A324
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DHyFhfqJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF71B1F031E0;
	Sat, 24 Oct 2026 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792830017;
	bh=eF5n1VtYV7LXlXMUbEni695151OYxaSW+Dr3Z0PHbWo=;
	h=Date:To:From:Subject;
	b=DHyFhfqJ6eqVp8YI2DtyjzXpBtX86pcymPQJ6TPCivk/5UdjJAisL/t28o7nAJ4Yg
	 I7F2PlwexuoKJeqJVpo0j3peczehFNbQYc9TUWsDvBCXLCiXQa5SuBkJYtf+j8Cq2j
	 Ytxkr5Hkvdirocw36MSNumuEH0GHolWKDJFwleT0=
Date: Sat, 24 Oct 2026 01:20:16 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,gutierrez.asier@huawei-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-core-introduce-damos_quota_goal-complement-fix.patch removed from -mm tree
Message-Id: <20261024082016.DF71B1F031E0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm-damon-core-introduce-damos_quota_goal-complement-fix
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damos_quota_goal-complement-fix.patch

This patch was dropped because it was folded into mm-damon-core-introduce-damos_quota_goal-complement.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-damon-core-introduce-damos_quota_goal-complement-fix
Date: Tue Sep 29 01:47:25 PM PDT 2026

fix comment tpyo, per Gutierrez

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SJ Park <sj@kernel.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-introduce-damos_quota_goal-complement-fix
+++ a/mm/damon/core.c
@@ -3267,7 +3267,7 @@ static void damos_set_quota_goal_current
 	if (!goal->complement)
 		return;
 
-	/* updte current_value to complemented value */
+	/* update current_value to complemented value */
 
 	/* for user_input, users set complemented value on their own */
 	if (goal->metric == DAMOS_QUOTA_USER_INPUT)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch

