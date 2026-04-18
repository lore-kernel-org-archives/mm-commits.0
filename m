Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB3536E460
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498848; cv=none; b=IEclSGb5Nr8ED38V5OWlMqXcjySU6ps9Zpopc5pEVG2XK84PjO3H8w2zep2mXSYzvAWU6p+ibn68h8tix/Z8kmOpNgiTb/Par3y0LH2H032rJ3zDrqb0shpfIu4nMhcL5/yGGTwqYRwipCA0zI3LO3o/s3L/bYg5G4fc0ZTn384=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498848; c=relaxed/simple;
	bh=Cxrd0fX4G4zuZCrZvnnHwUoUAyuvnqxmUAFhluTDSm4=;
	h=Date:To:From:Subject:Message-Id; b=gqferjmE8ge/yLvEOPHIBQCiP7eBb+PZgshzpgHTVMGHyVkMQovHcKLqbvCkK4gFNvNP3Bbh7gdwEAqR09eYBF7IKbb5fd8/NWWjOQXi93uwVeyywFm+yw3S4KWs5SlnZMjuJduOjmLXKTUd3g0Idz8UeVdVLrM2d5eWZ6qEH94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qdtwKyr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qdtwKyr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A51FC19424;
	Sat, 18 Apr 2026 07:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498848;
	bh=Cxrd0fX4G4zuZCrZvnnHwUoUAyuvnqxmUAFhluTDSm4=;
	h=Date:To:From:Subject:From;
	b=qdtwKyr1hGDFfJnNmcOVZ0IS8cpquh632h31NHx5iFT3z4eB3GXYhN+0+nbcbulLP
	 AImBJtzDNMSvSTPAOxU9/vw9TnBtrYPLdWQsDeugPjGH2feLTLBgsxpvwJKtXOwH03
	 rHkYMCwmNzINf365+9IJvWKGvtdQ5+XzzKxP79gs=
Date: Sat, 18 Apr 2026 00:54:02 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,kanchanapsridhar2026@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-remove-redundant-checks-in-zswap_cpu_comp_dead.patch removed from -mm tree
Message-Id: <20260418075407.3A51FC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: remove redundant checks in zswap_cpu_comp_dead()
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-redundant-checks-in-zswap_cpu_comp_dead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Subject: mm: zswap: remove redundant checks in zswap_cpu_comp_dead()
Date: Tue, 31 Mar 2026 11:33:50 -0700

Patch series "zswap pool per-CPU acomp_ctx simplifications", v3.

This patchset first removes redundant checks on the acomp_ctx and its
"req" member in zswap_cpu_comp_dead().

Next, it persists the zswap pool's per-CPU acomp_ctx resources to last
until the pool is destroyed.  It then simplifies the per-CPU acomp_ctx
mutex locking in zswap_compress()/zswap_decompress().

Code comments added after allocation and before checking to deallocate the
per-CPU acomp_ctx's members, based on expected crypto API return values
and zswap changes this patchset makes.

Patch 2 is an independent submission of patch 23 from [1], to
facilitate merging.


This patch (of 2):

There are presently redundant checks on the per-CPU acomp_ctx and it's
"req" member in zswap_cpu_comp_dead(): redundant because they are
inconsistent with zswap_pool_create() handling of failure in allocating
the acomp_ctx, and with the expected NULL return value from the
acomp_request_alloc() API when it fails to allocate an acomp_req.

Fix these by converting to them to be NULL checks.

Add comments in zswap_cpu_comp_prepare() clarifying the expected return
values of the crypto_alloc_acomp_node() and acomp_request_alloc() API.

Link: https://lore.kernel.org/20260331183351.29844-2-kanchanapsridhar2026@gmail.com
Link: https://patchwork.kernel.org/project/linux-mm/list/?series=1046677
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-redundant-checks-in-zswap_cpu_comp_dead
+++ a/mm/zswap.c
@@ -749,6 +749,10 @@ static int zswap_cpu_comp_prepare(unsign
 		goto fail;
 	}
 
+	/*
+	 * In case of an error, crypto_alloc_acomp_node() returns an
+	 * error pointer, never NULL.
+	 */
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
 		pr_err("could not alloc crypto acomp %s : %pe\n",
@@ -757,6 +761,7 @@ static int zswap_cpu_comp_prepare(unsign
 		goto fail;
 	}
 
+	/* acomp_request_alloc() returns NULL in case of an error. */
 	req = acomp_request_alloc(acomp);
 	if (!req) {
 		pr_err("could not alloc crypto acomp_request %s\n",
@@ -802,7 +807,7 @@ static int zswap_cpu_comp_dead(unsigned
 	struct crypto_acomp *acomp;
 	u8 *buffer;
 
-	if (IS_ERR_OR_NULL(acomp_ctx))
+	if (!acomp_ctx)
 		return 0;
 
 	mutex_lock(&acomp_ctx->mutex);
@@ -817,8 +822,11 @@ static int zswap_cpu_comp_dead(unsigned
 	/*
 	 * Do the actual freeing after releasing the mutex to avoid subtle
 	 * locking dependencies causing deadlocks.
+	 *
+	 * If there was an error in allocating @acomp_ctx->req, it
+	 * would be set to NULL.
 	 */
-	if (!IS_ERR_OR_NULL(req))
+	if (req)
 		acomp_request_free(req);
 	if (!IS_ERR_OR_NULL(acomp))
 		crypto_free_acomp(acomp);
_

Patches currently in -mm which might be from kanchanapsridhar2026@gmail.com are


