Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E5EEAFA;
	Wed, 26 Feb 2025 02:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740537740; cv=none; b=M+2CU00PP1pSbhotlAC4VbM2L7mAa5e0AGonYnTGHHFnE+RwquwSA7/BVgiaUEPDXcatDf2XENuO07m1PP3Hum4t2wM41MEswX3FrzvnxvWIsR/Sqg8VYQybf65q7SGOBgn77ROApizf2R0nsWVJTq7klOaWDihPyG18bEpFlHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740537740; c=relaxed/simple;
	bh=InW+IK7VHo43o9VPaLYHULMbSes36obf0v5JILCw6w4=;
	h=Date:To:From:Subject:Message-Id; b=OzRIv6q1rDkEa+qJmrbu3+VOwLJQ1xXCXrcskcnSMScH366XDmfh6EkSi93KDvbzJfo1uQ9ySMAhHFoquNRMiBine06Z4CI6JY5r2DoK1m8fc8pqAq5uVBkLG2c6XMfUQj55jYTgzLnMvJjOetAGcgmvnrnI2XbhJRM2uk/gNr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NA7iMfZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NA7iMfZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC05C4CEDD;
	Wed, 26 Feb 2025 02:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740537740;
	bh=InW+IK7VHo43o9VPaLYHULMbSes36obf0v5JILCw6w4=;
	h=Date:To:From:Subject:From;
	b=NA7iMfZxbKv006PVmIdnp9GBqZwEzatlDkr1AnDcEFhuccnS/hRHxPIhTZTzmScnN
	 LLzOkvazk/l/VGjh2XaLcExzFQLjnW2tZ0T8BC+iCosCTgjBrPFIrsPg+Thb735wMz
	 MgO4PXTigyjYVKf73pKl0nA13/ufUKw23M5Mtn2M=
Date: Tue, 25 Feb 2025 18:42:19 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,stable@vger.kernel.org,davem@davemloft.net,herbert@gondor.apana.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-crypto_free_acomp-deadlock-in-zswap_cpu_comp_dead.patch added to mm-hotfixes-unstable branch
Message-Id: <20250226024220.2FC05C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: fix crypto_free_acomp deadlock in zswap_cpu_comp_dead
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-fix-crypto_free_acomp-deadlock-in-zswap_cpu_comp_dead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-crypto_free_acomp-deadlock-in-zswap_cpu_comp_dead.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: mm: zswap: fix crypto_free_acomp deadlock in zswap_cpu_comp_dead
Date: Tue, 25 Feb 2025 16:53:58 +0800

Call crypto_free_acomp outside of the mutex in zswap_cpu_comp_dead() as
otherwise this could deadlock as the allocation path may lead back into
zswap while holding the same lock.  Zap the pointers to acomp and buffer
after freeing.

Also move the NULL check on acomp_ctx so that it takes place before
the mutex dereference.

Link: https://lkml.kernel.org/r/Z72FJnbA39zWh4zS@gondor.apana.org.au
Fixes: 12dcb0ef5406 ("mm: zswap: properly synchronize freeing resources during CPU hotunplug")
Reported-by: syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-crypto_free_acomp-deadlock-in-zswap_cpu_comp_dead
+++ a/mm/zswap.c
@@ -881,18 +881,23 @@ static int zswap_cpu_comp_dead(unsigned
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	struct crypto_acomp *acomp = NULL;
+
+	if (IS_ERR_OR_NULL(acomp_ctx))
+		return 0;
 
 	mutex_lock(&acomp_ctx->mutex);
-	if (!IS_ERR_OR_NULL(acomp_ctx)) {
-		if (!IS_ERR_OR_NULL(acomp_ctx->req))
-			acomp_request_free(acomp_ctx->req);
-		acomp_ctx->req = NULL;
-		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
-			crypto_free_acomp(acomp_ctx->acomp);
-		kfree(acomp_ctx->buffer);
-	}
+	if (!IS_ERR_OR_NULL(acomp_ctx->req))
+		acomp_request_free(acomp_ctx->req);
+	acomp_ctx->req = NULL;
+	acomp = acomp_ctx->acomp;
+	acomp_ctx->acomp = NULL;
+	kfree(acomp_ctx->buffer);
+	acomp_ctx->buffer = NULL;
 	mutex_unlock(&acomp_ctx->mutex);
 
+	crypto_free_acomp(acomp);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

mm-zswap-fix-crypto_free_acomp-deadlock-in-zswap_cpu_comp_dead.patch

