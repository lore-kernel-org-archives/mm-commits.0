Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E399B1DFF0
	for <mm-commits@vger.kernel.org>; Tue, 17 Mar 2026 19:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773776747; cv=none; b=I+ZR8GMt04gYTF6PY+aEEZea/Fy9H18hP60KKkE3PjDjzJ07qMl2vmOvIwXSyCJ3Hw4urq+C+s1OE4gaFQvqQSGqX16IRza2KBiyozb/AOyF5Hv/A2SDcnJHTDCS78qr34FBH9CtfsZuAKfhL8AvaoM3dgJIh31FVF3jYrxyLPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773776747; c=relaxed/simple;
	bh=G/ViWNZB3qB8PrB1pDPx/zddep92Q/h63eg1bA9ED0M=;
	h=Date:To:From:Subject:Message-Id; b=FoPh4jWAc9cnTCa8i7T9M0LvkgtXzezh3M1FBairuDfpsA7xTaw/Mn511MztVP61BxR8nu/GwXLwMFhn+kLDufsoZJFaBH6tZWJAPFXnNLrMB24jvS2td8K/DxjcQ2ycnnIM8vG4fJng4oOfJAoDL4LUTbD2R82zA3jKaNi1KWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GgjTIhsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GgjTIhsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83212C4CEF7;
	Tue, 17 Mar 2026 19:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773776746;
	bh=G/ViWNZB3qB8PrB1pDPx/zddep92Q/h63eg1bA9ED0M=;
	h=Date:To:From:Subject:From;
	b=GgjTIhsbkdVig1pIlc9O8z+tpBk6iyuDrUB2QyUJpxAmTWhU0dcJhrO8s3hGR1uQW
	 RgfQxxWPbip5Rr7h9YKrB+WuF1qMJFtgHXf5rGR/RnvP4x7EcWbZPafhhPIGbe5mNp
	 0ALb/QkEW9jxpjWouvhNxjeZhrG+13fZxBMJBvXI=
Date: Tue, 17 Mar 2026 12:45:45 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,yosry.ahmed@linux.dev,senozhatsky@chromium.org,nphamcs@gmail.com,kanchana.p.sridhar@intel.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,kanchanapsridhar2026@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-consistently-use-is_err_or_null-to-check-acomp_ctx-resources.patch added to mm-new branch
Message-Id: <20260317194546.83212C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-consistently-use-is_err_or_null-to-check-acomp_ctx-resources.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-consistently-use-is_err_or_null-to-check-acomp_ctx-resources.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Subject: mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
Date: Fri, 13 Mar 2026 22:16:32 -0700

Use IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check for valid
acomp/req, making it consistent with acomp_ctx_dealloc().

Link: https://lkml.kernel.org/r/20260314051632.17931-3-kanchanapsridhar2026@gmail.com
Co-developed-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-consistently-use-is_err_or_null-to-check-acomp_ctx-resources
+++ a/mm/zswap.c
@@ -804,7 +804,7 @@ static int zswap_cpu_comp_prepare(unsign
 	 * error pointer, never NULL.
 	 */
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp_ctx->acomp)) {
+	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %pe\n",
 				pool->tfm_name, acomp_ctx->acomp);
 		ret = PTR_ERR(acomp_ctx->acomp);
@@ -813,7 +813,7 @@ static int zswap_cpu_comp_prepare(unsign
 
 	/* acomp_request_alloc() returns NULL in case of an error. */
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
_

Patches currently in -mm which might be from kanchanapsridhar2026@gmail.com are

mm-zswap-remove-redundant-checks-in-zswap_cpu_comp_dead.patch
mm-zswap-tie-per-cpu-acomp_ctx-lifetime-to-the-pool.patch
mm-zswap-consistently-use-is_err_or_null-to-check-acomp_ctx-resources.patch

