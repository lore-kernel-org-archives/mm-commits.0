Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F35326938
	for <mm-commits@vger.kernel.org>; Tue, 17 Mar 2026 19:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773777074; cv=none; b=ZX+TUSwOIUpp/YCXa6YueQfHQBEl5kz6LsEiqKPMnM9yjhyiBiG1v4K7TKi5E5CoUty4nOn1fXj8PgdRJGOiMdLUytln5XIPipb+E4LuF0aktidXY3yq097vCLY/CgIxDfWGeOAUR45rWI5By5B05uZaC8oXrQ4p7qLsL3dk8Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773777074; c=relaxed/simple;
	bh=Ya/IXXctPlapsCBi9D4H1D72aBhsVKnnlUvAIIIVS5U=;
	h=Date:To:From:Subject:Message-Id; b=r+aUDxQfirlViq+g06ilQmjvQydqK5oxOY3aRFEGIG78EYOpUafbMQe0bNFAuY9lJWogPWc5FAi8PU8HWYzCNnsxt+2eF30YO/RfjHU/2PSiJW/cGmUktnihuNxzNbsqaVS/dZNr6PZjGEilwWz/dYJF5UpVB+d1UgRQHaxYaLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kyZw0NsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kyZw0NsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87A6C4CEF7;
	Tue, 17 Mar 2026 19:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773777074;
	bh=Ya/IXXctPlapsCBi9D4H1D72aBhsVKnnlUvAIIIVS5U=;
	h=Date:To:From:Subject:From;
	b=kyZw0NsPzS8OxXFYcjFhUjeO+Og0nfEkpBhn/rxxK7Vkl08febU0BLgsuUTqD4RiI
	 +7MpgTqYMIKLor7/GJmq/PmgI+VzSrWRjyxHidXDneC4twm/X3hyaAv/aPaE2FcacH
	 vF11T1xpZ83yjVgS+cyo67fGX1jcA5FQekDC1T8E=
Date: Tue, 17 Mar 2026 12:51:13 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,yosry.ahmed@linux.dev,senozhatsky@chromium.org,nphamcs@gmail.com,kanchana.p.sridhar@intel.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,kanchanapsridhar2026@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-zswap-consistently-use-is_err_or_null-to-check-acomp_ctx-resources.patch removed from -mm tree
Message-Id: <20260317195113.E87A6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
has been removed from the -mm tree.  Its filename was
     mm-zswap-consistently-use-is_err_or_null-to-check-acomp_ctx-resources.patch

This patch was dropped because it is obsolete

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

