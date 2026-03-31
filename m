Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6894C81
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774916268; cv=none; b=Fa3AREkIe0Lc1rqLlEvixkwCbIZfvjEpqcYjJGwFuVfsA9gbyWfx3M3glsyOeMCLC7mu9JX/bzNDmQMr9ER5OMZhEXyYQc4dhbIxYqH3K7yiVvgfsJURBq2xvz5YmxsNXs3Gi/jn2QQVOt8O+w5MSkZpoSjdHeWFb1lScu2KqJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774916268; c=relaxed/simple;
	bh=/SjXlsSBSOQr6Q9Q3ND2Zl/VmgMmx/SJFGWCxk0bBIM=;
	h=Date:To:From:Subject:Message-Id; b=ukBAxyr+DyTQrKqDxBFWJ6aVK+7gInS3C3f589QeUYFhYrAH73kG7kbgF9w2OThV2Ux3fl6avmPx939zkodGQS4fcPs9uq15+ikseK/pefSHLn18eHfI2HRB7ne2GQhdpfQ/c13MISky5cvHAXfk+pviWokDGa5alHnIad+SKEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FvY7nI5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FvY7nI5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8327C4CEF7;
	Tue, 31 Mar 2026 00:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774916267;
	bh=/SjXlsSBSOQr6Q9Q3ND2Zl/VmgMmx/SJFGWCxk0bBIM=;
	h=Date:To:From:Subject:From;
	b=FvY7nI5dbir0CmLN30nH7nyxSxre9rz0tFViIclkKOlZ39OguHVn/v5CrNHYz+d2i
	 sJ4O4UditAfPkUSi+fAAmlnwEWTpnI9lWGy2oFFBxhi7WU1t/RLp/eP7YUXK69/VYl
	 o89XG/LaL9fQz1suxQHq8wcgnp1bb16S3nXZ3+Xs=
Date: Mon, 30 Mar 2026 17:17:47 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,senozhatsky@chromium.org,nphamcs@gmail.com,kanchana.p.sridhar@intel.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,kanchanapsridhar2026@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-zswap-remove-redundant-checks-in-zswap_cpu_comp_dead.patch removed from -mm tree
Message-Id: <20260331001747.A8327C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: remove redundant checks in zswap_cpu_comp_dead()
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-redundant-checks-in-zswap_cpu_comp_dead.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Subject: mm: zswap: remove redundant checks in zswap_cpu_comp_dead()
Date: Mon, 16 Mar 2026 18:48:01 -0700

Patch series "zswap pool per-CPU acomp_ctx simplifications".

This patchset persists the zswap pool's per-CPU acomp_ctx resources to
last until the pool is destroyed. It then simplifies the per-CPU
acomp_ctx mutex locking in zswap_compress()/zswap_decompress().

Further, it consistently uses the same checks for valid
acomp_ctx->acomp/req in zswap procedures that allocate/deallocate
acomp_ctx members.

These are independent submissions of patches 23 and 24 from [1], to
facilitate merging. The Acks are preserved from [1].


This patch (of 2):

There are presently redundant checks on the per-CPU acomp_ctx and it's
"req" member in zswap_cpu_comp_dead(): redundant because they are
inconsistent with zswap_pool_create() handling of failure in allocating
the acomp_ctx, and with the expected NULL return value from the
acomp_request_alloc() API when it fails to allocate an acomp_req.

Fix these by converting them to be NULL checks.

Add comments in zswap_cpu_comp_prepare() clarifying the expected return
values of the crypto_alloc_acomp_node() and acomp_request_alloc() API.

Link: https://lkml.kernel.org/r/20260314051632.17931-1-kanchanapsridhar2026@gmail.com
Link: https://lkml.kernel.org/r/20260317014802.27591-2-kanchanapsridhar2026@gmail.com
Link: https://patchwork.kernel.org/project/linux-mm/list/?series=1046677 [1]
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-redundant-checks-in-zswap_cpu_comp_dead
+++ a/mm/zswap.c
@@ -747,6 +747,10 @@ static int zswap_cpu_comp_prepare(unsign
 		goto fail;
 	}
 
+	/*
+	 * In case of an error, crypto_alloc_acomp_node() returns an
+	 * error pointer, never NULL.
+	 */
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
 		pr_err("could not alloc crypto acomp %s : %pe\n",
@@ -755,6 +759,7 @@ static int zswap_cpu_comp_prepare(unsign
 		goto fail;
 	}
 
+	/* acomp_request_alloc() returns NULL in case of an error. */
 	req = acomp_request_alloc(acomp);
 	if (!req) {
 		pr_err("could not alloc crypto acomp_request %s\n",
@@ -800,7 +805,7 @@ static int zswap_cpu_comp_dead(unsigned
 	struct crypto_acomp *acomp;
 	u8 *buffer;
 
-	if (IS_ERR_OR_NULL(acomp_ctx))
+	if (!acomp_ctx)
 		return 0;
 
 	mutex_lock(&acomp_ctx->mutex);
@@ -815,8 +820,11 @@ static int zswap_cpu_comp_dead(unsigned
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

mm-zswap-tie-per-cpu-acomp_ctx-lifetime-to-the-pool.patch

