Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DAF215F49;
	Tue,  1 Apr 2025 22:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545715; cv=none; b=Jzq48c4Mg5KCFtZwbc3l2y+45uQpdyrHEhB5S+2KJXw5BCZIE4yiu9HrNfsL+SdaRI2/vKSoEV0PHejV1WaRGmAlzzCy8Oi6+95ECBBrYULmJZRE/6umHTs6C6RxoFWf9JFxs2gF4SEVh++HXO0N7XVpkSHEm/GKQWsN38cEMio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545715; c=relaxed/simple;
	bh=HO0EKI1e3GgJZBngOx3l/+hdhP6K0ulOpnpmCq9PAyY=;
	h=Date:To:From:Subject:Message-Id; b=qH9iCVgAF20K/ctNU1QGsxTM6yB5685dIBdNlcvqfBuVcH1KikKQHHd6vQg9UIdslLb7k0WuGEfTkqpRcE63qzDpi5aBxQoBf8ycbHBQW6z9gy7Bxzu9GNm4cHH4MBCNePbAFzAkpPEqwZbyPY4dLkY7+B4z5UjN6ZzWiQRS9ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bfWkbOvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bfWkbOvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D39C4CEE4;
	Tue,  1 Apr 2025 22:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545714;
	bh=HO0EKI1e3GgJZBngOx3l/+hdhP6K0ulOpnpmCq9PAyY=;
	h=Date:To:From:Subject:From;
	b=bfWkbOvcCU2u2sDAeCLu517LqWyd/GJrn1n51chHQMqqZwZSk3gXRzM3yM11YHAiZ
	 COss6xLwgmgBhCq8JKzeqzt0rPzQ/E7pdW312n9CEVgILAl85YQ0nNTmkX9X4aGt5R
	 gDjSCswxlvgnF+e03tfOOApaNBMBmIKd1+l7UOHc=
Date: Tue, 01 Apr 2025 15:15:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nphamcs@gmail.com,lists@colorremedies.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,ebiggers@kernel.org,davem@davemloft.net,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-fix-crypto_free_acomp-deadlock-in-zswap_cpu_comp_dead.patch removed from -mm tree
Message-Id: <20250401221514.C4D39C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: fix crypto_free_acomp() deadlock in zswap_cpu_comp_dead()
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-crypto_free_acomp-deadlock-in-zswap_cpu_comp_dead.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: mm: zswap: fix crypto_free_acomp() deadlock in zswap_cpu_comp_dead()
Date: Wed, 26 Feb 2025 18:56:25 +0000

Currently, zswap_cpu_comp_dead() calls crypto_free_acomp() while holding
the per-CPU acomp_ctx mutex.  crypto_free_acomp() then holds scomp_lock
(through crypto_exit_scomp_ops_async()).

On the other hand, crypto_alloc_acomp_node() holds the scomp_lock (through
crypto_scomp_init_tfm()), and then allocates memory.  If the allocation
results in reclaim, we may attempt to hold the per-CPU acomp_ctx mutex.

The above dependencies can cause an ABBA deadlock.  For example in the
following scenario:

(1) Task A running on CPU #1:
    crypto_alloc_acomp_node()
      Holds scomp_lock
      Enters reclaim
      Reads per_cpu_ptr(pool->acomp_ctx, 1)

(2) Task A is descheduled

(3) CPU #1 goes offline
    zswap_cpu_comp_dead(CPU #1)
      Holds per_cpu_ptr(pool->acomp_ctx, 1))
      Calls crypto_free_acomp()
      Waits for scomp_lock

(4) Task A running on CPU #2:
      Waits for per_cpu_ptr(pool->acomp_ctx, 1) // Read on CPU #1
      DEADLOCK

Since there is no requirement to call crypto_free_acomp() with the per-CPU
acomp_ctx mutex held in zswap_cpu_comp_dead(), move it after the mutex is
unlocked.  Also move the acomp_request_free() and kfree() calls for
consistency and to avoid any potential sublte locking dependencies in the
future.

With this, only setting acomp_ctx fields to NULL occurs with the mutex
held.  This is similar to how zswap_cpu_comp_prepare() only initializes
acomp_ctx fields with the mutex held, after performing all allocations
before holding the mutex.

Opportunistically, move the NULL check on acomp_ctx so that it takes place
before the mutex dereference.

Link: https://lkml.kernel.org/r/20250226185625.2672936-1-yosry.ahmed@linux.dev
Fixes: 12dcb0ef5406 ("mm: zswap: properly synchronize freeing resources during CPU hotunplug")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reported-by: syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67bcea51.050a0220.bbfd1.0096.GAE@google.com/
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Tested-by: Nhat Pham <nphamcs@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Murphy <lists@colorremedies.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-crypto_free_acomp-deadlock-in-zswap_cpu_comp_dead
+++ a/mm/zswap.c
@@ -883,18 +883,32 @@ static int zswap_cpu_comp_dead(unsigned
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	struct acomp_req *req;
+	struct crypto_acomp *acomp;
+	u8 *buffer;
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
+	req = acomp_ctx->req;
+	acomp = acomp_ctx->acomp;
+	buffer = acomp_ctx->buffer;
+	acomp_ctx->req = NULL;
+	acomp_ctx->acomp = NULL;
+	acomp_ctx->buffer = NULL;
 	mutex_unlock(&acomp_ctx->mutex);
 
+	/*
+	 * Do the actual freeing after releasing the mutex to avoid subtle
+	 * locking dependencies causing deadlocks.
+	 */
+	if (!IS_ERR_OR_NULL(req))
+		acomp_request_free(req);
+	if (!IS_ERR_OR_NULL(acomp))
+		crypto_free_acomp(acomp);
+	kfree(buffer);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are


